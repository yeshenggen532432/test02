<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>付货款管理</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-card header">
		<div class="layui-card-body">
			<ul class="uglcw-query form-horizontal query">
				<li>
						<input type="hidden" uglcw-role="textbox" id="all" value="0">
						<input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}" id="sdate">
				</li>
				<li>
						<input uglcw-model="edate" uglcw-role="datepicker" value="${edate}" id="edate">
				</li>
				<li>
						<select uglcw-role="combobox" uglcw-model="outType" placeholder="出库类型">
							<option value="">全部</option>
							<option value="销售出库">销售出库</option>
							<option value="其它出库">其它出库</option>
						</select>
				</li>
				<li style="width: 300px;">
						<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
						<button id="searchAll" uglcw-role="button" class="k-button k-info">查询所有</button>
						<%--<button id="reset" class="k-button" uglcw-role="button">重置</button>--%>
				</li>
			</ul>
		</div>
	</div>
	<div class="layui-card">
		<div class="layui-card-body full">
			<div id="grid" uglcw-role="grid"
				 uglcw-options="
                    id:'id',
                    showHeader: false,
                    url: '${base}manager/queryRecStat',
                    criteria: '.query',
                    query: function(param){
						if(uglcw.ui.get('#all').value() == 1){
							param.sdate = '';
							param.edate = '';
							param.outType = '';
						}
						return param;
                    }

                    ">
				<div data-field="itemName1"></div>
				<div data-field="amt1"
					 uglcw-options="template: '<a style=\'color:blue;\' onclick=\'showStat(this);\'>#= uglcw.util.toString(data.amt1, \'n2\')#</a>'"></div>
				<div data-field="itemName2"></div>
				<div data-field="amt2"
					 uglcw-options="template: '<a style=\'color:blue;\' onclick=\'showStat(this);\'>#= uglcw.util.toString(data.amt2, \'n2\')#</a>'"></div>
			</div>
		</div>
	</div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#all').value(0);
			uglcw.ui.get('#grid').reload();
		});
		uglcw.ui.get('#searchAll').on('click', function () {
			uglcw.ui.get('#all').value(1);
			uglcw.ui.get('#grid').reload();
		});
		/*uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal');
		});*/
		uglcw.ui.loaded()
	});

	function showStat(a) {
		var row = uglcw.ui.get('#grid').k().dataItem($(a).closest('tr'));

		var amtType;
		if (row.itemName1 === '总收款') {
			amtType = 5;
		} else if (row.itemName1 === '核销') {
			amtType = 4;
		} else if (row.itemName1 == '现金') {
			amtType = 6;
		} else if (row.itemName1 == '银行卡') {
			amtType = 1;
		} else if (row.itemName1 == '微信') {
			amtType = 2;
		} else if (row.itemName1 == '支付宝') {
			amtType = 3;
		}else if (row.itemName1 == '无卡现金') {
			amtType = 7;
		}
		if(amtType!=''){
			if(amtType==6) amtType=0;
		}
		var query = uglcw.ui.bind('.query');
		if(uglcw.ui.get('#all').value() == 1){
			delete query['sdate']
			delete query['edate']
		}
		query.ioType = query.outType;
		query.amtType = amtType;
		uglcw.ui.openTab('客户收款统计', '${base}manager/toRecUnitStat?' + $.map(query, function (v, k) {
			return k + '=' + ((v == null || v==undefined) ? '': v);
		}).join('&'));
	}

</script>
</body>
</html>
