<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<style type="text/css">
			.divDel{
				position: relative;
				width:200px;
				height:160px;
				margin:15px 0px 5px;
			}
			.imgDel{
				width:20px;
				height:20px;
				position: absolute;
				right: 5px;
				top: 5px;
			}
			.left_title{width:180px; display:inline-block; text-align:left; padding-left:30px}
		</style>
		<script>
			var showAllDesc = '${permission:checkUserButtonPdm("qwb.sysCustomer.showAllDesc")}';
		</script>
	</head>
	<body>

  			<form action="manager/opercustomer" name="customerfrm" id="customerfrm" method="post" enctype="multipart/form-data">
  			    <input type="hidden" name="id" id="id" value="${customer.id}"/>
  			    <input type="hidden" name="khTp" id="khTp" value="2"/>
  			    <input type="hidden" name="khPid" id="khPid" value="${customer.khPid}"/>
  			    <input type="hidden" name="shMid" id="shMid" value="${customer.shMid}"/>


  			    <input type="hidden" name="longitude" id="longitude" value="${customer.longitude}"/>
  			    <input type="hidden" name="latitude" id="latitude" value="${customer.latitude}"/>
  			    <input type="hidden" name="memId" id="memId" value="${customer.memId}"/>
  			    <input type="hidden" name="branchId" id="branchId" value="${customer.branchId}"/>
  			    <input type="hidden" name="wlId" id="wlId" value="${customer.wlId}"/>

  			    <input type="hidden" name="jxsflNm" id="jxsflNm" value="${customer.jxsflNm}"/>
  			    <input type="hidden" name="jxsjbNm" id="jxsjbNm" value="${customer.jxsjbNm}"/>
  			    <input type="hidden" name="jxsztNm" id="jxsztNm" value="${customer.jxsztNm}"/>
  			    <input type="hidden" name="fman" id="fman" value="${customer.fman}"/>
  			    <input type="hidden" name="ftel" id="ftel" value="${customer.ftel}"/>
  			    <input type="hidden" name="fgqy" id="fgqy" value="${customer.fgqy}"/>
  			    <input type="hidden" name="nxse" id="nxse" value="${customer.nxse}"/>
  			    <input type="hidden" name="ckmj" id="ckmj" value="${customer.ckmj}"/>
  			    <input type="hidden" name="dlqtpl" id="dlqtpl" value="${customer.dlqtpl}"/>
  			    <input type="hidden" name="dlqtpp" id="dlqtpp" value="${customer.dlqtpp}"/>
				<input type="hidden" name="rzMobile" value="${customer.rzMobile}"/>
				<input type="hidden" name="rzState" value="${customer.rzState}"/>
  			    <input type="hidden" name="page" id="pageNo" value="${page}"/>
				<div id="easyTabs" class="easyui-tabs">
				<div title="客户信息" style="font-size: 13px" >
					<div class="box" >
						<dl id="dl1" style="font-size: 13px">
						<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;  ">
							<legend  style="border:0px;background-color:white; font-size: 13px;color:teal;">一、客户基本信息</legend>
							<dd >
								<span class="left_title">1.客户编码：</span>
								<input class="reg_input" name="khCode" id="khCode" value="${customer.khCode}" style="width: 125px"/>
							</dd>
							<dd >
								<span class="left_title">2.客户名称：</span>
								<input class="reg_input" name="khNm" id="khNm" value="${customer.khNm}" style="width: 125px" placeholder="必填"/>
							</dd>
							<dd >
								<span class="left_title">3.客户助记码：</span>
								<input class="reg_input" name="py" id="py" value="${customer.py}" style="width: 125px" />
							</dd>
							<dd >
								<span class="left_title">4.客户类型：</span>
								<select class="reg_input" name="qdtypeId" id="qdtypeId" style="width: 125px;" onchange="arealist3();"></select>（企业内部分类）
							</dd>
							<dd >
								<span class="left_title">5.客户负责人：</span>
								<input class="reg_input" name="linkman" id="linkman" value="${customer.linkman}" style="width: 125px"/>
							</dd>

							<dd ><span class="left_title">6.客户联系方式</span></dd>
							<dd style="padding-left: 40px">
									<table style="width: 600px" id="tcmx">
										<tr  style="height: 30px;">
											<td align="right" style="padding-right: 5px">(1)客户负责人手机：
												<input class="reg_input" name="mobile" id="mobile" value="${customer.mobile}" style="width: 125px" placeholder="必填"/>
											</td>
											<td align="right" style="padding-right: 5px">(3)客户QQ号：
												<input class="reg_input" name="qq" id="qq" value="${customer.qq}" style="width: 125px"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											</td>
										</tr>
										<tr  style="height: 30px;">
											<td align="right" style="padding-right: 5px">(2)客户负责人固定电话：<input class="reg_input"name="tel" id="tel" value="${customer.tel}" style="width: 125px"/></td>
											<td align="right" style="padding-right: 5px">(4)客户微信号：<input class="reg_input" name="wxCode" id="wxCode" value="${customer.wxCode}" style="width: 125px"/>
												<span class="title" style="display: none">手机支持彩信：</span>
												<input class="reg_input" name="mobileCx" type="hidden" id="mobileCx" value="${customer.mobileCx}" style="width: 125px"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
										</tr>
									</table>
							</dd>
							<dd>
								<span class="left_title">7.客户地址</span></dd>
							<dd style="padding-left: 40px">
									<table style="width: 600px;" id="khaddress">
										<tr  style="height: 30px;">
											<td align="right" style="padding-right: 5px">
												(1)客户法定地址：<input  class="reg_input" name="lawAddress" id="lawAddress" value="${customer.lawAddress}"／>
											</td>
											<td align="right" style="padding-right: 5px">
												(3)客户送货地址：<input  class="reg_input" name="address" id="address" value="${customer.address}"></input>
												<input type="button" value="标注" onclick="javascript:showMap();"/>
											</td>
										</tr>
										<tr  style="height: 30px;">
											<td align="right" style="padding-right: 5px">
												(2)客户常用地址：
												<input  class="reg_input" name="oftenAddress" id="oftenAddress" value="${customer.oftenAddress}"／>
											</td>
											<td align="right" style="padding-right: 5px">
												(4)客户送地址2：
												<input  class="reg_input" name="sendAddress2" id="sendAddress2" value="${customer.sendAddress2}"／>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											</td>
										</tr>
									</table>
							</dd>
							<dd >
								<span class="left_title">8.社会信用统一代码：</span>
								<input name="uscCode" class="reg_input" style="width: 200px" id="uscCode" value="${customer.uscCode}"/>
							</dd>
							<dd >
								<span class="left_title">9.客户所属行业：</span>
								<input name="industryId" class="reg_input" style="width: 200px" type="hidden" id="industryId" value="${customer.industryId}"/>
								<input name="industryNm" class="reg_input" style="width: 200px" id="industryNm" value="${customer.industryNm}"/>(工商行业所属设定 平台的行业基础数据)
							</dd>

							<dd >
								<span class="left_title">10.客户位置：</span>
								经度：${customer.longitude}&nbsp;&nbsp;&nbsp;&nbsp;纬度:${customer.latitude}
							</dd>
							<dd >
								<span class="left_title">11.是否有效：</span>
								<input type="checkbox" name="isYx" id="isYx1" value="1" checked="checked"/>
							</dd>
							<dd >
								<span class="left_title">12.开户日期：</span>
								<input name="openDate" class="reg_input" id="openDate" value="${customer.openDate}" onClick="WdatePicker();" style="width: 110px;" readonly="readonly"/>
								<img onclick="WdatePicker({el:'openDate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
							</dd>
							<dd >
								<span class="left_title">13.闭户日期：</span>
								<input name="closeDate" class="reg_input" id="closeDate" value="${customer.closeDate}" onClick="WdatePicker();" style="width: 110px;" readonly="readonly"/><img onclick="WdatePicker({el:'closeDate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
							</dd>
							<dd >
								<span class="left_title">14.是否开户：</span>
								<input type="checkbox" name="isOpen" id="isOpen1" value="1" checked="checked"/>
							</dd>

							<dd >
								<span class="left_title">15.省：</span>
								<input name="province" class="reg_input" id="province" value="${customer.province}" style="width: 125px" readonly="readonly"/>
							</dd>
							<dd >
								<span class="left_title">16.城市：</span>
								<input name="city" class="reg_input" id="city" value="${customer.city}" style="width: 125px" readonly="readonly"/>
							</dd>
							<dd >
								<span class="left_title">17.区县：</span>
								<input name="area" class="reg_input" id="area" value="${customer.area}" style="width: 125px" readonly="readonly"/>
							</dd>
							<dd >
								<span class="left_title">18.备注：</span>
								<textarea rows="6" cols="68" name="remo" id="remo">${customer.remo}</textarea>
								<input type="hidden" value="设置价格" class="c_button" onclick="setTranPrice();"/>
								<input type="hidden" value="设置单位提成费用" class="c_button" onclick="setTcPrice();"/>
							</dd>
						</fieldset>

					<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;  ">
						<legend  style="border:0px;background-color:white; font-size: 13px;color:teal;">二、客户合作信息</legend>

						<dd>
							<span class="left_title">1.客户状态：</span>
							<select name="isDb" id="isDb">
							<option value="">全部</option>
							<option value="2" selected="selected">正常</option>
							<option value="1">倒闭</option>
							<option value="3">可恢复</option>
							</select>
							<script >
								$("#isDb").val(${customer.isDb});
							</script>
						</dd>
						<dd>
							<span class="left_title">2.客户合作方式：</span>
							<select name="hzfsNm" id="hzfsNm" style="width: 125px;">
								<option value="">请选择</option>
								<c:forEach items="${hzfsls}" var="hzfsls">
									<option value="${hzfsls.hzfsNm}" <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
								</c:forEach>
							</select>
						</dd>
						<dd>
							<span class="left_title">3.市场类型：</span>
							<select name="sctpNm" id="sctpNm" style="width: 125px;">
								<option value="">请选择</option>
								<c:forEach items="${sctypels}" var="sctypels">
									<option value="${sctypels.sctpNm}" <c:if test="${sctypels.sctpNm==customer.sctpNm}">selected</c:if>>${sctypels.sctpNm}</option>
								</c:forEach>
							</select>
						</dd>
						<dd >
						<span class="left_title">4.销售阶段：</span>
						<select name="xsjdNm" id="xsjdNm" style="width: 125px;">
							<option value="">请选择</option>
							<c:forEach items="${xsphasels}" var="xsphasels">
								<option value="${xsphasels.phaseNm}" <c:if test="${xsphasels.phaseNm==customer.xsjdNm}">selected</c:if>>${xsphasels.phaseNm}</option>
							</c:forEach>
						</select>
						</dd>
						<dd>
							<span class="left_title">5.供货类型：</span>
							<select name="ghtpNm" id="ghtpNm" style="width: 125px;">
								<option value="">请选择</option>
								<c:forEach items="${ghtypels}" var="ghtypels">
									<option value="${ghtypels.ghtpNm}" <c:if test="${ghtypels.ghtpNm==customer.ghtpNm}">selected</c:if>>${ghtypels.ghtpNm}</option>
								</c:forEach>
							</select>
						</dd>

						<dd >
							<span class="left_title">6.供货经销商：</span>
							<input name="pkhNm" id="pkhNm" value="${customer.pkhNm}" style="width: 100px" readonly="readonly"/>
							<input type="button" value="选择" onclick="javascript:choicecustomer();"/>
						</dd>
						<dd >
							<span class="left_title">7.客户归属片区：</span>
							<select id="regioncomb" class="easyui-combotree" style="width:200px;"
									data-options="url:'manager/sysRegions',animate:true,dnd:true,onClick: function(node){
							setRegion(node.id);
							}"></select>
							<input type="hidden" name="regionId" id="regionId" value="${customer.regionId}"/>
						</dd>
						<dd>
							<span class="left_title">8.客户负责业务员：</span>
							<input name="memberNm" id="memberNm" class="reg_input" value="${customer.memberNm}" style="width: 125px" readonly="readonly" placeholder="必填"/>
							<input type="button" value="选择" onclick="javascript:choicemember();"/>
						</dd>
						<dd >
							<span class="left_title">9.客户原始开发的业务员：</span>
							<input name="orgEmpId" id="orgEmpId" class="reg_input" value="${customer.orgEmpId}" type="hidden" />
							<input name="orgEmpNm" id="orgEmpNm" class="reg_input" value="${customer.orgEmpNm}" style="width: 125px" readonly="readonly" />
						</dd>
						<dd >
							<span class="left_title">10.客户创建日期：</span>
							<input name="createTime" id="createTime" value="${customer.createTime}"/>
						</dd>
						<dd >
							<span class="left_title">11.客户等级：</span>
							<select name="khlevelId" id="khlevelId" style="width: 125px;"></select>
						</dd>

						<dd >
							<span class="left_title">12.客户销售区域：</span>
							<input name="jyfw" class="reg_input" id="jyfw" value="${customer.jyfw}"/>
						</dd>
						<dd >
							<span class="left_title">13.客户归属公司部门：</span>
							<input name="branchName" id="branchName" value="${customer.branchName}" style="width: 125px" readonly="readonly"/>
						</dd>
					</fieldset>

						<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;  " >
							<legend  style="border:0px;background-color:white; font-size: 13px;color:teal;">三、合作要素操作</legend>
							<dd >
								<span class="left_title">1.是否二批：</span>
								<input type="checkbox" name="isEp" id="isEp" value="1" checked="checked"/>
							</dd>
							<dd >
								<span class="left_title">2.所属二批：</span>
								<input type="hidden"  name="epCustomerId" id="epCustomerId" value="${customer.epCustomerId }"/>
								<input name="epCustomerName" class="reg_input" id="epCustomerName" value="${customer.epCustomerName}" style="width: 125px" readonly="readonly"/>
								<input type="button" value="选择" onclick="javascript:choiceEpCustomer();"/>
							</dd>
							<dd >
								<span class="left_title">3.审核状态：</span>
								<input readonly="readonly" class="reg_input" name="shZt" id="shZt" value="${customer.shZt}" style="width: 125px" readonly="readonly"/>
							</dd>
							<dd >
								<span class="left_title">4.审核日期：</span>
								<input readonly="readonly" class="reg_input" name="shTime" id="shTime" value="${customer.shTime}"/>
							</dd>
							<dd >
								<span class="left_title">5.审核人：</span>
								<input readonly="readonly" class="reg_input" name="shMemberNm" id="shMemberNm" value="${customer.shMemberNm}"/>
							</dd>
							<span class="left_title">6.拜访频次：</span>
							<select name="bfpcNm" id="bfpcNm" style="width: 125px;">
								<option value="">请选择</option>
								<c:forEach items="${bfpcls}" var="bfpcls">
									<option value="${bfpcls.pcNm}" <c:if test="${bfpcls.pcNm==customer.bfpcNm}">selected</c:if>>${bfpcls.pcNm}</option>
								</c:forEach>
							</select>
							</dd>
					</fieldset>

						<c:if test="${not empty customer.id}">
							<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;  "  class="showClass">
								<legend  style="border:0px;background-color:white; font-size: 13px;color:teal;">四、销售政策设定</legend>
								(一)
								<dd >
									<span class="left_title">1.商品销售价：</span>
									<a href="javascript:;;" onclick="setWarePrice()">查看</a>
								</dd>
								<dd >
									<span class="left_title">2.营销费用设置：</span>
									<a href="javascript:;;" onclick="setAutoPrice()">查看</a>（1.按量计价：单价或百分比 也可以考虑时间区间 2.按营业额 3.固定费用投入 按固定时间设定投入）
								</dd>
								(二)自营商城模块
								<dd >
									<span class="left_title">1.自营商城商品销售价：</span>
									___________________
								</dd>
								<dd >
									<span class="left_title">2.自营商城营销费用设定：</span>
									___________________
								</dd>
								(三)平台商城模块
								<dd >
									<span class="left_title">1.平台商城商品销售价：</span>
									___________________
								</dd>
								<dd >
									<span class="left_title">2.平台商城营销费用设定：</span>
									___________________
								</dd>
								(四)门店模块
								<dd >
									<span class="left_title">1.门店商品销售价：</span>
									___________________
								</dd>
								<dd >
									<span class="left_title">2.门店营销费用设定：</span>
									___________________
								</dd>
							</fieldset>
						</c:if>
						</dl>
					</div>
				</div>
					<!-- ================= 图片开始=================== -->
					<div title="客户附件" style="overflow:auto;padding:20px;">
						<dl id="dl2">
							<c:if test="${empty customer.customerPicList}">
								<dd id="ddphoto1">
									<div class="divDel">
										<img id="photoImg21" alt="" style="width: 200px;height: 160px;" src="resource/images/login_bg.jpg" >
										<img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows(1);"/>
									</div>
									<div id="editDiv2" >
										<input type="file" accept="image/*" name="file21" id="file21" onchange="showPictrue(1)"  class="uploadFile"/>
									</div>
								</dd>
							</c:if>

							<c:if test="${!empty customer.customerPicList}">
								<c:forEach items="${customer.customerPicList}" var="item" varStatus="s">
									<dd id="ddphoto${s.index+1}">
										<input type="hidden" name="subId" id="subId${s.index+1}" value="${item.id}"/>
										<c:set var="subIds" value="${subIds},${item.id },"/>
										<div class="divDel">
											<c:if test="${!empty item.pic}">
												<img id="photoImg2${s.index+1}" alt=""   style="width: 200px;height: 160px;" src="upload/${item.pic}"/>
											</c:if>
											<c:if test="${empty item.pic}">
												<img id="photoImg2${s.index+1}" alt=""   style="width: 200px;height: 160px;" src="resource/images/login_bg.jpg"/>
											</c:if>
											<img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows('${s.index+1}');"/>
										</div>

										<div id="editDiv${s.index+1}" >
											<a class="easyui-linkbutton" iconcls="icon-edit" href="javascript:void(0);" onclick="modifyRows('${s.index+1}');">编辑</a>
										</div>
									</dd>
								</c:forEach>
							</c:if>
						</dl>
						<dd style="margin:20px 0px;">
							<a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加图片</a>
						</dd>
					</div>
					<!-- ================= 图片结束=================== -->
				</div>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>

	  		</form>

		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;"
			 minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
	</body>
</html>

		<script type="text/javascript">
		    function toSubmit(){
		        var khNm=$("#khNm").val();
				khNm = $.trim(khNm);
				$("#khNm").val(khNm);
		        var memberNm=$("#memberNm").val();
		        var mobile=$("#mobile").val();
		        if(!khNm){
		           alert("客户名称不能为空");
		           return;
		        }
		        if(!memberNm){
		           alert("业务员不能为空");
		           return;
		        }
		        if(!mobile){
		           alert("手机不能为空");
		           return;
		        }
				$("#customerfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("添加成功");
								toback();
							}else if(data=="2"){
								alert("修改成功");
								toback();
							}else if(data=="-2"){
								alert("该客户编码已存在");
								return;
							}else if(data=="-3"){
								alert("该客户名称已存在");
								return;
							}else{
								alert("操作失败");
							}
						}
				});
			}
			function toback(){
				//location.href="${base}/manager/querycustomer2?page=" + $("#pageNo").val();
				window.parent.$('#editdlg').dialog('close');
				/*window.parent.reloadCustomer();*/
			}

			$(function(){
			    var isYx="${customer.isYx}";
			    var id="${customer.id}";
			    if(isYx==1){
			      document.getElementById("isYx1").checked=true;
			    }else{
			      if(id){
			         document.getElementById("isYx1").checked=false;
			      }
			    }
				var isOpen="${customer.isOpen}";
			    if(isOpen==1){
			      document.getElementById("isOpen1").checked=true;
			    }else{
			      if(id){
			        document.getElementById("isOpen1").checked=false;
			      }
			    }
			    var isEp="${customer.isEp}";
			    if(isEp==1){
				      document.getElementById("isEp").checked=true;
				    }else{
				      if(id){
				        document.getElementById("isEp").checked=false;
				      }
				    }
				$('#regioncomb').combotree('setValue', '${customer.regionNm}');
			    arealist1();
				arealist2();
			});
			//选择业务员
			function choicemember(){
				document.getElementById("windowifrm").src="manager/querychoicemember";
				showWindow("选择业务员");
			}
			//设置业务员
			function setMember(memberId,branchId,memberNm,branchName){
			   $("#memId").val(memberId);
			   $("#branchId").val(branchId);
			   $("#memberNm").val(memberNm);
			   $("#branchName").val(branchName);
			   $("#choiceWindow").window('close');
			}
			//选择经销商
			function choicecustomer(){
				document.getElementById("windowifrm").src="manager/choicecustomer1";
				showWindow("选择经销商");
			}
			//选择二批客户
			function choiceEpCustomer(){
				document.getElementById("windowifrm").src="manager/choiceEpCustomer";
				showWindow("选择二批客户");
			}
			function setEpCustomer(id,khNm){
				   $("#epCustomerId").val(id);
				   $("#epCustomerName").val(khNm);
				   $("#choiceWindow").window('close');
			}
			//设置物经销商
			function setCustomer(id,khNm){
			   $("#khPid").val(id);
			   $("#pkhNm").val(khNm);
			   $("#choiceWindow").window('close');
			}
			//选择渠道类型
			function choiceQdtype(){
				document.getElementById("windowifrm").src="manager/choiceQdtype";
				showWindow("选择渠道类型");
			}
			//设置渠道类型
			function setQdtype(id,qdtpNm){
			   $("#qdtpNm").val(qdtpNm);
			   $("#choiceWindow").window('close');
			}
			//显示地图
			function showMap(){
				var city = $("#city").val();
				var oldLng = $("#longitude").val();
				var oldLat = $("#latitude").val();
				var zoom = $("#zoom").val();
				var address = $("#address").val();
				document.getElementById("windowifrm").src="${base}/manager/getmap?oldLng="+oldLng+"&oldLat="+oldLat+"&zoom="+zoom+"&searchCondition="+address+"&city="+city;
				showWindow("标注(提示：右键选择获取标注。)");
			}
			//设置标注
			function setCoordinate(longitude,latitude,zoom,province,city,area){
			    $("#longitude").val(longitude);
				$("#latitude").val(latitude);
				$("#province").val(province);
				$("#city").val(city);
				$("#area").val(area);
				$("#choiceWindow").window('close');
			}
			//显示弹出窗口
			function showWindow(title){
				$("#choiceWindow").window({
					title:title,
					top:getScrollTop()+50
				});
				$("#choiceWindow").window('open');
			}
			//获取上级
			function arealist1(){
			var qdtypeId="${customer.qdtypeId}";
				$.ajax({
					url:"manager/queryarealist1",
					type:"post",
					success:function(data){
						if(data){
						   var list = data.list1;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						      if(list[i].qdtpNm!=''){
						        if(list[i].id==qdtypeId){
						          img +='<option value="'+list[i].id+'" selected="selected">'+list[i].qdtpNm+'</option>';
						        }else{
						           img +='<option value="'+list[i].id+'">'+list[i].qdtpNm+'</option>';
						        }
						       }
						    }
						   $("#qdtypeId").html(img);
						 }
					}
				});
			}
			//获取下级(修改的时候刚进来调)
			function arealist2(){
			    var qdtypeId="${customer.qdtypeId}";
			    var khlevelId="${customer.khlevelId}";
				$.ajax({
					url:"manager/queryarealist2",
					type:"post",
					data:"qdtypeId="+qdtypeId,
					success:function(data){
						if(data){
						   var list = data.list2;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						       if(list[i].id==khlevelId){
						           img +='<option value="'+list[i].id+'" selected="selected">'+list[i].khdjNm+'</option>';
						        }else{
						           img +='<option value="'+list[i].id+'">'+list[i].khdjNm+'</option>';
						        }
						    }
						   $("#khlevelId").html(img);
						 }
					}
				});
			}
			//获取下级
			function arealist3(){
			    var qdtypeId=$("#qdtypeId").val();
			    var khlevelId='';
			    $.ajax({
					url:"manager/queryarealist2",
					type:"post",
					data:"qdtypeId="+qdtypeId,
					success:function(data){
						if(data){
						   var list = data.list2;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						       if(list[i].id==khlevelId){
						           img +='<option value="'+list[i].id+'" selected="selected">'+list[i].khdjNm+'</option>';
						        }else{
						           img +='<option value="'+list[i].id+'">'+list[i].khdjNm+'</option>';
						        }
						    }
						   $("#khlevelId").html(img);
						 }
					}
				});
			}

			function setWarePrice() {
					window.parent.parent.add("${customer.khNm}-设置商品销售价","manager/customerwaretype?customerId=${customer.id}&op=1");
			}

			function setAutoPrice(){
				window.parent.parent.add("${customer.khNm}-设置营销费用","manager/autopricecustomerwaretype?customerId=${customer.id}");
			}
			//*************************图片相关：开始******************************************
			//显示图片
			function showPictrue(n){
				console.log("showPictrue:"+n);
				var r= new FileReader();
				f=document.getElementById("file2"+n).files[0];
				r.readAsDataURL(f);
				r.onload=function  (e) {
					document.getElementById('photoImg2'+n).src=this.result;
				}
				//修改时记录要删除的图片id
				if(Number(len)>=Number(n)){
					var picId = $("#subId"+n).val();
					console.log("picId:"+picId);
					if(picId!=null && picId!=undefined && picId!=""){
						//记录删除的图片id
						if(delPicIds==""){
							delPicIds=""+picId;
						}else{
							delPicIds+=","+picId;
						}
						console.log(delPicIds);
					}
				}
			}

			//添加照片
			var index="${len}";
			var len="${len}";//记录个数
			function addRows(obj){
				index++;
				var strs = "<dd id=\"ddphoto"+index+"\">";
				strs+="<span class=\"title\">";
				strs+="<div class=\"divDel\">";
				strs+="<img id=\"photoImg2"+index+"\" alt=\"\" style=\"width: 200px;height: 160px;\" src=\"resource/images/login_bg.jpg\" />";
				strs+="<img class=\"imgDel\" src=\"resource/shop/mobile/images/delete_1.png\" onclick=\"deleteRows('"+index+"');\" />"
				strs+="</div>";
				strs+="<div id=\"editDiv"+index+"\">";
				strs+="<input type=\"file\" accept=\"image/*\" name=\"file2"+index+"\" id=\"file2"+index+"\" onchange=\'showPictrue("+index+")\'  class=\"uploadFile\"/>";
				strs+="</div>";
				strs+="</dd>";
				$("#dl2").append(strs);
			}

			//删除照片
			var delPicIds="";
			function deleteRows(c){
				var picId = $("#subId"+c).val();
				if(picId!=null && picId!=undefined && picId!=""){
					//记录删除的图片id
					if(delPicIds==""){
						delPicIds=""+picId;
					}else{
						delPicIds+=","+picId;
					}
				}
				var ddphoto = document.getElementById("ddphoto"+c);
				ddphoto.parentNode.removeChild(ddphoto);
			}
			//编辑图片
			function modifyRows(n){
				var str="<input type='file' accept='image/*' name='file2"+n+"' id='file2"+n+"'  onchange='showPictrue("+n+")'   class='uploadFile'/>";
				if($("#file2"+n+"").length>0){
				}else{
					$("#editDiv"+n).append(str);
				}
			}
			//*************************图片相关：结束******************************************

			function setTranPrice(){
				 var customerId="${customer.id}";
				 window.parent.add("设置价格","manager/customerwaretype?customerId=" + customerId);
			}
			function setTcPrice(){
				 var customerId="${customer.id}";
				 window.parent.add("设置单位提成费用","manager/customersaletype?customerId=" + customerId);
			}

			function setRegion(regionId){
				$("#regionId").val(regionId);
			}

			if(showAllDesc=='true'){
				//$(".showClass").show();
			}else{
				//$(".showClass").hide();
			}


		</script>

