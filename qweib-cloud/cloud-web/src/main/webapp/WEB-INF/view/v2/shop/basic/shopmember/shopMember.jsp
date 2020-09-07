<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>修改会员</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .xxzf-more{
            background-color: aliceblue;
            overflow: hidden;
            padding-bottom: 5px;
            padding-top: 5px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator" onsubmit="return false;">
                <div class="form-group">
                    <%--type="hidden"--%>
                    <input uglcw-role="textbox" uglcw-model="id" value="${model.id}" type="hidden">
                    <label class="control-label col-xs-8">会员名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="name" uglcw-role="textbox" uglcw-validate="required"
                               value="${model.name}" autocomplete="none">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">手&nbsp;&nbsp;机&nbsp;&nbsp;号</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="mobile" uglcw-role="textbox"
                                value="${model.mobile}"  ${(model.memId !=null && ! empty model.mobile)?"disabled":""} autocomplete="none" maxlength="11">
                    </div>
                </div>
                <%--员工会员不需要关联客户--%>
                <%--<c:if test="${''==source || '1'==source || '3'==source }">--%>
                    <div class="form-group" id="div-customer">
                            <%--type="hidden"--%>
                        <input uglcw-role="textbox" uglcw-model="customerId" id="customerId"
                               value="${model.customerId}" type="hidden">
                        <label class="control-label col-xs-8" ${(empty model.customerId && !empty model.customerName )?"style='color: red'":''}>关联客户</label>
                        <div class="col-xs-16">
                            <input style="width: 200px;" id="customerName" uglcw-model="customerName"
                                   uglcw-options="click: searchCustomer,clearButton:false"
                                   uglcw-role="gridselector" value="${model.customerName}">
                            <a href="javascript:clearCustomer()">清除关联</a>
                        </div>
                    </div>
                    <div class="form-group <c:if test="${model.customerId ==null}">hide</c:if>"  id="khCloseDiv">
                        <label class="control-label col-xs-8">进销存价格关联</label>
                        <div class="col-xs-16">
                            <ul uglcw-role="radio" uglcw-model="khClose" id="khClose" uglcw-value="${model.khClose}"
                                uglcw-options='"layout":"horizontal","dataSource":[{"text":"开启","value":"0"},{"text":"关闭","value":"1"}]'></ul>
                            <div class="xxzf-more">
                                1.开启进销存价格关联,只执行进销存价格.<br/>
                                2.关闭进销存价格关联,进销存客户只执行商城设定的价格体系,不执行进销存价格体系.
                            </div>
                        </div>
                    </div>
                    <%--<div class="form-group">
                        <label class="control-label col-xs-8">关联客户</label>
                        <div class="col-xs-16">manager/shopMember/dialogShopMemberPage2
                            <ul uglcw-role="radio" uglcw-model="qxCustomer" id="qxCustomer" uglcw-value="<c:if test="${model.customerId !=null}">1</c:if><c:if test="${model.customerId ==null}">0</c:if>"
                                uglcw-options='"layout":"horizontal","dataSource":[{"text":"是","value":"1"},{"text":"否","value":"0"}]'></ul>
                        </div>
                    </div>--%>
                <%--</c:if>--%>
                <div class="form-group" id="spMemGradeIdDiv">
                    <label class="control-label col-xs-8">会员等级</label>
                    <div class="col-xs-16"><%--${source==3?'':' and is_jxc is null'}--%>
                        <div style="width: 200px;">
                          <tag:select2 name="spMemGradeId" id="spMemGradeId" tableName="shop_member_grade"
                                     whereBlock="status=1" headerKey="" headerValue="--会员等级--" displayKey="id"
                                     attrJson='[{"isJxc":"is_jxc"}]'
                                     displayValue="grade_name" value="${model.spMemGradeId}"/>
                        </div>
                    </div>
                </div>
                <div class="form-group <c:if test="${'3'!=model.source }">hide</c:if>" id="isXxzfDiv">
                    <label class="control-label col-xs-8">线下支付</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="isXxzf" id="isXxzf" uglcw-value="${model.isXxzf}"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"不显示","value":"0"},{"text":"显示","value":"1"}]'>
                        </ul>
                        <div class="xxzf-more">
                            仅进销存会员可以单独设置，常规会员统一由等级控显示隐藏线下支付<br/>
                            (备注:会员下单选择支付方式是否显示“线下支付”,顺序:1.用户自己设置->2.等级设置->3.进销存会员默认关闭)</div>
                    </div>
                </div>
               <%-- <c:if test="${'3'==source}">
                    <div class="form-group">
                        <label class="control-label col-xs-8">进销存客户</label>
                        <div class="col-xs-16">
                            <ul uglcw-role="radio" uglcw-model="khClose" id="khClose" uglcw-value="${model.khClose}"
                                uglcw-options='"layout":"horizontal","dataSource":[{"text":"不关闭","value":"0"},{"text":"关闭","value":"1"}]'></ul>
                            <span class="xxzf-more">(说明:关闭之后只会享受'常规会员'的价格)</span>
                        </div>
                    </div>
                </c:if>--%>
                <div class="form-group">
                    <label class="control-label col-xs-8">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="remark" uglcw-role="textbox"
                               value="${model.remark}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-xs-8"></label>
                    <div class="col-xs-16">
                        <button onclick="javascript:toSumbit();" class="k-button k-info">${empty model.id?'保存':'修改'}</button>
                    </div>
                </div>

            </form>
        </div>
    </div>
</div>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.ui.loaded();

        changeCustomerName();
        //changeKhClose(1);

        //关联客户-单选框change事件
        $('#customerId').change(function(){
            changeCustomerName();
            uglcw.ui.get('#spMemGradeId').value('');
            //changeKhClose();
        });

        $('#khClose').change(function () {
            changeKhClose()
        });
    })

    function clearCustomer() {
        uglcw.ui.get('#customerName').value('');
        uglcw.ui.get('#customerId').value('');
    }

    //-----------------------------------------------------------------------------------------

    //选择客户
    function searchCustomer() {
        var customerName=uglcw.ui.get('#customerName').value();
        if(uglcw.ui.get('#customerId').value())customerName=''
        if(customerName)customerName=customerName.split('，')[0];
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/customerPage?khTp=2&isDb=2',
            // query: function (params) {
            //     params.extra = new Date().getTime();
            // },
            closable:true,
            btns:[],
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入客户名称" uglcw-role="textbox" uglcw-model="khNm" value="'+customerName+'">',
            columns: [
                {field: 'id', title: '客户id', width: 50, hidden: true},
                {field: 'khCode', title: '编码', width: 160},
                {field: 'khNm', title: '客户名称', width: 160},
                {field: 'linkman', title: '联系人', width: 160, tooltip: true},
            ],
            success:function(c){
                $('<span style="color:red;">（双击选择）</span>').appendTo($(c).find('.criteria'))
            },
            yes: function (data) {
                // 一行的数据
                if (data) {
                    var khNm;
                    var cid;
                    $(data).each(function (i, row) {
                        khNm = row.khNm;
                        cid = row.id;
                    })

                    uglcw.ui.get('#customerId').value(cid);
                    uglcw.ui.get('#customerName').value(khNm);
                }
            }
        })
    }

    function toSumbit() {
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        //如果未选择客户时,删除线上线下支付,删除等级,删除进销存价格关联
        if(!uglcw.ui.get('#customerId').value()){
            uglcw.ui.get('#isXxzf').value('')
            uglcw.ui.get('#khClose').value('');
            //uglcw.ui.get('#spMemGradeId').value('');

            //验证是否选择了进销存等级
            //用户选择等级的下标
            var spMemGradeId_index=$('#spMemGradeId_listbox li.k-state-selected').attr("data-offset-index");
            if(spMemGradeId_index&& parseInt(spMemGradeId_index)>0){
                var isJxc=$('#assist_spMemGradeId li:eq('+(spMemGradeId_index-1)+')').attr('isJxc');
                if(isJxc&&isJxc==1){
                    uglcw.ui.error("常规会员不可使用进销存等级");
                    return false;
                }
            }
        }else{//如果已选择客户时，关闭进销存价格关联时，删除会员等级
            if(uglcw.ui.get('#khClose').value()==0){
                uglcw.ui.get('#spMemGradeId').value('');
            }
            //验证是否选择了普通等级
            //用户选择等级的下标
            var spMemGradeId_index=$('#spMemGradeId_listbox li.k-state-selected').attr("data-offset-index");
            if(spMemGradeId_index&& parseInt(spMemGradeId_index)>0){
                var isJxc=$('#assist_spMemGradeId li:eq('+(spMemGradeId_index-1)+')').attr('isJxc');
                if(isJxc&&isJxc==0){
                    uglcw.ui.error("进销存会员不可使用普通等级");
                    return false;
                }
            }
        }
        var data = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/shopMember/update',
            type: 'post',
            data: data,
            async: false,
            success: function (resp) {
                uglcw.ui.loaded();
                if(resp.state) {
                    uglcw.ui.toast(resp.msg);

                    setTimeout(function () {
                        uglcw.io.emit('refreshShopMember-${source}', "${source}");//发布事件
                        uglcw.ui.closeCurrentTab();
                    },1000)
                }else {
                    uglcw.ui.error(resp.msg);
                }
                /*if (resp === '1') {
                    //uglcw.io.emit('refreshShopMember-${source}', "${source}");//发布事件
                    uglcw.ui.toast('修改成功');
                    // top.closeCurrentTab();//关闭当前页
                    uglcw.ui.closeCurrentTab();//关闭当前页
                } else {
                    uglcw.ui.error('修改失败');
                }*/
            }
        })
    }


    /**
     * 选择关联客户改变时修改等级可选状态
     */
    function changeCustomerName() {
        $('#spMemGradeIdDiv').removeClass('hide');//显示等级
        var customerId=uglcw.ui.get('#customerId').value();
        //如果未选择客户时
        if(!customerId){
            uglcw.ui.get('#customerId').value('');//删除客户ID
            $('#khCloseDiv').addClass('hide');//隐藏进销存价格关联
            $('#isXxzfDiv').addClass('hide');//线下支付
            //禁用进销存等级
            $('#assist_spMemGradeId li').each(function(){
                var index = $(this).index();
                var jxc =$(this).attr('isjxc');
                    if(jxc == '1'){
                        $('#spMemGradeId_listbox li:eq('+(index+1)+')').addClass('k-state-disabled')
                    }else{
                        $('#spMemGradeId_listbox li:eq('+(index+1)+')').removeClass('k-state-disabled')
                    }
                }
            )
        }else{
            $('#khCloseDiv').removeClass('hide');//显示进销存价格关联
            $('#isXxzfDiv').removeClass('hide');//显示线下支付
            var value=uglcw.ui.get('#khClose').value();
            if(!value){
                value=0;
                uglcw.ui.get('#khClose').value(value)
            }
            if(value==0){
                $('#spMemGradeIdDiv').addClass('hide');//隐藏会员等级
            }
            //启用进销存等级
            $('#assist_spMemGradeId li').each(function(){
                var index = $(this).index();
                var jxc =$(this).attr('isjxc');
                    if(jxc == '1'){
                        $('#spMemGradeId_listbox li:eq('+(index+1)+')').removeClass('k-state-disabled')
                    }else{
                        $('#spMemGradeId_listbox li:eq('+(index+1)+')').addClass('k-state-disabled')
                    }
                }
            )
        }
    }

    //进销存价格关联开启关闭时
    function changeKhClose(load) {
        var value=uglcw.ui.get('#khClose').value();
        //开启
        if(value==0){
            $('#spMemGradeIdDiv').addClass('hide');//隐藏会员等级
            if(!load)
                uglcw.ui.get('#isXxzf').value(1);//默认不显示线下支付
        }else{
            $('#spMemGradeIdDiv').removeClass('hide');//显示等级
            if(!load)
                uglcw.ui.get('#isXxzf').value(0);//默认显示线下支付
        }
    }
</script>
</body>
</html>
