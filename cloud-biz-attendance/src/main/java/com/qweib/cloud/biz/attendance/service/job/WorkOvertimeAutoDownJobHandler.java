package com.qweib.cloud.biz.attendance.service.job;

import com.qweib.cloud.biz.system.service.ws.SysCheckInService;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import com.qweibframework.commons.http.ResponseUtils;
import com.xxl.job.core.biz.model.ReturnT;
import com.xxl.job.core.handler.IJobHandler;
import com.xxl.job.core.handler.annotation.JobHandler;
import com.xxl.job.core.log.XxlJobLogger;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;


/**
 * 任务Handler示例（Bean模式）
 * <p>
 * 开发步骤：
 * 1、继承"IJobHandler"：“com.xxl.job.core.handler.IJobHandler”；
 * 2、注册到Spring容器：添加“@Component”注解，被Spring容器扫描为Bean实例；
 * 3、注册到执行器工厂：添加“@JobHandler(value="自定义jobhandler名称")”注解，注解value值对应的是调度中心新建任务的JobHandler属性的值。
 * 4、执行日志：需要通过 "XxlJobLogger.log" 打印执行日志；
 */
@Slf4j
@JobHandler(value = "workOvertimeAutoDownJobHandler")
@Component
public class WorkOvertimeAutoDownJobHandler extends IJobHandler {
    @Resource
    private SysCorporationRequest sysCorporationRequest;
    @Autowired
    private DataSourceContextAllocator allocator;
    @Resource
    private SysCheckInService sysCheckInService;

    @Override
    public ReturnT<String> execute(String param) {
        try {
            XxlJobLogger.log("准备执行自动下班:" + param);
            if (!StrUtil.isNull(param)) {
                JSONObject jsonObject = JSONObject.fromObject(param);
                if (jsonObject != null) {
                    String mId = jsonObject.getString("mId");
                    String database = jsonObject.getString("database");
                    SysCorporationDTO corporationDTO = ResponseUtils.convertResponse(sysCorporationRequest.getByDatabase(database));
                    allocator.alloc(database, corporationDTO.getId() + "");

                    SysCheckIn checkin = new SysCheckIn();
                    checkin.setPsnId(Integer.valueOf(mId));
                    checkin.setCheckTime(DateTimeUtil.getDateToStr());
                    checkin.setJobContent("");
                    checkin.setTp("1-2");
                    checkin.setLocation("");
                    checkin.setAutoDown("1");
                    int count = sysCheckInService.addCheck(checkin, database, null);
                    if (count <= 0) {
                        XxlJobLogger.log("自动下班添加数据出错");
                        return FAIL;
                    }
                }
            }
        } catch (Exception ex) {
            log.error("自动下班出现错误", ex);
            XxlJobLogger.log(ex);
            ex.printStackTrace();
        } finally {
            allocator.release();
        }
        return SUCCESS;
    }

}
