(function ($, window) {
    var uglcw_service = function () {
        return {};
    }
    uglcw_service.fn = uglcw_service.prototype = {};


    var initElement = function () {
        return '<style id="styleuglcwim-data-mall">'
            + '@media (max-height:600px),(max-width:1000px){[uglcwim-data-mall].main-contact{position:fixed;bottom:150px;right:15px;z-index:100000000000000000}[uglcwim-data-mall].main-contact .icon{display:block;width:30px;height:30px;background-image:url(/static/uglcu/images/chat-btn.png);background-size:100% 100%;vertical-align:-3px}[uglcwim-data-mall].main-contact .chat-btn{padding:10px;display:-webkit-box;display:-ms-flexbox;display:flex;font-size:12px;-webkit-box-orient:vertical;-webkit-box-direction:normal;-ms-flex-direction:column;flex-direction:column;text-decoration:none;padding:5px 10px;border-radius:2px}[uglcwim-data-mall].main-contact .chat-btn .txt{display:block;margin-top:-2px}[uglcwim-data-mall].main-contact .dot{width:12px;height:12px;border-radius:50%;position:absolute;top:-6px;right:-6px;background:#ed4343;border:1px solid #fff;box-shadow:0 2px 4px 0 rgba(0,0,0,.5)}[uglcwim-data-mall].main-contact .state{display:none}}@media (min-height:600px) and (min-width:1000px){[uglcwim-data-mall].main-contact{position:fixed;bottom:50px;right:50px;display:block;z-index:100000000000000000}[uglcwim-data-mall].main-contact .icon{display:inline-block;width:24px;height:24px;background-image:url(/static/uglcu/images/chat-btn.png);background-size:100% 100%;margin-right:10px;vertical-align:top}[uglcwim-data-mall].main-contact .chat-btn{width:138px;padding:13px 10px;font-size:0;height:50px}[uglcwim-data-mall].main-contact .txt{display:inline-block;font-size:16px;line-height:24px}[uglcwim-data-mall].main-contact .dot{display:none}[uglcwim-data-mall].main-contact .state{display:inline-block;width:138px;height:50px;position:absolute;background:#fff;left:-153px;top:0;z-index:99999;line-height:50px;box-shadow:0 2px 8px 0 rgba(0,0,0,.14)}[uglcwim-data-mall].main-contact .state .desc{color:#000;padding-left:16px;position:relative;font-size:16px}[uglcwim-data-mall].main-contact .state .desc:before{display:inline-block;border-radius:50%;content:"";width:6px;height:6px;background:#265bed;position:absolute;left:0;top:50%;margin-top:-3px}[uglcwim-data-mall].main-contact .state .desc:after{content:"";position:absolute;width:0;height:0;border-color:transparent;border-style:solid;right:-26px;border-width:5px 0 5px 5px;border-left-color:#fff;top:50%;margin-top:-5px}}[uglcwim-data-mall] .chat-btn{display:inline-block;margin-bottom:0;font-weight:400;text-align:center;-ms-touch-action:manipulation;touch-action:manipulation;cursor:pointer;background-image:none;border:none;white-space:nowrap;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;min-width:50px;padding:7px 10px;font-size:15px;color:#fff;background-color:#4979ff;box-sizing:border-box;vertical-align:middle}@media (max-height:600px),(max-width:1000px){[uglcwim-data-mall].main-chat{position:fixed;top:0;left:0;right:0;bottom:0;z-index:10000000000000000}[uglcwim-data-mall].main-chat .main-iframe{width:100%;height:100%;position:fixed;top:0;bottom:0;left:0;right:0}}@media (min-height:600px) and (min-width:1000px){[uglcwim-data-mall].main-chat{position:fixed;width:375px;max-height:667px;height:calc(100vh - 100px);right:50px;bottom:50px;background:#fafafb;box-shadow:0 2px 8px 0 rgba(0,0,0,.14);overflow:hidden}[uglcwim-data-mall].main-chat .main-iframe{width:100%;height:100%}}'
            + '</style>'
            + '<div uglcwim-data-mall id="uglcwim-main-contact" class="main-contact">'
            + '<a href="javascript:;" id="uglcwim-chat-btn" class="chat-btn">'
            + '<i class="icon" id="uglcwim-icon"></i>'
            + '<span class="txt">客服</span>'
            + '     <i class="dot" id="uglcwim-dot" style="display:none"></i>'
            + '      <div class="state" id="uglcwim-state" style="display:none"><span class="desc">客服已回复</span></div>'
            + '  </a>'
            + '  </div>'
            + '  <div uglcwim-data-mall id="uglcwim-main-chat" class="main-chat" style="display:none">'
            + '      <iframe id="uglcwim-main-iframe" class="main-iframe" frameborder="0"></iframe>'
            + '      </div>';
    };

    uglcw_service.init = function (o) {
        var html = initElement();
        var x = document.createElement("div");
        x.innerHTML = html;
        document.body.appendChild(x);
        var c = $('#uglcwim-main-contact');
        var iframe = document.getElementById('uglcwim-main-iframe');
        c.find('.chat-btn').on('tap', function () {
            if (!iframe.src) {
                iframe.src = o.url;
                iframe.onload = function () {
                    iframe.contentWindow.postMessage({type: "init"}, "*")
                }
            }
            $('#uglcwim-dot').hide();
            $('.main-chat').toggle();
        });
        window.addEventListener('message', function (e) {
            var event = e.data || {};
            if (event.type === 'close') {
                $('#uglcwim-dot').hide();
                $('.main-chat').toggle();
            } else if (event.type === 'message') {
                $('#uglcwim-dot').show();
            }
        })
    }


    window.uglcw_service = uglcw_service
})
(jQuery, window);