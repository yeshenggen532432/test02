var editstatus = 0;
var gstklist;
var orderlist;
var gdepartList = new Array();
var pageIndex = 0;
var isModify = false;
$(function(){
	
	//querystorage();
	//queryDict();
	queryAccount();
	queryCostType();
	queryProvider();
	querycustomer();
	querydepart();
	queryFinUnit();
	//初始化按钮
	//var billStatus = $("#billstatus").val();
	var billId = $("#billId").val();
	var status = $("#status").val();
	if(status == 0)
		{
			
			statuschg(1);
		}
	else
		{
			statuschg(0);
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
	$('#wareInput').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            //需要处理的事情
        	var tb = document.getElementById("warelist");
        	var line = tb.getElementsByTagName("tr")[0];  
        	
        	
        	waredbclick(line);
        		
        }
       
    });
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
		
		if(editstatus == 0)return;
		$(".pcl_chose_people").show();
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
	
	/*$(".pcl_chose_people tr").on('click',function(){
		var gyn = $(this).find('#pc_lib_name').text();
		
		var proId = $(this).find("input[name='proId']").val();
		
		$("#proId").val(proId);
		$("#pc_lib").html(gyn);
		
		$(".pcl_chose_people").hide();
	});*/
	
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
    						$("#stkId").val(json.list[i].id);
    						$("#stkNamespan").text(json.list[i].stkName);
    						
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


function queryFinUnit(filter){
	p3=1;
	var path = "queryFinUnit";
	var token = $("#tmptoken").val();
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

function queryFinUnitPage(){
	var filter = $("#searchtext").val();
	var path = "queryFinUnit";
	var token = $("#tmptoken").val();
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
        				text += "<tr ondblclick=\"customerclick(this)\">" ;
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
        				text += "<tr ondblclick=\"customerclick(this)\">" ;
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
			text += "<tr ondblclick=\"memberClick(this)\">" ;
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
	
	$("#proId").val(proId);
	$("#pc_lib").html(memberNm);
	$("#depId").val(depId);
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

function queryCostType()
{
	var path = "queryIoTypeList?typeName=其它应收款";
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
        		
        		var size = json.rows.length;
        		var text = "<table>";
					text+= "			<thead>";
					text+= "				<tr>";
					text+= "					<td>项目类别</td>";
										
					text+= "				</tr>";
					text+= "			</thead>";
								
					text+= "		</table>";
        		for(var i = 0;i < size; i++)
        		{
        				
        					text+="<div class=\"infinite\">";
        					text+="<div class=\"pcl_menu_m\">";
        					text+="	<div class=\"pcl_sub_menu\" style=\"display: block; padding-left: 0;\">";
        					text+="		<a href=\"javascript:queryItemByType(" +json.rows[i].id + ");\">" + json.rows[i].typeName + "</a>";
        					text+="	</div>";
        					text+="</div>";
        					text+="</div>";
        					if(topType == 0)topType = json.rows[i].id;
        				
        				
        				
        		}
        		
        		$("#wareTypeTree").html(text);
        		if(topType != 0)queryItemByType(topType);
				
        		
        	}
        }
    });
}

function queryItemByType(costType)
{
	var path = "queryIoItemList?typeName=其它应收款";
	//var token = $("#tmptoken").val();
	//alert(token);
	
	$.ajax({
        url: path,
        type: "POST",
        data : {"typeId":costType},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
        		
        		var size = json.rows.length;
        		var text = "";
        		for(var i = 0;i < size; i++)
        			{
        				
        			text += '<tr ondblclick="waredbclick(this)">';
        			text += '<td style="padding-left: 20px;text-align: left;"><img src="' + basePath + '/resource/stkstyle/img/icon19.jpg" class="pcl_ic" name = "itemName"/><input type="hidden" name="costId" value = "' +json.rows[i].id+ '"/>' + json.rows[i].itemName + '</td>';
        			
        			text += '<td>' + json.rows[i].remarks + '<input type="hidden" name="typeName" value = "' +json.rows[i].typeName+ '"/></td>';
        			text += '</tr>';
        			}
        		$("#warelist").html(text);
				
        		
        	}
        }
    });
}

function queryWareByKeyWord(keyWord)
{
	
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
        			text += '<td style="padding-left: 20px;text-align: left;"><img src="' + basePath + '/resource/stkstyle/img/icon19.jpg" class="pcl_ic" name = "warecode"/><input type="hidden" name="wareId" value = "' +json.list[i].wareId+ '"/>' + json.list[i].wareCode + '</td>';
        			text += '<td><input type="hidden" name="wareUnit" value = "' + json.list[i].wareDw + '"/>' + json.list[i].wareNm + '</td>';
        			text += '<td>' + json.list[i].inPrice + '</td>';
        			text += '</tr>';
        			}
        		$("#warelist").html(text);
				
        		
        	}
        }
    });
}
function newClick()
{
	location = 'toFinOutEdit';
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
			$("#btnnew").removeClass('on');
		}
		if($("#btnedit").hasClass('on')){
			$("#btnedit").removeClass('on');
		}
		if($("#btndelete").hasClass('on')){
			$("#btndelete").removeClass('on');
		}
		if($("#btnaudit").hasClass('on')){
			$("#btnaudit").removeClass('on');
		}
		if($("#btncancel").hasClass('on')){
			$("#btncancel").removeClass('on');
		}
		if(!$("#btnsave").hasClass('on')){
			$("#btnsave").addClass('on');
		}
		if(!$("#btnreset").hasClass('on')){
			$("#btnreset").addClass('on');
		}
		if($("#btnprint").hasClass('on')){
			$("#btnprint").removeClass('on');
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
			$("#btnnew").removeClass('on');
		}
		if($("#btnedit").hasClass('on')){
			$("#btnedit").removeClass('on');
		}
		if($("#btndelete").hasClass('on')){
			$("#btndelete").removeClass('on');
		}
		if($("#btnaudit").hasClass('on')){
			$("#btnaudit").removeClass('on');
		}
		if($("#btncancel").hasClass('on')){
			$("#btncancel").removeClass('on');
		}
		if(!$("#btnsave").hasClass('on')){
			$("#btnsave").addClass('on');
		}
		if(!$("#btnreset").hasClass('on')){
			$("#btnreset").addClass('on');
		}
		if($("#btnprint").hasClass('on')){
			$("#btnprint").removeClass('on');
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
			$("#btnnew").addClass('on');
		}
		if(!$("#btnedit").hasClass('on')){
			$("#btnedit").addClass('on');
		}
		if(!$("#btndelete").hasClass('on')){
			$("#btndelete").addClass('on');
		}
		if(!$("#btnaudit").hasClass('on')){
			$("#btnaudit").addClass('on');
		}
		if(!$("#btncancel").hasClass('on')){
			$("#btncancel").addClass('on');
		}
		if($("#btnsave").hasClass('on')){
			$("#btnsave").removeClass('on');
		}
		if($("#btnreset").hasClass('on')){
			$("#btnreset").removeClass('on');
		}
		if(!$("#btnprint").hasClass('on')){
			$("#btnprint").addClass('on');
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

function waredbclick(trobj)
{
	 
	if(editstatus == 0)return;
	//var wareCode = trobj.cells[0].innerText;//childNodes[0].text;
	
	var costId = $(trobj.cells[0]).find("input[name='costId']").val();
	//alert(JSON.stringify(wareId));
	var itemName = trobj.cells[0].innerText;
	var typeName = $(trobj.cells[1]).find("input[name='typeName']").val();
	$("#more_list tbody").append(
			'<tr>'+
				'<td style="padding-left: 20px;text-align: left;"><img src="'+basePath +'/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>'+
				'<input type="hidden" name="costId" value = "' + costId + '"/>' + typeName + '</td>'+
				
				'<td>' + itemName + '</td>'+
				
				'<td><input name="edtAmt" type="text" class="pcl_i2" value="" onchange="countAmt()"/></td>'+
				'<td><input name="edtRemarks" type="text" class="pcl_i2"/></td>'+
				
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
	
	
	var trList = $("#chooselist").children("tr");
	
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var costId = tdArr.eq(0).find("input").val();
	    
	    var amt = tdArr.eq(2).find("input").val();
	    
	   
	    if(amt == "")break;
	    total = total + parseFloat(amt);
	   
	    if(costId == 0)continue;
	    
	}
	
	$("#totalamt").val(numeral(total).format("0,0.00"));

	isModify = true;
}






function draftSave(){

	var status = $("#status").val();
	if(status==1){
		alert("该单据已审批，不能操作！");
		return;
	}
	if(status==2){
		alert("该单据已作废，不能操作!");
		return;
	}
	var proId = $("#proId").val();
	var billId = $("#billId").val();
	var proType = $("#proType").val();
	var proName = $("#pc_lib").text();
	var accId = $("#accId").val();
	if(accId == 0)
		{
			alert("请选择支出账户");
			return;
		}
	
	var inTime = $("#inDate").val();
	//var depId = $("#depId").val();
	//alert(depId);
	//var discount = $("#discount").val();
	var wareList = new Array();
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tdArr = trList.eq(i).find("td");
	    var costId = tdArr.eq(0).find("input").val();
	    
	    //alert(xsTp);
	    var amt = tdArr.eq(2).find("input").val();
	    var remarks = tdArr.eq(3).find("input").val();
	   
	    if(amt == "")break;
	    if(costId == 0)continue;
	    var subObj = {
				itemId: costId,				
				amt: amt,
				remarks:remarks
								
		};
	    wareList.push(subObj);
	}
	var remarks1 = $("#remarks").val();
	if(wareList.length == 0)
		{
			alert("请选择费用");
			return;
		}
	
	
	if(proId == 0)
		{
			alert("请选择申请人");
			return;
		}
	var path = "addFinOut";
	var token = $("#tmptoken").val();
	if(!confirm('是否确定暂存？'))return;
	//alert(JSON.stringify(wareList));
	$.ajax({
        url: path,
        type: "POST",
        data : {"token":token,"id":billId,"proId":proId,"accId":accId,"status":0,"proType":proType,"proName":proName,"remarks":remarks1,"billTimeStr":inTime,"wareStr":JSON.stringify(wareList)},
        dataType: 'json',
        async : false,
        success: function (json) {
        	if(json.state){
				$("#billId").val(json.id);
				$("#billstatus").val("暂存成功");
				$("#billId").val(json.id);
				$("#btnsave").hide();
				$("#btndraftaudit").show();
				$("#btnaudit").hide();
				isModify = false;
        	}
        }
    });
	
}


function saveAudit(){

	var status = $("#status").val();
	if(status==1){
		alert("该单据已审批，不能操作！");
		return;
	}
	if(status==2){
		alert("该单据已作废，不能操作!");
		return;
	}
	var proId = $("#proId").val();
	var billId = $("#billId").val();
	var proType = $("#proType").val();
	var proName = $("#pc_lib").text();
	var accId = $("#accId").val();
	if(accId == 0)
	{
		alert("请选择支出账户");
		return;
	}

	var inTime = $("#inDate").val();
	//var depId = $("#depId").val();
	//alert(depId);
	//var discount = $("#discount").val();
	var wareList = new Array();
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
		var tdArr = trList.eq(i).find("td");
		var costId = tdArr.eq(0).find("input").val();

		//alert(xsTp);
		var amt = tdArr.eq(2).find("input").val();
		var remarks = tdArr.eq(3).find("input").val();

		if(amt == "")break;
		if(costId == 0)continue;
		var subObj = {
			itemId: costId,
			amt: amt,
			remarks:remarks

		};
		wareList.push(subObj);
	}
	var remarks1 = $("#remarks").val();
	if(wareList.length == 0)
	{
		alert("请选择费用");
		return;
	}


	if(proId == 0)
	{
		alert("请选择申请人");
		return;
	}
	var path = "addFinOut";
	var token = $("#tmptoken").val();
	if(!confirm('是否确定保存并审批？'))return;
	//alert(JSON.stringify(wareList));
	$.ajax({
		url: path,
		type: "POST",
		data : {"token":token,"id":billId,"proId":proId,"accId":accId,"status":1,"proType":proType,"proName":proName,"remarks":remarks1,"billTimeStr":inTime,"wareStr":JSON.stringify(wareList)},
		dataType: 'json',
		async : false,
		success: function (json) {
			if(json.state){
				$("#billId").val(json.id);
				$("#status").val(1);
				$("#billstatus").val("提交成功");
				$("#btndraft").hide();
				$("#btndraftaudit").hide();
				$("#btnsave").hide();
				statuschg(1);
			}
		}
	});

}


function audit(){
	var status = $("#status").val();
	if(status==1){
		alert("该单据已审批，不能操作！");
		return;
	}
	if(status==2){
		alert("该单据已作废，不能操作!");
		return;
	}
	if(isModify){
		$.messager.alert('消息','单据已修改，请先保存!','info');
		return;
	}
	var id = $("#billId").val();
	if(!confirm('是否确定审批？'))return;
	$.ajax({
		url:"updateFinOutAudit",
		type:"post",
		data:"billId="+id,
		success:function(json){
			if(json.state){
				$("#billstatus").val("审批成功！");
				$("#status").val(1);
				$("#btndraft").hide();
				$("#btndraftaudit").hide();
				$("#btnsave").hide();
				statuschg(1);
			}else{
				alert("操作失败" + json.msg);
				return;
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

function queryAccount(){
	var path = "queryAccountList";
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
}

