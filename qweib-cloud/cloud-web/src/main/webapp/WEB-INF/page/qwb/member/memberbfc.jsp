<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/memberbfcPage?dataTp=${dataTp }" title="业务员拜访明细列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="id" width="10" align="center" hidden="true">
						拜访id
					</th>
				    <th field="mid" width="10" align="center" hidden="true">
						业务员id
					</th>
					<th field="cid" width="10" align="center" hidden="true">
						客户id
					</th>
				    <th field="qddate" width="80" align="center" >
						拜访日期
					</th>
					<th field="memberNm" width="100" align="center" >
						业务员
					</th>
					<th field="khNm" width="120" align="center" >
						客户
					</th>
					<th field="qdtime" width="150" align="center" >
						签到时间
					</th>
					<th field="listpic" width="400" align="center" formatter="formatterSt">
						拜访拍照
					</th>
					<th field="count1" width="200" align="center" formatter="formatterSt1">
						订单信息
					</th>
					<th field="count2" width="200" align="center" formatter="formatterSt2">
						库存信息
					</th>
					<th field="memberMobile" width="100" align="center" >
						手机号
					</th>
					<th field="branchName" width="80" align="center" >
						部门
					</th>

					<th field="qdtpNm" width="80" align="center" >
						客户类型
					</th>
					<th field="khdjNm" width="80" align="center" >
						客户等级
					</th>
					<th field="remo" width="120" align="center" >
						客户备注
					</th>

					<th field="ldtime" width="150" align="center" >
						离店时间
					</th>
					<th field="bfsc" width="120" align="center" >
						拜访时长
					</th>

					<th field="oper1" width="80" align="center" formatter="formatterSt2">
						销售小结明细
					</th>
					<th field="bcbfzj" width="100" align="center" >
						拜访总结
					</th>
					<th field="dbsx" width="100" align="center" >
						代办事项
					</th>
					<th field="qdaddress" width="275" align="center" >
						签到地址
					</th>
					<th field="khaddress" width="275" align="center" >
						客户地址
					</th>
					<th field="linkman" width="100" align="center" >
						负责人
					</th>
					<th field="tel" width="120" align="center" >
						负责人电话
					</th>
					<th field="mobile" width="120" align="center" >
						负责人手机
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			部门：<select name="branchId" id="branchId">
		            <option value="">全部</option>
		            <c:forEach items="${deptList}" var="list">
		               <option value="${list.branchId}">${list.branchName}</option>
		            </c:forEach>
		        </select>
		    业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    客户类型： <select name="qdtpNm" id="qdtpNm" style="width: 125px;" ></select>
		    客户等级: <select name="khdjNm" id="khdjNm">
	                  <option value="">全部</option>
	                  <c:forEach items="${list}" var="list">
						<option value="${list.khdjNm}">${list.khdjNm}</option>
					  </c:forEach>
	               </select>   
		    拜访日期: <input name="stime" id="stime"  onClick="WdatePicker();" style="width: 100px;" value="${stime}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="etime"  onClick="WdatePicker();" style="width: 100px;" value="${etime}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			步骤1	
	        <input type="checkbox" id="picIndex1" checked="true"/>  
	        &nbsp;&nbsp;
	                            步骤2
	        <input type="checkbox" id="picIndex2" checked="true"/> 
	        &nbsp;&nbsp;
	                            步骤3
	        <input type="checkbox" id="picIndex3" checked="true"/> 
	        &nbsp;&nbsp; 
	                            步骤6
	        <input type="checkbox" id="picIndex4" checked="true"/> 	
	        	显示无图片记录
	        <input type="checkbox" id="isShow" checked="true"/>		  
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querymemberbfc();">查询</a>
			<a class="easyui-linkbutton" href="javascript:createRptData();">生成报表</a>
			<a class="easyui-linkbutton" href="javascript:queryRpt();">查询生成的报表</a>
		</div>
		<div id="bigPicDiv"  class="easyui-window" title="图片" style="width:315px;top: 110px;overflow: hidden;" 
			minimizable="false" maximizable="false" modal="true"  collapsible="false" 
			 closed="true">
			  <img style="width: 300px;" id="photoImg" alt=""/>
		</div>
	    <script type="text/javascript">
		    //查询
			function querymemberbfc(){
				var picIndex1 = 0;
				if( $('#picIndex1').prop('checked'))picIndex1 = 1;
				var picIndex2 = 0;
				if( $('#picIndex2').prop('checked'))picIndex2 = 1;
				var picIndex3 = 0;
				if( $('#picIndex3').prop('checked'))picIndex3 = 1;
				var picIndex4 = 0;
				if( $('#picIndex4').prop('checked'))picIndex4 = 1;
				var isShow = 0;
				if($('#isShow').prop('checked'))isShow = 1;
				$("#datagrid").datagrid('load',{
					url:"manager/memberbfcPage",
					jz:"1",
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val(),
					stime:$("#stime").val(),
					etime:$("#etime").val(),
					picIndex1:picIndex1,
					picIndex2:picIndex2,
					picIndex3:picIndex3,
					picIndex4:picIndex4,
					isShow:isShow,
					etime:$("#etime").val(),
					qdtpNm:$("#qdtpNm").val(),
					khdjNm:$("#khdjNm").val(),
					branchId:$("#branchId").val()
			});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querymemberbfc();
				}
			}
		    function formatterSt(v,row){
		        var hl='<table>';
		        hl +='<tr>';
		        for(var i=0;i<v.length;i++){
		           if((i+1)%4==0){
		              hl +='<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\''+v[i].pic+'\');"><img style="width: 85px;" src="${base}upload/'+v[i].picMin+'"/></a></br>&nbsp;&nbsp;&nbsp;'+v[i].nm+'</td>';
		              hl +='</tr>';
		              hl +='<tr>';
		           }else{
		             hl +='<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\''+v[i].pic+'\');"><img style="width: 85px;" src="${base}upload/'+v[i].picMin+'"/></a></br>&nbsp;&nbsp;&nbsp;'+v[i].nm+'</td>';
		           }
		        }
		        hl +='</tr>';
  			    hl +='</table>';
  			    return hl;
			}
			function todetail(title,mid,cid,qddate){
			    window.parent.add(title,"manager/memberbfcPicXq?mid="+mid+"&cid="+cid+"&qddate="+qddate);
			}
			function formatterSt2(v,row){
				return '<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:todetail2(\''+row.qddate+'/'+row.memberNm+'/'+row.khNm+'\','+row.mid+','+row.cid+',\''+row.qddate+'\');">查看</a>';
			}
			function todetail2(title,mid,cid,xjdate){
			    window.parent.add(title,"manager/toqueryBfxsxj?mid="+mid+"&cid="+cid+"&xjdate="+xjdate);
			}
			function toBigPic(picurl){
			   document.getElementById("photoImg").setAttribute("src","${base}upload/"+picurl);
			   $("#bigPicDiv").window("open");
		   }
		   $('#bigPicDiv').window({
		     onBeforeClose:function(){
		       document.getElementById("photoImg").setAttribute("src","");
		     }
		   });
		   
		 //获取客户类别
			function arealist1(){
				$.ajax({
					url:"manager/queryarealist1",
					type:"post",
					success:function(data){
						if(data){
						   var list = data.list1;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						      if(list[i].qdtpNm!=''){
						        if(list[i].qdtpNm==qdtpNm){
						          img +='<option value="'+list[i].qdtpNm+'" selected="selected">'+list[i].qdtpNm+'</option>';
						        }else{
						           img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
						        }
						       }
						    }
						   $("#qdtpNm").html(img);
						 }
					}
				});
			}
			arealist1();
			function createRptData()
		    {
				var picIndex1 = 0;
				if( $('#picIndex1').prop('checked'))picIndex1 = 1;
				var picIndex2 = 0;
				if( $('#picIndex2').prop('checked'))picIndex2 = 1;
				var picIndex3 = 0;
				if( $('#picIndex3').prop('checked'))picIndex3 = 1;
				var picIndex4 = 0;
				if( $('#picIndex4').prop('checked'))picIndex4 = 1;
				var isShow = 0;
				if($('#isShow').prop('checked'))isShow = 1;
				var khNm = $("#khNm").val();
				var memberNm = $("#memberNm").val();
				var stime = $("#stime").val();
				var etime = $("#etime").val();
				var picIndex1 = picIndex1;				
				var etime=$("#etime").val();
				var qdtpNm=$("#qdtpNm").val();
				var khdjNm=$("#khdjNm").val();
				var branchId=$("#branchId").val();
		    	parent.closeWin('业务员拜访明细报表');
		    	parent.add('业务员拜访明细报表','manager/toMemberbfcSave?stime=' + stime + '&etime=' + etime +'&memberNm='+memberNm+'&khNm=' + khNm
		    			+'&qdtpNm='+qdtpNm+'&khdjNm='+khdjNm + '&branchId=' + branchId + '&picIndex1=' + picIndex1 + '&picIndex2=' + picIndex2
		    			+'&picIndex3=' + picIndex3 + '&picIndex4=' + picIndex4 + '&isShow=' + isShow);
		    }
			
			function queryRpt()
		    {
		    	parent.closeWin('生成的统计表');
		    	parent.add('生成的统计表','manager/toMemberbfcQuery?rptType=11');
		    }

			function formatterSt1(v,row){
				var hl='<table width="100%">';
				if(row.list1.length>0){
					hl +='<tr>';
					hl +='<td width="60%;"><b>商品名称</b></td>';
					hl +='<td width="40%;"><b>数量</font></b></td>';
					hl +='</tr>';
				}
				for(var i=0;i<row.list1.length;i++){
					hl +='<tr>';
					hl +='<td>'+row.list1[i].wareNm+'</td>';
					hl +='<td>'+row.list1[i].wareNum+'</td>';
					hl +='</tr>';
				}
				hl +='</table>';
				return hl;
			}

			function formatterSt2(v,row){
				var hl='<table width="100%">';
				if(row.list2.length>0){
					hl +='<tr>';
					hl +='<td width="60%;"><b>商品名称</b></td>';
					hl +='<td width="40%;"><b>数量</font></b></td>';
					hl +='</tr>';
				}
				for(var i=0;i<row.list2.length;i++){
					hl +='<tr>';
					hl +='<td>'+row.list2[i].wareNm+'</td>';
					hl +='<td>'+row.list2[i].kcNum+'</td>';
					hl +='</tr>';
				}
				hl +='</table>';
				return hl;
			}
		</script>
	</body>
</html>
