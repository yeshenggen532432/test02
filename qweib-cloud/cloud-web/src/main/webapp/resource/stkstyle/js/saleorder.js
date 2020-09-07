var editstatus = 0;
var gstklist;
var isEp=0;//是否选择直供转单二批 0:否 1:是
$(function(){
	
	querydepart();
	//初始化按钮
	var billId = $("#id").val();
	if(billId == 0)
		{
		
		 $("#pszd").val("公司直送");
		 $("#pszdspan").text("公司直送");
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
			$("#outDate").val(dateStr);
		}
	
	//displayXsTpSel();
	
	/*
	 * 表单收起按钮
	 * */
//	$('#wareInput').bind('keypress', function (event) {
//        if (event.keyCode == "13") {
//            //需要处理的事情
//        	var tb = document.getElementById("warelist");
//        	var line = tb.getElementsByTagName("tr")[0];  
//        	waredbclick(line);
//        		
//        }
//       
//    });
	$(".ft_icon").on('touchend',function(){
		if($(this).hasClass('show')){
			$(".ftb_hd").hide();
			$(this).removeClass('show');
		}else{
			$(".ftb_hd").show();
			$(this).addClass('show');
		}
	});
	$("#pc_lib").on('click',function(){
		querycustomer();
		$("#customerForm").show();
	});
	/*
	$("#epCustomerName").on('click',function(){
		isEp=1;
		if(editstatus == 0)return;
		querycustomer();
		$("#customerForm").show();
	});
	*/
	$("#memberNm").on('click',function(){
		$("#memberForm").show();
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
	
	$(".pcl_infinite p").on('click',function(){
		if($(this).hasClass('open')){
			$(this).siblings('.pcl_file').slideUp(200);
			$(this).removeClass('open');
		}else{
			$(this).siblings('.pcl_file').slideDown(200);
			$(this).addClass('open');
		}
	});
	
	$(".pcl_del").on('click',function(){
		if(confirm('确定删除？')){
			$(this).parents('tr').remove();
		}
	});
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
			box.fadeOut(200);
		});
	}
	/*
	 *  销售类型 选择方式
	 *
	 * */
	var v=0,o;
	function lib_had2(btn,box){
		var this_eq;
		btn.on('click',function(){
			if(!$(this).attr('data-id')){
				$(this).attr('data-id',v);
				this_eq=v;
				v++;
			}
			box.fadeIn(200);
			o=$(this).attr('data-id');
		});
		box.find('.mask').on('click',function(){
			box.fadeOut(200);
		});
		box.find('li').on('click',function(){
			var t = $(this).text();
			$(".lib_chose_sale[data-id="+o+"]").text(t);
			box.fadeOut(200);
		});
	}
	/*
	 * 有二级菜单的浮层
	 * */
	var flag = 1,
		didnum = Number(0);
	function has_sub_had(btn,box){
		// 点击出现浮层按钮
		btn.on('click',function(){
			box.fadeIn(200);
		});
		// 半透明层关闭浮层
		box.find('.mask').on('click',function(){
			box.fadeOut(200);
			if(!$("#more_list .beer").length){
				
				$("#more_list tbody").append(
					'<tr class="initial_rest">'+
						'<td><a href="javascript:;" class="delete_beer">删除</a></td>'+
						'<td><a href="javascript:;" class="beer">点击选择</a></td>'+
						'<td><a href="javascript:;" class="lib_chose_sale">点击选择</a></td>'+
						'<td><input type="number" class="bli"/></td>'+
						'<td><input type="text" class="bli"/></td>'+
						'<td><input type="number" class="bli"/></td>'+ 
					'</tr>'
				);
			}
			$(".beer").on('click',function(){
				$("#beer_box").fadeIn(200);
			});
			lib_had2($(".lib_chose_sale"),$("#lib_chose_sale_had")); // 出库-销售类型-按钮绑定
		});
		// 二级菜单栏点开
		box.find('li').on('click',function(){
			
			if(!$(this).hasClass('on')){
				box.find('li').removeClass('on');
				box.find('.sub_menu').slideUp(200)
				$(this).addClass('on');
				$(this).find('.sub_menu').slideDown(200);
			}
			
		});
		
		$(".sub_2").on('click',function(){
			if(!$(this).hasClass('act')){
				$(".sub_2").removeClass('act');
				$(".sub_m2").slideUp();
				$(this).addClass('act');
				$(this).find('.sub_m2').slideDown(200);
			}
		});
		
		box.find('td').on('click',function(){
			
			var t = $(this).find('span').text();
			
			var bl = $("#more_list .beer").length; // 获取已选中条数
			
			var did = $(this).attr('data-id'); // 选择按钮的data-id 如果不存在 则添加
			console.log(did);
			if(!did){
				didnum++;
				$(this).attr('data-id',didnum);
			}
			
			$(".initial_rest").remove();
			
			if($(this).hasClass('on')){
				
				var didn2 = $(this).attr('data-id');
				$("#more_list tr").each(function(){
					if($(this).attr('data-id') == didn2){
						$(this).remove();
					}
				});
				
			}else{
				var dididid = $(this).attr('data-id');
				$("#more_list tbody").append(
					'<tr data-id="'+dididid+'">'+
						'<td><a href="javascript:;" class="delete_beer">删除</a></td>'+
						'<td><a href="javascript:;" class="beer">'+t+'</a></td>'+
						'<td><a href="javascript:;" class="lib_chose_sale">点击选择</a></td>'+
						'<td><input type="number" class="bli"/></td>'+
						'<td><input type="text" class="bli"/></td>'+
						'<td><input type="number" class="bli"/></td>'+ 
					'</tr>'
				);
			}
			if($(this).hasClass('on')){
				$(this).removeClass('on');
				$(this).find('.check').removeClass('checked');
			}else{
				$(this).addClass('on');
				$(this).find('.check').addClass('checked');
			}
		});
	}
	
	function supplier(){
		$("#lib_supplier").on('click',function(){
			$(".chose_people").fadeIn(200);
		});
		$(".people_list li").on('click',function(){
			var p1=$(this).find('.p1').text(),p2=$(this).find('.p2').text();
			
			$("#lib_supplier").html(p1+'&nbsp;&nbsp;&nbsp;'+p2);
//			console.log(123);
			$(".chose_people").fadeOut(200);
		});
	}
	supplier();
	lib_had2($(".lib_chose_sale"),$("#lib_chose_sale_had")); // 出库-销售类型-按钮绑定
	
	lib_had($("#warehouse"),$("#warehouse_bhad")); // 出库-销售类型-按钮绑定
	lib_had($("#order"),$("#order_had")); // 出库-销售类型-按钮绑定
	//lib_had($("#lib_supplier"),$("#lib_supplier_had")); //供应商选择
	
	has_sub_had($(".beer"),$("#beer_box"));// 选择啤酒类型
	
});

function searchCustomer()
{
	var filter = $("#searchcst").val();
	
	querycustomer(filter);

}
var customerPage = 1;
function querycustomer(filter){
	customerPage = 1;
	var path = "stkchoosecustomer";
	var ep='';
	if(isEp==1){
		ep = isEp;
	}
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":1,"rows":50,"dataTp":"1","khNm":filter,"isEp":ep},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.rows.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        				text += "<tr ondblclick=\"customerclick(this)\">" ;
        					text += "<td><span id=\"pc_lib_name\">" + json.rows[i].khNm + "</span><input  type=\"hidden\" name=\"cstId\" value=\"" + json.rows[i].id + "\"/></td>	";  
        				
						text += "<td><span id=\"pc_lib_mes\">" + json.rows[i].mobile + "</span></td>";
						text += "<td><span id=\"pc_address\">" + json.rows[i].address+ "</span></td>";
						text += "<td><span id=\"pc_khNm\">" + json.rows[i].linkman+ "</span></td>";
						text += "<td>" + json.rows[i].branchName +"</td>";
						text += "<td><span class=\"bule_col\">" + json.rows[i].shZt + "</span></td>";
						text += "<td style='display:none'><span id='saleId'>" + json.rows[i].memId + "</span><span id='saleNm'>" + json.rows[i].memberNm + "</span></td>";  			
        				text += "</tr>";
						
        			}
        		customerPage++;
        		$("#customerlist").html(text);
        	}
        }
    });
}
function querycustomerPage(){
	var filter = $("#searchcst").val();
	var path = "stkchoosecustomer";
	var ep='';
	if(isEp==1){
		ep = isEp;
	}
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":customerPage,"rows":50,"dataTp":"1","khNm":filter,"isEp":ep},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		var size = json.rows.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        				text += "<tr ondblclick=\"customerclick(this)\">" ;
        				text += "<td><span id=\"pc_lib_name\">" + json.rows[i].khNm + "</span><input  type=\"hidden\" name=\"cstId\" value=\"" + json.rows[i].id + "\"/></td>	";  
						text += "<td><span id=\"pc_lib_mes\">" + json.rows[i].mobile + "</span></td>";
						text += "<td><span id=\"pc_address\">" + json.rows[i].address+ "</span></td>";
						text += "<td><span id=\"pc_khNm\">" + json.rows[i].linkman+ "</span></td>";
						text += "<td>" + json.rows[i].branchName +"</td>";
						text += "<td><span class=\"bule_col\">" + json.rows[i].shZt + "</span></td>";
						text += "<td style='display:none'><span id='saleId'>" + json.rows[i].memId + "</span><span id='saleNm'>" + json.rows[i].memberNm + "</span></td>";       				
        				text += "</tr>";
        			}
        		customerPage++;
        		//$("#customerlist").html(text);
        		$("#customerlist").append(text);
        	}
        }
    });
}

function customerclick(trobj)
{
	var cstId = $(trobj.cells[0]).find("input[name='cstId']").val();
	var cstNm = $(trobj.cells[0]).find("span").text();
	/*
	if(isEp==1){
		$("#epCustomerId").val(cstId);
		$("#epCustomerName").val(shr);
		$(".pcl_chose_people").hide();
		return;
	}*/
	var shr =  $(trobj.cells[3]).find("#pc_khNm").text();
	var tel = $(trobj.cells[1]).find("#pc_lib_mes").text();
	var address = $(trobj.cells[2]).find("#pc_address").text();
	//var gyn = $(this).find('#pc_lib_name').text(),n = $(this).find('#pc_lib_mes').text();
	//var address = $(this).find('#pc_address').text();
	//var cstId = $(this).find("input[name='cstId']").val();
	
	$("#cid").val(cstId);
	$("#pc_lib").html(cstNm);//客户名称
	$("#shr").val(shr);//收货人
	$("#tel").val(tel);//客户电话
	$("#address").val(address);//客户地址
	var saleId = $(trobj.cells[6]).find("#saleId").text();
	getMemberInfo(saleId);
	$(".pcl_chose_people").hide();
	//queryOrder();
}


function queryWareType(customerId)
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
					text+= "					<td onclick=\"javascript:queryWareByType();\">全部商品</td>";
										
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
				
        		
        		$(".pcl_menu_m p").on('click',function(){
        			if($(this).hasClass('open')){
        				$(this).siblings('.pcl_sub_menu').slideUp(200);
        				$(this).removeClass('open');
        			}else{
        				$(this).siblings('.pcl_sub_menu').slideDown(200);
        				$(this).addClass('open');
        			}
        		});
        	}
        }
    });
}

function queryWareByType(wareType)
{
	var cstId = $("#cstId").val();
	 if(cstId==""){
		 alert("请先选择客户!");
		 return;
	 }
	var path = "queryStkWare";
	//var token = $("#tmptoken").val();
	//alert(token);
	stkId = $("#stkId").val();
	if(stkId == "")stkId = 0;
	$.ajax({
        url: path,
        type: "POST",
        data : {"wareType":wareType,"stkId":stkId,"status":1,"customerId":cstId},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		var size = json.list.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        			text += '<tr ondblclick="waredbclick(this)">';
        			text += '<td><input type="checkbox" name="chkbox"/></td>';
        			text += '<td style="padding-left: 20px;text-align: left;"><input type="hidden" name="wareId" value = "' +json.list[i].wareId+ '"/>' + json.list[i].wareCode + '</td>';
        			text += '<td><input type="hidden" name="wareUnit" value = "' + json.list[i].wareDw + '"/>' + json.list[i].wareNm + '</td>';
        			text += '<td><input type="hidden" name="wareGg" value = "' + json.list[i].wareGg + '"/>' + json.list[i].wareDj + '</td>';
        			text += '<td>' + json.list[i].stkQty + '';
        			text += '<input type="hidden" name="maxUnit" value = "' + json.list[i].wareDw + '"/>';
        			text += '<input type="hidden" name="maxUnitCode" value = "' + json.list[i].maxUnitCode + '"/>';
        			text += '<input type="hidden" name="minUnit" value = "' + json.list[i].minUnit + '"/>';
        			text += '<input type="hidden" name="minUnitCode" value = "' + json.list[i].minUnitCode + '"/>';
        			text += '<input type="hidden" name="hsNum" value = "' + json.list[i].hsNum + '"/></td>';
        			text += '</tr>';
        			}
        		$("#warelist").html(text);
				
        		
        	}
        }
    });
}

function queryWareByKeyWord(keyWord)
{
	if(event.keyCode !=13&&event.button!=0){
		return;
	}
	var cstId = $("#cstId").val();
	 if(cstId==""){
		 alert("请先选择客户!");
		 return;
	 }
	
	var path = "queryStkWarePage1";
	//var token = $("#tmptoken").val();
	//alert(token);
	stkId = $("#stkId").val();
	if(stkId == "")stkId = 0;
	$.ajax({
        url: path,
        type: "POST",
        data : {"keyWord":keyWord,"stkId":stkId,"status":1,"customerId":cstId,"page":1,"rows":50},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.list.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        			text += '<tr ondblclick="waredbclick(this)">';
        			text += '<td><input type="checkbox" name="chkbox"/></td>';
        			text += '<td style="padding-left: 20px;text-align: left;"><input type="hidden" name="wareId" value = "' +json.list[i].wareId+ '"/>' + json.list[i].wareCode + '</td>';
        			text += '<td><input type="hidden" name="wareUnit" value = "' + json.list[i].wareDw + '"/>' + json.list[i].wareNm + '</td>';
        			text += '<td><input type="hidden" name="wareGg" value = "' + json.list[i].wareGg + '"/>' + json.list[i].wareDj + '</td>';
        			text += '<td>' + json.list[i].stkQty + '';
        			text += '<input type="hidden" name="maxUnit" value = "' + json.list[i].wareDw + '"/>';
        			text += '<input type="hidden" name="maxUnitCode" value = "' + json.list[i].maxUnitCode + '"/>';
        			text += '<input type="hidden" name="minUnit" value = "' + json.list[i].minUnit + '"/>';
        			text += '<input type="hidden" name="minUnitCode" value = "' + json.list[i].minUnitCode + '"/>';
        			text += '<input type="hidden" name="hsNum" value = "' + json.list[i].hsNum + '"/></td>';
        			text += '</tr>';
        			}
        		$("#warelist").html(text);
				
        		
        	}
        }
    });
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
	
	location = 'pcstkout?orderId=0';
	if(editstatus != 0)
	{
	  return;
	}
	statuschg(1);
}
function printClick()
{
	if(editstatus != 0)
		{
		  //alert("请先保存");
		  $.messager.alert('消息','请先保存','info');
		  return;
		}
	var billId = $("#id").val();
	if(billId == 0)
		{
			//alert("没有可打印的单据");
			 $.messager.alert('消息','没有可打印的单据','info');
			return ;
		}
	window.location.href='showorderprint?fromFlag=0&billId=' + billId;
}


function resetClick()
{
	statuschg(0);
}

var rowIndex=1000;
function waredbclick(trobj)
{
	 
	var wareCode = trobj.cells[1].innerText;//childNodes[0].text;
	var wareId = $(trobj.cells[1]).find("input[name='wareId']").val();
	//alert(JSON.stringify(wareId));
	var wareName = trobj.cells[2].innerText;
	var price = trobj.cells[3].innerText;
	var unitName = $(trobj.cells[2]).find("input[name='wareUnit']").val();
	var wareGg = $(trobj.cells[3]).find("input[name='wareGg']").val();
	var maxUnitCode = $(trobj.cells[4]).find("input[name='maxUnitCode']").val();
	var minUnitCode = $(trobj.cells[4]).find("input[name='minUnitCode']").val();
	var minUnit = $(trobj.cells[4]).find("input[name='minUnit']").val();
	var hsNum = $(trobj.cells[4]).find("input[name='hsNum']").val();
	$("#more_list tbody").append(
			'<tr>'+
				'<td style="padding-left: 20px;text-align: left;display:none"><img src="'+basePath +'/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>'+
				'<input type="hidden" id="wareId'+rowIndex+'" name="wareId" value = "' + wareId + '"/>' + wareCode + '</td>'+
				'<td>'+ wareName + '</td>'+
				'<td>'+ wareGg + '</td>'+
				'<td>'+
				'<select name="xstp" class="pcl_sel2" onchange="chooseXsTp(this);">'+
				'<option value="正常销售" checked>正常销售</option>'+
				'<option value="促销折让">促销折让</option>'+
				'<option value="消费折让">消费折让</option>'+
				'<option value="费用折让">费用折让</option>'+
				'<option value="其他销售">其他销售</option>'+
				'</select>'+
				'</td>'+
				'<td>' +  
				'<select id="beUnit'+rowIndex+'" name="beUnit" class="pcl_sel2" onchange="changeUnit(this,'+rowIndex+')">'+
				'<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+
				'<option value="'+minUnitCode+'">'+minUnit+'</option>'+
				'</select>'
				+ '</td>'+
				'<td><input id="edtprice'+rowIndex+'" name="edtprice" type="text" class="pcl_i2" value="' + price + '" onchange="countAmt()"/></td>'+
				'<td><input id="edtqty'+rowIndex+'" name="edtqty" type="text" class="pcl_i2" value="1" onchange="countAmt()"/></td>'+
				'<td>' + price + '</td>'+
				'<td style="display:none"><input id="hsNum'+rowIndex+'" name="hsNum" type="hidden" class="pcl_i2" value="'+hsNum+'"/></td>'+
				'<td style="display:none"><input id="unitName'+rowIndex+'" name="unitName" type="hidden" class="pcl_i2" value="'+unitName+'" /></td>'+
				'<td ><input id="remark'+rowIndex+'" name="remark" type="text" class="pcl_i2" /></td>'+
				'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
				
			'</tr>'
		);
	rowIndex++;
	countAmt();
	/*$(".pcl_del").on('click',function(){
		if(confirm('确定删除？')){
			$(this).parents('tr').remove();
		}
	});*/
        $("#more_list tbody tr").mouseover(function(){  
          var wareId = $(this).find("input[name='wareId']").val()
     	 querySaleCustomerHisWarePrice(wareId);
          $("#tipPrice").show();
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

function countAmt(){
	var total = 0;
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    var qty = tdArr.eq(6).find("input").val();
	    var price = tdArr.eq(5).find("input").val();
	    if(qty == "")break;
	    total = total + qty*price;
	    tdArr.eq(7).text(numeral(qty*price).format("0.00"));
	    if(wareId == 0)continue;
	}
	$("#zje").val(numeral(total).format("0.00"));
	var zdzk = $("#zdzk").val();
	var cjje = total - zdzk;
	$("#cjje").val(numeral(cjje).format("0.00"));
	
}

function displayXsTpSel()
{
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    var xsTp = tdArr.eq(3).find("input").val();
	     tdArr.eq(3).find(".pcl_sel2").val(xsTp);//.val();//.options;//.val();
	    var qty = tdArr.eq(6).find("input").val();
	    if(qty == "")break;
	    if(wareId == 0)continue;
	}
}

function chooseXsTp(sel)
{
	var trobj = sel.parentNode.parentNode;
	if(sel.value != "正常销售")
	$(trobj.cells[5]).find("input").val("0");
	else
	{
		
	}
	countAmt();
}

function submitStk(){
	var cid = $("#cid").val();//客户ID
	var billId = $("#id").val();
	var khNm = $("#pc_lib").text();//客户名称
	var tel = $("#tel").val();//联系电话
	var address = $("#address").val();//客户地址
	var remo = $("#remo").val();//备注
	var shTime = $("#shTime").val();//送货时间
	var shr = $("#shr").val();//收货人
	var mid = $("#mid").val();//业务员ID
	var orderZt = $("#orderZt").val();
	var oddate = $("#oddate").val();
	var odtime = $("#odtime").val();
	if(mid == "")
		{
			alert("请选择业务员");
			return;
		}
	if(orderZt=="审核"){
		alert("该订单已审核");
		return;
	}
	var zdzk = $("#zdzk").val();//折扣金额
	var zje = $("#zje").val();//总金额
	var cjje = $("#cjje").val();//成交金额
	var pszd = $("#pszd").val();//配送指定
	var stkId = $("#stkId").val();
	var proType= $("#proType").val();
	var orderTp= $("#orderTp").val();
	var orderLb= $("#orderLb").val();
	var shopMemberId= $("#shopMemberId").val();
	var shopMemberName= $("#shopMemberName").val();
	var status= $("#status").val();
	var isPay= $("#isPay").val();
	var payType= $("#payType").val();
	if(payType &&payType!='0'&&payType!='1'){
		alert("该订单已提交支付系统不可修改");
		return;
	}
	if(orderTp == null || orderTp == undefined || orderTp ==""){
		orderTp = "销售订单";
	}
	if(orderLb == null || orderLb == undefined || orderLb ==""){
		orderLb = "电话单";
	}
	var isSend= $("#isSend").val();
	var isFinish= $("#isFinish").val();
	var payTime= $("#payTime").val();
	var transportName= $("#transportName").val();
	var finishTime= $("#finishTime").val();
	var cancelTime= $("#cancelTime").val();
	var cancelRemo= $("#cancelRemo").val();
	var transportCode= $("#transportCode").val();
	var freight= $("#freight").val();
	var orderAmount= $("#orderAmount").val();
	var couponCost= $("#couponCost").val();
	var promotionCost= $("#promotionCost").val();


	var wareList = new Array();
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    var wareGg = tdArr.eq(2).html();
	    var xsTp = tdArr.eq(3).find("select").val();
	    var qty = tdArr.eq(6).find("input").val();
	    var beUnit = tdArr.eq(4).find("select").val();
	    var price = tdArr.eq(5).find("input").val();
	    var hsNum = tdArr.eq(8).find("input").val();
	    var remark = tdArr.eq(10).find("input").val();
	    var unit = tdArr.eq(4).find("option:selected").text();
	    var wareZj = tdArr.eq(7).html();

		var detailWareNm=$("[name=detailWareNm]",trList).val();
		var detailWareGg=$("[name=detailWareGg]",trList).val();
		var detailShopWareAlias=$("[name=detailShopWareAlias]",trList).val();
		var detailWareDesc=$("[name=detailWareDesc]",trList).val();
		var wareDjFinal=$("[name=wareDjFinal]",trList).val();
		var detailPromotionCost=$("[name=detailPromotionCost]",trList).val();
		var detailCouponCost=$("[name=detailCouponCost]",trList).val();

		if(beUnit==""){
	    	alert("请选择单位！");
	    	return;
	    }
	    if(qty == "")break;
	    if(wareId == 0)continue;
	    var subObj = {
				wareId:wareId,
				xsTp:xsTp,
				wareGg:wareGg,
				wareNum:qty,
				wareDw:unit,
				wareDj:price,
				hsNum:hsNum,
				wareZj:wareZj,
				beUnit:beUnit,
				remark:remark,

			detailWareNm:detailWareNm,
			detailWareGg:detailWareGg,
			detailShopWareAlias:detailShopWareAlias,
			detailWareDesc:detailWareDesc,
			wareDjFinal:wareDjFinal,
			detailPromotionCost:detailPromotionCost,
			detailCouponCost:detailCouponCost
		};
	    wareList.push(subObj);
	}
	if(wareList.length == 0)
		{
			alert("请选择商品");
			return;
		}
	if(cid == 0)
		{
		  alert("请选择客户");
		  return;
		}
	
	var path = "saveSaleorder";
	//alert(JSON.stringify(wareList));
	if(!confirm('保存后将不能修改，是否确定保存？'))return;
	
	//Integer cid,String shr,
	//String tel,String address,String remo,Double zje,Double zdzk,Integer mid,Double cjje,String orderTp,String shTime,String pszd,String date
	//var  data1 = "{id:"+billId+",cid:"+cid+",mid:"+mid+",shr:"+shr+",tel:"+tel+",address:"+address+",zdzk:"+zdzk+",remo:"+remo+",shTime:"+shTime+",orderTp:销售订单,zje:"+zje+",cjje:"+cjje+",pszd:"+pszd+",orderLb:电话单,orderZt:"+orderZt+",oddate:"+oddate+",odtime:"+odtime+",wareStr:"+JSON.stringify(wareList)+"}";
	//alert(data1);
	$.ajax({
        url: path,
        type: "POST",
        //data : {"stkId":stkId,"id":billId,"cid":cid,"mid":mid,"proType":proType,"shr":shr,"tel":tel,"address":address,"zdzk":zdzk,"remo":remo,"shTime":shTime,"orderTp":"销售订单","zje":zje,"cjje":cjje,"pszd":pszd,"orderLb":"电话单","orderZt":orderZt,"oddate":oddate,"odtime":odtime,"wareStr":JSON.stringify(wareList)},
        data : {"stkId":stkId,"id":billId,"cid":cid,"mid":mid,"proType":proType,"shr":shr,"tel":tel,"address":address,"zdzk":zdzk,"remo":remo,"shTime":shTime,"orderTp":orderTp,"zje":zje,"cjje":cjje,"pszd":pszd,"orderLb":orderLb,"orderZt":orderZt,"oddate":oddate,"odtime":odtime,
            "shopMemberId":shopMemberId,"shopMemberName":shopMemberName,"status":status,"isPay":isPay,"payType":payType,
			"isSend":isSend,"isFinish":isFinish,"payTime":payTime,"transportName":transportName,"cancelRemo":cancelRemo,"transportCode":transportCode,"freight":freight,"orderAmount":orderAmount,"promotionCost":promotionCost,"couponCost":couponCost,
			"wareStr":JSON.stringify(wareList)},
        dataType: 'json',
        async : false,
        success: function (json) {
			alert(json.msg);
        	if(json.state){
        		if(json.id!=undefined&&json.id!=0&&json.id!=""){
        			$("#id").val(json.id);
        		}
        		if(json.status=='审核'){
        			$("#orderZt").val("审核");
        			$("#divOrderStatus").html("审核");
        		}else{
        			$("#divOrderStatus").html("提交成功");
        		}
        		statuschg(0);
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
        	if(json==null){
        		return;
        	}
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

function getMemberInfo(memberId){
	if(memberId==""){
		return;
	}
	var path = "getMemberInfo";
	$.ajax({
        url: path,
        type: "POST",
        data : {"memberId":memberId},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		$("#memberNm").html(json.member.memberNm);
        		$("#mid").val(json.member.memberId);
        	}
        }
    });
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
			text += "<td style='display:none'>" + json.rows[i].memberId + "</td>";
			text += "</tr>";
		}
	
	$("#memberList").html(text);
}

function memberClick(trobj)
{
	var tel = $(trobj.cells[1]).text();
	var memberNm = $(trobj.cells[0]).text();
	var memberId = $(trobj.cells[2]).text();;
	//$("#staff").html(memberNm);
	//$("#stafftel").val(tel);
	$("#memberNm").html(memberNm);
	$("#mid").val(memberId);
	$(".pcl_chose_people").hide();
	//queryOrder();
}

function changeUnit(o,index){
	var hsNum = document.getElementById("hsNum"+index).value;
	var bePrice = document.getElementById("edtprice"+index).value;
	var k= o.selectedIndex;
	bePrice = bePrice==''?0:bePrice;
	hsNum = hsNum==''?1:hsNum;
	var tempAmt = 0;
	if(o.value=='B'){//包装单位
		tempAmt = bePrice*hsNum;
		document.getElementById("edtprice"+index).value=tempAmt.toFixed(2);
		document.getElementById("unitName"+index).value= o.options[k].text;
	}
	if(o.value=='S'){//计量单位
		tempAmt = bePrice/hsNum;
		tempAmt = parseFloat(tempAmt);
		document.getElementById("edtprice"+index).value = tempAmt.toFixed(2);
		document.getElementById("unitName"+index).value=o.options[k].text;
	}
	countAmt(); 
}
function chkbox(obj){
	var chkbox = document.getElementsByName("chkbox");
	for(var i=0;i<chkbox.length;i++){
		chkbox[i].checked=obj.checked;
	}
}

function confirmWareSelect(){
	var chkbox = document.getElementsByName("chkbox");
	for(var i=0;i<chkbox.length;i++){
		if(chkbox[i].checked){
			waredbclick(chkbox[i].parentNode.parentNode);
		}
	}
}

function setWareCustomerHisPrice(wareId,oId)
{
	var path = "queryOrderSaleCustomerHisWarePrice";
	var cstId = $("#cid").val();
	if(cstId==""){
		return;
	} 
	if(wareId==""){
		return;
	}
	$.ajax({
        url: path,
        type: "POST",
        data : {"cid":cstId,"wareId":wareId},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		if(json.hisPrice!=0&&json.hisPrice!=""&&json.hisPrice!=undefined){
        			$("#"+oId).val(json.hisPrice);
        		}
        	}
        }
    });
}
