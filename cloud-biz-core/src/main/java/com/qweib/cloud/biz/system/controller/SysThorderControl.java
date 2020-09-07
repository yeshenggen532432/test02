package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysThorderService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysThorder;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager/thorder")
public class SysThorderControl extends GeneralControl{
    @Resource
    private SysThorderService thorderService;

    @RequestMapping("/queryThorderPage")
    public String queryThorderPage(HttpServletRequest request, Model model, String dataTp){
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            model.addAttribute("database", info.getDatasource());
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MONTH, -1);
            model.addAttribute("sdate", format.format(calendar.getTime()));
            model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            model.addAttribute("dataTp", dataTp);
        } catch (Exception e) {
            // TODO: handle exception
        }
        return "/uglcw/thorder/order";
    }
    @RequestMapping("/thorderPage")
    public void thorderPage(HttpServletRequest request, HttpServletResponse response, SysThorder order, Integer page, Integer rows,
                            String jz, String dataTp){
        try{
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MONTH, -1);
            if(StrUtil.isNull(order.getSdate())){
                order.setSdate(format.format(calendar.getTime()));
            }
            if(StrUtil.isNull(order.getEdate())){
                order.setEdate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            }
            Page p=new Page();
            SysLoginInfo info = getLoginInfo(request);
            if(!StrUtil.isNull(jz)){
                p = this.thorderService.queryThorderPage(order, dataTp, info, page, rows);
                List<SysThorder> vlist=(List<SysThorder>)p.getRows();
                for (SysThorder thorder : vlist) {
                    thorder.setList(this.thorderService.queryThorderDetailPage(thorder.getId(),order.getDatabase(), 1, 50).getRows());
                }
            }
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        }catch (Exception e) {
            log.error("分页查询订单出错", e);
        }
    }

    @RequestMapping("/queryThorderDetailPage")
    public String queryThorderDetailPage(HttpServletRequest request, Model model, Integer orderId){
        model.addAttribute("orderId", orderId);
        return "/uglcw/thorder/orderdetail";
    }

    @RequestMapping("/thorderDetailPage")
    public void thorderDetailPage(HttpServletRequest request, HttpServletResponse response, Integer orderId, Integer page, Integer rows){
        try{
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.thorderService.queryThorderDetailPage(orderId, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        }catch (Exception e) {
            log.error("分页查询订单详情出错", e);
        }
    }

    @RequestMapping("/updateOrderSh")
    public void updateOrderSh(HttpServletResponse response, HttpServletRequest request, Integer id, String sh){
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.thorderService.updateOrderSh(info.getDatasource(), id, sh);
//			 SysThorder order=this.thorderService.queryThorderByid(info.getDatasource(), id);
//			List<SysThorderDetail> detail = this.thorderWebService.queryThorderDetail(info.getDatasource(),id);
//			SysConfig config = this.configService.querySysConfigByCode("CONFIG_ORDER_AUTO_CREATE_XSFP", info.getDatasource());
//			if(config!=null&&"1".equals(config.getStatus())){
//				order.setList(detail);
//				int i = stkInService.saveAutoCreateOrderToTh(info.getDatasource(),order);
//			}
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("修改订单审核出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/deleteOrder")
    public void deleteOrder(HttpServletResponse response, HttpServletRequest request, Integer id){
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.thorderService.deleteOrder(info.getDatasource(), id);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("删除订单出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/updateOrderZf")
    public void updateOrderZf(HttpServletResponse response, HttpServletRequest request, Integer id){
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.thorderService.updateOrderSh(info.getDatasource(), id, "已作废");
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("作废订单出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }
}
