/**
 * 
 */
var editstatus = 0;
var gstklist;
var orderlist;
$(function(){
	querystorage();
	var billId = $("#billId").val();
	if(billId == 0)
	queryCheckWare();
	
	querydepart();
	queryWareType();
	
	$("#staff").on('click',function(){
		
		if(editstatus == 0)return;
		$("#staffForm").show();
		$("#memdiv").show();
		$(".pcl_3box .pcl_switch").show();
	});
	
	function close_box(box,btn){
		btn.click(function(){
			box.hide();
		});
	}
	close_box($(".pcl_chose_people"),$(".close_button"));
	close_box($(".pcl_chose_people"),$(".close_btn2"));
	
	$("#staff").on('click',function(){
		
		
		$("#staffForm").show();
		$("#memdiv").show();
		$(".pcl_3box .pcl_switch").show();
	});
	
	
	var status = $("#status").val();
	
	
	if(billId==0)
		{
		
			statuschg(1);
		}
	else
		{
			statuschg(0);
		}
	if(billId == 0)
		{
		
		
		 var myDate = new Date();    
			var seperator1 = "-";
		    
		    var month = myDate.getMonth() + 1;
		    var strDate = myDate.getDate();
		    if (month >= 1 && month <= 9) {
		        month = "0" + month;
		    }
		    if (strDate >= 0 && strDate <= 9) {
		        strDate = "0" + strDate;
		    }
		    var hour = myDate.getHours();
		    if(hour < 10)hour = '0' + hour;
		    var minute = myDate.getMinutes();
		    if(minute<10)minute = '0' + minute;
		   
			var dateStr = myDate.getFullYear() + seperator1 + month + seperator1 + strDate + " " + hour + ":" + minute;		
			$("#checkDate").val(dateStr);
				
			
		}
	if(billId > 0)
	{
	document.getElementById("btnsave").style.display="none";
	}
	
	
	$('#wareInput').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            //需要处理的事情
        	var tb = document.getElementById("warelist");
        	var line = tb.getElementsByTagName("tr")[0];  
        	
        	
        	waredbclick(line);
        		
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
	
});


function querystorage(){
	var path = "queryBaseStorage";
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
        		
        		var size = json.list.length;
        		gstklist = json.list;
        		var objSelect = document.getElementById("stksel");
        		objSelect.options.add(new Option(''),'');
        		for(var i = 0;i < size; i++)
        			{
        				objSelect.options.add( new Option(json.list[i].stkName,json.list[i].id));
        				if(i == 0)
    					{
        					var billId = $("#billId").val();
        					
    						if(billId == 0)
    							{
    						$("#stkId").val(json.list[i].id);
    						$("#stkNamespan").text(json.list[i].stkName);
    							}
    						
    					}
        				
        			}
				
        		
        	}
        }
    });
}

function querydepart(){
	
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

function queryMember(branchId){
	
	var path = "stkMemberPage";
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
	var path = "stkMemberPage";
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
			
			text += "<td>" + json.rows[i].memberMobile + "</td>";	
			
			       				
			text += "</tr>";
			
		}
	
	
	$("#memberList").html(text);
}

function memberClick(trobj)
{
	var tel = $(trobj.cells[1]).text();
	
	var memberNm = $(trobj.cells[0]).text();
	
	//var gyn = $(this).find('#pc_lib_name').text(),n = $(this).find('#pc_lib_mes').text();
	//var address = $(this).find('#pc_address').text();
	//var cstId = $(this).find("input[name='cstId']").val();
	
	$("#staff").html(memberNm);
	$("#stafftel").val(tel);
	
	$(".pcl_chose_people").hide();
	//queryOrder();
}

function waredbclick(trobj)
{
	 
	if(editstatus == 0)return;
	var wareCode = trobj.cells[0].innerText;//childNodes[0].text;
	
	var wareId = $(trobj.cells[0]).find("input[name='wareId']").val();
	//alert(JSON.stringify(wareId));
	var wareName = trobj.cells[1].innerText;
	var price = trobj.cells[2].innerText;
	var stkQty = trobj.cells[3].innerText;
	var unitName = $(trobj.cells[1]).find("input[name='wareUnit']").val();
	$("#more_list tbody").append(
			
			'<tr>'+
			'<td style="padding-left: 20px;text-align: left;"><img src="'+basePath +'/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>'+
			'<input type="hidden" name="wareId" value = "' + wareId + '"/>' + wareCode + '</td>'+
			'<td>'+ wareName + '</td>'+
			
			'<td>' + unitName + '</td>'+
			'<td><input name="edtStkQty" type="text" class="pcl_i2" value="' + stkQty + '"</td>'+
			'<td><input name="realQty" type="text" class="pcl_i2" value="' + stkQty + '" onchange="countQty()"/></td>'+
			'<td>0</td>'+
			'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
			
		'</tr>'
				
			
		);
	countAmt();
	/*$(".pcl_del").on('click',function(){
		if(confirm('确定删除？')){
			$(this).parents('tr').remove();
		}
	});*/
	
}

function queryWareType()
{
	var path = "queryStkWareType";
	//var token = $("#tmptoken").val();
	//alert(token);
	var topType = 0;
	$.ajax({
        url: path,
        type: "POST",
        data : {"token11":""},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.list.length;
        		var text = "<table>";
					text+= "			<thead>";
					text+= "				<tr>";
					text+= "					<td>商品类别</td>";
										
					text+= "				</tr>";
					text+= "			</thead>";
								
					text+= "		</table>";
        		for(var i = 0;i < size; i++)
        		{
        				if(json.list[i].waretypeLeaf == 1)
        				{
        					text+="<div class=\"infinite\">";
        					text+="<div class=\"pcl_menu_m\">";
        					text+="	<div class=\"pcl_sub_menu\" style=\"display: block; padding-left: 0;\">";
        					text+="		<a href=\"javascript:queryWareByType(" +json.list[i].waretypeId + ");\">" + json.list[i].waretypeNm + "</a>";
        					text+="	</div>";
        					text+="</div>";
        					text+="</div>";
        					if(topType == 0)topType = json.list[i].waretypeId;
        				}
        				else
        				{
        					text+="<div class=\"infinite\">";
        					text+="<div class=\"pcl_menu_m\">";
        					text+="	<p>" + json.list[i].waretypeNm + "</p>";
        					text += "<div class=\"pcl_sub_menu\">";
        					var size2 = json.list[i].list2.length;
        					for(var j = 0;j<size2;j++)
        						{
								
        						text += "<a href=\"javascript:queryWareByType(" +json.list[i].list2[j].waretypeId + ");\">" + json.list[i].list2[j].waretypeNm + "</a>";
        						if(topType == 0)topType = json.list[i].list2[j].waretypeId;
									
        						}
        					text += "	</div>";
        					text += "</div>";
        					text += "</div>";
        				}
        				
        		}
        		
        		$("#wareTypeTree").html(text);
        		if(topType != 0)queryWareByType(topType);
				
        		
        	}
        }
    });
}

function queryWareByType(wareType)
{
	var path = "queryStkWare";
	//var token = $("#tmptoken").val();
	//alert(token);
	stkId = $("#stkId").val();
	if(stkId == "")stkId = 0;
	$.ajax({
        url: path,
        type: "POST",
        data : {"wareType":wareType,"stkId":stkId},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.list.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        				
        			text += '<tr ondblclick="waredbclick(this)">';
        			text += '<td style="padding-left: 20px;text-align: left;"><img src="' + basePath + '/resource/stkstyle/img/icon19.jpg" class="pcl_ic" name = "warecode"/><input type="hidden" name="wareId" value = "' +json.list[i].wareId+ '"/>' + json.list[i].wareCode + '</td>';
        			text += '<td><input type="hidden" name="wareUnit" value = "' + json.list[i].wareDw + '"/>' + json.list[i].wareNm + '</td>';
        			text += '<td>' + json.list[i].wareDj + '</td>';
        			text += '<td>' + json.list[i].stkQty + '</td>';
        			text += '</tr>';
        			}
        		$("#warelist").html(text);
				
        		
        	}
        }
    });
}

function queryWareByKeyWord(keyWord)
{
	
	var path = "queryStkWare1";
	//var token = $("#tmptoken").val();
	//alert(token);
	stkId = $("#stkId").val();
	if(stkId == "")stkId = 0;
	$.ajax({
        url: path,
        type: "POST",
        data : {"keyWord":keyWord,"stkId":stkId},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.list.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        				
        			text += '<tr ondblclick="waredbclick(this)">';
        			text += '<td style="padding-left: 20px;text-align: left;"><img src="' + basePath + '/resource/stkstyle/img/icon19.jpg" class="pcl_ic" name = "warecode"/><input type="hidden" name="wareId" value = "' +json.list[i].wareId+ '"/>' + json.list[i].wareCode + '</td>';
        			text += '<td><input type="hidden" name="wareUnit" value = "' + json.list[i].wareDw + '"/>' + json.list[i].wareNm + '</td>';
        			text += '<td>' + json.list[i].wareDj + '</td>';
        			text += '<td>' + json.list[i].stkQty + '</td>';
        			text += '</tr>';
        			}
        		$("#warelist").html(text);
				
        		
        	}
        }
    });
}


function editClick()
{
	if(editstatus != 0)
	{
	  return;
	}
	statuschg(2);
}

function deleteClick()
{
	if(editstatus != 0)
	{
	  alert("请先保存");
	  return;
	}
}

function auditClick()
{
	
	if(editstatus != 0)
		{
		  alert("请先保存");
		  return;
		}
	var status = $("#billstatus").val();
	//alert(status);
	if(status == "已审")
		{
		  alert("该单据已经审核");
		  return;
		}
	if(status == "作废")
		{
		alert("该单据已经作废");
		return;
		}
	auditProc();
}

function newClick()
{
	
	location = 'pcstkcheck';
	if(editstatus != 0)
	{
	  return;
	}
	statuschg(1);
}

function resetClick()
{
	statuschg(0);
}

function statuschg(btnstatus)
{
	editstatus = btnstatus;
	if(btnstatus==1)//新建
	{
		if($("#btnnew").hasClass('on')){
			$("#btnnew").removeClass('on');
		}
		//if($("#btnedit").hasClass('on')){
		//	$("#btnedit").removeClass('on');
		//}
		//if($("#btndelete").hasClass('on')){
		//	$("#btndelete").removeClass('on');
		//}
		//if($("#btnaudit").hasClass('on')){
		//	$("#btnaudit").removeClass('on');
		//}
		//if($("#btncancel").hasClass('on')){
		//	$("#btncancel").removeClass('on');
		//}
		if(!$("#btnsave").hasClass('on')){
			$("#btnsave").addClass('on');
		}
		if(!$("#btnreset").hasClass('on')){
			$("#btnreset").addClass('on');
		}
		//if($("#btnprint").hasClass('on')){
		//	$("#btnprint").removeClass('on');
		//}
		$("#remarks").removeAttr("readonly");
		//$("#discount").removeAttr("readonly");
		$("#checkTime").removeAttr("disabled");
		//$("#pszdsel").removeAttr("disabled");
		$("#stksel").removeAttr("disabled");
		//$("#ordersel").removeAttr("disabled");
		//$("#csttel").removeAttr("readonly");
		//$("#cstaddress").removeAttr("readonly");
		
		var qtyedits =  document.getElementsByName("edtqty");
		for(var i = 0;i<qtyedits.length;i++)
		{
		$(qtyedits[i]).removeAttr("readonly");
		}
		//$("#billstatus").val("未发货");
	}
	if(btnstatus == 2)//编辑
	{
		if($("#btnnew").hasClass('on')){
			$("#btnnew").removeClass('on');
		}
		
		if(!$("#btnsave").hasClass('on')){
			$("#btnsave").addClass('on');
		}
		if(!$("#btnreset").hasClass('on')){
			$("#btnreset").addClass('on');
		}
		
		$("#remarks").removeAttr("readonly");
		//$("#discount").removeAttr("readonly");
		$("#checkTime").removeAttr("disabled");
		//$("#pszdsel").removeAttr("disabled");
		$("#stksel").removeAttr("disabled");
		//$("#ordersel").removeAttr("disabled");
		//$("#csttel").removeAttr("readonly");
		//$("#cstaddress").removeAttr("readonly");
		
		var qtyedits =  document.getElementsByName("edtqty");
		for(var i = 0;i<qtyedits.length;i++)
		{
		$(qtyedits[i]).removeAttr("readonly");
		}
	}
	if(btnstatus == 0)
	{
		if(!$("#btnnew").hasClass('on')){
			$("#btnnew").addClass('on');
		}
		
		
		if($("#btnsave").hasClass('on')){
			$("#btnsave").removeClass('on');
		}
		if($("#btnreset").hasClass('on')){
			$("#btnreset").removeClass('on');
		}
		
		$("#remarks").attr("readonly","readonly");
		//$("#discount").attr("readonly","readonly");
		$("#checkTime").attr("disabled",true);
		//$("#pszdsel").attr("disabled","disabled");
		$("#stksel").attr("disabled","disabled");
		//$("#ordersel").attr("disabled","disabled");
		//$("#csttel").attr("readonly","readonly");
		//$("#cstaddress").attr("readonly","readonly");
		
		var qtyedits =  document.getElementsByName("edtqty");
		for(var i = 0;i<qtyedits.length;i++)
		{
		$(qtyedits[i]).attr("readonly","readonly");
		}
	}
	
}

function queryCheckWare()
{
	var path = "queryCheckWare";
	//var token = $("#tmptoken").val();
	//alert(token);
	alert(11);
	stkId = $("#stkId").val();
	if(stkId == "")stkId = 0;
	$.ajax({
        url: path,
        type: "POST",
        data : {"stkId":stkId},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.list.length;
        		$("#chooselist").text("");
        		gwareList = json.list;
        		for(var i = 0;i < size; i++)
        			{
        				
        			$("#more_list tbody").append(
        					'<tr>'+
        						'<td style="padding-left: 20px;text-align: left;"><img src="'+basePath +'/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>'+
        						'<input type="hidden" name="wareId" value = "' + json.list[i].wareId + '"/>' + json.list[i].wareCode + '</td>'+
        						'<td>'+ json.list[i].wareNm + '</td>'+
        						
        						'<td>' + json.list[i].wareDw + '</td>'+
        						'<td><input name="edtStkQty" type="text" class="pcl_i2" value="' + json.list[i].stkQty + '"</td>'+
        						'<td><input name="realQty" type="text" class="pcl_i2" value="' + json.list[i].stkQty + '" onchange="countQty()"/></td>'+
        						'<td>0</td>'+
        						'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
        						
        					'</tr>'
        				);
        			}
        		
				
        		
        	}
        }
    });
}


function deleteChoose(lineObj)
{
	if(confirm('确定删除？')){
		//alert(lineObj.innerHTML);
		$(lineObj).parents('tr').remove();
		countAmt();
	}
}

function countQty(){
	var total = 0;
	
	
	var trList = $("#chooselist").children("tr");
	
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    
	    var qty = tdArr.eq(3).find("input").val();
	   
	    var qty1 = tdArr.eq(4).find("input").val();
	   
	   
	    tdArr.eq(5).text(qty1 - qty);
	    if(wareId == 0)continue;
	}
	
	
	
}


function submitStk(){
	if(editstatus == 0)
		{
			alert("请先新建或编辑");
			return;
		}
	
	
	var stkId = $("#stkId").val();	
	
	var remarks = $("#remarks").val();
	
	var checkTime = $("#checkDate").val();
	
	var staff = $("#staff").text();
	var billId = 0;
	//alert(outTime);
	
	var wareList = new Array();
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    
	    //alert(xsTp);
	    var qty = tdArr.eq(4).find("input").val();
	    
	    if(qty == "")break;
	    if(wareId == 0)continue;
	    var subObj = {
				wareId: wareId,				
				qty: qty
								
		};
	    wareList.push(subObj);
	    
	    
	}
	
	if(wareList.length == 0)
		{
			alert("请选择商品");
			return;
		}
	if(stkId == 0)
		{
			alert("请选择仓库");
			return;
		}
	
	
	var path = "addStkCheck";
	var token = $("#tmptoken").val();
	//alert(JSON.stringify(wareList));
	if(!confirm('保存后将不能修改，是否确定保存？'))return;
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"id":billId,"staff":staff,"stkId":stkId,"remarks":remarks,"checkTimeStr":checkTime,"wareStr":JSON.stringify(wareList)},
        dataType: 'json',
        async : false,
        success: function (json) {
        	
        	if(json.state){
        		$("#billId").val(json.id);
        		alert("提交成功");
        		statuschg(0);
        		//window.location.href='stkoutQuery?token=' + token;
        	}
        	else
			{
				alert(json.msg);
			}
        }
    });
	
}

