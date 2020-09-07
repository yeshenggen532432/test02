<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
		<%@include file="/WEB-INF/page/include/source.jsp"%>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resource/audit/css/reset.css" />
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resource/audit/css/layout.css" />
    </head>
    <body>
        <div class="outer clearfix">
            <h2>审批详情</h2> 
            <table>
                <tr>
                    <th class="id" style="width: 20%">申请人</th>
                    <th class="user" style="padding: 0;width: 30%">
                        <dl>
                            <dt>
                            	<c:if test="${empty audit.memberHead}">
                            		<img src="<%=request.getContextPath()%>/resource/audit/images/head.jpg" alt="" />
                            	</c:if>
                            	<c:if test="${!empty audit.memberHead}">
                            		<img src="<%=request.getContextPath()%>/upload/${audit.memberHead}" alt="" />
                            	</c:if>
                            </dt>
                            <dd>${audit.memberNm}</dd>
                        </dl>
                    </th>
                    <th class="id" style="width: 20%">申请部门</th>
                    <th style="width: 30%">${empty audit.branchName?'公司本级':audit.branchName}</th>
                </tr>
                <tr>
                    <td class="id">审批标题</td>
                    <td colspan="3" class="setpd">${audit.title}</td>
                </tr>
                <tr>
                    <td class="id">审批编号</td>
                    <td colspan="3" class="setpd">${audit.auditNo}</td>
                </tr>
               <!-- 请假 -->
                <c:if test="${audit.auditTp=='1'}">
                	<tr>
	                    <td class="id">请假类型</td>
	                    <td  colspan="3" class="setpd">${audit.tp}</td>
	                </tr>
	                <tr>
	                    <td class="id">开始时间</td>
	                    <td  colspan="3" class="setpd">${audit.stime}</td>
	                </tr>
	                <tr>
	                    <td class="id">结束时间</td>
	                    <td  colspan="3" class="setpd">${audit.etime}</td>
	                </tr>
	                <tr>
	                    <td class="id">请假天数</td>
	                    <td  colspan="3" class="setpd">${audit.auditData}</td>
	                </tr>
	                <tr>
	                    <td class="id">请假事由</td>
	                    <td  colspan="3" class="setpd">${audit.dsc}</td>
	                </tr>
                </c:if>
                <!-- 报销 -->
                <c:if test="${audit.auditTp=='2'}">
                	<tr>
	                    <td class="id">报销类别</td>
	                    <td  colspan="3" class="setpd">${audit.tp}</td>
	                </tr>
	                <tr>
	                    <td class="id">报销金额(元)</td>
	                    <td  colspan="3" class="setpd">${audit.auditData}</td>
	                </tr>
	                <tr>
	                    <td class="id">费用明细</td>
	                    <td  colspan="3" class="setpd">${audit.dsc}</td>
	                </tr>
                </c:if>
                <!-- 出差 -->
                <c:if test="${audit.auditTp=='3'}">
                	<tr>
	                    <td class="id">出差地点</td>
	                    <td  colspan="3" class="setpd">${audit.tp}</td>
	                </tr>
	                <tr>
	                    <td class="id">出发时间</td>
	                    <td  colspan="3" class="setpd">${audit.stime}</td>
	                </tr>
	                <tr>
	                    <td class="id">返回时间</td>
	                    <td  colspan="3" class="setpd">${audit.etime}</td>
	                </tr>
	                <tr>
	                    <td class="id">出差天数</td>
	                    <td  colspan="3" class="setpd">${audit.auditData}</td>
	                </tr>
	                <tr>
	                    <td class="id">出差事由</td>
	                    <td  colspan="3" class="setpd">${audit.dsc}</td>
	                </tr>
                </c:if>
                <!-- 物品领用 -->
                <c:if test="${audit.auditTp=='4'}">
                	<tr>
	                    <td class="id">物品用途</td>
	                    <td  colspan="3" class="setpd">${audit.tp}</td>
	                </tr>
	                    <td class="id">领用详情</td>
	                    <td  colspan="3" class="setpd">${audit.dsc}</td>
	                </tr>
                </c:if>
                <!-- 通用审批 -->
                <c:if test="${audit.auditTp=='5'}">
                	<tr>
	                    <td class="id">申请内容</td>
	                    <td  colspan="3" class="setpd">${audit.tp}</td>
	                </tr>
	                <tr>
	                    <td class="id">审批详情</td>
	                    <td  colspan="3" class="setpd">${audit.dsc}</td>
	                </tr>
                </c:if>
                <!-- 自定义审批 -->
                <c:if test="${audit.auditTp=='6' || audit.auditTp=='7'}">
                    <c:if test="${!empty audit.tp}">
                        <tr>
                            <td class="id">类型</td>
                            <td  colspan="3" class="setpd">${audit.tp}</td>
                        </tr>
                    </c:if>
                    <c:if test="${!empty audit.amount}">
                        <tr>
                            <td class="id">金额</td>
                            <td  colspan="3" class="setpd">${audit.amount}</td>
                        </tr>
                    </c:if>
                    <c:if test="${!empty audit.stime}">
                        <tr>
                            <td class="id">开始时间</td>
                            <td  colspan="3" class="setpd">${audit.stime}</td>
                        </tr>
                    </c:if>
                    <c:if test="${!empty audit.etime}">
                        <tr>
                            <td class="id">结束时间</td>
                            <td  colspan="3" class="setpd">${audit.etime}</td>
                        </tr>
                    </c:if>
                    <c:if test="${!empty audit.dsc}">
                        <tr>
                            <td class="id">详情</td>
                            <td  colspan="3" class="setpd">${audit.dsc}</td>
                        </tr>
                    </c:if>
                    <c:if test="${!empty audit.objectName}">
                        <tr>
                            <td class="id">对象</td>
                            <td  colspan="3" class="setpd">${audit.objectName}</td>
                        </tr>
                    </c:if>
                    <c:if test="${!empty audit.accName}">
                        <tr>
                            <td class="id">账户</td>
                            <td  colspan="3" class="setpd">${audit.accName}</td>
                        </tr>
                    </c:if>
                    <c:if test="${!empty audit.auditData}">
                        <tr>
                            <td class="id">备注</td>
                            <td  colspan="3" class="setpd">${audit.auditData}</td>
                        </tr>
                    </c:if>
                </c:if>
                <c:if test="${!empty audit.picList}">
                	<tr>
	                    <td class="id">图片</td>
	                    <td class="showIMG" colspan="3">
	                    	<c:forEach items="${audit.picList}" var="item">
	                    		<img src="<%=request.getContextPath()%>/upload/${item.pic}"  alt="" />
	                    	</c:forEach>
	                    </td>
	                </tr>
                </c:if>
                <c:if test="${!empty audit.fileList}">
                    <tr>
                        <td class="id">附件</td>
                        <td colspan="3">
                            <c:forEach items="${audit.fileList}" var="item">
                                ${item.origin}<br/>
                            </c:forEach>
                        </td>
                    </tr>
                </c:if>
                <tr>
                <td colspan="4" style="background-color: white;">
                <c:forEach items="${audit.checkList}" var="ch">
                    <div class="process clearfix">
                        <div class="category clearfix">
                            <c:if test="${empty ch.memberHead}">
                                <img src="<%=request.getContextPath()%>/resource/audit/images/head.jpg" alt="" />
                            </c:if>
                            <c:if test="${!empty ch.memberHead}">
                                <img src="<%=request.getContextPath()%>/upload/${ch.memberHead }" alt="" />
                            </c:if>
                            <em>
                                ${ch.memberNm }
                            </em>
                        </div>
                        <div class="action clearfix" >
                            <strong>
                                ${ch.checkTp=='1'?'发起申请':ch.checkTp=='2'?'已同意':ch.checkTp=='3'?'已拒绝':ch.checkTp=='4'?'已转发':ch.checkTp=='5'?'已撤销':'' }
                                <c:if test="${!empty ch.dsc && ch.dsc!='null'}">（${ch.dsc}）</c:if>
                            </strong>
                        </div>
                        <div class="time clearfix">
                            <span>日期：${ch.checkTime } </span>
                        </div>
                    </div>
                </c:forEach>
                </td>
            </tr>
            </table>
        </div>
        <div align="center" id="divbutt">
	        <button onclick="toPrint();">打印</button>
	        <!--  <button onclick="toback()">返回</button>-->
        </div>
        <script type="text/javascript">
        	function toPrint(){
        		$("#divbutt").hide();
        		window.print();
        		$("#divbutt").show();
        	}
        	function toback(){
        		location.href="${base}/manager/toAuditmng";
        	}


        </script>
    </body>
</html>