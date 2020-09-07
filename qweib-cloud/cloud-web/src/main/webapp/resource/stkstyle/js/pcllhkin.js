var editstatus = 0;
var gstklist;
var orderlist;
var gdepartList = new Array();
var pageIndex = 0;
var isModify = false;
$(function(){
	
	querystorage();
	//queryDict();
	queryWareType();
	queryProvider();
	querycustomer();
	querydepart();
	queryFinUnit();
	
	//初始化按钮
	//var billStatus = $("#billstatus").val();
	var billId = $("#billId").val();
	var status = $("#status").val();
	if(status == -2)
	{
		statuschg(1);
	}
	else
	{
		statuschg(0);
	}
	
	if(billId > 0)
	{
	//document.getElementById("btnsave").style.display="none";
	}
	if(billId == 0)
	{
		// var myDate = new Date();
		// var seperator1 = "-";
	    //
	    // var month = myDate.getMonth() + 1;
	    // var strDate = myDate.getDate();
	    // if (month >= 1 && month <= 9) {
	    //     month = "0" + month;
	    // }
	    // if (strDate >= 0 && strDate <= 9) {
	    //     strDate = "0" + strDate;
	    // }
	    // var hour = myDate.getHours();
	    // if(hour < 10)hour = '0' + hour;
	    // var minute = myDate.getMinutes();
	    // if(minute<10)minute = '0' + minute;
		//
		// var dateStr = myDate.getFullYear() + seperator1 + month + seperator1 + strDate + " " + hour + ":" + minute;
		// $("#inDate").val(dateStr);
	}
	/*
	 * 表单收起按钮
	 * */
//	$('#wareInput').bind('keypress', function (event) {
//        if (event.keyCode == "13") {
//            //需要处理的事情
//        	var tb = document.getElementById("warelist");
//        	var line = tb.getElementsByTagName("tr")[0];  
//        	
//        	
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
	/*$(".pcl_del").on('click',function(){
		if(confirm('确定删除？')){
			$(this).parents('tr').remove();
		}
	});*/
	
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
			/*$(".pcl_del").on('click',function(){
				if(confirm('确定删除？')){
					var this_id = $(this).parents('tr').attr('data-id');
					$("tr[data-id="+this_id+"]").remove();
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
	
	/*
	 
	 * 供应商选择
	 * 
	 * */
	
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
	//supplier();
	lib_had2($(".lib_chose_sale"),$("#lib_chose_sale_had")); // 出库-销售类型-按钮绑定
	
	lib_had($("#warehouse"),$("#warehouse_bhad")); // 出库-销售类型-按钮绑定
	lib_had($("#order"),$("#order_had")); // 出库-销售类型-按钮绑定
	//lib_had($("#lib_supplier"),$("#lib_supplier_had")); //供应商选择
	
	has_sub_had($(".beer"),$("#beer_box"));// 选择啤酒类型
	
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

function testChg(obj)
{
	obj.stkName = obj.stkName + "11";
}

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
        		
        		
        		var objSelect = document.getElementById("intypesel");
        		objSelect.options.add(new Option(''),'');
        		for(var i = 0;i < size; i++)
        			{
        				if(json.rows[i].typeName == "采购入库")continue;
        				objSelect.options.add( new Option(json.rows[i].typeName,json.rows[i].typeName));
        				
        			}
				
        		
        	}
        }
    });
}

function queryProvider(filter){
	
	var path = "stkprovider";
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


function queryFinUnit(filter){
	p3=1;
	var path = "queryFinUnit";
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
        			text += "<tr onclick=\"finUnitClick(this)\">" ;
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
function queryFinUnitPage(){
	var filter = $("#searchtext").val();
	var path = "queryFinUnit";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":p3,"rows":12,"dataTp":"1","proName":filter},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		var size = json.rows.length;
        		var text = "";
        		
        		for(var i = 0;i < size; i++)
        			{
        			text += "<tr onclick=\"finUnitClick(this)\">" ;
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
	//var tel = $(trobj.cells[1]).find("#pc_lib_mes").text();
	//var address = $(trobj.cells[2]).find("#pc_address").text();
	//var gyn = $(this).find('#pc_lib_name').text(),n = $(this).find('#pc_lib_mes').text();
	//var address = $(this).find('#pc_address').text();
	//var cstId = $(this).find("input[name='cstId']").val();
	
	$("#proId").val(cstId);
	$("#pc_lib").html(shr);
	$("#proType").val(0);
	//$("#csttel").val(tel);
	//$("#cstaddress").val(address);
	$(".pcl_chose_people").hide();
	//queryOrder();
}


function finUnitClick(trobj)
{
	var cstId = $(trobj.cells[0]).find("input[name='proId']").val();
	var shr = $(trobj.cells[0]).text();
	//var tel = $(trobj.cells[1]).find("#pc_lib_mes").text();
	//var address = $(trobj.cells[2]).find("#pc_address").text();
	//var gyn = $(this).find('#pc_lib_name').text(),n = $(this).find('#pc_lib_mes').text();
	//var address = $(this).find('#pc_address').text();
	//var cstId = $(this).find("input[name='cstId']").val();
	
	$("#proId").val(cstId);
	$("#pc_lib").html(shr);
	$("#proType").val(3);
	//$("#csttel").val(tel);
	//$("#cstaddress").val(address);
	$(".pcl_chose_people").hide();
	//queryOrder();
}

function querycustomer(filter){
	p2=1;
	var path = "stkchoosecustomer";
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
        		p2++;
        		$("#customerlist").html(text);
        	}
        }
    });
}

function querycustomerPage(){
	var filter = $("#searchtext").val();
	var path = "stkchoosecustomer";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"page":p2,"rows":12,"dataTp":"1","khNm":filter},
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
        		p2++;
        		$("#customerlist").append(text);
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
	
	$("#proId").val(cstId);
	$("#pc_lib").html(shr);
	$("#proType").val(2);
	//$("#csttel").val(tel);
	//$("#cstaddress").val(address);
	$(".pcl_chose_people").hide();
	//queryOrder();
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
			
			text += "<td>" + json.rows[i].memberJob + "</td>";	
			
			       				
			text += "</tr>";
			
		}
	
	
	$("#memberList").html(text);
}

function memberClick(trobj)
{
	var proId = $(trobj.cells[0]).find("input[name='memberId']").val();
	
	var memberNm = $(trobj.cells[0]).text();
	
	//var gyn = $(this).find('#pc_lib_name').text(),n = $(this).find('#pc_lib_mes').text();
	//var address = $(this).find('#pc_address').text();
	//var cstId = $(this).find("input[name='cstId']").val();
	
	$("#proId").val(proId);
	$("#pc_lib").html(memberNm);
	$("#proType").val(1);
	$(".pcl_chose_people").hide();
	//queryOrder();
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
				
        		
        	}
        }
    });
}

function queryWareByType(wareType)
{
	var path = "queryStkWare2";
	$.ajax({
        url: path,
        type: "POST",
        data : {"wareType":wareType,"status":1},
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
        			text += '<td><input type="hidden" name="wareGg" value = "' + json.list[i].wareGg + '"/>' + json.list[i].inPrice + '';
        			text += '<input type="hidden" name="maxUnit" value = "' + json.list[i].wareDw + '"/>';
        			text += '<input type="hidden" name="maxUnitCode" value = "' + json.list[i].maxUnitCode + '"/>';
        			text += '<input type="hidden" name="minUnit" value = "' + json.list[i].minUnit + '"/>';
        			text += '<input type="hidden" name="minUnitCode" value = "' + json.list[i].minUnitCode + '"/>';
        			text += '<input type="hidden" name="hsNum" value = "' + json.list[i].hsNum + '"/>';
        			text += '<input type="hidden" name="sunitFront" value = "' + json.list[i].sunitFront + '"/></td>';
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
	
	var path = "queryStkWare2";
	//var token = $("#tmptoken").val();
	//alert(token);
	
	$.ajax({
        url: path,
        type: "POST",
        data : {"wareNm":keyWord,"status":1},
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
        			text += '<td><input type="hidden" name="wareGg" value = "' + json.list[i].wareGg + '"/>' + json.list[i].inPrice + '';
        			text += '<input type="hidden" name="maxUnit" value = "' + json.list[i].wareDw + '"/>';
        			text += '<input type="hidden" name="maxUnitCode" value = "' + json.list[i].maxUnitCode + '"/>';
        			text += '<input type="hidden" name="minUnit" value = "' + json.list[i].minUnit + '"/>';
        			text += '<input type="hidden" name="minUnitCode" value = "' + json.list[i].minUnitCode + '"/>';
        			text += '<input type="hidden" name="hsNum" value = "' + json.list[i].hsNum + '"/>';
        			text += '<input type="hidden" name="sunitFront" value = "' + json.list[i].sunitFront + '"/></td>';
        			text += '</tr>';
        			}
        		$("#warelist").html(text);
				
        		
        	}
        }
    });
}
function newClick()
{
	location = 'pcotherstkin';
	if(editstatus != 0)
	{
	  return;
	}
	statuschg(1);
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
			//$("#btnnew").removeClass('on');
		}
		if($("#btnedit").hasClass('on')){
			//$("#btnedit").removeClass('on');
		}
		if($("#btndelete").hasClass('on')){
			//$("#btndelete").removeClass('on');
		}
		if($("#btnaudit").hasClass('on')){
			//$("#btnaudit").removeClass('on');
		}
		if($("#btncancel").hasClass('on')){
			//$("#btncancel").removeClass('on');
		}
		if(!$("#btnsave").hasClass('on')){
			//$("#btnsave").addClass('on');
		}
		if(!$("#btnreset").hasClass('on')){
			//$("#btnreset").addClass('on');
		}
		if($("#btnprint").hasClass('on')){
			//$("#btnprint").removeClass('on');
		}
		$("#remarks").removeAttr("readonly");
		$("#discount").removeAttr("readonly");
		$("#inDate").removeAttr("disabled");
		
		$("#stksel").removeAttr("disabled");
		
		var edits = document.getElementsByName("edtprice");
		for(var i = 0;i<edits.length;i++)
			{
			$(edits[i]).removeAttr("readonly");
			}
		var qtyedits =  document.getElementsByName("edtqty");
		for(var i = 0;i<qtyedits.length;i++)
		{
		$(qtyedits[i]).removeAttr("readonly");
		}
		//$("#billstatus").val("未审");
	}
	if(btnstatus == 2)//编辑
	{
		if($("#btnnew").hasClass('on')){
			//$("#btnnew").removeClass('on');
		}
		if($("#btnedit").hasClass('on')){
			//$("#btnedit").removeClass('on');
		}
		if($("#btndelete").hasClass('on')){
			//$("#btndelete").removeClass('on');
		}
		if($("#btnaudit").hasClass('on')){
			//$("#btnaudit").removeClass('on');
		}
		if($("#btncancel").hasClass('on')){
			//$("#btncancel").removeClass('on');
		}
		if(!$("#btnsave").hasClass('on')){
			//$("#btnsave").addClass('on');
		}
		if(!$("#btnreset").hasClass('on')){
			//$("#btnreset").addClass('on');
		}
		if($("#btnprint").hasClass('on')){
			//$("#btnprint").removeClass('on');
		}
		$("#remarks").removeAttr("readonly");
		$("#discount").removeAttr("readonly");
		$("#inDate").removeAttr("disabled");
		
		$("#stksel").removeAttr("disabled");
		
		var edits = document.getElementsByName("edtprice");
		for(var i = 0;i<edits.length;i++)
			{
			$(edits[i]).removeAttr("readonly");
			}
		var qtyedits =  document.getElementsByName("edtqty");
		for(var i = 0;i<qtyedits.length;i++)
		{
		$(qtyedits[i]).removeAttr("readonly");
		}
	}
	if(btnstatus == 0)
	{
		if(!$("#btnnew").hasClass('on')){
			//$("#btnnew").addClass('on');
		}
		if(!$("#btnedit").hasClass('on')){
			//$("#btnedit").addClass('on');
		}
		if(!$("#btndelete").hasClass('on')){
			//$("#btndelete").addClass('on');
		}
		if(!$("#btnaudit").hasClass('on')){
			//$("#btnaudit").addClass('on');
		}
		if(!$("#btncancel").hasClass('on')){
			//$("#btncancel").addClass('on');
		}
		if($("#btnsave").hasClass('on')){
			//$("#btnsave").removeClass('on');
		}
		if($("#btnreset").hasClass('on')){
			//$("#btnreset").removeClass('on');
		}
		if(!$("#btnprint").hasClass('on')){
			//$("#btnprint").addClass('on');
		}
		$("#remarks").attr("readonly","readonly");
		$("#discount").attr("readonly","readonly");
		$("#inDate").attr("disabled",true);
		
		$("#stksel").attr("disabled","disabled");
		
		var edits = document.getElementsByName("edtprice");
		for(var i = 0;i<edits.length;i++)
			{
			$(edits[i]).attr("readonly","readonly");
			}
		var qtyedits =  document.getElementsByName("edtqty");
		for(var i = 0;i<qtyedits.length;i++)
		{
		$(qtyedits[i]).attr("readonly","readonly");
		}
	}
	
}
var rowIndex=1000;
function waredbclick(trobj)
{
	 
	if(editstatus == 0)return;
	var wareCode = trobj.cells[1].innerText;//childNodes[0].text;
	
	var wareId = $(trobj.cells[1]).find("input[name='wareId']").val();
	//alert(JSON.stringify(wareId));
	var wareName = trobj.cells[2].innerText;
	var price = trobj.cells[3].innerText;
	var unitName = $(trobj.cells[2]).find("input[name='wareUnit']").val();
	var wareGg = $(trobj.cells[3]).find("input[name='wareGg']").val();
	var maxUnitCode = $(trobj.cells[3]).find("input[name='maxUnitCode']").val();
	var minUnitCode = $(trobj.cells[3]).find("input[name='minUnitCode']").val();
	var minUnit = $(trobj.cells[3]).find("input[name='minUnit']").val();
	var hsNum = $(trobj.cells[3]).find("input[name='hsNum']").val();
	$("#more_list tbody").append(
			'<tr>'+
				'<td style="padding-left: 20px;text-align: left;"><img src="'+basePath +'/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>'+
				'<input type="hidden" id="wareId'+rowIndex+'" name="wareId" value = "' + wareId + '"/>' + wareCode + '</td>'+
				'<td>'+ wareName + '</td>'+
				'<td>'+ wareGg + '</td>'+
				'<td>' +  
				'<select id="beUnit'+rowIndex+'" name="beUnit" class="pcl_sel2" onchange="changeUnit(this,'+rowIndex+')">'+
				'<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+
				'<option value="'+minUnitCode+'">'+minUnit+'</option>'+
				'</select>'
				+ '</td>'+
				'<td style="display:'+priceDisplay+'"><input id="edtprice'+rowIndex+'" name="edtprice" type="text" class="pcl_i2" value="' + price + '" onchange="countAmt()"/></td>'+
				'<td style="display:'+qtyDisplay+'"><input id="edtqty'+rowIndex+'" name="edtqty" type="text" class="pcl_i2" value="1" onchange="countAmt()"/></td>'+
				'<td style="display:'+amtDisplay+'">' + price + '</td>'+
				'<td style="display:none"><input id="hsNum'+rowIndex+'" name="hsNum" type="hidden" class="pcl_i2" value="'+hsNum+'"/></td>'+
				'<td style="display:none"><input id="unitName'+rowIndex+'" name="unitName" type="hidden" class="pcl_i2" value="'+unitName+'" /></td>'+
				'<td><input name="text"  class="pcl_i2"  onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 90px;"  readonly="readonly" value="'  + '"/></td>'+
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
	
	var len = $("#more_list").find("tr").length ;
	var row = $("#more_list tbody tr").eq(len-2);
	/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/
	var sunitFront = $(trobj).find("input[name='sunitFront']").val();
	if(sunitFront==1){
		$(row).find("select[name='beUnit']").val(minUnitCode);
		$(row).find("select[name='beUnit']").trigger("change");
	}
	/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/
}


function deleteChoose(lineObj)
{
	var status = $("#status").val();
	if(status > 0)return;
	if(editstatus == 0)return;
	
	if(confirm('确定删除？')){
		//alert(lineObj.innerHTML);
		$(lineObj).parents('tr').remove();
		countAmt();
	}
}



function countAmt(){
	var total = 0;
	var sumQty = 0;
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    var qty = tdArr.eq(4).find("input").val();
	    var price = tdArr.eq(5).find("input").val();
	    if(qty == "")break;
	    total = total + qty*price;
	    sumQty = sumQty + qty*1;
	    tdArr.eq(6).find("input").val(numeral(qty*price).format("0,0.00"));
	    if(wareId == 0)continue;
	}
	
	$("#totalamt").val(numeral(total).format("0,0.00"));
	var discount = $("#discount").val();
	var disamt = total - discount;
	$("#disamt").val(numeral(disamt).format("0,0.00"));
	$("#edtSumAmt").text(numeral(disamt).format("0,0.00"));
	$("#edtSumQty").text(sumQty);
	isModify = true;
	
}

function countPrice(){
	var total = 0;
	var sumQty = 0;
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    var qty = tdArr.eq(4).find("input").val();
	    var amt = tdArr.eq(6).find("input").val();
	    if(qty == ""||amt==""||qty==0)break;
	    var price = parseFloat(amt)/parseFloat(qty);
	    price= price.toFixed(7);
	    tdArr.eq(5).find("input").val(price);
	    total = parseFloat(total) + parseFloat(amt);
	    if(wareId == 0)continue;
	}
	
	$("#totalamt").val(numeral(total).format("0,0.00"));
	var discount = $("#discount").val();
	var disamt = total - discount;
	$("#disamt").val(numeral(disamt).format("0,0.00"));
	$("#edtSumAmt").text(numeral(disamt).format("0,0.00"));
	$("#edtSumQty").text(sumQty);
	isModify = true;
}

function draftSave(){
	var status = $("#status").val();
	if(status != -2){
		 $.messager.alert('消息',"发票不在暂存状态，不能保存！");
		 return;
	}
	var proId = $("#proId").val();
	var billId = $("#billId").val();
	var proType = $("#proType").val();
	var proName = $("#proName").val();
	var stkId = $("#stkId").val();
	var remarks = $("#remarks").val();
	var inTime = $("#inDate").val();
	var discount = $("#discount").val();
	var wareList = new Array();
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    var qty = tdArr.eq(4).find("input").val();
	    var beUnit = tdArr.eq(3).find("select").val();
	    var price = tdArr.eq(5).find("input").val();
	    var hsNum = tdArr.eq(7).find("input").val();
	    var unit = tdArr.eq(3).find("option:selected").text();
	    var productDate = tdArr.eq(9).find("input").val();
	    if(qty == "")break;
	    if(wareId == 0)continue;
	    var subObj = {
				wareId: wareId,				
				qty: qty,
				inQty:qty,
				unitName: unit,
				price: price,
				hsNum:hsNum,
				beUnit:beUnit,
				productDate:productDate
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
	
	if(proId == 0)
		{
			alert("请选择入库对象");
			return;
		}
	var path = "dragSaveStkLlhkIn";
	var token = $("#tmptoken").val();
	if(!confirm('是否确定暂存？'))return;
	//alert(JSON.stringify(wareList));
	$("#btndraft").attr("disabled",true);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"id":billId,"proId":proId,"proType":proType,"proName":proName,"stkId":stkId,"remarks":remarks,"inDate":inTime,"inType":"领料回库","discount":discount,"wareStr":JSON.stringify(wareList)},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		$("#billId").val(json.id);
        		$("#billNo").val(json.billNo);
        		$("#btndraft").hide();
				$("#btnsave").hide();
        		$("#btndraftaudit").show();
        		$("#btnprint").show();
        		$("#btncancel").show();
        		$("#btnaudit").hide();
        		$("#billstatus").val("暂存成功");
				isModify = false;
        	}else{
				$("#btndraft").attr("disabled",false);

			}
        }
    });
	
}

function submitStk(){
	if(editstatus == 0)
		{
			alert("请先新建或编辑");
			return;
		}
	var proId = $("#proId").val();
	var billId = $("#billId").val();
	var proType = $("#proType").val();
	var proName = $("#proName").val();
	var stkId = $("#stkId").val();
	var remarks = $("#remarks").val();
	var inTime = $("#inDate").val();
	var discount = $("#discount").val();
	var wareList = new Array();
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var wareId = tdArr.eq(0).find("input").val();
	    var qty = tdArr.eq(4).find("input").val();
	    var beUnit = tdArr.eq(3).find("select").val();
	    var price = tdArr.eq(5).find("input").val();
	    
	    var hsNum = tdArr.eq(7).find("input").val();
	    var unit = tdArr.eq(3).find("option:selected").text();
	    var productDate = tdArr.eq(9).find("input").val();
	    if(qty == "")break;
	    if(wareId == 0)continue;
	    var subObj = {
				wareId: wareId,				
				qty: qty,
				inQty:qty,
				unitName: unit,
				price: price,
				hsNum:hsNum,
				beUnit:beUnit,
				productDate:productDate
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
	
	if(proId == 0)
		{
			alert("请选择入库对象");
			return;
		}
	var path = "addStkLlhkIn";
	var token = $("#tmptoken").val();
	if(!confirm('保存后将不能修改，是否确定保存？'))return;
	//alert(JSON.stringify(wareList));
	$("#btnsave").attr("disabled",true);
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"id":billId,"proId":proId,"proType":proType,"proName":proName,"stkId":stkId,"remarks":remarks,"inDate":inTime,"inType":"领料回库","discount":discount,"wareStr":JSON.stringify(wareList)},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		$("#billId").val(json.id);
        		$("#status").val(1);
        		$("#billNo").val(json.billNo);
        		$("#billstatus").val("提交成功");
        		$("#btndraft").hide();
        		$("#btndraftaudit").hide();
        		$("#btnsave").hide();
        		$("#btncancel").show();
        		statuschg(0);
        	}else{
				$.messager.alert('消息',json.msg,'info');
				$("#billId").val(json.id);
				$("#status").val(-2);
				$("#billNo").val(json.billNo);
				$("#btndraft").hide();
				$("#btndraftaudit").hide();
				statuschg(0);
			}
        }
    });
}

function audit()
{
	var billId = $("#billId").val();
	var status = $("#status").val();
	if(status==0){
		 $.messager.alert('消息','该单据已审批!','info');
	}
	if(billId == 0||status!=-2)
		{
			$.messager.alert('消息','发票已作废,不能审批!','info');
			 return;
		}
	if(status==2)
	{
		 $.messager.alert('消息','发票已作废，不能审批','info');
		 return;
	}
	if(isModify){
		$.messager.alert('消息','单据已修改，请先保存!','info');
		return;
	}
	$("#btndraftaudit").attr("disabled",true);
    $.messager.confirm('确认', '是否确定审核?',function(r){
		if(r){
		    var path = "auditDraftStkLlhkIn";
		    $.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":"","billId":billId},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		$("#billstatus").val("审批成功！");
		        		$("#status").val(0);
		        		$("#btndraft").hide();
		        		$("#btndraftaudit").hide();
		        		$("#btnsave").hide();
		        		$("#btnprint").show();
		        		$("#btncancel").show();
		        		$("#btnaudit").show();
		        		statuschg(0);
		        	}
		        	else
		        	{
		        		$.messager.alert('消息',json.msg,'info');
						$("#btndraftaudit").attr("disabled",false);
		        	}
		        	}
		    	});
    }});
}

function cancelClick()
{
	var billId = $("#billId").val();
	if(billId == 0)
		{
			alert("没有可作废的单据");
			return;
		}
	var billStatus = $("#status").val();
	if(billStatus == 2)
	{
	  alert("该单据已经作废");
	  return;
	}
    if(!confirm('确定作废？'))return;
	$("#btncancel").attr("disabled",true);
    var path = "cancelStkLlhkInByBillId";
    $.ajax({
        url: path,
        type: "POST",
        data : {"token":"","billId":billId},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		alert("作废成功");
        		$("#billstatus").val("作废成功");
        		$("#status").val(2);
				$("#btncancel").hide();
        	}
        	else
        	{
        		alert("作废失败" + json.msg);
				$("#btncancel").attr("disabled",false);
        	}
        }
    });
}


var p0 =1;
var p1 =1;
var p2 =1;
var p3 =1;
function queryclick()
{
	var searchText = $("#searchtext").val();
	if(pageIndex == 0)queryProvider(searchText);
	if(pageIndex == 1)queryMemberByName(searchText);
	if(pageIndex == 2)querycustomer(searchText);
	if(pageIndex == 3)queryFinUnit(searchText);
	
}

function changeUnit(o,index){
	var trList = $("#chooselist").children("tr");
	if(index<0){
		return;
	}
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