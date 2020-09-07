<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="base" type="java.lang.String"
			  description="base" required="true"%>
<%@ attribute name="id" type="java.lang.String"
	description="id" required="true"%>
<%@ attribute name="name" type="java.lang.String"
	description="name" %>
<%@ attribute name="value" type="java.lang.String"
	description="value" %>
<%@ attribute name="style" type="java.lang.String"
			  description="value" %>
<%@ attribute name="stkId" type="java.lang.String"
			  description="stkId" required="true"%>
<%@ attribute name="stkName" type="java.lang.String"
			  description="stkName" %>
<%@ attribute name="stkValue" type="java.lang.String"
			  description="stkValue" %>
<div class="col-xs-3 qwb-grid-editable k-edit-cell">
<input qwb-validate="required" qwb-role="combobox" id="${id}" value="${value}" onchange="loadStorageList()"
	   qwb-options="url: '${base}manager/stkHouse/dataList',
						dataTextField: 'houseName',
						index: 0,
						clearButton:false,
						dataValueField: 'id',
						dataBound:function (){
						 $.ajaxSettings.async = false;
						loadStorageList();
						qwb.ui.get('#${stkId}').value(${stkValue});
						}
                                        " qwb-model="${id}"/>
</div>
	<div class="col-xs-3 qwb-grid-editable k-edit-cell">
	<%--qwb-options="url: '${base}manager/getStorageList',--%>
<%--dataTextField: 'stkName',--%>
<%--index: 0,--%>
<%--dataValueField: 'id'--%>
<input qwb-role="combobox" id="${stkId}" placeholder="库位" qwb-model="${stkId}"
	   qwb-options="dataTextField: 'stkName',
						dataValueField: 'id'"
>
</div>
<script>
	function loadStorageList(){
		var houseId = $("#"+'${id}').val();
		var houseName =qwb.ui.get("#${id}").k().text();
		qwb.ui.get("#${stkId}").value("");
		var w =  qwb.ui.get("#${stkId}").k();
		w.setDataSource({
			data:[]
		})
		if(houseId){
			$.ajax({
				url: "${base}/manager/getStorageList",
				type: "POST",
				data: {"houseId": houseId, "status": 1},
				dataType: 'json',
				async: false,
				success: function (json) {
					if (json.list != undefined) {
						console.log(json);
						w.setDataSource({
							data:json.list
						})
						//w.select(0);
						var tempId = 0;
						$.map(json.list, function (data) {
							if(data.isTemp==1){
								tempId = data.id;
								qwb.ui.get("#${stkId}").value(tempId);
							}
						});

						if(tempId==0){
							qwb.ui.info("["+houseName+"]未设置临时库位，请<a href='javascript:toSetStorage()'>设置</a>");
						}
					}
				}
			})
		}

	}

	/**
	 *  检查是否有临时库位
	 */
	function checkStkTemp(){
		var houseId = $("#"+'${id}').val();
		var bool=false;
		$.ajax({
			url: "${base}/manager/getStorageList",
			type: "POST",
			data: {"houseId": houseId, "status": 1},
			dataType: 'json',
			async: false,
			success: function (json) {
				if (json.list != undefined) {
					$.map(json.list, function (data) {
						if(data.isTemp==1){
							bool = true;
						}
					});
				}
			}
		})
		return bool;
	}

	function toSetStorage() {
		//querybasestk
		qwb.ui.openTab('库位列表', '${base}manager/querybasestk');
	}
</script>


