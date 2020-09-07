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
<link href="resource/wj/css/basic.css" type="text/css" rel="stylesheet">
</head>
<script type="text/javascript">
	function tocheck(a,b,num,vid){
		var vote = document.getElementById("optionId"+num).value;
		if(a==1){//单选
			$(".xuan").on("click", "a", function(){
			      // console.log($(this).parents("dl").find("span"));
			      // console.log($(this).parents("dl").find("span").index($(this)));
			      $(this).parents('dl').find('span').addClass('cur')
			      $(this).parents('dd').siblings().find('span').removeClass('cur')
			    })
			    document.getElementById("optionId"+num).value=vid+",";
		}
		if(a==2){//多选
			var id = $("#duo"+num+"-"+b);
			var att = id.attr("class");
			if(att!='choice'){
				id.attr("class","choice");
				document.getElementById("optionId"+num).value = vote+vid+",";
			}else{
				id.attr("class","unchoice");
				document.getElementById("optionId"+num).value=vote.replace(vid+",","");
			}
		}
		
	}

	//提交按钮
	function tosubmit(){
		var topMenus = getClass('input','optionclass');
	    for(var i=0;i < topMenus.length; i++)
	    {
		    if(topMenus[i].value==""){
		    	$("#tjwarm").show();
		    	return;
		    }      
	    }
		$("#tishibox").show();
	}


	function getClass(tagName,className) //获得标签名为tagName,类名className的元素
	{
	    if(document.getElementsByClassName) //支持这个函数
	    {        return document.getElementsByClassName(className);
	    }
	    else
	    {       var tags=document.getElementsByTagName(tagName);//获取标签
	        var tagArr=[];//用于返回类名为className的元素
	        for(var i=0;i < tags.length; i++)
	        {
	            if(tags[i].class == className)
	            {
	                tagArr[tagArr.length] = tags[i];//保存满足条件的元素
	            }
	        }
	        return tagArr;
	    }

	}

		
	//确认提交
	function tjbtn(){
		<%--$("#form").submit(function (){
			$.ajax({
				url:"${base}/web/addvote",
				data: $('#form').serialize(), 
				type:"post",
				success:function(json){
					alert(json);
				}
			});
		});--%>
		$("#form").submit();
	}

	function closeWarm(){
		$("#tjwarm").hide();
	}
</script>

<body >
<div class="wjbox">
<form id="form" action="web/addvote" method="post">
  <ul class="xuan">
  	<c:if test="${!empty list}">
  		<c:forEach items="${list}" var="question" varStatus="num">
  			<li style="padding-top: 10px;">
		      <div class="wjtit" id=""><span>Q${num.count }</span>${question.content }</div>
	  			<input type="hidden" name="voteList[${num.count }].problemId" value="${question.qid }" />
	  			<input type="hidden" name="voteList[${num.count }].ids" id="optionId${num.count}" value="" class="optionclass" />
		      	<c:if test="${question.dsck==1}">
		      		<dl class="wjcon" >
				      	<c:forEach items="${question.detailList}" var="questionDetail" varStatus="i">
				      		<dd class="dan${num.count }"><a href="javascript:tocheck(1,'${i.count }','${num.count }','${questionDetail.id}')"><span id="dan${num.count }-${i.count }" ></span>${questionDetail.no }.${questionDetail.content }</a></dd>
				      	</c:forEach>
				      </dl>
		      	</c:if>
		      	<c:if test="${question.dsck!=1}">
		      		<dl class="wjcon">
				      	<c:forEach items="${question.detailList}" var="questionDetail" varStatus="j">
				      		<dd><a href="javascript:tocheck(2,'${j.count }','${num.count }','${questionDetail.id}')"><span id="duo${num.count }-${j.count }" class="unchoice"></span> ${questionDetail.no }.${questionDetail.content }</a></dd>
				      	</c:forEach>
				      </dl>
		      	</c:if>
		      
		    </li>
  		</c:forEach>
  	</c:if>
  </ul>
  </form>
  <c:if test="${state!=false}">
  	<div class="wj_tijiao" style="padding-top: 10px"><a href="javascript:tosubmit();">提交</a></div>
  </c:if>
</div>

<div class="tishibox" style="display: none;" id="tishibox">
  <div class="tishi">
    <div class="tishicon">
      <img src="resource/wj/images/ts.png">
      <div class="ts_text">
        <h2>成功提交</h2>
        <p>感谢您参与问卷调查</p>
        <a href="javascript:tjbtn();">确定</a>
      </div>
    </div>
  </div>
</div>
<div class="tishibox" style="display: none;" id="tjwarm">
  <div class="tishi">
    <div class="tishicon">
      <img src="resource/wj/images/ts.png">
      <div class="ts_text">
        <h2>提示</h2>
        <p>有未完成的题目，请填完再提交！</p>
        <a href="javascript:closeWarm();">确定</a>
      </div>
    </div>
  </div>
</div>

<!-- 错误消息提示 -->
<div align="center" style="margin-top: 0px;width: auto;">
  	<font color="red" size="3px">${msg}</font>
</div>	
</body>
</html>
