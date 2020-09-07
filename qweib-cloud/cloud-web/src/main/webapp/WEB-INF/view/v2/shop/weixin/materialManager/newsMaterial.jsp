<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>素材管理</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta name="referrer" content="never">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="/manager/WeixinConfig/newsPage" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=5 pageList="[5,10,20,30,40,50]" nowrap="false" toolbar="#tb">
			<thead>
				<tr>
					<th field="id" width="50" align="center" hidden="true">
						素材id
					</th>
					<th field="title" width="200" align="center">
						标题
					</th>
					<th field="author" width="60" align="center">
						作者
					</th>
					<th field="uploadTime" width="150" align="center">
						更新日期
					</th>
					<th field="delete" width="80" align="center" formatter="deleteFormatter">
						删除
					</th>
					<%--<th field="thumbId" width="300" align="center" formatter="imgFormatter">
						封面
					</th>
					<th field="newsDetail" width="80" align="center" formatter="urlFormatter">
						编辑
					</th>

					<th field="mediaId" width="120" align="center" formatter="media_idFormatter">
						微信公众平台图文
					</th>
					<th field="upload" width="130" align="center" formatter="uploadFormatter">
						上传到微信公众平台
					</th>

					<th field="remark" width="100" align="center">
						备注
					</th>--%>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			图文消息&nbsp(共<label id="num">${newsCount}</label>条)
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:editNewsMaterial();">新建图文素材</a>
			<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:parent.toNewsManager();">刷新</a>
		</div>
		<script type="text/javascript">	

		function imgFormatter(val,row,index){
			if(val!=""){
				var thumb_photo= row.content.news_item[0].thumb_url;
				return "<input  type=\"image\" src=\""+""+thumb_photo+"\" height=\"180\" width=\"280\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";  
			}
		}

		function urlFormatter(val,row,index){
			var url= row.content.news_item[0].url;
			return "<input style='width:60px;height:27px' type='button' value='浏览' onclick='showNews("+index+","+"\""+url+"\""+")' />";
        }
		function showNews(index,url){
		     window.open(url,'浏览图文消息');
		     $("#datagrid").datagrid('refreshRow',index);		     
		}
		function deleteFormatter(val,row,index){
			var id= row.id;
		    return "<input style='width:60px;height:27px' type='button' value='删除' onclick='deleteNews("+index+","+"\""+id+"\""+")' />";
		} 	

        //删除
        function deleteNews(index,id){
            $("#datagrid").datagrid('refreshRow',index);
            $.messager.confirm('提示框', '你确定要删除吗?',function(data){
                if(data){
                    var deleteNews_url="/manager/WeixinConfig/deleteNews?id="+id;
                    var msg=$.ajax({url:deleteNews_url,async:false});
                    var data=msg.responseText;
                    if(data=="1"){
                        alert("删除成功!");
                        window.location.href="javascript:parent.toNewsManager();"
                    }else{
                        alert("删除失败!");
                    }
                }else{
                    alert("取消删除！");
                }
            })
        }
        
        //打开图文编辑页面
        function editNewsMaterial(){
            var url="/manager/WeixinConfig/toNewsDetailPage";
            window.location.href=url;
        }
		</script>
	</body>
</html>
