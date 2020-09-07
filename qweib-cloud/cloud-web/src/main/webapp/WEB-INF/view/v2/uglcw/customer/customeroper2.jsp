<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>添加客户-修改客户</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .tyWidth {
            width: 200px
        }

        /*lable左对齐*/
        .form-horizontal .control-label {
            text-align: left;
        }

        /*去掉阴影*/
        .layui-card {
            box-shadow: 0 0 0 0 rgba(0, 0, 0, 0);
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card" id="layout">
                <div class="layui-card-header">
                    <button id="save" uglcw-role="button" class="k-info" onclick="javascript:toSumbit();">保存</button>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <div uglcw-role="tabs">
                            <ul>
                                <li>一、客户基本信息</li>
                                <li>二、客户合作信息</li>
                                <li>三、合作要素操作</li>
                                <c:if test="${not empty customer.id}">
                                    <li>四、销售政策设定</li>
                                </c:if>
                                <li>客户附件</li>
                            </ul>
                            <%--======================客户信息:start===========================--%>
                            <div>
                                <div class="layui-col-md12">
                                    <div class="layui-card">
                                        <div class="layui-card-body">
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="id" id="id"
                                                   value="${customer.id}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="khTp" id="khTp"
                                                   value="2"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="khPid" id="khPid"
                                                   value="${customer.khPid}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="shMid" id="shMid"
                                                   value="${customer.shMid}"/>

                                            <input type="hidden" uglcw-role="textbox" uglcw-model="longitude" id="longitude"
                                                   value="${customer.longitude}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="latitude" id="latitude"
                                                   value="${customer.latitude}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="memId" id="memId"
                                                   value="${customer.memId}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="branchId" id="branchId"
                                                   value="${customer.branchId}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="wlId" id="wlId"
                                                   value="${customer.wlId}"/>

                                            <input type="hidden" uglcw-role="textbox" uglcw-model="jxsflNm" id="jxsflNm"
                                                   value="${customer.jxsflNm}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="jxsjbNm" id="jxsjbNm"
                                                   value="${customer.jxsjbNm}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="jxsztNm" id="jxsztNm"
                                                   value="${customer.jxsztNm}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="fman" id="fman"
                                                   value="${customer.fman}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="ftel" id="ftel"
                                                   value="${customer.ftel}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="fgqy" id="fgqy"
                                                   value="${customer.fgqy}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="nxse" id="nxse"
                                                   value="${customer.nxse}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="ckmj" id="ckmj"
                                                   value="${customer.ckmj}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="dlqtpl" id="dlqtpl"
                                                   value="${customer.dlqtpl}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="dlqtpp" id="dlqtpp"
                                                   value="${customer.dlqtpp}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="rzMobile"
                                                   value="${customer.rzMobile}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="rzState"
                                                   value="${customer.rzState}"/>
                                            <input type="hidden" uglcw-role="textbox" uglcw-model="page" id="pageNo"
                                                   value="${page}"/>
                                            <input type="hidden" value="设置价格" class="c_button"
                                                   onclick="setTranPrice();"/>
                                            <input type="hidden" value="设置单位提成费用" class="c_button"
                                                   onclick="setTcPrice();"/>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">1.客户编码</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="khCode" id="khCode"
                                                           uglcw-role="textbox" value="${customer.khCode}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">2.客户名称</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="khNm" id="khNm"
                                                           uglcw-role="textbox" uglcw-validate="required"
                                                           value="${customer.khNm}" placeholder="(必填)">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">3.客户助记码</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="py" id="py"
                                                           uglcw-role="textbox" value="${customer.py}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">4.客户类型</label>
                                                <div class="col-xs-17">
                                                    <tag:select2 name="qdtypeId,qdtpNm" id="qdtypeId"
                                                                 tableName="sys_qdtype"
                                                                 headerKey="" value="${customer.qdtypeId}"
                                                                 headerValue="--选择客户类型--" displayKey="id"
                                                                 displayValue="qdtp_nm" width="200px"
                                                                 onchange="arealist3();"/>
                                                    <label style="width: 50px;">客户等级</label>
                                                    <select style="width: 200px;" uglcw-model="khlevelId,khdjNm" id="khlevelId"
                                                            uglcw-role="combobox"
                                                            uglcw-options="
                                                            placeholder:'请选择',
                                                            value: '${customer.khlevelId}',
                                                            url:'${base}manager/queryarealist2',
                                                            loadFilter: {
                                                                data:function(response){
                                                                return response.list2 || [];
                                                                }
                                                            },
                                                            data: function(){
                                                                return {
                                                                    qdtypeId: '${customer.qdtypeId}'
                                                                }
                                                            },
                                                            dataTextField:'khdjNm',dataValueField:'id'"
                                                            class="tyWidth">
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">5.加盟连锁店</label>
                                                <div class="col-xs-16">
                                                    <tag:select2 width="200px" id="shopId" name="shopId" headerKey=""
                                                                 headerValue=""
                                                                 value="${customer.shopId}" displayKey="id"
                                                                 displayValue="store_name"
                                                                 tableName="sys_chain_store">
                                                    </tag:select2>
                                                </div>
                                            </div>
                                            <%--  <div class="form-group">
                                                  <label class="control-label col-xs-3">5.客户等级</label>
                                                  <div class="col-xs-16">
                                                      <select uglcw-model="khdjNm" id="khdjNm" uglcw-role="combobox"
                                                              uglcw-options="
                                                              placeholder:'请选择',
                                                              value: '${customer.khdjNm}',
                                                              url:'${base}manager/queryarealist2',
                                                              loadFilter: {
                                                                  data:function(response){
                                                                  return response.list2 || [];
                                                                  }
                                                              },
                                                              data: function(){
                                                                  return {
                                                                      qdtpNm: '${customer.qdtpNm}'
                                                                  }
                                                              },
                                                              dataTextField:'khdjNm',dataValueField:'khdjNm'"
                                                              class="tyWidth">
                                                      </select>
                                                  </div>
                                              </div>--%>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">6.客户负责人</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="linkman" id="linkman"
                                                           uglcw-role="textbox" value="${customer.linkman}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">7.客户联系方式</label>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="mobile" id="mobile"
                                                           uglcw-role="textbox" value="${customer.mobile}"
                                                           placeholder="客户负责人手机">
                                                </div>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="tel" id="tel"
                                                           uglcw-role="textbox" value="${customer.tel}"
                                                           placeholder="客户负责人固定电话">
                                                </div>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="qq" id="qq"
                                                           uglcw-role="textbox" value="${customer.qq}"
                                                           placeholder="客户QQ号">
                                                </div>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="wxCode" id="wxCode"
                                                           uglcw-role="textbox" value="${customer.wxCode}"
                                                           placeholder="客户微信号">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">8.客户地址</label>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="lawAddress" id="lawAddress"
                                                           uglcw-role="textbox" value="${customer.lawAddress}"
                                                           placeholder="客户法定地址">
                                                </div>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="oftenAddress"
                                                           id="oftenAddress" uglcw-role="textbox"
                                                           value="${customer.oftenAddress}" placeholder="客户常用地址">
                                                </div>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="address" id="address"
                                                           uglcw-role="textbox" value="${customer.address}"
                                                           placeholder="客户送货地址">
                                                    <input type="button" value="标注" onclick="javascript:showMap();"
                                                           uglcw-role="button"/>
                                                </div>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="sendAddress2"
                                                           id="sendAddress2" uglcw-role="textbox"
                                                           value="${customer.sendAddress2}" placeholder="客户送地址2">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">9.社会信用统一代码</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="uscCode" id="uscCode"
                                                           uglcw-role="textbox" value="${customer.uscCode}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">10.客户所属行业</label>
                                                <div class="col-xs-16">
                                                    <input uglcw-role="textbox" uglcw-model="industryId" id="industryId"
                                                           value="${customer.industryId}" type="hidden">
                                                    <input style="width: 200px;" uglcw-model="industryNm" id="industryNm"
                                                           uglcw-role="textbox" value="${customer.industryNm}">
                                                    (工商行业所属设定 平台的行业基础数据)
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">11.客户位置</label>
                                                <div class="col-xs-16">
                                                    经度：<span id="longitudeSpan">${customer.longitude}</span>&nbsp;&nbsp;&nbsp;&nbsp;纬度:<span
                                                        id="latitudeSpan">${customer.latitude}</span>
                                                    <a href="javascript:;" onclick="showMap()"
                                                       style="color: blue">点击获取</a>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3" for="isYx">12.是否有效</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="isYx" id="isYx"
                                                           uglcw-role="checkbox" type="checkbox"
                                                           uglcw-value="${empty customer.isYx? 1 : customer.isYx}"
                                                           uglcw-options="type:'number'">
                                                    <label for="isYx"></label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">13.开户日期</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="openDate" id="openDate"
                                                           uglcw-role="datepicker" value="${customer.openDate}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">14.闭户日期</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="closeDate" id="closeDate"
                                                           uglcw-role="datepicker" value="${customer.closeDate}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3" for="isOpen">15.是否开户</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="isOpen" id="isOpen"
                                                           uglcw-role="checkbox" type="checkbox"
                                                           uglcw-value="${empty customer.isOpen? 1 : customer.isOpen}"
                                                           uglcw-options="type:'number'">
                                                    <label for="isOpen"></label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">16.省</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="province" id="province"
                                                           uglcw-role="textbox" value="${customer.province}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">17.城市</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="city" id="city"
                                                           uglcw-role="textbox" value="${customer.city}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">18.区县</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="area" id="area"
                                                           uglcw-role="textbox" value="${customer.area}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">19.销售打印模板</label>
                                                <div class="col-xs-16">
                                                    <tag:select2 width="120px" name="printTemplateId" id="printTemplateId" value="${customer.printTemplateId}"
                                                                 onchange="changeTemplate(this)" tableName="stk_print_template"
                                                                 displayKey="id" displayValue="fd_name" whereBlock="fd_type='1'">
                                                    </tag:select2>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">20.备注</label>
                                                <div class="col-xs-16">
                                                    <textarea style="width: 300px;" uglcw-model="remo" id="remo"
                                                              uglcw-role="textbox">${customer.remo}</textarea>
                                                </div>
                                            </div>


                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--======================客户信息:end===========================--%>


                            <%--======================二.客户合作信息:start===========================--%>
                            <div>
                                <div class="layui-col-md12">
                                    <div class="layui-card">
                                        <div class="layui-card-body">
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">1.客户状态</label>
                                                <div class="col-xs-16">
                                                    <select uglcw-model="isDb" id="isDb"
                                                            placeholder="客户状态"
                                                            uglcw-options="value: '${customer.isDb}'"
                                                            uglcw-role="combobox" class="tyWidth">
                                                        <option value="2" selected="selected">正常</option>
                                                        <option value="1">倒闭</option>
                                                        <option value="3">可恢复</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">2.客户合作方式</label>
                                                <div class="col-xs-16">
                                                    <select uglcw-model="hzfsNm" id="hzfsNm" class="tyWidth"
                                                            uglcw-role="combobox">
                                                        <option value="">请选择</option>
                                                        <c:forEach items="${hzfsls}" var="hzfsls">
                                                            <option value="${hzfsls.hzfsNm}"
                                                                    <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">3.市场类型</label>
                                                <div class="col-xs-16">
                                                    <select uglcw-model="sctpNm" id="sctpNm" class="tyWidth"
                                                            uglcw-role="combobox">
                                                        <option value="">请选择</option>
                                                        <c:forEach items="${sctypels}" var="sctypels">
                                                            <option value="${sctypels.sctpNm}"
                                                                    <c:if test="${sctypels.sctpNm==customer.sctpNm}">selected</c:if>>${sctypels.sctpNm}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">4.销售阶段</label>
                                                <div class="col-xs-16">
                                                    <select uglcw-model="xsjdNm" id="xsjdNm" class="tyWidth"
                                                            uglcw-role="combobox">
                                                        <option value="">请选择</option>
                                                        <c:forEach items="${xsphasels}" var="xsphasels">
                                                            <option value="${xsphasels.phaseNm}"
                                                                    <c:if test="${xsphasels.phaseNm==customer.xsjdNm}">selected</c:if>>${xsphasels.phaseNm}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">5.供货类型</label>
                                                <div class="col-xs-16">
                                                    <select uglcw-model="ghtpNm" id="ghtpNm" class="tyWidth"
                                                            uglcw-role="combobox">
                                                        <option value="">请选择</option>
                                                        <c:forEach items="${ghtypels}" var="ghtypels">
                                                            <option value="${ghtypels.ghtpNm}"
                                                                    <c:if test="${ghtypels.ghtpNm==customer.ghtpNm}">selected</c:if>>${ghtypels.ghtpNm}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">6.供货经销商</label>
                                                <div class="col-xs-16">
                                                    <input id="pkhNm" uglcw-role="gridselector" uglcw-model="pkhNm"
                                                           value="${customer.pkhNm}" class="tyWidth"
                                                           style="width: 200px;"
                                                           uglcw-options="click: showSelectJxc" readonly/>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">7.客户归属片区</label>
                                                <div class="col-xs-16">
                                                    <select id="regioncomb" uglcw-role="dropdowntree"
                                                            uglcw-model="regionId,regionNm" style="width: 200px;"
                                                            uglcw-options="
                                                                value:'${customer.regionId}',
                                                                url: '${base}manager/sysRegions',
                                                                select:function(e){
                                                                var node = this.dataItem($(e.node));
                                                                uglcw.ui.get('#regionId').value(node.id);
                                                               }">
                                                    </select>
                                                    <input type="hidden" uglcw-model="regionId" uglcw-role="textbox"
                                                           id="regionId" value="${customer.regionId}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">8.客户负责业务员</label>
                                                <div class="col-xs-16">
                                                    <input id="memberNm" uglcw-role="gridselector" uglcw-model="memberNm"
                                                           value="${customer.memberNm}" class="tyWidth"
                                                           style="width: 200px;"
                                                           uglcw-options="click: showSelectMember" readonly
                                                           uglcw-validate="required" placeholder="(必填)"/>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">9.客户原始开发的业务员</label>
                                                <div class="col-xs-16">
                                                    <input uglcw-model="orgEmpId" id="orgEmpId" uglcw-role="textbox"
                                                           value="${customer.orgEmpId}" type="hidden">
                                                    <input style="width: 200px;" uglcw-model="orgEmpNm" id="orgEmpNm"
                                                           uglcw-role="textbox" value="${customer.orgEmpNm}" readonly>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">10.客户创建日期</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="createTime" id="createTime"
                                                           uglcw-role="datetimepicker" value="${customer.createTime}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">11.客户销售区域</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="jyfw" id="jyfw"
                                                           uglcw-role="textbox" value="${customer.jyfw}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">12.客户归属公司部门</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="branchName" id="branchName"
                                                           uglcw-role="textbox" value="${customer.branchName}" readonly>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--======================二.客户合作信息:end===========================--%>


                            <%--======================三.合作要素操作:start===========================--%>
                            <div>
                                <div class="layui-col-md12">
                                    <div class="layui-card">
                                        <div class="layui-card-body">
                                            <div class="form-group">
                                                <label class="control-label col-xs-3" for="isEp">1.是否二批</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="isEp" id="isEp"
                                                           uglcw-role="checkbox" type="checkbox"
                                                           uglcw-value="${empty customer.isEp?1:customer.isEp}"
                                                           uglcw-options="type:'number'">
                                                    <label for="isEp"></label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">2.所属二批</label>
                                                <div class="col-xs-16">
                                                    <input type="hidden" uglcw-model="epCustomerId" id="epCustomerId"
                                                           value="${customer.epCustomerId}" uglcw-role="textbox"/>
                                                    <input id="epCustomerName" uglcw-role="gridselector"
                                                           uglcw-model="epCustomerName" value="${customer.epCustomerName}"
                                                           class="tyWidth"
                                                           style="width: 200px;"
                                                           uglcw-options="click: show2pKh" readonly/>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">3.审核状态</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="shZt" id="shZt"
                                                           uglcw-role="textbox" value="${customer.shZt}" readonly>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">4.审核日期</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="shTime" id="shTime"
                                                           uglcw-role="textbox" value="${customer.shTime}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">5.审核人</label>
                                                <div class="col-xs-16">
                                                    <input style="width: 200px;" uglcw-model="shMemberNm" id="shMemberNm"
                                                           uglcw-role="textbox" value="${customer.shMemberNm}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-3">6.拜访频次</label>
                                                <div class="col-xs-16">
                                                    <select uglcw-model="bfpcNm" id="bfpcNm" class="tyWidth"
                                                            uglcw-role="combobox">
                                                        <option value="">请选择</option>
                                                        <c:forEach items="${bfpcls}" var="bfpcls">
                                                            <option value="${bfpcls.pcNm}"
                                                                    <c:if test="${bfpcls.pcNm==customer.bfpcNm}">selected</c:if>>${bfpcls.pcNm}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--======================三.合作要素操作:end===========================--%>

                            <%--======================四.销售政策设定:start===========================--%>
                            <c:if test="${not empty customer.id}">
                                <div>
                                    <div class="layui-col-md12">
                                        <div class="layui-card">
                                            <div class="layui-card-body">
                                                (一)
                                                <div class="form-group">
                                                    <label class="control-label col-xs-3" for="isEp">1.商品销售价</label>
                                                    <div class="col-xs-16">
                                                        <a style="color:blue;" href="javascript:;"
                                                           onclick="setWarePrice()">查看</a>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="control-label col-xs-3">2.营销费用设置</label>
                                                    <div class="col-xs-16">
                                                        <a style="color:blue;" href="javascript:;"
                                                           onclick="setAutoPrice()">查看</a>（1.按量计价：单价或百分比 也可以考虑时间区间
                                                        2.按营业额 3.固定费用投入 按固定时间设定投入）

                                                    </div>
                                                </div>
                                                (二)自营商城模块
                                                <div class="form-group">
                                                    <label class="control-label col-xs-3">1.自营商城商品销售价</label>
                                                    <div class="col-xs-16">
                                                        ___________________
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="control-label col-xs-3">2.自营商城营销费用设定</label>
                                                    <div class="col-xs-16">
                                                        ___________________
                                                    </div>
                                                </div>
                                                (三)平台商城模块
                                                <div class="form-group">
                                                    <label class="control-label col-xs-3">1.平台商城商品销售价</label>
                                                    <div class="col-xs-16">
                                                        ___________________
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="control-label col-xs-3">2.平台商城营销费用设定</label>
                                                    <div class="col-xs-16">
                                                        ___________________
                                                    </div>
                                                </div>
                                                (四)门店模块
                                                <div class="form-group">
                                                    <label class="control-label col-xs-3">1.门店商品销售价</label>
                                                    <div class="col-xs-16">
                                                        ___________________
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="control-label col-xs-3">2.门店营销费用设定</label>
                                                    <div class="col-xs-16">
                                                        ___________________
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            <%--======================四.销售政策设定:end===========================--%>

                            <%--======================客户附件:end===========================--%>
                            <div class="layui-col-md12">
                                <div class="layui-card">
                                    <div class="layui-card-body">
                                        <div class="form-group">
                                            <%--<label class="control-label col-xs-1" for="isEp"></label>--%>
                                            <div class="col-xs-16">
                                                <div id="album" uglcw-options="cropper: false" uglcw-role="album"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--======================客户附件:end===========================--%>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/map.jsp" %>
<script>
    var mapModel;

    //显示地图
    function showMap() {
        var city = uglcw.ui.get("#city").value();
        var oldLng = uglcw.ui.get("#longitude").value();
        var oldLat = uglcw.ui.get("#latitude").value();
        var address = uglcw.ui.get("#address").value();

        g_showMap({oldLng: oldLng, oldLat: oldLat, searchCondition: address, city: city}, function (data) {
            console.log(data);
            uglcw.ui.get("#longitude").value(data.lng);
            uglcw.ui.get("#latitude").value(data.lat);

            $('#longitudeSpan').text(data.lng);
            $('#latitudeSpan').text(data.lat);

            uglcw.ui.get("#province").value(data.province);
            uglcw.ui.get("#city").value(data.city);
            uglcw.ui.get("#area").value(data.district);
            uglcw.ui.success('获取成功');
        });
    }


    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.ui.loaded();

        //客户负责业务员 ：没有选择业务员默认创建人为业务员   用id查找员工信息 新增就用ajax去获取 再绑定
        <c:if test="${customer.id == null or customer.id < 1}">
        var memberId = ${principal.idKey};
        uglcw.ui.get('#createTime').value(new Date())  //新增的时候时间默认给当前时间
        $.ajax({
            url: '${base}manager/getMemberInfo',
            type: 'post',
            data: {memberId: memberId},
            success: function (response) {
                //设置branchId, memberId,
                uglcw.ui.get('#memId').value(response.member.memberId);
                uglcw.ui.get('#branchId').value(response.member.branchId);
                uglcw.ui.get('#memberNm').value(response.member.memberNm);
            }
        })
        </c:if>
        initPic();

    })

    //-----------------------------------------------------------------------------------------

    function toSumbit() {
        var khNm = uglcw.ui.get("#khNm").value();
        var memberNm = uglcw.ui.get("#memberNm").value();
        var mobile = uglcw.ui.get("#mobile").value();
        if (!khNm) {
            uglcw.ui.toast("客户名称不能为空");
            return;
        }
        if (!memberNm) {
            uglcw.ui.toast("业务员不能为空");
            return;
        }
        /*  if (!mobile) {
              uglcw.ui.toast("手机不能为空");
              return;
          }*/
        var openDate = uglcw.ui.get("#openDate").value();
        var closeDate = uglcw.ui.get("#closeDate").value();
        if (openDate != null && closeDate != null) {
            var open = new Date(openDate).getTime();
            var close = new Date(closeDate).getTime();
            if (open > close) {
                uglcw.ui.toast("开户日期大于闭户日期");
                return;
            }
        }

        var valid = uglcw.ui.get('.form-horizontal').validate();
        if (!valid) {
            return false;
        }
        var data = uglcw.ui.bindFormData('.form-horizontal');
        //附件
        var album = uglcw.ui.get('#album');
        data.append('delPicIds', album.getDeleted().join(','));
        $(album.value()).each(function (idx, item) {
            if (item.file) {
                data.append('file2' + item.fid, item.file, item.title);
            }
        });
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/opercustomer',
            type: 'post',
            data: data,
            async: false,
            processData: false,
            contentType: false,
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp == "1") {
                    uglcw.ui.success("添加成功");
                    uglcw.io.emit('refreshCustomer', "success");//发布事件
                    uglcw.ui.closeCurrentTab();//关闭当前页
                } else if (resp == "2") {
                    uglcw.ui.success("修改成功");
                    uglcw.io.emit('refreshCustomer', "success");//发布事件
                    uglcw.ui.closeCurrentTab();//关闭当前页
                } else if (resp == "-2") {
                    uglcw.ui.success("该客户编码已存在");
                    return;
                } else if (resp == "-3") {
                    uglcw.ui.success("该客户名称已存在");
                    return;
                } else if (resp == "-1") {
                    uglcw.ui.error("开户日期大于闭户日期");
                } else {
                    uglcw.ui.error("操作失败");
                }
            }
        })
    }

    //选择业务员
    function showSelectMember() {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/memberPage',
            // query: function (params) {
            //     params.extra = new Date().getTime();
            // },
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入姓名" uglcw-role="textbox" uglcw-model="memberNm">',
            columns: [
                {field: 'memberNm', title: '姓名', width: 100},
                {field: 'memberMobile', title: '手机号码', width: 150},
                {field: 'branchName', title: '部门', width: 150},
            ],
            yes: function (nodes) {
                var node = nodes[0];
                uglcw.ui.get('#memId').value(node.memberId);
                uglcw.ui.get('#memberNm').value(node.memberNm);
                uglcw.ui.get('#branchId').value(node.branchId);
                uglcw.ui.get('#branchName').value(node.branchName);
            }
        })
    }

    //选择供货经销商
    function showSelectJxc() {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/customerPage?khTp=1',
            // query: function (params) {
            //     params.extra = new Date().getTime();
            // },
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入客户名称" uglcw-role="textbox" uglcw-model="khNm">',
            columns: [
                {field: 'khCode', title: '编码', width: 50},
                {field: 'khNm', title: '名称', width: 160},
                {field: 'linkman', title: '联系人', width: 160},
            ],
            yes: function (nodes) {
                uglcw.ui.get('#pkhNm').value(nodes[0].khNm);
                uglcw.ui.get('#khPid').value(nodes[0].id);
            }
        })
    }

    //选择二批客户
    function show2pKh() {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/customerPage?khTp=2&isEp=1',
            // query: function (params) {
            //     params.extra = new Date().getTime();
            // },
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入客户名称" uglcw-role="textbox" uglcw-model="khNm">',
            columns: [
                {field: 'khCode', title: '编码', width: 50},
                {field: 'khNm', title: '名称', width: 160},
                {field: 'linkman', title: '联系人', width: 160},
            ],
            yes: function (nodes) {
                var node = nodes[0];
                uglcw.ui.get('#epCustomerId').value(node.id);
                uglcw.ui.get('#epCustomerName').value(node.khNm);
            }
        })
    }


    //改变客户类型时;客户等级数据跟着变化
    function arealist3() {
        var qdtypeId = uglcw.ui.get('#qdtypeId').value();  // uglcw.ui.get('#qdtypeId').k().text();
        uglcw.ui.get('#khlevelId').value('');
        $.ajax({
            url: "manager/queryarealist2",
            type: "post",
            data: {
                qdtypeId: qdtypeId
            },
            success: function (data) {
                if (data) {
                    uglcw.ui.get('#khlevelId').k().setDataSource(new kendo.data.DataSource({data: data.list2}));
                    uglcw.ui.get('#khlevelId').k().select(-1);
                }
            }
        });
    }


    function setWarePrice() {
        uglcw.ui.openTab("${customer.khNm}-设置商品销售价", "${base}manager/customerwaretype?customerId=${customer.id}&op=1");
    }

    function setAutoPrice() {
        uglcw.ui.openTab("${customer.khNm}-设置营销费用", "${base}manager/autopricecustomerwaretype?customerId=${customer.id}");
    }

    function initPic() {

        var pics = $.map(${fns:toJson(customer.customerPicList)}, function (item) {
            return {
                id: item.id,
                thumb: '/upload/' +item.picMini,
                url: '/upload/' + item.pic,
                title: '/upload/' + item.pic,
            }
        });
        uglcw.ui.get('#album').value(pics);
    }


</script>
</body>
</html>
