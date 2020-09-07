$(function(){
	//querystorage();
	//queryWare();
	
	//querycustomer('');
	/*var myDate = new Date();    
	var seperator1 = "-";
    
    var month = myDate.getMonth() + 1;
    var strDate = myDate.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
	var dateStr = myDate.getFullYear() + seperator1 + month + seperator1 + strDate;
	$("#demo1").val(dateStr);
	$("#demo2").val(dateStr);*/
	
	
	/*
	 * 表单收起按钮
	 * */
	
	/*
	 * 通用点击选择选项按钮
	 * */
	
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
        data : {"token":token,"ioType":0},
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
    if(operateBoxs.length > 1)
    	{
    		alert("只能选择一条单据");
    		return;
    	}
	var token = $("#tmptoken").val();
	window.location.href='stkinCheck?token=' + token + '&billId=' + keys[0] + "&opeType=0";
    
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
	if (operateBoxs.length > 0) {
		
			if (confirm('是否确定作废？')) {
				$.ajax( {
					url : "cancelProc",
					data : "billId=" + operateBoxs[0] + "&token=" + token,
					type : "post",
					success : function(json) {
						if (json.state) {
							alert("作废成功");
							
						} else  {
							alert("作废失败" + json.msg);
						}
					}
				});
			};
	} else {
		showMsg("请选择要作废的数据");
	}
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
	var path = "getStkInNeedPay";
    var token = $("#tmptoken").val();
    $.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"billId":keys[0]},
        dataType: 'json',
        async : false,
        success: function (json) {
        	
        	if(json.state){
        		if(json.needPay<= 0)
        			{
        				alert("该单据已经付清");
        				return;
        			}
        		var msg = "核销金额" + json.needPay + ",是否确定枋销?";
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
	
	var path = "updateFreeAmt";
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
    window.location.href='stkPay?token=' + token + '&billId=' + keys;
}

