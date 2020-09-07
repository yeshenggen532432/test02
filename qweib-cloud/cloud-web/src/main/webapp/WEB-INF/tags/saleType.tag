<%--出库类型--%>
<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="id" type="java.lang.String" 
	description="id" required="true"%>
<%@ attribute name="name" type="java.lang.String" 
	description="name" required="true"%>
<%@ attribute name="value" type="java.lang.String" 
	description="value" %>	
<%@ attribute name="onchange" type="java.lang.String" 
	description="onchange"%>
<%@ attribute name="onclick" type="java.lang.String" 
	description="onclick"%>
<%@ attribute name="headerKey" type="java.lang.String" 
	description="headerKey属性"%>
<%@ attribute name="headerValue" type="java.lang.String" 
	description="headerValue属性"%>	
<%@ attribute name="style" type="java.lang.String" 
	description="样式"%>	
<%@ attribute name="tclass" type="java.lang.String" 
	description="class"%>
<select id="${id}"  class="easyui-combobox"  data-options="valueField:'id',textField:'text',multiple:true,panelHeight:'auto'" >
</select>
<script>
	var outData=[
		{
			id:'正常销售',
			text:'正常销售'
		},
		{
			id:'促销折让',
			text:'促销折让'
		},
		{
			id:'消费折让',
			text:'消费折让'
		},
		{
			id:'费用折让',
			text:'费用折让'
		},
		{
			id:'其他销售',
			text:'其他销售'
		}
		,
		{
			id:'销售退货',
			text:'销售退货'
		}
	];
	var otherData=[
		{
			id:'其它出库',
			text:'其它出库'
		},
		{
			id:'报损出库',
			text:'报损出库'
		},
		{
			id:'借出出库',
			text:'借出出库'
		}
	];
	var otherData2=[
		{
			id:'其它出库',
			text:'其它出库'
		},
		{
			id:'报损出库',
			text:'报损出库'
		},
		{
			id:'借出出库',
			text:'借出出库'
		},
		{
			id:'移库出库',
			text:'移库出库'
		},
		{
			id:'组装出库',
			text:'组装出库'
		},{
			id:'拆卸出库',
			text:'拆卸出库'
		},
		{
			id:'领料出库',
			text:'领料出库'
		},
		{
			id:'盘亏',
			text:'盘亏'
		}
	];
</script>