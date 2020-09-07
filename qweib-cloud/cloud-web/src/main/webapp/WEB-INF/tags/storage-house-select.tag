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
<%@ attribute name="houseId" type="java.lang.String"
			  description="houseId" required="true"%>
<%@ attribute name="houseName" type="java.lang.String"
			  description="houseName" %>
<%@ attribute name="stkValue" type="java.lang.String"
			  description="stkValue" %>

<%@ attribute name="status" type="java.lang.String"
			  description="status" %>


	<input qwb-validate="required" qwb-role="combobox" id="${id}" value="${value}" onchange="loadHouseList()"
		   qwb-options="url: '${base}manager/getStorageList?saleCar=0&status=${status}',
						dataTextField: 'stkName',
						index: 0,
						clearButton:false,
						dataValueField: 'id',
						dataBound:function (){
						 $.ajaxSettings.async = false;
						loadHouseList();
						//qwb.ui.get('#${houseId}').value(${houseName});
						}
                                        "
		   style="width:140px !important;"
		   qwb-model="${id}"/>

	<input qwb-role="combobox" id="${houseId}" placeholder="库位" qwb-model="${houseId}"
		   style="width:140px !important;"
		   qwb-options="dataTextField: 'houseName',
						dataValueField: 'id'"
	>
<script>
	function loadHouseList(){
		var stkId = $("#"+'${id}').val();
		var stkName =qwb.ui.get("#${id}").k().text();
		qwb.ui.get("#${houseId}").value("");
		var w =  qwb.ui.get("#${houseId}").k();
		w.setDataSource({
			data:[]
		})
		if(houseId){
			$.ajax({
				url: "${base}/manager/stkHouse/dataList",
				type: "POST",
				data: {"stkId": stkId, "status": 1},
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
								qwb.ui.get("#${houseId}").value(tempId);
							}
						});
						// if(tempId==0){
						// 	qwb.ui.info("["+stkName+"]未设置临时库位，请<a href='javascript:toSetStorage()'>设置</a>");
						// }
					}
				}
			})
		}

	}

	/**
	 *  检查是否有临时库位
	 */
	<%--function checkStkTemp(){--%>
		<%--var houseId = $("#"+'${id}').val();--%>
		<%--var bool=false;--%>
		<%--$.ajax({--%>
			<%--url: "${base}/manager/getStorageList",--%>
			<%--type: "POST",--%>
			<%--data: {"houseId": houseId, "status": 1},--%>
			<%--dataType: 'json',--%>
			<%--async: false,--%>
			<%--success: function (json) {--%>
				<%--if (json.list != undefined) {--%>
					<%--$.map(json.list, function (data) {--%>
						<%--if(data.isTemp==1){--%>
							<%--bool = true;--%>
						<%--}--%>
					<%--});--%>
				<%--}--%>
			<%--}--%>
		<%--})--%>
		<%--return bool;--%>
	<%--}--%>

</script>


