<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.k-i-success {
			color: green;
		}

		.k-i-error {
			color: red;
		}

		.k-grid td {
			padding-top: .5em;
			padding-bottom: .5em;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
	</style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="uglcw-layout-container">
		<div class="uglcw-layout-fixed" style="width: 200px;">
			<div class="layui-card">
				<%--<div class="layui-card-header">--%>
				<%--用户组名称--%>
				<%--</div>--%>
				<div class="layui-card-body full">
					<div uglcw-role="grid" id="grid1"
						 uglcw-options="
						 id:'id',
                        url: '${base}manager/pos/queryGroupList?page=1&rows=20'
                        "
					>
						<div data-field="groupName">用户组名称</div>
					</div>
				</div>
			</div>
			<div class="layui-card">
				<%--<div class="layui-card-header">--%>
				<%--用户组名称--%>
				<%--</div>--%>
				<div class="layui-card-body full">
					<div uglcw-role="grid" id="grid2"
						 uglcw-options="
						 id:'id',
                        url: '${base}manager/pos/getModuleList?page=1&rows=20'
                        "
					>
						<div data-field="moduleName">模块名称</div>
					</div>
				</div>
			</div>
		</div>
		<div class="uglcw-layout-content">
			<div class="form-horizontal query">
				<%--type="hidden"--%>

				<input type="hidden" uglcw-role="textbox" uglcw-model="groupId" id="groupId">
				<input type="hidden" uglcw-role="textbox" uglcw-model="moduleId" id="moduleId">
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
						    responsive:[40],
							toolbar: kendo.template($('#toolbar').html()),
							autoBind: false,
							editable: true,
							navigatable: true,
							id:'id',
							url: '${base}manager/pos/getFunctionList',
							criteria: '.query',
							pageable: true,
                    ">
						<div data-field="funcName" uglcw-options="schema:{editable: false}">功能名称</div>
						<div data-field="isCheck" uglcw-options="
                        schema:{type:'boolean'},
                        template: '<i class=\'k-icon #= data.isCheck ? \'k-i-success\' : \'k-i-error\'#\'></i>'
                        ">权限
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
	<a role="button" href="javascript:grant(1);" class="k-button k-info k-button-icontext">
		<span class="k-icon k-i-success"></span>全部授权
	</a>
	<a role="button" class="k-button k-button-icontext" href="javascript:grant(0);">
		<span class="k-icon k-i-error"></span>取消授权</a>
	<a role="button" class="k-button k-button-icontext" href="javascript:submit();">
		<span class="k-icon k-i-save"></span>提交
	</a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();
		//用户组名称
		uglcw.ui.get('#grid1').on('dataBound', function () {
			console.log('dataBound');
			uglcw.ui.get('#groupId').value(uglcw.ui.get('#grid1').bind()[0].id);
			setTimeout(function () {
				uglcw.ui.get('#grid1').k().select('tr:eq(0)');
			}, 200);
			uglcw.ui.get('#grid').reload();
		});
		var grid1 = uglcw.ui.get('#grid1').k();
		$('#grid1 tbody').on('click', 'tr', function (e) {
			var item = grid1.dataItem($(this));
			uglcw.ui.get('#groupId').value(item.id);
			// uglcw.ui.get('#moduleId').value('');
			uglcw.ui.get('#grid').reload();
		})

		//模块名称
		uglcw.ui.get('#grid2').on('dataBound', function () {
			uglcw.ui.get('#moduleId').value(uglcw.ui.get('#grid2').bind()[0].id);
			setTimeout(function () {
				uglcw.ui.get('#grid2').k().select('tr:eq(0)');
			}, 200);
			uglcw.ui.get('#grid').reload();
		});

		var grid2 = uglcw.ui.get('#grid2').k();
		$('#grid2 tbody').on('click', 'tr', function (e) {
			var item = grid2.dataItem($(this));
			// uglcw.ui.get('#groupId').value('');
			uglcw.ui.get('#moduleId').value(item.id);
			uglcw.ui.get('#grid').reload();
		})

		uglcw.ui.loaded();
	})


	//=========================================================
	//checkFlag:1全部授权；0：全部不授权
	function grant(checkFlag) {
		console.log("checkFlag:::"+checkFlag)

		uglcw.ui.confirm('确定提交吗？', function () {
			uglcw.ui.loading();
			var moduleId = $("#moduleId").val();
			var groupId = $("#groupId").val();
			var rows = uglcw.ui.get('#grid').bind();

			var rightList = new Array();
			if(checkFlag == '1'){
				for(var i=0;i<rows.length;i++){
					var menuId = rows[i].id;
					// var isCheck = rows[i].isCheck;
					var subObj = {
						groupId: groupId,
						funcId: menuId,
						isCheck: checkFlag,
					};
					rightList.push(subObj);
				}
			}

			$.ajax( {
				url : "${base}manager/pos/saveGroupRight",
				data : {"groupId":groupId,"moduleId":moduleId,"rightStr":JSON.stringify(rightList)},
				type : "post",
				success: function (response) {
					uglcw.ui.loaded();
					if (response.state) {
						uglcw.ui.success('提交成功');
						uglcw.ui.get('#grid').reload();
					} else {
						uglcw.ui.error('提交失败');
					}
				},
				error: function () {
					uglcw.ui.loaded();
				}
			});
		})

	}

	//打叉不提交数据
	function submit() {
		uglcw.ui.confirm('确定提交吗？', function () {
			uglcw.ui.loading();			uglcw.ui.loading();
			var moduleId = uglcw.ui.get('#moduleId').value();
			var groupId = uglcw.ui.get('#groupId').value();
			var rows = uglcw.ui.get('#grid').bind();
			// var data = $.map(rows, function (row) {
			// 	return {
			// 		groupId: groupId,
			// 		funcId: row.id,
			// 		isCheck: uglcw.util.toInt(row.isCheck),
			// 	}
			// })
			var rightList = new Array();
			for(var i=0;i<rows.length;i++){
				var menuId = rows[i].id;
				var isCheck = uglcw.util.toInt(rows[i].isCheck);
				if(isCheck == 1){
					var subObj = {
						groupId: groupId,
						funcId: menuId,
						isCheck: isCheck,
					};
					rightList.push(subObj);
				}
			}
			$.ajax( {
				url : "${base}manager/pos/saveGroupRight",
				data : {"groupId":groupId,"moduleId":moduleId,"rightStr":JSON.stringify(rightList)},
				type : "post",
				success: function (response) {
					uglcw.ui.loaded();
					if (response.state) {
						uglcw.ui.success('提交成功');
						uglcw.ui.get('#grid').reload();
					} else {
						uglcw.ui.error('提交失败');
					}
				},
				error: function () {
					uglcw.ui.loaded();
				}
			});
		})
	}

</script>
</body>
</html>
