<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/md5.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/stkcheck.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
		<input  type="hidden" name="billId" id="billId" value="${billId}"/>
				
				<input  type="hidden" name="cstId" id="cstId" value="${cstId}"/>
				<input  type="hidden" name="proType" id="proType" value="${proType}"/>
				<input  type="hidden" name="status" id="status" value="${status}"/>
				
				
				<input  type="hidden" name="accId" id="accId" value="${accId}"/>
		<div class="box">
  			
  			  
  			
  				
  			
  				
  			    <dl id="dl">
	      			<dt class="f14 b">费用支付凭证</dt>
	      			<dd>
	        			<span class="title" style="color:red">${billStatus}</span>
	        		</dd>
	        		<dd>
	        		   
	      				<span class="title">收款对象：</span>
	        			<input class="reg_input" name="cstName" id="cstName" value="${cstName}" style="width: 120px"/>
	        			<span id="memberNmTip" class="onshow"></span>
	        			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:selectEmpClick();">查找</a>
	        		</dd>
	        		<dd>
	        		<span class="title">收款时间：</span>
	        		<input name="sdate" id="recTime"  onClick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 120px;" value="${recTimeStr}" readonly="readonly"/>
	        		</dd>
	        		
	        		<dd>
	      				<span class="title">收款金额：</span>
	        			<input class="reg_input" name="cash" id="cash" value="${recAmt}"  style="width: 120px" onkeyup="makeAmtFormat(0,this.value)"/>
	        			<span class="title" id="lbcash">0</span>
	        			
	        		</dd>
	        		<dd>
	      				<span class="title">收款账户：</span>
	        			
										<select name=""  id = "payAccount">
											
										</select>
									
	        		</dd>
	        		<dd>
	        		<span class="title">收款项目：</span>
	        			<input class="reg_input" name="itemName" id="itemName"  style="width: 220px" />
	        			
	        			
	        		</dd>
	        		
	        		<dd>
	      				<span class="title">备注：</span>
	        			<textarea rows="4" cols="50" name="remarks" id="remarks"></textarea>
	        		</dd>
	        	</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			
	     		</div>
	  		
		</div>
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div class="chose_people pcl_chose_people" style="" id="empselect">
			<div class="mask"></div>
			<div class="cp_list2">
				<!--<a href="javascript:;" class="pcl_close_button"><img src="style/img/lightbox-btn-close.jpg"/></a>-->
				<div class="pcl_box_left">
					<div class="cp_src">
						<div class="cp_src_box">
							<img src="<%=basePath %>/resource/stkstyle/img/src_icon2.jpg"/>
							<input type="text" placeholder="模糊查询" id="searchtext"/>
						</div>
						<input type="button" class="cp_btn" value="查询" onclick="queryclick()"/>
						<input type="button" class="cp_btn2 close_btn2" value="取消"/>
					</div>
					<div class="cp_btn_box">
						<a href="javascript:;" class="on">供应商</a><a href="javascript:;">部门</a><a href="javascript:;">客户</a>
					</div>
				</div>
				<div class="pcl_3box">
					<div class="pcl_switch">
						<div class="pcl_3box1">
							<table class="pcl_table">
								<thead>
									<tr>
										<td>供应商</td>
										<td>联系电话</td>
										<td>地址</td>
									</tr>
								</thead>
								<tbody id="provderList">
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="pcl_switch clearfix">
						<div class="pcl_3box2">
							<h2>部门分类树</h2>
							<div class="pcl_l2" id="departTree">
								<a href="#">员工</a>
								<a href="#">员工</a>
								<a href="#">员工</a>
								<div class="pcl_infinite">
									<p><i></i>综合部</p>
									<div class="pcl_file">
										<a href="#">员工</a>
										<a href="#">员工</a>
										<a href="#">员工</a>
										<div class="pcl_infinite">
											<p><i></i>综合部</p>
											<div class="pcl_file">
												<a href="#">员工</a>
												<a href="#">员工</a>
												<a href="#">员工</a>
											</div>
										</div>
									</div>
								</div>
								<div class="pcl_file">
									<div class="pcl_infinite">
										<p><i></i>综合部</p>
										<div class="pcl_file">
											<a href="#">员工</a>
											<a href="#">员工</a>
											<a href="#">员工</a>
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="pcl_rf_box">
							<table class="pcl_table" >
								<thead>
									<tr>
										<td>姓名</td>
										<td>职位</td>
									</tr>
								</thead>
								<tbody id="memberList">
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
									
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr><tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="pcl_switch">
						<div class="pcl_3box1">
							<table class="pcl_table">
								<thead>
									<tr>
										<td>客户名称</td>
										<td>联系电话</td>
										<td>地址</td>
									</tr>
								</thead>
								<tbody id="customerlist">
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				
			</div>
		</div>	
		<script type="text/javascript">
			var editstatus = 1;
		    $(function(){
		    	queryAccount();
		    	queryProvider();
		    	querycustomer();
		    	querydepart();
				
				
			});

		    
			function toSubmit(){
				
					//验证手机号码
					var status = $("#status").val();
					if(status> 0)
						{
							alert('该单据不能修改');
							return;
						}
					var cash = $("#cash").val();
					var accId = $("#accId").val();
					var remarks = $("#remarks").val();
					var itemName = $("#itemName").val();
					var cstName = $("#cstName").val();
					var cstId = $("#cstId").val();
					var billId = $("#billId").val();
					var recTime = $("#recTime").val();
					var proType = $("#proType").val();
					if(cash == "")
						{
						  alert("请输入收款金额");
						  return;
						}
					if(accId == "")
						{
						alert("请选择收款账户");
						return;
						}
					
					
					var path = "manager/addFinRec"
					
					if(!confirm('是否确定保存？'))return;
					
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"token":"111","id":billId,"cstId":cstId,"accId":accId,"proType":proType,"khNm":cstName,"recAmt":cash,"remarks":remarks,"recTimeStr":recTime,"itemName":itemName},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	
				        	if(json.state){
				        		$("#billId").val(json.id);
				        		alert("保存成功");
				        		location.href="${base}/manager/toFinRecList";
				        	}
				        }
				    });
				
			}
			function toback(){
				var billId = $("#billId");
				location.href="${base}/manager/toFinRecList";
			}
			
			
            
			
			
			////////////////////////////
			
			function makeAmtFormat(payType,amt)
            {
                if(payType == 0)
                    {
                		$("#lbcash").text('¥' +numeral(amt).format("0,0.00"));
                    }
                if(payType == 1)
                {
            		$("#lbbank").text('¥' + numeral(amt).format("0,0.00"));
                }
                if(payType == 2)
                {
            		$("#lbwx").text('¥' + numeral(amt).format("0,0.00"));
                }
                if(payType == 3)
                {
            		$("#lbzfb").text('¥' + numeral(amt).format("0,0.00"));
                }
            }
			
			function selectEmpClick()
			{
				if(editstatus == 0)return;
				$("#empselect").show();
			}
			
			$(".pcl_infinite p").on('click',function(){
				if($(this).hasClass('open')){
					$(this).siblings('.pcl_file').slideUp(200);
					$(this).removeClass('open');
				}else{
					$(this).siblings('.pcl_file').slideDown(200);
					$(this).addClass('open');
				}
			});
			
			$(".pcl_menu_m p").on('click',function(){
				if($(this).hasClass('open')){
					$(this).siblings('.pcl_sub_menu').slideUp(200);
					$(this).removeClass('open');
				}else{
					$(this).siblings('.pcl_sub_menu').slideDown(200);
					$(this).addClass('open');
				}
			});
			
			function close_box(box,btn){
				btn.click(function(){
					box.hide();
				});
			}
			
			function sw(tl,ct){
				tl.first().addClass("on");
				ct.first().show();
			
				tl.click(function(){
					var a = $(this).index();
					pageIndex = a;
					if (ct.eq(a).css("display")!= "block") {
						ct.hide(),
						ct.eq(a).show(),
						tl.removeClass("on"),
						$(this).addClass("on");
					};
				});
			}
			
			sw($(".cp_btn_box a"),$(".pcl_3box .pcl_switch"));
			sw($(".wap_swich_wap td"),$(".wap_bbbb li"));
			
			
			//关闭浮层
			close_box($(".pcl_chose_people"),$(".close_button"));
			close_box($(".pcl_chose_people"),$(".close_btn2"));
			
			
			function queryProvider(filter){
				
				var path = "manager/stkprovider";
				var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token":token,"page":1,"rows":12,"dataTp":"1","proName":filter},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		
			        		var size = json.rows.length;
			        		var text = "";
			        		for(var i = 0;i < size; i++)
			        			{
			        			text += "<tr onclick=\"providerClick(this)\">" ;
								text += "<td><input  type=\"hidden\" name=\"proId\" value=\"" + json.rows[i].id + "\"/>";  
								text += json.rows[i].proName + "</td>";
								text += "<td>" + json.rows[i].tel + "</td>";
								text += "<td>" + json.rows[i].address + "</td>";
								text += "</tr>";
									
			        			}
							
			        		
			        		$("#provderList").html(text);
			        	}
			        }
			    });
			}


			function providerClick(trobj)
			{
				var cstId = $(trobj.cells[0]).find("input[name='proId']").val();
				var shr = $(trobj.cells[0]).text();
				//var tel = $(trobj.cells[1]).find("#pc_lib_mes").text();
				//var address = $(trobj.cells[2]).find("#pc_address").text();
				//var gyn = $(this).find('#pc_lib_name').text(),n = $(this).find('#pc_lib_mes').text();
				//var address = $(this).find('#pc_address').text();
				//var cstId = $(this).find("input[name='cstId']").val();
				
				$("#cstId").val(cstId);
				$("#cstName").val(shr);
				$("#proType").val(0);
				
				//$("#csttel").val(tel);
				//$("#cstaddress").val(address);
				$(".pcl_chose_people").hide();
				//queryOrder();
			}

			function querycustomer(filter){
				
				var path = "manager/stkchoosecustomer";
				var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token":token,"page":1,"rows":12,"dataTp":"1","khNm":filter},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		
			        		var size = json.rows.length;
			        		var text = "";
			        		for(var i = 0;i < size; i++)
			        			{
			        				text += "<tr onclick=\"customerclick(this)\">" ;
			        					text += "<td>" + json.rows[i].khNm + "<input  type=\"hidden\" name=\"cstId\" value=\"" + json.rows[i].id + "\"/></td>	";  
			        				
									text += "<td>" + json.rows[i].mobile + "</td>";
									text += "<td>" + json.rows[i].address+ "</td>";
									
									       				
			        				text += "</tr>";
									
			        			}
							
			        		
			        		$("#customerlist").html(text);
			        	}
			        }
			    });
			}

			function customerclick(trobj)
			{
				var cstId = $(trobj.cells[0]).find("input[name='cstId']").val();
				var shr = $(trobj.cells[0]).text();
				//var tel = $(trobj.cells[1]).find("#pc_lib_mes").text();
				//var address = $(trobj.cells[2]).find("#pc_address").text();
				//var gyn = $(this).find('#pc_lib_name').text(),n = $(this).find('#pc_lib_mes').text();
				//var address = $(this).find('#pc_address').text();
				//var cstId = $(this).find("input[name='cstId']").val();
				
				$("#cstId").val(cstId);
				$("#cstName").val(shr);
				$("#proType").val(2);
				//$("#csttel").val(tel);
				//$("#cstaddress").val(address);
				$(".pcl_chose_people").hide();
				//queryOrder();
			}

			function queryMember(branchId){
				
				var path = "manager/stkMemberPage";
				var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token":token,"page":1,"rows":8,"branchId":branchId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		displayMember(json);	
			        		
			        	}
			        }
			    });
			}

			function queryMemberByName(memberNm)
			{
				var path = "manager/stkMemberPage";
				var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token":token,"page":1,"rows":8,"memberNm":memberNm},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		displayMember(json);	
			        		
			        	}
			        }
			    });
			}

			function displayMember(json)
			{
				var size = json.rows.length;
				var text = "";
				for(var i = 0;i < size; i++)
					{
						text += "<tr onclick=\"memberClick(this)\">" ;
							text += "<td>" + json.rows[i].memberNm + "<input  type=\"hidden\" name=\"memberId\" value=\"" + json.rows[i].memberId + "\"/></td>	";  
						
						text += "<td>" + json.rows[i].memberJob +"<input  type=\"hidden\" name=\"branchId\" value=\"" + json.rows[i].branchId + "\"/></td>";	
						
						       				
						text += "</tr>";
						
					}
				
				
				$("#memberList").html(text);
			}

			function memberClick(trobj)
			{
				var proId = $(trobj.cells[0]).find("input[name='memberId']").val();
				var depId = $(trobj.cells[1]).find("input[name='branchId']").val();
				
				var memberNm = $(trobj.cells[0]).text();
				
				//var gyn = $(this).find('#pc_lib_name').text(),n = $(this).find('#pc_lib_mes').text();
				//var address = $(this).find('#pc_address').text();
				//var cstId = $(this).find("input[name='cstId']").val();
				
				$("#cstId").val(proId);
				$("#cstName").val(memberNm);
				$("#depId").val(depId);
				$("#proType").val(1);
				$(".pcl_chose_people").hide();
				//queryOrder();
			}

			
			function querydepart(){
				
				var path = "manager/queryStkDepart";
				var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"dataTp":"1"},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		
			        		var size = json.list.length;
			        		var text = "";
			        		var firstId = 0;
			        		for(var i = 0;i < size; i++)
			        			{
			        				if(firstId == 0 && json.list[i].ischild == "2")firstId = json.list[i].branchId;
			        				if(json.list[i].ischild == "0")continue;
			        				text += makeDepartTree(json.list,json.list[i]) ;
									
			        			}
							
			        		
			        		$("#departTree").html(text);
			        		if(firstId != 0)queryMember(firstId);
			        	}
			        }
			    });
			}

			function makeDepartTree(departList,obj)
			{
				if(obj.ischild == "2")//没有子部门
				{
					var retStr = "<a href='javascript:queryMember(" + obj.branchId + ");'>" + obj.branchName + "</a>";
					obj.ischild = 0;
					return retStr;
				}
				if(obj.ischild == "1")
				{
					var retStr = "<div class='pcl_infinite'>";
						retStr += "<p><i></i>" + obj.branchName + "</p>";
						retStr += "<div class='pcl_file'>";
						obj.ischild = 0;
						for(var i = 0;i<departList.length;i++)
							{
								if(departList[i].parentId == obj.branchId)
									{
										
										retStr += makeDepartTree(departList,departList[i]);
									}
							}
						retStr += "</div>";
						retStr += "</div>";
						return retStr;
						
				}
				return "";
			}
			
			function queryAccount(){
				var path = "manager/queryAccountList";
				//var token = $("#tmptoken").val();
				//alert(token);
				
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token11":""},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		
			        		var size = json.rows.length;
			        		gstklist = json.rows;
			        		var objSelect = document.getElementById("payAccount");
			        		objSelect.options.add(new Option(''),'');
			        		for(var i = 0;i < size; i++)
			        			{
			        				
			        				objSelect.options.add( new Option(json.rows[i].accName,json.rows[i].id));
			        				
			        				
			        			}
			        		
							
			        		
			        	}
			        }
			    });
			    $("#payAccount").val($("#accId").val());
			}
			
			$("#payAccount").change(function(){
				var index = this.selectedIndex;
			    var accId = this.options[index].value;
			    $("#accId").val(accId);
			    
				
			});
            
		</script>
	</body>
</html>
