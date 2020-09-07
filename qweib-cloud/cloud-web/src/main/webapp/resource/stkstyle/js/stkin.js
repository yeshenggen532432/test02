$(function(){
	querystorage();
	queryWareType();
	
	querycustomer('');
	var status =$("#statusindex").val();
	var khNm = $("#lib_supplier").text();
	if(khNm == "")$("#lib_supplier").text("点击选择");
	var billId = $("#billId").val();
	if(billId >0)
	{
		//alert(2222);
		$("#btnsubmit").attr("disabled", true);
		$("#remarks").attr("readonly","readonly");
		$("#discount").attr("readonly","readonly");
		$("#demo1").attr("disabled",true);
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
	$("#demo1").val(dateStr);
		}
	/*
	 * 表单收起按钮
	 * */
	$(".ft_icon").on('touchend',function(){
		if($(this).hasClass('show')){
			$(".ftb_hd").hide();
			$(this).removeClass('show');
		}else{
			$(".ftb_hd").show();
			$(this).addClass('show');
		}
	});
	
	$(".close1").click(function(){
		$(".src_goods").hide();
	});
	
	$(".bs_f p").on('click',function(){
		if($(this).hasClass('open')){
			$(this).siblings('.bs_submenu').slideUp(200);
			$(this).removeClass('open');
		}else{
			$(this).siblings('.bs_submenu').slideDown(200);
			$(this).addClass('open');
		}
	});
	/*
	 * 通用点击选择选项按钮
	 * */
	function lib_had(btn,box){
		btn.on('click',function(){
			var status =$("#status").text();
			if(status != "未审")
			{
				return;
			}
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
	
	function lib_hadstk(btn,box){
		btn.on('click',function(){
			var status =$("#statusindex").val();
			if(status >0)
			{
				
				return;
			}
			box.fadeIn(200);
		});
		box.find('.mask').on('click',function(){
			box.fadeOut(200);
		});
		box.find('li').on('click',function(){
			var t = $(this).text();
			btn.text(t);
			var stkId = $(this).find("input[name='stkId']").val();
			$("#stkId").val(stkId);
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
			var status =$("#status").text();
			if(status != "未审")
			{
				return;
			}
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
			var status =$("#status").text();
			if(status != "未审")
			{
				return;
			}
			box.fadeIn(200);
		});
		// 半透明层关闭浮层
		box.find('.mask').on('click',function(){
			box.fadeOut(200);
			/*if(!$("#more_list .beer").length){
				
				$("#more_list tbody").append(
					'<tr class="initial_rest">'+
						'<td><a href="javascript:;" class="delete_beer">删除</a></td>'+
						'<td><a href="javascript:;" class="beer">点击选择</a></td>'+
						
						'<td><input type="number" class="bli"/></td>'+
						'<td><input type="text" class="bli"/></td>'+
						'<td><input type="number" class="bli"/></td>'+ 
					'</tr>'
				);
			}*/
			/*$(".beer").on('click',function(){
				var status =$("#statusindex").text();
				if(status > 0)
				{
					return;
				}
				
				$("#beer_box").show();
			});*/
			lib_had2($(".lib_chose_sale"),$("#lib_chose_sale_had")); // 出库-销售类型-按钮绑定
			/*$(".delete_beer").on('click',function(){
				var status =$("#status").text();
				if(status != "未审")
				{
					return;
				}
				if(confirm('确定删除？')){
					var this_id = $(this).parents('tr').attr('data-id');
					$(this).parents('tr').remove();
					
					var trList = $("#subList").children("tr");
					if(trList.length == 0)
					{
						$("#more_list tbody").append(
								'<tr class="initial_rest">'+
									'<td><a href="javascript:;" class="delete_beer">删除</a></td>'+
									'<td><a href="javascript:;" class="beer">点击选择</a></td>'+
									
									'<td><input type="number" class="bli"/></td>'+
									'<td><input type="text" class="bli"/></td>'+
									'<td><input type="number" class="bli"/></td>'+ 
								'</tr>'
							);
					}
					countAmt();
					
				}
			})*/
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
		
		
	}
	
	/*
	 
	 * 供应商选择
	 * 
	 * */
	
	function supplier(){
		$("#lib_supplier").on('click',function(){
			$(".chose_people").fadeIn(200);
		});
		$(".people_list li").on('click',function(){
			var cstName = $(this).find('.top_title').text();
			var cstId = $(this).find("input[name='proId']").val();
			var p1=$(this).find('.p1').text(),p2=$(this).find('.p2').text();
			$("#lib_supplier").html(cstName);
			
			$("#proId").val(cstId);
//			console.log(123);
			$(".chose_people").fadeOut(200);
		});
	}
	supplier();
	//lib_had2($(".lib_chose_sale"),$("#lib_chose_sale_had")); // 出库-销售类型-按钮绑定
	
	lib_hadstk($("#warehouse"),$("#warehouse_bhad")); // 出库-销售类型-按钮绑定
	//lib_had($("#order"),$("#order_had")); // 出库-销售类型-按钮绑定
	//lib_had($("#lib_supplier"),$("#lib_supplier_had")); //供应商选择
	
	has_sub_had($(".beer"),$("#beer_box"));// 选择啤酒类型
	
});
function querystorage(){
	var path = "queryBaseStorage";
	var token = $("#tmptoken").val();
	//alert(token);
	var billId = $("#billId").val();
	
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.list.length;
        		var text = "<ul>";
        		for(var i = 0;i < size; i++)
        			{
        				text += "<li>" + json.list[i].stkName;
        				text += "<input  type=\"hidden\" name=\"stkId\"  value=\"" + json.list[i].id + "\"/>";
        				text +="</li>";
        				if(i == 0&& billId == 0)
    					{
        					
    						$("#stkId").val(json.list[i].id);
    						$("#warehouse").text(json.list[i].stkName);
    					}
        			}
				
        		text += "</ul>";
        		$("#basestk").html(text);
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

function countAmt(){
	var total = 0;
	
	var trList = $("#subList").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    
	    var qty = tdArr.eq(1).find("input").val();
	    
	    var price = tdArr.eq(3).find("input").val();
	    total = total + qty*price;
	    if(wareId == 0)continue;
	}
	$("#totalamt").html(total);
	var discount = $("#discount").val();
	var disamt = total - discount;
	$("#disamt").html(disamt);
	
}

function submitStk(){
	var cstId = $("#proId").val();
	var stkId = $("#stkId").val();
	var billId = $("#billId").val();
	var remarks = $("#remarks").val();
	var proName = $("#lib_supplier").text();
	var outTime = $("#demo1").val();
	var discount = $("#discount").val();
	var wareList = new Array();
	if(cstId == 0)
		{
			alert("请选择收货对象");
			return;
		}
	var trList = $("#subList").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    
	    var qty = tdArr.eq(1).find("input").val();
	    var unit = tdArr.eq(2).find("input").val();
	    var price = tdArr.eq(3).find("input").val();
	    if(qty == "")break;
	    if(wareId == 0)continue;
	    var subObj = {
				wareId: wareId,
				qty: qty,
				inQty:qty,
				unitName: unit,
				price: price					
		};
	    wareList.push(subObj);
	    
	    
	}
	if(wareList.length <= 0)
		{
			alert("请填写商品");
			return;
		}
	if (!confirm('保存后将不能修改，是否确定保存？'))return;
	var path = "addStkIn";
	var token = $("#tmptoken").val();
	//alert(outTime);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"id":billId,"proId":cstId,"proName":proName,"proType":0,"stkId":stkId,"remarks":remarks,"inDate":outTime,"inType":"采购入库","discount":discount,"wareStr":JSON.stringify(wareList)},
        dataType: 'json',
        async : false,
        success: function (json) {
        	
        	if(json.state){
        		
        		alert("提交成功");
        		var lastPage = $("#lastPage").val();
        		window.location.href='backpage?token=' + token + '&lastPage=' + lastPage;
        	}
        }
    });
	
}


function waredbclick(trobj)
{
	 
	var status =$("#statusindex").val();
	if(status > 0)
	{
		return;
	}
	$(".initial_rest").remove();
	var wareCode = trobj.cells[0].innerText;//childNodes[0].text;
	
	var wareId = $(trobj.cells[0]).find("input[name='wareId']").val();
	//alert(JSON.stringify(wareId));
	var wareName = trobj.cells[1].innerText;
	var price = trobj.cells[2].innerText;
	var unitName = $(trobj.cells[1]).find("input[name='wareUnit']").val();
	var dididid = $(this).attr('data-id');
	$("#more_list tbody").append(
			'<tr>'+
			//'<tr data-id="'+dididid+'">'+
			
			'<td><a href="javascript:;" class="beer">'+wareName+'</a><input  type=\"hidden\" name=\"wareId\"  value=\"' + wareId + '\"/></td>'+
			
			'<td><input type="number" class="bli" value=\"1\" onchange="countAmt()"/></td>'+
			'<td><input type="text" class="bli" value="' + unitName +  '"/></td>'+
			'<td><input type="number" class="bli" value="' + price + '" onchange="countAmt()"/></td>'+ 
			'<td><input type="number" class="bli" value="' + price + '" readonly="readonly"/></td>'+ 
			'<td><a href="javascript:" onclick="deleteWare(this);" class="delete_beer">删除</a></td>'+
		'</tr>'
				
				
				
		);
	$("#more_list tbody").append(
			'<tr class="initial_rest" onclick="showWareForm();">'+
			'<td><a href="javascript:;" class="beer">点击选择</a></td>'+
			
			'	<td><input type="number" class="bli"/></td>'+
			'	<td><input type="text" class="bli"/></td>'+
			'	<td><input type="number" class="bli"/></td>'+
			'	<td><input type="number" class="bli"/></td>'+
			'	<td><a href="javascript:;" class="delete_beer">删除</a></td>'+
			'</tr>'
		);
	totalQty = totalQty + 1;
	$("#totalqty").text(totalQty);
	countAmt();
	/*$(".pcl_del").on('click',function(){
		if(confirm('确定删除？')){
			$(this).parents('tr').remove();
		}
	});*/
	
}


/**
 * 选择商品的背景色
 * @param obj
 */
function tronmousedown(obj){  
	var trs = document.getElementById('warelist').getElementsByTagName('tr');  
    for( var o=0; o<trs.length; o++ ){  
     if( trs[o] == obj ){  
      trs[o].style.backgroundColor = '#DFEBF2';  
     }  
     else{  
      trs[o].style.backgroundColor = '';  
     }  
    }  
   }  
/**
 * 选择订单的背景色
 * @param obj
 */
function tronmousedown1(obj){  
	var trs = document.getElementById('orderList').getElementsByTagName('tr');  
    for( var o=0; o<trs.length; o++ ){  
     if( trs[o] == obj ){  
      trs[o].style.backgroundColor = '#DFEBF2';  
     }  
     else{  
      trs[o].style.backgroundColor = '';  
     }  
    }  
   }  

function deleteWare(obj)
{
	//alert(obj.innerHTML);
	$(obj).parents('tr').remove();
	//$("tr[data-id="+this_id+"]").remove();
	var trList = $("#subList").children("tr");
	if(trList.length == 0)
	{
		$("#more_list tbody").append(
				'<tr class="initial_rest" onclick="showWareForm();">'+
				'<td><a href="javascript:;" class="beer">点击选择</a></td>'+
				'	<td><a href="javascript:;" class="lib_chose_sale">点击选择</a></td>'+
				'	<td><input type="number" class="bli"/></td>'+
				'	<td><input type="text" class="bli"/></td>'+
				'	<td><input type="number" class="bli"/></td>'+
				'	<td><input type="number" class="bli"/></td>'+
				'	<td><a href="javascript:;" class="delete_beer">删除</a></td>'+
				'</tr>'
			);
	}
	countAmt();

}

function showWareForm()
{
	var status =$("#statusindex").val();
	if(status > 0)
	{
		return;
	}
	//$("#beer_box").fadeIn(200);
	totalQty = 0;
	$("#totalqty").text(totalQty);
	$("#beer_box").show();
}

function queryWareType()
{
	var path = "queryStkWareType";
	var token = $("#tmptoken").val();
	//alert(token);
	var topType = 0;
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.list.length;
        		var text = "";
					
        		for(var i = 0;i < size; i++)
        		{
        				if(json.list[i].waretypeLeaf == 1)
        				{
        					text+="<div class='bs_f'>";
        					text+="		<a href=\"javascript:queryWareByType(" +json.list[i].waretypeId + ");\">" + json.list[i].waretypeNm + "</a>";
        					text+="</div>";
        					
        					if(topType == 0)topType = json.list[i].waretypeId;
        				}
        				else
        				{
        					text+="<div class='bs_f'>";
							text+= "<p>" + json.list[i].waretypeNm + "</p>";
							text += "<div class='bs_submenu'>";
        					var size2 = json.list[i].list2.length;
        					for(var j = 0;j<size2;j++)
        						{
								//<a href="#">管理部</a>
        						text += "<a href=\"javascript:queryWareByType(" +json.list[i].list2[j].waretypeId + ");\">" + json.list[i].list2[j].waretypeNm + "</a>";
        						if(topType == 0)topType = json.list[i].list2[j].waretypeId;
									
        						}
        					
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
	var token = $("#tmptoken").val();
	//alert(token);
	stkId = $("#stkId").val();
	if(stkId == "")stkId = 0;
	$.ajax({
        url: path,
        type: "POST",
        data : {"wareType":wareType,"stkId":stkId,"token":token},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.list.length;
        		
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        				
        			text += '<tr onclick="waredbclick(this)" onmousedown = "tronmousedown(this)" style="cursor:hand;background-color:#FFFFFF">';
        			text += '<td><input type="hidden" name="wareId" value = "' +json.list[i].wareId+ '"/>' + json.list[i].wareCode + '</td>';
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
	var token = $("#tmptoken").val();
	//alert(token);
	
	$.ajax({
        url: path,
        type: "POST",
        data : {"keyWord":keyWord,"token":token},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.list.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
    			{
    				
    			text += '<tr onclick="waredbclick(this)" onmousedown = "tronmousedown(this)" style="cursor:hand;background-color:#FFFFFF">';
    			text += '<td><input type="hidden" name="wareId" value = "' +json.list[i].wareId+ '"/>' + json.list[i].wareCode + '</td>';
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
