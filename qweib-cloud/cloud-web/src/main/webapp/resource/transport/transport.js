$(function(){
	//定义运费模板主体模板、头模板、单行显示模板
	TransTpl = ''; RuleHead = ''; RuleCell = '';	
	TransTpl += "<div style=\"border: 1px solid #B2D1FF;margin: 5px 0px; padding: 5px;width:674px;\" data-delivery=\"TRANSTYPE\">";
	TransTpl += "<div class=\"entity\">";
	TransTpl += "<div class=\"default J_DefaultSet\">";
	TransTpl += "默认运费：";
	TransTpl += "<input class=\"w30 mr5 text\" type=\"text\" aria-label=\"默认运费件数\" maxlength=\"4\" autocomplete=\"off\" data-field=\"start\" value=\"1\" name=\"default[TRANSTYPE][start]\">";
	TransTpl += "件内，";
	TransTpl += "<input class=\"w50 mr5 text\" type=\"text\" aria-label=\"默认运费价格\" maxlength=\"6\" autocomplete=\"off\" value=\"\" name=\"default[TRANSTYPE][postage]\" data-field=\"postage\">";
	TransTpl += "元， 每增加";
	TransTpl += "<input class=\"w30 ml5 mr5 text\" type=\"text\" aria-label=\"每加件\" maxlength=\"4\" autocomplete=\"off\" value=\"1\" data-field=\"plus\" name=\"default[TRANSTYPE][plus]\">";
	TransTpl += "件， 增加运费";
	TransTpl += "<input class=\"w50 ml5 mr5 text\" type=\"text\" aria-label=\"加件运费\" maxlength=\"6\" autocomplete=\"off\" value=\"\" data-field=\"postageplus\" name=\"default[TRANSTYPE][postageplus]\">";
	TransTpl += "元";
	TransTpl += "<div class=\"J_DefaultMessage\"></div>";
	TransTpl += "</div>";
	TransTpl += "<div class=\"tbl-except\">";
	TransTpl += "</div>";
	TransTpl += "<div class=\"batch\" style=\"display:none\">";
	TransTpl += "<label><input class=\"J_BatchCheck\" type=\"checkbox\" aria-label=\"全选\" value=\"\" name=\"\">";
	TransTpl += "全选</label>";
	TransTpl += "&nbsp;<a class=\"J_BatchSet\" href=\"JavaScript:void(0);\">批量设置</a>";
	TransTpl += "<a class=\"J_BatchDel\" href=\"JavaScript:void(0);\">批量删除</a>";
	TransTpl += "</div>";
	TransTpl += "<div class=\"tbl-attach\">";
	TransTpl += "<div class=\"J_SpecialMessage\"></div>";
	TransTpl += "<a class=\"J_AddRule\" href=\"JavaScript:void(0);\">为指定地区城市设置运费</a>";
	TransTpl += "<a class=\"J_ToggleBatch\" style=\"display:none\" href=\"JavaScript:void(0);\">批量操作</a>";
	TransTpl += "</div>";
	TransTpl += "</div>";
	TransTpl += "</div>";

	SpecialMessage = '';
	SpecialMessage += "<span  error_type=\"area\" class=\"msg J_Message\" style=\"display:none\"><span class=\"error\">指定地区城市为空或指定错误</span></span>";
	SpecialMessage += "<span  error_type=\"start\" class=\"msg J_Message\" style=\"display:none\"><span class=\"error\">首件应输入1至9999的数字</span></span>";
	SpecialMessage += "<span error_type=\"postage\" class=\"msg J_Message\" style=\"display:none\"><span class=\"error\">首费应输入0.00至999.99的数字</span></span>";
	SpecialMessage += "<span error_type=\"plus\" class=\"msg J_Message\" style=\"display:none\"><span class=\"error\">续件应输入1至9999的数字</span></span>";
	SpecialMessage += "<span error_type=\"postageplus\" class=\"msg J_Message\" style=\"display:none\"><span class=\"error\">续费应输入0.00至999.99的数字</span></span>";

	DefaultMessage = '';
	DefaultMessage += "<span error_type=\"start\" class=\"msg J_Message\" style=\"display:none\"><span class=\"error\">首件应输入1至9999的数字</span></span>";
	DefaultMessage += "<span error_type=\"postage\" class=\"msg J_Message\" style=\"display:none\"><span class=\"error\">首费应输入0.00至999.99的数字</span></span>";
	DefaultMessage += "<span error_type=\"plus\" class=\"msg J_Message\" style=\"display:none\"><span class=\"error\">续件应输入1至9999的数字</span></span>";
	DefaultMessage += "<span error_type=\"postageplus\" class=\"msg J_Message\" style=\"display:none\"><span class=\"error\">续费应输入0.00至999.99的数字</span></span>";

	//记录当前起始值
	StartNum = $('.tbl-except>table>tbody>tr').size();

	//头模板
	RuleHead += "<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\">\n";
	RuleHead += "<colgroup>\n";
	RuleHead += "<col class=\"col-area\">\n";
	RuleHead += "<col class=\"col-start\">\n";
	RuleHead += "<col class=\"col-postage\">\n";
	RuleHead += "<col class=\"col-plus\">\n";
	RuleHead += "<col class=\"col-postageplus\">\n";
	RuleHead += "<col class=\"col-action\">\n";
	RuleHead += "<\/colgroup>\n";
	RuleHead += "<thead>\n";
	RuleHead += "<tr>\n";
	RuleHead += "<th>运送到<\/th>\n";
	RuleHead += "<th>首件(件)<\/th>\n";
	RuleHead += "<th>首费(元)<\/th>\n";
	RuleHead += "<th>续件(件)<\/th>\n";
	RuleHead += "<th>续费(元)<\/th>\n";
	RuleHead += "<th>操作<\/th>\n";
	RuleHead += "<\/tr>\n";
	RuleHead += "<\/thead>\n";
	RuleHead += "<tbody>\n";
	RuleHead += "<\/tbody>\n";
	RuleHead += "<\/table>\n";

	//单行内容模板
	RuleCell += "<tr ruleCellGroup=\"CurNum\" data-group=\"nCurNum\">\n";
	RuleCell += "<td class=\"cell-area\">\n";
	RuleCell += "<a class=\"acc_popup edit J_EditArea\" title=\"编辑运送区域\" area-haspopup=\"true\" area-controls=\"J_DialogArea\" entype=\'J_EditArea\' data-acc=\"event:enter\" href=\"JavaScript:void(0);\">编辑<\/a>\n";
	RuleCell += "<span class=\"area-group\">\n";
	RuleCell += "<input class=\"J_BatchField\" style=\"width:15px;display:none\" type=\"checkbox\" value=\"\" name=\"TRANSTYPE_nCurNum\">\n";
	RuleCell += "<p>未添加地区</p><\/span>\n";
	RuleCell += "<input type=\"hidden\" value=\"\" name=\"areas[TRANSTYPE][CurNum]\">\n";
	RuleCell += "<\/td>\n";
	RuleCell += "<td>\n";
	RuleCell += "<input class=\"input-text text\" type=\"text\" aria-label=\"首件\" maxlength=\"4\" autocomplete=\"off\" value=\"1\" data-field=\"start\" name=\"special[TRANSTYPE][CurNum][start]\">\n";
	RuleCell += "<\/td>\n";
	RuleCell += "<td>\n";
	RuleCell += "<input class=\"w50 mr5 text\" type=\"text\" aria-label=\"首费\" maxlength=\"6\" autocomplete=\"off\" value=\"\" data-field=\"postage\" name=\"special[TRANSTYPE][CurNum][postage]\">\n";
	RuleCell += "<\/td>\n";
	RuleCell += "<td>\n";
	RuleCell += "<input class=\"input-text text\" type=\"text\" aria-label=\"续件\" maxlength=\"4\" autocomplete=\"off\" value=\"1\" data-field=\"plus\" name=\"special[TRANSTYPE][CurNum][plus]\">\n";
	RuleCell += "<\/td>\n";
	RuleCell += "<td>\n";
	RuleCell += "<input class=\"w50 mr5 text\" type=\"text\" aria-label=\"续费\" maxlength=\"6\" autocomplete=\"off\" value=\"\" data-field=\"postageplus\" name=\"special[TRANSTYPE][CurNum][postageplus]\">\n";
	RuleCell += "<\/td>\n";
	RuleCell += "<td>\n";
	RuleCell += "<a class=\"J_DeleteRule\" href=\"JavaScript:void(0);\">删除<\/a>\n";
	RuleCell += "<\/td>\n";
	RuleCell += "<\/tr>\n";

/*	为指定地区设置运费,增加一行运费规则*/
	$('.J_AddRule').live('click',function (){
		StartNum +=1;
		if ($(this).parent().parent().find('.tbl-except').html().replace("\n",'')==''){
			$(this).parent().parent().find('.tbl-except').append(RuleHead);
		}
		cell = RuleCell.replace(/CurNum/g,StartNum); 
		cell = cell.replace(/TRANSTYPE/g,$(this).parent().parent().parent().attr('data-delivery')); 
		$(this).parent().parent().find('.tbl-except').find('table').append(cell);

		//如果没有批量操作a链接，则添加
		if ($(this).parent().parent().find('input[type="checkbox"]').css('display') == 'none'){
			$(this).next().css('display','').html('批量操作');
		}else{
			$(this).next().css('display','').html('取消批量');
			$(this).parent().parent().find('.tbl-except').find('.J_BatchField:last').css('display','');
		}
	});

	$(".trans-line").parent().append(TransTpl.replace(/TRANSTYPE/g,"df"));
/*	平邮、快递、EMS单击事件*/
	/*$('input[name="tplType[]"]').click(function (){
		if ($(this).attr('checked')){
			if ($(this).parent().next().html() == null){
				$(this).parent().parent().append(TransTpl.replace(/TRANSTYPE/g,$(this).val()));
			}else{
				$(this).parent().next().css('display','');
			}
			$('p[error_type="trans_type"]').css('display','none');
		}else{
			$(this).parent().next().css('display','none');
		}
	});*/

/*	自定义转成整形的方法*/
	jQuery.fn.toInt = function() {
		var s = parseInt(jQuery(this).val().replace( /^0*/,''));
		return isNaN(s) ? 0 : s;
	};

/*	关闭选择区域层*/
	$('.ks-ext-close-x').click(function(){
	    $("#dialog_areas").css('display','none');
	    $("#dialog_batch").css('display','none');
	    $('.ks-ext-mask').css('display','none');
	    return false;
	});

/*	关闭选择区域层*/
	$('.J_Cancel').click(function(){
	    $("#dialog_areas").css('display','none');
	    $("#dialog_batch").css('display','none');
	    $('.ks-ext-mask').css('display','none');
	});	

/*	选择完区域后，确定事件*/
	$('.J_Submit').click(function (){
		var CityText = '', CityText2 = '', CityValue = '';
		//记录已选择的所有省及市的value，SelectArea下标为value值，值为true，如江苏省SelectArea[320000]=true,南京市SelectArea[320100]=true
//		SelectArea = new Array();
		//取得已选的省市的text，返回给父级窗口，如果省份下的市被全选择，只返回显示省的名称，否则显示已选择的市的名称
		//首先找市被全部选择的省份
		$('#J_CityList').find('.gareas').each(function(){
			var a = $(this).find('input[type="checkbox"]').size();
			var b = $(this).find('input:checked').size();
			//市被全选的情况
			if (a == b){
				CityText += ($(this).find('.J_Province').next().html())+',';
			}else{
				//市被部分选中的情况
				$(this).find('.J_City').each(function(){
						//计算并准备传输选择的区域值（具体到市级ID），以，隔开
							if ($(this).attr('checked')){
								CityText2 += ($(this).next().html())+',';
							}
				});
			}
		});
		CityText += CityText2;

		//记录弹出层内所有已被选择的checkbox的值(省、市均记录)，记录到CityValue，SelectArea中
		$('#J_CityList').find('.province-list').find('input[type="checkbox"]').each(function(){
			if ($(this).attr('checked')){
				CityValue += $(this).val()+',';
			}
		});

		//去掉尾部的逗号
		CityText = CityText.replace(/(,*$)/g,'');
		CityValue = CityValue.replace(/(,*$)/g,'');

		//返回选择的文本内容
		if (CityText == '')CityText = '未添加地区';
		$(objCurlArea).find('.area-group>p').html(CityText);
		//返回选择的值到隐藏域
		$('input[name="areas['+curTransType+']['+curIndex.substring(1)+']"]').val(CityValue+'|||'+CityText);
		//关闭弹出层与遮罩层
	    $("#dialog_areas").css('display','none');
	    $('.ks-ext-mask').css('display','none');
	    //清空check_num显示的数量
		$(".check_num").html('');
		$('#J_CityList').find('input[type="checkbox"]').attr('checked',false);
		//如果该配送方式，地区都不为空，隐藏地区的提示层
		isRemove = true;
		$('div[data-delivery="'+curTransType+'"]').find('input[type="hidden"]').each(function(){
			if ($(this).val()==''){
				isRemove = false;return false;
			}
		});
		if (isRemove == true){
			$('div[data-delivery="'+curTransType+'"]').find('span[error_type="area"]').css('display','none');
		}
	});

/*	省份点击事件*/
	$('.J_Province').click(function(){
		if ($(this).attr('checked') == "checked"){
			//选择所有未被disabled的子地区
			$(this).parent().find('.citys').children().find('input[type="checkbox"]').each(function(){
				if ($(this).attr('disabled') == undefined){
					$(this).attr('checked',true);
				}else{
					$(this).attr('checked',false);
				}
			});
			//计算并显示所有被选中的子地区数量
			num = '('+$(this).parent().find('.citys').eq(0).find('input:checked').size()+')';
			if (num == '(0)') num = '';
			$(this).parent().parent().find(".check_num").eq(0).html(num);

			//如果该大区域所有省都选中，该区域选中
			input_checked 	= $(this).parent().parent().parent().find('input:checked').size();
			input_all 		= $(this).parent().parent().parent().find('input[type="checkbox"]').size();
			if (input_all == input_checked){
				$(this).parent().parent().parent().parent().find('.J_Group').attr('checked',true);
			}	

		}else{
			//取消全部子地区选择，取消显示数量
			$(this).parent().parent().find(".check_num").eq(0).html('');
			$(this).parent().find('.citys').eq(0).find('input[type="checkbox"]').attr('checked',false);
			//取消大区域选择
			$(this).parent().parent().parent().parent().find('.J_Group').attr('checked',false);
		}
	});

/*	大区域点击事件（华北、华东、华南...）*/
	$('.J_Group').click(function(){
		if ($(this).attr('checked')){
			//区域内所有没有被disabled复选框选中，带disabled说明已经被选择过了，不能再选
			$(this).parent().parent().parent().find('input[type="checkbox"]').each(function(){
				if ($(this).attr('disabled') == undefined){
					$(this).attr('checked',true);
				}else{
					$(this).attr('checked',false);
				}				
			});
			//循环显示每个省下面的市级的数量
			$(this).parent().parent().parent().find('.province-list').find('.ecity').each(function(){
				//显示该省下面已选择的市的数量
				num = '('+$(this).find('.citys').find('input:checked').size()+')';
				//如果是0，说明没有选择，不显示数量
				if (num != '(0)'){
					$(this).find(".check_num").html(num);
				}
			});
		}else{
			//区域内所有筛选框取消选中
			$(this).parent().parent().parent().find('input[type="checkbox"]').attr('checked',false);
			//循环清空每个省下面显示的市级数量
			$(this).parent().parent().parent().find('.province-list').find('.ecity').each(function(){
				$(this).find(".check_num").html('');
			});
		}

	});

/*	关闭弹出的市级小层*/
	$('.close_button').click(function(){ 
	    $(this).parent().parent().parent().parent().removeClass('showCityPop');
	});

/*	市级地区单事件*/
	$('.J_City').click(function(){
		//显示选择市级数量，在所属省后面
		num = '('+$(this).parent().parent().find('input:checked').size()+')';
		if (num=='(0)')num='';
		$(this).parent().parent().parent().find(".check_num").eq(0).html(num);
		//如果市级地区全部选中，则父级省份也选中，反之有一个不选中,则省份和大区域也不选中
		if (!$(this).attr('checked')){
			//取消省份选择
			$(this).parent().parent().parent().find('.J_Province').attr('checked',false);
			//取消大区域选择
			$(this).parent().parent().parent().parent().parent().parent().find('.J_Group').attr('checked',false);
		}else{
			//如果该省所有市都选中，该省选中
			input_checked 	= $(this).parent().parent().find('input:checked').size();
			input_all 		= $(this).parent().parent().find('input[type="checkbox"]').size();
			if (input_all == input_checked){
				$(this).parent().parent().parent().find('.J_Province').attr('checked',true);
			}
			//如果该大区域所有省都选中，该区域选中
			input_checked 	= $(this).parent().parent().parent().parent().parent().find('input:checked').size();
			input_all 		= $(this).parent().parent().parent().parent().parent().find('input[type="checkbox"]').size();
			if (input_all == input_checked){
				$(this).parent().parent().parent().parent().parent().parent().find('.J_Group').attr('checked',true);
			}
		}
	});
	
/*	省份下拉事件*/
	$(".trigger").click(function () {
		objTrigger = this;objHead = $(this).parent();objPanel = $(this).next();
		if ($(this).next().css('display') == 'none'){
			//隐藏所有已弹出的省份下拉层，只显示当前点击的层
			$('.ks-contentbox').find('.ecity').removeClass('showCityPop');
			$(this).parent().parent().addClass('showCityPop');
		}else{
			//隐藏当前的省份下拉层
			$(this).parent().parent().removeClass('showCityPop');
		}
		//点击省，市所在的head与panel层以外的区域均隐藏当前层
        var oHandle = $(this);
//        oHandle = document.getElementById($(this).attr('id'));//不兼容Ie8,废弃
		var de = document.documentElement?document.documentElement : document.body;
        de.onclick = function(e){
	        var e = e || window.event;
	        var target = e.target || e.srcElement;
	        var getTar = target.getAttribute("id");
	        while(target){
	        	//循环最外层一个时，会出现异常
				try{
					//jquery 转成DOM对象，比较两个DOM对象
	                if(target==$(objHead)[0])return true;
	                if(target==$(objPanel)[0])return true;
	                //暂不考虑使用ID比较
//	                if(target.getAttribute("id")==$(objHead).attr('id'))return true;
//	                if(target.getAttribute("id")==$(objPanel).attr('id'))return true;
				}catch(ex){};
	            target = target.parentNode;
	        }
	        $(objTrigger).parent().parent().removeClass('showCityPop');
        }
	});

	/*	选择运送区域*/
	$('a[entype="J_EditArea"]').live('click',function () {
		curTransType = $(this).next().next().attr('name').substring(6,8);
		//取消所以已选择的checkbox
		$('#J_CityList').find('input[type="checkbox"]').attr('checked',false);//.attr('disabled','');
	
		//取消显示所有统计数量
		$('#J_CityList').find('.check_num').html('');

		//记录当前行的标识n1,n2,n3....
		curIndex = $(this).parent().parent().attr('data-group');

		//记录当前操作的行，选择完地区会向该区域抛出值
		objCurlArea = $(this).parent();
	
		//记录已选择的所有省及市的value，SelectArea下标为value值，值为true，如江苏省SelectArea[320000]=true,南京市SelectArea[320100]=true
		SelectArea = new Array();

		//取得当前行隐藏域内的city值，放入SelectArea数组中
		var expAreas = $('input[name="areas['+curTransType+']['+curIndex.substring(1)+']"]').val();
		expAreas = expAreas.split('|||');
		expAreas = expAreas[0].split(',');
		try{
			if(expAreas[0] != ''){
				for(var v in expAreas){
					SelectArea[expAreas[v]] = true;
				}
			}
	
			//初始化已选中的checkbox
			$('#J_CityList').find('.ecity').each(function(){
				var count = 0;
				$(this).find('input[type="checkbox"]').each(function(){
					if(SelectArea[$(this).val()]==true){
						$(this).attr('checked',true);
						if($(this)[0].className!='J_Province') count++;
					}
				});
				if (count > 0){
					$(this).find('.check_num').html('('+count+')');
				}
	
			});

			//循环每一行，如果一行省都选中，则大区载选中
			$('#J_CityList>li').each(function(){
				$(this).find('.J_Group').attr('checked',true);
				father = this;
				$(this).find('.J_Province').each(function(){
					if (!$(this).attr('checked')){
						$(father).find('.J_Group').attr('checked',false);
						return ;
					}
				});
			});
		}catch(ex){}
		//其它行已选择的地区，不能再选择了
		$(objCurlArea).parent().parent().find('.area-group').each(function(){
			if ($(this).next().attr('name') != 'areas['+curTransType+']['+curIndex.substring(1)+']'){
				expAreas = $(this).next().val().split('|||');
				expAreas = expAreas[0].split(',');
				//重置SelectArea
				SelectArea = new Array();
				try{
					if(expAreas[0] != ''){
						for(var v in expAreas){
							SelectArea[expAreas[v]] = true;
						}
					}

					//其它行已选中的在这里都置灰
					$('#J_CityList').find('input[type="checkbox"]').each(function(){
						if(SelectArea[$(this).val()]==true){
							$(this).attr('disabled','disabled').attr('checked',false);
						}
					});
					//循环每一行，如果一行的省都被disabled，则大区域也disabled
					$('#J_CityList>li').each(function(){
						$(this).find('.J_Group').attr('disabled','disabled');
						father = this;
						$(this).find('.J_Province').each(function(){
							if (!$(this).attr('disabled')){
								$(father).find('.J_Group').attr('disabled','');
								return ;
							}
						});
					});				
				}catch(ex){}
			}
		});
		//定位弹出层的坐标
		var pos = $(this).position();
		var pos_x = pos.left-250;
		var pos_y = pos.top+20;
		$("#dialog_areas").css({'left' : pos_x, 'top' : pos_y,'position' : 'absolute','display' : 'block'});
		$('.ks-ext-mask').css('display','block');
	
	});

	$('#title').blur(function(){
		if ($(this).val() !=''){
			$('p[error_type="title"]').css('display','none');
		}
	});

	/*	首费离开校验*/
	$('input[data-field="postage"]').live('blur',function (){
		var oNum = new Number($(this).val());
		oNum = oNum.toFixed(2);
		if (oNum > 999.99) oNum = 999.99;
		if (oNum=='NaN') oNum = '0.00'; 
		$(this).val(oNum);
		if($(this)[0].className=='w50 mr5 input-error') $(this).removeClass('input-error');
		if($(this)[0].className=='w50 ml5 mr5 input-error') $(this).removeClass('input-error');
		
		if($(this).parent()[0].className=='default J_DefaultSet'){
			//首费不为空了，如果是默认的首费，隐藏提示层span
			$(this).parent().find('.J_DefaultMessage').find('span[error_type="postage"]').css('display','none');
		}else{
			//如果是动态添加的首费,当所有首费输入框都不为空时，提示层span隐藏
			isRemove = true;
			$(this).parent().parent().parent().find('input[data-field="postage"]').each(function(){
				if ($(this).val()==''){
					isRemove = false;return false;
				}
			});
			//提示层span隐藏
			if (isRemove == true){
				$(this).parent().parent().parent().parent().parent().parent().find('.tbl-attach').find('.J_SpecialMessage').find('span[error_type="postage"]').css('display','none');
			}
		}
	});

	/*	续费离开校验*/
	$('input[data-field="postageplus"]').live('blur',function (){
		var oNum = new Number($(this).val());
		oNum = oNum.toFixed(2);
		if (oNum > 999.99) oNum = 999.99;
		if (oNum=='NaN') oNum = '0.00';
		$(this).val(oNum);
		if($(this)[0].className=='w50 mr5 input-error') $(this).removeClass('input-error');
		if($(this)[0].className=='w50 ml5 mr5 input-error') $(this).removeClass('input-error');

		if($(this).parent()[0].className=='default J_DefaultSet'){
			//续费不为空了，如果是默认的首费，隐藏提示层span
			$(this).parent().find('.J_DefaultMessage').find('span[error_type="postageplus"]').css('display','none');
		}else{
			//如果是动态添加的首费,当所有续费输入框都不为空时，提示层span隐藏
			isRemove = true;
			$(this).parent().parent().parent().find('input[data-field="postageplus"]').each(function(){
				if ($(this).val()==''){
					isRemove = false;return false;
				}
			});
			//提示层span隐藏
			if (isRemove == true){
				$(this).parent().parent().parent().parent().parent().parent().find('.tbl-attach').find('.J_SpecialMessage').find('span[error_type="postageplus"]').css('display','none');
			}
		}			
	});

	/*	续件离开校验*/
	$('input[data-field="plus"]').live('blur',function (){
		if ($(this).val() != ''){
			$(this).val($(this).toInt());
		}else{
			$(this).val(1);
		}
	});
	
	/*	首件离开校验*/
	$('input[data-field="start"]').live('blur',function (){
		if ($(this).val() != ''){
			$(this).val($(this).toInt());
		}else{
			$(this).val(1);
		}
	});
	
	/*	删除一行运费规则*/
	$('.J_DeleteRule').live('click',function (){
		if (!confirm('确认删除吗?')) return false;
		curTransType = $(this).parent().parent().parent().find('input[type="hidden"]').eq(0).attr('name').substring(6,8);
		obj_parent = $(this).parent().parent().parent();
		$(this).parent().parent().remove();
		if ($(obj_parent).find('tr').html() == null){
			$(obj_parent).parent().parent().parent().find('.batch').css('display','none');
			$(obj_parent).parent().parent().parent().find('.J_ToggleBatch').css('display','none');
			$(obj_parent).parent().parent().parent().find('.batch').next().find('span').css('display','none');
		}else{
			//如果该配送方式，地区都不为空，隐藏地区的提示层
			isRemove = true;
			$('div[data-delivery="'+curTransType+'"]').find('input[type="hidden"]').each(function(){
				if ($(this).val()==''){
					isRemove = false;return false;
				}
			});
			if (isRemove == true){
				$('div[data-delivery="'+curTransType+'"]').find('span[error_type="area"]').css('display','none');
			}			
		}
	});
	
	/*批量操作*/
	$('.J_ToggleBatch').live('click',function(){
		if ($(this).parent().parent().find('.J_BatchField').eq(0).css('display')=='none'){
			$(this).parent().parent().find('.batch').css('display','');
			$(this).parent().parent().find('.batch').find('.J_BatchCheck').attr('checked',false);
			$(this).parent().parent().find('.J_BatchField').css('display','');
			$(this).html('取消批量');	
		}else{
			$(this).parent().parent().find('.batch').css('display','none');
			$(this).parent().parent().find('.J_BatchField').css('display','none');
			$(this).html('批量操作');	
		}
	});
	
	/*运费规则单行复选框事件*/
	$('.J_BatchField').live('click',function(){
		if (!$(this).attr('checked')){
			obj_parent = $(this).parent().parent().parent().parent().parent().parent().parent();
			$(obj_parent).find('.J_BatchCheck').attr('checked',false);
		}else{
			obj_tbody = $(this).parent().parent().parent().parent();
			checkbox_count = $(obj_tbody).find('.J_BatchField').size();
			checked_count = $(obj_tbody).find('input:checked').size();
			if (checkbox_count == checked_count){
				obj_parent = $(this).parent().parent().parent().parent().parent().parent().parent();
				$(obj_parent).find('.J_BatchCheck').attr('checked',true);			
			}
		}
	});
	
	/*批量设置全选*/
	$('.J_BatchCheck').live('click',function(){
		$('.J_BatchField').attr('checked',$(this).attr('checked'));
	});
	
	/*批量设置弹出层*/
	$('.J_BatchSet').live('click',function(){
		if($('.tbl-except').find('input:checked').size()==0){
			alert('请选择要批量设置的地区');return false;
		}
		//定义当前的父级框，来区分是在EXPRESS,EMS,POST哪种弹出的
		curTrans = $(this).parent().parent();
		//定位弹出层的坐标
		var pos = $(this).position();
		var pos_x = pos.left-20;
		var pos_y = pos.top+20;
		$("#dialog_batch").css({'left' : pos_x, 'top' : pos_y,'position' : 'absolute','display' : 'block'});
		$('.ks-ext-mask').css('display','block');	
	});
	
	/*批量删除*/
	$('.J_BatchDel').live('click',function(){
		if($(this).parent().parent().find('.tbl-except').find('input:checked').size()==0){
			alert('请选择要批量处理的地区');return false;
		}
		if (!confirm('确认批量删除吗')){
			return false;
		}
		
		$(this).parent().parent().find('.tbl-except>table>tbody>tr').each(function(){
			if ($(this).find('.J_BatchField').attr('checked')){
				$(this).remove();
			}
		});
		if ($(this).parent().parent().find('table>tbody>tr').html() == null){
			$(this).parent().parent().parent().find('.batch').css('display','none');
			$(this).parent().parent().parent().find('.J_ToggleBatch').css('display','none');
			$(this).parent().parent().parent().find('.batch').next().find('span').css('display','none');		
		}else{
			curTransType = $(this).parent().prev().find('input[type="hidden"]').eq(0).attr('name').substring(6,8);
			//如果该配送方式，地区都不为空，隐藏地区的提示层
			isRemove = true;
			$('div[data-delivery="'+curTransType+'"]').find('input[type="hidden"]').each(function(){
				if ($(this).val()==''){
					isRemove = false;return false;
				}
			});
			if (isRemove == true){
				$('div[data-delivery="'+curTransType+'"]').find('span[error_type="area"]').css('display','none');
			}			
		}
		
	});
	
	/*批量设置页面提交事件*/
	$('.J_SubmitPL').live('click',function(){
		var obj_this = $(this).parent().parent(); 
		$(curTrans).find('.tbl-except>table>tbody>tr').each(function(){
			if ($(this).find('.J_BatchField').attr('checked')){
				$(this).find('input[data-field="start"]').val($(obj_this).find('input[data-field="start"]').val()).removeClass('input-error');
				$(this).find('input[data-field="postage"]').val($(obj_this).find('input[data-field="postage"]').val()).removeClass('input-error');
				$(this).find('input[data-field="plus"]').val($(obj_this).find('input[data-field="plus"]').val()).removeClass('input-error');
				$(this).find('input[data-field="postageplus"]').val($(obj_this).find('input[data-field="postageplus"]').val()).removeClass('input-error');
			}
		});
	    $("#dialog_batch").css('display','none');
	    $('.ks-ext-mask').css('display','none');	
	});
	
	/*保存运费模板*/
	$('#submit_tpl').click(function(){
		$('.J_SpecialMessage').html(SpecialMessage);
		$('.J_DefaultSet').find('.J_DefaultMessage').html(DefaultMessage);
		isSubmit = true;	
		$('.postage-tpl').each(function(){
			//如果复选框选中了，才判断
			if (!$(this).find('input[name="tplType[]"]').attr('checked')) return true;
			//首件跟续件由于有默认值，鼠标离开也有默认值，这里只需判断首费与续费即可

			//首费JS空判断-------------------------------
			father = this;
			//只判断已显示的，即只判断EMS、平邮、快递中已选择的内容
			var obj = $(this).find('.J_DefaultSet').find('input[data-field="postage"]');
			if($(obj).val() != 'undefined'){
				isShowError = false;
				if($(obj).val()==''){
					$(obj).addClass('input-error'); isShowError = true; isSubmit = false;
				}else{
					$(this).removeClass('input-error');
				}

				if (isShowError){
					$(this).find('.J_DefaultSet').find('span[error_type="postage"]').show();
				}				
			}
			//续费JS空判断-------------------------------
			//只判断已显示的，即只判断EMS、平邮、快递中已选择的内容
			var obj = $(this).find('.J_DefaultSet').find('input[data-field="postageplus"]');
			if($(obj).val() != 'undefined'){
				isShowError = false;
				if($(obj).val()==''){
					$(obj).addClass('input-error'); isShowError = true; isSubmit = false;
				}else{
					$(this).removeClass('input-error');
				}
				if (isShowError){
					$(this).find('.J_DefaultSet').find('span[error_type="postageplus"]').show();
				}				
			}
			//地区空判断-------------------------------
			//只判断已显示的，即只判断EMS、平邮、快递中已选择的内容
			if($(this).find('.tbl-except').find('.cell-area').html() != null){
				isShowError = false;
				$(this).find('.tbl-except').find('tr').each(function(){
					if($(this).find('input[type="hidden"]').val()==''){
						isShowError = true; isSubmit = false; return false;
					}
				});
				if (isShowError){
					$(father).find('.tbl-attach').find('span[error_type="area"]').css('display','');
				}
			}		
			//首费JS空判断-------------------------------
			//只判断已显示的，即只判断EMS、平邮、快递中已选择的内容
			if($(father).find('.tbl-except').find('.cell-area').html() != null){
				isShowError = false;
				$(this).find('.tbl-except').find('input[data-field="postage"]').each(function(){
					if ($(this).val()==''){
						$(this).addClass('input-error');isShowError = true; isSubmit = false;
					}
				});

				if (isShowError){
					$(father).find('.tbl-attach').find('span[error_type="postage"]').show();
				}
			}
			//续费JS空判断-------------------------------
			//只判断已显示的，即只判断EMS、平邮、快递中已选择的内容
			if($(father).find('.tbl-except').find('.cell-area').html() != null){
				isShowError = false;
				$(this).find('.tbl-except').find('input[data-field="postageplus"]').each(function(){
					if ($(this).val()==''){
						$(this).addClass('input-error'); isShowError = true; isSubmit = false;
					}
				});

				if (isShowError){
					$(father).find('.tbl-attach').find('span[error_type="postageplus"]').css('display','');
				}
			}			

		});

		//运费模板名称校验
		if ($('#title').val()==''){
			isSubmit = false;
			$('p[error_type="title"]').css('display','');
		}else{
			$('p[error_type="title"]').css('display','none');
		}
		//请至少选择一种运送方式
		i=0;
		$('input[name="tplType[]"]').each(function(){
			if (!$(this).attr('checked')){
				i++;
			}
		});
		if (i==3){
			isSubmit = false;
			$('p[error_type="trans_type"]').css('display','');			
		}
		if (isSubmit == true){
			var tranStr = getTranJsonStr();
			if(tranStr != ""){
				var title = $("[name=title]").val();
				var url = BASE_PATH + "/manager/shopTransport/addOrUpdate";
				var args = "";
				if(transportId == ""){
					args = {"title":title, "tranStr":tranStr};
				}else{
					args = {"title":title, "tranStr":tranStr, "transportId":transportId};
				}
				$.post(url, args, function(data){
					if(data){
						alert("保存成功");
						setTimeout("ok()",500);
					}else{
						alert("保存失败");
					}
				});
			}
			return false;
		}else{
			return false;
		}
	});
	//拼接字符串
	function getTranJsonStr(){
		var transportExtendListStr = "[";
		$("[name='tplType[]']:checked").each(function(x,v){
			//默认的运费
			var transportExtendDefStr = "{";
			var tranType = $(this).val();
			var $tranDiv = $("#"+tranType); 
			//默认运费
			var defStart = $("[name='default["+tranType+"][start]']").val();
			//默认起始价格
			var defPostage = $("[name='default["+tranType+"][postage]']").val();
			//每增加件数
			var defPlus = $("[name='default["+tranType+"][plus]']").val();
			//增加运费
			var defPostageplus = $("[name='default["+tranType+"][postageplus]']").val();
			transportExtendDefStr += "\"snum\":\"" + defStart + "\",\"sprice\":\"" + defPostage + "\",\"xnum\":\"" + defPlus + "\",\"xprice\":\"" + defPostageplus + "\"";
			transportExtendDefStr += "},";
			transportExtendListStr += transportExtendDefStr;
			//运费特例
			$tranDiv.find("[rulecellgroup]").each(function(x,y){
				var transportExtendOthStr = "{";
				var num = $(this).attr("rulecellgroup");
				var area = $(this).find("[name='areas["+tranType+"]["+num+"]']").val();
				var areaArr = area.split("|||");
				//地区id
				var areaId = "," + areaArr[0] + ",";
				//地区名字
				var areaName = areaArr[1];
				//运费
				var othStart = $("[name='special["+tranType+"]["+num+"][start]']").val();
				//起始价格
				var othPostage = $("[name='special["+tranType+"]["+num+"][postage]']").val();
				//每增加件数
				var othPlus = $("[name='special["+tranType+"]["+num+"][plus]']").val();
				//增加运费
				var othPostageplus = $("[name='special["+tranType+"]["+num+"][postageplus]']").val();
				transportExtendOthStr +="\"areaId\":\"" + areaId + "\",\"areaName\":\"" + areaName + "\",\"snum\":\"" + othStart + "\",\"sprice\":\"" + othPostage + "\",\"xnum\":\"" + othPlus + "\",\"xprice\":\"" + othPostageplus + "\"";
				transportExtendOthStr += "},";
				transportExtendListStr += transportExtendOthStr;
			});
		});
		if(transportExtendListStr != "["){
			transportExtendListStr = transportExtendListStr.substring(0,transportExtendListStr.length-1);
			return transportExtendListStr + "]";
		}else{
			return "";
		}
	}
});
function ok(){
	window.location.href = BASE_PATH + '/manager/shopTransport/toList';
}