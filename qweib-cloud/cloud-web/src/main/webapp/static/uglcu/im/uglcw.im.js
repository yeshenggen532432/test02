var TYPE_WEB = 1, TYPE_WIFI = 1;
var MSG_TXT = "text", MSG_VOICE = "uglcw:vc", MSG_FILE = "uglcw:file", MSG_IMG = "uglcw:img", MSG_RICH = "uglcw:rich", MSG_NTF = "uglcw:infoNtf";
var IM = function () {
}
var emptyFn = function () {
}
var conversations = [];
var socketio;
var timeout_handles = {};
/**
 * 初始化IM
 * @param options
 */

var MSG_TYPES = [MSG_TXT,MSG_VOICE,MSG_FILE,MSG_IMG,MSG_RICH,MSG_NTF]

IM.prototype.init = function (options) {
  options = options || {};
  var prefix = options.https ? 'https' : 'http';
  this.ip = options.ip || '192.168.1.145';
  this.port = options.port || '33233';
  this.url = options.url || prefix + '://' + this.ip + ':' + this.port;
  this.token = options.token || emptyFn;
  this.onConnect = options.onConnect || emptyFn;
  this.onClosed = options.onClosed || emptyFn;
  this.onMessage = options.onMessage || emptyFn;
  this.onTextMessage = options.onTextMessage || emptyFn;
  this.onImgMessage = options.onImgMessage || emptyFn;
  this.onAudioMessage = options.onAudioMessage || emptyFn;
  this.onVoiceMessage = options.onVoiceMessage || emptyFn;
  this.onFileMessage = options.onFileMessage || emptyFn;
  this.onRichMessage = options.onRichMessage || emptyFn;
  this.onNtfMessage = options.onNtfMessage || emptyFn;
  this.onError = options.onError || emptyFn;
  this.customHandlers = options.customHandlers || [];
  this.onAck = options.onAck || emptyFn;
  this.debug = options.debug || false;
  this.onPushMessage = options.onPushMessage || emptyFn;
  this.onPresence = options.onPresence || emptyFn;
  this.autoStart = options.autoStart !== undefined ? options.autoStart : true;
  this.type = TYPE_WEB;
  if (this.autoStart) {
    this.start();
  }
}

IM.prototype.addHandlers = function (options) {
  for (var prop in options) {
    this[prop] = options[prop] || emptyFn;
  }
}

IM.prototype.addCustomHandler = function (customHandlers) {
  for (var i = 0; i < customHandlers.length; i++) {
    this.customHandlers.push(customHandlers[i]);
  }
}

/**
 * 启动IM连接
 */
IM.prototype.start = function () {
  var _self = this;
  //create connection and auto reconnect.
  socketio = io.connect(this.url, {
    transports: ['websocket']
  });

  //do auth on connected.
  socketio.on('connect', function () {
    _self.log('im server connected! →_→ authenticating... ');
    _self.auth(_self.token());
  });

  socketio.on('disconnect', function () {
    _self.log('im server disconnected! :(');
    _self.onClosed();
  });

  socketio.on('message', function (message) {
    message.type = '0';
    if (message.from != _self.id) {
      socketio.emit('ack', {
        packetId: message.packetId,
        type: 0,
        clientType: _self.type,
        persistent: message.persistent
      });
    }
    _self.handleMessage(message);
  });

  socketio.on('groupchat', function (message) {
    message.chatType = 'group';
    if (message.from != _self.id) {
      socketio.emit('ack', {
        packetId: message.packetId,
        type: 'groupChat',
        clientType: _self.type,
        persistent: message.persistent
      });
    }
    _self.handleMessage(message);
  });

  socketio.on('auth', function (response) {
    if (response.code === 200) {
      _self.id = response.data.id;
      _self.log('[' + _self.id + '] authenticate succeed :)');
      _self.onConnect(response);
    } else {
      _self.log('authenticate failed :(' + JSON.stringify(response));
      _self.onError(response.data);
    }
  });

  socketio.on('ack', function (ack) {
    _self.log('ack:' + ack.packetId);
    _self.onAck(ack);
    var timer = timeout_handles[ack.packetId];
    if (timer) {
      clearTimeout(timer.timeout);
      timer.callback.success(ack.packetId);
      delete timeout_handles[ack.packetId];
    }
  });

  socketio.on('push', function (message) {
    socketio.emit('ack', {packetId: message.packetId, type: 'push'});
    _self.log('recieve push message:' + JSON.stringify(message));
    _self.onPushMessage(message);
  });

  //
  socketio.on('presence', function (message) {
    _self.log(JSON.stringify(message));
    _self.onPresence(message);
  });

};

/**
 * 关闭后重连
 */
IM.prototype.reconnect = function () {
  if (socketio) {
    socketio.connect();
  } else {
    this.start();
  }
}

/**
 * 关闭连接
 */
IM.prototype.close = function () {
  if (socketio) {
    this.logout();
    socketio.disconnect();
  }
};

IM.prototype.auth = function (token) {
  var _self = this;
  token = token || {};
  token.packetId = _self.genUUID();
  socketio.emit('auth', token);
}

IM.prototype.logout = function () {
  var _self = this;
  socketio.emit('logout', {packetId: _self.genUUID});
}

/**
 * 消息处理
 * @param chatType
 * @param message
 */
IM.prototype.handleMessage = function (message) {
  this.log(message);
  this.onMessage(message);
  switch (message.msgType) {

    case MSG_TXT :
      this.onTextMessage(message);
      break;
    case MSG_IMG :
      this.onImgMessage(message);
      break;
    case MSG_FILE :
      this.onFileMessage(message);
      break;
    case MSG_VOICE :
      this.onVoiceMessage(message);
      break;
    case MSG_RICH :
      this.onRichMessage(message);
      break;
    case MSG_NTF :
      this.onNtfMessage(message);
      break;
    default :
      //自定义消息处理
      if (this.customHandlers) {
        for (var i in this.customHandlers) {
          if (this.customHandlers[i].type == message.type) {
            this.customHandlers[i].handler(message);
            break;
          }
        }
      }
  }
};

/**
 * 发送聊天消息
 *
 * @param message 消息实体
 * @param chatType 消息类型 chat | groupchat
 */
IM.prototype.sendMessage = function (message, chatType, callback) {
  if (!message.packetId) {
    message.packetId = this.genUUID();
  }
  message.type = chatType || 0;
  if (online()) {
    socketio.emit('message', message);
    if (callback) {
      promise(message.packetId, callback);
    }
  } else if (callback) {
    callback.offline(message.packetId);
  }

};

IM.prototype.genUUID = function () {
  return UUIDjs.create(4).toString().replace(new RegExp('-', 'gm'), '');
};

/**
 * 发送文本消息
 *
 * @param options
 */
IM.prototype.sendTextMessage = function (options, callback) {
  var message = {
    packetId: options.packetId || this.genUUID(),
    to: options.to,
    dataType: MSG_TXT,
    data: {
      content: options.content
    },
  };

  if (options.extra) {
    message.extra = options.extra;
  }
  this.sendMessage(message, options.chatType, callback);
}

/**
 * 发送图片
 *
 * @param options
 */
IM.prototype.sendImgMessage = function (options, callback) {
  var message = {
    packetId: options.packetId || this.genUUID(),
    to: options.to,
    type: MSG_IMG,
    data: {
      url: options.img,
      width: options.width,
      height: options.height
    }
  };

  if (options.extra) {
    message.extra = options.extra;
  }
  this.sendMessage(message, options.chatType, callback);
}

/**
 * 发送文件
 *
 */
IM.prototype.sendFileMessage = function (options, callback) {
  var message = {
    packetId: options.packetId || this.genUUID(),
    to: options.to,
    type: MSG_FILE,
    data: {
      url: options.url,
      name: options.name,
      length: options.length
    }
  };

  if (options.extra) {
    message.extra = options.extra;
  }
  this.sendMessage(message, options.chatType, callback);
}

/**
 * 发送语音
 *
 */
IM.prototype.sendVoiceMessage = function (options, callback) {
  var message = {
    packetId: options.packetId || this.genUUID(),
    to: options.to,
    type: MSG_VOICE,
    data: {
      url: options.url,
      duration: options.duration
    }
  };

  if (options.extra) {
    message.extra = options.extra;
  }
  this.sendMessage(message, options.chatType, callback);
}

/**
 * 发送语音
 *
 */
IM.prototype.sendRichContentMessage = function (options, callback) {
  var message = {
    packetId: options.packetId || this.genUUID(),
    to: options.to,
    type: MSG_RICH,
    data: {
      title: options.title,
      content: options.content,
      width: options.width,
      height: options.height,
      url: options.url,
      extra: options.link
    }
  };

  if (options.extra) {
    message.extra = options.extra;
  }
  this.sendMessage(message, options.chatType, callback);
}

IM.prototype.sendNotification = function (options, callback) {
  var message = {
    packetId: options.packetId || this.genUUID(),
    to: options.to,
    type: MSG_NTF,
    data: {
      content: options.content
    }
  };

  if (options.extra) {
    message.extra = options.extra;
  }
  this.sendMessage(message, options.chatType, callback);
}


IM.prototype.getThumbnail = function (rawUrl, width, height) {
  var w = width || 100;
  var h = height || 100;
  var index = rawUrl.lastIndexOf('.');
  var pre = rawUrl.substring(0, index);
  var ext = rawUrl.substring(index);
  var size = '-' + w + 'x' + h;
  return pre + size + ext;
}


IM.prototype.log = function (o) {
  if (this.debug) {
    console.debug(o);
  }
}

//detect if network is ok
function online() {
  return navigator.onLine;
}

function promise(packetId, callback, timeout) {
  timeout = timeout || 3000;
  var timerId = setTimeout(function () {
    callback.timeout(packetId);
    delete timeout_handles[packetId]
  }, timeout);
  timeout_handles[packetId] = {callback: callback, timeout: timerId};
}



