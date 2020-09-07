<%@ page language="java" pageEncoding="UTF-8" %>
<%--头部点击,表格出现编辑功能05-14 zzx 参考http://localhost:8080/manager/shopWareGroup/toPage
1.<%@include file="/WEB-INF/view/v2/include/edit-kendo.jsp" %> 引入文件
2.<div data-field="sort" uglcw-options="
								width:120,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '排序',field:'sort'}),//调用头部模版,参数titlt:显示名称,field:列名称
								template:function(row){
									return uglcw.util.template($('#data_edit_template').html())({value:row.sort, id:row.id, field:'sort',callback:'function'})//调用数据模版,参数value:当前列数据,id主键区分每列标识,field:列名称和头部名称一致,callback:回调方法默认callChangeFun
								}
								">
						</div>
3.callChangeFun(value,field ,id)//页面重写回调方法,value:修改后的值,field:列名称,id:主键ID,this:本身对象
--%>
<%--编辑头部模版--%>
<script id="header_edit_template" type="text/x-uglcw-template">
    <span onclick="javascript:headClickFun('#=field#');">#= title#✎</span>
</script>
<%--编辑数据模版--%>
<script id="data_edit_template" type="text/x-uglcw-template">
    # if(type == null || type == undefined || type === '' || type== "undefined"){ #
    #    var type = "text" #
    # } #
    # if(tipText == null || tipText == undefined || tipText === '' || tipText== "undefined"){ #
    #    var tipText = "" #
    # } #
    # if(value == null || value == undefined || value === '' || value== "undefined"){ #
    #    var value = "" #
    # } #
    # if(callback == null || callback == undefined || callback === '' || callback== "undefined"){ #
    #    var callback = "" #
    # } #
    # if(dataSource == null || dataSource == undefined || dataSource === '' || dataSource== "undefined"){ #
    #    var dataSource = {} #
    # } #
    # dataSource=encodeURI(JSON.stringify(dataSource)); #
    <input class="#=field#_input k-textbox" id="#=field#_input_#=id#" name="#=field#_input" type="#=type#"
           style="height:25px;display:none; #if(tipText){#width:80%;#}#"
           onchange="editChangeFun(this.value,'#= field #',#=id #,'#=callback#','#=dataSource#')" value='#= value #'>
    <span class="#=field#_span" id="#=field#_span_#=id#" title="#=value#">#=value #</span>
    #if(tipText){#
        <span class="rate_org_rate" id="#=field#_spanTip_#=id#" style="color:green">(#=tipText #)</span>
    #}#
</script>

<%--编辑下拉框数据模版--%>
<script id="data_select_template" type="text/x-uglcw-template">
    # if(value == null || value == undefined || value === '' || value== "undefined"){ #
    #    var value = "" #
    # } #
    # if(callback == null || callback == undefined || callback === '' || callback== "undefined"){ #
    #    var callback = "" #
    # } #
    # if(options == null || options == undefined || options === '' || options== "undefined"){ #
    #    var options = [] #
    # } #
    # if(dataSource == null || dataSource == undefined || dataSource === '' || dataSource== "undefined"){ #
    #    var dataSource ={} #
    # } #
    # dataSource=encodeURI(JSON.stringify(dataSource)); #
    #var text='';#
    <span class="#=field#_input" style="display:none">
        <select id="#=field#_select_#=id#" uglcw-role="combobox"
                uglcw-options="clearButton:false,value:#=value#, change: function(){ editChangeFun(this.value(), '#= field#', '#= id#', '#= callback#','#=dataSource#',this) }">
            # for(var i=0; i<options.length; i++){#
            # var o = options[i] #
            # if(o.value==value)text=o.text;#
            <option value="#=o.value#"> #=o.text#</option>
            #}#
        </select>
    </span>
    <span class="#=field#_span" id="#=field#_span_#=id#">#= text#</span>
</script>

<script>
    //头部点击事件
    function headClickFun(field) {
        var display = $("." + field + "_input").css('display');
        if (display == 'none') {
            $("." + field + "_input").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").hide();
            $("." + field + "_span").show();
        }
    }

    function editChangeFun(value, field, id, callback, dataSource, th) {
        if (th) {
            dataSource = JSON.parse(decodeURI(dataSource));
            dataSource.optionText = th.text();
            dataSource = encodeURI(JSON.stringify(dataSource));
        }
        if (callback) {
            window[callback](value, field, id, dataSource,function () {
                callSuccessFun(value, field, id);
            });
        }
        //else
        //    callChangeFun(value,field ,id,dataSource);
    }

    <%--   //数据修改回调方法
       function callChangeFun(value,field ,id) {
           if(value&&isNaN(value)){
               uglcw.ui.error("请输入正整数");
               return;
           }
           $.ajax({
               url: "manager/shopWareGroup/updateBase",
               type: "post",
               data: "id=" + id + "&sort=" + value,
               success: function (data) {
                   if (data.state) {
                       callSuccessFun(value,field,id);
                   } else {
                       uglcw.ui.error(data.msg);
                   }
               }
           });
       }--%>
    //成功修改后回调
    function callSuccessFun(value, field, id) {
        $("#" + field + "_span_" + id).text(value);
    }

    //下拉成功修改后回调
    /* function callSelectSuccessFun(value,field,id,options) {
         var text='';
         $.each(options,function(i,item){
             if(item.value==value){text=item.text;return;}
         });
         callSuccessFun(text,field,id)
     }*/
    //成功修改后回调
    /*function callSelectSuccessFun(value,field,id,th) {
        $("#"+field+"_span_"+id).text(th.text);
    }*/
</script>
