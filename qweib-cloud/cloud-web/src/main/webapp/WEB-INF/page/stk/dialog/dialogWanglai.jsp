<%@ page language="java" pageEncoding="UTF-8"%>
<div class="chose_people pcl_chose_people" style="display: ''" id="wanglaiForm">
			<div class="mask"></div>
			<div class="cp_list2">
				<div class="pcl_box_left">
					<div class="cp_src">
						<div class="cp_src_box">
							<img src="<%=basePath %>/resource/stkstyle/img/src_icon2.jpg" />
							<input type="text" placeholder="模糊查询" id="searchtext" onkeyup ="queryclick2()"/>
						</div>
						<input type="button" class="cp_btn" value="查询" onclick="queryclick2()"/>
						<input type="button" class="cp_btn2 close_btn2" value="取消"/>
					</div>
					<div class="cp_btn_box">
						<a href="javascript:;" class="on">客户</a><a href="javascript:;">其它往来单位</a><a href="javascript:;">部门</a><a href="javascript:;" >供应商</a>
					</div>
				</div>
				<div class="pcl_3box">
					<div class="pcl_switch">
						<div class="pcl_3box1">
						<div style="height: 400px;overflow: auto;text-align: center">
							<table class="pcl_table">
								<thead>
									<tr>
										<td>客户名称</td>
										<td>联系电话</td>
										<td>地址</td>
										<td>联系人</td>
									</tr>
								</thead>
								<tbody id="customerlist2">
									
								</tbody>
							</table>
							<span id="customerLoadData" style="text-align: center;float:center;"><a href="javascript:;;" onclick="searchcustomerPage()" style="color: red">加载更多</a></span>
							</div>
						</div>
					</div>
					
					<div class="pcl_switch">
						<div class="pcl_3box1">
						<div style="height: 400px;overflow: auto;text-align: center">
							<table class="pcl_table">
								<thead>
									<tr>
										<td>往来单位</td>
										<td>联系电话</td>
										<td>地址</td>
									</tr>
								</thead>
								<tbody id="unitList">
									
								</tbody>
							</table>
							<span id="customerLoadData" style="text-align: center;float:center;"><a href="javascript:;;" onclick="searchFinUnitPage()" style="color: red">加载更多</a></span>
							</div>
						</div>
					</div>
					<div class="pcl_switch clearfix">
						<div class="pcl_3box2" style="height: 350px;overflow: auto;">
							<h2>部门分类树</h2>
							<div class="pcl_l2" id="departTree2" >
							</div>
						</div>
						<div class="pcl_rf_box">
						<div style="height: 400px;overflow: auto;text-align: center">
							<table class="pcl_table" >
								<thead>
									<tr>
										<td>姓名</td>
										<td>电话</td>
									</tr>
								</thead>
								<tbody id="memberList2">
									
								</tbody>
							</table>
							</div>
						</div>
					</div>
					<div class="pcl_switch clearfix">
						<div class="pcl_3box1">
						<div style="height: 400px;overflow: auto;text-align: center">
							<table class="pcl_table">
								<thead>
									<tr>
										<td>供应商</td>
										<td>联系电话</td>
										<td>地址</td>
									</tr>
								</thead>
								<tbody id="provderList">
								</tbody>
							</table>
						</div>	
						</div>
					</div>
				</div>
			</div>
		</div>	
<script type="text/javascript">
var p0 =1;
var p1 =1;
var p2 =1;
var p3 =1;
var pageIndex =2;
function queryclick2()
{
	var searchText = $("#searchtext").val();
	if(pageIndex == 0){searchProvider(searchText);}
	else if(pageIndex == 1){searchMemberByName(searchText);}
	else if(pageIndex == 2){searchcustomer(searchText);}
	else{if(pageIndex == 3)searchFinUnit(searchText);}
}
function searchProvider(filter){
	
	var path = "stkprovider";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":1,"rows":50,"dataTp":"1","proName":filter},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.rows.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        			text += "<tr ondblclick=\"providerClick(this)\">" ;
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


function searchFinUnit(filter){
	p3=1;
	var path = "queryFinUnit";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":1,"rows":50,"dataTp":"1","proName":filter},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.rows.length;
        		var text = "";
        		
        		for(var i = 0;i < size; i++)
        			{
        			text += "<tr ondblclick=\"finUnitClick(this)\">" ;
					text += "<td><input  type=\"hidden\" name=\"proId\" value=\"" + json.rows[i].id + "\"/>";  
					text += json.rows[i].proName + "</td>";
					text += "<td>" + json.rows[i].tel + "</td>";
					text += "<td>" + json.rows[i].address + "</td>";
					text += "</tr>";
						
        			}
				p3++;
        		$("#unitList").html(text);
        	}
        }
    });
}
function searchFinUnitPage(){
	var filter = $("#searchtext").val();
	var path = "queryFinUnit";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":p3,"rows":50,"dataTp":"1","proName":filter},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		var size = json.rows.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        			text += "<tr ondblclick=\"finUnitClick(this)\">" ;
					text += "<td><input  type=\"hidden\" name=\"proId\" value=\"" + json.rows[i].id + "\"/>";  
					text += json.rows[i].proName + "</td>";
					text += "<td>" + json.rows[i].tel + "</td>";
					text += "<td>" + json.rows[i].address + "</td>";
					text += "</tr>";
        			}
				p3++;
        		$("#unitList").append(text);
        	}
        }
    });
}


function providerClick(trobj)
{
	var cstId = $(trobj.cells[0]).find("input[name='proId']").val();
	var shr = $(trobj.cells[0]).text();
	$("#cstId").val(cstId);
	//$("#pc_lib").html(shr);

	//$('#cstIdComb').combobox('setValue',cstId);
	//$('#cstIdComb').combobox('setText',shr);
	$("#khNm").val(shr);

	$("#proType").val(0);
	$(".pcl_chose_people").hide();
	
}

function searchdepart(){
	var path = "queryStkDepart";
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
        				text += makeDepartTree2(json.list,json.list[i]) ;
						
        			}
        		$("#departTree2").html(text);
        		if(firstId != 0)searchMember(firstId);
        	}
        }
    });
}

function makeDepartTree2(departList,obj)
{
	if(obj.ischild == "2")//没有子部门
	{
		var retStr = "<a href='javascript:searchMember(" + obj.branchId + ");'>" + obj.branchName + "</a>";
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

function finUnitClick(trobj)
{
	var cstId = $(trobj.cells[0]).find("input[name='proId']").val();
	var shr = $(trobj.cells[0]).text();
	$("#cstId").val(cstId);
	//$("#pc_lib").html(shr);

	$("#khNm").val(shr);

	//$('#cstIdComb').combobox('setValue',cstId);
	//$('#cstIdComb').combobox('setText',shr);

	$("#proType").val(3);
	$(".pcl_chose_people").hide();
}

function searchcustomer(filter){
	p2=1;
	var path = "stkchoosecustomer";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":1,"rows":50,"dataTp":"1","khNm":filter},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.rows.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        			text += "<tr ondblclick=\"setCustomer(this)\">" ;
    				text += "<td><span id=\"pc_lib_name\">" + json.rows[i].khNm + "</span><input  type=\"hidden\" name=\"cstId\" value=\"" + json.rows[i].id + "\"/></td>	";  
					text += "<td><span id=\"pc_lib_mes\">" + json.rows[i].mobile + "</span></td>";
					text += "<td><span id=\"pc_address\">" + json.rows[i].address+ "</span></td>";
					text += "<td><span id=\"pc_khNm\">" + json.rows[i].linkman+ "</span></td>";
					text += "<td style='display:none'>" + json.rows[i].branchName +"</td>";
					text += "<td style='display:none'><span class=\"bule_col\">" + json.rows[i].shZt + "</span></td>";
					text += "<td style='display:none'><span id='saleId'>" + json.rows[i].memId + "</span><span id='saleNm'>" + json.rows[i].memberNm + "</span></td>";       				
    				text += "</tr>";
						
        			}
				p2++;
        		$("#customerlist2").html(text);
        	}
        }
    });
}
function searchcustomerPage(){
	var filter = $("#searchtext").val();
	var path = "stkchoosecustomer";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":p2,"rows":50,"dataTp":"1","khNm":filter},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		var size = json.rows.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        			text += "<tr ondblclick=\"setCustomer(this)\">" ;
    				text += "<td><span id=\"pc_lib_name\">" + json.rows[i].khNm + "</span><input  type=\"hidden\" name=\"cstId\" value=\"" + json.rows[i].id + "\"/></td>	";  
					text += "<td><span id=\"pc_lib_mes\">" + json.rows[i].mobile + "</span></td>";
					text += "<td><span id=\"pc_address\">" + json.rows[i].address+ "</span></td>";
					text += "<td><span id=\"pc_khNm\">" + json.rows[i].linkman+ "</span></td>";
					text += "<td style='display:none'>" + json.rows[i].branchName +"</td>";
					text += "<td style='display:none'><span class=\"bule_col\">" + json.rows[i].shZt + "</span></td>";
					text += "<td style='display:none'><span id='saleId'>" + json.rows[i].memId + "</span><span id='saleNm'>" + json.rows[i].memberNm + "</span></td>";       				
    				text += "</tr>";
        			}
				p2++;
        		$("#customerlist2").append(text);
        	}
        }
    });
}

function setCustomer(trobj)
{
	var cstId = $(trobj.cells[0]).find("input[name='cstId']").val();
	var shr = $(trobj.cells[0]).find("span").text();
	if(isEp==1){
		$("#epCustomerId").val(cstId);
		$("#epCustomerName").val(shr);
		$(".pcl_chose_people").hide();
		return;
	}
	var tel = $(trobj.cells[1]).find("#pc_lib_mes").text();
	var address = $(trobj.cells[2]).find("#pc_address").text();
	var saleId = $(trobj.cells[6]).find("#saleId").text();
	$("#proType").val(2);
	$("#cstId").val(cstId);
	//$("#pc_lib").html(shr);
    checkCustomerUnRec(cstId);
	$("#khNm").val(shr);
	//$('#cstIdComb').combobox('setValue',cstId);
	//$('#cstIdComb').combobox('setText',shr);

	$("#csttel").val(tel);
	$("#cstaddress").val(address);
	getMemberInfo(saleId);
	$(".pcl_chose_people").hide();
	setTimeout('setPingYi()',10);
	isModify=true;

}


function searchMember(branchId){
	var path = "stkMemberPage";
	var token = $("#tmptoken").val();
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":1,"rows":50,"branchId":branchId},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		showMember(json);	
        	}
        }
    });
}

function searchMemberByName(memberNm)
{
	var path = "stkMemberPage";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":1,"rows":50,"memberNm":memberNm},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		showMember(json);	
        	}
        }
    });
}

function showMember(json)
{
	var size = json.rows.length;
	var text = "";
	for(var i = 0;i < size; i++)
		{
			text += "<tr ondblclick=\"setMember(this)\">" ;
			text += "<td>" + json.rows[i].memberNm + "<input  type=\"hidden\" name=\"memberId\" value=\"" + json.rows[i].memberId + "\"/></td>	";  
			text += "<td>" + json.rows[i].memberMobile + "</td>";	
			text += "</tr>";
		}
	$("#memberList2").html(text);
}

function setMember(trobj)
{
	var proId = $(trobj.cells[0]).find("input[name='memberId']").val();
	var memberNm = $(trobj.cells[0]).text();
	var tel = $(trobj.cells[1]).text();
	$("#cstId").val(proId);
	//$("#pc_lib").html(memberNm);
	//$('#cstIdComb').combobox('setValue',proId);
	//$('#cstIdComb').combobox('setText',memberNm);
	$("#khNm").val(memberNm);

	$("#proType").val(1);
	$(".pcl_chose_people").hide();
}

function sw(tl,ct){
	tl.first().addClass("on");
	ct.first().show();
	tl.click(function(){
		var a = $(this).index();
		var txt = $(this).text();
		//pageIndex = a;
		if(txt=="客户"){
			pageIndex=2;
		}
		if(txt=="供应商"){
			pageIndex=0;
		}
		if(txt=="部门"){
			pageIndex=1;
		}
		if(txt=="其它往来单位"){
			pageIndex=3;
		}
		if (ct.eq(a).css("display")!= "block") {
			ct.hide(),
			ct.eq(a).show(),
			tl.removeClass("on"),
			$(this).addClass("on");
		};
	});
}
sw($(".cp_btn_box a"),$(".pcl_3box .pcl_switch"));

searchProvider();
searchcustomer();
searchdepart();
searchFinUnit();
</script>	
		
		