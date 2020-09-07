<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<%--1左边：商品分类start--%>
		<div class="layui-col-md3">
			<div class="layui-card">
				<div class="layui-card-header">功能导航</div>
				<div class="layui-card-body">
					<div uglcw-role="tree" id="wareTypeTree"
						 uglcw-options="
							url: '${base}/manager/weiXinReply/toReplyLeftMenu',
							select: function(e){
								var node = this.dataItem(e.node);
								if(node.branchId == 1){
									toSubscribeReply();
								}
								if(node.branchId == 2){
									toReceiveReply();
								}
								if(node.branchId == 3){
									toKeywordReply();

								}
                       		}
                    	">
					</div>
				</div>
			</div>
		</div>
		<%--1左边：商品分类end--%>

		<%--2右边：表格start--%>
		<div class="layui-col-md9">
			<iframe name="mainiframe" id="mainiframe" src="" frameborder="0" marginheight="0" marginwidth="0"
					width="100%" height="100%"></iframe>
		</div>
		<%--2右边：表格end--%>
	</div>
</div>

<%--添加关键词--%>
<script type="text/x-uglcw-template" id="keywordAddDiv">
	<div class="layui-card">
		<div class="layui-card-body">
			<form class="form-horizontal" uglcw-role="validator">
				<div class="form-group">
					<label class="control-label col-xs-6">关键词</label>
					<div class="col-xs-16">
						<textarea uglcw-role="textbox" uglcw-model="keyword"  uglcw-validate="required" maxlength="30" uglcw-options="min: 1, max: 30"></textarea>
					</div>
				</div>
			</form>
		</div>
	</div>
</script>


<script id="edit" type="text/x-uglcw-template">
	<button onclick="javascript:editKeyword('#= data.keyword#');" class="k-button k-info">编辑</button>
</script>
<script id="delete" type="text/x-uglcw-template">
	<button onclick="javascript:deleteKeyword('#= data.keyword#');" class="k-button k-info">删除</button>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        resize();
        $(window).resize(resize);
        uglcw.ui.loaded();
        toSubscribeReply();
    })


    //---------------------------------------------------------------------------------------------------------------

    function operatePrice(field) {
        var display =$("."+field+"_input").css('display');
        if(display == 'none'){
            $("."+field+"_input").show();
            $("."+field+"_span").hide();
        }else{
            $("."+field+"_input").hide();
            $("."+field+"_span").show();
        }
    }

    function changePrice(o,field,wareId){
        $.ajax({
            url: "manager/shopWare/updateShopWarePrice2",
            type: "post",
            data: "id=" + wareId + "&price=" + o.value +"&field="+field,
            success: function (data) {
                if (data == '1') {
                    $("#"+field+"_span_"+wareId).text(o.value);
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }



    //打开编辑页面
    function editKeyword(keyword){
        var url="/manager/weiXinReply/toKeywordReplyDetail?keyword="+keyword;
        window.location.href=url;
    }

    //删除关键词
    function deleteKeyword(keyword){
        uglcw.ui.confirm('你确定要删除关键词 '+keyword+' 吗?',function(){
                var deleteKeyword_url="/manager/weiXinReply/deleteKeyword?keyword="+keyword;
                var msg=$.ajax({url:deleteKeyword_url,async:false});
                var json=$.parseJSON(msg.responseText);
                if(json.state){
                    uglcw.ui.success("删除成功!");
                    uglcw.ui.get('#grid').reload();
                }else{
                    uglcw.ui.error("删除失败!");
                }
        })
    }

    //添加关键词
    function addKeyword() {
        uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                if (row) {
                    uglcw.ui.bind($(container), row);
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/shopWareGroup/editGroup',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '2') {
                            uglcw.ui.success('修改成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '3') {
                            uglcw.ui.error('该分组名称已存在');
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }

    //打开自定义被关注回复页面
    function toSubscribeReply(){
        var url="/manager/weiXinReply/toSubscribeReply";
        mainiframe.location.href=url;
    }

    /*//自定义被关注回复
    function toSubscribeReply(){
        //打开自定义被关注回复页面
        var url="/manager/weiXinReply/toSubscribeReply";
        uglcw.ui.openTab('自定义被关注回复', url);
    }*/

    function toReceiveReply(){
        //打开自定义收到消息回复页面
        var url="/manager/weiXinReply/toReceiveReply";
        mainiframe.location.href=url;
    }

   /* //打开自定义收到消息回复页面
    function toReceiveReply(){
        var url="/manager/weiXinReply/toReceiveReply";
        uglcw.ui.openTab('自定义收到消息回复', url);
    }*/

    /*function toKeywordReply(){
        //打开自定义关键词分页页面
        var url="/manager/weiXinReply/toKeywordReply";
        mainiframe.location.href=url;
    }*/
    function toKeywordReply(){
        //打开自定义关键词分页页面
        var url="/manager/weiXinReply/toKeywordReply";
        mainiframe.location.href=url;
    }
    /*//打开自定义关键词分页页面
    function toKeywordReply(){
        var url="/manager/weiXinReply/toKeywordReply";
        uglcw.ui.openTab('自定义关键词回复', url);
    }*/


    var delay;
    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - 40;
            $("#mainiframe").height(height);
        }, 200)
    }

</script>
</body>
</html>
