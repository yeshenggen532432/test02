<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>照片墙图片</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
		<div class="box">
		<input name="wallId" id="wallId" type="hidden" value="${bPicList[0].wallId }"/>
			<c:forEach items="${bPicList }" var="wallPic" varStatus="s">
				<dl id="dl">
	      			<dt class="f14 b">图片${s.count }:</dt>
				<dd>
					<input name="picId${s.count }" id="picId${s.count }" value="${wallPic.picId}" type="hidden"/>
					
					<img id="pic${s.count }" alt="" style="width: 150px;height: 160px;" src="${base }/upload/${wallPic.pic }"/ >
					<a class="easyui-linkbutton" iconcls="icon-remove" href="javascript:void(0);" onclick="deleteRows('${s.count}');">删除</a>
				</dd>
			</c:forEach>
		</div>
		<script type="text/javascript">
		function deleteRows(num){
			var picId = $("#picId"+num).val();
			if(confirm("是否删除改图片?")){
						$.ajax({
							url:"manager/delPic",
							data:"id="+picId,
							type:"post",
							success:function(json){
								if(json){
								var wallId=$("#wallId").val();
									location.href="manager/toPicPage?wallId="+wallId;
									showMsg(json);
								}
							}
						});
					}
		}
		</script>
	</body>
</html>
