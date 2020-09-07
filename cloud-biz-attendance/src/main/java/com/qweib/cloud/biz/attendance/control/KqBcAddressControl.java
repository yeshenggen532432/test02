package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.KqAddress;
import com.qweib.cloud.biz.attendance.service.KqBcAddressService;
import com.qweib.cloud.biz.attendance.service.KqBcService;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.core.domain.SysLoginInfo;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * 考勤班次地址
 */
@Controller
@RequestMapping("manager/kqBcAddress")
public class KqBcAddressControl extends GeneralControl {
    @Resource
    private KqBcService kqBcService;
    @Resource
    private KqBcAddressService kqBcAddressService;


    /**
     * 保存
     */
    @RequestMapping("save")
    public void save(HttpServletResponse response, KqAddress bean) {
        SysLoginInfo info = UserContext.getLoginInfo();
        KqAddress oldBean = this.kqBcAddressService.queryKqBcAddressByAddress(info.getDatasource(), bean.getAddress());
        if (oldBean != null) {
            sendWarm(response, "地址名称已存在");
            return;
        }
        //添加
        if (bean.getId() == null) {
            sendSuccess(response, "添加成功");
            this.kqBcAddressService.add(info.getDatasource(), bean);
        } else {
            //修改
//          oldBean = this.kqBcAddressService.queryById(info.getDatasource(), bean.getId());
            this.kqBcAddressService.update(info.getDatasource(), bean);
            sendSuccess(response, "修改成功");
        }
    }

    /**
     *
     */
    @RequestMapping("queryList")
    public void queryList(HttpServletResponse response, KqAddress bean) {
        SysLoginInfo info = UserContext.getLoginInfo();
        List<KqAddress> list = new ArrayList<>();
        List<KqAddress> bcAddressList = this.kqBcService.queryBcAddress(info.getDatasource());
        List<KqAddress> kqAddressList = this.kqBcAddressService.queryList(info.getDatasource(), bean);
        //bcAddressList数据是直接从班次中获取的
        if (bcAddressList != null) {
            list.addAll(bcAddressList);
        }
        if (kqAddressList != null) {
            for (KqAddress kqAddress: kqAddressList) {
                kqAddress.setType("1");
            }
            list.addAll(kqAddressList);
        }
        JSONObject json = new JSONObject();
        json.put("total", list.size());
        json.put("rows", list);
        sendJsonResponse(response, json.toString());
    }
//
//    /**
//     * 修改审批流启用状态
//     */
//    @ResponseBody
//    @RequestMapping("updateAuditZdyStatus")
//    public Response updateAuditZdyState(Integer id){
//        SysLoginInfo loginInfo = UserContext.getLoginInfo();
//        BscAuditZdy oldAuditZdy = this.auditZdyWebService.queryAuditZdyById(id, loginInfo.getDatasource());
//        if(oldAuditZdy != null){
//            Integer state = oldAuditZdy.getStatus();
//            if(state != null && state == 1){
//                oldAuditZdy.setStatus(0);
//            }else{
//                oldAuditZdy.setStatus(1);
//            }
//        }
//        this.auditZdyWebService.updateAuditZdy(loginInfo.getDatasource(), oldAuditZdy);
//        return Response.createSuccess();
//    }
//
//    /**
//     * 修改审批流是否同步手机端
//     */
//    @ResponseBody
//    @RequestMapping("updateAuditZdyIsMobile")
//    public Response updateAuditZdyIsMobile(Integer id){
//        SysLoginInfo loginInfo = UserContext.getLoginInfo();
//        BscAuditZdy oldAuditZdy = this.auditZdyWebService.queryAuditZdyById(id, loginInfo.getDatasource());
//        if(oldAuditZdy != null){
//            String isMobile = oldAuditZdy.getIsMobile();
//            if(isMobile != null && "1".equals(isMobile)){
//                oldAuditZdy.setIsMobile("0");
//            }else{
//                oldAuditZdy.setIsMobile("1");
//            }
//        }
//        this.auditZdyWebService.updateAuditZdy(loginInfo.getDatasource(), oldAuditZdy);
//        return Response.createSuccess();
//    }
//
//    @ResponseBody
//    @RequestMapping("/updateAuditZdySort")
//    public Response updateSort(Integer id,Integer sort){
//        SysLoginInfo loginInfo = UserContext.getLoginInfo();
//        BscAuditZdy oldAuditZdy = this.auditZdyWebService.queryAuditZdyById(id, loginInfo.getDatasource());
//        oldAuditZdy.setSort(sort);
//        this.auditZdyWebService.updateAuditZdy(loginInfo.getDatasource(), oldAuditZdy);
//        return Response.createSuccess();
//    }


}
