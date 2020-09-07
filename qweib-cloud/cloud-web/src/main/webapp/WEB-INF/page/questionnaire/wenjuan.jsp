<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>  
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"> 
<meta content="email=no,telephone=no" name="format-detection"/>
<title>问卷调查</title>
<%@include file="/WEB-INF/page/include/source.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<link href="resource/wj/css/basic.css" rel="stylesheet" type="text/css">
</head>
<script type="text/javascript">
	var count = '${size}';
	var dsck = '${quests.dsck}';
	var mycars=new Array();
	var flag = true;
	function check(id){
		if(typeof(count)=="undefined"){
			i=0;
		}else if('${size}'>0){
			flag = false;
			return;
		}	
		var l = $("#l"+id);
		var att=l.attr("class");
		var lis = $("li");
		if(dsck==1){		
			for(var j=0;j<lis.length;j++){
				$(lis[j]).removeAttr("class");
			}
			if(att!="cur"){
				l.attr("class","cur");
   				mycars.splice(0, mycars.length);
				mycars.push(id);
			}
		}else if(dsck==0){
			if(att!="cur"){
				l.attr("class","cur");
				mycars.push(id);
			}else{
				l.removeAttr("class");
				for (var i=0; i<mycars.length; i++){
			        if (mycars[i] === id){
			            mycars.splice(i, 1);
			        }
			    }
			}	
		}else{
			if(att!="cur"){
				if(dsck>count){
					l.attr("class","cur");
					mycars.push(id);
					count++;
				}else{
					alert("此题最多选择"+dsck+"个");
				}
			}else{
				l.removeAttr("class");
				for (var i=0; i<mycars.length; i++){
			        if (mycars[i] === id){
			            mycars.splice(i, 1);
			        }
			    }
				count--;
			}
		}
	}
	
	function add(){
		if(flag==false){
			window.location.href="<%=request.getContextPath()%>/web/pageQuestionnaire?token=${token}&pageNo=${pageNo+1}";
			return;
		}
		$.ajax({
			url:"web/addvote",
			data:"ids="+mycars+"&token="+'${token}'+"&problemId="+'${quests.qid }'+"&dsck="+dsck,
			type:"post",
			async:false,
			success:function(json){
				if(json=="1"){
				   window.location.href="<%=request.getContextPath()%>/web/pageQuestionnaire?token=${token}&pageNo=${pageNo+1}";
				}else{
				   alert("操作失败");
				}
			}
		});
	}
	function query(){
		if(flag==false){
			window.location.href="<%=request.getContextPath()%>/web/listQuestionnaire";
			return;
		}
		$.ajax({
			url:"web/addvote",
			data:"ids="+mycars+"&token="+'${token}'+"&problemId="+'${quests.qid }'+"&dsck="+dsck,
			type:"post",
			async:false,
			success:function(json){
				if(json=="1"){
				   window.location.href="<%=request.getContextPath()%>/web/listQuestionnaire";
				}else{
				   alert("操作失败");
				}
			}
		});
	}
</script>
<body>
<div class="wjbox">
  <div class="wj_tit clearfix"><p>
		<c:if test="${quests.dsck>1}">
	  		${pageNo }.${quests.title}:${quests.content}${quests.dsck==0?'(多选)':quests.dsck==1?'(单选)':''}(最多${quests.dsck}个选项)：${detail.isCheck}
	  	</c:if>
	  	<c:if test="${quests.dsck<=1}">
	  		${pageNo }.${quests.title}:${quests.content}${quests.dsck==0?'(多选)':quests.dsck==1?'(单选)':''}：
	  	</c:if>
	</p><!-- <a href="#" class="wj_jieguo">结果</a> --></div>
  <ul class="wj_tm">
    <c:forEach items="${list}" var="detail" varStatus="i">
    	<li ${detail.isCheck>0?"class='cur'":"" } id="l${detail.id}">
    		<a href="javascript:check(${detail.id })">
    			<span class="${i.count==1?'c_fen':i.count==2?'c_lv':i.count==3?'c_huang':i.count==4?'c_yellow':i.count==5?'c_blue':i.count==6?'c_green':i.count==7?'c_purple':''}">${detail.no }</span><p>${detail.content }</p><span class="xz"></span>
    		</a>
    	</li>
    </c:forEach>
  </ul>
  <div class="wj_tijiao">
  		<c:if test="${pageCount>=pageNo+1}">
	  		<td><a href="javascript:add()" >下一步</a></td>
		</c:if>
		<c:if test="${pageCount==pageNo}">
	  		<td><a href="javascript:query()" >下一步</a></td>
		</c:if>
  </div>
</div>
</body>
</html>
