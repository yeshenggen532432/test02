if (typeof jQuery === 'undefined') {
    throw new Error('uglcw.core requires jQuery')
}

(function ($, window) {
    'use strict';
    Array.prototype.findIndex = Array.prototype.findIndex || function (callback) {
        if (this === null) {
            throw new TypeError('Array.prototype.findIndex called on null or undefined');
        } else if (typeof callback !== 'function') {
            throw new TypeError('callback must be a function');
        }
        var list = Object(this);
        // Makes sures is always has an positive integer as length.
        var length = list.length >>> 0;
        var thisArg = arguments[1];
        for (var i = 0; i < length; i++) {
            if (callback.call(thisArg, list[i], i, list)) {
                return i;
            }
        }
        return -1;
    };
    var uglcw = function () {
        return {};
    }
    uglcw.fn = uglcw.prototype = {};

    uglcw.extend = uglcw.fn.extend = function () {
        var options, name, src, copy, copyIsArray, clone,
            target = arguments[0] || {},
            i = 1,
            length = arguments.length,
            deep = false;

        // Handle a deep copy situation
        if (typeof target === "boolean") {
            deep = target;

            // Skip the boolean and the target
            target = arguments[i] || {};
            i++;
        }

        // Handle case when target is a string or something (possible in deep copy)
        if (typeof target !== "object" && !$.isFunction(target)) {
            target = {};
        }

        // Extend itself if only one argument is passed
        if (i === length) {
            target = this;
            i--;
        }

        for (; i < length; i++) {

            // Only deal with non-null/undefined values
            if ((options = arguments[i]) != null) {

                // Extend the base object
                for (name in options) {
                    src = target[name];
                    copy = options[name];

                    // Prevent never-ending loop
                    if (target === copy) {
                        continue;
                    }

                    // Recurse if we're merging plain objects or arrays
                    if (deep && copy && ($.isPlainObject(copy) ||
                        (copyIsArray = $.isArray(copy)))) {

                        if (copyIsArray) {
                            copyIsArray = false;
                            clone = src && $.isArray(src) ? src : [];

                        } else {
                            clone = src && $.isPlainObject(src) ? src : {};
                        }

                        // Never move original objects, clone them
                        target[name] = uglcw.extend(deep, clone, copy);

                        // Don't bring in undefined values
                    } else if (copy !== undefined) {
                        target[name] = copy;
                    }
                }
            }
        }

        // Return the modified object
        return target;
    };

    $.each(['show', 'hide'], function (i, e) {
        var el = $.fn[e];
        $.fn[e] = function () {
            this.trigger(e);
            return el.apply(this, arguments);
        }
    });

    $.fn.hasScrollBar = function (direction) {
        if (direction == 'vertical') {
            return this.get(0).scrollHeight > this.innerHeight();
        } else if (direction == 'horizontal') {
            return this.get(0).scrollWidth > this.innerWidth();
        }
        return false;

    }

    $.fn.hasHScrollBar = function () {
        return this.get(0).scrollWidth > this.innerWidth();
    }


    $.fn.hasVScrollBar = function () {
        return this.get(0).scrollHeight > this.innerHeight();
    }

    window.uglcw = uglcw;
})(jQuery, window);
(function ($, window, uglcw) {
    'use strict';
    var util = {};

    $.fn.getCursorPosition = function () {
        var input = this.get(0);
        if (!input) return; // No (input) element found
        if ('selectionStart' in input) {
            // Standard-compliant browsers
            return input.selectionStart;
        } else if (document.selection) {
            // IE
            input.focus();
            var sel = document.selection.createRange();
            var selLen = document.selection.createRange().text.length;
            sel.moveStart('character', -input.value.length);
            return sel.text.length - selLen;
        }
    };

    util.isNull = function (value) {
        return value === undefined || value === null || value === "";
    }

    /** @function toInt
     * @description 将值转换为整数
     * @param {object} value - 值
     * @returns {int} 整数或0
     */
    util.toInt = function (value) {
        if (isNaN(value)) {
            return 0;
        }

        return this.isNull(value) ? 0 : value * 1;
    }

    /** @function toDecimal
     * @description 将值转换为小数
     * @param {object} value - 值
     * @returns {decimal} 小数或0
     */
    util.toDecimal = function (value) {
        if (isNaN(value)) {
            return 0;
        }


        return this.isNull(value) ? 0 : value * 1.0;
    }

    /** @function toBoolean
     * @description 将值转换为bool
     * @param {object} value - 值
     * @returns {bool} true/false
     */
    util.toBoolean = function (value) {
        if (value == undefined) {
            return false;
        }
        if (util.toInt(value) > 0 || value.toString().toLowerCase() == "true") {
            return true;
        }


        return false;
    }

    util.toDate = function (value) {
        return new Date(Date.parse(value.replace(/-/g, "/")));
    }
    /**
     * @function formatDate
     * @description 格式化时间
     * @param {Date} value-date对象
     * @param {String} fmt - 格式化字符串
     * @returns {string} 时间字符串
     */
    util.formatDate = function (value, fmt) {
        var o = {
            "M+": value.getMonth() + 1, //月份
            "d+": value.getDate(), //日
            "H+": value.getHours(), //小时
            "m+": value.getMinutes(), //分
            "s+": value.getSeconds(), //秒
            "q+": Math.floor((value.getMonth() + 3) / 3), //季度
            "S": value.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (value.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    };

    util.queryString = function (url) {
        url = url || window.location.href;
        var vars = {}, hash;
        var hashes = url.slice(url.indexOf('?') + 1).split('&');
        for (var i = 0; i < hashes.length; i++) {
            hash = hashes[i].split('=');
            vars[hash[0]] = hash[1];
        }
        return vars;
    };

    util.arrayToTree = function (data, o) {
        var opts = uglcw.extend({
            root: '0', //根节点ID值
            parent: 'pid', //父节点ID字段
            id: 'id', //id
            children: 'children'
        }, o);
        var roots = [], map = {};
        $(data).each(function (idx, node) {
            map[node[opts.id]] = node;
            if (node[opts.parent] == opts.root) {
                node.children = [];
                roots.push(node);
            }
        });

        $(data).each(function (idx, node) {
            var pid = node[opts.parent];
            if (map[pid]) {
                if (!map[pid][opts.children]) {
                    map[pid][opts.children] = []
                }
                map[pid][opts.children].push(node);
            }
        })
        return roots;
    };

    util.parseObject = function (str) {
        var opts = {};
        if (str) {
            if (str.charAt(0) !== '{') {
                str = '{' + str + '}'
            }
            try {
                opts = eval("(" + str + ")");
            } catch (e) {
                console.error('配置解析失败', str, e);
            }
        }
        return opts;
    }

    util.getScrollBarWidth = function (refresh) {
        if (!isNaN(util._scrollbar) && !refresh) {
            return util._scrollbar;
        } else {
            var div = document.createElement('div'), result;
            div.style.cssText = 'overflow:scroll;overflow-x:hidden;zoom:1;clear:both;display:block';
            div.innerHTML = '&nbsp;';
            document.body.appendChild(div);
            util._scrollbar = result = div.offsetWidth - div.scrollWidth;
            document.body.removeChild(div);
            return result;
        }
    };

    /**
     * 防抖操作
     * @param fn
     * @param wait
     * @returns {debounced}
     */
    util.debounce = function (fn, wait) {
        var callback = fn;
        var timerId = null;

        function debounced() {
            var context = this;
            var args = arguments;
            clearTimeout(timerId);
            timerId = setTimeout(function () {
                callback.apply(context, args);
            }, wait)
        }

        return debounced;
    };

    util.throttle = function (fn, wait) {
        var callback = fn;
        var timerId = null;
        var firstInvoke = true;

        function throttled() {
            var context = this;
            var args = arguments;
            if (firstInvoke) {
                callback.apply(context, args);
                firstInvoke = false;
                return;
            }
            if (timerId) {
                return;
            }
            timerId = setTimeout(function () {
                clearTimeout(timerId);
                timerId = null;
                callback.apply(context, args);
            }, wait);

        }
        return throttled;
    }

    uglcw.util = util;
})(jQuery, window, uglcw);

(function ($, window, uglcw) {
    'use strict';

    if (window == window.top) {
        //当前为top
        var _topics = {
            subscribe: []
        };
        var topics = {
            on: function (event, fn, win) {
                if (_topics[event]) {
                    _topics[event].push({
                        win: win,
                        handler: fn
                    });
                } else {
                    _topics[event] = [{
                        win: win,
                        handler: fn
                    }];
                }
            },
            off: function (event, win) {
                var handlers = _topics[event];
                if (handlers && handlers.length > 0) {
                    var index = handlers.findIndex(function (idx, item) {
                        return item.win = win;
                    })
                    if (index != -1) {
                        handlers.splice(index, 1)
                    }
                }
            },
            emit: function (event, data, win) {
                if (_topics[event]) {
                    $(_topics[event]).each(function (idx, item) {
                        if (item.win != win) {
                            item.handler.call(this, data)
                        }
                    })
                }
            },
            offline: function (win) {
                $.map(_topics, function (handlers, event) {
                    var index = handlers.findIndex(function (item) {
                        return item.win == win
                    })
                    if (index != -1) {
                        handlers.splice(index, 1);
                    }
                })
            }
        }
        console.trace('root io is ready');
        uglcw.topics = topics
        uglcw._topics = _topics

    } else {
        $(window).unload(function () {
            window.top.uglcw.topics.offline(window)
        });
    }

    var io = {
        emit: function (event, data, win, target) {
            window.top.uglcw.topics.emit(event, data, win || window, target);
        },
        on: function (event, handler) {
            window.top.uglcw.topics.on(event, handler, window);
        },
        off: function (event) {
            window.top.uglcw.topics.off(event, window);
        },
        broadcast: function (event, data) {
            window.top.uglcw.topics.broadcast(event, data, window);
        }
    };

    uglcw.io = io;

})(jQuery, window, uglcw);