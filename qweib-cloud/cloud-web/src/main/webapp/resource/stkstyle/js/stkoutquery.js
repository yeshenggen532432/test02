$(function(){
	//querystorage();
	//queryWare();
	
	//querycustomer('');
	
	
	//queryDict();
	queryData();
	/*
	 * 表单收起按钮
	 * */
	
	/*
	 * 通用点击选择选项按钮
	 * */
	function lib_had(btn,box){
		btn.on('click',function(){
			box.fadeIn(200);
		});
		box.find('.mask').on('click',function(){
			box.fadeOut(200);
		});
		box.find('li').on('click',function(){
			var t = $(this).text();
			btn.text(t);
			queryData();
			box.fadeOut(200);
		});
	}
	
	function lib_hadstk(btn,box){
		btn.on('click',function(){
			box.fadeIn(200);
		});
		box.find('.mask').on('click',function(){
			box.fadeOut(200);
		});
		box.find('li').on('click',function(){
			var t = $(this).text();
			btn.text(t);
			//var stkId = $(this).find("input[name='stkId']").val();
			queryData();
			box.fadeOut(200);
		});
	}
	/*
	 *  销售类型 选择方式
	 *
	 * */
	
	/*
	 * 有二级菜单的浮层
	 * */
	
	
	
	/*
	 
	 * 供应商选择
	 * 
	 * */
	
	
	//lib_had2($(".lib_chose_sale"),$("#lib_chose_sale_had")); // 出库-销售类型-按钮绑定
	
	lib_hadstk($("#warehouse"),$("#warehouse_bhad")); // 出库-销售类型-按钮绑定
	lib_had($("#choosestatus"),$("#bill_status")); // 出库-销售类型-按钮绑定
	//lib_had($("#lib_supplier"),$("#lib_supplier_had")); //供应商选择
	
	//has_sub_had($(".beer"),$("#beer_box"));// 选择啤酒类型
	
});
function queryDict(){
	var path = "querystkdict";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"ioType":1},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.rows.length;
        		var text = "<ul>";
        		for(var i = 0;i < size; i++)
        			{
        				text += "<li>" + json.rows[i].typeName;
        				
        				text +="</li>";
        			}
				
        		text += "</ul>";
        		$("#stkdict").html(text);
        		
        	}
        }
    });
}




function querycustomer(filter){
	
	var path = "stkprovider";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":1,"rows":30,"dataTp":"1","khNm":filter},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.rows.length;
        		var text = "<ul>";
        		for(var i = 0;i < size; i++)
        			{
        				text += "<li>" ;
        					text += "	<input  type=\"hidden\" name=\"proId\" value=\"" + json.rows[i].id + "\"/>";  
        				text += "<div class=\"pl_wrap\">";
						text += "<div class=\"pl_box\"><img src=\"" + basePath + "/resource/stkstyle/img/icon8.png\" class=\"list_icon\"/></div>";
						text += "<div class=\"pl_box\">";
						text += "<p class=\"top_title\">" + json.rows[i].proName + "</p>";
						
						text += "<p class=\"pl_mes1\"><img src=\"" + basePath + "/resource/stkstyle/img/icon9.png\"/><i class=\"p1\">" + json.rows[i].tel + "</i></p>";
						text += "<p class=\"pl_mes1\"><img src=\"" + basePath + "/resource/stkstyle/img/icon10.png\"/><i class=\"p2\">" + json.rows[i].address + "</i></p>";
						text += "</div>";
						text += "</div>";
				
						text += "<div class=\"bottom_mes\"></div>";
        				text +="</li>";
        			}
				
        		text += "</ul>";
        		$("#customerList").html(text);
        	}
        }
    });
}



function queryData(){
	
	var startDate = $("#demo1").val();
	var endDate = $("#demo2").val();
	
	var status = $("#choosestatus").text();
	
	var inType = $("#warehouse").text();
	var searchKey = $("#searchKey").val();
	var path = "stkoutQueryDo";
	var token = $("#tmptoken").val();
	var billStatus = -1;
	if(status == "未发货")billStatus = 0;
	if(status == "已发货")billStatus = 1;
	if(status == "作废")billStatus = 2;
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"khNm":searchKey,"sdate":startDate,"edate":endDate,"outType":inType,"status":billStatus},
        dataType: 'json',
        async : false,
        success: function (json) {
        	
        	if(json.state){
        		
        		var size = json.rows.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        				text = text + "<tr onmousedown = \"tronmousedown1(this)\" onclick=\"chooseBill(" + json.rows[i].id + ")\">";
        				text += "<td><input type=\"checkbox\" class=\"sc_check\" name=\"chooseline\" value=\""  + json.rows[i].id + "\" /><input  type=\"hidden\" name=\"lineid\" value=\"" +json.rows[i].id +  "\"/>" + json.rows[i].billNo + "</td>";
        				text += "<td>" +json.rows[i].outDate + "</td>";
						text += "<td>" + json.rows[i].khNm + "</td>";
						text += "<td>" + json.rows[i].outType + "</td>";
						
						text += "<td>" + json.rows[i].staff + "</td>";					
						
							
						
						text += "<td>" + json.rows[i].billStatus + "</td>";
        				text = text + "</tr>";
        			}
        		if(size>0)
        		$("#dataList").html(text);
        		else
        		{
        			text = "<tr>";
							text += "<td><input type=\"checkbox\" class=\"sc_check\"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
							text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
							text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
							text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
							text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
							text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
						text += "</tr>";
						$("#dataList").html(text);
        		}
        		
        		$("#totalqty").html(json.total);
        		$("#totalamt").html(json.sumAmt);
        		
        	}
        }
    });
	
	
}

function auditProc()
{
	var operateBox = document.getElementsByName("chooseline");
    var operateBoxs = new Array();
    var keys = "";
    var j = 0;
    for(var i=0;i<operateBox.length;i++){
       if(operateBox[i].checked){
          operateBoxs[j] = operateBox[i].value;
          keys += operateBox[i].value;
          if(i < operateBox.length - 1){
             keys += ",";
          }               
          j++;
       }          
    }
    if(operateBoxs == null || operateBoxs.length == 0){
        alert("请选择您要审核的记录");
        return;
    }
    
    var token = $("#tmptoken").val();
    window.location.href='stkoutQuery?token=' + token ;
    
    
}

function cancelProc()
{
	var operateBox = document.getElementsByName("chooseline");
    var operateBoxs = new Array();
    var keys = "";
    var j = 0;
    for(var i=0;i<operateBox.length;i++){
       if(operateBox[i].checked){
          operateBoxs[j] = operateBox[i].value;
          keys += operateBox[i].value;
          if(i < operateBox.length - 1){
             keys += ",";
          }               
          j++;
       }          
    }
    if(operateBoxs == null || operateBoxs.length == 0){
        alert("请选择您要作废的记录");
        return;
    }
    if(operateBoxs.length > 1)
    	{
    		alert("只能选择一条单据");
    		return;
    	}
   
	var token = $("#tmptoken").val();
	var path = "cancelStkOut";
	if (confirm('是否确定作废？')) 
		{
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"billId":operateBoxs[0]},
        dataType: 'json',
        async : false,
        success: function (json) {
        	
        	if(json.state){
        		
        		alert("作废成功");
        		
        	}
        	else
        	{
        		alert("作废失败" + json.msg);
        	}
        	
        }
    });
		}
	
	window.location.href='stkoutQuery?token=' + token;
}

function test()
{
	var path = "testadd";
    var token = $("#tmptoken").val();
    $.ajax({
        url: path,
        type: "POST",
        data : {"token":token},
        dataType: 'json',
        async : false,
        success: function (json) {
        	
        	if(json.state){
        		
        		alert("审核成功");
        		
        	}
        	else
        	{
        		alert("审核失败");
        	}
        	
        }
    });
    
}

function switchToPay()
{
	var operateBox = document.getElementsByName("chooseline");
    var operateBoxs = new Array();
    var keys = "";
    var j = 0;
    for(var i=0;i<operateBox.length;i++){
       if(operateBox[i].checked){
          operateBoxs[j] = operateBox[i].value;
          keys = operateBox[i].value;
                       
          j++;
       }          
    }
    if(operateBoxs == null || operateBoxs.length == 0){
        alert("请选择您要付款的记录");
        return;
    }
    if(j> 1)
    {
    	alert("只能选择一张单据");
        return;
    }
    //alert(keys);
    
    var token = $("#tmptoken").val();
    window.location.href='stkRec?token=' + token + '&billId=' + keys;
}

function newBill()
{
	var token = $("#tmptoken").val();
    window.location.href='stkout?token=' + token + '&orderId=0&lastPage=历史发票';
}

function newOtherBill()
{
	var token = $("#tmptoken").val();
    window.location.href='otherout?token=' + token + '&orderId=0&lastPage=历史发票';
}

function showBillInfo()
{
	var operateBox = document.getElementsByName("chooseline");
    var operateBoxs = new Array();
    var keys = "";
    var j = 0;
    for(var i=0;i<operateBox.length;i++){
       if(operateBox[i].checked){
          operateBoxs[j] = operateBox[i].value;
          keys = operateBox[i].value;
                       
          j++;
       }          
    }
    if(operateBoxs == null || operateBoxs.length == 0){
        alert("请选择您要查看的记录");
        return;
    }
    if(j> 1)
    {
    	alert("只能选择一张单据");
        return;
    }
    
    
    var token = $("#tmptoken").val();
    window.location.href='stkoutEdit?token=' + token + '&billId=' + keys;
}

function chooseBill(billId)
{
	var operateBox = document.getElementsByName("chooseline");
	for(var i=0;i<operateBox.length;i++){
		if(operateBox[i].value== billId)operateBox[i].checked = true;
		else operateBox[i].checked = false;
	          
	    }
	//var token = $("#tmptoken").val();
    //window.location.href='stkoutEdit?token=' + token + '&billId=' + billId;
}

function freePay()
{
	var operateBox = document.getElementsByName("chooseline");
    var operateBoxs = new Array();
    var keys = "";
    var j = 0;
    for(var i=0;i<operateBox.length;i++){
       if(operateBox[i].checked){
          operateBoxs[j] = operateBox[i].value;
          keys = operateBox[i].value;
                       
          j++;
       }          
    }
    if(operateBoxs == null || operateBoxs.length == 0){
        alert("请选择您要付款的记录");
        return;
    }
    if(j> 1)
    {
    	alert("只能选择一张单据");
        return;
    }
	var path = "getStkOutNeedRec";
    var token = $("#tmptoken").val();
    $.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"billId":keys[0]},
        dataType: 'json',
        async : false,
        success: function (json) {
        	
        	if(json.state){
        		if(json.needRec<= 0)
        			{
        				alert("该单据已经结清");
        				return;
        			}
        		var msg = "核销金额" + json.needRec + ",是否确定枋销?";
        		if(!confirm(msg))return;
        		sureFreePay(keys[0]);
        		
        	}
        	else
        	{
        		alert(json.msg);
        	}
        	
        }
    });
    
}

function sureFreePay(billId)
{
	
	var path = "updateOutFreeAmt";
    var token = $("#tmptoken").val();
    $.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"billId":billId},
        dataType: 'json',
        async : false,
        success: function (json) {
        	
        	if(json.state){
        		alert("核销成功");
        		queryData();
        		
        	}
        	else
        	{
        		alert("审核失败");
        	}
        	
        }
    });
}

function tronmousedown1(obj){  
	var trs = document.getElementById('dataList').getElementsByTagName('tr');  
    for( var o=0; o<trs.length; o++ ){  
     if( trs[o] == obj ){  
      trs[o].style.backgroundColor = '#DFEBF2';  
     }  
     else{  
      trs[o].style.backgroundColor = '';  
     }  
    }  
   }  
