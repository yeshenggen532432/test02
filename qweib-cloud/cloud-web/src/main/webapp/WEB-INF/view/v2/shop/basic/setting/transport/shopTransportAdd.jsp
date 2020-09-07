<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>运费模版增加或修改</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>


    <style>
        .wrap{padding:30px;}
        .postage-tpl-head .label-like{text-align:left}
        .postage-tpl .default{background:#e6f4fb!important;line-height:36px !important;padding:10px 15px !important;}
        .dialog-areas .title{height:40px !important;line-height:40px !important;border:none !important;margin-top:26px}
        .dialog-areas .ks-ext-close{margin-top:26px}
        .dialog-areas{box-shadow:1px 1px 8px 1px !important;border-radius:3px;}
        .dialog-areas button{padding:6px 3px !important ;}
        .dialog-areas .btns{margin-left:330px !important ;}
        td{height: 40px;}
        .btn_wuliu{font-weight: 700;color: #fff;width: 120px;height: 34px;border-radius: 4px; cursor: pointer; box-shadow: 1px 1px 0 rgba(0,0,0,0.1);background:#449ce7;}
        .w30{width:30px}
        .w50{width:50px}
    </style>

    <link href="${base}/resource/transport/transport.css" rel="stylesheet" type="text/css">

<body>

<%--批量操作开始--%>
    <div id="dialog_batch" class="ks-ext-position ks-overlay ks-dialog dialog-batch" style="left: 0px; top: 0px; z-index: 9999; display: none">
        <div class="ks-contentbox">
            <div class="ks-stdmod-header"></div>
            <div class="ks-stdmod-body">
                <form method="post">
                    默认运费：
                    <input class="w50 text" type="text" maxlength="4" autocomplete="off" data-field="start" value="1" name="express_start"> 件内，
                    <input class="w50 text" type="text" maxlength="6" autocomplete="off" value="0.00" name="express_postage" data-field="postage"> 元， 每增加
                    <input class="w50 text" type="text" maxlength="4" autocomplete="off" value="1" data-field="plus" name="express_plus"> 件，增加运费
                    <input class="w50 text" type="text" maxlength="6" autocomplete="off" value="0.00" data-field="postageplus" name="express_postageplus"> 元
                    <div class="J_DefaultMessage"></div>
                    <div class="btns">
                        <button class="J_SubmitPL" type="button">确定</button>
                        <button class="J_Cancel" type="button">取消</button>
                    </div>
                </form>
            </div>
            <div class="ks-stdmod-footer"></div>
            <a class="ks-ext-close" href="javascript:void(0)"> <span
                    class="ks-ext-close-x">X</span>
            </a>
        </div>
    </div>
<%--批量操作结束--%>


                <form method="post" id="tpl_form" name="tpl_form" action="javascript:void(0);">
                    <input type="hidden" name="transport_id" value="" />
                    <div class="postage-tpl" id="df">
                    <div class="postage-tpl-head" style="margin-left:0">
                        <div class="clear30"></div>
                        <ul>
                            <li class="form-elem"><label for="J_TemplateTitle" class="label-like" style="text-align:left">模板名称：</label>
                                <input type="text" class="text" id="title" autocomplete="off" value="" name="title">
                                <p class="msg" style="display: none" error_type="title">
                                    <span class="error">必须填写模板名称</span>
                                </p>
                                <span class="field-note">除指定地区外，其余地区的运费采用"默认运费"</span>
                            </li>
                        </ul>
                    </div>
                        <p class="trans-line">
                            <input id="Deliverypy" type="checkbox" value="df" name="tplType[]" checked style="display: none">
                        </p>
                    </div>
                    <div class="trans-submit">
                        <input type="submit" id="submit_tpl" class="submit btn_wuliu" value="保存" /> <input type="submit" onclick="javascript:location.href='${base}/manager/shopTransport/toList'" class="submit btn_wuliu" value="取消" />
            </div>
            </form>


            <div class="ks-ext-mask" style="position: absolute; left: 0px; top: 0px; width: 100%; height: 5000px; z-index: 9998; display: none"></div>
        </div>
        <div id="dialog_areas" class="ks-ext-position ks-overlay ks-dialog dialog-areas" style="left: 112px; top: 307.583px; z-index: 9999; display: none;width:600px;">
            <div class="ks-contentbox">
                <div class="ks-stdmod-header">
                    <div class="title">选择区域</div>
                </div>
                <div class="ks-stdmod-body">
                    <form method="post">
                        <ul id="J_CityList">
                            <style type="text/css">
                                em.zt {font-size: 0;line-height: 0;width: 0;height: 0;display: inline-block;padding: 0;border: 4px solid;border-color: #333 transparent transparent transparent;border-style: solid dashed dashed dashed;}
                            </style>
                            <li>
                                <div class=" dcity clearfix">
                                    <div class="province-list" style="width: 600px">
<c:forEach items="${sysAreaList }" var="aas" varStatus="s">
                                        <div class="ecity" style="width: 140px;margin-right:0px;">
													<span class="gareas"> <input type="checkbox" class="J_Province" id="J_Province_${aas.areaId}" value="${aas.areaId}" />
													<label for="J_Province_${aas.areaId}">${aas.areaName}</label>
													<span class="check_num" />
													</span><em class="zt trigger"></em>
                                            <div class="citys">
    <c:forEach items="${aas.children }" var="ac" varStatus="s">
                                                <span class="areas">
															<input type="checkbox" class="J_City" id="J_City_${ac.areaId}" value="${ac.areaId}" />
															<label for="J_City_${ac.areaId}">${ac.areaName}</label>
															</span>

                                            </c:forEach>
                                            <p style="text-align: right;">
                                                <input type="button" class="close_button" value="关闭" />
                                            </p>
                                        </div>
                                        </span>
                                    </div>
                                    </c:forEach>
                </div>
            </div>
            </li>
            </ul>
            <div class="btns">
                <button class="J_Submit" type="button" style="border:1px solid #ddd;background:#449CE7;width:80px;border-radius:4px;color:#fff">确定</button>
                <button class="J_Cancel" type="button" style="border:1px solid #ddd;background:#e6e6e6;width:80px;border-radius:4px;">取消</button>
            </div>
            </form>

            <script type="text/javascript" src="${base}/resource/transport/transport.js" charset="utf-8"></script>
        <script type="text/javascript">
        var BASE_PATH = '${base}';
        var transportId = "";
    </script>

                    <script>
                        $(function(){
                            $('div[class="postage-tpl"]').each(function(){
                                var tplType = $(this).find('input[name="tplType[]"]').attr('value');
                                var tag = 0;
                                <c:if test="${transport!=null && transport.shopTransportExtendList !=null}">
                                $("#title").val('${transport.title}');
                                transportId=${transport.id};
                                <c:forEach items="${transport.shopTransportExtendList }" var="tel" varStatus="s">
                                $('#Delivery'+tplType).attr('checked',true);
                                $('#Delivery'+tplType).click().attr('checked',true);
                                if(tag == 0){
                                    $(this).find('.tbl-except').append(RuleHead);
                                }
                                if ('${tel.areaId}' == ''){
                                    var cur_tr = $(this).find('.tbl-except').prev();
                                    $(cur_tr).find('input[data-field="start"]').attr("value","${tel.snum}");
                                    $(cur_tr).find('input[data-field="postage"]').val('${tel.sprice}');
                                    $(cur_tr).find('input[data-field="plus"]').val('${tel.xnum}');
                                    $(cur_tr).find('input[data-field="postageplus"]').val('${tel.xprice}');
                                    tag ++;
                                }else{
                                    StartNum +=1;
                                    cell = RuleCell.replace(/CurNum/g,StartNum);
                                    cell = cell.replace(/TRANSTYPE/g,'df');
                                    $(this).find('.tbl-except').find('table').append(cell);
                                    $(this).find('.J_ToggleBatch').css('display','').html('批量操作');
                                    var cur_tr = $(this).find('.tbl-except').find('table').find('tr:last');
                                    $(cur_tr).find('.area-group>p').html('${tel.areaName}');
                                    var area = '${tel.areaId}';
                                    area = area.substring(1,area.length-1);
                                    $(cur_tr).find('input[type="hidden"]').val(area + '|||' + '${tel.areaName}');
                                    $(cur_tr).find('input[data-field="start"]').val('${tel.snum}');
                                    $(cur_tr).find('input[data-field="postage"]').val('${tel.sprice}');
                                    $(cur_tr).find('input[data-field="plus"]').val('${tel.xnum}');
                                    $(cur_tr).find('input[data-field="postageplus"]').val('${tel.xprice}');
                                    tag ++;
                                }
                                </c:forEach>
                                </c:if>
                            });
                        });
                    </script>
</body>
</html>
