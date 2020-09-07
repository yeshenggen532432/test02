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

    var calculator = function() {

        /*
         * 判断obj是否为一个整数
         */
        function isInteger(obj) {
            return Math.floor(obj) === obj
        }

        /*
         * 将一个浮点数转成整数，返回整数和倍数。如 3.14 >> 314，倍数是 100
         * @param floatNum {number} 小数
         * @return {object}
         *   {times:100, num: 314}
         */
        function toInteger(floatNum) {
            var ret = {times: 1, num: 0}
            if (isInteger(floatNum)) {
                ret.num = floatNum
                return ret
            }
            var strfi  = floatNum + ''
            var dotPos = strfi.indexOf('.')
            var len    = strfi.substr(dotPos+1).length
            var times  = Math.pow(10, len)
            var intNum = Number(floatNum.toString().replace('.',''))
            ret.times  = times
            ret.num    = intNum
            return ret
        }

        /*
         * 核心方法，实现加减乘除运算，确保不丢失精度
         * 思路：把小数放大为整数（乘），进行算术运算，再缩小为小数（除）
         *
         * @param a {number} 运算数1
         * @param b {number} 运算数2
         * @param digits {number} 精度，保留的小数点数，比如 2, 即保留为两位小数
         * @param op {string} 运算类型，有加减乘除（add/subtract/multiply/divide）
         *
         */
        function operation(a, b, digits, op) {
            var o1 = toInteger(a)
            var o2 = toInteger(b)
            var n1 = o1.num
            var n2 = o2.num
            var t1 = o1.times
            var t2 = o2.times
            var max = t1 > t2 ? t1 : t2
            var result = null
            switch (op) {
                case 'add':
                    if (t1 === t2) { // 两个小数位数相同
                        result = n1 + n2
                    } else if (t1 > t2) { // o1 小数位 大于 o2
                        result = n1 + n2 * (t1 / t2)
                    } else { // o1 小数位 小于 o2
                        result = n1 * (t2 / t1) + n2
                    }
                    return result / max
                case 'subtract':
                    if (t1 === t2) {
                        result = n1 - n2
                    } else if (t1 > t2) {
                        result = n1 - n2 * (t1 / t2)
                    } else {
                        result = n1 * (t2 / t1) - n2
                    }
                    return result / max
                case 'multiply':
                    result = (n1 * n2) / (t1 * t2)
                    return result
                case 'divide':
                    result = (n1 / n2) * (t2 / t1)
                    return result
            }
        }

        // 加减乘除的四个接口
        function add(a, b, digits) {
            return operation(a, b, digits, 'add')
        }
        function subtract(a, b, digits) {
            return operation(a, b, digits, 'subtract')
        }
        function multiply(a, b, digits) {
            return operation(a, b, digits, 'multiply')
        }
        function divide(a, b, digits) {
            return operation(a, b, digits, 'divide')
        }

        // exports
        return {
            add: add,
            subtract: subtract,
            multiply: multiply,
            divide: divide
        }
    }();

    util.add = calculator.add;
    util.subtract = calculator.subtract;
    util.multiply = calculator.multiply;
    util.divide = calculator.divide;

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
(function ($, window, uglcw) {
    'use strict';
    var ui = {};
    var util = uglcw.util;
    var attrPrefix = 'uglcw-';
    ui.attrPrefix = attrPrefix;

    ui.attr = function (context, attr, value) {
        if (value === undefined) {
            return $(context).attr(attrPrefix + attr);
        } else {
            $(context).attr(attrPrefix + attr, value);
        }
    };

    ui.removeAttr = function (context, attr) {
        $(context).removeAttr(attrPrefix + attr);
    };

    ui.hasAttr = function (context, attr) {
        var attr = ui.attr(context, attr);
        return typeof attr !== typeof undefined && attr !== false
    }

    ui.navigate = function (url, data, newTab) {
        if (data) {
            url += "?";
            for (var key in data) {
                if ($.isFunction(data[key])) {
                    continue;
                }
                url = url + key + '=' + data[key] + '&';
            }
        }
        if (newTab) {
            window.open(url);
        } else {
            document.location.href = url;
        }
    }

    ui.openTab = function (title, url) {
        var params = uglcw.util.queryString();
        var targetParams = uglcw.util.queryString(url);
        var sticky = params._sticky || _STICKY;
        if (!targetParams._sticky && sticky) {
            if (url.indexOf('?') === -1) {
                url += '?_sticky=' + sticky;
            } else {
                url += '&_sticky=' + sticky;
            }
        }
        if (window.top.openTab) {
            window.top.openTab(title, url);
        } else {
            window.open(url, '_blank');
        }
    };

    ui.replaceCurrentTab = function (title, url) {
        if (window.top.replaceCurrentTab) {
            window.top.replaceCurrentTab(title, url);
        } else {
            window.location.href = url;
        }
    };

    ui.closeCurrentTab = function () {
        if (window.top.closeCurrentTab) {
            window.top.closeCurrentTab()
        }
    };

    ui.closeOtherTab = function () {
        if (window.top.closeOtherTab) {
            window.top.closeOtherTab()
        }
    };

    ui.reload = function () {
        document.location.href = document.location.href;
    };

    ui.init = function (context) {
        var pageInit = context === undefined;
        context = context || 'body';
        var lazy = [];
        $(context).find('[' + attrPrefix + 'role]').each(function (i, ele) {
            var options = ui.attr(ele, 'options');
            ui.removeAttr(ele, 'options');
            var role = ui.attr(ele, 'role');
            var skip = ui.hasAttr(ele, 'skip');
            options = util.parseObject(options);
            var widget = ui.get(ele);
            if (widget && !widget.k() && !skip) {
                if (widget.lazy && widget.lazy()) {
                    lazy.push({widget: widget, options: options});
                } else {
                    widget.init(options);
                }
            }
        });
        $(lazy).each(function (idx, item) {
            item.widget.init(item.options)
        });
        if(pageInit){
            uglcw.layout.init();
        }
    };

    /**
     * 批量取值或赋值
     * <pre>
     *    uglcw.ui.bind('#form', {username: '123456', 'mobile': '18888888888'})
     *    var data = uglcw.ui.bind('#form')
     * </pre>
     * @param context  控件所在容器
     * @param data data存在时,作为绑定的数据源
     * @return result  data不存在时返回容器内控件的键值
     */
    ui.bind = function (context, data) {
        context = context || 'body';
        if (data === undefined) {
            var result = {};
            // <input uglcw-role="textbox" uglcw-model="username">
            $(context).find('[' + attrPrefix + 'role][' + attrPrefix + 'model]').each(function (i, ele) {
                var widget = ui.get(ele);
                var model = ui.attr(ele, 'model');
                if (widget.bind) {
                    var bindResult = widget.bind(model);
                    if (bindResult) {
                        $.extend(result, bindResult);
                    }
                } else {
                    result[model] = widget.value();
                }
            });
            return result;
        } else {
            $(context).find('[' + attrPrefix + 'role][' + attrPrefix + 'model]').each(function (i, el) {
                var widget = ui.get(el);
                var model = ui.attr(el, 'model');
                if (widget.bind) {
                    widget.bind(model, data);
                } else {
                    var val = data[model];
                    if (val !== undefined) {
                        widget.value(val);
                    }
                }
            })
        }
    };

    ui.bindFormData = function (context) {
        context = context || 'body';
        var result = new FormData();
        $(context).find('[' + attrPrefix + 'role][' + attrPrefix + 'model]').each(function (i, ele) {
            var widget = ui.get(ele);
            var model = ui.attr(ele, 'model');
            if (widget.bindFormData) {
                result = widget.bindFormData(result);
            } else if (widget.bind) {
                var bindResult = widget.bind(model);
                if (bindResult) {
                    $.map(bindResult, function (v, k) {
                        result.append(k, v);
                    })
                }
            } else {
                result.append(model, widget.value());
            }
        });
        return result;
    };

    ui.clear = function (context, data, opts) {
        var opts = uglcw.extend({
            excludeHidden: true,
            excludeWidgets: ['datepicker']
        }, opts);
        $(context).find('[' + attrPrefix + 'role][' + attrPrefix + 'model]').each(function (i, ele) {
            var role = ui.attr(ele, 'role');
            if (opts.excludeWidgets && opts.excludeWidgets.length > 0 && opts.excludeWidgets.indexOf(role) !== -1) {
                //continue;
                return;
            }
            var widget = ui.get(ele), data = {};
            if (opts.excludeHidden && widget.hidden) {
                return;
            }
            var model = ui.attr(ele, 'model');
            data[model] = '';
            if (widget.bind) {
                widget.bind(model, data);
            } else {
                widget.value('');
            }
        });
        if (data !== undefined) {
            ui.bind(context, data)
        }
    };

    ui.enable = function (context, bool) {
        $(context).find('[' + attrPrefix + 'role]').each(function (i, ele) {
            var widget = ui.get(ele);
            if (widget.enable) {
                widget.enable(bool);
            }
        });
    };

    ui.readonly = function (context, bool) {
        $(context).find('[' + attrPrefix + 'role]').each(function (i, ele) {
            var widget = ui.get(ele)
            if (widget.readonly) {
                widget.readonly(bool);
            }
        });
    };

    ui.get = function (context) {
    };

    function BaseUI(obj) {
        this._obj = obj;
        $(this._obj).data('qui', this);
    }

    BaseUI.prototype = {
        /**
         * ui初始化
         * @param {object} opt - 配置选项
         */
        init: function (opt) {
        },
        /**
         * 事件注册统一入口
         * @param {string} event - 事件名
         * @param {function} callback - 事件回调函数
         */
        on: function (event, callback) {
        },
        /**
         * 获取元素对应的原始对象
         * @returns {dom object} 原始对象
         */
        element: function () {
            return this._obj;
        },
        /**
         * 获取ui支持的事件列表
         * @returns {array} ui支持的事件列表
         */
        _getSupportedEvents: function () {
            return []
        },
        /**
         * 检测指定的事件是否受支持
         * @param {string} event - 事件名
         * @returns {bool} 支持返回true，否则返回false
         */
        isSupportedEvent: function (e) {
            e = e || '';
            return $.inArray(e.toUpperCase(), this._getSupportedEvents()) != -1;
        },
        /**
         * 销毁控件，子类重载
         */
        destroy: function () {
        }
    }

    function EditableUI(obj) {
        BaseUI.call(this, obj);
    }

    EditableUI.prototype = new BaseUI();
    EditableUI.prototype.constructor = EditableUI

    EditableUI.prototype.show = function () {
        $(this._obj).show();
    }
    EditableUI.prototype.hide = function () {
        $(this._obj).hide();
    }

    function KUI(obj) {
        EditableUI.call(this, obj);
    }

    KUI.prototype = new EditableUI();
    KUI.prototype.constructor = KUI;
    KUI.prototype.init = function (opt) {
        var that = this
        var model = ui.attr(that._obj, 'model');
        if (model) {
            $(that._obj).attr('name', model);
        }
        var validate = ui.attr(that._obj, 'validate');
        if (validate) {
            var msg = ui.attr(that._obj, 'msg');
            var name = $(that._obj).attr('name');
            $(that._obj).after('<span class="k-invalid-msg" data-for="' + name + '"></span>')
            var rules = validate.split('|');
            $(rules).each(function (i, rule) {
                if (rule) {
                    var r = rule.split(':');
                    switch (r[0].toLowerCase()) {
                        case 'required':
                            $(that._obj).attr('required', true)
                            $(that._obj).attr('data-required-msg', '请输入必填项')
                            break;
                        case 'number':
                            break;
                        case 'email':
                            $(that._obj).attr('type', 'email')
                            $(that._obj).attr('validationMessage', '请输入正确的Email' || msg)
                            break;
                        case 'mobile':
                            $(that._obj).attr('pattern', '1[0-9]{10}')
                            $(that._obj).attr('type', 'text')
                            $(that._obj).attr('validationMessage', '请输入正确的手机号' || msg)
                            break;
                        case 'url':
                            $(that._obj).attr('type', 'url')
                            $(that._obj).attr('validationMessage', '请输入正确的URL' || msg)
                            break;
                        case 'pattern':
                            $(that._obj).attr('type', 'text')
                            $(that._obj).attr('pattern', r[1])
                            $(that._obj).attr('validationMessage', '请输入正确的内容' || msg)
                            break;
                        case 'max':

                    }
                }
            })
        }

        EditableUI.prototype.init.call(this, opt);
    }
    KUI.prototype.on = function (event, callback) {
        var widget = this.k();
        if (widget && widget.bind) {
            widget.bind(event, callback);
        } else {
            $(this._obj).bind(event, callback);
        }
    }
    KUI.prototype.initEvent = function (opt) {
        //根据配置属性注册ui事件
        if (opt) {
            for (var i in opt) {
                //以on开头的属性表示事件
                if (i.indexOf("on") == 0) {
                    if ($.isFunction(opt[i])) {
                        this.on(i.substr(2), opt[i]);
                    } else {
                        this.on(i.substr(2), function () {
                            window[opt[i]]();
                        });
                    }
                }
            }
        }
    }
    KUI.prototype.k = function () {
    }
    KUI.prototype.destory = function () {
        var widget = this.k();
        if (widget) {
            widget.destroy();
        }
    }
    ui.BaseUI = BaseUI;
    ui.EditableUI = EditableUI;
    ui.KUI = KUI;
    uglcw.ui = ui;
})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    var PLUGIN_NAME = 'iziToast';  // 样式类名
    var BODY = document.querySelector('body');
    var ISMOBILE = (/Mobi/.test(navigator.userAgent)) ? true : false;
    var MOBILEWIDTH = 568;
    var ISCHROME = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
    var ISFIREFOX = typeof InstallTrigger !== 'undefined';
    var ACCEPTSTOUCH = 'ontouchstart' in document.documentElement;
    // 显示区域
    var POSITIONS = ['bottomRight', 'bottomLeft', 'bottomCenter', 'topRight', 'topLeft', 'topCenter', 'center'];
    // 默认主题
    var THEMES = {
        info: {
            color: 'blue',
            icon: 'ico-info'
        },
        success: {
            color: 'green',
            icon: 'ico-success'
        },
        warning: {
            color: 'orange',
            icon: 'ico-warning'
        },
        error: {
            color: 'red',
            icon: 'ico-error'
        },
        question: {
            color: 'yellow',
            icon: 'ico-question'
        }
    };
    var CONFIG = {};  // 全局配置
    // 默认配置
    var defaults = {
        id: null,
        className: '',  // 自定义class，用空格分割
        title: '',  // 标题
        titleColor: '',  // 标题文字颜色
        titleSize: '',  // 标题文字大小
        titleLineHeight: '',  // 标题高度
        message: '',  // 内容
        messageColor: '',  // 内容文字颜色
        messageSize: '',  // 内容文字大小
        messageLineHeight: '',  // 内容高度
        backgroundColor: '',  // 背景颜色
        theme: 'light', // dark
        color: '', // 背景颜色
        icon: '',  // 图标
        iconText: '',  // 图标文字
        iconColor: '',  // 图标颜色
        iconUrl: null,  // 图标地址
        image: '',  // 是否显示图片
        imageWidth: 60,  // 图片宽度
        maxWidth: null,  // 最大宽度
        zindex: null,  //
        layout: 2,  // 布局类型
        balloon: false,  // 气泡
        close: true,  // 是否显示关闭按钮
        closeOnEscape: false,
        closeOnClick: false,  // 点击关闭
        displayMode: 0,  // 0无限制,1存在就不发出,2销毁之前
        position: 'topRight', // bottomRight, bottomLeft, topRight, topLeft, topCenter, bottomCenter, center
        target: '',  // 显示位置
        targetFirst: null,  // 插入顺序
        timeout: 5000,  // 关闭时间，false不自动关闭
        rtl: false,  // 内容居右
        animateInside: false,  // 进入动画效果
        drag: true,  // 是否可滑动移除
        pauseOnHover: true,  // 鼠标移入暂停进度条时间
        resetOnHover: false,  // 鼠标移入重置进度条时间
        progressBar: true,  // 是否显示进度条
        progressBarColor: '',  // 进度条颜色
        progressBarEasing: 'linear',  // 进度条动画效果
        overlay: false,  // 是否显示遮罩层
        overlayClose: false,  // 点击遮罩层是否关闭
        overlayColor: 'rgba(0, 0, 0, 0.1)',  // 遮罩层颜色
        transitionIn: 'fadeInLeft', // bounceInLeft, bounceInRight, bounceInUp, bounceInDown, fadeIn, fadeInDown, fadeInUp, fadeInLeft, fadeInRight, flipInX
        transitionOut: 'fadeOutRight', // fadeOut, fadeOutUp, fadeOutDown, fadeOutLeft, fadeOutRight, flipOutX
        transitionInMobile: 'bounceInDown',  // 移动端进入动画
        transitionOutMobile: 'fadeOutUp',  // 移动端退出动画
        buttons: {},  // 操作按钮
        inputs: {},  // 输入框
        audio: '',  // 音效
        onOpening: function () {
        },
        onOpened: function () {
        },
        onClosing: function () {
        },
        onClosed: function () {
        }
    };

    var $iziToast = {
        children: {},
        setSetting: function (ref, option, value) {
            $iziToast.children[ref][option] = value;
        },
        getSetting: function (ref, option) {
            return $iziToast.children[ref][option];
        },
        // 全局设置
        settings: function (options) {
            $iziToast.destroy();  // 全部销毁之前的通知
            CONFIG = options;
            defaults = extend(defaults, options || {});
        },
        // 关闭所有通知
        destroy: function () {
            forEach(document.querySelectorAll('.' + PLUGIN_NAME + '-overlay'), function (element, index) {
                element.remove();
            });
            forEach(document.querySelectorAll('.' + PLUGIN_NAME + '-wrapper'), function (element, index) {
                element.remove();
            });
            forEach(document.querySelectorAll('.' + PLUGIN_NAME), function (element, index) {
                element.remove();
            });
            this.children = {};
            // 移除事件监听
            document.removeEventListener(PLUGIN_NAME + '-opened', {}, false);
            document.removeEventListener(PLUGIN_NAME + '-opening', {}, false);
            document.removeEventListener(PLUGIN_NAME + '-closing', {}, false);
            document.removeEventListener(PLUGIN_NAME + '-closed', {}, false);
            document.removeEventListener('keyup', {}, false);
            CONFIG = {};  // 移除全局配置
        },
        // msg类型
        msg: function (msg, options) {
            if (options.icon == 4) {
                options.overlay = true;
                options.timeout = false;
                options.drag = false;
                options.displayMode = 0;
            }
            var icons = ['ico-success', 'ico-error', 'ico-warning', 'ico-load', 'ico-info'];
            options.icon = icons[options.icon - 1];
            var theme = {
                message: msg,
                position: 'topCenter',
                transitionIn: 'bounceInDown',
                transitionOut: 'fadeOut',
                transitionOutMobile: 'fadeOut',
                progressBar: false,
                close: false,
                layout: 1,
                audio: ''
            };
            var settings = extend(CONFIG, options || {});
            settings = extend(theme, settings || {});
            this.show(settings);
        }
    };

    // 关闭指定的通知
    $iziToast.hide = function (options, $toast, closedBy) {
        if (typeof $toast != 'object') {
            $toast = document.querySelector($toast);
        }
        var that = this;
        var settings = extend(this.children[$toast.getAttribute('data-iziToast-ref')], options || {});
        settings.closedBy = closedBy || null;
        delete settings.time.REMAINING;
        $toast.classList.add(PLUGIN_NAME + '-closing');
        // 移除遮罩层
        (function () {
            var $overlay = document.querySelector('.' + PLUGIN_NAME + '-overlay');
            if ($overlay !== null) {
                var refs = $overlay.getAttribute('data-iziToast-ref');
                refs = refs.split(',');
                var index = refs.indexOf(String(settings.ref));
                if (index !== -1) {
                    refs.splice(index, 1);
                }
                $overlay.setAttribute('data-iziToast-ref', refs.join());
                if (refs.length === 0) {
                    $overlay.classList.remove('fadeIn');
                    $overlay.classList.add('fadeOut');
                    setTimeout(function () {
                        $overlay.remove();
                    }, 700);
                }
            }
        })();
        // 移除动画
        if (settings.transitionIn) {
            $toast.classList.remove(settings.transitionIn);
        }
        if (settings.transitionInMobile) {
            $toast.classList.remove(settings.transitionInMobile);
        }
        if (ISMOBILE || window.innerWidth <= MOBILEWIDTH) {
            if (settings.transitionOutMobile)
                $toast.classList.add(settings.transitionOutMobile);
        } else {
            if (settings.transitionOut)
                $toast.classList.add(settings.transitionOut);
        }
        var H = $toast.parentNode.offsetHeight;
        $toast.parentNode.style.height = H + 'px';
        $toast.style.pointerEvents = 'none';
        if (!ISMOBILE || window.innerWidth > MOBILEWIDTH) {
            $toast.parentNode.style.transitionDelay = '0.2s';
        }
        try {
            var event = new CustomEvent(PLUGIN_NAME + '-closing', {detail: settings, bubbles: true, cancelable: true});
            document.dispatchEvent(event);
        } catch (ex) {
            console.warn(ex);
        }
        setTimeout(function () {
            $toast.parentNode.style.height = '0px';
            $toast.parentNode.style.overflow = '';
            setTimeout(function () {
                delete that.children[settings.ref];
                $toast.parentNode.remove();
                try {
                    var event = new CustomEvent(PLUGIN_NAME + '-closed', {
                        detail: settings,
                        bubbles: true,
                        cancelable: true
                    });
                    document.dispatchEvent(event);
                } catch (ex) {
                    console.warn(ex);
                }
                if (typeof settings.onClosed !== 'undefined') {
                    settings.onClosed.apply(null, [settings, $toast, closedBy]);
                }
            }, 1000);
        }, 200);
        // 回调关闭事件
        if (typeof settings.onClosing !== 'undefined') {
            settings.onClosing.apply(null, [settings, $toast, closedBy]);
        }
    };

    // 显示通知
    $iziToast.show = function (options) {
        var that = this;
        // Merge user options with defaults
        var settings = extend(CONFIG, options || {});
        settings = extend(defaults, settings);
        settings.time = {};
        if (settings.id === null) {
            settings.id = generateId(settings.title + settings.message + settings.color);
        }
        if (settings.displayMode == 1 || settings.displayMode == 'once') {
            try {
                if (document.querySelectorAll('.' + PLUGIN_NAME + '#' + settings.id).length > 0) {
                    return false;
                }
            } catch (exc) {
                console.warn('[' + PLUGIN_NAME + '] Could not find an element with this selector: ' + '#' + settings.id + '. Try to set an valid id.');
            }
        }
        if (settings.displayMode == 2 || settings.displayMode == 'replace') {
            try {
                forEach(document.querySelectorAll('.' + PLUGIN_NAME + '#' + settings.id), function (element, index) {
                    that.hide(settings, element, 'replaced');
                });
            } catch (exc) {
                console.warn('[' + PLUGIN_NAME + '] Could not find an element with this selector: ' + '#' + settings.id + '. Try to set an valid id.');
            }
        }
        settings.ref = new Date().getTime() + Math.floor((Math.random() * 10000000) + 1);
        $iziToast.children[settings.ref] = settings;
        var $DOM = {
            body: document.querySelector('body'),
            overlay: document.createElement('div'),
            toast: document.createElement('div'),
            toastBody: document.createElement('div'),
            toastTexts: document.createElement('div'),
            toastCapsule: document.createElement('div'),
            cover: document.createElement('div'),
            buttons: document.createElement('div'),
            inputs: document.createElement('div'),
            icon: !settings.iconUrl ? document.createElement('i') : document.createElement('img'),
            wrapper: null
        };
        $DOM.toast.setAttribute('data-iziToast-ref', settings.ref);
        $DOM.toast.appendChild($DOM.toastBody);
        $DOM.toastCapsule.appendChild($DOM.toast);
        // CSS Settings
        (function () {
            $DOM.toast.classList.add(PLUGIN_NAME);
            $DOM.toast.classList.add(PLUGIN_NAME + '-opening');
            $DOM.toastCapsule.classList.add(PLUGIN_NAME + '-capsule');
            $DOM.toastBody.classList.add(PLUGIN_NAME + '-body');
            $DOM.toastTexts.classList.add(PLUGIN_NAME + '-texts');
            if (ISMOBILE || window.innerWidth <= MOBILEWIDTH) {
                if (settings.transitionInMobile)
                    $DOM.toast.classList.add(settings.transitionInMobile);
            } else {
                if (settings.transitionIn)
                    $DOM.toast.classList.add(settings.transitionIn);
            }
            if (settings.className) {
                var classes = settings.className.split(' ');
                forEach(classes, function (value, index) {
                    $DOM.toast.classList.add(value);
                });
            }
            if (settings.id) {
                $DOM.toast.id = settings.id;
            }
            if (settings.rtl) {
                $DOM.toast.classList.add(PLUGIN_NAME + '-rtl');
                $DOM.toast.setAttribute('dir', 'rtl');
            }
            if (settings.layout > 1) {
                $DOM.toast.classList.add(PLUGIN_NAME + '-layout' + settings.layout);
            }
            if (settings.balloon) {
                $DOM.toast.classList.add(PLUGIN_NAME + '-balloon');
            }
            if (settings.maxWidth) {
                if (!isNaN(settings.maxWidth)) {
                    $DOM.toast.style.maxWidth = settings.maxWidth + 'px';
                } else {
                    $DOM.toast.style.maxWidth = settings.maxWidth;
                }
            }
            if (settings.theme !== '' || settings.theme !== 'light') {
                $DOM.toast.classList.add(PLUGIN_NAME + '-theme-' + settings.theme);
            }
            if (settings.color) { //#, rgb, rgba, hsl
                if (isColor(settings.color)) {
                    $DOM.toast.style.background = settings.color;
                } else {
                    $DOM.toast.classList.add(PLUGIN_NAME + '-color-' + settings.color);
                }
            }
            if (settings.backgroundColor) {
                $DOM.toast.style.background = settings.backgroundColor;
                if (settings.balloon) {
                    $DOM.toast.style.borderColor = settings.backgroundColor;
                }
            }
        })();
        // Cover image
        (function () {
            if (settings.image) {
                $DOM.cover.classList.add(PLUGIN_NAME + '-cover');
                $DOM.cover.style.width = settings.imageWidth + 'px';
                if (isBase64(settings.image.replace(/ /g, ''))) {
                    $DOM.cover.style.backgroundImage = 'url(data:image/png;base64,' + settings.image.replace(/ /g, '') + ')';
                } else {
                    $DOM.cover.style.backgroundImage = 'url(' + settings.image + ')';
                }
                if (settings.rtl) {
                    $DOM.toastBody.style.marginRight = (settings.imageWidth) + 'px';
                } else {
                    $DOM.toastBody.style.marginLeft = (settings.imageWidth) + 'px';
                }
                $DOM.toast.appendChild($DOM.cover);
            }
        })();
        // Button close
        (function () {
            if (settings.close) {
                $DOM.buttonClose = document.createElement('button');
                // $DOM.buttonClose.type = 'button';
                $DOM.buttonClose.setAttribute('type', 'button');
                $DOM.buttonClose.classList.add(PLUGIN_NAME + '-close');
                $DOM.buttonClose.addEventListener('click', function (e) {
                    var button = e.target;
                    that.hide(settings, $DOM.toast, 'button');
                });
                $DOM.toast.appendChild($DOM.buttonClose);
            } else {
                if (settings.rtl) {
                    $DOM.toast.style.paddingLeft = '18px';
                } else {
                    $DOM.toast.style.paddingRight = '18px';
                }
            }
        })();
        // Progress Bar & Timeout
        (function () {
            if (settings.progressBar) {
                $DOM.progressBar = document.createElement('div');
                $DOM.progressBarDiv = document.createElement('div');
                $DOM.progressBar.classList.add(PLUGIN_NAME + '-progressbar');
                $DOM.progressBarDiv.style.background = settings.progressBarColor;
                $DOM.progressBar.appendChild($DOM.progressBarDiv);
                $DOM.toast.appendChild($DOM.progressBar);
            }
            if (settings.timeout) {
                if (settings.pauseOnHover && !settings.resetOnHover) {
                    $DOM.toast.addEventListener('mouseenter', function (e) {
                        that.progress(settings, $DOM.toast).pause();
                    });
                    $DOM.toast.addEventListener('mouseleave', function (e) {
                        that.progress(settings, $DOM.toast).resume();
                    });
                }
                if (settings.resetOnHover) {
                    $DOM.toast.addEventListener('mouseenter', function (e) {
                        that.progress(settings, $DOM.toast).reset();
                    });
                    $DOM.toast.addEventListener('mouseleave', function (e) {
                        that.progress(settings, $DOM.toast).start();
                    });
                }
            }
        })();
        // Icon
        (function () {
            if (settings.iconUrl) {
                $DOM.icon.setAttribute('class', PLUGIN_NAME + '-icon');
                $DOM.icon.setAttribute('src', settings.iconUrl);
            } else if (settings.icon) {
                $DOM.icon.setAttribute('class', PLUGIN_NAME + '-icon ' + settings.icon);
                if (settings.iconText) {
                    $DOM.icon.appendChild(document.createTextNode(settings.iconText));
                }
                if (settings.iconColor) {
                    $DOM.icon.style.color = settings.iconColor;
                }
            }
            if (settings.icon || settings.iconUrl) {
                if (settings.rtl) {
                    $DOM.toastBody.style.paddingRight = '33px';
                } else {
                    $DOM.toastBody.style.paddingLeft = '33px';
                }
                $DOM.toastBody.appendChild($DOM.icon);
            }

        })();
        // Title & Message
        (function () {
            if (settings.title.length > 0) {
                $DOM.strong = document.createElement('strong');
                $DOM.strong.classList.add(PLUGIN_NAME + '-title');
                $DOM.strong.appendChild(createFragElem(settings.title));
                $DOM.toastTexts.appendChild($DOM.strong);
                if (settings.titleColor) {
                    $DOM.strong.style.color = settings.titleColor;
                }
                if (settings.titleSize) {
                    if (!isNaN(settings.titleSize)) {
                        $DOM.strong.style.fontSize = settings.titleSize + 'px';
                    } else {
                        $DOM.strong.style.fontSize = settings.titleSize;
                    }
                }
                if (settings.titleLineHeight) {
                    if (!isNaN(settings.titleSize)) {
                        $DOM.strong.style.lineHeight = settings.titleLineHeight + 'px';
                    } else {
                        $DOM.strong.style.lineHeight = settings.titleLineHeight;
                    }
                }
            }
            if (settings.message.length > 0) {
                $DOM.p = document.createElement('p');
                $DOM.p.classList.add(PLUGIN_NAME + '-message');
                $DOM.p.appendChild(createFragElem(settings.message));
                $DOM.toastTexts.appendChild($DOM.p);
                if (settings.messageColor) {
                    $DOM.p.style.color = settings.messageColor;
                }
                if (settings.messageSize) {
                    if (!isNaN(settings.titleSize)) {
                        $DOM.p.style.fontSize = settings.messageSize + 'px';
                    } else {
                        $DOM.p.style.fontSize = settings.messageSize;
                    }
                }
                if (settings.messageLineHeight) {
                    if (!isNaN(settings.titleSize)) {
                        $DOM.p.style.lineHeight = settings.messageLineHeight + 'px';
                    } else {
                        $DOM.p.style.lineHeight = settings.messageLineHeight;
                    }
                }
            }
            if (settings.title.length > 0 && settings.message.length > 0) {
                if (settings.rtl) {
                    $DOM.strong.style.marginLeft = '10px';
                } else if (settings.layout != 2 && !settings.rtl) {
                    $DOM.strong.style.marginRight = '10px';
                    $DOM.strong.style.marginBottom = '0px';
                }
            }
        })();
        $DOM.toastBody.appendChild($DOM.toastTexts);
        // Inputs
        var $inputs;
        (function () {
            if (settings.inputs.length > 0) {
                $DOM.inputs.classList.add(PLUGIN_NAME + '-inputs');
                forEach(settings.inputs, function (value, index) {
                    $DOM.inputs.appendChild(createFragElem(value[0]));
                    $inputs = $DOM.inputs.childNodes;
                    $inputs[index].classList.add(PLUGIN_NAME + '-inputs-child');
                    if (value[3]) {
                        setTimeout(function () {
                            $inputs[index].focus();
                        }, 300);
                    }
                    $inputs[index].addEventListener(value[1], function (e) {
                        var ts = value[2];
                        return ts(that, $DOM.toast, this, e);
                    });
                });
                $DOM.toastBody.appendChild($DOM.inputs);
            }
        })();
        // Buttons
        (function () {
            if (settings.buttons.length > 0) {
                $DOM.buttons.classList.add(PLUGIN_NAME + '-buttons');
                forEach(settings.buttons, function (value, index) {
                    $DOM.buttons.appendChild(createFragElem(value[0]));
                    var $btns = $DOM.buttons.childNodes;
                    $btns[index].classList.add(PLUGIN_NAME + '-buttons-child');
                    if (value[2]) {
                        setTimeout(function () {
                            $btns[index].focus();
                        }, 300);
                    }
                    $btns[index].addEventListener('click', function (e) {
                        e.preventDefault();
                        var ts = value[1];
                        return ts(that, $DOM.toast, this, e, $inputs);
                    });
                });
            }
            $DOM.toastTexts.appendChild($DOM.buttons);
        })();
        if (settings.message.length > 0 && (settings.inputs.length > 0 || settings.buttons.length > 0)) {
            $DOM.p.style.marginBottom = '0';
        }
        if (settings.inputs.length > 0 || settings.buttons.length > 0) {
            if (settings.rtl) {
                $DOM.toastTexts.style.marginLeft = '10px';
            } else {
                $DOM.toastTexts.style.marginRight = '10px';
            }
            if (settings.inputs.length > 0 && settings.buttons.length > 0) {
                if (settings.rtl) {
                    $DOM.inputs.style.marginLeft = '8px';
                } else {
                    $DOM.inputs.style.marginRight = '8px';
                }
            }
        }
        // Wrap
        (function () {
            $DOM.toastCapsule.style.visibility = 'hidden';
            setTimeout(function () {
                var H = $DOM.toast.offsetHeight;
                var style = $DOM.toast.currentStyle || window.getComputedStyle($DOM.toast);
                var marginTop = style.marginTop;
                marginTop = marginTop.split('px');
                marginTop = parseInt(marginTop[0]);
                var marginBottom = style.marginBottom;
                marginBottom = marginBottom.split('px');
                marginBottom = parseInt(marginBottom[0]);

                $DOM.toastCapsule.style.visibility = '';
                $DOM.toastCapsule.style.height = (H + marginBottom + marginTop) + 'px';

                setTimeout(function () {
                    $DOM.toastCapsule.style.height = 'auto';
                    if (settings.target) {
                        $DOM.toastCapsule.style.overflow = 'visible';
                    }
                }, 500);

                if (settings.timeout) {
                    that.progress(settings, $DOM.toast).start();
                }
            }, 100);
        })();
        // Target
        (function () {
            var position = settings.position;
            if (settings.target) {
                $DOM.wrapper = document.querySelector(settings.target);
                $DOM.wrapper.classList.add(PLUGIN_NAME + '-target');
                if (settings.targetFirst) {
                    $DOM.wrapper.insertBefore($DOM.toastCapsule, $DOM.wrapper.firstChild);
                } else {
                    $DOM.wrapper.appendChild($DOM.toastCapsule);
                }
            } else {
                if (POSITIONS.indexOf(settings.position) == -1) {
                    console.warn('[' + PLUGIN_NAME + '] Incorrect position.\nIt can be › ' + POSITIONS);
                    return;
                }
                if (ISMOBILE || window.innerWidth <= MOBILEWIDTH) {
                    if (settings.position == 'bottomLeft' || settings.position == 'bottomRight' || settings.position == 'bottomCenter') {
                        position = PLUGIN_NAME + '-wrapper-bottomCenter';
                    } else if (settings.position == 'topLeft' || settings.position == 'topRight' || settings.position == 'topCenter') {
                        position = PLUGIN_NAME + '-wrapper-topCenter';
                    } else {
                        position = PLUGIN_NAME + '-wrapper-center';
                    }
                } else {
                    position = PLUGIN_NAME + '-wrapper-' + position;
                }
                $DOM.wrapper = document.querySelector('.' + PLUGIN_NAME + '-wrapper.' + position);
                if (!$DOM.wrapper) {
                    $DOM.wrapper = document.createElement('div');
                    $DOM.wrapper.classList.add(PLUGIN_NAME + '-wrapper');
                    $DOM.wrapper.classList.add(position);
                    document.body.appendChild($DOM.wrapper);
                }
                var targetFirst = settings.targetFirst;
                if ((targetFirst == undefined || targetFirst == null) && (settings.position == 'topLeft' || settings.position == 'topCenter' || settings.position == 'topRight')) {
                    targetFirst = true;
                }
                if (targetFirst) {
                    $DOM.wrapper.insertBefore($DOM.toastCapsule, $DOM.wrapper.firstChild);
                } else {
                    $DOM.wrapper.appendChild($DOM.toastCapsule);
                }
            }
            if (!isNaN(settings.zindex)) {
                $DOM.wrapper.style.zIndex = settings.zindex;
            } else {
                console.warn('[' + PLUGIN_NAME + '] Invalid zIndex.');
            }
        })();
        // Overlay
        (function () {
            if (settings.overlay) {
                if (document.querySelector('.' + PLUGIN_NAME + '-overlay.fadeIn') !== null) {
                    $DOM.overlay = document.querySelector('.' + PLUGIN_NAME + '-overlay');
                    $DOM.overlay.setAttribute('data-iziToast-ref', $DOM.overlay.getAttribute('data-iziToast-ref') + ',' + settings.ref);
                    if (!isNaN(settings.zindex) && settings.zindex !== null) {
                        $DOM.overlay.style.zIndex = settings.zindex - 1;
                    }
                } else {
                    $DOM.overlay.classList.add(PLUGIN_NAME + '-overlay');
                    $DOM.overlay.classList.add('fadeIn');
                    $DOM.overlay.style.background = settings.overlayColor;
                    $DOM.overlay.setAttribute('data-iziToast-ref', settings.ref);
                    if (!isNaN(settings.zindex) && settings.zindex !== null) {
                        $DOM.overlay.style.zIndex = settings.zindex - 1;
                    }
                    document.querySelector('body').appendChild($DOM.overlay);
                }
                if (settings.overlayClose) {
                    $DOM.overlay.removeEventListener('click', {});
                    $DOM.overlay.addEventListener('click', function (e) {
                        that.hide(settings, $DOM.toast, 'overlay');
                    });
                } else {
                    $DOM.overlay.removeEventListener('click', {});
                }
            }
        })();
        // Inside animations
        (function () {
            if (settings.animateInside) {
                $DOM.toast.classList.add(PLUGIN_NAME + '-animateInside');
                var animationTimes = [200, 100, 300];
                if (settings.transitionIn == 'bounceInLeft' || settings.transitionIn == 'bounceInRight') {
                    animationTimes = [400, 200, 400];
                }
                if (settings.title.length > 0) {
                    setTimeout(function () {
                        $DOM.strong.classList.add('slideIn');
                    }, animationTimes[0]);
                }
                if (settings.message.length > 0) {
                    setTimeout(function () {
                        $DOM.p.classList.add('slideIn');
                    }, animationTimes[1]);
                }
                if (settings.icon || settings.iconUrl) {
                    setTimeout(function () {
                        $DOM.icon.classList.add('revealIn');
                    }, animationTimes[2]);
                }
                var counter = 150;
                if (settings.buttons.length > 0 && $DOM.buttons) {
                    setTimeout(function () {
                        forEach($DOM.buttons.childNodes, function (element, index) {
                            setTimeout(function () {
                                element.classList.add('revealIn');
                            }, counter);
                            counter = counter + 150;
                        });
                    }, settings.inputs.length > 0 ? 150 : 0);
                }
                if (settings.inputs.length > 0 && $DOM.inputs) {
                    counter = 150;
                    forEach($DOM.inputs.childNodes, function (element, index) {
                        setTimeout(function () {
                            element.classList.add('revealIn');
                        }, counter);
                        counter = counter + 150;
                    });
                }
            }
        })();
        settings.onOpening.apply(null, [settings, $DOM.toast]);
        try {
            var event = new CustomEvent(PLUGIN_NAME + '-opening', {detail: settings, bubbles: true, cancelable: true});
            document.dispatchEvent(event);
        } catch (ex) {
            console.warn(ex);
        }
        setTimeout(function () {
            $DOM.toast.classList.remove(PLUGIN_NAME + '-opening');
            $DOM.toast.classList.add(PLUGIN_NAME + '-opened');
            try {
                var event = new CustomEvent(PLUGIN_NAME + '-opened', {
                    detail: settings,
                    bubbles: true,
                    cancelable: true
                });
                document.dispatchEvent(event);
            } catch (ex) {
                console.warn(ex);
            }
            settings.onOpened.apply(null, [settings, $DOM.toast]);
        }, 1000);
        if (settings.drag) {
            if (ACCEPTSTOUCH) {
                $DOM.toast.addEventListener('touchstart', function (e) {
                    drag.startMoving(this, that, settings, e);
                }, false);
                $DOM.toast.addEventListener('touchend', function (e) {
                    drag.stopMoving(this, e);
                }, false);
            } else {
                $DOM.toast.addEventListener('mousedown', function (e) {
                    e.preventDefault();
                    drag.startMoving(this, that, settings, e);
                }, false);
                $DOM.toast.addEventListener('mouseup', function (e) {
                    e.preventDefault();
                    drag.stopMoving(this, e);
                }, false);
            }
        }
        if (settings.closeOnEscape) {
            document.addEventListener('keyup', function (evt) {
                evt = evt || window.event;
                if (evt.keyCode == 27) {
                    that.hide(settings, $DOM.toast, 'esc');
                }
            });
        }
        if (settings.closeOnClick) {
            $DOM.toast.addEventListener('click', function (evt) {
                that.hide(settings, $DOM.toast, 'toast');
            });
        }
        // 播放声音
        if (settings.audio) {
            that.playSound(settings.audio);
        }
        that.toast = $DOM.toast;
    };

    // 控制进度条
    $iziToast.progress = function (options, $toast, callback) {
        var that = this,
            ref = $toast.getAttribute('data-iziToast-ref'),
            settings = extend(this.children[ref], options || {}),
            $elem = $toast.querySelector('.' + PLUGIN_NAME + '-progressbar div');
        return {
            start: function () {
                if (typeof settings.time.REMAINING == 'undefined') {
                    $toast.classList.remove(PLUGIN_NAME + '-reseted');
                    if ($elem !== null) {
                        $elem.style.transition = 'width ' + settings.timeout + 'ms ' + settings.progressBarEasing;
                        $elem.style.width = '0%';
                    }
                    settings.time.START = new Date().getTime();
                    settings.time.END = settings.time.START + settings.timeout;
                    settings.time.TIMER = setTimeout(function () {
                        clearTimeout(settings.time.TIMER);
                        if (!$toast.classList.contains(PLUGIN_NAME + '-closing')) {
                            that.hide(settings, $toast, 'timeout');
                            if (typeof callback === 'function') {
                                callback.apply(that);
                            }
                        }
                    }, settings.timeout);
                    that.setSetting(ref, 'time', settings.time);
                }
            },
            pause: function () {
                if (typeof settings.time.START !== 'undefined' && !$toast.classList.contains(PLUGIN_NAME + '-paused') && !$toast.classList.contains(PLUGIN_NAME + '-reseted')) {
                    $toast.classList.add(PLUGIN_NAME + '-paused');
                    settings.time.REMAINING = settings.time.END - new Date().getTime();
                    clearTimeout(settings.time.TIMER);
                    that.setSetting(ref, 'time', settings.time);
                    if ($elem !== null) {
                        var computedStyle = window.getComputedStyle($elem),
                            propertyWidth = computedStyle.getPropertyValue('width');
                        $elem.style.transition = 'none';
                        $elem.style.width = propertyWidth;
                    }
                    if (typeof callback === 'function') {
                        setTimeout(function () {
                            callback.apply(that);
                        }, 10);
                    }
                }
            },
            resume: function () {
                if (typeof settings.time.REMAINING !== 'undefined') {
                    $toast.classList.remove(PLUGIN_NAME + '-paused');
                    if ($elem !== null) {
                        $elem.style.transition = 'width ' + settings.time.REMAINING + 'ms ' + settings.progressBarEasing;
                        $elem.style.width = '0%';
                    }
                    settings.time.END = new Date().getTime() + settings.time.REMAINING;
                    settings.time.TIMER = setTimeout(function () {
                        clearTimeout(settings.time.TIMER);
                        if (!$toast.classList.contains(PLUGIN_NAME + '-closing')) {
                            that.hide(settings, $toast, 'timeout');
                            if (typeof callback === 'function') {
                                callback.apply(that);
                            }
                        }
                    }, settings.time.REMAINING);
                    that.setSetting(ref, 'time', settings.time);
                } else {
                    this.start();
                }
            },
            reset: function () {
                clearTimeout(settings.time.TIMER);
                delete settings.time.REMAINING;
                that.setSetting(ref, 'time', settings.time);
                $toast.classList.add(PLUGIN_NAME + '-reseted');
                $toast.classList.remove(PLUGIN_NAME + '-paused');
                if ($elem !== null) {
                    $elem.style.transition = 'none';
                    $elem.style.width = '100%';
                }
                if (typeof callback === 'function') {
                    setTimeout(function () {
                        callback.apply(that);
                    }, 10);
                }
            }
        };
    };

    // 判断是否是ie9以下版本
    var isIE9_ = function () {
        var userAgent = navigator.userAgent;
        if (window.navigator.userAgent.indexOf("MSIE") >= 1) {
            var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
            reIE.test(userAgent);
            var fIEVersion = parseFloat(RegExp["$1"]);
            if (fIEVersion != 10) {
                return true;
            }
        }
        return false;
    };

    // 给Element添加remove方法
    if (!('remove' in Element.prototype)) {
        Element.prototype.remove = function () {
            if (this.parentNode) {
                this.parentNode.removeChild(this);
            }
        };
    }

    // 自定义事件
    if (typeof window.CustomEvent !== 'function') {
        var CustomEventPolyfill = function (event, params) {
            params = params || {bubbles: false, cancelable: false, detail: undefined};
            var evt = document.createEvent('CustomEvent');
            evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
            return evt;
        };
        CustomEventPolyfill.prototype = window.Event.prototype;
        window.CustomEvent = CustomEventPolyfill;
    }

    // 遍历数据
    var forEach = function (collection, callback, scope) {
        if (Object.prototype.toString.call(collection) === '[object Object]') {
            for (var prop in collection) {
                if (Object.prototype.hasOwnProperty.call(collection, prop)) {
                    callback.call(scope, collection[prop], prop, collection);
                }
            }
        } else {
            if (collection) {
                for (var i = 0, len = collection.length; i < len; i++) {
                    callback.call(scope, collection[i], i, collection);
                }
            }
        }
    };

    // 合并自定义参数和默认参数
    var extend = function (defaults, options) {
        var extended = {};
        forEach(defaults, function (value, prop) {
            extended[prop] = defaults[prop];
        });
        forEach(options, function (value, prop) {
            extended[prop] = options[prop];
        });
        return extended;
    };

    // 创建新的文档片段
    var createFragElem = function (htmlStr) {
        var frag = document.createDocumentFragment(),
            temp = document.createElement('div');
        temp.innerHTML = htmlStr;
        while (temp.firstChild) {
            frag.appendChild(temp.firstChild);
        }
        return frag;
    };

    // 生成ID
    var generateId = function (params) {
        var newId = btoa(encodeURIComponent(params));
        return newId.replace(/=/g, "");
    };

    // 判断是否是颜色字符串
    var isColor = function (color) {
        if (color.substring(0, 1) == '#' || color.substring(0, 3) == 'rgb' || color.substring(0, 3) == 'hsl') {
            return true;
        } else {
            return false;
        }
    };

    // 判断是否是base64字符串
    var isBase64 = function (str) {
        try {
            return btoa(atob(str)) == str;
        } catch (err) {
            return false;
        }
    };

    // 拖拽方法
    var drag = function () {
        return {
            move: function (toast, instance, settings, xpos) {
                var opacity,
                    opacityRange = 0.3,
                    distance = 180;
                if (xpos !== 0) {
                    toast.classList.add(PLUGIN_NAME + '-dragged');
                    toast.style.transform = 'translateX(' + xpos + 'px)';
                    if (xpos > 0) {
                        opacity = (distance - xpos) / distance;
                        if (opacity < opacityRange) {
                            instance.hide(extend(settings, {
                                transitionOut: 'fadeOutRight',
                                transitionOutMobile: 'fadeOutRight'
                            }), toast, 'drag');
                        }
                    } else {
                        opacity = (distance + xpos) / distance;
                        if (opacity < opacityRange) {
                            instance.hide(extend(settings, {
                                transitionOut: 'fadeOutLeft',
                                transitionOutMobile: 'fadeOutLeft'
                            }), toast, 'drag');
                        }
                    }
                    toast.style.opacity = opacity;
                    if (opacity < opacityRange) {
                        if (ISCHROME || ISFIREFOX)
                            toast.style.left = xpos + 'px';
                        toast.parentNode.style.opacity = opacityRange;
                        this.stopMoving(toast, null);
                    }
                }
            },
            startMoving: function (toast, instance, settings, e) {
                e = e || window.event;
                var posX = ((ACCEPTSTOUCH) ? e.touches[0].clientX : e.clientX),
                    toastLeft = toast.style.transform.replace('px)', '');
                toastLeft = toastLeft.replace('translateX(', '');
                var offsetX = posX - toastLeft;
                if (settings.transitionIn) {
                    toast.classList.remove(settings.transitionIn);
                }
                if (settings.transitionInMobile) {
                    toast.classList.remove(settings.transitionInMobile);
                }
                toast.style.transition = '';
                if (ACCEPTSTOUCH) {
                    document.ontouchmove = function (e) {
                        e.preventDefault();
                        e = e || window.event;
                        var posX = e.touches[0].clientX,
                            finalX = posX - offsetX;
                        drag.move(toast, instance, settings, finalX);
                    };
                } else {
                    document.onmousemove = function (e) {
                        e.preventDefault();
                        e = e || window.event;
                        var posX = e.clientX,
                            finalX = posX - offsetX;
                        drag.move(toast, instance, settings, finalX);
                    };
                }
            },
            stopMoving: function (toast, e) {
                if (ACCEPTSTOUCH) {
                    document.ontouchmove = function () {
                    };
                } else {
                    document.onmousemove = function () {
                    };
                }
                toast.style.opacity = '';
                toast.style.transform = '';
                if (toast.classList.contains(PLUGIN_NAME + '-dragged')) {
                    toast.classList.remove(PLUGIN_NAME + '-dragged');
                    toast.style.transition = 'transform 0.4s ease, opacity 0.4s ease';
                    setTimeout(function () {
                        toast.style.transition = '';
                    }, 400);
                }
            }
        };
    }();

    // 兼容IE
    var Base64 = {
        _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", encode: function (e) {
            var t = "";
            var n, r, i, s, o, u, a;
            var f = 0;
            e = Base64._utf8_encode(e);
            while (f < e.length) {
                n = e.charCodeAt(f++);
                r = e.charCodeAt(f++);
                i = e.charCodeAt(f++);
                s = n >> 2;
                o = (n & 3) << 4 | r >> 4;
                u = (r & 15) << 2 | i >> 6;
                a = i & 63;
                if (isNaN(r)) {
                    u = a = 64
                } else if (isNaN(i)) {
                    a = 64
                }
                t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a)
            }
            return t
        }, decode: function (e) {
            var t = "";
            var n, r, i;
            var s, o, u, a;
            var f = 0;
            e = e.replace(/[^A-Za-z0-9+/=]/g, "");
            while (f < e.length) {
                s = this._keyStr.indexOf(e.charAt(f++));
                o = this._keyStr.indexOf(e.charAt(f++));
                u = this._keyStr.indexOf(e.charAt(f++));
                a = this._keyStr.indexOf(e.charAt(f++));
                n = s << 2 | o >> 4;
                r = (o & 15) << 4 | u >> 2;
                i = (u & 3) << 6 | a;
                t = t + String.fromCharCode(n);
                if (u != 64) {
                    t = t + String.fromCharCode(r)
                }
                if (a != 64) {
                    t = t + String.fromCharCode(i)
                }
            }
            t = Base64._utf8_decode(t);
            return t
        }, _utf8_encode: function (e) {
            e = e.replace(/rn/g, "n");
            var t = "";
            for (var n = 0; n < e.length; n++) {
                var r = e.charCodeAt(n);
                if (r < 128) {
                    t += String.fromCharCode(r)
                } else if (r > 127 && r < 2048) {
                    t += String.fromCharCode(r >> 6 | 192);
                    t += String.fromCharCode(r & 63 | 128)
                } else {
                    t += String.fromCharCode(r >> 12 | 224);
                    t += String.fromCharCode(r >> 6 & 63 | 128);
                    t += String.fromCharCode(r & 63 | 128)
                }
            }
            return t
        }, _utf8_decode: function (e) {
            var t = "";
            var n = 0;
            var r = c1 = c2 = 0;
            while (n < e.length) {
                r = e.charCodeAt(n);
                if (r < 128) {
                    t += String.fromCharCode(r);
                    n++
                } else if (r > 191 && r < 224) {
                    c2 = e.charCodeAt(n + 1);
                    t += String.fromCharCode((r & 31) << 6 | c2 & 63);
                    n += 2
                } else {
                    c2 = e.charCodeAt(n + 1);
                    c3 = e.charCodeAt(n + 2);
                    t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63);
                    n += 3
                }
            }
            return t
        }
    };
    if (isIE9_()) {
        // 兼容btoa和atob方法
        window.btoa = function (str) {
            return Base64.encode(str);
        };
        window.atob = function (str) {
            return Base64.decode(str);
        };
        // 兼容classList属性
        if (!("classList" in document.documentElement)) {
            Object.defineProperty(window.Element.prototype, 'classList', {
                get: function () {
                    var self = this;

                    function update(fn) {
                        return function () {
                            var className = self.className.replace(/^\s+|\s+$/g, ''),
                                valArr = arguments;
                            return fn(className, valArr)
                        }
                    }

                    function add_rmv(className, valArr, tag) {
                        for (var i in valArr) {
                            if (typeof valArr[i] !== 'string' || !!~valArr[i].search(/\s+/g)) throw TypeError('the type of value is error')
                            var temp = valArr[i]
                            var flag = !!~className.search(new RegExp('(\\s+)?' + temp + '(\\s+)?'))
                            if (tag === 1) {
                                !flag ? className += ' ' + temp : ''
                            } else if (tag === 2) {
                                flag ? className = className.replace(new RegExp('(\\s+)?' + temp), '') : ''
                            }
                        }
                        self.className = className;
                        return tag;
                    }

                    return {
                        add: update(function (className, valArr) {
                            add_rmv(className, valArr, 1)
                        }),
                        remove: update(function (className, valArr) {
                            add_rmv(className, valArr, 2)
                        }),
                        toggle: function (value) {
                            if (typeof value !== 'string' || arguments.length === 0) throw TypeError("Failed to execute 'toggle' on 'DOMTokenList': 1 argument(string) required, but only 0 present.")
                            if (arguments.length === 1) {
                                this.contains(value) ? this.remove(value) : this.add(value)
                                return
                            }
                            !arguments[1] ? this.remove(value) : this.add(value)
                        },
                        contains: update(function (className, valArr) {
                            if (valArr.length === 0) throw TypeError("Failed to execute 'contains' on 'DOMTokenList': 1 argument required, but only 0 present.")
                            if (typeof valArr[0] !== 'string' || !!~valArr[0].search(/\s+/g)) return false
                            return !!~className.search(new RegExp(valArr[0]))
                        }),
                        item: function (index) {
                            typeof index === 'string' ? index = parseInt(index) : ''
                            if (arguments.length === 0 || typeof index !== 'number') throw TypeError("Failed to execute 'toggle' on 'DOMTokenList': 1 argument required, but only 0 present.")
                            var claArr = self.className.replace(/^\s+|\s+$/, '').split(/\s+/)
                            var len = claArr.length
                            if (index < 0 || index >= len) return null
                            return claArr[index]
                        }
                    }
                }
            });
        }
    }

    // 播放声音
    $iziToast.playSound = function (src) {
        if (!(src.indexOf('http') == 0)) {
            src = '/static/uglcu/notice/' + src + '.wav';
        }
        if (!!window.ActiveXObject || "ActiveXObject" in window) {  // IE
            var embed = document.noticePlay;
            if (embed) {
                embed.remove();
            }
            embed = document.createElement('embed');
            embed.setAttribute('name', 'noticePlay');
            embed.setAttribute('src', src);
            embed.setAttribute('autostart', true);
            embed.setAttribute('loop', false);
            embed.setAttribute('hidden', true);
            document.body.appendChild(embed);
            embed = document.noticePlay;
            embed.volume = 100;
        } else {   // 非IE
            var audio = document.createElement('audio');
            audio.setAttribute('hidden', true);
            audio.setAttribute('src', src);
            document.body.appendChild(audio);
            audio.addEventListener('ended', function () {
                audio.parentNode.removeChild(audio);
            }, false);
            audio.play();
        }
    };

    // 不同主题的通知
    forEach(THEMES, function (theme, name) {
        $iziToast[name] = function (options) {
            var settings = extend(CONFIG, options || {});
            settings = extend(theme, settings || {});
            this.show(settings);
        };
    });


    uglcw.extend(ui, {
        info: function (message) {
            $iziToast.msg(message, {icon: 5});
        },
        success: function (message) {
            $iziToast.msg(message, {icon: 1});
        },

        error: function (message) {
            $iziToast.msg(message, {icon: 2});
        },

        warning: function (message) {
            $iziToast.msg(message, {icon: 3});

        },
        progress: function (message) {
            return $iziToast.msg(message, {icon: 4, close: true});
        },
        mute: function () {
            $iziToast.destroy();
        },
        toast: function (msg) {
            layer.msg(msg);
        },
        confirm: function (msg, yes, cancel, o) {
            var click = false;
            var i = layer.confirm(msg, uglcw.extend({
                offset: '150px',
                success: function (layero, index) {
                    var that = this;
                    that.enterEsc = function (e) {
                        if (e.keyCode === 13) {
                            return that.yes.call(that, layero, index);
                        } else if (e.keyCode === 27) {
                            return that.btn2.call(that, layero, index);
                        }
                    };
                    $(document).on('keydown', this.enterEsc);
                },
                end: function () {
                    $(document).off('keydown', this.enterEsc);
                }
            }, o), function () {
                if(click){
                    return
                }
                click = true;
                if (yes && $.isFunction(yes)) {
                    var ret = yes();
                    if (ret !== undefined || !ret) {
                        layer.close(i);
                    }
                }
            }, function () {
                if (cancel && $.isFunction(cancel)) {
                    cancel();
                }
                layer.close(i);
            })
        },

        notice: function (o) {
            o.title = o.title || "";
            o.message = o.desc || o.message || "";
            o.type = o.type || 'info';
            o.audio = o.audio + "";
            o.timeout = o.timeout === undefined ? 5000 : o.timeout;
            if (o.type === 'close') {
                return $iziToast.destroy();
            }
            $iziToast[o.type](o);
        }
    })
    ;


})(jQuery, window, uglcw);

(function (jQuery, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var util = uglcw.util;
    var WIDGET_CACHE_KEY = 'qui';

    kendo.culture('zh-CN');

    uglcw.extend(uglcw.ui, {
        get: function (context) {
            if ($(context).data(WIDGET_CACHE_KEY)) {
                return $(context).data(WIDGET_CACHE_KEY);
            }
            var role = ui.attr(context, 'role');
            var widget = $(context);
            if (widget) {
                widget = this.create(context, role);
            }
            return widget;
        },
        create: function (context, role) {
            var widget = null;
            if (role === undefined) {
                console.error('unknown widget ', context, role);
                return;
            }
            role = role.toLowerCase();
            switch (role) {
                case 'textbox':
                    widget = new ui.TextBox(context);
                    break;
                case 'checkbox':
                    widget = new ui.CheckBox(context);
                    break;
                case 'radio':
                    widget = new ui.Radio(context);
                    break;
                case 'numeric':
                    widget = new ui.Numeric(context);
                    break;
                case 'datepicker':
                    widget = new ui.DatePicker(context);
                    break;
                case 'datetimepicker':
                    widget = new ui.DateTimePicker(context);
                    break;
                case 'daterangepicker':
                    widget = new ui.DateRangePicker(context);
                    break;
                case 'timepicker':
                    widget = new ui.TimePicker(context);
                    break;
                case 'button':
                    widget = new ui.Button(context);
                    break;
                case 'buttongroup':
                    widget = new ui.ButtonGroup(context);
                    break;
                case 'validator':
                    widget = new ui.Validator(context);
                    break;
                case 'autocomplete':
                    widget = new ui.AutoComplete(context);
                    break;
                case 'colorpicker':
                    widget = new ui.ColorPicker(context);
                    break;
                case 'combobox':
                    widget = new ui.ComboBox(context);
                    break;
                case 'combogrid':
                    widget = new ui.ComboGrid(context);
                    break;
                case 'dropdownlist':
                    widget = new ui.DropDownList(context);
                    break;
                case 'dropdowntree':
                    widget = new ui.DropDownTree(context);
                    break;
                case 'maskedtextbox':
                    widget = new ui.MaskedTextBox(context);
                    break;
                case 'multiselect':
                    widget = new ui.MultiSelect(context);
                    break;
                case 'slider':
                    widget = new ui.Slider(context);
                    break;
                case 'tabs':
                    widget = new ui.Tabs(context);
                    break;
                case 'grid':
                    widget = new ui.Grid(context);
                    break;
                case 'grid-advanced':
                    widget = new ui.AdvancedGrid(context);
                    break;
                case 'tree':
                    widget = new ui.Tree(context);
                    break;
                case 'tooltip':
                    widget = new ui.Tooltip(context);
                    break;
                case 'modal':
                    widget = new ui.Modal(context);
                    break;
                case 'upload':
                    widget = new ui.Upload(context);
                    break;
                case 'editor':
                    widget = new ui.Editor(context);
                    break;
                case 'accordion':
                    widget = new ui.Accordion(context);
                    break;
                case 'wangeditor':
                    widget = new ui.WangEditor(context);
                    break;
                case 'gridselector':
                    widget = new ui.GridSelector(context);
                    break;
                case 'tag':
                    widget = new ui.Tag(context);
                    break;
                case 'album':
                    widget = new ui.Album(context);
                    break;
                case 'scheduler':
                    widget = new ui.Scheduler(context);
                    break;
                case 'qrcode':
                    widget = new ui.QRCode(context);
                    break;
                case 'barcode':
                    widget = new ui.Barcode(context);
                    break;
                case 'resizable':
                    widget = new ui.Resizable(context);
                    break;
                default:
                    console.error('unknown widget', context, role);
                    break;
            }
            return widget;
        }
    });

    uglcw.extend(uglcw.util, {
        template: kendo.template,
        toString: kendo.toString,
        uuid: function () {
            return kendo.guid().replace(/-/g, '');
        }
    })

})(jQuery, window, uglcw);

(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Validator(obj) {
        ui.KUI.call(this, obj);
    }

    Validator.prototype = new ui.KUI();
    Validator.prototype.constructor = Validator;

    Validator.defaultOptions = {
        //errorTemplate: '<span class="uglcw-err-msg k-invalid-msg">#= message#</span>',
        validateOnBlur: true,
       /* errorTemplate: '<div class="k-widget k-tooltip k-tooltip-validation"' +
            'style="margin:0.5em"><span class="k-icon k-warning"> </span>' +
            '#=message#<div class="k-callout k-callout-n"></div></div>'*/
    };


    Validator.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        this.lazy = o.lazy || false
        $(this._obj).kendoValidator($.extend(Validator.defaultOptions, o));
        this.initEvent(o);
    }

    Validator.prototype.lazy = function () {
        return this.lazy;
    }

    Validator.prototype.value = function (v) {

    }

    Validator.prototype.enable = function (bool) {
    }

    Validator.prototype.readonly = function (bool) {
    }

    Validator.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Validator.prototype.element = function () {
        return this.k().wrapper;
    }

    Validator.prototype.validate = function () {
        var result = this.k().validate();
        return result;
    }

    Validator.prototype.clear = function () {
        return this.k().hideMessages();
    }

    uglcw.extend(ui, {
        'Validator': Validator
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    uglcw.extend(ui, {
        loading: function (context) {
            context = context || 'body';
            kendo.ui.progress($(context), true);
        },
        loaded: function (context) {
            context = context || 'body';
            kendo.ui.progress($(context), false)
        }
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Tooltip(obj) {
        ui.KUI.call(this, obj);
    }

    Tooltip.prototype = new ui.KUI();
    Tooltip.prototype.constructor = Tooltip;

    Tooltip.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).kendoTooltip($.extend({
            autoHide: true,
            position: 'top'
        }, o));
        this.initEvent(o);
    }

    Tooltip.prototype.show = function(){
        this.k().show();
    }

    Tooltip.prototype.hide = function(){
        this.k().hide();
    }

    Tooltip.prototype.value = function (v) {

    }

    Tooltip.prototype.enable = function (bool) {
    }

    Tooltip.prototype.readonly = function (bool) {
    }

    Tooltip.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Tooltip.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Tooltip': Tooltip
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var util = uglcw.util;
    var Tooltip = ui.Tooltip;

    function TextBox(obj) {
        ui.KUI.call(this, obj);
    }

    TextBox.prototype = new ui.KUI();
    TextBox.prototype.constructor = TextBox;

    TextBox.defaults = {
        clearable: true,
        tooltip: false
    };

    TextBox.prototype.init = function (o) {
        var that = this;
        o = uglcw.extend({}, TextBox.defaults, o);
        ui.KUI.prototype.init.call(this, o);
        var $element = $(this._obj);

        var hidden = $element.prop('type') === 'hidden';
        this.hidden = hidden;
        var wrapper = $element;
        if ($element.is("input")) {
            $element.removeClass("k-textbox");
            $element.wrap('<div class="k-textbox ' + (o.icon ? ' k-space-right' : '') + '"></div>');
            wrapper = $($element.closest('.k-textbox'));
            if (hidden) {
                wrapper.hide();
            }
            if (o.icon) {
                $element.after('<i class="' + o.icon + '"></i>')
            }
            if (o.clearable) {
                wrapper.addClass('k-textbox-clearable');
                var clearButton = $('<span unselectable="on" class="k-icon k-clear-value k-i-close" title="clear" role="button" tabindex="-1"></span>');
                clearButton.insertAfter($element);
                clearButton.on('click', function (e) {
                    that.value('');
                    $element.trigger('change');
                });
                if (!that.value()) {
                    wrapper.find('.k-i-close').addClass('k-hidden');
                }

                wrapper.on('mouseenter', function () {
                    $(this).addClass('k-state-hover');
                });

                wrapper.on('mouseleave', function () {
                    $(this).removeClass('k-state-hover');
                });

                var handleChangeEvent = function () {
                    if (!that.value()) {
                        wrapper.find('.k-i-close').addClass('k-hidden');
                    } else {
                        wrapper.find('.k-i-close').removeClass('k-hidden');
                    }
                };

                $element.on('change input', handleChangeEvent);
            }
            wrapper.attr('style', $element.attr('style'));
            $element.removeAttr('style');

        }
        if ($element.is(":checkbox")) {
            $element[0].checked = util.toBoolean(ui.attr(this._obj, 'value'));
        } else if ($element.is("textarea")) {
            $element.addClass('k-textbox');
            $element.css("width", "100%");
        }

        if ($element.is(":disabled")) {
            this.enable(false);
        }
        if ($element.attr('readonly')) {
            this.readonly(true);
        }
        if (o.tooltip) {
            new Tooltip(wrapper).init({
                content: ui.attr(that._obj, 'label') || o.tooltip
            });
        }
        if (o.change) {
            o.on('change', o.change);
        }
        this.initEvent(o);
    }

    TextBox.prototype.hidden = function () {
        return this.hidden;
    }

    TextBox.prototype.value = function (v) {
        if (v === undefined) {
            if ($(this._obj).is(":checkbox")) {
                return $(this._obj)[0].checked;
            } else if ($(this._obj).is('input') || $(this._obj).is('textarea')) {
                return $(this._obj).val();
            } else {
                return $(this._obj).html();
            }

        } else {
            if ($(this._obj).is(":checkbox")) {
                return $(this._obj)[0].checked = util.toBoolean(v);
            } else if ($(this._obj).is('input') || $(this._obj).is('textarea')) {
                var old = $(this._obj).val();
                $(this._obj).val(v);
                if (old != v) {
                    $(this._obj).trigger("change");//隐藏域触发更新 mvvm
                }
            } else {
                $(this._obj).html(v);
            }
        }
    }

    TextBox.prototype.enable = function (bool) {
        if (bool == undefined) {
            return !$(this._obj).prop('disabled');
        } else {
            if (bool) {
                $(this._obj).closest('.k-textbox').removeClass("k-state-disabled");
            } else {
                $(this._obj).closest('.k-textbox').addClass("k-state-disabled");
            }
            $(this._obj).prop('disabled', !util.toBoolean(bool));
        }
    };

    TextBox.prototype.readonly = function (bool) {
        if (bool == undefined) {
            return !$(this._obj).prop('readonly');
        } else {
            if (bool) {
                $(this._obj).closest('.k-textbox').addClass("k-state-disabled");
            } else {
                $(this._obj).closest('.k-textbox').removeClass("k-state-disabled");
            }
            $(this._obj).prop('readonly', util.toBoolean(bool));
        }
    };

    uglcw.extend(ui, {TextBox: TextBox})

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var util = uglcw.util;

    function CheckBox(obj) {
        ui.KUI.call(this, obj);
    }

    CheckBox.defaults = {
        type: 'number' //boolean|number
    }

    CheckBox.prototype = new ui.KUI();
    CheckBox.prototype.constructor = CheckBox;

    CheckBox.prototype.init = function (o) {
        var options = uglcw.extend({}, CheckBox.defaults, o);
        ui.KUI.prototype.init.call(this, options);
        var $element = $(this._obj);
        if ($element.is(":checkbox")) {
            $element.addClass('k-checkbox');
            var id = $element.attr('id');
            if (id) {
                $('label[for=' + id + ']:not(.control-label)').addClass('k-checkbox-label')
            }
            $element[0].checked = util.toBoolean(ui.attr(this._obj, 'value'));
        }
        this.options = options;
        this.initEvent(o);
    }

    CheckBox.prototype.value = function (v) {
        if (v == undefined) {
            if ($(this._obj).is(":checkbox")) {
                if (this.options.type == 'number') {
                    return util.toInt($(this._obj)[0].checked);
                }
                return $(this._obj)[0].checked;
            }
            return $(this._obj).val();
        } else {
            if ($(this._obj).is(":checkbox")) {
                return $(this._obj)[0].checked = util.toBoolean(v);
            } else {
                $(this._obj).val(v);
                $(this._obj).trigger("change");//隐藏域触发更新 mvvm
            }
        }
    }

    CheckBox.prototype.enable = function (bool) {
        if (bool == undefined) {
            return !$(this._obj).prop('disabled');
        } else {
            if (bool) {
                $(this._obj).removeClass("k-state-disabled");
            } else {
                $(this._obj).addClass("k-state-disabled");
            }
            $(this._obj).prop('disabled', !util.toBoolean(bool));
        }
    };

    CheckBox.prototype.readonly = function (bool) {
        if (bool == undefined) {
            return !$(this._obj).prop('readonly');
        } else {
            if (bool) {
                $(this._obj).addClass("k-state-disabled");
            } else {
                $(this._obj).removeClass("k-state-disabled");
            }
            $(this._obj).prop('readonly', util.toBoolean(bool));
        }
    };

    uglcw.extend(ui, {'CheckBox': CheckBox})

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var util = uglcw.util;

    function Radio(obj) {
        ui.KUI.call(this, obj);
    }


    Radio.defaults = {
        //布局方式 horizontal|vertical
        layout: 'horizontal',
        //文本字段名
        dataTextField: "text",
        //值字段名
        dataValueField: "value",
        //数据源
        dataSource: [],
        //默认选中的值
        value: null,
        //是否禁用
        disabled: false,
        //是否设置默认值
        checkDefault: true

    }

    Radio.prototype = new ui.KUI();
    Radio.prototype.constructor = Radio;

    Radio.prototype.init = function (o) {
        var that = this;
        ui.KUI.prototype.init.call(this, o);
        var options = $.extend({}, Radio.defaults, o);
        this.options = options;
        var $element = $(this._obj);
        $element.html('');
        $element.addClass('uglcw-radio');
        if (options.layout === 'horizontal') {
            $element.addClass('horizontal');
        }
        var model = ui.attr($element, 'model');
        var value = ui.attr($element, 'value');
        var dataSource = options.dataSource || [];
        if (options.checkDefault) {
            value = value === undefined ? dataSource[0].value : value;
        }
        var html = util.template(
            '# for(var i=0; i< data.dataSource.length; i++){ #' +
            ' <li><input type="radio" #= data.dataSource[i].disabled? "disabled": ""#  name="' + model + '" #= data.value== data.dataSource[i].value? "checked": ""#  class="k-radio" id="' + model + '_radio_#= data.dataSource[i].value#" value="#= data.dataSource[i].value#"><label class="k-radio-label" for="' + model + '_radio_#= data.dataSource[i].value#">#=data.dataSource[i].text#</label></li>' +
            '# } #'
        )({value: value, dataSource: dataSource});
        $element.append(html);
        $(that._obj).find('[type=radio]').on('change', function () {
            if ($.isFunction(options.change)) {
                options.change(that.value())
            }
        });
        this.initEvent(options);
    }

    /**
     *
     * @param model
     * @param v
     */
    Radio.prototype.bind = function (model, v) {
        if (v !== undefined) {
            this.value(v[model]);
        } else {
            //同一个bind context下有多个model相同的radio只取选中的那个
            var result = {};
            if (this.checked()) {
                result[model] = this.value();
            }
            return result
        }
    };

    Radio.prototype.checked = function () {
        return !!$(this._obj).find("input:radio:checked").length;
    };

    Radio.prototype.value = function (v) {
        var that = this;
        if (v === undefined) {
            return $(this._obj).find("input:radio:checked").val();
        } else {
            $(this._obj).find('input:radio:checked').prop('checked', false);
            if (v !== '') {
                var t = $(this._obj).find("input:radio[value=" + v + "]");
                if (t) {
                    t.prop('checked', true);
                    $(that._obj).find('[type=radio]').trigger('change');
                }
            }
        }
    }

    Radio.prototype.enable = function (bool) {
        if (bool == undefined) {
            return $(this._obj).find("input:radio[disabled]").length === 0;
        } else {
            $(this._obj).find("input:radio").prop('disabled', !util.toBoolean(bool));
        }
    };

    Radio.prototype.readonly = function (bool) {
        if (bool == undefined) {
            return !$(this._obj).find("input:radio[readonly]").prop('readonly');
        } else {
            $(this._obj).find("input:radio").prop('readonly', util.toBoolean(bool));
        }
    };

    uglcw.extend(ui, {'Radio': Radio})

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var Tooltip = ui.Tooltip;
    var keys = kendo.keys;

    //重载_keydown方法，利用step控制是否允许上下按键增减数值
    kendo.ui.NumericTextBox.fn._keydown = function (e) {
        var that = this, key = e.keyCode;
        that._key = key;
        if (key == keys.DOWN) {
            that.options.step ? that._step(-1) : that._change(that.element.val());
        } else if (that.options.step && key == keys.UP) {
            that.options.step ? that._step(1) : that._change(that.element.val());
        } else if (key == keys.ENTER) {
            that._change(that.element.val());
        } else if (key != keys.TAB) {
            that._typing = true;
        } else if (key = keys.SPACEBAR){
            e.preventDefault()
        }
    }

    kendo.ui.NumericTextBox.fn._keypress = function (e) {
        if (e.which === 0 || e.metaKey || e.ctrlKey || e.keyCode === keys.BACKSPACE || e.keyCode === keys.ENTER) {
            return;
        }
        var that = this;
        var min = that.options.min;
        var element = that.element;
        var selection = kendo.caret(element);
        var selectionStart = selection[0];
        var selectionEnd = selection[1];
        var character = String.fromCharCode(e.which);
        var numberFormat = that._format(that.options.format);
        var isNumPadDecimal = that._key === keys.NUMPAD_DOT;
        var value = element.val();
        var isValid;
        if (isNumPadDecimal) {
            character = numberFormat['.'];
        }
        value = value.substring(0, selectionStart) + character + value.substring(selectionEnd);
        isValid = that._numericRegex(numberFormat).test(value);
        if (isValid && isNumPadDecimal) {
            element.val(value);
            kendo.caret(element, selectionStart + character.length);
            e.preventDefault();
        } else if (min !== null && min >= 0 && value.charAt(0) === '-' || !isValid) {
            that._addInvalidState();
            //e.preventDefault();
            //直接将空格事件冒泡给document
            var event = $.Event('keyup'); event.which = event.keyCode = e.keyCode; $(document).trigger(event);
            that._key = 0;
            return false
        }
        that._key = 0;
    };


    function Numeric(obj) {
        ui.KUI.call(this, obj);
    }

    Numeric.prototype = new ui.KUI();
    Numeric.prototype.constructor = Numeric;

    Numeric.defaults = {
        spinners: false,
        tooltip: false,
        step: false,
        round: false
    };

    Numeric.prototype.init = function (o) {
        var that = this;
        o = uglcw.extend({}, Numeric.defaults, o);
        this.options = o;
        ui.KUI.prototype.init.call(this, o);
        var widget = $(this._obj).kendoNumericTextBox($.extend({
            culture: 'zh-CHS',
            decimals: null
        }, o)).data('kendoNumericTextBox');
        this.initEvent(o);
        widget.wrapper.find('.k-input').on('focus', function () {
            var input = $(this);
            clearTimeout(input.data('selectTimeId'));
            var selectTimeId = setTimeout(function () {
                input.select();
            });
            input.data('selectTimeId', selectTimeId);
        }).blur(function (e) {
            clearTimeout($(this).data('selectTimeId'));
        })
        if (o.tooltip) {
            new Tooltip(widget.wrapper).init({
                content: ui.attr(that._obj, 'label') || o.tooltip
            })
        }
    }

    Numeric.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    Numeric.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    Numeric.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    Numeric.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Numeric.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Numeric': Numeric
    })

})(jQuery, window, uglcw);

(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function DatePicker(obj) {
        ui.KUI.call(this, obj);
    }

    DatePicker.prototype = new ui.KUI();
    DatePicker.prototype.constructor = DatePicker;

    DatePicker.defaults = {
        culture: "zh-CH",
        format: "yyyy-MM-dd",
        editable: true,
        dateInput: true
    }


    DatePicker.prototype.init = function (o) {
        var that = this;
        var opts = uglcw.extend({}, DatePicker.defaults, o);
        this.options = opts;
        ui.KUI.prototype.init.call(this, opts);
        $(this._obj).attr('type', 'date');
        $(this._obj).kendoDatePicker(opts);
        var widget = this.k();
        widget.element.on('click', function () {
            widget.open();
        });
        widget.wrapper.addClass('k-datepicker-clearable');
        var clearButton = $('<span unselectable="on" class="k-icon k-clear-value k-i-close" title="clear" role="button" tabindex="-1"></span>');
        clearButton.insertBefore(widget.wrapper.find('.k-select'));
        clearButton.on('click', function (e) {
            widget.value(null);
            widget.trigger('change');
        });
        if (!widget.value()) {
            widget.wrapper.find('.k-i-close').addClass('k-hidden');
        }
        widget.bind('change', function () {
            if (!this.value()) {
                widget.wrapper.find('.k-i-close').addClass('k-hidden');
            } else {
                widget.wrapper.find('.k-i-close').removeClass('k-hidden');
            }
        });

        if (!opts.editable) {
            $(this._obj).attr('readonly', true);
        }
        if(opts.tooltip){
            new ui.Tooltip(widget.wrapper).init({
                content: ui.attr(that._obj, 'label') || opts.tooltip
            });
        }
        this.initEvent(opts);
    };

    DatePicker.prototype.value = function (v) {
        var that = this
        var k = this.k();
        if (v == undefined) {
            var val = k.value();
            if (!val) {
                return null;
            }
            return kendo.toString(val, that.options.format || 'yyyy-MM-dd');
        }

        k.value($.isNumeric(v) ? new Date(v) : v);
    }

    DatePicker.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    DatePicker.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    DatePicker.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    DatePicker.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'DatePicker': DatePicker
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var util = uglcw.util;

    function DateTimePicker(obj) {
        ui.KUI.call(this, obj);
    }

    DateTimePicker.prototype = new ui.KUI();
    DateTimePicker.prototype.constructor = DateTimePicker;

    DateTimePicker.defaults = {
        culture: "zh-CH",
        format: "yyyy-MM-dd HH:mm:ss",
        editable: true,
        tooltip: false,
        ARIATemplate: "选择时间"
    };

    DateTimePicker.prototype.init = function (o) {
        var uuid = util.uuid();

        var that = this;
        var opts = uglcw.extend({
            footer: '<a class="k-link" href="javascript:void(0);" data-uid="' + uuid + '">选择时间<i style="margin-bottom: 2px;" class="k-icon k-i-clock"></i></a>'
        }, DateTimePicker.defaults, o);
        this.options = opts;
        ui.KUI.prototype.init.call(this, opts);
        $(this._obj).kendoDateTimePicker(opts);
        var widget = this.k();
        widget.element.on('click', function () {
            widget.close('time');
            widget.open();
            //屏蔽默认的选择当天日期事件
            widget.dateView.div.find('.k-footer a.k-link.k-nav-today').off('click');
            widget.dateView.div.find('.k-footer a.k-link.k-nav-today').on('click', function(e){
                e.preventDefault();
            })
        });
        widget.wrapper.addClass('k-datepicker-clearable');
        var clearButton = $('<span unselectable="on" class="k-icon k-clear-value k-i-close" title="clear" role="button" tabindex="-1"></span>');
        clearButton.insertBefore(widget.wrapper.find('.k-select'));
        clearButton.on('click', function (e) {
            widget.value(null);
            widget.trigger('change');
        });
        if (!widget.value()) {
            widget.wrapper.find('.k-i-close').addClass('k-hidden');
        }
        widget.bind('change', function () {
            if (!this.value()) {
                widget.wrapper.find('.k-i-close').addClass('k-hidden');
            } else {
                widget.wrapper.find('.k-i-close').removeClass('k-hidden');
            }
        });
        if (opts.tooltip) {
            new ui.Tooltip(widget.wrapper).init({
                content: ui.attr(that._obj, 'label') || opts.tooltip
            });
        }
        $(document).on('click', '[data-uid=' + uuid + ']', function (e) {
            e.preventDefault();
            e.stopPropagation();
            widget.close("date");
            widget.open("time");
        });
        this.initEvent(opts);
    }

    DateTimePicker.prototype.value = function (v) {
        var that = this;
        var k = this.k();
        if (v == undefined) {
            var val = k.value();
            if (!val) {
                return null;
            }
            return kendo.toString(val, that.options.format || 'yyyy-MM-dd HH:mm:ss');
        }

        k.value($.isNumeric(v) ? new Date(v) : v);
    }

    DateTimePicker.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    DateTimePicker.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    DateTimePicker.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    DateTimePicker.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'DateTimePicker': DateTimePicker
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function DateRangePicker(obj) {
        ui.KUI.call(this, obj);
    }

    DateRangePicker.prototype = new ui.KUI();
    DateRangePicker.prototype.constructor = DateRangePicker;

    DateRangePicker.prototype.init = function (o) {
        var that = this;
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).kendoDateRangePicker($.extend({
            culture: "zh-CH",
            format: "yyyy-MM-dd",
            editable: false,
        }, o));
        if(o.tooltip){
            var wrapper = this.k().wrapper;
            new ui.Tooltip(wrapper.find('span.k-dateinput:eq(0)')).init({
                content: ui.attr(that._obj, 'label-start') || '开始时间'
            });
            new ui.Tooltip(wrapper.find('span.k-dateinput:eq(1)')).init({
                content: ui.attr(that._obj, 'label-end') || '结束时间'
            });
        }
        this.initEvent(o);
    }

    DateRangePicker.prototype.bind = function (model, v) {
        var models = model.split(',');
        var k = this.k();
        if (v == undefined) {
            var result = {};
            var val = k.range();

            if (models.length == 2) {
                result[models[0]] = kendo.toString(val.start, k.options.format || 'yyyy-MM-dd');
                result[models[1]] = kendo.toString(val.end, k.options.format || 'yyyy-MM-dd');
            }
            return result;
        }
        k.range({
            start: v[models[0]],
            end: v[models[1]]
        })
    }

    DateRangePicker.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    DateRangePicker.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    DateRangePicker.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    DateRangePicker.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'DateRangePicker': DateRangePicker
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function TimePicker(obj) {
        ui.KUI.call(this, obj);
    }

    TimePicker.prototype = new ui.KUI();
    TimePicker.prototype.constructor = TimePicker;

    TimePicker.defaults = {
        culture: "zh-CH",
        format: "HH:mm:ss",
        editable: false,
        tooltip: false
    }

    TimePicker.prototype.init = function (o) {
        var that = this;
        ui.KUI.prototype.init.call(this, o);
        this.options = $.extend({},TimePicker.defaults, o);
        $(this._obj).kendoTimePicker(this.options);
        if(this.options.tooltip){
            new ui.Tooltip(that.k().wrapper).init({
                content: ui.attr(that._obj, 'label') || that.options.tooltip
            })
        }
        this.initEvent(o);
    }

    TimePicker.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            var val = k.value();
            if (!val) {
                return null;
            }
            return kendo.toString(val, k.options.format || 'HH:mm:ss');
        }
        k.value(v);
    }

    TimePicker.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    TimePicker.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    TimePicker.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    TimePicker.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'TimePicker': TimePicker
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Button(obj) {
        ui.KUI.call(this, obj);
    }

    Button.prototype = new ui.KUI();
    Button.prototype.constructor = Button;

    Button.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).kendoButton(o);
        if (o.tooltip) {
            new ui.Tooltip(this._obj).init({
                content: ui.attr(this._obj, 'label') || o.tooltip
            })
        }
        this.initEvent(o);
    }

    Button.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    Button.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    Button.prototype.readonly = function (bool) {
        this.k().enable(!bool);
    }

    Button.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Button.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Button': Button
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function ButtonGroup(obj) {
        ui.KUI.call(this, obj);
    }

    ButtonGroup.prototype = new ui.KUI();
    ButtonGroup.prototype.constructor = ButtonGroup;

    ButtonGroup.defaults = {
        selection: 'single',
        tooltip: false,
        select: function (e) {
            var that = this
            console.log(this, e.indices[0])
            setTimeout(function () {
                $(that.element).find('li:eq(' + e.indices[0] + ')').removeClass('k-state-active k-state-focused')
            }, 100)
        }
    }

    ButtonGroup.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        this.options = uglcw.extend({}, ButtonGroup.defaults, o);
        $(this._obj).kendoButtonGroup(this.options);
        if (this.options.tooltip) {
            $(this._obj).find('li').each(function () {
                var $li = $(this);
                if (ui.attr($li, 'label') || ui.attr($li, 'tooltip')) {
                    new ui.Tooltip($li).init({
                        content: ui.attr($li, 'label') || ui.attr($li, 'tooltip')
                    })
                }
            })
        }
        this.initEvent(o);
    }

    ButtonGroup.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    ButtonGroup.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    ButtonGroup.prototype.readonly = function (bool) {
        this.k().enable(!bool);
    }

    ButtonGroup.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    ButtonGroup.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'ButtonGroup': ButtonGroup
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var keys = kendo.keys;

    kendo.ui.AutoComplete.fn._keydown = function (e) {
        var that = this;
        var key = e.keyCode;
        var listView = that.listView;
        var visible = that.popup.visible();
        var current = listView.focus();
        that._last = key;
        if (key === keys.DOWN) {
            if (visible) {
                this._move(current ? 'focusNext' : 'focusFirst');
            } else if (that.value()) {
                that._filterSource({
                    value: that.ignoreCase ? that.value().toLowerCase() : that.value(),
                    operator: that.options.filter,
                    field: that.options.dataTextField,
                    ignoreCase: that.ignoreCase
                }).done(function () {
                    if (that._allowOpening()) {
                        that._resetFocusItem();
                        that.popup.open();
                    }
                });
            }
            e.preventDefault();
        } else if (key === keys.UP) {
            if (visible) {
                this._move(current ? 'focusPrev' : 'focusLast');
            }
            e.preventDefault();
        } else if (key === keys.HOME) {
            this._move('focusFirst');
        } else if (key === keys.END) {
            this._move('focusLast');
        } else if (key === keys.ENTER || key === keys.TAB) {
            if (key === keys.ENTER && visible) {
                e.preventDefault();
            }
            if (visible && current) {
                var dataItem = listView.dataItemByIndex(listView.getElementIndex(current));
                if (that.trigger('select', {
                    dataItem: dataItem,
                    item: current
                })) {
                    return;
                }
                this._select(current);
            }
            this._blur();
        } else if (key === keys.ESC) {
            if (visible) {
                e.preventDefault();
            } else {
                that._clearValue();
            }
            that.close();
        } else if (that.popup.visible() && (key === keys.PAGEDOWN || key === keys.PAGEUP)) {
            e.preventDefault();
            var direction = key === keys.PAGEDOWN ? 1 : -1;
            listView.scrollWith(direction * listView.screenHeight());
        } else if (key === keys.SPACEBAR) {
            e.preventDefault();
            var event = $.Event('keyup'); event.which = event.keyCode = e.keyCode; $(document).trigger(event);
        } else {
            that.popup._hovered = true;
            that._search();
        }
    };


    function AutoComplete(obj) {
        ui.KUI.call(this, obj);
    }

    AutoComplete.prototype = new ui.KUI();
    AutoComplete.prototype.constructor = AutoComplete;
    AutoComplete.defaults = {
        autoWidth: true,
        filter: 'contains',
        highlightFirst: true,
        noDataTemplate: '暂无数据',
        tooltip: false,
        icon: 'k-i-more-horizontal', //右侧图标
        selectable: false,
    };
    AutoComplete.prototype.init = function (o) {
        var that = this;
        ui.KUI.prototype.init.call(this, o);
        var opts = $.extend({}, AutoComplete.defaults, o);
        if (opts.url) {
            opts.dataSource = {
                serverFiltering: true,
                schema: $.extend({
                    data: function (response) {
                        return response.list || []
                    }
                }, opts.loadFilter),
                transport: {
                    read: {
                        url: opts.url,
                        type: opts.type || 'get',
                        data: opts.data || function () {
                        }
                    }
                },
                requestStart: o.requestStart
            }
        }
        $(this._obj).kendoAutoComplete(opts);
        if (opts.tooltip) {
            new ui.Tooltip(that.k().wrapper).init({
                content: ui.attr(that._obj, 'label') || opts.tooltip
            });
        }
        if (opts.selectable) {
            var wrapper = this.k().wrapper;
            wrapper.addClass('uglcw-autocomplete-selectable');
            $(that._obj).after('<a href="javascript:void(0);" class="k-select k-icon ' + opts.icon + '"></a>');
            $(that._obj).on('dblclick', function () {
                if ($.isFunction(opts.click)) {
                    opts.click.apply(that);
                }
            })
            wrapper.find('.' + opts.icon).on('click', function () {
                if ($.isFunction(opts.click)) {
                    opts.click.apply(that);
                }
            })
        }
        this.initEvent(opts);
    }

    AutoComplete.prototype.value = function (v) {
        var k = this.k();
        if (v === undefined) {
            return k.value();
        }
        k.value(v);
    }

    AutoComplete.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    AutoComplete.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    AutoComplete.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    AutoComplete.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'AutoComplete': AutoComplete
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function ColorPicker(obj) {
        ui.KUI.call(this, obj);
    }

    ColorPicker.prototype = new ui.KUI();
    ColorPicker.prototype.constructor = ColorPicker;

    ColorPicker.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).kendoColorPicker(o);
        this.initEvent(o);
    }

    ColorPicker.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        if(v == ''){
            v = null;
        }
        k.value(v);
    }

    ColorPicker.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    ColorPicker.prototype.readonly = function (bool) {
    }

    ColorPicker.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    ColorPicker.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'ColorPicker': ColorPicker
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var keys = kendo.keys;

    kendo.ui.ComboBox.fn._keydown = function (e) {
        var that = this, key = e.keyCode;
        that._last = key;
        clearTimeout(that._typingTimeout);
        that._typingTimeout = null;
        if (key === keys.HOME) {
            that._firstItem();
        } else if (key === keys.END) {
            that._lastItem();
        } else if (key === keys.ENTER || key === keys.TAB && that.popup.visible()) {
            var current = that.listView.focus();
            var dataItem = that.dataItem();
            var shouldTrigger = true;
            if (!that.popup.visible() && (!dataItem || that.text() !== that._text(dataItem))) {
                current = null;
            }
            if (current) {
                if (that.popup.visible()) {
                    e.preventDefault();
                }
                dataItem = that.listView.dataItemByIndex(that.listView.getElementIndex(current));
                if (dataItem) {
                    shouldTrigger = that._value(dataItem) !== kendo.ui.List.unifyType(that.value(), typeof that._value(dataItem));
                }
                if (shouldTrigger && that.trigger('select', {
                    dataItem: dataItem,
                    item: current
                })) {
                    return;
                }
                that._userTriggered = true;
                that._select(current).done(function () {
                    that._blur();
                    that._valueBeforeCascade = that._old = that.value();
                });
            } else {
                if (that._syncValueAndText() || that._isSelect) {
                    that._accessor(that.input.val());
                }
                that.listView.value(that.input.val());
                that._blur();
            }
        } else if (key === keys.SPACEBAR) {
            e.preventDefault();
            var event = $.Event('keyup');
            event.which = event.keyCode = e.keyCode;
            $(document).trigger(event);
        } else if (key != keys.TAB && !that._move(e)) {
            that._search();
        } else if (key === keys.ESC && !that.popup.visible() && that.text()) {
            that._clearValue();
        }
    };

    function ComboBox(obj) {
        ui.KUI.call(this, obj);
    }

    ComboBox.prototype = new ui.KUI();
    ComboBox.prototype.constructor = ComboBox;

    ComboBox.defaults = {
        clearButton: true,
        dataTextField: "text",
        dataValueField: "value",
        tooltip: false,
        allowInput: false
    }

    ComboBox.prototype.init = function (o) {
        var that = this;
        ui.KUI.prototype.init.call(this, o);
        var opts = $.extend({}, ComboBox.defaults, o);
        if (opts.url) {
            opts.dataSource = {
                schema: $.extend({
                    data: function (response) {
                        return response.list || []
                    }
                }, opts.loadFilter),
                transport: $.extend({
                    read: {
                        url: opts.url,
                        type: opts.type || 'get',
                        data: opts.data || function () {
                        }
                    }
                }, opts.transport)
            }
        }
        $(this._obj).kendoComboBox(opts);
        var widget = this.k();
        widget.input.on('focus', function () {
            widget.open();
        });
        widget.input.on('click', function () {
            widget.open();
        });
        if (opts.tooltip) {
            new ui.Tooltip(widget.wrapper).init({
                content: ui.attr(that._obj, 'label') || opts.tooltip
            });
        }
        if (!opts.allowInput) {
            widget.input.attr('readonly', true).on('keydown', function (e) {
                if (e.keyCode === 8) {
                    e.preventDefault();
                }
            })
        }
        this.initEvent(o);
    }

    ComboBox.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    ComboBox.prototype.dataItem = function () {
        return this.k().dataItem().toJSON();
    }

    ComboBox.prototype.bind = function (model, v) {
        if (model.indexOf(',') === -1) {
            if (v === undefined) {
                var result = {};
                result[model] = this.value();
                return result;
            } else {
                return this.value(v[model]);
            }
        } else {
            var fields = model.split(',');
            if (v === undefined) {
                var result = {};
                result[fields[0]] = this.value();
                result[fields[1]] = this.k().text()
                return result;
            } else {
                return this.value(v[fields[0]]);
                //this.k().text(v[fields[1]]);
            }
        }
    }

    ComboBox.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    ComboBox.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    ComboBox.prototype.k = function () {
        return $(this._obj).data('kendoComboBox');
    }

    ComboBox.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'ComboBox': ComboBox
    })

})(jQuery, window, uglcw);

(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function ComboGrid(obj) {
        ui.KUI.call(this, obj);
    }

    ComboGrid.prototype = new ui.KUI();
    ComboGrid.prototype.constructor = ComboGrid;

    ComboGrid.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).kendoMultiColumnComboBox(o);
        this.initEvent(o);
    }

    ComboGrid.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    ComboGrid.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    ComboGrid.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    ComboGrid.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    ComboGrid.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'ComboGrid': ComboGrid
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function DropDownList(obj) {
        ui.KUI.call(this, obj);
    }

    DropDownList.prototype = new ui.KUI();
    DropDownList.prototype.constructor = DropDownList;

    DropDownList.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).kendoDropDownList(o);
        this.initEvent(o);
    }

    DropDownList.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    DropDownList.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    DropDownList.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    DropDownList.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    DropDownList.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'DropDownList': DropDownList
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function DropDownTree(obj) {
        ui.KUI.call(this, obj);
    }

    function visit(data, opts) {
        if (data) {
            $(data).each(function (i, node) {
                node.expanded = $.isFunction(opts.expandable) ? opts.expandable(node) : node.expanded;
                node.checked = $.isFunction(opts.checkable) ? opts.checkable(node) : node.checked;
                if (node[opts.children] && node[opts.children].length > 0) {
                    node.items = node[opts.children];
                    delete node[opts.children];
                    visit(node.items, opts);
                }
            })
        }
    }

    DropDownTree.prototype = new ui.KUI();
    DropDownTree.prototype.constructor = DropDownTree;
    DropDownTree.defaults = {
        dataTextField: 'text',
        dataValueField: 'id',
        autoWidth: true,
        filter: 'none',
        noDataTemplate: '暂无数据',
        children: 'children',
        lazy: true,
        initLevel: 2,
        checkAllTemplate: '全选',
        tooltip: false
    };

    DropDownTree.prototype.init = function (o) {
        var that = this;
        var opts = uglcw.extend({}, DropDownTree.defaults, o);
        this.options = opts;
        ui.KUI.prototype.init.call(this, o);
        var children = {
            schema: {
                data: function (response) {
                    var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                    if (opts.flat) {
                        root = util.arrayToTree(root, opts.flat)
                    }
                    visit(root, opts);
                    return root
                },
                model: {
                    id: opts.id || 'id',
                    hashChildren: opts.hasChildren || function (node) {
                        return node.state === 'closed'
                    },
                }
            },
            transport: {
                read: {
                    url: opts.url,
                    type: opts.type || 'get',
                    dataType: 'json',
                    data: opts.data || function () {
                    }
                }
            }
        };
        if (opts.url) {
            if (opts.lazy) {
                $.ajax({
                    async: false,
                    url: opts.initUrl || opts.url,
                    type: opts.dataType || 'get',
                    dataType: 'json',
                    data: opts.data || function () {
                    },
                    success: function (response) {
                        var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                        if (opts.flat) {
                            root = util.arrayToTree(root, opts.flat)
                        }
                        visit(root, that.options);

                        opts.dataSource = {
                            data: root,
                            schema: {
                                model: {
                                    id: opts.id || 'id',
                                    hasChildren: opts.initLevel === 1 ? (opts.hasChildren || function (node) {
                                        return node.state === 'closed'
                                    }) : 'items',
                                    children: opts.initLevel === 1 ? children : {
                                        schema: {
                                            data: 'items',
                                            model: {
                                                id: opts.id || 'id',
                                                hasChildren: opts.hasChildren || function (node) {
                                                    return node.state === 'closed'
                                                },
                                                children: children
                                            },
                                        }
                                    }
                                },
                            },
                        };
                        opts.dataBound = opts.dataBound || function () {
                        }
                        $(that._obj).kendoDropDownTree(opts);
                        that.initEvent(o);
                    }
                })
            } else {
                $.ajax({
                    url: opts.url,
                    type: opts.dataType || 'get',
                    dataType: 'json',
                    async: false,
                    data: opts.data || function () {
                    },
                    success: function (response) {
                        var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                        if (opts.flat) {
                            root = util.arrayToTree(root, opts.flat)
                        }
                        visit(root, opts);
                        opts.dataSource = new kendo.data.HierarchicalDataSource({
                            data: root
                        });
                        $(that._obj).kendoDropDownTree(opts);
                        that.initEvent(o);
                    }
                });
            }

        } else {
            $(that._obj).kendoDropDownTree(opts);
            that.initEvent(o);
        }
    }

    DropDownTree.prototype._initTooltip = function () {
        var that = this;
        if (that.options.tooltip) {
            new ui.Tooltip(that.k().wrapper).init({
                content: ui.attr(that._obj, 'label') || this.options.tooltip
            })
        }
    };

    DropDownTree.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    DropDownTree.prototype.bind = function (model, v) {
        if (model.indexOf(',') === -1) {
            if (v === undefined) {
                var result = {};
                result[model] = this.value();
                return result;
            } else {
                return this.value(v[model]);
            }
        } else {
            var fields = model.split(',');
            if (v === undefined) {
                var result = {};
                result[fields[0]] = this.value();
                result[fields[1]] = this.k().text()
                return result;
            } else {
                this.k().text(v[fields[1]]);
                return this.value(v[fields[0]]);
            }
        }
    }

    DropDownTree.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    DropDownTree.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    DropDownTree.prototype.k = function () {
        return $(this._obj).data('kendoDropDownTree');
    }

    DropDownTree.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'DropDownTree': DropDownTree
    })

})(jQuery, window, uglcw);

(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function MaskedTextBox(obj) {
        ui.KUI.call(this, obj);
    }

    MaskedTextBox.prototype = new ui.KUI();
    MaskedTextBox.prototype.constructor = MaskedTextBox;

    MaskedTextBox.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).kendoMaskedTextBox(o);
        this.initEvent(o);
    }

    MaskedTextBox.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    MaskedTextBox.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    MaskedTextBox.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    MaskedTextBox.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    MaskedTextBox.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'MaskedTextBox': MaskedTextBox
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function MultiSelect(obj) {
        ui.KUI.call(this, obj);
    }

    MultiSelect.prototype = new ui.KUI();
    MultiSelect.prototype.constructor = MultiSelect;

    MultiSelect.defaults = {
        dataTextField: 'text',
        dataValueField: 'value',
        noDataTemplate: '暂无数据',
        tagMode: 'multiple',
        autoClose: false,
        stringify: true,
        tooltip: false,
    };

    MultiSelect.prototype.init = function (o) {
        var that = this;
        var opts = uglcw.extend({}, MultiSelect.defaults, o);
        this.options = opts;
        if (opts.url) {
            opts.dataSource = {
                schema: $.extend({
                    data: function (response) {
                        return response || []
                    }
                }, opts.loadFilter),
                transport: {
                    read: {
                        url: opts.url,
                        type: opts.type || 'get',
                        data: opts.data || function () {
                        }
                    }
                }
            }
        }
        ui.KUI.prototype.init.call(this, opts);
        $(this._obj).kendoMultiSelect(opts);
        if(opts.tooltip){
            new ui.Tooltip(this.k()).init({
                content: ui.attr(that._obj, 'label') || opts.tooltip
            })
        }
        this.initEvent(opts);
    };

    MultiSelect.prototype.value = function (v) {
        var k = this.k();
        if (v === undefined) {
            return this.options.stringify ? k.value().join(',') : k.value();
        }
        if (typeof v == 'string') {
            v = v.split(',')
        }
        k.value(v);
    }

    MultiSelect.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    MultiSelect.prototype.dataItems = function () {
        var dataItems = this.k().dataItems();
        return $.map(dataItems, function (item) {
            return item.toJSON();
        })
    }

    MultiSelect.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    MultiSelect.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    MultiSelect.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'MultiSelect': MultiSelect
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Slider(obj) {
        ui.KUI.call(this, obj);
    }

    Slider.prototype = new ui.KUI();
    Slider.prototype.constructor = Slider;

    Slider.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).kendoSlider(o);
        this.initEvent(o);
    }

    Slider.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    Slider.prototype.enable = function (bool) {
    }

    Slider.prototype.readonly = function (bool) {
    }

    Slider.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Slider.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Slider': Slider
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Tabs(obj) {
        ui.KUI.call(this, obj);
    }

    Tabs.prototype = new ui.KUI();
    Tabs.prototype.constructor = Tabs;

    Tabs.defaults = {
        scrollable: true,//滚动
        animation: false,
        index: 0
    }

    Tabs.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).addClass('uglcw-tabstrip');
        var opts = $.extend({}, Tabs.defaults, o);
        $(this._obj).kendoTabStrip(opts);
        $(this._obj).on('mouseenter', '.k-item', function () {
            $(this).find('.k-loading').show().removeClass('k-complete');
        })
        $(this._obj).on('mouseleave', '.k-item', function () {
            $(this).find('.k-loading').hide().addClass('k-complete');
        })
        this.k().select(opts.index);
        this.initEvent(opts);

    }

    Tabs.prototype.value = function (v) {
        if (v === undefined) {
            return this.select().index();
        }
        this.select(v);
    };

    Tabs.prototype.select = function (index) {
        if (index === undefined) {
            return this.k().select();
        } else {
            this.k().select(index)
        }

    };

    Tabs.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    Tabs.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    Tabs.prototype.k = function () {
        return $(this._obj).data('kendoTabStrip')
    }

    Tabs.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Tabs': Tabs
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var CONFIRM_DIALOG_CACHE_KEY = '_confirm_dialog';
    var STAY_IN_CURRENT_CELL = '_stay_in_current_cell';
    var MOVE_ON_CLOSE = '_move_on_close';
    var DONT_MOVE_ON_CLOSE = '_do_not_move_on_close';
    var EDIT_BY_ENTER = '_edit_by_enter';
    var EDIT_BY_CLICK = '_edit_by_click';

    function Grid(obj) {
        ui.KUI.call(this, obj);
    }

    function hintElement(element) { // Customize the hint
        var grid = kendo.widgetInstance($(element).closest('.uglcw-grid')),
            table = grid.table.clone(), // Clone Grid's table
            wrapperWidth = grid.wrapper.width(), //get Grid's width
            wrapper = $("<div class='k-grid uglcw-grid k-widget uglcw-grid-draggable'></div>").width(wrapperWidth),
            hint;

        table.find("thead").remove(); // Remove Grid's header from the hint
        table.find("tbody").empty(); // Remove the existing rows from the hint
        table.wrap(wrapper); // Wrap the table
        table.append(element.clone().addClass('k-state-selected uglcw-grid-draggable').removeAttr("uid")); // Append the dragged element
        hint = table.parent(); // Get the wrapper
        return hint; // Return the hint element
    }

    /**
     * 列追加属性
     * @param column
     * @param key
     * @param value
     * @param type
     */
    function appendAttribute(column, key, value, type) {
        type = type || '';
        var attr = type ? type + 'Attributes' : 'attributes';
        column[attr] = column[attr] || {};
        var exist = (column[attr][key] || '');
        column[attr][key] = exist ? (exist + ' ' + value) : value;
    }

    //绑定
    function bindResize(element, others, options) {
        others = others || [];
        var doResize = function () {
            var delay = $(element).data('resize_delay');
            if (delay) {
                clearTimeout(delay);
            }
            delay = setTimeout(function () {
                var $grid = $(element);
                uglcw.ui.get($grid).resize();
            }, 20);
            $(element).data('resize_delay', delay);
        };
        $(window).resize(doResize);
        doResize();
    }

    function mergeGrid (grid, mergedColumns){
        if (grid.options.mergeBy && mergedColumns.length > 0) {
            var data = grid.k().dataSource.view().toJSON();
            var start = 0, end = 0, combo = 0;
            var current = '';
            $(data).each(function (i, row) {
                var values = [], isLast = i === data.length - 1;
                $.map(grid.options.mergeBy.split(','), function (col) {
                    values.push(row[col]);
                });
                var mergeBy = values.join('__');
                console.log('mergeBy:'+mergeBy)
                if (i === 0) {
                    current = mergeBy;
                }
                combo += 1;
                console.log(combo, start, end);
                if (current != mergeBy || isLast) {
                    //准备开始下一组，先合并上一组 || 或者最后一条
                    if(current == mergeBy){
                        combo += 1;
                    }
                    var span = end - start;
                    if (combo > 1) {
                        $(mergedColumns).each(function (j, column) {
                            $(grid._obj).find('.uglcw-grid-merged.' + column.field).eq(start).attr('rowspan', combo - 1)
                            $(grid._obj).find('.uglcw-grid-merged.' + column.field).slice(start + 1, start + combo - 1).addClass('uglcw-hide-cell')
                        })
                    }
                    start = i;
                    current = mergeBy
                    combo = 1;
                }
            })
        }
    }

    Grid.prototype = new ui.KUI();
    Grid.prototype.constructor = Grid;
    Grid.defaults = {
        serverAggregates: true,
        rowNumber: false,
        showEditableMark: true, //显示可编辑列标记( 铅笔)
        responsive: [], //响应式高度 window高度- responsive 数组中的元素或数值;
        noRecords: false, //显示无数据
        resizable: true,
        validate: true,
        navigatable: true,
        lockable: true,
        selectable: false,
        align: 'center',
        showHeader: true, //显示表头
        autoBind: true,
        pageSize: 20,
        allowCopy: true,
        autoSync: false,
        autoAppendRow: true, //自动增加一行
        autoMove: true, //是否自动移动
        speedy: {
            className: '',  //限制回车跳转范围
            editMode: false //是否立即进入编辑状态
        },
        serverFiltering: false,
        minHeight: 0, //最小高度

    };
    Grid.prototype.init = function (o) {
        if (this.k()) {
            return;
        }
        o = uglcw.extend({}, Grid.defaults, o);
        ui.KUI.prototype.init.call(this, o);
        var that = this;
        var columns = [], schema = {model: {fields: {}}};
        if (o.id) {
            //指定主键
            schema.model.id = o.id;
        }

        if (o.editable) {
            o.editable = $.extend({}, {
                createAt: 'bottom',
                confirmation: false,
            }, o.editable)
        }

        if (o.checkbox) {
            var checkboxColumn = {
                width: 35,
                selectable: true,
                locked: o.lockable,
                type: 'checkbox',
            };
            if (checkboxColumn.locked) {
                appendAttribute(checkboxColumn, 'class', 'uglcw-grid-locked');
            }
            appendAttribute(checkboxColumn, 'class', 'uglcw-grid-checkbox');
            appendAttribute(checkboxColumn, 'class', 'uglcw-grid-checkbox', 'header');
            columns.push(checkboxColumn);
            o.selectable = false;
        }

        if (o.rowNumber) {
            var numberColumn = {
                width: 35,
                title: '#',
                locked: o.lockable,
                template: '<span class="row-number label-circle"></span>',
            };
            if (numberColumn.locked) {
                appendAttribute(numberColumn, 'class', 'uglcw-grid-locked');
            }
            appendAttribute(numberColumn, 'style', 'text-align: center; padding:0;cursor: move;');
            appendAttribute(numberColumn, 'style', 'text-align: center; padding:0', 'header');
            appendAttribute(numberColumn, 'tabindex', -1);
            columns.push(numberColumn);
        }

        //重写删除确认提示
        var destroyCmd = {
            name: "Delete",
            className: "uglcw-grid-cmd-remove",
            text: "<i class='k-icon k-i-minus'></i>",
            click: function (e) {
                e.preventDefault();
                var td = $(e.target).closest('td');
                var tr = $(td).closest("tr");
                var data = that.k().dataItem(tr);
                uglcw.ui.confirm("是否删除", function () {
                    that.rowIndex = tr.index();
                    that.cellIndex = td.index();
                    $(that._obj).data(STAY_IN_CURRENT_CELL, true);
                    that.k().dataSource.remove(data);
                });
            }
        };

        var insertCmd = {
            name: "Add",
            className: "uglcw-grid-cmd-add",
            text: "<i class='k-icon k-i-plus'></i>",
            click: function (e) {
                e.preventDefault();
                var rowIndex = $(e.target).closest('tr').index();
                var cellIndex = $(e.target).closest('td').index();
                that.rowIndex = rowIndex;
                that.cellIndex = cellIndex;
                that.addRow(null, {index: rowIndex + 1, move: false});
                if (that.options.onInsert && $.isFunction(that.options.onInsert)) {
                    that.options.onInsert.call(that, rowIndex + 1);
                }
            }
        };
        var mergedColumns = []
        $(that._obj).find("[data-field]").each(function (index, th) {
            var column = {
                field: $(th).attr("data-field"), editable: function () {
                    return false
                }
            };


            //设置标题
            column.title = ($(th).text() || column.field || "").trim();
            //获取配置
            var opts = ui.attr(th, "options") || '';
            if (opts.charAt(0) !== '{') {
                opts = '{' + opts + '}';
            }
            try {
                column = uglcw.extend(column, eval('(' + opts + ')'));
            } catch (e) {
                console.error('表格列字段配置解析失败 [' + column.title + ']', opts, e);
            }

            column.locked = o.lockable && column.locked;
            if (column.locked) {
                appendAttribute(column, 'class', 'uglcw-grid-locked')
            }
            if (column.merge) {
                mergedColumns.push(column)
                appendAttribute(column, 'class', 'uglcw-grid-merged ' + column.field)
            }

            column.align = column.align || o.align;
            if (column.align && column.type !== 'checkbox') {
                appendAttribute(column, 'style', 'text-align:' + column.align + ';');
                if (!column.titleAlign) {
                    appendAttribute(column, 'style', 'text-align:' + column.align + ';', 'header');
                }
                appendAttribute(column, 'style', 'text-align:' + column.align + ';', 'footer');
            }
            if (column.titleAlign && column.type !== 'checkbox') {
                appendAttribute(column, 'style', 'text-align:' + column.titleAlign + ';', 'header');
            }
            //字段是否可编辑只接收function类型参数
            if (column.editable !== undefined) {
                if (!$.isFunction(column.editable)) {
                    var editable = column.editable;
                    column.editable = function () {
                        return editable;
                    }
                }
            }
            if (column.editor !== undefined || column.schema !== undefined) {
                column.editable = function () {
                    return true;
                }
            }

            if (column.command) {
                $(that._obj).addClass('uglcw-grid-compact');
                if ($.isArray(column.command)) {
                    var kcmd = [];
                    column.command.forEach(function (cmd) {
                        if (cmd === "destroy") {
                            kcmd.push(destroyCmd)
                        } else if (cmd === 'create') {
                            kcmd.push(insertCmd);
                        } else {
                            kcmd.push(cmd);
                        }
                    });
                    column.command = kcmd;
                } else if (column.command === "destroy") {
                    column.command = [destroyCmd];
                } else if (column.command === 'create') {
                    column.command = [insertCmd];
                }
            }
            //分配编辑器
            if (column.schema) {
                //配置字段格式化
                if (column.schema.type === "timestamp") {
                    column.template = '#= data.' + column.field + ' == null ? "" : kendo.toString(new Date(data.' + column.field + '), "' + (column.schema.format || 'yyyy-MM-dd') + '")#';
                }
                if (column.schema.type === "date") {
                    column.template = '#= data.' + column.field + ' == null ? "" : kendo.toString(data.' + column.field + ', "' + (column.schema.format || 'yyyy-MM-dd') + '")#';
                    column.schema.parse = function (value) {
                        return kendo.toString(value, column.format || 'yyyy-MM-dd');
                    }
                }
                schema.model.fields[column.field] = column.schema;

                if (column.schema && column.editable && column.editable() && column.schema.type === 'number') {
                    column.editor = column.editor || function (container, options) {
                        var model = options.model;
                        var input = $('<input data-bind="value:' + options.field + '"/>');
                        input.appendTo(container);
                        var numeric = new uglcw.ui.Numeric(input);
                        numeric.init({
                            decimals: column.schema.decimals || 2,
                            format: column.format ? column.format.split(":")[1].replace('}', '') : 'n2'
                        });
                    }
                }

            }
            //通过tooltip显示隐藏的信息
            if (column.tooltip) {
                appendAttribute(column, 'show-tooltip', true);
                column.template = column.template || '<span data-role="#=data.' + column.field + ' ? \"tooltip\": \"\"#" title="#=data.' + column.field + ' === undefined || data.' + column.field + ' == null ? \"\" : data.' + column.field + '#">#=data.' + column.field + ' === undefined || data.' + column.field + ' == null ? \"\" : data.' + column.field + ' #</span>'
            }

            if (column.barcode) {
                column.template = column.template || '<span class="uglcw-grid-barcode">#= data.' + column.field + ' || \"\"#</span>'
            }
            if (column.qrcode) {
                column.template = column.template || '<span class="uglcw-grid-qrcode">#= data.' + column.field + ' || \"\"#</span>'
            }
            //必填字段列头加标记
            if (column.validate && column.validate.indexOf("require") !== -1) {
                appendAttribute(column, 'class', 'uglcw-grid-required', 'header');
            }

            if (column.editable && column.editable()) {
                appendAttribute(column, 'class', 'uglcw-grid-editable');
                appendAttribute(column, 'class', 'uglcw-grid-editable', 'header');
            } else {
                if (!column.command) {
                    appendAttribute(column, 'tabindex', -1);
                    appendAttribute(column, 'class', 'uglcw-grid-readonly');
                }
            }
            columns.push(column);
        });

        this._checkable(columns);

        this._obj.schema = schema;
        //合并配置
        var opts = uglcw.extend({}, Grid.defaults, o, {columns: columns});

        var dataSourceOptions = {
            data: opts.dataSource || [],
            autoSync: opts.autoSync,
            schema: schema
        }

        //服务端数据源配置
        if (opts.url) {
            dataSourceOptions.schema = $.extend(dataSourceOptions.schema, {
                data: function (response) {
                    return response.rows || []
                },
                total: function (response) {
                    return response.total || 0;
                },
                aggregates: function (response) {
                    return response.aggregates || {};
                }
            }, opts.loadFilter);
            dataSourceOptions.serverPaging = true;
            dataSourceOptions.pageSize = opts.pageSize;
            dataSourceOptions.batch = true;
            dataSourceOptions.serverAggregates = opts.serverAggregates;
            dataSourceOptions.serverFiltering = opts.serverFiltering;
            dataSourceOptions.transport = {
                read: {
                    url: opts.url,
                    type: opts.type || 'get',
                    contentType: opts.contentType,
                    dataType: opts.dataType || 'json',
                    data: opts.data || function (param) {
                        param.rows = param.pageSize;
                        delete param['take'];
                        delete param['skip'];
                        delete param['aggregate'];
                        delete param['pageSize'];
                        //查询区域选择器
                        if (opts.criteria) {
                            var criteria = ui.bind(opts.criteria);
                            param = uglcw.extend(param, criteria);
                        }
                        //查询参数拦截器
                        if ($.isFunction(opts.query)) {
                            param = opts.query(param);
                        }
                        return param;
                    }
                },
                create: function () {
                    console.log('on create', arguments)
                },
                update: function () {
                    console.log('on update', arguments)
                },
                destroy: function () {
                    console.log('on destroy', arguments)
                },
                parameterMap: opts.parameterMap
            }
        } else if (opts.dataSource && opts.loadFilter) {
            if ($.isFunction(opts.loadFilter)) {
                dataSourceOptions.data = opts.loadFilter(opts.dataSource) || [];
            } else if ($.isFunction(opts.loadFilter.data)) {
                dataSourceOptions.data = opts.loadFilter.data(opts.dataSource) || [];
            }
        }

        //解析分页配置
        if (opts.pageable) {
            var pageSize = opts.pageable.pageSize || 20, pageSizes = [10, 20, 50, 100];
            if (pageSizes.indexOf(pageSize) === -1) {
                pageSizes.push(pageSize)
            }
            opts.pageable = uglcw.extend({
                input: true,
                refresh: true,
                pageSize: pageSize,
                pageSizes: pageSizes,
                messages: {display: "{0} - {1} 总计:{2}", empty: "当前无数据", page: "跳转至"}
            }, opts.pageable);
            dataSourceOptions.pageSize = opts.pageable.pageSize;
        }

        //是否支持离线存储
        if (opts.offline) {
            dataSourceOptions.offlineStorage = opts.offline + "-" + kendo.guid(this._obj);
            //当页面刷新或关闭时删除localstorage
            window.addEventListener("unload", function () {
                localStorage.removeItem(dataSourceOptions.offlineStorage);
            });
        }

        if (opts.aggregate) {
            dataSourceOptions.aggregate = opts.aggregate;
        }

        dataSourceOptions.group = opts.group;

        opts.dataSource = new kendo.data.DataSource(dataSourceOptions);
        if (opts.offline) {
            opts.dataSource.online(false);
        }


        //防止从table创建grid
        $(this._obj).html('');
        if (opts.size === 'small') {
            $(this._obj).addClass('uglcw-small');
        }
        $(this._obj).addClass('uglcw-grid');
        if (!opts.showHeader) {
            $(this._obj).addClass('none-header');
        }
        this.options = opts;
        //内置事件
        this.options = uglcw.extend({}, opts, {
            cellClose: function (e) {
                var widget = this;
                //无修改
                var $cell = $(e.container);
                var currentRow = $cell.closest('tr');
                var lastRow = currentRow.is(':last-child');
                var lastEditableCell = $cell.is(currentRow.find('td.uglcw-grid-editable:visible:last'));
                that.rowIndex = currentRow.index();
                that.cellIndex = $cell.index();
                if ($cell.data(EDIT_BY_CLICK) || (lastRow && lastEditableCell && !$cell.data(EDIT_BY_ENTER))) {
                    //鼠标点击编辑最后一个单元格 关闭时不自动增加一行
                    $cell.removeData(EDIT_BY_CLICK);
                    widget.current($cell);
                    return;
                }
                that.moveToNextCell($(e.container), true);
            },
            saveChanges: function (e) {
                that.saveButtonClicked = true;
            },
            dataBinding: function (e) {
                if (opts.editable) {
                    if ($(that._obj).data('forgetCellIndex')) {
                        $(that._obj).removeData('forgetCellIndex');
                    } else {
                        if (that.cellIndex === undefined || that.cellIndex == null || isNaN(that.cellIndex)) {
                            var current = e.sender.current() || [];
                            if (current[0]) {
                                that.cellIndex = current.index();
                                that.rowIndex = current.parent().index();
                            }
                        }
                    }
                }
                if ($.isFunction(opts.dataBinding)) {
                    opts.dataBinding.apply(this, [e]);
                }
            },
            dataBound: function (e) {
                var init = $(that._obj).data('_tooltip');
                if (!init) {
                    $(that._obj).data('_tooltip', true)
                    setTimeout(function () {
                        $(that._obj).find('.k-grid-content').kendoTooltip({
                            filter: '[data-role=tooltip]',
                            position: 'left',
                            content: function (e) {
                                return $(e.target).html()
                            }
                        })

                    }, 200)
                }
                $(that._obj).find('.uglcw-grid-barcode').each(function () {
                    var text = $(this).text();
                    $(this).text('');
                    new ui.Barcode($(this)).init({
                        value: text
                    })
                })

                $(that._obj).find('.uglcw-grid-qrcode').each(function () {
                    var text = $(this).text();
                    $(this).text('');
                    new ui.QRCode($(this)).init({
                        value: text
                    })
                })
                if (that.options.draggable) {
                    setTimeout(function () {
                        grid.table.kendoSortable({
                            hint: hintElement,
                            ignore: 'input',
                            cursor: "move",
                            placeholder: function (element) {
                                return element.clone().addClass("k-state-selected").css("opacity", 0.65);
                            },
                            container: $(that._obj).find("tbody"),
                            filter: ">tbody >tr",
                            change: function (e) {
                                var skip = grid.dataSource.skip() || 0,
                                    newIndex = e.newIndex + skip,
                                    dataItem = grid.dataSource.getByUid(e.item.data("uid"));
                                grid.dataSource.remove(dataItem);
                                dataItem.dirty = true;
                                grid.dataSource.insert(newIndex, dataItem);
                                $(that._obj).find('.k-grid-content tr:eq(' + newIndex + ')').addClass('k-state-selected');
                            }
                        });
                    }, 200)
                }

                //生成行号
                if (that.options.rowNumber) {
                    var rows = this.element.find('.row-number');
                    $(rows).each(function (index) {
                        $(this).html(index + 1);
                    })
                }
                if (opts.editable) {
                    //恢复grid重新渲染前单元格位置
                    if (that.cellIndex !== undefined && that.cellIndex != null && !isNaN(that.cellIndex)) {
                        clearTimeout(that.moveTimer);
                        that.moveTimer = setTimeout(function () {
                            if ($(that._obj).data(STAY_IN_CURRENT_CELL)) {
                                that.moveToCell($(that._obj).find('.k-grid-content tr:eq(' + that.rowIndex + ') td:eq(' + that.cellIndex + ')'));
                                $(that._obj).removeData(STAY_IN_CURRENT_CELL);
                            } else {
                                that.moveToNext(that.rowIndex, that.cellIndex, that.autoAppendRow);
                            }
                            that.cellIndex = that.rowIndex = null;
                            // The code below is needed only when the user clicks on the "Save Changes" button.
                            // Otherwise, focusing the table explicitly and unconditionally can steal the page focus.
                            if (that.saveButtonClicked) {
                                e.sender.table.focus();
                                that.saveButtonClicked = false;
                            }
                        })
                    }
                }

                var grid = e.sender;
                var rows = $(that._obj).find('.k-grid-content>table>tbody>tr');
                //rows.unbind('click');
                if (opts.checkbox) {
                    var lockedRows = $(that._obj).find('.k-grid-content-locked>table>tbody>tr');
                    //lockedRows.unbind('click');
                    lockedRows.on('click', function (e) {
                        var row = $(e.target).closest('tr');
                        if (row.hasClass("k-state-selected")) {
                            var selected = $(that._obj).find('.k-grid-content>table>tbody>tr.k-state-selected');
                            selected = $.grep(selected, function (x) {
                                var itemToRemove = grid.dataItem(row);
                                var currentItem = grid.dataItem(x);
                                return itemToRemove.uid !== currentItem.uid;
                            });
                            grid.clearSelection();
                            grid.select(selected);
                        } else {
                            grid.select(row)
                        }
                    });

                    rows.on('click', function (e) {
                        if ($(e.target).hasClass('k-checkbox-label')) {
                            return;
                        }
                        var row = $(e.target).closest('tr');
                        if (row.hasClass("k-state-selected")) {
                            var selected = $(that._obj).find('.k-grid-content>table>tbody>tr.k-state-selected');
                            selected = $.grep(selected, function (x) {
                                var itemToRemove = grid.dataItem(row);
                                var currentItem = grid.dataItem(x);
                                return itemToRemove.uid !== currentItem.uid;
                            });
                            grid.clearSelection();
                            grid.select(selected);
                        } else {
                            grid.select(row)
                        }
                    });
                } else {
                    rows.on('click', function (e) {
                        if ($(that._obj).hasClass('uglcw-grid-locked')) {
                            var lockedRows = $(that._obj).find('.k-grid-content-locked>table>tbody>tr');
                            lockedRows.removeClass('k-state-selected');
                        }
                        var row = $(e.target).closest('tr');
                        rows.removeClass('k-state-selected');
                        grid.select(row);
                    })
                }

                $(that._obj).find('.k-grid-content td.k-command-edit .k-button').on('click', function (e) {
                    e.preventDefault();
                });

                mergeGrid(that, mergedColumns);

                if ($.isFunction(opts.dataBound)) {
                    opts.dataBound.apply(this, [e]);
                }
            }
        });


        var grid = $(this._obj).kendoGrid(this.options).data('kendoGrid');
        grid._selectedMap = {};
        grid._selectedItems = [];
        grid.bind('change', function () {
            var that = this, key, dataItem, allRows = that.items(), dataSourceOptions = that.dataSource.options,
                schema = dataSourceOptions.schema, modelId, selected = {};
            if (!schema || !schema.model || !that._data) {
                return;
            }
            modelId = $.isFunction(schema.model) ? schema.model.fn.idField : schema.model.id;
            if (!modelId) {
                return;
            }
            that.select().each(function () {
                dataItem = that.dataItem(this);
                selected[dataItem[modelId]] = true;
            });
            for (var i = 0; i < allRows.length; i++) {
                dataItem = that.dataItem(allRows[i]);
                key = dataItem[modelId];
                if (key) {
                    var exists = !!that._selectedMap[key];
                    if (selected[key] && !exists) {
                        grid._selectedMap[key] = dataItem;
                        grid._selectedItems.push(dataItem);
                    } else if (!selected[key] && exists) {
                        delete grid._selectedMap[key];
                        var idx = grid._selectedItems.findIndex(function (item) {
                            return item[modelId] === key;
                        })
                        if (idx !== -1) {
                            grid._selectedItems.splice(idx, 1);
                        }
                    }
                }
            }
        });

        $(this._obj).on('dblclick', '.k-grid-content>table>tbody>tr,.k-grid-content-locked>table>tbody>tr', function (e) {
            if ($.isFunction(that.options.dblclick)) {
                var dataItem = grid.dataItem(this);
                that.options.dblclick.apply(that, [dataItem]);
            }
        });
        $(this._obj).on('click', '.k-grid-content>table>tbody>tr,.k-grid-content-locked>table>tbody>tr', function (e) {
            if ($.isFunction(that.options.click)) {
                var dataItem = grid.dataItem(this);
                that.options.click.apply(that, [dataItem]);
            }
        });
        $(this._obj).on('click', 'td.uglcw-grid-editable', function () {
            $(this).data(EDIT_BY_CLICK, true);
            $(that._obj).data(STAY_IN_CURRENT_CELL, true);
            var cellIndex = $(this).index();
            var rowIndex = $(this).closest('tr').index();
            that.rowIndex = rowIndex;
            that.cellIndex = cellIndex;
        });

        if (opts.editable) {
            grid.table.on('keydown', function (e) {
                var editing = false;
                var $cell = $(that._obj).find('td.k-state-focused');
                if ($cell.length < 1) {
                    $cell = $(that._obj).find('td.k-edit-cell');
                    if ($cell.length > 0) {
                        editing = true;
                    } else {
                        return
                    }
                }
                var $row = $cell.closest('tr');
                var cellIndex = $cell.index();
                var rowIndex = $row.index();
                var lastRow = $row.is(':last-child');
                var editable = $cell.hasClass('uglcw-grid-editable');
                var keyCode = e.keyCode;
                if (e.keyCode === kendo.keys.ENTER) {
                    //回车进入编辑框 标记
                    if (editable) {
                        $cell.data(EDIT_BY_ENTER, true);
                        that.rowIndex = rowIndex;
                        that.cellIndex = cellIndex;
                    } else {
                        var entered = $cell.data('_uglcw_tab_entered');
                        if (!entered) {
                            $cell.data('_uglcw_tab_entered', true);
                        } else if (!editing && !editable) {
                            //非可编辑框 非编辑状态
                            $cell.removeData('_uglcw_tab_entered');
                            that.moveToNextCell($cell);
                        }
                    }
                } else if (keyCode === kendo.keys.DELETE) {
                    //that.removeSelectedRow(true)
                } else if (keyCode === kendo.keys.UP) {

                } else if (keyCode === kendo.keys.DOWN) {

                }
            })
        }

        this.initEvent(opts);
        //绑定高度自适应
        if (opts.responsive && opts.responsive.length > 0) {
            bindResize(this._obj, opts.responsive, opts);
        }
    };

    Grid.prototype._checkable = function (columns) {
        var that = this;
        var locked = false;
        $(columns).each(function (i, col) {
            if (col.locked) {
                locked = true;
                return false;
            }
        });

        if (locked) {
            $(that._obj).addClass('uglcw-grid-locked');
        } else {
            $(that._obj).addClass('uglcw-grid-unlocked');
        }
    };

    Grid.prototype.moveToCell = function (cell) {
        this.k().current($(cell));
    };

    Grid.prototype.moveToFirstCell = function () {
        this.moveToCell($(this._obj).find('.k-grid-content tr:eq(0) td:eq(0)'));
    };

    Grid.prototype.moveToLastRow = function () {
        this.moveToCell($(this._obj).find('.k-grid-content tr:last td:eq(0)'));
    };

    Grid.prototype.moveToNext = function (rowIndex, cellIndex, createNewRow) {
        var that = this;
        that.moveToNextCell($(that._obj).find('.k-grid-content tr:eq(' + rowIndex + ') td:eq(' + cellIndex + ')'), createNewRow);
    };

    Grid.prototype.moveToNextCell = function (cell, createNewRow) {
        createNewRow = createNewRow === undefined ? true : createNewRow;
        var that = this;
        var grid = this.k();
        var currentCell = $(cell).closest('td');
        var cellIndex = currentCell.index();
        var currentRow = currentCell.closest('tr');
        var rowIndex = currentRow.index();
        var targetCell = '.uglcw-grid-editable';
        if (that.options.speedy && that.options.speedy.className) {
            targetCell += ('.' + that.options.speedy.className);
        }
        var nextEditableCell = that.getNextEditableCell(cell, rowIndex, cellIndex);
        if (!nextEditableCell) {
            if (currentRow.is(':last-child') && createNewRow && that.options.autoAppendRow) {
                //debugger;
                that.addRow();
                nextEditableCell = that.getNextEditableCell(null, rowIndex, cellIndex);
            } else {
                //移动到下一行
                nextEditableCell = $(that._obj).find('.k-grid-content tr:eq(' + (rowIndex + 1) + ') td' + targetCell + ':visible:first');
            }
        }
        grid.current(nextEditableCell);
        /* clearTimeout(that.editDelay);
         that.editDelay = setTimeout(function () {
             grid.editCell(nextEditableCell);
         }, 50)*/
    };

    /**
     * 获取下一个可编辑的单元格
     * @param cell
     * @returns {*}
     */
    Grid.prototype.getNextEditableCell = function (cell, rowIndex, cellIndex) {
        var that = this, hit;
        var targetCell = '.uglcw-grid-editable';
        if (that.options.speedy && that.options.speedy.className) {
            targetCell += ('.' + that.options.speedy.className);
        }
        if (cell) {
            hit = $(cell).find('~ ' + targetCell + ':visible:first');
            if ($(cell).hasClass('uglcw-grid-locked')) {
                hit = $(that._obj).find('.k-grid-content tr:eq(' + rowIndex + ') ' + targetCell + ':visible:first');
            }
        } else {
            hit = $(that._obj).find('.k-grid-content tr:last td' + targetCell + ':visible:first');
        }
        return hit.length > 0 ? hit : false;
    };

    Grid.prototype.kInit = function (o) {
        var that = this;
        var opts = uglcw.extend({}, Grid.defaults, o);
        var checkbox = false, lockable = false;
        var mergedColumns = [];
        $(opts.columns).each(function (i, column) {
            if (column.locked) {
                lockable = true;
            }
            if (column.selectable) {
                checkbox = true;
            }
            if (column.command) {
                $(that._obj).addClass('uglcw-grid-compact');
            }
            if (column.merge) {
                mergedColumns.push(column)
                appendAttribute(column, 'class', 'uglcw-grid-merged ' + column.field)
            }
        })
        opts.lockable = lockable;
        if (lockable) {
            $(that._obj).addClass('uglcw-grid-locked');
        } else {
            $(that._obj).addClass('uglcw-grid-unlocked');
        }
        opts.checkbox = checkbox;
        opts.selectable = false;
        this.options = uglcw.extend({}, opts, {
            cellClose: function (e) {
                //无修改
                if (!opts.autoMove) {
                    return
                }
                var $cell = $(e.container);
                var currentRow = $cell.closest('tr');
                var lastRow = currentRow.is(':last-child');
                var lastEditableCell = $cell.is('.uglcw-grid-editable:visible:last');
                that.rowIndex = currentRow.index();
                that.cellIndex = $cell.index();
                if ($cell.data(EDIT_BY_CLICK) || (lastRow && lastEditableCell && !$cell.data(EDIT_BY_ENTER))) {
                    //鼠标点击编辑最后一个单元格 关闭时不自动增加一行
                    $cell.removeData(EDIT_BY_CLICK);
                    return;
                }
                that.moveToNextCell($(e.container), true);
            },
            saveChanges: function (e) {
                that.saveButtonClicked = true;
            },
            dataBinding: function (e) {
                if (opts.editable) {
                    if ($(that._obj).data('forgetCellIndex')) {
                        $(that._obj).removeData('forgetCellIndex');
                    } else {
                        if (that.cellIndex === undefined || that.cellIndex == null || isNaN(that.cellIndex)) {
                            var current = e.sender.current() || [];
                            if (current[0]) {
                                that.cellIndex = current.index();
                                that.rowIndex = current.parent().index();
                            }
                        }
                    }
                }
                if ($.isFunction(opts.dataBinding)) {
                    opts.dataBinding.apply(this, [e]);
                }
            },
            dataBound: function (e) {
                var init = $(that._obj).data('_tooltip');
                if (!init) {
                    $(that._obj).data('_tooltip', true)
                    setTimeout(function () {
                        $(that._obj).find('.k-grid-content').kendoTooltip({
                            filter: '[data-role=tooltip]',
                            position: 'left',
                            content: function (e) {
                                return $(e.target).html()
                            }
                        })

                    }, 200)
                }
                $(that._obj).find('.uglcw-grid-barcode').each(function () {
                    var text = $(this).text();
                    $(this).text('');
                    new ui.Barcode($(this)).init({
                        value: text
                    })
                })

                $(that._obj).find('.uglcw-grid-qrcode').each(function () {
                    var text = $(this).text();
                    $(this).text('');
                    new ui.QRCode($(this)).init({
                        value: text
                    })
                })
                if (that.options.draggable) {
                    setTimeout(function () {
                        grid.table.kendoSortable({
                            hint: $.noop,
                            cursor: "move",
                            placeholder: function (element) {
                                return element.clone().addClass("k-state-hover").css("opacity", 0.65);
                            },
                            container: $(that._obj).find("tbody"),
                            filter: ">tbody >tr",
                            change: function (e) {
                                var skip = grid.dataSource.skip(),
                                    oldIndex = e.oldIndex + skip,
                                    newIndex = e.newIndex + skip,
                                    data = grid.dataSource.data(),
                                    dataItem = grid.dataSource.getByUid(e.item.data("uid"));
                                grid.dataSource.remove(dataItem);
                                dataItem.dirty = true;
                                grid.dataSource.insert(newIndex, dataItem);
                            }
                        });
                    }, 200)
                }

                //生成行号
                if (that.options.rowNumber) {
                    var rows = this.element.find('.row-number');
                    $(rows).each(function (index) {
                        $(this).html(index + 1);
                    })
                }
                if (opts.editable) {
                    //恢复grid重新渲染前单元格位置
                    if (that.cellIndex !== undefined && that.cellIndex != null && !isNaN(that.cellIndex)) {
                        clearTimeout(that.moveTimer);
                        that.moveTimer = setTimeout(function () {
                            if ((!opts.autoMove) || $(that._obj).data(STAY_IN_CURRENT_CELL)) {
                                that.moveToCell($(that._obj).find('.k-grid-content tr:eq(' + that.rowIndex + ') td:eq(' + that.cellIndex + ')'));
                                $(that._obj).removeData(STAY_IN_CURRENT_CELL);
                            } else {
                                that.moveToNext(that.rowIndex, that.cellIndex, that.autoAppendRow);
                            }
                            that.cellIndex = that.rowIndex = null;
                            // The code below is needed only when the user clicks on the "Save Changes" button.
                            // Otherwise, focusing the table explicitly and unconditionally can steal the page focus.
                            if (that.saveButtonClicked) {
                                e.sender.table.focus();
                                that.saveButtonClicked = false;
                            }
                        })
                    }
                }

                var grid = e.sender;
                var rows = $(that._obj).find('.k-grid-content tr');
                rows.unbind('click');
                if (opts.checkbox) {
                    var lockedRows = $(that._obj).find('.k-grid-content-locked tr');
                    lockedRows.unbind('click');
                    lockedRows.on('click', function (e) {
                        var row = $(e.target).closest('tr');
                        if (row.hasClass("k-state-selected")) {
                            var selected = $(that._obj).find('.k-grid-content tr.k-state-selected');
                            selected = $.grep(selected, function (x) {
                                var itemToRemove = grid.dataItem(row);
                                var currentItem = grid.dataItem(x);
                                return itemToRemove.uid !== currentItem.uid;
                            });
                            grid.clearSelection();
                            grid.select(selected);
                        } else {
                            grid.select(row)
                        }
                    });
                    rows.on('click', function (e) {
                        if ($(e.target).hasClass('k-checkbox-label')) {
                            return;
                        }
                        var row = $(e.target).closest('tr');
                        if (row.hasClass("k-state-selected")) {
                            var selected = $(that._obj).find('.k-grid-content tr.k-state-selected');
                            selected = $.grep(selected, function (x) {
                                var itemToRemove = grid.dataItem(row);
                                var currentItem = grid.dataItem(x);
                                return itemToRemove.uid !== currentItem.uid;
                            });
                            grid.clearSelection();
                            grid.select(selected);
                        } else {
                            grid.select(row);
                        }
                    });
                } else {
                    rows.on('click', function (e) {
                        if ($(that._obj).hasClass('qwg-grid-locked')) {
                            var lockedRows = $(that._obj).find('.k-grid-content-locked tr');
                            lockedRows.removeClass('k-state-selected');
                        }
                        var row = $(e.target).closest('tr');
                        rows.removeClass('k-state-selected');
                        grid.select(row);
                    })
                }
                mergeGrid(that, mergedColumns);
                if ($.isFunction(opts.dataBound)) {
                    opts.dataBound.apply(this, [e]);
                }
            }
        });

        $(this._obj).kendoGrid(this.options);
        var grid = this.k();
        grid._selectedMap = {};
        grid._selectedItems = [];
        grid.bind('change', function () {
            var that = this, key, dataItem, allRows = that.items(), dataSourceOptions = that.dataSource.options,
                schema = dataSourceOptions.schema, modelId, selected = {};
            if (!schema || !schema.model || !that._data) {
                return;
            }
            modelId = $.isFunction(schema.model) ? schema.model.fn.idField : schema.model.id;
            if (!modelId) {
                return;
            }
            that.select().each(function () {
                dataItem = that.dataItem(this);
                selected[dataItem[modelId]] = true;
            });
            for (var i = 0; i < allRows.length; i++) {
                dataItem = that.dataItem(allRows[i]);
                key = dataItem[modelId];
                if (key) {
                    var exists = !!grid._selectedMap[key];
                    if (selected[key] && !exists) {
                        grid._selectedMap[key] = dataItem;
                        grid._selectedItems.push(dataItem);
                    } else if (!selected[key] && exists) {
                        delete grid._selectedMap[key];
                        var idx = grid._selectedItems.findIndex(function (item) {
                            return item[modelId] === key;
                        })
                        if (idx !== -1) {
                            grid._selectedItems.splice(idx, 1);
                        }
                    }
                }
            }
        });
        $(this._obj).on('dblclick', '.k-grid-content tr,.k-grid-content-locked tr', function (e) {
            if ($.isFunction(that.options.dblclick)) {
                var dataItem = grid.dataItem(this);
                that.options.dblclick.apply(that, [dataItem]);
            }
        });
        $(this._obj).on('click', '.k-grid-content tr,.k-grid-content-locked tr', function (e) {
            if ($.isFunction(that.options.click)) {
                var dataItem = grid.dataItem(this);
                that.options.click.apply(that, [dataItem]);
            }
        });
        $(this._obj).on('click', 'td.uglcw-grid-editable', function () {
            $(this).data(EDIT_BY_CLICK, true);
            $(that._obj).data(STAY_IN_CURRENT_CELL, true);
            var cellIndex = $(this).index();
            var rowIndex = $(this).closest('tr').index();
            that.rowIndex = rowIndex;
            that.cellIndex = cellIndex;
        });
        if (opts.responsive && opts.responsive.length > 0) {
            bindResize(this._obj, opts.responsive, opts);
        }
    }

    Grid.prototype.value = function (v) {
        return this.bind(v);
    }

    Grid.prototype.bind = function (model, data) {
        if (model !== undefined) {
            if ($.isArray(model)) {
                this.k().dataSource.data(model);
                return;
            }
            if (data !== undefined) {
                this.k().dataSource.data(data[model] || []);
            } else if (typeof model === 'string') {
                var result = {};
                result[model] = this.k().dataSource.data().toJSON();
                return result;
            }
        } else {
            return this.k().dataSource.data().toJSON();
        }
    };

    Grid.prototype.clearCellIndex = function () {
        this.rowIndex = null;
        this.cellIndex = null;
        $(this._obj).data('forgetCellIndex', true);
    }


    /**
     * 添加数据支持数据
     * @param row
     */
    Grid.prototype.addRow = function (row, o) {
        o = o || {}
        o.move = o.move === undefined ? true : o.move;
        var that = this;
        if ($.isArray(row)) {
            $(row).each(function (idx, item) {
                if (that.options.add && $.isFunction(that.options.add)) {
                    item = that.options.add(item);
                }
                if (o.move) {
                    that.clearCellIndex();
                }
                if (o.index !== undefined) {
                    that.k().dataSource.insert(o.index, item);
                } else {
                    that.k().dataSource.add(item)
                }
            })
        } else {
            if (that.options.add && $.isFunction(that.options.add)) {
                row = that.options.add(row || {});
            }
            if (o.move) {
                that.clearCellIndex();
            }
            if (o.index !== undefined) {
                that.k().dataSource.insert(o.index, row);
            } else {
                that.k().dataSource.add(row)
            }
        }
        //that.scrollBottom();
        if (o.move) {
            setTimeout(function () {
                that.k().table.focus();
                that.moveToNextCell();
            }, 50);
        } else {
            $(that._obj).data(STAY_IN_CURRENT_CELL, true);
        }
    }

    Grid.prototype.cancelRow = function () {
        this.k().cancelRow();
    };

    /**
     * 根据名称显示列
     * @param column
     */
    Grid.prototype.showColumn = function (column) {
        var grid = this.k();
        var index = grid.columns.findIndex(function (col) {
            return col.field == column;
        })
        $(this._obj).find('.uglcw-cell-hide').addClass('uglcw-rendering');
        grid.showColumn(index);
        $(this._obj).find('.uglcw-rendering').removeClass('uglcw-rendering');
    }

    Grid.prototype.columnIndex = function (column, includeHidden) {
        var grid = this.k();
        var columns = grid.columns;
        if (includeHidden === undefined || !includeHidden) {
            columns = columns.filter(function (column) {
                return column.hidden === undefined || !column.hidden;
            })
        }
        var index = columns.findIndex(function (col) {
            return col.field === column;
        });
        return index;
    }

    /**
     * 根据名称隐藏列
     * @param column
     */
    Grid.prototype.hideColumn = function (column) {
        var grid = this.k();
        var index = grid.columns.findIndex(function (col) {
            return col.field == column;
        })
        $(this._obj).find('.uglcw-cell-hide').addClass('uglcw-rendering');
        grid.hideColumn(index);
        $(this._obj).find('.uglcw-rendering').removeClass('uglcw-rendering');
    }


    Grid.prototype.enable = function (bool) {
        this.readonly(!bool);
    };

    Grid.prototype.readonly = function (bool) {
        var grid = this.k();
        grid.setOptions({editable: !bool});
        var commandIndex = grid.columns.findIndex(function (column) {
            return column.command;
        })
        if (commandIndex !== -1) {
            if (!bool) {
                grid.showColumn(commandIndex);
            } else {
                grid.hideColumn(commandIndex);
            }
        }
    }

    /**
     * 获取选中行
     * @returns {Array}
     */
    Grid.prototype.selectedRow = function () {
        var grid = this.k(), row;

        if (grid.options.persistSelection) {
            return grid._selectedItems;
        }

        row = $(this._obj).find('.k-grid-content tr.k-state-selected');
        var data;
        if (row && row.length > 1) {
            data = [];
            $(row).each(function (idx, item) {
                data.push(grid.dataItem(item));
            });
        } else {
            data = grid.dataItem(row);
            data = data ? [data] : data
        }
        return data;
    };

    Grid.prototype.clearSelection = function () {
        var that = this;
        if (that.options.checkbox) {
            this.k().clearSelection();
        } else {
            $(that._obj).find('.k-state-selected').removeClass('k-state-selected');
        }
    };

    /**
     * 删除选中行
     * @param force 是否需要确认提示
     */
    Grid.prototype.removeSelectedRow = function (force, callback) {
        var that = this;
        var grid = this.k(), row, removed = [], uids = [];
        if (grid) {
            row = $(this._obj).find('.k-grid-content tr.k-state-selected');

            if (row && row.length > 0) {
                if (row.length > 1) {
                    if (!force) {
                        uglcw.ui.confirm('是否删除选中行？', function () {
                            $(row).each(function (idx, item) {
                                var dataItem = grid.dataItem(item);
                                removed.push(dataItem);
                                uids.push(dataItem.uid);
                            });
                            $(uids).each(function (idx, uid) {
                                grid.removeRow($(that._obj).find('tr[data-uid=' + uid + ']'));
                            });
                            that.moveToLastRow();
                            if ($.isFunction(callback)) {
                                callback(removed);
                            }
                        })
                    } else {
                        var uids = []
                        $(row).each(function (idx, item) {
                            var dataItem = grid.dataItem(item);
                            removed.push(dataItem);
                            uids.push(dataItem.uid)
                        });
                        $(uids).each(function (idx, uid) {
                            grid.removeRow($(that._obj).find('tr[data-uid=' + uid + ']'));
                        });
                        that.moveToLastRow();
                        if ($.isFunction(callback)) {
                            callback(removed);
                        }
                    }
                } else {
                    if (!force) {
                        uglcw.ui.confirm('是否删除选中行？', function () {
                                removed.push(grid.dataItem(row));
                                grid.removeRow(row);
                                that.moveToLastRow();
                                if ($.isFunction(callback)) {
                                    callback(removed);
                                }
                            }
                        )
                    } else {
                        removed.push(grid.dataItem(row));
                        grid.removeRow(row);
                        that.moveToLastRow();
                        if ($.isFunction(callback)) {
                            callback(removed);
                        }
                    }
                }
            }
        }
    }

    /**
     * 滚动至顶部(需要设置virtualScroll)
     */
    Grid.prototype.scrollTop = function () {
        var grid = this.k();
        grid.content.scrollTop(0);
    }

    /**
     * 保存修改
     */
    Grid.prototype.commit = function (o) {
        var that = this;
        var grid = this.k();
        //$(this._obj).data('_dont_move_after_sync', true);
        $(grid.dataSource.data()).each(function (idx, item) {
            item.dirty = false;
        })
        if (o) {
            that.rowIndex = o.rowIndex || that.rowIndex;
            that.cellIndex = o.cellIndex || that.cellIndex;
        }
        if (!isNaN(that.cellIndex)) {
            var $cell = $(that._obj).find('.k-grid-content tr:eq(' + that.rowIndex + ') td:eq(' + that.cellIndex + ')');
            if ($cell.closest('tr').is(':last-child') && $cell.is('.uglcw-grid-editable:visible:last') && !$cell.data(EDIT_BY_ENTER)) {
                $(that._obj).data(STAY_IN_CURRENT_CELL, true);
            }
        }
        grid.saveChanges();
    }

    /**
     * 滚至底部
     */
    Grid.prototype.scrollBottom = function () {
        var grid = this.k();
        grid.content.scrollTop(grid.content[0].scrollHeight);
    }

    /**
     * 刷新数据
     */
    Grid.prototype.reload = function (param) {
        var grid = this.k();
        var autoBind = grid.options.autoBind;
        if (!autoBind) {
            grid.setOptions({
                autoBind: true
            })
        } else {
            if (grid.options.pageable) {
                if (param && param.stay) {
                    grid.dataSource.page(grid.dataSource.page());
                } else {
                    grid.dataSource.page(1);
                }
            } else {
                grid.dataSource.read();
            }
        }
    }

    Grid.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Grid.prototype.element = function () {
        return this.k().wrapper;
    }

    Grid.prototype.resize = function (container, responsive) {
        var that = this;
        var element = that._obj;
        var options = that.options;
        var others = responsive || that.options.responsive || [];
        var surroundHeight = 0;
        container = container || window;
        $(others).each(function (i, e) {
            if (typeof e == 'number') {
                surroundHeight += e;
            } else {
                surroundHeight += $(e + ':visible').height();
            }
        });
        var targetHeight = $(container).height() - surroundHeight;
        var $grid = $(element);
        var otherHeight = 0;
        //计算非内容部分的高度(header, footer, toolbar...)
        $grid.children().not('.k-grid-content,.k-grid-content-locked').each(function () {
            otherHeight += $(this).outerHeight(true);
        });
        //设置表格高度
        var contentHeight = targetHeight - otherHeight;
        if (options.minHeight) {
            if (contentHeight < options.minHeight) {
                var diff = options.minHeight - contentHeight;
                targetHeight += diff;
            }
        }
        $grid.height(targetHeight);
        //设置表格内容高度
        $grid.find('.k-grid-content').height(targetHeight - otherHeight);

        var hasHScrollBar = $grid.find('.k-grid-content').hasHScrollBar();
        var scrollBarHeight = hasHScrollBar ? uglcw.util.getScrollBarWidth() : 0;
        $grid.find('.k-grid-content-locked').height(targetHeight - otherHeight - scrollBarHeight);
        var noRecordsTemplate = $grid.find('.k-grid-norecords-template');
        if (noRecordsTemplate.length > 0) {
            //处理无数据模板的位置;
            $(noRecordsTemplate).attr('style', 'position: absolute;');
        }

        var $lockedContent = $grid.find('.k-grid-content-locked');
        var lockedWidth = 0;
        if ($lockedContent.length > 0) {
            lockedWidth = $lockedContent.width();
        }
        $grid.find('.k-grid-content').width($grid.width() - lockedWidth);

        var hasHScrollBar = $grid.find('.k-grid-content').hasHScrollBar();
        if (hasHScrollBar) {
            $grid.find('.k-grid-content-locked').height(targetHeight - otherHeight - uglcw.util.getScrollBarWidth());
        }
    };

    uglcw.extend(ui, {
        'Grid': Grid
    })

})(jQuery, window, uglcw);

(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui, Grid = kendo.ui.Grid;

    var uglcwGrid = Grid.extend({
        init: function (element, options) {
            Grid.fn.init.call(this, element, options);
        },
        options: {
            name: 'uglcwGrid'
        }
    });

    kendo.ui.plugin(uglcwGrid);


    function focusTable(table, direct) {
        if (direct === true) {
            table = $(table);
            var scrollLeft = table.parent().scrollLeft();
            kendo.focusElement(table);
            table.parent().scrollLeft(scrollLeft);
        } else {
            $(table).one('focusin', function (e) {
                e.preventDefault();
            }).focus();
        }
    }


    var STAY_IN_CURRENT_CELL = '_stay_in_current_cell';
    var EDIT_BY_ENTER = '_edit_by_enter';
    var NAVROW = 'tr:not(.k-footer-template):visible', KEYS = kendo.keys;
    var _tableKeyDown = kendo.ui.uglcwGrid.fn._tableKeyDown;
    kendo.ui.uglcwGrid.fn._tableKeyDown = function (e) {
        var next, current = this.current();
        var row = current.parent();
        var container = row.parent();
        var a = $(e.target);
        var role;
        if (e.keyCode === KEYS.UP) {
            role = a.data('role') || a.attr('role');
            if (role !== 'combobox' && role !== 'dropdownlist') {
                if (role === 'autocomplete') {
                    var autoComplete = kendo.widgetInstance($(a));
                    if (autoComplete && autoComplete.popup._activated) {
                        return _tableKeyDown.call(this, e);
                    }
                }
                next = this._prevVerticalCell(container, current);
                if (!next[0]) {
                    this._lastCellIndex = 0;
                    container = this._verticalContainer(container);
                    next = this._prevVerticalCell(container, current);
                }
                if (next.length > 0) {
                    return this._handleEditing(current, next, next.closest('table'));
                }
            }
        } else if (e.keyCode === KEYS.DOWN) {
            role = a.data('role') || a.attr('role');
            if (role !== 'combobox' && role !== 'dropdownlist') {
                if (role === 'autocomplete') {
                    var autoComplete = kendo.widgetInstance($(a));
                    if (autoComplete && autoComplete.popup._activated) {
                        return _tableKeyDown.call(this, e);
                    }
                }
                next = this._nextVerticalCell(container, current);
                if (!next[0]) {
                    this._lastCellIndex = 0;
                    container = this._verticalContainer(container);
                    next = this._nextVerticalCell(container, current);
                }
                if (next.length > 0) {
                    return this._handleEditing(current, next, next.closest('table'));
                }
            }
        } else if (e.keyCode === KEYS.LEFT) {
            if (a.is('input')) {
                role = a.data('role') || a.attr('role');
                if (role !== 'combobox' && role !== 'dropdownlist') {
                    var p = a.getCursorPosition() || 0;
                    if (a.val().length !== 0 && p !== 0) {
                        return;
                    }
                }
            }
            //if (a.val().length === 0 || p === 0) {
            index = container.find(NAVROW).index(row);
            next = this._prevHorizontalCell(container, current, index);
            if (!next[0]) {
                container = this._horizontalContainer(container);
                next = this._prevHorizontalCell(container, current, index);
                if (next[0] !== current[0]) {
                    focusTable(container.parent(), true);
                }
            }
            if (next.length > 0) {
                return this._handleEditing(current, next, next.closest('table'));
            }
            //}

        } else if (e.keyCode === KEYS.RIGHT) {
            if (a.is('input')) {
                role = a.data('role') || a.attr('role');
                if (role !== 'combobox' && role !== 'dropdownlist') {
                    var p = a.getCursorPosition() || 0;
                    if (a.val().length !== p && p !== 0) {
                        return;
                    }
                }
            }
            var index = container.find(NAVROW).index(row);
            next = this._nextHorizontalCell(container, current, index);
            if (!next[0]) {
                container = this._horizontalContainer(container, true);
                next = this._nextHorizontalCell(container, current, index);
                if (next[0] !== current[0]) {
                    focusTable(container.parent(), true);
                }
            }
            if (next.length > 0) {
                return this._handleEditing(current, next, next.closest('table'));
            }
        } else if (e.keyCode === KEYS.ESC) {
            return console.log('esc');
        }
        _tableKeyDown.call(this, e);
    };

    var _handleEnterKey = kendo.ui.uglcwGrid.fn._handleEnterKey;
    kendo.ui.uglcwGrid.fn._handleEnterKey = function (current, currentTable, target) {
        if (current.hasClass('k-edit-cell')) {
            var grid = uglcw.ui.get(current.closest('.uglcw-grid'));
            var next = grid.getNextEditable(current);
            if (next.length > 0) {
                return this._handleEditing(current, next, $(next).closest('table'));
            }
        } else if (current.hasClass('uglcw-grid-readonly')) {
            return this._moveRight(current, false, false, false, currentTable);
        }
        return _handleEnterKey.call(this, current, currentTable, target);
    };

    function AdvancedGrid(obj) {
        ui.KUI.call(this, obj);
    }

    function hintElement(element) { // Customize the hint
        var grid = kendo.widgetInstance($(element).closest('.uglcw-grid')),
            table = grid.table.clone(), // Clone Grid's table
            wrapperWidth = grid.wrapper.width(), //get Grid's width
            wrapper = $("<div class='k-grid uglcw-grid k-widget'></div>").width(wrapperWidth),
            hint;

        table.find("thead").remove(); // Remove Grid's header from the hint
        table.find("tbody").empty(); // Remove the existing rows from the hint
        table.wrap(wrapper); // Wrap the table
        table.append(element.clone().addClass('k-state-selected').removeAttr("uid")); // Append the dragged element
        hint = table.parent(); // Get the wrapper
        return hint; // Return the hint element
    }

    /**
     * 列追加属性
     * @param column
     * @param key
     * @param value
     * @param type
     */
    function appendAttribute(column, key, value, type) {
        type = type || '';
        var attr = type ? type + 'Attributes' : 'attributes';
        column[attr] = column[attr] || {};
        var exist = (column[attr][key] || '');
        column[attr][key] = exist ? (exist + ' ' + value) : value;
    }

    //绑定
    function bindResize(element, others, options) {
        others = others || [];
        var doResize = function () {
            var delay = $(element).data('resize_delay');
            if (delay) {
                clearTimeout(delay);
            }
            delay = setTimeout(function () {
                var $grid = $(element);
                uglcw.ui.get($grid).resize();
            }, 20);
            $(element).data('resize_delay', delay);
        };
        $(window).resize(doResize);
        doResize();
    }

    function mergeGrid (grid, mergedColumns){
        if (grid.options.mergeBy && mergedColumns.length > 0) {
            var data = grid.k().dataSource.view().toJSON();
            var start = 0, end = 0, combo = 0;
            var current = '';
            $(data).each(function (i, row) {
                var values = [], isLast = i === data.length - 1;
                $.map(grid.options.mergeBy.split(','), function (col) {
                    values.push(row[col]);
                });
                var mergeBy = values.join('__');
                if (i === 0) {
                    current = mergeBy;
                }
                combo += 1;
                console.log(combo, start, end);
                if (current != mergeBy || isLast) {
                    //准备开始下一组，先合并上一组 || 或者最后一条
                    if(current == mergeBy){
                        combo += 1;
                    }
                    var span = end - start;
                    if (combo > 1) {
                        $(mergedColumns).each(function (j, column) {
                            $(grid._obj).find('.uglcw-grid-merged.' + column.field).eq(start).attr('rowspan', combo - 1)
                            $(grid._obj).find('.uglcw-grid-merged.' + column.field).slice(start + 1, start + combo - 1).addClass('uglcw-hide-cell')
                        })
                    }
                    start = i;
                    current = mergeBy
                    combo = 1;
                }
            })
        }
    }


    AdvancedGrid.prototype = new ui.KUI();
    AdvancedGrid.prototype.constructor = AdvancedGrid;
    AdvancedGrid.defaults = {
        serverAggregates: true,
        rowNumber: false,
        showEditableMark: true, //显示可编辑列标记( 铅笔)
        responsive: [], //响应式高度 window高度- responsive 数组中的元素或数值;
        noRecords: false, //显示无数据
        resizable: true,
        validate: true,
        navigatable: true,
        lockable: true,
        selectable: false,
        align: 'center',
        showHeader: true, //显示表头
        autoBind: true,
        pageSize: 20,
        allowCopy: true,
        autoSync: false,
        autoAppendRow: true, //自动增加一行
        autoMove: true, //是否自动移动
        speedy: {
            className: '',  //限制回车跳转范围
            direct: true //是否立即进入编辑状态
        },
        serverFiltering: false,
        minHeight: 0, //最小高度

    };
    AdvancedGrid.prototype.init = function (o) {
        if (this.k()) {
            return;
        }
        o = uglcw.extend({}, AdvancedGrid.defaults, o);
        ui.KUI.prototype.init.call(this, o);
        var that = this;
        var columns = [], schema = {model: {fields: {}}};
        if (o.id) {
            //指定主键
            schema.model.id = o.id;
        }

        if (o.editable) {
            o.editable = $.extend({}, {
                createAt: 'bottom'
            }, o.editable)
        }

        if (o.checkbox) {
            var checkboxColumn = {
                width: 35,
                selectable: true,
                locked: o.lockable,
                type: 'checkbox',
            };
            if (checkboxColumn.locked) {
                appendAttribute(checkboxColumn, 'class', 'uglcw-grid-locked uglcw-grid-readonly');
            }
            appendAttribute(checkboxColumn, 'class', 'uglcw-grid-checkbox');
            appendAttribute(checkboxColumn, 'class', 'uglcw-grid-checkbox', 'header');
            columns.push(checkboxColumn);
            o.selectable = false;
        }

        if (o.rowNumber) {
            var numberColumn = {
                width: 35,
                title: '#',
                locked: o.lockable,
                template: '<span class="row-number label-circle"></span>',
                footerTemplate: '<span class="row-count">'
            };
            if (numberColumn.locked) {
                appendAttribute(numberColumn, 'class', 'uglcw-grid-locked uglcw-grid-readonly');
            }
            appendAttribute(numberColumn, 'style', 'text-align: center; padding:0;cursor: move;');
            appendAttribute(numberColumn, 'style', 'text-align: center; padding:0', 'header');
            appendAttribute(numberColumn, 'tabindex', -1);
            columns.push(numberColumn);
        }

        //重写删除确认提示
        var destroyCmd = {
            name: "Delete",
            className: "uglcw-grid-cmd-remove",
            text: "<i class='k-icon k-i-minus'></i>",
            click: function (e) {
                e.preventDefault();
                var td = $(e.target).closest('td');
                var tr = $(td).closest("tr");
                var data = that.k().dataItem(tr);
                uglcw.ui.confirm("确定删除吗？", function () {
                    that.k().dataSource.remove(data);
                }, function () {

                }, {
                    btns: ['删除', '取消'],
                    title: false,
                    closeBtn: 0
                });
            }
        };

        var insertCmd = {
            name: "Add",
            className: "uglcw-grid-cmd-add",
            text: "<i class='k-icon k-i-plus'></i>",
            click: function (e) {
                e.preventDefault();
                var rowIndex = $(e.target).closest('tr').index();
                var cellIndex = $(e.target).closest('td').index();
                that.rowIndex = rowIndex;
                that.cellIndex = cellIndex;
                that.addRow(null, {index: rowIndex + 1, move: false});
                if (that.options.onInsert && $.isFunction(that.options.onInsert)) {
                    that.options.onInsert.call(that, rowIndex + 1);
                }
            }
        };
        var mergedColumns = [];
        $(that._obj).find("[data-field]").each(function (index, th) {
            var column = {
                field: $(th).attr("data-field"), editable: function () {
                    return false
                }
            };


            //设置标题
            column.title = ($(th).text() || column.field || "").trim();
            //获取配置
            var opts = ui.attr(th, "options") || '';
            if (opts.charAt(0) !== '{') {
                opts = '{' + opts + '}';
            }
            try {
                column = uglcw.extend(column, eval('(' + opts + ')'));
            } catch (e) {
                console.error('表格列字段配置解析失败 [' + column.title + ']', opts, e);
            }

            column.locked = o.lockable && column.locked;
            if (column.locked) {
                appendAttribute(column, 'class', 'uglcw-grid-locked')
            }

            if (column.merge) {
                mergedColumns.push(column)
                appendAttribute(column, 'class', 'uglcw-grid-merged ' + column.field)
            }

            column.align = column.align || o.align;
            if (column.align && column.type !== 'checkbox') {
                appendAttribute(column, 'style', 'text-align:' + column.align + ';');
                if (!column.titleAlign) {
                    appendAttribute(column, 'style', 'text-align:' + column.align + ';', 'header');
                }
                appendAttribute(column, 'style', 'text-align:' + column.align + ';', 'footer');
            }
            if (column.titleAlign && column.type !== 'checkbox') {
                appendAttribute(column, 'style', 'text-align:' + column.titleAlign + ';', 'header');
            }
            //字段是否可编辑只接收function类型参数
            if (column.editable !== undefined) {
                if (!$.isFunction(column.editable)) {
                    var editable = column.editable;
                    column.editable = function () {
                        return editable;
                    }
                }
            }
            if (column.editor !== undefined || column.schema !== undefined) {
                column.editable = function () {
                    return true;
                }
            }

            if (column.command) {
                $(that._obj).addClass('uglcw-grid-compact');
                if ($.isArray(column.command)) {
                    var kcmd = [];
                    column.command.forEach(function (cmd) {
                        if (cmd === "destroy") {
                            kcmd.push(destroyCmd)
                        } else if (cmd === 'create') {
                            kcmd.push(insertCmd);
                        } else {
                            kcmd.push(cmd);
                        }
                    });
                    column.command = kcmd;
                } else if (column.command === "destroy") {
                    column.command = [destroyCmd];
                } else if (column.command === 'create') {
                    column.command = [insertCmd];
                }
            }
            //分配编辑器
            if (column.schema) {
                //配置字段格式化
                if (column.schema.type === "timestamp") {
                    column.template = '#= data.' + column.field + ' == null ? "" : kendo.toString(new Date(data.' + column.field + '), "' + (column.schema.format || 'yyyy-MM-dd') + '")#';
                }
                if (column.schema.type === "date") {
                    column.template = '#= data.' + column.field + ' == null ? "" : kendo.toString(data.' + column.field + ', "' + (column.schema.format || 'yyyy-MM-dd') + '")#';
                    column.schema.parse = function (value) {
                        return kendo.toString(value, column.format || 'yyyy-MM-dd');
                    }
                }
                schema.model.fields[column.field] = column.schema;

                if (column.schema && column.editable && column.editable() && column.schema.type === 'number') {
                    column.editor = column.editor || function (container, options) {
                        var model = options.model;
                        var input = $('<input data-bind="value:' + options.field + '"/>');
                        input.appendTo(container);
                        var numeric = new uglcw.ui.Numeric(input);
                        numeric.init({
                            decimals: column.schema.decimals || 2,
                            format: column.format ? column.format.split(":")[1].replace('}', '') : 'n2'
                        });
                    }
                }

            }
            //通过tooltip显示隐藏的信息
            if (column.tooltip) {
                appendAttribute(column, 'show-tooltip', true);
                column.template = column.template || '<span data-role="#=data.' + column.field + ' ? \"tooltip\": \"\"#" title="#=data.' + column.field + ' === undefined || data.' + column.field + ' == null ? \"\" : data.' + column.field + '#">#=data.' + column.field + ' === undefined || data.' + column.field + ' == null ? \"\" : data.' + column.field + ' #</span>'
            }

            if (column.barcode) {
                column.template = column.template || '<span class="uglcw-grid-barcode">#= data.' + column.field + ' || \"\"#</span>'
            }
            if (column.qrcode) {
                column.template = column.template || '<span class="uglcw-grid-qrcode">#= data.' + column.field + ' || \"\"#</span>'
            }
            //必填字段列头加标记
            if (column.validate && column.validate.indexOf("require") !== -1) {
                appendAttribute(column, 'class', 'uglcw-grid-required', 'header');
            }

            if (column.editable && column.editable()) {
                appendAttribute(column, 'class', 'uglcw-grid-editable');
                appendAttribute(column, 'class', 'uglcw-grid-editable', 'header');
            } else {
                if (!column.command) {
                    appendAttribute(column, 'tabindex', -1);
                    appendAttribute(column, 'class', 'uglcw-grid-readonly');
                }
            }
            columns.push(column);
        });

        this._checkable(columns);

        this.schema = schema;
        //合并配置
        var opts = uglcw.extend({}, AdvancedGrid.defaults, o, {columns: columns});

        var dataSourceOptions = {
            data: opts.dataSource || [],
            autoSync: opts.autoSync,
            schema: schema
        }

        //服务端数据源配置
        if (opts.url) {
            dataSourceOptions.schema = $.extend(dataSourceOptions.schema, {
                data: function (response) {
                    return response.rows || []
                },
                total: function (response) {
                    return response.total || 0;
                },
                aggregates: function (response) {
                    return response.aggregates || {};
                }
            }, opts.loadFilter);
            dataSourceOptions.serverPaging = true;
            dataSourceOptions.pageSize = opts.pageSize;
            dataSourceOptions.batch = true;
            dataSourceOptions.serverAggregates = opts.serverAggregates;
            dataSourceOptions.serverFiltering = opts.serverFiltering;
            dataSourceOptions.transport = uglcw.extend({
                read: {
                    url: opts.url,
                    type: opts.type || 'get',
                    contentType: opts.contentType,
                    dataType: opts.dataType || 'json',
                    data: opts.data || function (param) {
                        param.rows = param.pageSize;
                        if (!opts.pageable) {
                            delete param['page'];
                            delete param['rows'];
                        }
                        delete param['take'];
                        delete param['skip'];
                        delete param['aggregate'];
                        delete param['pageSize'];
                        //查询区域选择器
                        if (opts.criteria) {
                            var criteria = ui.bind(opts.criteria);
                            param = uglcw.extend(param, criteria);
                        }
                        //查询参数拦截器
                        if ($.isFunction(opts.query)) {
                            param = opts.query(param);
                        }
                        return param;
                    }
                },
                parameterMap: opts.parameterMap
            }, opts.transport);
        } else if (opts.dataSource && opts.loadFilter) {
            if ($.isFunction(opts.loadFilter)) {
                dataSourceOptions.data = opts.loadFilter(opts.dataSource) || [];
            } else if ($.isFunction(opts.loadFilter.data)) {
                dataSourceOptions.data = opts.loadFilter.data(opts.dataSource) || [];
            }
        }

        //解析分页配置
        if (opts.pageable) {
            var pageSize = opts.pageable.pageSize || 20, pageSizes = [10, 20, 50, 100];
            if (pageSizes.indexOf(pageSize) === -1) {
                pageSizes.push(pageSize)
            }
            opts.pageable = uglcw.extend({
                input: true,
                refresh: true,
                pageSize: pageSize,
                pageSizes: pageSizes,
                messages: {display: "{0} - {1} 总计:{2}", empty: "当前无数据", page: "跳转至"}
            }, opts.pageable);
            dataSourceOptions.pageSize = opts.pageable.pageSize;
        }

        //是否支持离线存储
        if (opts.offline) {
            dataSourceOptions.offlineStorage = opts.offline + "-" + kendo.guid(this._obj);
            //当页面刷新或关闭时删除localstorage
            window.addEventListener("unload", function () {
                localStorage.removeItem(dataSourceOptions.offlineStorage);
            });
        }

        if (opts.aggregate) {
            dataSourceOptions.aggregate = opts.aggregate;
            $(dataSourceOptions.aggregate).each(function (i, agg) {
                dataSourceOptions.schema.model.fields[agg.field] = uglcw.extend(dataSourceOptions.schema.model.fields[agg.field], {type: 'number'});
            })
        }

        dataSourceOptions.group = opts.group;

        opts.dataSource = new kendo.data.DataSource(dataSourceOptions);
        if (opts.offline) {
            opts.dataSource.online(false);
        }


        //防止从table创建grid
        $(this._obj).html('');
        if (opts.size === 'small') {
            $(this._obj).addClass('uglcw-small');
        }
        $(this._obj).addClass('uglcw-grid');
        if (!opts.showHeader) {
            $(this._obj).addClass('none-header');
        }
        this.options = opts;
        //内置事件
        this.options = uglcw.extend({}, opts, {
            dataBound: function (e) {
                var init = $(that._obj).data('_tooltip');
                if (!init) {
                    $(that._obj).data('_tooltip', true)
                    setTimeout(function () {
                        $(that._obj).find('.k-grid-content').kendoTooltip({
                            filter: '[data-role=tooltip]',
                            position: 'left',
                            content: function (e) {
                                return $(e.target).html()
                            }
                        })

                    }, 200)
                }
                $(that._obj).find('.uglcw-grid-barcode').each(function () {
                    var text = $(this).text();
                    $(this).text('');
                    new ui.Barcode($(this)).init({
                        value: text
                    })
                })

                $(that._obj).find('.uglcw-grid-qrcode').each(function () {
                    var text = $(this).text();
                    $(this).text('');
                    new ui.QRCode($(this)).init({
                        value: text
                    })
                })
                if (that.options.draggable) {
                    setTimeout(function () {
                        grid.table.kendoSortable({
                            hint: hintElement,
                            ignore: 'input',
                            cursor: "move",
                            placeholder: function (element) {
                                return element.clone().addClass("k-state-selected").css("opacity", 0.65);
                            },
                            container: $(that._obj).find("tbody"),
                            filter: ">tbody >tr",
                            change: function (e) {
                                var skip = grid.dataSource.skip() || 0,
                                    newIndex = e.newIndex + skip,
                                    dataItem = grid.dataSource.getByUid(e.item.data("uid"));
                                grid.dataSource.remove(dataItem);
                                grid.dataSource.insert(newIndex, dataItem);
                                $(that._obj).find('.k-grid-content tr:eq(' + newIndex + ')').addClass('k-state-selected');
                            }
                        });
                    }, 200)
                }

                //生成行号
                if (that.options.rowNumber) {
                    var rows = this.element.find('.row-number');
                    $(rows).each(function (index) {
                        $(this).html(index + 1);
                    })
                    //$(this.element.find('.row-count')).html(rows.length || 0);
                }
                var grid = e.sender;
                var rows = $(that._obj).find('.k-grid-content>table>tbody>tr');
                rows.unbind('click');
                if (opts.checkbox) {
                    var lockedRows = $(that._obj).find('.k-grid-content-locked>table>tbody>tr');
                    lockedRows.unbind('click');
                    lockedRows.on('click', function (e) {
                        var row = $(e.target).closest('tr');
                        if (row.hasClass("k-state-selected")) {
                            var selected = $(that._obj).find('.k-grid-content>table>tbody>tr.k-state-selected');
                            selected = $.grep(selected, function (x) {
                                var itemToRemove = grid.dataItem(row);
                                var currentItem = grid.dataItem(x);
                                return itemToRemove.uid !== currentItem.uid;
                            });
                            grid.clearSelection();
                            grid.select(selected);
                        } else {
                            grid.select(row)
                        }
                    });

                    rows.on('click', function (e) {
                        if ($(e.target).hasClass('k-checkbox-label')) {
                            return;
                        }
                        var row = $(e.target).closest('tr');
                        if (row.hasClass("k-state-selected")) {
                            var selected = $(that._obj).find('.k-grid-content>table>tbody>tr.k-state-selected');
                            selected = $.grep(selected, function (x) {
                                var itemToRemove = grid.dataItem(row);
                                var currentItem = grid.dataItem(x);
                                return itemToRemove.uid !== currentItem.uid;
                            });
                            grid.clearSelection();
                            grid.select(selected);
                        } else {
                            grid.select(row)
                        }
                    });
                } else {
                    rows.on('click', function (e) {
                        if ($(that._obj).hasClass('uglcw-grid-locked')) {
                            var lockedRows = $(that._obj).find('.k-grid-content-locked>table>tbody>tr');
                            lockedRows.removeClass('k-state-selected');
                        }
                        var row = $(e.target).closest('tr');
                        rows.removeClass('k-state-selected');
                        grid.select(row);
                    })
                }

                mergeGrid(that, mergedColumns);
                if ($.isFunction(opts.dataBound)) {
                    opts.dataBound.apply(this, [e]);
                }
            }
        });


        var grid = $(this._obj).kendouglcwGrid(this.options).data('kendouglcwGrid');
        grid._selectedItems = [];
        grid._selectedMap = {};
        if (grid.footerTemplate) {
            grid.dataSource.bind('change', function (e) {
                if (e.field && e.action === "itemchange") {
                    if (grid.footerTemplate) {
                        grid._footer();
                    }
                }
            })
        }
        ;

        grid.bind('change', function () {
            var that = this, key, dataItem, allRows = that.items(), dataSourceOptions = that.dataSource.options,
                schema = dataSourceOptions.schema, modelId, selected = {};
            if (!schema || !schema.model || !that._data) {
                return;
            }
            modelId = $.isFunction(schema.model) ? schema.model.fn.idField : schema.model.id;
            if (!modelId) {
                return;
            }
            that.select().each(function () {
                dataItem = that.dataItem(this);
                selected[dataItem[modelId]] = true;
            });
            for (var i = 0; i < allRows.length; i++) {
                dataItem = that.dataItem(allRows[i]);
                key = dataItem[modelId];
                if (key) {
                    var exists = !!grid._selectedMap[key];
                    if (selected[key] && !exists) {
                        grid._selectedMap[key] = dataItem;
                        grid._selectedItems.push(dataItem);
                    } else if (!selected[key] && exists) {
                        delete grid._selectedMap[key];
                        var idx = grid._selectedItems.findIndex(function (item) {
                            return item[modelId] === key;
                        })
                        if (idx !== -1) {
                            grid._selectedItems.splice(idx, 1);
                        }
                    }
                }
            }
        });

        $(this._obj).on('dblclick', '.k-grid-content tr,.k-grid-content-locked tr', function (e) {
            if ($.isFunction(that.options.dblclick)) {
                var dataItem = grid.dataItem(this);
                that.options.dblclick.apply(that, [dataItem]);
            }
        });
        $(this._obj).on('click', '.k-grid-content tr,.k-grid-content-locked tr', function (e) {
            if ($.isFunction(that.options.click)) {
                var dataItem = grid.dataItem(this);
                that.options.click.apply(that, [dataItem]);
            }
        });


        this.initEvent(opts);
        //绑定高度自适应
        if (opts.responsive && opts.responsive.length > 0) {
            bindResize(this._obj, opts.responsive, opts);
        }
    };

    AdvancedGrid.prototype._checkable = function (columns) {
        var that = this;
        var locked = false;
        $(columns).each(function (i, col) {
            if (col.locked) {
                locked = true;
                return false;
            }
        });

        if (locked) {
            $(that._obj).addClass('uglcw-grid-locked');
        } else {
            $(that._obj).addClass('uglcw-grid-unlocked');
        }
    };

    AdvancedGrid.prototype._renderRow = function (row) {
        var that = this
        var grid = that.k();
        var dataItem = grid.dataItem(row);

        var rowChildren = $(row).children('td[role="gridcell"]');

        for (var i = 0; i < grid.columns.length; i++) {

            var column = grid.columns[i];
            var template = column.template;
            var cell = rowChildren.eq(i);

            if (template !== undefined) {
                var kendoTemplate = kendo.template(template);

                // Render using template
                cell.html(kendoTemplate(dataItem));
            } else {
                var fieldValue = dataItem[column.field];

                var format = column.format;
                var values = column.values;

                if (values !== undefined && values != null) {
                    // use the text value mappings (for enums)
                    for (var j = 0; j < values.length; j++) {
                        var value = values[j];
                        if (value.value == fieldValue) {
                            cell.html(value.text);
                            break;
                        }
                    }
                } else if (format !== undefined) {
                    // use the format
                    cell.html(kendo.format(format, fieldValue));
                } else {
                    // Just dump the plain old value
                    cell.html(fieldValue);
                }
            }
        }
        if (row.find('.row-number').length > 0) {
            row.find('.row-number').text($(row).index() + 1);
        }
        grid._footer();
    }

    AdvancedGrid.prototype.moveToCell = function (cell) {
        this.k().current($(cell));
    };


    AdvancedGrid.prototype.moveToFirstCell = function () {
        this.moveToCell($(this._obj).find('.k-grid-content tr:eq(0) td:eq(0)'));
    };

    AdvancedGrid.prototype.moveToLastRow = function () {
        this.moveToCell($(this._obj).find('.k-grid-content tr:last td:eq(0)'));
    };

    AdvancedGrid.prototype.moveToNext = function (rowIndex, cellIndex, createNewRow) {
        var that = this;
        that.moveToNextCell($(that._obj).find('.k-grid-content tr:eq(' + rowIndex + ') td:eq(' + cellIndex + ')'), createNewRow);
    };

    AdvancedGrid.prototype.moveToNextCell = function (cell, createNewRow) {
        createNewRow = createNewRow === undefined ? true : createNewRow;
        var that = this;
        var grid = this.k();
        var currentCell = $(cell).closest('td');
        var cellIndex = currentCell.index();
        var currentRow = currentCell.closest('tr');
        var rowIndex = currentRow.index();
        var targetCell = '.uglcw-grid-editable';
        if (that.options.speedy && that.options.speedy.className) {
            targetCell += ('.' + that.options.speedy.className);
        }
        var nextEditableCell = that.getNextEditableCell(cell, rowIndex, cellIndex);
        if (!nextEditableCell) {
            if (currentRow.is(':last-child') && createNewRow && that.options.autoAppendRow) {
                //debugger;
                grid.closeCell(currentCell);
                that.addRow();
                nextEditableCell = that.getNextEditableCell(null, rowIndex, cellIndex);
            } else {
                //移动到下一行
                nextEditableCell = $(that._obj).find('.k-grid-content tr:eq(' + (rowIndex + 1) + ') td' + targetCell + ':visible:first');
            }
        }
        grid._handleEditing(currentCell, nextEditableCell, nextEditableCell.closest('table'));
        //grid.current(nextEditableCell);
        /* clearTimeout(that.editDelay);
         that.editDelay = setTimeout(function () {
             grid.editCell(nextEditableCell);
         }, 50)*/
    };

    AdvancedGrid.prototype.getNextEditable = function (cell) {
        var that = this;
        var grid = this.k();
        var currentCell = $(cell).closest('td');
        var cellIndex = currentCell.index();
        var currentRow = currentCell.closest('tr');
        var rowIndex = currentRow.index();
        var targetCell = '.uglcw-grid-editable';
        if (that.options.speedy && that.options.speedy.className) {
            targetCell += ('.' + that.options.speedy.className);
        }
        var nextCell = that.getNextEditableCell(cell);
        if (!nextCell) {
            if (currentRow.is(':last-child') && that.options.autoAppendRow) {
                //debugger;
                grid._handleEditing(currentCell, null, grid.table);
                that.addRow();
                nextCell = that.getNextEditableCell(null);
            } else {
                //移动到下一行
                if ($(that._obj).find('.k-grid-content-locked').length > 0) {
                    nextCell = $(that._obj).find('.k-grid-content-locked tr:eq(' + (rowIndex + 1) + ') td' + targetCell + ':visible:first');
                    if (nextCell.length < 0) {
                        nextCell = $(that._obj).find('.k-grid-content tr:eq(' + (rowIndex + 1) + ') td' + targetCell + ':visible:first');
                    }
                } else {
                    nextCell = $(that._obj).find('.k-grid-content tr:eq(' + (rowIndex + 1) + ') td' + targetCell + ':visible:first');
                }
            }
        }
        return nextCell;
    };

    /**
     * 获取下一个可编辑的单元格
     * @param cell
     * @returns {*}
     */
    AdvancedGrid.prototype.getNextEditableCell = function (cell) {
        var that = this, hit;
        var targetCell = '.uglcw-grid-editable';
        if (that.options.speedy && that.options.speedy.className) {
            targetCell += ('.' + that.options.speedy.className);
        }
        if (cell) {
            var rowIndex = $(cell).closest('tr').index();
            hit = $(cell).find('~ ' + targetCell + ':visible:first');
            if ($(cell).hasClass('uglcw-grid-locked')) {
                hit = $(that._obj).find('.k-grid-content tr:eq(' + rowIndex + ') ' + targetCell + ':visible:first');
            }
        } else {
            if ($(that._obj).find('.k-grid-content-locked').length > 0) {
                hit = $(that._obj).find('.k-grid-content-locked tr:last td' + targetCell + ':visible:first');
                if (hit.length < 0) {
                    hit = $(that._obj).find('.k-grid-content tr:last td' + targetCell + ':visible:first');
                }
            } else {
                hit = $(that._obj).find('.k-grid-content tr:last td' + targetCell + ':visible:first');
            }
        }
        return hit.length > 0 ? hit : false;
    };

    AdvancedGrid.prototype.kInit = function (o) {
        var that = this;
        var opts = uglcw.extend({}, AdvancedGrid.defaults, o);
        var checkbox = false, lockable = false;
        var mergedColumns = [];
        $(opts.columns).each(function (i, column) {
            if (column.locked) {
                lockable = true;
            }
            if (column.selectable) {
                checkbox = true;
            }
            if (column.command) {
                $(that._obj).addClass('uglcw-grid-compact');
            }
            if (column.merge) {
                mergedColumns.push(column)
                appendAttribute(column, 'class', 'uglcw-grid-merged ' + column.field)
            }
        })
        opts.lockable = lockable;
        if (lockable) {
            $(that._obj).addClass('uglcw-grid-locked');
        } else {
            $(that._obj).addClass('uglcw-grid-unlocked');
        }
        opts.checkbox = checkbox;
        opts.selectable = false;
        this.options = uglcw.extend({}, opts, {
            dataBound: function (e) {
                var init = $(that._obj).data('_tooltip');
                if (!init) {
                    $(that._obj).data('_tooltip', true)
                    setTimeout(function () {
                        $(that._obj).find('.k-grid-content').kendoTooltip({
                            filter: '[data-role=tooltip]',
                            position: 'left',
                            content: function (e) {
                                return $(e.target).html()
                            }
                        })

                    }, 200)
                }
                $(that._obj).find('.uglcw-grid-barcode').each(function () {
                    var text = $(this).text();
                    $(this).text('');
                    new ui.Barcode($(this)).init({
                        value: text
                    })
                })

                $(that._obj).find('.uglcw-grid-qrcode').each(function () {
                    var text = $(this).text();
                    $(this).text('');
                    new ui.QRCode($(this)).init({
                        value: text
                    })
                })
                if (that.options.draggable) {
                    setTimeout(function () {
                        grid.table.kendoSortable({
                            hint: $.noop,
                            cursor: "move",
                            placeholder: function (element) {
                                return element.clone().addClass("k-state-hover").css("opacity", 0.65);
                            },
                            container: $(that._obj).find("tbody"),
                            filter: ">tbody >tr",
                            change: function (e) {
                                var skip = grid.dataSource.skip(),
                                    oldIndex = e.oldIndex + skip,
                                    newIndex = e.newIndex + skip,
                                    data = grid.dataSource.data(),
                                    dataItem = grid.dataSource.getByUid(e.item.data("uid"));
                                grid.dataSource.remove(dataItem);
                                grid.dataSource.insert(newIndex, dataItem);
                            }
                        });
                    }, 200)
                }

                //生成行号
                if (that.options.rowNumber) {
                    var rows = this.element.find('.row-number');
                    $(rows).each(function (index) {
                        $(this).html(index + 1);
                    })
                }
                if (opts.editable) {
                    //恢复grid重新渲染前单元格位置
                    if (that.cellIndex !== undefined && that.cellIndex != null && !isNaN(that.cellIndex)) {
                        clearTimeout(that.moveTimer);
                        that.moveTimer = setTimeout(function () {
                            if ((!opts.autoMove) || $(that._obj).data(STAY_IN_CURRENT_CELL)) {
                                that.moveToCell($(that._obj).find('.k-grid-content tr:eq(' + that.rowIndex + ') td:eq(' + that.cellIndex + ')'));
                                $(that._obj).removeData(STAY_IN_CURRENT_CELL);
                            } else {
                                that.moveToNext(that.rowIndex, that.cellIndex, that.autoAppendRow);
                            }
                            that.cellIndex = that.rowIndex = null;
                            // The code below is needed only when the user clicks on the "Save Changes" button.
                            // Otherwise, focusing the table explicitly and unconditionally can steal the page focus.
                            if (that.saveButtonClicked) {
                                e.sender.table.focus();
                                that.saveButtonClicked = false;
                            }
                        })
                    }
                }

                var grid = e.sender;
                var rows = $(that._obj).find('.k-grid-content>table>tbody>tr');
                rows.unbind('click');
                if (opts.checkbox) {
                    var lockedRows = $(that._obj).find('.k-grid-content-locked>table>tbody>tr');
                    lockedRows.unbind('click');
                    lockedRows.on('click', function (e) {
                        var row = $(e.target).closest('tr');
                        if (row.hasClass("k-state-selected")) {
                            var selected = $(that._obj).find('.k-grid-content>table>tbody>tr.k-state-selected');
                            selected = $.grep(selected, function (x) {
                                var itemToRemove = grid.dataItem(row);
                                var currentItem = grid.dataItem(x);
                                return itemToRemove.uid !== currentItem.uid;
                            });
                            grid.clearSelection();
                            grid.select(selected);
                        } else {
                            grid.select(row)
                        }
                    });
                    rows.on('click', function (e) {
                        if ($(e.target).hasClass('k-checkbox-label')) {
                            return;
                        }
                        var row = $(e.target).closest('tr');
                        if (row.hasClass("k-state-selected")) {
                            var selected = $(that._obj).find('.k-grid-content>table>tbody>tr.k-state-selected');
                            selected = $.grep(selected, function (x) {
                                var itemToRemove = grid.dataItem(row);
                                var currentItem = grid.dataItem(x);
                                return itemToRemove.uid !== currentItem.uid;
                            });
                            grid.clearSelection();
                            grid.select(selected);
                        } else {
                            grid.select(row);
                        }
                    });
                } else {
                    rows.on('click', function (e) {
                        if ($(that._obj).hasClass('qwg-grid-locked')) {
                            var lockedRows = $(that._obj).find('.k-grid-content-locked>table>tbody>tr');
                            lockedRows.removeClass('k-state-selected');
                        }
                        var row = $(e.target).closest('tr');
                        rows.removeClass('k-state-selected');
                        grid.select(row);
                    })
                }

                mergeGrid(that, mergedColumns);

                if ($.isFunction(opts.dataBound)) {
                    opts.dataBound.apply(this, [e]);
                }
            }
        });

        $(this._obj).kendouglcwGrid(this.options);
    }

    AdvancedGrid.prototype.value = function (v) {
        return this.bind(v);
    }

    AdvancedGrid.prototype.bind = function (model, data) {
        if (model !== undefined) {
            if ($.isArray(model)) {
                this.k().dataSource.data(model);
                return;
            }
            if (data !== undefined) {
                this.k().dataSource.data(data[model] || []);
            } else if (typeof model === 'string') {
                var result = {};
                result[model] = this.k().dataSource.data().toJSON();
                return result;
            }
        } else {
            return this.k().dataSource.data().toJSON();
        }
    };

    AdvancedGrid.prototype.clearCellIndex = function () {
        this.rowIndex = null;
        this.cellIndex = null;
        $(this._obj).data('forgetCellIndex', true);
    }


    /**
     * 添加数据支持数据
     * @param row
     */
    AdvancedGrid.prototype.addRow = function (row, o) {
        o = o || {}
        o.move = o.move === undefined ? true : o.move;
        var that = this;
        if ($.isArray(row)) {
            $(row).each(function (idx, item) {
                if (that.options.add && $.isFunction(that.options.add)) {
                    item = that.options.add(item);
                }
                if (o.move) {
                    that.clearCellIndex();
                }
                if (o.index !== undefined) {
                    that.k().dataSource.insert(o.index, item);
                } else {
                    that.k().dataSource.add(item)
                }
            })
        } else {
            if (that.options.add && $.isFunction(that.options.add)) {
                row = that.options.add(row || {});
            }
            if (o.move) {
                that.clearCellIndex();
            }
            if (o.index !== undefined) {
                that.k().dataSource.insert(o.index, row);
            } else {
                that.k().dataSource.add(row)
            }
        }
        //that.scrollBottom();
        if (o.move) {
            setTimeout(function () {
                that.k().table.focus();
                that.moveToNextCell();
            }, 50);
        } else {
            $(that._obj).data(STAY_IN_CURRENT_CELL, true);
        }
    }

    AdvancedGrid.prototype.cancelRow = function () {
        this.k().cancelRow();
    };

    /**
     * 根据名称显示列
     * @param column
     */
    AdvancedGrid.prototype.showColumn = function (column) {
        var grid = this.k();
        var index = grid.columns.findIndex(function (col) {
            return col.field == column;
        })
        $(this._obj).find('.uglcw-cell-hide').addClass('uglcw-rendering');
        grid.showColumn(index);
        $(this._obj).find('.uglcw-rendering').removeClass('uglcw-rendering');
    }

    AdvancedGrid.prototype.columnIndex = function (column, includeHidden) {
        var grid = this.k();
        var columns = grid.columns;
        if (includeHidden === undefined || !includeHidden) {
            columns = columns.filter(function (column) {
                return column.hidden === undefined || !column.hidden;
            })
        }
        var index = columns.findIndex(function (col) {
            return col.field === column;
        });
        return index;
    }

    /**
     * 根据名称隐藏列
     * @param column
     */
    AdvancedGrid.prototype.hideColumn = function (column) {
        var grid = this.k();
        var index = grid.columns.findIndex(function (col) {
            return col.field == column;
        })
        $(this._obj).find('.uglcw-cell-hide').addClass('uglcw-rendering');
        grid.hideColumn(index);
        $(this._obj).find('.uglcw-rendering').removeClass('uglcw-rendering');
    }


    AdvancedGrid.prototype.enable = function (bool) {
        this.readonly(!bool);
    };

    AdvancedGrid.prototype.readonly = function (bool) {
        var grid = this.k();
        grid.setOptions({editable: !bool});
        var commandIndex = grid.columns.findIndex(function (column) {
            return column.command;
        })
        if (commandIndex !== -1) {
            if (!bool) {
                grid.showColumn(commandIndex);
            } else {
                grid.hideColumn(commandIndex);
            }
        }
    }

    /**
     * 获取选中行
     * @returns {Array}
     */
    AdvancedGrid.prototype.selectedRow = function () {
        var grid = this.k(), row;
        if (grid.options.persistSelection) {
            return grid._selectedItems;
        }
        row = $(this._obj).find('.k-grid-content tr.k-state-selected');
        var data;
        if (row && row.length > 1) {
            data = [];
            $(row).each(function (idx, item) {
                data.push(grid.dataItem(item));
            });
        } else {
            data = grid.dataItem(row);
            data = data ? [data] : data
        }
        return data;
    };

    AdvancedGrid.prototype.clearSelection = function () {
        var that = this;
        if (that.options.checkbox) {
            this.k().clearSelection();
        } else {
            $(that._obj).find('.k-state-selected').removeClass('k-state-selected');
        }
    };

    /**
     * 删除选中行
     * @param force 是否需要确认提示
     */
    AdvancedGrid.prototype.removeSelectedRow = function (force, callback) {
        var that = this;
        var grid = this.k(), row, removed = [], uids = [];
        if (grid) {
            row = $(this._obj).find('.k-grid-content tr.k-state-selected');

            if (row && row.length > 0) {
                if (row.length > 1) {
                    if (!force) {
                        uglcw.ui.confirm('是否删除选中行？', function () {
                            $(row).each(function (idx, item) {
                                var dataItem = grid.dataItem(item);
                                removed.push(dataItem);
                                uids.push(dataItem.uid);
                            });
                            $(uids).each(function (idx, uid) {
                                grid.removeRow($(that._obj).find('tr[data-uid=' + uid + ']'));
                            });
                            that.moveToLastRow();
                            if ($.isFunction(callback)) {
                                callback(removed);
                            }
                        })
                    } else {
                        $(row).each(function (idx, item) {
                            var dataItem = grid.dataItem(item);
                            removed.push(dataItem);
                            uids.push(dataItem.uid)
                        });
                        $(uids).each(function (idx, uid) {
                            grid.removeRow($(that._obj).find('tr[data-uid=' + uid + ']'));
                        });
                        that.moveToLastRow();
                        if ($.isFunction(callback)) {
                            callback(removed);
                        }
                    }
                } else {
                    if (!force) {
                        uglcw.ui.confirm('是否删除选中行？', function () {
                                removed.push(grid.dataItem(row));
                                grid.removeRow(row);
                                that.moveToLastRow();
                                if ($.isFunction(callback)) {
                                    callback(removed);
                                }
                            }
                        )
                    } else {
                        removed.push(grid.dataItem(row));
                        grid.removeRow(row);
                        that.moveToLastRow();
                        if ($.isFunction(callback)) {
                            callback(removed);
                        }
                    }
                }
            }
        }
    }

    /**
     * 滚动至顶部(需要设置virtualScroll)
     */
    AdvancedGrid.prototype.scrollTop = function () {
        var grid = this.k();
        grid.content.scrollTop(0);
    }

    /**
     * 保存修改
     */
    AdvancedGrid.prototype.commit = function (o) {
        var that = this;
        var grid = this.k();
        //$(this._obj).data('_dont_move_after_sync', true);
        $(grid.dataSource.data()).each(function (idx, item) {
            item.dirty = false;
        })
        if (o) {
            that.rowIndex = o.rowIndex || that.rowIndex;
            that.cellIndex = o.cellIndex || that.cellIndex;
        }
        if (!isNaN(that.cellIndex)) {
            var $cell = $(that._obj).find('.k-grid-content tr:eq(' + that.rowIndex + ') td:eq(' + that.cellIndex + ')');
            if ($cell.closest('tr').is(':last-child') && $cell.is('.uglcw-grid-editable:visible:last') && !$cell.data(EDIT_BY_ENTER)) {
                $(that._obj).data(STAY_IN_CURRENT_CELL, true);
            }
        }
        grid.saveChanges();
    }

    /**
     * 滚至底部
     */
    AdvancedGrid.prototype.scrollBottom = function () {
        var grid = this.k();
        grid.content.scrollTop(grid.content[0].scrollHeight);
    }

    /**
     * 刷新数据
     */
    AdvancedGrid.prototype.reload = function (param) {
        var grid = this.k();
        var autoBind = grid.options.autoBind;
        if (!autoBind) {
            grid.setOptions({
                autoBind: true
            })
        } else {
            if (grid.options.pageable) {
                if (param && param.stay) {
                    grid.dataSource.page(grid.dataSource.page());
                } else {
                    grid.dataSource.page(1);
                }
            } else {
                grid.dataSource.read();
            }
        }
    };

    AdvancedGrid.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    AdvancedGrid.prototype.element = function () {
        return this.k().wrapper;
    }

    AdvancedGrid.prototype.resize = function (container, responsive) {
        var that = this;
        var element = that._obj;
        var options = that.options;
        var others = responsive || that.options.responsive || [];
        container = container || window;
        var surroundHeight = 0;
        $(others).each(function (i, e) {
            if (typeof e == 'number') {
                surroundHeight += e;
            } else {
                surroundHeight += $(e + ':visible').height();
            }
        });
        var targetHeight = $(container).height() - surroundHeight;
        var $grid = $(element);
        var otherHeight = 0;
        //计算非内容部分的高度(header, footer, toolbar...)
        $grid.children().not('.k-grid-content,.k-grid-content-locked').each(function () {
            otherHeight += $(this).outerHeight(true);
        });
        //设置表格高度
        var contentHeight = targetHeight - otherHeight;
        if (options.minHeight) {
            if (contentHeight < options.minHeight) {
                var diff = options.minHeight - contentHeight;
                targetHeight += diff;
            }
        }
        $grid.height(targetHeight);
        //设置表格内容高度
        $grid.find('.k-grid-content').height(targetHeight - otherHeight);
        var hasHScrollBar = $grid.find('.k-grid-content').hasHScrollBar();
        var scrollBarHeight = hasHScrollBar ? 17 : 0;
        $grid.find('.k-grid-content-locked').height(targetHeight - otherHeight - scrollBarHeight);
        var noRecordsTemplate = $grid.find('.k-grid-norecords-template');
        if (noRecordsTemplate.length > 0) {
            //处理无数据模板的位置;
            $(noRecordsTemplate).attr('style', 'position: absolute;');
        }
        var $lockedContent = $grid.find('.k-grid-content-locked');
        var lockedWidth = 0;
        if ($lockedContent.length > 0) {
            lockedWidth = $lockedContent.width() + 2;
        }
        $grid.find('.k-grid-content').width($grid.width() - lockedWidth);
        $grid.find('.k-grid-header').attr('style', 'padding-right: 17px;');
    };

    uglcw.extend(ui, {
        'AdvancedGrid': AdvancedGrid
    })

})(jQuery, window, uglcw);

(function ($, window, uglcw) {
        'use strict';
        var ui = uglcw.ui;
        var util = uglcw.util;

        function Tree(obj) {
            ui.KUI.call(this, obj);
        }

        function traverse(nodes, callback) {
            for (var i = 0; i < nodes.length; i++) {
                var node = nodes[i];
                var children = node.hasChildren && node.children.data();
                callback(node);
                if (children) {
                    traverse(children, callback);
                }
            }
        }

        function visit(data, opts) {
            if (data) {
                $(data).each(function (i, node) {
                    node.expanded = $.isFunction(opts.expandable) ? opts.expandable(node) : node.expanded;
                    node.checked = $.isFunction(opts.checkable) ? opts.checkable(node) : node.checked;
                    if (node[opts.children] && node[opts.children].length > 0) {
                        node.items = node[opts.children];
                        delete node[opts.children];
                        visit(node.items, opts);
                    }
                })
            }
        }

        Tree.prototype = new ui.KUI();
        Tree.prototype.constructor = Tree;
        Tree.defaults = {
            flat: false,
            dataTextField: 'text',
            selection: 'multiple',
            autoWith: true,
            filter: 'contains',
            noDataTemplate: '暂无数据',
            children: 'children',
            lazy: true,
            toJSON: true,
            initLevel: 2
        }
        Tree.prototype.init = function (o) {
            var that = this;
            ui.KUI.prototype.init.call(this, o);
            var opts = $.extend({}, Tree.defaults, o);


            if (opts.checkbox && opts.selection === 'single') {
                var check = opts.check
                opts.checkboxes = true;
                opts.check = function (e) {
                    var dataItem = this.dataItem(e.node);
                    var rootNodes = this.dataSource.data();
                    traverse(rootNodes, function (node) {
                        if (node != dataItem) {
                            node.set('checked', false);
                        }
                    });
                    if ($.isFunction(check)) {
                        check.call(this, e);
                    }
                }
            }

            this.options = opts;
            var children = {
                schema: {
                    data: function (response) {
                        var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                        if (opts.flat) {
                            root = util.arrayToTree(root, opts.flat)
                        }
                        visit(root, opts);
                        return root
                    },
                    model: {
                        id: opts.id || 'id',
                        hashChildren: opts.hasChildren || function (node) {
                            return node.state === 'closed'
                        },
                    }
                },
                transport: {
                    read: {
                        url: opts.url,
                        type: opts.type || 'get',
                        dataType: 'json',
                        data: opts.data || function () {
                        }
                    }
                }
            };
            if (opts.url) {
                if (opts.lazy) {
                    $.ajax({
                        url: opts.url,
                        type: opts.dataType || 'get',
                        dataType: 'json',
                        data: opts.data || function () {
                        },
                        success: function (response) {
                            var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                            if (opts.flat) {
                                root = util.arrayToTree(root, opts.flat)
                            }
                            visit(root, that.options);

                            opts.dataSource = {
                                data: root,
                                schema: {
                                    model: {
                                        id: opts.id || 'id',
                                        hasChildren: opts.initLevel === 1 ? (opts.hasChildren || function (node) {
                                            return node.state === 'closed'
                                        }) : 'items',
                                        children: opts.initLevel === 1 ? children : {
                                            schema: {
                                                data: 'items',
                                                model: {
                                                    id: opts.id || 'id',
                                                    hasChildren: opts.hasChildren || function (node) {
                                                        return node.state === 'closed'
                                                    },
                                                    children: children
                                                },
                                            }
                                        }
                                    },
                                },
                            };
                            opts.dataBound = opts.dataBound || function () {
                            }
                            $(that._obj).kendoTreeView(opts);
                            that.initEvent(o);
                        }
                    })
                } else {
                    $.ajax({
                        url: opts.url,
                        type: opts.dataType || 'get',
                        dataType: 'json',
                        async: false,
                        data: opts.data || function () {
                        },
                        success: function (response) {
                            var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                            if (opts.flat) {
                                root = util.arrayToTree(root, opts.flat)
                            }
                            visit(root, opts);
                            opts.dataSource = new kendo.data.HierarchicalDataSource({
                                data: root
                            });
                            opts.loadOnDemand = false;
                            $(that._obj).kendoTreeView(opts);
                            that.initEvent(o);
                        }
                    });
                }

            } else {
                $(that._obj).kendoTreeView(opts);
                that.initEvent(o);
            }

            $(that._obj).on('click', "li .k-state-selected", function (e) {
                var treeview = that.k();
                var node = $(this).closest("li")[0];
                treeview.trigger("select", {node: node});
            })
        }

        Tree.prototype.reload = function (query) {
            var that = this;
            var opts = that.options;
            var o = opts;
            var children = {
                schema: {
                    data: function (response) {
                        var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                        if (opts.flat) {
                            root = util.arrayToTree(root, opts.flat)
                        }
                        visit(root, opts);
                        return root
                    },
                    model: {
                        id: opts.id || 'id',
                        hashChildren: opts.hasChildren || function (node) {
                            return node.state === 'closed'
                        },
                    }
                },
                transport: {
                    read: {
                        url: opts.url,
                        type: opts.type || 'get',
                        dataType: 'json',
                        data: opts.data || function () {
                        }
                    }
                }
            };


            if (opts.url) {
                if (opts.lazy) {
                    $.ajax({
                        url: opts.url,
                        type: opts.dataType || 'get',
                        dataType: 'json',
                        data: opts.data || function () {
                        },
                        success: function (response) {
                            var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                            if (opts.flat) {
                                root = util.arrayToTree(root, opts.flat)
                            }
                            visit(root, that.options);
                            opts.dataSource = {
                                data: root,
                                schema: {
                                    model: {
                                        id: opts.id || 'id',
                                        hasChildren: 'items',
                                        children: {
                                            schema: {
                                                data: 'items',
                                                model: {
                                                    id: opts.id || 'id',
                                                    hasChildren: opts.hasChildren || function (node) {
                                                        return node.state == 'closed'
                                                    },
                                                    children: {
                                                        schema: {
                                                            data: function (response) {
                                                                var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                                                                if (opts.flat) {
                                                                    root = util.arrayToTree(root, opts.flat)
                                                                }
                                                                visit(root, opts);
                                                                return root
                                                            },
                                                            model: {
                                                                id: opts.id || 'id',
                                                                hashChildren: opts.hasChildren || function (node) {
                                                                    return node.state == 'closed'
                                                                },
                                                            }
                                                        },
                                                        transport: {
                                                            read: {
                                                                url: opts.url,
                                                                type: opts.type || 'get',
                                                                dataType: 'json',
                                                                data: opts.data || function () {
                                                                }
                                                            }
                                                        }
                                                    }
                                                },
                                            }
                                        }
                                    },
                                },
                            };
                            opts.dataBound = opts.dataBound || function () {
                            }
                            that.k().setDataSource(new kendo.data.HierarchicalDataSource(opts.dataSource));
                        }
                    })
                } else {
                    $.ajax({
                        url: opts.url,
                        type: opts.dataType || 'get',
                        dataType: 'json',
                        async: false,
                        data: opts.data || function () {
                        },
                        success: function (response) {
                            var root = $.isFunction(o.loadFilter) ? o.loadFilter(response) : (response || []);
                            if (opts.flat) {
                                root = util.arrayToTree(root, opts.flat)
                            }
                            visit(root, opts);
                            opts.dataSource = new kendo.data.HierarchicalDataSource({
                                data: root
                            });
                            that.k().setDataSource(opts.dataSource);
                        }
                    });
                }

            } else {
                that.k().dataSource.read();
            }
        };

        /**
         * 获取选中节点数据
         * @returns {Array}
         */
        Tree.prototype.selectedNodes = function () {
            var that = this;
            var checked = []


            function gather(nodes) {
                $(nodes).each(function (idx, node) {
                    var status = $(that._obj).find('#_' + node.uid).closest('li.k-item').attr('aria-checked');

                    if (status === 'true' || status === 'mixed') {
                        var n = that.options.toJSON ? node.toJSON() : node;
                        delete n['items'];
                        //标记半选中
                        if (status === 'mixed') {
                            n.halfChecked = true;
                        }
                        checked.push(n)
                    }
                    if (node.hasChildren) {
                        gather(node.children.view());
                    }
                })
            }

            var nodes = this.k().dataSource.view();
            gather(nodes);
            return checked;
        };

        Tree.prototype.nodes = function (gather) {
            var that = this;
            var checked = [];

            function gatherAll(nodes) {
                $(nodes).each(function (idx, node) {
                    var status = $(that._obj).find('#_' + node.uid).closest('li.k-item').attr('aria-checked');
                    var n = node.toJSON();
                    if (status === 'true') {
                        n.checked = true
                    }
                    if (status === 'mixed') {
                        n.halfChecked = true
                    }
                    checked.push(n);
                    if (node.hasChildren) {
                        gatherAll(node.children.view());
                    }
                })
            }

            if (gather) {
                gatherAll(this.k().dataSource.view());
            } else {
                checked = this.k().dataSource.view().toJSON();
            }
            return checked;
        };

        Tree.prototype.selectedIds = function () {
            var checked = $.map(this.selectedNodes(), function (node) {
                return node.id
            });
            return checked;
        }

        Tree.prototype.expand = function (target) {
            this.k().expand(target || '.k-item');
        }

        Tree.prototype.collapse = function (target) {
            this.k().collapse(target || '.k-item');
        }

        Tree.prototype.clearSelection = function () {
            var tree = this.k();
            tree.select($());
            if (tree.options.checkboxes) {
                $(this._obj).find('.k-checkbox-wrapper input').prop('checked', false).trigger('change');
            }

        }

        Tree.prototype.value = function (v) {
            var k = this.k();
            if (v == undefined) {
                return k.value();
            }
            k.value(v);
        }

        Tree.prototype.enable = function (bool) {
            this.k().enable(bool);
        }

        Tree.prototype.readonly = function (bool) {
            this.k().readonly(bool);
        }

        Tree.prototype.k = function () {
            return kendo.widgetInstance($(this._obj));
        }

        Tree.prototype.element = function () {
            return this.k().wrapper;
        }

        uglcw.extend(ui, {
            'Tree': Tree
        })

    }
)(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Upload(obj) {
        ui.KUI.call(this, obj);
    }

    Upload.prototype = new ui.KUI();
    Upload.prototype.constructor = Upload;
    Upload.defaults = {
        showFileList: true,
        dropZone: '.drop-zone',
        field: 'file'
    }
    Upload.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        var that = this;
        var opts = uglcw.extend({}, Upload.defaults, {
            async: {
                saveUrl: o.url,
                saveField: o.field,
                autoUpload: o.autoUpload
            },
            success: function (e) {
            },
            select: function (index, file) {
            }
        }, o);
        $(that._obj).kendoUpload(opts).data('kendoUpload');
        this.initEvent(opts);
    }

    Upload.prototype.upload = function () {
        this.k().upload();
    }


    Upload.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    Upload.prototype.enable = function (bool) {
        this.readonly(!bool);
    }

    Upload.prototype.readonly = function (bool) {
        var uploader = this.k();
    }

    Upload.prototype.k = function () {
        return $(this._obj).data('kendoUpload');
    }

    Upload.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Upload': Upload
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Modal(obj) {
        ui.BaseUI.call(this, obj);
    }

    function disableBtn(layero) {
        $()
    }

    function enableBtn(layero) {

    }

    Modal.prototype = new ui.BaseUI();
    Modal.prototype.constructor = Modal;

    Modal.prototype.init = function (o) {
        ui.BaseUI.prototype.init.call(this, o);

        this.initEvent(o);
    }

    Modal.defaults = {
        title: '标题',
        content: '',
        area: '500px',
        okText: '确定',
        cancelText: '取消',
        resizable: true,
        closable: true,
        full: false,
        shade: 0.3,
        shadeClose: false,
        scrollbar: false,
        btnAlign: 'r',
        maxmin: true,
        ok: function () {
        },
        cancel: function () {
        }
    }

    Modal.open = function (o) {
        var opts = $.extend({}, Modal.defaults, o);
        var type = 1
        if (opts.url) {
            type = 2;
            opts.content = opts.url;
        }
        var config = {
            id: opts.id,
            type: type,
            title: opts.title,
            resize: opts.resizable,
            closeBtn: opts.closable,
            btnAlign: opts.btnAlign,
            offset: opts.offset,
            area: opts.area,
            content: opts.content,
            shade: opts.shade,
            anim: opts.anim || 0,
            shadeClose: opts.shadeClose,
            moveOut: opts.moveOut,
            move: opts.move,
            btn: opts.btns === undefined ? [opts.okText, opts.cancelText] : opts.btns,
            scrollbar: opts.scrollbar,
            fixed: opts.fixed,
            maxmin: opts.maxmin,
            full: opts.fullscreen,
            min: opts.min,
            restore: opts.restore,
            success: function (layero, index) {
                if (opts.full) {
                    layer.full(index);
                    if ($.isFunction(opts.fullscreen)) {
                        setTimeout(function () {
                            opts.fullscreen.call(opts, layero);
                        }, 200);
                    }
                }
                if (opts.url) {
                    layer.iframeAuto(index);
                }
                if (opts.success && $.isFunction(opts.success)) {
                    opts.success(layero, index)
                }
            },
            yes: function (index, layero) {
                if (opts.__yes) {
                    return;
                }
                opts.__yes = true;
                if (opts.yes && $.isFunction(opts.yes)) {
                    var ret = opts.yes(layero, index)
                    if (ret !== false) {
                        layer.close(index);
                    } else {
                        opts.__yes = false;
                    }
                }
            },
            cancel: function (index, layero) {
                if (opts.cancel && $.isFunction(opts.cancel)) {
                    return opts.cancel(layero, index)
                } else {
                    return true
                }
            },
            btn2: function (index, layero) {
                if (opts.__btn2) {
                    return;
                }
                opts.__btn2 = true;
                if (opts.btn2 && $.isFunction(opts.btn2)) {
                    var ret = opts.btn2(layero, index);
                    return ret;
                }
                return true;
            },
            btn3: function (index, layero) {
                if (opts.__btn3) {
                    return;
                }
                opts.__btn3 = true;
                if (opts.btn3 && $.isFunction(opts.btn3)) {
                    var ret = opts.btn3(layero, index);
                    opts.__btn3 = false;
                    return ret;
                } else {
                    return true;
                }
            },
            resizing: function (layero) {
                var delay = $(layero).data('resize_delay');
                if (delay) {
                    window.clearTimeout(delay)
                }
                if (opts.resizing && $.isFunction(opts.resizing)) {
                    $(layero).data('resize_delay', setTimeout(function () {
                        opts.resizing(layero)
                    }, 200));
                }
            }
        };

        if (opts.btns) {
            var btns = $.map(opts.btns, function (btn, index) {
                if (typeof btn === 'string') {
                    return btn;
                } else if (typeof btn === 'object') {
                    if (index === 0) {
                        config['yes'] = btn.click
                    } else {
                        config['btn' + (index + 1)] = btn.click
                    }
                    return btn.name
                }
            })
            config.btn = btns;
        }

        var i = layer.open(config);
        uglcw.currentModal = i;
        return i;
    }

    Modal.close = function (i) {
        var i = i === undefined ? layer.index : i;
        layer.close(i);
    }

    Modal.showGridSelector = function (o) {
        o = uglcw.extend({
            persistSelection: true,
            clearSelection: false,
            pageable: true,
        }, o);
        return Modal.open({
            size: o.size || 'small',
            title: o.title === undefined ? '请选择' : o.title,
            closable: o.closable,
            area: o.area || [(o.width ? o.width + 'px' : '650px'), (o.height ? o.height + 'px' : '350px')],
            moveOut: true,
            resizable: o.resizable,
            maxmin: o.maxmin === undefined ? false : o.maxmin,
            scrollbar: false,
            content: '<div class="uglcw-selector-container"><div class="criteria"></div><div class="uglcw-grid uglcw-small"></div></div>',
            success: function (container) {
                var height = $(container).find('.layui-layer-content').height();
                var columns = o.columns || [];
                if (o.checkbox) {
                    columns.splice(0, 0, {
                        width: 35,
                        selectable: true,
                        type: 'checkbox',
                        locked: true,
                        attributes: {'class': 'uglcw-grid-checkbox'},
                        headerAttributes: {'class': 'uglcw-grid-checkbox'}
                    })
                }
                if (o.criteria) {
                    //自定义查询条件
                    $(container).find('.criteria').html(o.criteria);
                    $(container).find('.criteria').append('<button class="k-info search-btn" uglcw-role="button">搜索</button>');
                    uglcw.ui.init($(container).find('.criteria'));
                    uglcw.ui.get($(container).find('.criteria .search-btn')).on('click', function () {
                        uglcw.ui.get($(container).find('.uglcw-grid')).reload();
                    })
                }

                $(columns).each(function (i, column) {
                    if (column.tooltip) {
                        column.attributes = columns.attributes || {};
                        column.attributes['show-tooltip'] = true;
                    }
                })
                var $grid = $(container).find('.uglcw-grid');
                var g = new ui.Grid($grid);
                g.kInit({
                    height: height - $(container).find('.criteria').height() - 15,
                    dataSource: {
                        schema: $.extend({
                            model: {
                                id: o.id || 'id',

                            },
                            data: function (response) {
                                return response.rows || []
                            },
                            total: function (response) {
                                return response.total || 0;
                            },
                            aggregates: function (response) {
                                return response.aggregates || {};
                            }
                        }, o.loadFilter),
                        transport: {
                            read: {
                                url: o.url,
                                data: function (param) {
                                    param.rows = param.pageSize;
                                    delete param['take'];
                                    delete param['skip'];
                                    delete param['aggregate'];
                                    delete param['pageSize'];
                                    //查询区域选择器
                                    var criteria = ui.bind($(container).find('.criteria'));
                                    param = uglcw.extend(param, criteria);
                                    //查询参数拦截器
                                    if ($.isFunction(o.query)) {
                                        param = o.query(param);
                                    }
                                    return param;
                                }
                            }
                        },
                        serverAggregates: true,
                        serverPaging: true,
                        pageSize: o.pageSize || 20
                    },
                    pageable: o.pageable ? uglcw.extend({
                        numeric: true,
                        refresh: true,
                        input: true,
                        pageSize: o.pageSize,
                        buttonCount: 3,
                        messages: {display: "总计:{2}", empty: "当前无数据", page: "跳转至"},
                        pageSizes: [10, 20, 50, 100]
                    }, o.pageable) : false,
                    columns: columns,
                    aggregate: o.aggregate,
                    dataBound: function (e) {
                        if (o.dataBound && $.isFunction(o.dataBound)) {
                            o.dataBound(e)
                        }
                        var init = $grid.data('__tooltip');
                        if (!init) {
                            $grid.data('__tooltip', true);
                            setTimeout(function () {
                                $grid.find('.k-grid-content').kendoTooltip({
                                    filter: 'td[show-tooltip=true]',
                                    position: 'left',
                                    content: function (e) {
                                        return $(e.target).html()
                                    }
                                })
                            }, 200)
                        }

                    }
                });
                $grid.on('dblclick', 'tbody tr', function () {
                    var grid = ui.get($grid).k();
                    var row = grid.dataItem($(this));
                    if (o.yes && $.isFunction(o.yes)) {
                        var ret = o.yes([row]);
                        if (ret === undefined || ret) {
                            ui.Modal.close();
                        }
                    }
                })
                if ($.isFunction(o.success)) {
                    o.success(container, g);
                }
            },
            btns: o.btns === undefined ? ['选中并继续', '确定', '取消'] : o.btns,
            yes: function (container) {
                var grid = ui.get($(container).find('.uglcw-grid'));
                var rows = grid.selectedRow();
                if (o.clearSelection) {
                    grid.clearSelection();
                }
                if (o.yes && $.isFunction(o.yes)) {
                    o.yes(rows);
                    if (o.clearSelection) {
                        grid.clearSelection();
                    }
                    return false
                }
            },
            btn2: function (container) {
                if (o.btns) {
                    if (o.btn2 && $.isFunction(o.btn2)) {
                        return o.btn2(container);
                    }
                } else {
                    var rows = ui.get($(container).find('.uglcw-grid')).selectedRow();
                    if (o.yes && $.isFunction(o.yes)) {
                        return o.yes(rows);
                    }
                }
                return true;
            },
            btn3: function (container) {
                return true
            },
            resizing: function (container) {
                var $container = $(container).find('.uglcw-grid');
                var grid = uglcw.ui.get($container).k();
                var padding = 18;
                var height = $($(container).find('.layui-layer-content')).height() - $($(container).find('.criteria')).height() - padding;
                grid.setOptions({
                    height: height
                });
            }
        })
    }

    Modal.showTreeSelector = function (o) {
        return Modal.open({
            offset: o.offset,
            closable: o.closable,
            btns: o.btns,
            maxmin: o.maxmin === undefined ? false : o.maxmin,
            okText: o.okText,
            title: o.title === undefined ? '请选择' : o.title,
            area: o.area || '300px',
            content: '<div class="uglcw-selector-container"><div class="uglcw-tree"></div></div>',
            success: function (container) {
                new ui.Tree($(container).find('.uglcw-tree')).init(uglcw.extend({
                    lazy: o.lazy,
                    expand: o.expand,
                    id: o.id || 'id',
                    url: o.url,
                    selection: o.selection,
                    data: o.data,
                    autoScroll: o.autoScroll || true,
                    checkbox: o.checkbox === undefined ? true : o.checkbox,
                    checkboxes: o.checkboxes || {
                        checkChildren: true
                    },
                    hasChildren: o.hasChildren || function (node) {
                        return node.state == 'closed';
                    },
                }, o))
                if ($.isFunction(o.success)) {
                    o.success(container);
                }
            },
            yes: function (container) {
                var t = ui.get($(container).find('.uglcw-tree'));
                var nodes = t.selectedNodes();
                if (o.yes && $.isFunction(o.yes)) {
                    o.yes(nodes, t.nodes(), t.nodes(true));
                }
            },
            btn2: o.btn2 || function (container) {
            },
            btn1: o.btn1,
            cancel: o.cancel
        })
    }

    Modal.showTreeGridSelector = function (o) {
        o = uglcw.extend({
            clearSelection: false,
            persistSelection: true
        }, o);
        return Modal.open({
            closable: o.closable,
            title: o.title === undefined ? '请选择' : o.title,
            area: o.area === undefined ? (o.width ? o.width + 'px' : '800px') : o.area,
            moveOut: true,
            scrollbar: false,
            resizable: o.resizable,
            maxmin: o.maxmin === undefined ? false : o.maxmin,
            content: '<div class="uglcw-selector-container">' +
                '<div>' +
                '<div class="col-xs-5" style="padding-top: 20px;padding-right: 0px;"><div style="overflow-y: auto; height: 370px;" class="uglcw-tree"></div></div>' +
                '<div class="col-xs-19" style="padding-left: 5px;"><div class="criteria"></div><div class="uglcw-grid uglcw-small"></div></div>' +
                '</div></div>',
            success: function (container) {
                var height = $(container).find('.layui-layer-content').height();
                var $tree = $(container).find('.uglcw-tree');
                $tree.css('height', (height - 25) + 'px');
                var $grid = $(container).find('.uglcw-grid');
                var $criteria = $(container).find('.criteria');
                var treeOpts = uglcw.extend({
                    select: function (e) {
                        var node = this.dataItem(e.node);
                        var id = node[o.tree.id || 'id'];
                        var param = {};
                        param[(o.tree.model || 'typeId')] = id;
                        //选中值绑定到搜索区域
                        ui.bind($criteria, param);
                        //刷新grid
                        ui.get($grid).reload();
                    }
                }, o.tree);
                $criteria.append('<input uglcw-model="' + (o.tree.model || 'typeId') + '"  uglcw-role="textbox" type="hidden">');

                var t = new ui.Tree($tree);
                t.init(treeOpts);

                var columns = o.columns || [];
                if (o.checkbox) {
                    columns.splice(0, 0, {
                        width: 35,
                        selectable: true,
                        type: 'checkbox',
                        locked: true,
                        attributes: {'class': 'uglcw-grid-checkbox'},
                        headerAttributes: {'class': 'uglcw-grid-checkbox'}
                    })
                }
                if (o.criteria) {
                    //自定义查询条件
                    $criteria.append(o.criteria);
                    $criteria.append('<button class="k-info search-btn" uglcw-role="button">搜索</button>');
                    uglcw.ui.init($criteria);
                    uglcw.ui.get($criteria.find('.search-btn')).on('click', function () {
                        uglcw.ui.get($(container).find('.uglcw-grid')).reload()
                    })
                }

                $(columns).each(function (i, column) {
                    if (column.tooltip) {
                        column.attributes = columns.attributes || {};
                        column.attributes['show-tooltip'] = true;
                    }
                });

                var g = new ui.Grid($grid);
                g.kInit({
                    aggregate: o.aggregate,
                    persistSelection: o.persistSelection,
                    height: height - $(container).find('.criteria').height() - 15,
                    size: o.size || 'small',
                    dataSource: {
                        schema: $.extend({
                            model: {
                                id: o.id || 'id',
                            },
                            data: function (response) {
                                return response.rows || []
                            },
                            total: function (response) {
                                return response.total || 0;
                            },
                            aggregates: function (response) {
                                return response.aggregates || {};
                            }
                        }, o.loadFilter),
                        transport: {
                            read: {
                                url: o.url,
                                data: function (param) {
                                    param.rows = param.pageSize;
                                    delete param['take'];
                                    delete param['skip'];
                                    delete param['aggregate'];
                                    delete param['pageSize'];
                                    //查询区域选择器
                                    var criteria = ui.bind($criteria);
                                    param = uglcw.extend(param, criteria);
                                    //查询参数拦截器
                                    if ($.isFunction(o.query)) {
                                        param = o.query(param);
                                    }
                                    return param;
                                }
                            }
                        },
                        batch: true,
                        serverAggregates: true,
                        serverPaging: true,
                        pageSize: o.pageSize || 20
                    },
                    pageable: {
                        numeric: true,
                        refresh: true,
                        input: true,
                        pageSize: o.pageSize,
                        buttonCount: 3,
                        messages: {display: "总计:{2}", empty: "当前无数据", page: "转至"},
                        pageSizes: [10, 20, 50, 100]
                    },
                    columns: columns,
                    dataBound: function (e) {
                        var grid = this;
                        if (o.dataBound && $.isFunction(o.dataBound)) {
                            o.dataBound(e)
                        }
                        var init = $grid.data('__tooltip');
                        if (!init) {
                            $grid.data('__tooltip', true)
                            setTimeout(function () {
                                $grid.find('.k-grid-content').kendoTooltip({
                                    filter: 'td[show-tooltip=true]',
                                    position: 'left',
                                    content: function (e) {
                                        return $(e.target).html()
                                    }
                                })
                            }, 200)
                        }

                        if (o.selection && o.selection.length > 0) {
                            setTimeout(function () {
                                var data = grid.dataSource.data();
                                var idField = o.id || 'id';
                                $(data).each(function (i, row) {
                                    $(o.selection).each(function (j, item) {
                                        if (item[idField] == row[idField]) {
                                            var ck = $grid.find('tr[data-uid=' + row.uid + '] input.k-checkbox');
                                            if (!ck.is(':checked')) {
                                                grid.select($grid.find('tr[data-uid=' + row.uid + ']'));
                                            }
                                            return false
                                        }
                                    })
                                })
                            }, 50);
                        }
                    }
                });

                $grid.on('dblclick', 'tbody tr', function () {
                    var grid = ui.get($grid).k();
                    var row = grid.dataItem($(this));
                    if (o.yes && $.isFunction(o.yes)) {
                        var ret = o.yes([row]);
                        if (ret === undefined || ret) {
                            ui.Modal.close();
                        }
                    }
                });
                if ($.isFunction(o.success)) {
                    o.success(container, t, g);
                }
            },
            btns: o.btns || ['选中并继续', '确定', '取消'],
            yes: function (container) {
                var grid = ui.get($(container).find('.uglcw-grid'));
                var rows = grid.selectedRow();
                if (o.clearSelection) {
                    grid.clearSelection();
                }
                if (o.yes && $.isFunction(o.yes)) {
                    o.yes(rows);
                    return false
                }
            },
            btn2: function (container) {
                if (o.btns) {
                    if (o.btn2 && $.isFunction(o.btn2)) {
                        return o.btn2(container);
                    }
                } else {
                    var rows = ui.get($(container).find('.uglcw-grid')).selectedRow();
                    if (o.yes && $.isFunction(o.yes)) {
                        return o.yes(rows);
                    }
                }
            },
            btn3: o.btn3 || o.cancel,
            resizing: function (container) {
                var $container = $(container).find('.uglcw-grid')
                var grid = uglcw.ui.get($container).k();
                var padding = 18;
                var height = $($(container).find('.layui-layer-content')).height() - $($(container).find('.criteria')).height() - padding;
                grid.setOptions({
                    height: height
                });
            }
        })
    }

    Modal.showUpload = function (o) {
        var i = Modal.open({
            btns: o.btns,
            closable: o.closable === undefined ? true : o.closable,
            okText: '上传',
            title: o.title === undefined ? '请选择' : o.title,
            area: '300px',
            content: '<div class="upload-container"><input class="uglcw-file-input" type="file">' +
                '<div class="drop-zone"><div class="text-wrapper"><p><i class="k-icon k-i-plus"></i></p><p class="drop-file-here">拖拽文件到此处</p></div></div></div>',
            success: function (container) {
                var uploader = new ui.Upload($(container).find('.uglcw-file-input'));
                uploader.init({
                    url: o.url,
                    field: o.field,
                    autoUpload: o.autoUpload === undefined ? false : o.autoUpload,
                    error: o.error || function () {
                    },
                    success: function (e) {
                        if ($.isFunction(o.success)) {
                            var result = o.success(e);
                            if (result == undefined || result == true) {
                                ui.Modal.close(i);
                            }
                        } else {
                            ui.Modal.close(i);
                        }
                    },
                    upload: o.upload || function () {
                    },
                    complete: o.complete || function () {
                    }
                });
                $(container).data('_uploader', uploader);
                $(container).find('.drop-zone').on('click', function () {
                    $(container).find('.uglcw-file-input').click();
                })
            },
            yes: function (container) {
                var uploader = $(container).data('_uploader');
                uploader.upload();
                return false;
            },
            btn2: function () {

            }
        })
    }

    Modal.showMap = function (o) {
        var options = uglcw.extend({
            //启用显示定位
            enableGeolocation: true,
        }, o);
        Modal.open({
            content: '<div id="_uglcw-map">',
            success: function (container) {

            }
        })
    }

    Modal.showProgress = function (o) {
        o = uglcw.extend({
            percent: 0,
        }, o)
        var id = uglcw.util.uuid();
        Modal.open({
            maxmin: false,
            closable: false,
            modal: true,
            resizable: false,
            move: false,
            content: '<div id="' + id + '" class="layui-progress layui-progress-big" lay-filter="' + id + '" lay-showPercent="true">' +
                '                        <div class="layui-progress-bar" lay-percent="' + (o.percent || 0) + '%"></div>' +
                '                    </div>',
            success: function (c) {
                layui.element.progress(id, o.percent);
            },
            title: false,
            btns: []
        })
    }

    Modal.prototype.hide = function () {
        this.k().hide();
    }

    Modal.prototype.value = function (v) {

    }

    Modal.prototype.enable = function (bool) {
    }

    Modal.prototype.readonly = function (bool) {
    }

    Modal.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Modal.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Modal': Modal
    })

})(jQuery, window, uglcw);

(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Editor(obj) {
        ui.KUI.call(this, obj);
    }

    Editor.prototype = new ui.KUI();
    Editor.prototype.constructor = Editor;

    Editor.defaults = {
        content: true,
        toolbar: true
    };

    Editor.prototype.init = function (o) {
        var opts = uglcw.extend({}, Editor.defaults, o);
        ui.KUI.prototype.init.call(this, opts);
        $(this._obj).kendoEditor(opts);
        this.initEvent(opts);
    };

    Editor.prototype.value = function (v) {
        var k = this.k();
        if (v === undefined) {
            return k.value();
        }
        k.value(v);
    }

    Editor.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    Editor.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    Editor.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Editor.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Editor': Editor
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Accordion(obj) {
        ui.KUI.call(this, obj);
    }

    Accordion.prototype = new ui.KUI();
    Accordion.prototype.constructor = Accordion;

    Accordion.defaults = {
        expandAll: false, //初始化展开所有
        expandFirst: true,
        expandMode: 'single', //
        minHeight: 200,
    };

    Accordion.prototype.init = function (o) {
        var that = this;
        var opts = uglcw.extend({
            expand: function () {
                //that.resize();
            }
        }, Accordion.defaults, o);
        ui.KUI.prototype.init.call(this, opts);
        $(this._obj).addClass("uglcw-accordion k-widget k-reset k-header k-panelbar");
        $(this._obj).attr('tabindex', 0);
        $(this._obj).attr('role', 'menu');
        var lis = $(this._obj).find('li');
        var height = $(this._obj).parent().height();
        height = height < opts.minHeight ? opts.minHeight : height;
        $(this._obj).css('height', (height - lis.length) + 'px');
        var contentHeight = height - lis.length * 32;
        $(lis).each(function (i, li) {
            var $li = $(li);
            $li.addClass('accordion-item k-item k-state-default');
            var children = $li.children();
            var header = children[0];
            $(header).wrap('<span class="uglcw-accordion-header k-link k-header"></span>');
            $('<span class="k-icon k-i-arrow-chevron-down k-panelbar-collapse"></span>').insertAfter(header);
            var content = children[1];
            $(content).addClass('k-content').css({
                display: 'none',
                height: contentHeight + 'px',
                overflow: 'auto',
                padding: 0
            });
            $(content).children().first().css({
                height: contentHeight + 'px',
                overflow: 'auto'
            })
        });

        $(that._obj).on('click', '.k-header', function () {
            that.toggle($(this).closest('li.accordion-item'));
        });

        if (opts.expandFirst) {
            that.toggle($(that._obj).find('li:eq(0)'))
        }
        $(window).on('resize', function () {
            that.resize()
        });
        setTimeout(function () {
            that.resize();
        }, 1000);
        this.initEvent(opts);
    };

    Accordion.prototype.toggle = function (li) {
        var that = this;
        var $li = $(li);
        $li.find('.uglcw-accordion-header .k-icon').toggleClass("k-i-arrow-chevron-down k-i-arrow-chevron-up");
        var content = $li.find('.k-content');
        if (!content.is(':visible')) {
            var other = $(that._obj).find('.accordion-item.k-state-active');
            if (other.length > 0) {
                other.removeClass('k-state-active');
                other.find('.uglcw-accordion-header .k-icon').toggleClass("k-i-arrow-chevron-down k-i-arrow-chevron-up");
                other.find('.k-content').slideUp()
            }
            $li.addClass('k-state-active');
            content.slideDown()
        } else {
            $li.removeClass('k-state-active');
            content.slideUp()
        }
    };

    Accordion.prototype.resize = function () {
        var that = this;
        var parent = $(that._obj).parent();
        var height = parent.height();
        var lis = $(this._obj).find('li.accordion-item');
        $(this._obj).css('height', (height - lis.length) + 'px');
        var contentHeight = height - lis.length * 32;
        lis.each(function () {
            var $content = $(this).find('.k-content');
            $content.css('height', contentHeight + 'px');
            $content.children().first().css({
                height: contentHeight + 'px'
            })
        })
    }

    Accordion.prototype.value = function (v) {

    }

    Accordion.prototype.enable = function (bool) {

    }

    Accordion.prototype.readonly = function (bool) {

    }

    Accordion.prototype.k = function () {

    }

    Accordion.prototype.element = function () {
        return this._obj;
    }

    uglcw.extend(ui, {
        'Accordion': Accordion
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Tag(obj) {
        ui.KUI.call(this, obj);
    }

    Tag.prototype = new ui.KUI();
    Tag.prototype.constructor = Tag;

    Tag.defaults = {
        closable: false,
        type: 'primary'
    }

    Tag.prototype.init = function (o) {
        var that = this
        var opts = uglcw.extend({}, Tag.defaults, o);
        opts.message = opts.message || $(this._obj).text() || '';
        opts.target = $(that._obj);
        ui.KUI.prototype.init.call(this, o);
        $(this._obj).text('');
        $.elementUI.createTag(opts);
        $(that._obj).on('click', '.el-tag', function(){
            if($.isFunction(opts.click)){
                opts.click.call(this, opts);
            }
        });
        $(that._obj).on('mousedown', '.el-icon-close', function(e){
            if($.isFunction(opts.close)){
                opts.close.call(this, e, opts);
            }
        });
    }

    Tag.prototype.value = function (v) {

    }

    Tag.prototype.enable = function (bool) {

    }

    Tag.prototype.readonly = function (bool) {

    }

    uglcw.extend(ui, {
        'Tag': Tag
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Album(obj) {
        ui.KUI.call(this, obj);
    }

    var AlbumItem = kendo.data.Model.define({
        fields: {
            fid: {
                type: 'string'
            },
            title: {
                type: 'string'
            },
            thumb: {
                type: 'string'
            },
            url: {
                type: 'string'
            },
            checked: {
                type: 'boolean',
                default: false
            }
        },
        idStr: function () {
            return 'uglcw_album_' + this.get('id');
        }
    });

    Album.prototype = new ui.KUI();
    Album.prototype.constructor = Album;

    Album.defaults = {
        enable: true,
        sortable: false,
        multiple: true, //是否允许多张
        checkbox: false, //是否启用多选框，
        cropper: 0, // 0: 不裁剪 1: 必裁剪 2: 可选
        aspectRatio: 1, //裁剪比例，cropper为true时有效
        field: 'file',
        limit: 0,
        preview: true, //是否允许查看大图
        editable: false, //是否允许编辑
        accept: '.jpg,.png,.jpeg,.gif'
    };

    Album.prototype.init = function (o) {
        var that = this;
        var opts = uglcw.extend({}, Album.defaults, o);
        that.opts = opts;
        var uuid = uglcw.util.uuid();
        $(that._obj).addClass('uglcw-album');
        $(that._obj).html('<div class="album-list" data-bind="source: dataSource" data-template="album-item-tpl-' + uuid + '"></div>' +
            '<div class="album-opts"><input class="album-upload" accept="' + opts.accept + '" type="file"></div>' +
            '<div class="album-add" data-bind="visible: addable"><i class="ion-md-camera"></i></div>');
        $('<script id="album-item-tpl-' + uuid + '" type="text/x-uglcw-template">' +
            '    <div class="album-item">' +
            '        <div class="album-select" data-bind="visible: checkbox">' +
            '            <input data-bind="attr: {id: idStr}, checked: checked" class="k-checkbox" type="checkbox">' +
            '            <label data-bind="attr: {for: idStr}" class="k-checkbox-label"></label>' +
            '        </div>' +
            '        <img data-bind="attr: {src: thumb}">' +
            '        <div class="album-item-cover">' +
            '            <i class="ion-ios-eye" data-bind="click: preview"></i>' +
            '            <i class="ion-ios-trash" data-bind="click: remove, visible: enable"></i>' +
            '        </div>' +
            '    </div>' +
            '</script>').appendTo(that._obj);
        that.vm = kendo.observable({
            limit: opts.limit,
            editable: opts.editable,
            addable: true,
            enable: opts.enable,
            deleted: [],
            checkbox: opts.checkbox,
            checkAll: function (check) {
                $.map(this.dataSource, function (item) {
                    item.set('checked', check);
                })
            },
            value: function(v){
                var dataSource = this.get('dataSource');
                dataSource.splice(0, that.vm.dataSource.length);
                $(v).each(function (idx, item) {
                    dataSource.push(new AlbumItem(item));
                })
                if (that.vm.limit > 0 && dataSource.length >= that.vm.limit) {
                    that.vm.set('addable', false);
                }else{
                    that.vm.set('addable', true);
                }
            },
            edit: function(e){

            },
            remove: function (e) {
                var data = e.data;
                var dataSource = this.get('dataSource');
                var index = dataSource.indexOf(data);
                uglcw.ui.confirm('确定删除吗？', function () {
                    if (data.id) {
                        that.vm.deleted.push(data.id)
                    }
                    dataSource.splice(index, 1);
                    if (that.vm.limit > 0 && that.vm.limit > dataSource.length) {
                        that.vm.set('addable', true);
                    }
                })
            },
            preview: function (e) {
                var data = e.data;
                var dataSource = this.get('dataSource');
                var index = dataSource.indexOf(data);
                layer.photos({
                    photos: {
                        start: index, data: $.map(dataSource, function (item) {
                            return {
                                src: item.url,
                                pid: item.fid,
                                alt: item.title,
                                thumb: item.thumb || item.url
                            }
                        })
                    }, anim: 5
                });
            },
            dataSource: []
        });
        //初始化数据
        if (o.dataSource) {
            $(o.dataSource).each(function (idx, item) {
                if (o.limit > 0 && idx > o.limit) {
                    that.vm.addable = false;
                    return false;
                }
                item.thumb = item.thumb || item.url;
                that.vm.dataSource.push(new AlbumItem(item));
            });
            if (o.limit > 0 && o.dataSource.length >= o.limit) {
                that.vm.addable = false;
            }
        }
        kendo.bind($(that._obj), that.vm);

        if (o.sortable) {
            $(that._obj).find('.album-list').kendoSortable({
                axis: 'x',
                cursor: 'move',
                filter: '.album-item',
                container: $(that._obj).find('.album-list'),
                placeholder: function (element) {
                    return element.clone().addClass('album-placeholder');
                },
                hint: function (element) {
                    var e = element.clone();
                    e.find('.album-item-cover').remove();
                    e.find('.album-select').remove();
                    return e;
                },
                change: function (e) {
                    var f = e.oldIndex, to = e.newIndex;
                    var tmp = that.vm.dataSource[to];
                    that.vm.dataSource[to] = that.vm.dataSource[f];
                    that.vm.dataSource[f] = tmp;
                    if (o.sort && $.isFunction(o.sort)) {
                        o.sort(e);
                    }
                }
            });
        }
        $(that._obj).find('.album-add').on('click', function () {
            $(that._obj).find('.album-opts .album-upload:last').click();
        })


        if (opts.cropper && $('#cropper-tpl').length < 1) {
            //插入模板
            $('<script id="cropper-tpl" type="text/x-uglcw-template">' +
                '    <div class="cropper-wrapper">' +
                '        <div class="img-box">' +
                '            <img class="cropper-image">' +
                '        </div>' +
                '        <div class="right-con">' +
                '            <div class="preview-box"></div>' +
                '            <div class="button-box">' +
                '                <button class="k-button k-info rotate"><i class="k-icon k-i-rotate-right"></i></button>' +
                '                <button class="k-button zoom-out k-info"><i class="k-icon k-i-zoom-out"></i></button>' +
                '                <button class="k-button k-info zoom-in"><i class="k-icon k-i-zoom-in"></i></button>' +
                '                <button class="k-button k-info flip-horizontal"><i class="k-icon k-i-flip-horizontal"></i></button>' +
                '                <button class="k-button k-info flip-vertical"><i class="k-icon k-i-flip-vertical"></i></button>' +
                '                <button class="k-button k-info arrow-up"><i class="k-icon k-i-arrow-chevron-up"></i></button>' +
                '                <button class="k-button k-info arrow-left"><i class="k-icon k-i-arrow-chevron-left"></i></button>' +
                '                <button class="k-button k-info arrow-down"><i class="k-icon k-i-arrow-chevron-down"></i></button>' +
                '                <button class="k-button k-info arrow-right"><i class="k-icon k-i-arrow-chevron-right"></i></button>' +
                '            </div>' +
                '        </div>' +
                '    </div>' +
                '</script>').appendTo($('body'));
        }
        var doUpload = function (fileItem) {
            if (o.upload && $.isFunction(o.upload)) {
                o.upload(fileItem);
            }
            var formData = new FormData();
            formData.append(o.async.saveField || 'file', fileItem.file);
            $.ajax({
                url: o.async.saveUrl,
                type: 'post',
                cache: false,
                data: formData,
                processData: false,
                contentType: false,
            }).done(function (response) {
                if (o.success && $.isFunction(o.success)) {
                    var resp = o.success(response);
                    var item = new AlbumItem({
                        fid: fileItem.fid,
                        file: fileItem.file,
                        url: resp.url,
                        thumb: resp.thumb || resp.url,
                        title: fileItem.name
                    });
                    that.vm.dataSource.push(item);
                } else {
                    that.vm.dataSource.push(fileItem);
                }
                if (that.vm.limit > 0 && that.vm.limit <= that.vm.dataSource.length) {
                    that.vm.set('addable', false);
                }
            }).fail(function () {
                uglcw.ui.toast('上传失败');
            });
        };
        var uploadOptions = {
            dropZone: $(that._obj).find('.album-add:last'),
            multiple: opts.multiple,
            select: function (e) {
                var exists = that.vm.dataSource.length;
                $(e.files).each(function (idx, file) {
                    if (o.limit > 0 && exists + idx >= o.limit) {
                        return false;
                    }
                    var raw = file.rawFile;
                    if (raw) {
                        setTimeout(function () {
                            var reader = new FileReader();
                            reader.onloadend = function () {
                                var url = this.result;
                                if (opts.cropper) {
                                    var btns = ['裁剪', '取消'];
                                    if (opts.cropper === 2) {
                                        btns = ['裁剪', '不裁剪', '取消'];
                                    }
                                    uglcw.ui.Modal.open({
                                        maxmin: false,
                                        area: ['600px', '370px'],
                                        content: $('#cropper-tpl').html(),
                                        title: false, //'裁剪',
                                        btns: btns,
                                        closeBtn: false,
                                        success: function (container) {
                                            $(container).find('.cropper-image').attr('src', url);
                                            $(container).find('.cropper-image').cropper({
                                                checkCrossOrigin: false,
                                                aspectRatio: opts.aspectRatio || 1,
                                                preview: '.preview-box',
                                            });
                                            var cropper = $(container).find('.cropper-image').data('cropper');
                                            var move = function (x, y) {
                                                cropper.move(x, y);
                                            }
                                            $(container).find('.k-button.rotate').on('click', function () {
                                                cropper.rotate(90);
                                            });
                                            $(container).find('.k-button.zoom-out').on('click', function () {
                                                cropper.zoom(-0.1);
                                            });
                                            $(container).find('.k-button.zoom-in').on('click', function () {
                                                cropper.zoom(0.1);
                                            });
                                            $(container).find('.k-button.flip-horizontal').on('click', function () {
                                                cropper['scaleX'](-cropper.getData()['scaleX'])
                                            });
                                            $(container).find('.k-button.flip-vertical').on('click', function () {
                                                cropper['scaleY'](-cropper.getData()['scaleY'])
                                            });
                                            $(container).find('.k-button.arrow-up').on('click', function () {
                                                move(0, -4);
                                            });
                                            $(container).find('.k-button.arrow-down').on('click', function () {
                                                move(0, 4);
                                            });
                                            $(container).find('.k-button.arrow-left').on('click', function () {
                                                move(-4, 0);
                                            });
                                            $(container).find('.k-button.arrow-right').on('click', function () {
                                                move(4, 0);
                                            })
                                        },

                                        yes: function (container) {
                                            //裁剪
                                            var cropper = $(container).find('.cropper-image').data('cropper');
                                            var canvas = cropper.getCroppedCanvas();
                                            canvas.toBlob(function (blob) {
                                                var item = new AlbumItem({
                                                    fid: uglcw.util.uuid(),
                                                    file: new File([blob], file.name, {
                                                        type: blob.type,
                                                        lastModified: Date.now()
                                                    }),
                                                    url: canvas.toDataURL(),
                                                    thumb: canvas.toDataURL(),
                                                    title: file.name
                                                });
                                                if (o.async) {
                                                    doUpload(item);
                                                } else {
                                                    if (that.vm.limit > 0 && that.vm.limit <= that.vm.dataSource.length) {
                                                        return uglcw.ui.warning('图片数量超出限制');
                                                    }
                                                    that.vm.dataSource.push(item);
                                                    if (that.vm.limit > 0 && that.vm.limit <= that.vm.dataSource.length) {
                                                        that.vm.set('addable', false);
                                                    }
                                                }
                                            })
                                        },
                                        btn2: function () {
                                            //不裁剪
                                            if (that.vm.limit > 0 && that.vm.limit < that.vm.dataSource.length) {
                                                return uglcw.ui.warning('图片数量超出限制');
                                            }
                                            var item = new AlbumItem({
                                                fid: uglcw.util.uuid(),
                                                file: raw,
                                                url: url,
                                                thumb: url,
                                                title: file.name
                                            });
                                            if (o.async) {
                                                doUpload(item);
                                            } else {
                                                that.vm.dataSource.push(item);
                                                if (that.vm.limit > 0 && that.vm.limit <= that.vm.dataSource.length) {
                                                    that.vm.set('addable', false);
                                                }
                                            }
                                        }
                                    })
                                } else {
                                    if (that.vm.limit > 0 && that.vm.limit < that.vm.dataSource.length) {
                                        return uglcw.ui.warning('图片数量超出限制');
                                    }
                                    var item = new AlbumItem({
                                        fid: uglcw.util.uuid(),
                                        file: raw,
                                        url: url,
                                        thumb: url,
                                        title: file.name
                                    });
                                    if (o.async) {
                                        doUpload(item);
                                    } else {
                                        that.vm.dataSource.push(item);
                                        if (that.vm.limit > 0 && that.vm.limit <= that.vm.dataSource.length) {
                                            that.vm.set('addable', false);
                                        }
                                    }
                                }
                            };
                            reader.readAsDataURL(raw);
                        }, 100)
                    }
                })
            }
        };
        var uploader = new uglcw.ui.Upload($(that._obj).find('.album-upload'));
        uploader.init(uploadOptions);
    };


    Album.prototype.value = function (v) {
        var that = this;
        if (v !== undefined) {
            //清空
            that.vm.value(v);
        } else {
            return that.vm.dataSource.toJSON();
        }
    };

    Album.prototype.getDeleted = function () {
        return this.vm.deleted;
    };

    Album.prototype.bindFormData = function (formData) {
        var that = this;
        $.map(that.vm.dataSource.toJSON(), function (item) {
            if (item.file) {
                formData.append(that.opts.field, item.file, item.title);
            }
        });
        return formData;
    };

    Album.prototype.enable = function (bool) {
    }

    Album.prototype.readonly = function (bool) {

    }

    uglcw.extend(ui, {
        'Album': Album
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var Widget = kendo.ui.Widget;
    var uglcwGridSelector = Widget.extend({
        init: function (element, o) {
            Widget.fn.init.call(this, element, o);
            var that = this;
            var style = $(element).attr('style');
            var readonly = $(element).prop('readonly');
            if (readonly) {
                $(element).removeAttr('readonly');
                $(element).attr('data-readonly', true);
            }
            if (!o.allowInput) {
                $(element).attr('data-readonly', !o.allowInput);
            }
            $(element).wrap('<div class="k-gridselector k-textbox k-space-right" ' + (style ? 'style="' + style + '"' : '') + '></div>');
            //初始化样式
            $(element).after('<a href="javascript:void(0);" class="k-select k-icon ' + o.icon + '"></a>');

            var $wrapper = $(element).closest('.k-gridselector');
            var widget = $(element);
            this._validation();
            if (o.clearButton) {
                var clearButton = $('<span unselectable="on" class="k-icon k-clear-value k-i-close" title="clear" role="button" tabindex="-1"></span>');
                clearButton.insertBefore($wrapper.find('.k-select'));
                clearButton.on('click', function (e) {
                    that.value('');
                    that.text('');
                    widget.trigger('change');
                });

                if (!that.value()) {
                    $wrapper.find('.k-i-close').addClass('k-hidden');
                }
                widget.bind('change', function () {
                    if (!that.value()) {
                        $wrapper.find('.k-i-close').addClass('k-hidden');
                    } else {
                        $wrapper.find('.k-i-close').removeClass('k-hidden');
                    }
                });
            }
            $wrapper.on('mouseenter', function () {
                if (that.enable()) {
                    $(this).addClass('k-state-hover');
                }
            });

            $wrapper.on('mouseleave', function () {
                $(this).removeClass('k-state-hover');
            });


            $(element).closest('.k-textbox').find('.' + o.icon).on('click', function () {
                if ($.isFunction(o.click)) {
                    o.click.apply(that);
                } else {
                    ui.Modal.showGridSelector(o.selectorOptions || {})
                }
            });

            $(element).on('dblclick', function () {
                if ($.isFunction(o.click)) {
                    o.click.apply(that);
                } else {
                    ui.Modal.showGridSelector({})
                }
            });
            if (o.value) {
                this.value(o.value);
            }
            if (o.text) {
                this.text(o.text);
            }
            if (o.readonly) {
                this.readonly(true)
            }
            if (o.disable) {
                this.enable(false);
            }
            if (o.tooltip) {
                new ui.Tooltip($wrapper).init({
                    content: ui.attr(element, 'label') || o.tooltip
                })
            }
            if($.isFunction(o.change)){

            }

        },
        options: {
            name: "uglcwGridSelector",
        },
        _validation: function () {
            var that = this;
            var element = that.element;
            that._validationIcon = $('<span class=\'k-icon k-i-warning\'></span>').hide().insertAfter(element);
        },
        readonly: function (readonly) {
            if (readonly !== undefined) {
                $(this.element).attr('data-readonly', readonly);
            } else {
                return $(this.element).prop('data-readonly')
            }
        },
        enable: function (enable) {
            if (enable !== undefined) {
                if (enable) {
                    $(this.element).closest('.k-textbox').removeClass('k-state-disabled');
                } else {
                    $(this.element).closest('.k-textbox').addClass('k-state-disabled');
                }
            } else {
                return !$(this.element).closest('.k-textbox').hasClass('k-state-disabled');
            }
        },
        destroy: function () {

        },
        value: function (v) {
            if (v === undefined) {
                return $(this.element).val();
            } else {
                $(this.element).val(v);
                $(this.element).trigger('change');
            }
        },
        text: function (v) {
            if (v === undefined) {
                return $(this.element).data('text')
            } else {
                $(this.element).data('text', v);
            }
        }
    });

    kendo.ui.plugin(uglcwGridSelector);

    function GridSelector(obj) {
        ui.KUI.call(this, obj);
    }

    GridSelector.prototype = new ui.KUI();
    GridSelector.prototype.constructor = GridSelector;

    GridSelector.defaults = {
        dataTextField: "text",
        dataValueField: "value",
        selectorOptions: {}, //弹出框配置: uglcw.ui.Modal.showGridSelector
        icon: 'k-i-more-horizontal', //右侧图标
        allowInput: false, //是否允许输入
        disable: false,
        readonly: false,
        tooltip: false,
        clearButton: true
    };

    GridSelector.prototype.init = function (o) {
        var that = this;
        ui.KUI.prototype.init.call(this, o);
        o = $.extend({}, GridSelector.defaults, o);
        $(that._obj).kendouglcwGridSelector(o);
        this.initEvent(o);
    };

    GridSelector.prototype.value = function (v) {
        return this.k().value(v);
    };

    GridSelector.prototype.text = function (t) {
        return this.k().text(t);
    };

    GridSelector.prototype.bind = function (model, v) {
        var widget = this.k();
        if (model.indexOf(',') === -1) {
            if (v === undefined) {
                var result = {};
                result[model] = widget.value();
                return result;
            } else {
                return widget.value(v[model]);
            }
        } else {
            var fields = model.split(',');
            if (v === undefined) {
                var result = {};
                result[fields[0]] = widget.value();
                result[fields[1]] = widget.text();
                return result;
            } else {
                widget.value(v[fields[0]]);
                widget.text(v[fields[1]]);
            }
        }
    }

    GridSelector.prototype.enable = function (bool) {
        return this.k().enable(bool);
    };

    GridSelector.prototype.readonly = function (bool) {
        return this.k().readonly(bool);
    };

    GridSelector.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    };

    GridSelector.prototype.element = function () {
        return this.k().element
    };

    uglcw.extend(ui, {
        'GridSelector': GridSelector
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Scheduler(obj) {
        ui.KUI.call(this, obj);
    }

    Scheduler.prototype = new ui.KUI();
    Scheduler.prototype.constructor = Scheduler;
    Scheduler.defaults = {
        autoWith: true,
        filter: 'contains',
        noDataTemplate: '暂无数据'
    }
    Scheduler.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);

        var opts = $.extend({}, Scheduler.defaults, o)
        if (opts.url) {
            opts.dataSource = {
                serverFiltering: true,
                schema: $.extend({
                    data: function (response) {
                        return response.list || []
                    }
                }, opts.loadFilter),
                transport: {
                    read: {
                        url: opts.url,
                        type: opts.type || 'get',
                        data: function (param) {
                            var query = uglcw.extend({}, param);
                            if (opts.criteria) {
                                var criteria = ui.bind(opts.criteria);
                                query = uglcw.extend(query, criteria);
                            }
                            if ($.isFunction(opts.query)) {
                                query = opts.query(query);
                            }
                            return query;
                        }
                    }
                }
            }
        }
        $(this._obj).kendoScheduler(opts);
        this.initEvent(o);
    }

    Scheduler.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    };

    Scheduler.prototype.reload = function () {
        this.k().dataSource.read();
    };

    Scheduler.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    Scheduler.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    Scheduler.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Scheduler.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Scheduler': Scheduler
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function QRCode(obj) {
        ui.KUI.call(this, obj);
    }

    QRCode.prototype = new ui.KUI();
    QRCode.prototype.constructor = QRCode;

    QRCode.defaults = {

    };

    QRCode.prototype.init = function (o) {
        var opts = uglcw.extend({}, QRCode.defaults, o);
        ui.KUI.prototype.init.call(this, opts);
        $(this._obj).kendoQRCode(opts);
        this.initEvent(opts);
    };

    QRCode.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    QRCode.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    QRCode.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    QRCode.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    QRCode.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'QRCode': QRCode
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;

    function Barcode(obj) {
        ui.KUI.call(this, obj);
    }

    Barcode.prototype = new ui.KUI();
    Barcode.prototype.constructor = Barcode;

    Barcode.defaults = {

    };

    Barcode.prototype.init = function (o) {
        var opts = uglcw.extend({}, Barcode.defaults, o);
        ui.KUI.prototype.init.call(this, opts);
        $(this._obj).kendoBarcode(opts);

        this.initEvent(opts);
    };

    Barcode.prototype.value = function (v) {
        var k = this.k();
        if (v == undefined) {
            return k.value();
        }
        k.value(v);
    }

    Barcode.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    Barcode.prototype.readonly = function (bool) {
        this.k().readonly(bool);
    }

    Barcode.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Barcode.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Barcode': Barcode
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var KEY_DELAY = '_resize_delay';

    function Resizable(obj) {
        ui.KUI.call(this, obj);
    }

    function bindResize(element, options) {
        var others = options.responsive;
        var doResize = function () {
            var delay = $(element).data(KEY_DELAY);
            if (delay) {
                clearTimeout(delay);
            }
            delay = setTimeout(function () {
                var surroundHeight = 0; //周围高度;
                $(others).each(function (index, item) {
                    if (typeof item === 'number') {
                        surroundHeight += item;
                    } else {
                        surroundHeight += $(item).height();
                    }
                });
                var targetHeight = $(window).height() - surroundHeight;
                $(element).css('height', targetHeight).css('overflow-y', 'auto');
                if (options.resize && $.isFunction(options.resize)) {
                    options.resize()
                }
            }, options.delay);
            $(element).data(KEY_DELAY, delay);
        };
        $(window).resize(doResize);
        doResize();
    }


    Resizable.prototype = new ui.KUI();
    Resizable.prototype.constructor = Resizable;

    Resizable.defaults = {
        delay: 50,
        responsive: [],
        resize: function () {
        }
    };

    Resizable.prototype.init = function (o) {
        ui.KUI.prototype.init.call(this, o);
        this.options = uglcw.extend({}, Resizable.defaults, o);
        $(this._obj).addClass('uglcw-resizable');
        bindResize(this._obj, this.options);
        this.initEvent(o);
    }

    Resizable.prototype.enable = function (bool) {
        this.k().enable(bool);
    }

    Resizable.prototype.readonly = function (bool) {
        this.k().enable(!bool);
    }

    Resizable.prototype.k = function () {
        return kendo.widgetInstance($(this._obj));
    }

    Resizable.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'Resizable': Resizable
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var ui = uglcw.ui;
    var E = window.wangEditor;

    function WangEditor(obj) {
        ui.KUI.call(this, obj);
    }

    WangEditor.prototype = new ui.KUI();
    WangEditor.prototype.constructor = WangEditor;

    WangEditor.defaults = {
        debug: false,
        menus: [
            'head',  // 标题
            'bold',  // 粗体
            'fontSize',  // 字号
            'fontName',  // 字体
            'italic',  // 斜体
            'underline',  // 下划线
            'strikeThrough',  // 删除线
            'foreColor',  // 文字颜色
            'backColor',  // 背景颜色
            'link',  // 插入链接
            'list',  // 列表
            'justify',  // 对齐方式
            'quote',  // 引用
            'emoticon',  // 表情
            'image',  // 插入图片
            'table',  // 表格
            'video',  // 插入视频
            'code',  // 插入代码
            'undo',  // 撤销
            'redo'  // 重复
        ],
        fontNames: [
            '宋体',
            '微软雅黑',
            'Arial',
            'Tahoma',
            'Verdana'
        ],
        uploadImgServer: '/manager/photo/wangEditorUpload',
        uploadFileName: 'file',
        uploadImgMaxSize: 3 * 1024 * 1024,
        uploadImgMaxLength: 5
    };

    WangEditor.prototype.init = function (o) {
        var opts = uglcw.extend({}, WangEditor.defaults, o);
        ui.KUI.prototype.init.call(this, opts);
        var editor = new E(this._obj);
        editor.customConfig = opts;
        editor.create();
        $(this._obj).data('wangEditor', editor);
        this.initEvent(opts);
    };

    WangEditor.prototype.value = function (v) {
        var k = this.k();
        if (v === undefined) {
            var content = k.txt.html();
            return content == '<p><br></p>' ? '' : content;
        }
        k.txt.html(v);
    };

    WangEditor.prototype.append = function (html) {
        this.k().txt.append(html);
    }

    WangEditor.prototype.clear = function () {
        this.k().txt.clear();
    }

    WangEditor.prototype.enable = function (bool) {
        var editor = this.k();
        editor.$textElem.attr('contenteditable', bool);
    }

    WangEditor.prototype.readonly = function (bool) {
        this.k().enable(!bool);
    }

    WangEditor.prototype.k = function () {
        return $(this._obj).data('wangEditor');
    }

    WangEditor.prototype.element = function () {
        return this.k().wrapper;
    }

    uglcw.extend(ui, {
        'WangEditor': WangEditor
    })

})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    var layout = {
        initialized: false
    };
    layout.init = function () {
        if (this.initialized) {
            return;
        }
        this.initialized = true;
        var gridResizing = function () {
            var $grid = $('.uglcw-layout-content .uglcw-grid');
            if ($grid.length > 0) {
                $grid.each(function () {
                    uglcw.ui.get(this).resize();
                });
            }
        };
        var TOGGLE_BAR = '.uglcw-layout-toggle-bar';
        var $fixeds = $('.uglcw-layout-fixed');
        $fixeds.each(function () {
            var $fixed = $(this);
            var options = uglcw.util.parseObject(uglcw.ui.attr($fixed, 'options'));

            $fixed.children().wrapAll('<div class="uglcw-layout-fixed-content"></div>');
            var $content = $fixed.find('.uglcw-layout-fixed-content');
            $fixed.data('width', $fixed.width());
            if ($fixed.find(TOGGLE_BAR).length === 0) {
                $('<div class="uglcw-layout-toggle-bar"><div class="k-icon k-i-arrow-chevron-left"></div></div>').appendTo($fixed);
            }

            $fixed.on('click', TOGGLE_BAR, function () {
                $(this).find('.k-icon').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-right');
                if ($fixed.width() > 16) {
                    $content.hide();
                    $fixed.animate({
                        width: 0,
                    }, 300, function () {
                        $content.hide();
                        gridResizing();
                    });
                    if ($.isFunction(options.change)) {
                        options.change(false);
                    }
                } else {
                    $fixed.animate({
                        width: $fixed.data('width')
                    }, 300, function () {
                        $content.show();
                        gridResizing();
                    });
                    if ($.isFunction(options.change)) {
                        options.change(true);
                    }
                }
            });

            if (options.collapsed) {
                $fixed.width(0);
                $content.hide();
            }
        })

        //搜索条件回车
        $('.uglcw-query').on('keydown', 'input', function (e) {
            if (e.keyCode === kendo.keys.ENTER) {
                $('.uglcw-query #search').click();
            }
        });
        var querySolution = {
            list: function (module) {
                $.ajax({
                    url: '/manager/common/querysolution/' + module,
                    type: 'get',
                    success: function (response) {
                        if (response.success && response.data && response.data.length > 0) {
                            $('.uglcw-query .query-solution-item').remove();
                            $.map(response.data, function (solution) {
                                var $tag = $('<li class="query-solution-item"></li>');
                                $tag.appendTo($('.uglcw-query'));
                                var tag = new uglcw.ui.Tag($tag);
                                tag.init({
                                    solution: solution,
                                    type: 'primary',
                                    message: solution.title,
                                    closable: true,
                                    click: function (o) {
                                        $('.uglcw-query .el-tag').removeClass('el-tag--default').addClass('el-tag--primary');
                                        $($tag).find('.el-tag').removeClass('el-tag--primary').addClass('el-tag--default');
                                        querySolution.query(module, o.solution.id);
                                    },
                                    close: function (e, o) {
                                        querySolution.remove(module, o.solution.id, function (success) {
                                            if (!success) {
                                                e.stopPropagation();
                                            }
                                            querySolution.list(module);
                                        })
                                    }
                                });
                            });
                            uglcw.ui.get('.uglcw-grid').resize();
                        }
                    }
                })
            },
            remove: function (namespace, id, callback) {
                $.ajax({
                    async: false,
                    url: '/manager/common/querysolution/' + namespace + '/' + id,
                    type: 'DELETE',
                    success: function (response) {
                        callback(response.success);
                    },
                    error: function () {
                        callback(false);
                    }
                })
            },
            add: function (module, title, share) {
                var query = uglcw.ui.bind('.uglcw-query');
                var items = $.map(query, function (v, k) {
                    return {
                        field: k,
                        value: v,
                        op: 0
                    }
                });
                $.ajax({
                    url: '/manager/common/querysolution/' + module,
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        namespace: module,
                        title: title,
                        items: items,
                        share: share
                    }),
                    success: function (response) {
                        if (response.success) {
                            uglcw.ui.success(response.message || '保存成功');
                            querySolution.list(module);
                        }
                    }
                })
            },
            query: function (module, id) {
                $.ajax({
                    url: '/manager/common/querysolution/' + module + '/' + id,
                    type: 'GET',
                    success: function (response) {
                        if (response.success) {
                            var items = response.data || [], query = {};
                            $.map(items, function (item) {
                                query[item.field] = item.value;
                            });
                            uglcw.ui.bind('.uglcw-query', query);
                            $('.uglcw-query #search').click();
                        }
                    }
                })
            }
        };
        var module = $('.uglcw-query').data('module');
        if (module) {
            querySolution.list(module);
            if ($('#search').length > 0) {
                var $li = $('#search').closest('li');
                $li.css('cssText', 'width:180px !important;');
                $li.append('<button class="query-solution-save ghost k-button k-info">保存</button>');
                $li.find('.query-solution-save').on('click', function () {
                    uglcw.ui.Modal.open({
                        title: '新增查询方案',
                        maxmin: false,
                        content: '<input class="query-solution-input" placeholder="请输入查询方案名称" uglcw-role="textbox" uglcw-model="title">',
                        btns: ['保存', '保存为共享方案', '取消'],
                        success: function (c) {
                            uglcw.ui.init(c);
                            $(c).find('.query-solution-input').focus();
                        },
                        yes: function (c) {
                            querySolution.add(module, uglcw.ui.bind($(c)).title, false)
                        },
                        btn2: function (c) {
                            querySolution.add(module, uglcw.ui.bind($(c)).title, true)
                        }
                    })
                })
            }
        }


    };
    uglcw.layout = layout;
})(jQuery, window, uglcw);
(function ($, window, uglcw) {
    'use strict';
    var biz = {};
    var ui = uglcw.ui;
    var util = uglcw.util;
    biz.state = function (context, state) {
        $(context).find('[' + ui.attrPrefix + 'role]').each(function (i, el) {
            var tempState = ui.attr(el, 'state');
            tempState = (tempState === undefined ? 7 : util.toInt(tempState));
            var widget = ui.get(el);
            if (widget.state) {
                widget.state(state);
            } else {
                var enable = (tempState & state) > 0;
                if (!enable || ($(this).attr('readonly') !== 'readonly')) {
                    widget.enable(enable);
                }
            }
        });
    };
    uglcw.biz = biz;
})(jQuery, window, uglcw);