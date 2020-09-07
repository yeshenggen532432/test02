
$(function(){
	querystorage();
	queryWareType();
	
	queryDict();
	queryProvider();
	querycustomer();
	querydepart();
	
	var billId =$("#billId").val();
	
	var stkName = $("#warehouse").text();
	if(stkName == "")
		{
			$("#warehouse").text("请点击");
		}
	if(billId > 0)
	{
		//alert(2222);
		$("#btnsubmit").attr("disabled", true);
		$("#remarks").attr("readonly","readonly");
		$("#discount").attr("readonly","readonly");
		$("#demo1").attr("disabled",true);
	}
	var proName = $("#lib_supplier").text();
	if(proName == "")
		{
		$("#lib_supplier").text("请点击");
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
			var stkId = $(this).find("input[name='stkId']").val();
			$("#stkId").val(stkId);
			box.fadeOut(200);
		});
	}
	
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
	 关闭浮层
	 * */
	function close_box(box,btn){
		btn.click(function(){
			box.hide();
		});
	}
	/*
	 点击切换
	 * */
	function sw(tl,ct){
		tl.first().addClass("on");
		ct.first().show();
	
		tl.click(function(){
			var a = $(this).index();
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
	//supplier();
	//lib_had2($(".lib_chose_sale"),$("#lib_chose_sale_had")); // 出库-销售类型-按钮绑定
	
	lib_hadstk($("#warehouse"),$("#warehouse_bhad")); // 出库-销售类型-按钮绑定
	lib_had($("#inType"),$("#order_had")); // 出库-销售类型-按钮绑定
	//lib_had($("#lib_supplier"),$("#lib_supplier_had")); //供应商选择
	
	has_sub_had($(".beer"),$("#beer_box"));// 选择啤酒类型
	
});
function querystorage(){
	var path = "queryBaseStorage";
	var token = $("#tmptoken").val();
	var billId = $("#billId").val();
	//alert(token);
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

function queryWare(){
	var path = "queryWaretypeLs1";
	var token = $("#tmptoken").val();
	//alert(token);
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
        			//<p class="lib_title">啤酒<img src="<%=basePath %>/resource/stkstyle/img/arrow.png"/></p>
        				//alert(json.list[i].waretypeNm);
        				text += "<li>";
        				text += "<p class=\"lib_title\">" + json.list[i].waretypeNm + "<img src=\"" + basePath + "/resource/stkstyle/img/arrow.png\"/></p>";
        				if(json.list[i].waretypeLeaf == "1")
        					{
        					//alert(json.list[i].waretypeNm);
        				var size2 = json.list[i].list3.length;
        				if(size2 > 0)
        				{
        					text+= "<div class=\"sub_menu\">";
							text += "<table>";
        				}
        				for(var j = 0;j< size2;j++)
        				{
        					if(j %2 == 0)
        					{
        						text += "<tr>";
        						text += "<td>";
        						text += "	<label><span>" + json.list[i].list3[j].wareNm + "</span><i class=\"check\"></i></label>";
        						text += "<input  type=\"hidden\" name=\"wareId\"  value=\"" + json.list[i].list3[j].wareId +  "\"/>"; 
        						text += "<input  type=\"hidden\" name=\"warePrice\"  value=\"" + json.list[i].list3[j].wareDj +  "\"/>";
        						text += "<input  type=\"hidden\" name=\"wareUnit\"  value=\"" + json.list[i].list3[j].wareDw +  "\"/>";
        						text += "</td>";
        					}
        					else
        					{
        						text += "<td>";
        						text += "<label><span>" +json.list[i].list3[j].wareNm + "</span><i class=\"check\"></i></label>";
        						text += "<input  type=\"hidden\" name=\"wareId\"  value=\"" + json.list[i].list3[j].wareId +  "\"/>";
        						text += "<input  type=\"hidden\" name=\"warePrice\"  value=\"" + json.list[i].list3[j].wareDj +  "\"/>";
        						text += "<input  type=\"hidden\" name=\"wareUnit\"  value=\"" + json.list[i].list3[j].wareDw +  "\"/>";
        						text += "</td>";
        						text += "</tr>";
        					};
        					
        				}
        				if(size2%2== 1)
        					{
        						text += "</tr>";
        					}
        				if(size2>0)
        				{
        					text += "</table>";
        					text += "</div>";
        				}
        				}//waretypeLeaf = 1
        				if(json.list[i].waretypeLeaf == "0")
        				{
        					//alert(json.list[i].waretypeNm);
        				var size3 = json.list[i].list2.length;
        				if(size3 > 0)
        				{
        					text += "<div class=\"sub_menu\">";
        					text += "<div class=\"sub_2\">";
        				}
        				for(var j = 0;j<size3;j++)
        				{
        					
        					text += "<p>" + json.list[i].list2[j].waretypeNm +"</p>";
        					var size4 = json.list[i].list2[j].list3.length;
        					if(size4 > 0)
        					{
        						text += "<div class=\"sub_m2\">";
        						text += "<table>";
        					}
        					for(var n = 0;n< size4;n++)
        					{
        						if(n %2 == 0)
            					{
            						text += "<tr>";
            						text += "<td>";
            						text += "	<label><span>" + json.list[i].list2[j].list3[n].wareNm + "</span><i class=\"check\"></i></label>";
            						text += "<input  type=\"hidden\" name=\"wareId\"  value=\"" + json.list[i].list2[j].list3[n].wareId +  "\"/>";
            						text += "<input  type=\"hidden\" name=\"warePrice\"  value=\"" + json.list[i].list2[j].list3[n].wareDj +  "\"/>";
            						text += "<input  type=\"hidden\" name=\"wareUnit\"  value=\"" + json.list[i].list2[j].list3[n].wareDw +  "\"/>";
            						text += "</td>";
            					}
            					else
            					{
            						text += "<td>";
            						text += "<label><span>" +json.list[i].list2[j].list3[n].wareNm + "  </span><i class=\"check\"></i></label>";
            						text += "<input  type=\"hidden\" name=\"wareId\"  value=\"" + json.list[i].list2[j].list3[n].wareId +  "\"/>";
            						text += "<input  type=\"hidden\" name=\"warePrice\"  value=\"" + json.list[i].list2[j].list3[n].wareDj +  "\"/>";
            						text += "<input  type=\"hidden\" name=\"wareUnit\"  value=\"" + json.list[i].list2[j].list3[n].wareDw +  "\"/>";
            						text += "</td>";
            						text += "</tr>";
            					};
        					}
        					if(size4%2== 1)
        					{
        						text += "</tr>";
        					}
        					if(size4>0)
        					{
        						text += "</table>";
        						text += "</div>";
        					}
        				}
        				if(size3 > 0)
        				{
        					text += "</div>";
        					text += "</div>";
        				}
        				}//waretypeLeaf = 0
        					
        				text += "</li>";
        			}
				
        		text += "</ul>";
        		$("#wareList").html(text);
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
	
	var stkId = $("#stkId").val();
	var billId = $("#billId").val();
	var remarks = $("#remarks").val();
	
	var outTime = $("#demo1").val();
	var discount = $("#discount").val();
	var proType = $("#proType").val();
	var proName = $("#lib_supplier").text();
	var cstId = $("#proId").val();
	var wareList = new Array();
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
				inQty:0,
				unitName: unit,
				price: price					
		};
	    wareList.push(subObj);
	    
	    
	}
	
	if(stkId == 0)
		{
		alert("请选择仓库");
		return;
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
        data : {"token":token,"id":billId,"proId":cstId,"proType":proType,"proName":proName,"stkId":stkId,"remarks":remarks,"inDate":outTime,"inType":"其它入库","discount":discount,"wareStr":JSON.stringify(wareList)},
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
        				if(json.rows[i].typeName == "采购入库")continue;
        				text += "<li>" + json.rows[i].typeName;
        				
        				text +="</li>";
        			}
				
        		text += "</ul>";
        		$("#stkDict").html(text);
        		
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
	$("#lib_supplier").html(shr);
	$("#proType").val(0);
	//$("#csttel").val(tel);
	//$("#cstaddress").val(address);
	$(".src_goods").hide();
	//queryOrder();
}



function querycustomer(filter){
	
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
	
	$("#proId").val(cstId);
	$("#lib_supplier").html(shr);
	$("#proType").val(2);
	//$("#csttel").val(tel);
	//$("#cstaddress").val(address);
	$(".src_goods").hide();
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
			
			text += "<td>" + json.rows[i].memberMobile + "</td>";	
			
			       				
			text += "</tr>";
			
		}
	
	
	$("#memberList").html(text);
	//$("#memberList1").html(text);
}

function memberClick(trobj)
{
	var proId = $(trobj.cells[0]).find("input[name='memberId']").val();
	
	var memberNm = $(trobj.cells[0]).text();
	var tel = $(trobj.cells[1]).text();
	//memdiv
	//var gyn = $(this).find('#pc_lib_name').text(),n = $(this).find('#pc_lib_mes').text();
	//var address = $(this).find('#pc_address').text();
	//var cstId = $(this).find("input[name='cstId']").val();
	
	$("#proType").val(proId);
	$("#lib_supplier").html(memberNm);
	$("#proType").val(1);
	
	$(".src_goods").hide();
	//queryOrder();
}

function querydepart(){
	
	var path = "queryStkDepart";
	var token = $("#tmptoken").val();
	//alert(token);
	$.ajax({
        url: path,
        type: "POST",
        data : {"dataTp":"1","token":token},
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
        		//$("#departTree1").html(text);
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
		var retStr = "<div class='bs_f'>";
			retStr += "<p>" + obj.branchName + "</p>";
			retStr += "<div class='bs_submenu'>";
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
			'<td><input type="text" class="bli" value="' + unitName +  '" readonly="readonly"/></td>'+
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