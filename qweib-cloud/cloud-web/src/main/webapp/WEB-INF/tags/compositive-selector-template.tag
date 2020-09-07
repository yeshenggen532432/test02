<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@tag pageEncoding="UTF-8" %>
<%@attribute name="id" required="false" %>
<%@attribute name="index" required="false" description="选中的TAB的索引" %>
<%@attribute name="tabs" required="false" description="显示TAB集合: 0,1,2,3" %>
<c:set var="visibleTabs" value="${tabs eq null ? '0,1,2,3': tabs}"/>
<script type="text/x-qwb-template" id="customer-selector-no-result-tpl">
    <div style="margin-top: 20px;">
        <div>
            未找到客户:<span style="color: red;">#= data.khNm#</span>。是否立即添加 ？
        </div>
        <br/>
        <button class="k-button k-info" onclick="addNewCustomer2('#= data.khNm#')">
            <i class="k-icon k-i-plus"></i>立即添加#= data.khNm#
        </button>
    </div>
</script>
<script id="${empty id ?'consignee-selector': id}" type="text/x-qwb-template">
    <div class="${empty id ?'consignee-selector': id}" qwb-role="tabs" qwb-options="
                activate: function(e){
                    if($(e.contentElement).find('.qwb-grid').hasClass('k-grid')){
                        var grid = qwb.ui.get($(e.contentElement).find('.qwb-grid'));
                        if(grid && grid.k() && !grid._loaded){
                            grid.reload()
                            grid._loaded = true;
                        }
                   }
                },
                <c:if test="${index ne null}">
                index: ${fn:length(visibleTabs.split(',')) > index ? index : 0}
                </c:if>

            ">
        <ul>
            <c:if test="${fn:contains(visibleTabs, '0')}">
                <li qwb-field="proName" qwb-id="id" qwb-type="0">供应商</li>
            </c:if>
            <c:if test="${fn:contains(visibleTabs, '1')}">
                <li qwb-field="memberNm" qwb-id="memberId" qwb-type="1">部门</li>
            </c:if>
            <c:if test="${fn:contains(visibleTabs, '2')}">
                <li qwb-field="khNm" qwb-id="id" qwb-type="2">客户</li>
            </c:if>
            <c:if test="${fn:contains(visibleTabs, '3')}">
                <li qwb-field="proName" qwb-id="id" qwb-type="3">其他往来单位</li>
            </c:if>
        </ul>
        <c:if test="${fn:contains(visibleTabs, '0')}">
            <div>
                <div class="criteria criteria-provider" style="margin-bottom: 5px;">
                    <input class="query" style="width:200px;" placeholder="输入关键字" qwb-model="proName"
                           qwb-role="textbox">
                    <button class="k-info search" qwb-role="button"><i class="k-icon k-i-search"></i>搜索</button>
                </div>
                <div qwb-role="grid" id="grid-provider" qwb-options="
                url: '${base}manager/stkprovider',
				size:'small',
					autoBind:  ${(index ne null and index == 0)? true: false},
				criteria: '.criteria-provider',
				pageable: true,
				height: 300
			">
                    <div data-field="proName">供应商</div>
                    <div data-field="tel">联系电话</div>
                    <div data-field="address">地址</div>
                </div>
            </div>
        </c:if>
        <c:if test="${fn:contains(visibleTabs, '1')}">
            <div>
                <div style="display: inline-flex;">
                    <div class="col-xs-5">
                        <div style="height:290px;" qwb-role="tree"
                             qwb-options="
                            dataTextField: 'branchName',
                            dataValueField: 'branchId',
                            url:'${base}manager/department/tree?dataTp=1',
                            select: function(e){
                                var node = this.dataItem(e.node);
                                qwb.ui.bind('.criteria-member',{branchId: node.branchId});
                                qwb.ui.get('.grid-member').reload();
                            },
                            loadFilter:function(response){
                              return response.data || [];
                            }
                        "
                        ></div>
                    </div>
                    <div class="col-xs-19" style="padding: 0;">
                        <div class="criteria criteria-member" style="margin-bottom: 5px;">
                            <input qwb-role="textbox" qwb-model="branchId" type="hidden">
                            <input class="query" style="width:200px;" placeholder="输入关键字" qwb-model="memberNm"
                                   qwb-role="textbox">
                            <button class="k-info search" qwb-role="button"><i class="k-icon k-i-search"></i>搜索</button>
                        </div>
                        <div qwb-role="grid"
                             class="grid-member"
                             qwb-options="
                             	autoBind:  ${(index ne null and index == 1)? true: false},
                                url: '${base}manager/stkMemberPage',
                                height: 300,
                                criteria: '.criteria-member',
                                size:'small',
                                pageable: true
			                ">
                            <div data-field="memberNm">姓名</div>
                            <div data-field="memberMobile">电话</div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${fn:contains(visibleTabs, '2')}">
            <div>
                <div class="criteria criteria-customer" style="margin-bottom: 5px;">
                    <input class="query" style="width:200px;" placeholder="输入关键字" qwb-model="khNm" qwb-role="textbox">
                    <button class="k-info search" qwb-role="button"><i class="k-icon k-i-search"></i>搜索</button>
                </div>
                <div qwb-role="grid" id="_grid-customer2" qwb-options="
				size:'small',
				criteria: '.criteria-customer',
				autoBind:  ${(index ne null and index == 2)? true: false},
				pageable: {
                    refresh: true,
                    pageSizes: true,
                    buttonCount: 2
				},
				noRecords:{
				    template: function(){
				        return qwb.util.template($('#customer-selector-no-result-tpl').html())({data: qwb.ui.bind('.criteria-customer')});
				    }
				},
				url: '${base}manager/stkchoosecustomer',
				height: 300
			">
                    <div data-field="khNm" qwb-options="tooltip: true">客户名称</div>
                    <div data-field="mobile">客户电话</div>
                    <div data-field="memberNm">业务员</div>
                    <div data-field="memberMobile">业务员电话</div>
                    <div data-field="address" qwb-options="tooltip: true">地址</div>
                </div>
            </div>
        </c:if>
        <c:if test="${fn:contains(visibleTabs, '3')}">
            <div>
                <div class="criteria criteria-finunit" style="margin-bottom: 5px;">
                    <input class="query" style="width:200px;" placeholder="输入关键字" qwb-model="proName"
                           qwb-role="textbox">
                    <button class="k-info search" qwb-role="button"><i class="k-icon k-i-search"></i>搜索</button>
                </div>
                <div qwb-role="grid" qwb-options="
				size:'small',
			    autoBind:  ${(index ne null and index == 3)? true: false},
				criteria: '.criteria-finunit',
				url: '${base}manager/queryFinUnit',
				pageable: true,
				height: 300
			">
                    <div data-field="proName">往来单位</div>
                    <div data-field="mobile">联系电话</div>
                    <div data-field="address">地址</div>
                </div>
            </div>
        </c:if>
    </div>
</script>
<script>
    function addNewCustomer(customerName, callback) {
        var branchId;
        $.ajax({
            async: false,
            url: '${base}manager/getMemberInfo',
            type: 'post',
            data: {memberId: ${principal.idKey}},
            success: function (response) {
                branchId = response.member.branchId;
            }
        })
        $.ajax({
            url: '${base}manager/opercustomer',
            type: 'post',
            data: {
                khNm: customerName,
                memId: ${principal.idKey},
                branchId: branchId
            },
            success: function (response) {
                if (response === '1') {
                    qwb.ui.success('添加成功')
                    if ($.isFunction(callback)) {
                        callback();
                    }
                }else if(response ==='-2'){
                    qwb.ui.error('客户编号已存在');
                }else if(response === '-3'){
                    qwb.ui.error('客户名称已存在');
                }else {
                    qwb.ui.error('添加失败');
                }
            }
        })

    }
    function addNewCustomer2(customerName){
        addNewCustomer(customerName, function(){
            qwb.ui.get('#_grid-customer2').reload();
        })
    }
</script>

