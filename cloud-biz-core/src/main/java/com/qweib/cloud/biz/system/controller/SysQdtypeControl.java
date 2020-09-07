package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.SysQdTypePriceService;
import com.qweib.cloud.biz.system.service.SysQdtypeService;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysQdTypePrice;
import com.qweib.cloud.core.domain.SysQdtype;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.MathUtils;
import net.sf.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysQdtypeControl extends GeneralControl {
    @Resource
    private SysQdtypeService qdtypeService;
    @Resource
    private SysQdTypePriceService qdTypePriceService;
    @Resource
    private SysWaresService sysWaresService;
    @Resource
    private SysCustomerService customerService;

    /**
     * 摘要：
     *
     * @说明：渠道类型页面
     * @创建：作者:llp 创建时间：2016-7-25
     * @修改历史： [序号](llp 2016 - 7 - 25)<修改说明>
     */
    @RequestMapping("queryQdtype")
    public String queryQdtype(Model model) {
        return "/uglcw/khgxsx/qdtype";
    }

    /**
     * 摘要：
     *
     * @说明：分页查询渠道类型
     * @创建：作者:llp 创建时间：2016-7-25
     * @修改历史： [序号](llp 2016 - 7 - 25)<修改说明>
     */
    @RequestMapping("toQdtypePage")
    public void toQdtypePage(SysQdtype qdtype, int page, int rows, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.qdtypeService.queryQdtypePage(qdtype, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("分页查询渠道类型出错：", e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：操作渠道类型
     * @创建：作者:llp 创建时间：2016-7-25
     * @修改历史： [序号](llp 2016 - 7 - 25)<修改说明>
     */
    @RequestMapping("operQdtype")
    public void operQdtype(SysQdtype qdtype, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            if (!StrUtil.isNull(qdtype)) {
                if (null != qdtype.getId() && qdtype.getId() > 0) {
                    this.qdtypeService.updateQdtype(qdtype, info.getDatasource());
                    this.sendHtmlResponse(response, "2");
                } else {
                    this.qdtypeService.addQdtype(qdtype, info.getDatasource());
                    this.sendHtmlResponse(response, "1");
                }
            }
        } catch (Exception e) {
            log.error("操作渠道类型出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 摘要：
     *
     * @说明：获取渠道类型
     * @创建：作者:llp 创建时间：2016-7-25
     * @修改历史： [序号](llp 2016 - 7 - 25)<修改说明>
     */
    @RequestMapping("getQdtype")
    public void getQdtype(Integer id, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysQdtype qdtype = this.qdtypeService.queryQdtypeById(id, info.getDatasource());
            JSONObject json = new JSONObject(qdtype);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取渠道类型出错：", e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：删除渠道类型
     * @创建：作者:llp 创建时间：2016-7-25
     * @修改历史： [序号](llp 2016 - 7 - 25)<修改说明>
     */
    @RequestMapping("deleteQdtypeById")
    public void deleteQdtypeById(Integer id, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);

            int count = this.customerService.queryQdtypeId(id, info.getDatasource());
            if (count > 0) {
                this.sendHtmlResponse(response, "2");
                return;
            }

            this.qdtypeService.deleteQdtypeById(id, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("操作渠道类型出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/qdtypepricewaretype")
    public String qdtypepricewaretype(HttpServletRequest request, Model model, String dataTp) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("datasource", info.getDatasource());
        model.addAttribute("dataTp", dataTp);
        return "/uglcw/khgxsx/qdtypepricewaretype";
    }

    @RequestMapping("/qdtypepricewarepage")
    public String qdtypepricewarepage(HttpServletRequest request, Model model, Integer wtype, String dataTp, Integer relaId) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("wtype", wtype);
        model.addAttribute("tpNm", info.getTpNm());
        List<SysQdtype> typeList = qdtypeService.queryList(null, info.getDatasource());
        JSONArray typeListJson = JSONArray.fromObject(typeList);
        model.addAttribute("typeTitleJson", typeListJson.toString());

        List<SysQdTypePrice> typePriceList = qdTypePriceService.queryList(null, info.getDatasource());
        JSONArray typePriceJson = JSONArray.fromObject(typePriceList);

        model.addAttribute("typePriceJson", typePriceJson.toString());

        return "/uglcw/khgxsx/qdtypepricewarepage";
    }

    @RequestMapping("/qdtypepriceoneware")
    public String qdtypepriceoneware(HttpServletRequest request, Model model, Integer wareId) {
        SysLoginInfo info = this.getLoginInfo(request);
        List<SysQdtype> typeList = qdtypeService.queryList(null, info.getDatasource());
        model.addAttribute("typeList", typeList);
        SysQdTypePrice typePrice = new SysQdTypePrice();
        if (!StrUtil.isNull(wareId)) {
            typePrice.setWareId(wareId);
        } else {
            return null;
        }
        List<SysQdTypePrice> typePriceList = qdTypePriceService.queryList(typePrice, info.getDatasource());
        model.addAttribute("typePriceList", typePriceList);
        model.addAttribute("wareId", wareId);
        model.addAttribute("op",request.getParameter("op"));
        return "/uglcw/khgxsx/qdtypepriceoneware";
    }

    @RequestMapping("/updateQdTypePrice")
    public void updateQdTypePrice(HttpServletResponse response, HttpServletRequest request, SysQdTypePrice model) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int i = 0;
            if (model != null) {
                if (StrUtil.isNull(model.getId())) {
                    i = this.qdTypePriceService.addQdTypePrice(model, info.getDatasource());
                } else {
                    i = this.qdTypePriceService.updateQdTypePrice(model, info.getDatasource());
                }
            }
            this.sendJsonResponse(response, "" + i);
        } catch (Exception e) {
        }
    }

    @RequestMapping("/updateQdTypeRate")
    public void updateQdTypeRate(HttpServletResponse response, HttpServletRequest request,Integer id, Double rate) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysQdtype qdtype =  this.qdtypeService.queryQdtypeById(id,info.getDatasource());
            if(StrUtil.isNull(rate)){
                qdtype.setRate(null);
            }else{
                qdtype.setRate(new BigDecimal(rate));
            }
            this.qdtypeService.updateQdtype(qdtype,info.getDatasource());
            this.sendJsonResponse(response, 1+"");
        } catch (Exception e) {
        }
    }

    @RequestMapping("customerTypeList")
    public String customerTypeList(Model model, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<SysQdtype> list = this.qdtypeService.queryQdtypels(info.getDatasource());
            model.addAttribute("list", list);
        } catch (Exception e) {
            log.error("", e);
        }
        return "/uglcw/khgxsx/customer_type_list";
    }


    @RequestMapping("/toCustomerTypeSetWareTree")
    public String toCustomerTypeSetWareTree(HttpServletRequest request, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        String relaId = request.getParameter("relaId");
        model.addAttribute("relaId", relaId);
        SysQdtype sysQdtype = qdtypeService.queryQdtypeById(Integer.valueOf(relaId), info.getDatasource());
        model.addAttribute("sysQdtype", sysQdtype);
        return "/uglcw/khgxsx/customer_type_set_ware_tree";
    }

    @RequestMapping("/toCustomerTypeSetWarePage")
    public String toCustomerTypeSetWarePage(HttpServletRequest request, Integer wtype, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        String relaId = request.getParameter("relaId");
        model.addAttribute("relaId", relaId);
        model.addAttribute("wtype", wtype);
        String isType = request.getParameter("isType");
        if (StrUtil.isNull(isType)) {
            model.addAttribute("isType", "");
        } else {
            model.addAttribute("isType", isType);
        }
        return "/uglcw/khgxsx/customer_type_set_ware_page";
    }

    @RequestMapping("/customerTypeSetWarePage")
    public void customerTypeSetWarePage(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        ware.setWaretype(wtype);
        String relaId = request.getParameter("relaId");
        SysQdTypePrice qdTypePrice = new SysQdTypePrice();
        qdTypePrice.setRelaId(Integer.valueOf(relaId));
        List<SysQdTypePrice> qdTypePriceList = qdTypePriceService.queryList(qdTypePrice, info.getDatasource());
//
//		SysQdtype sysQdtype = qdtypeService.queryQdtypeById(Integer.valueOf(relaId),info.getDatasource());

        try {
            ware.setWaretype(wtype);
            Page p = this.sysWaresService.queryCompanyStockWare(ware, page, rows, info.getDatasource());

            if (p.getRows() != null && p.getRows().size() > 0) {
                for (int i = 0; i < p.getRows().size(); i++) {
                    SysWare sysWare = (SysWare) p.getRows().get(i);
                    sysWare.setWareDj(null);
                    sysWare.setCxPrice(null);
                    sysWare.setFxPrice(null);
                    sysWare.setSunitPrice(null);
                    sysWare.setMinCxPrice(null);
                    sysWare.setMinFxPrice(null);

                    if (!StrUtil.isNumberNullOrZero(sysWare.getLsPrice())) {
                        sysWare.setTempWareDj(sysWare.getLsPrice());
                    }
                    if (!StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
                        sysWare.setTempSunitPrice(new BigDecimal(sysWare.getMinLsPrice()));
                    }
//                    if(StrUtil.isNumberNullOrZero(sysWare.getTempWareDj())){
//                        BigDecimal rate = new BigDecimal(1);
//                        if(!StrUtil.isNumberNullOrZero(sysWare.getAddRate())){
//                            rate = sysWare.getAddRate().divide(new BigDecimal(100));
//                            if(StrUtil.isNumberNullOrZero(sysWare.getLsPrice())&&!StrUtil.isNumberNullOrZero(sysWare.getInPrice())){
//                                sysWare.setTempWareDj(sysWare.getInPrice()*(rate.doubleValue()));
//                            }
//                            if(StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())&&!StrUtil.isNumberNullOrZero(sysWare.getMinInPrice())){
//                                sysWare.setTempSunitPrice(new BigDecimal(sysWare.getMinInPrice()*(rate.doubleValue())));
//                            }
//                        }
//
//                    }

                    sysWare.setLsPrice(null);
                    sysWare.setMinLsPrice(null);
                    sysWare.setRate(null);

                    if (qdTypePriceList != null && qdTypePriceList.size() > 0) {
                        for (int j = 0; j < qdTypePriceList.size(); j++) {
                            SysQdTypePrice sclp = qdTypePriceList.get(j);
                            if (sysWare.getWareId().equals(sclp.getWareId())) {
                                if (!StrUtil.isNumberNullOrZero(sclp.getPrice()) && StrUtil.isNumeric(sclp.getPrice())) {
                                    sysWare.setWareDj(Double.valueOf(sclp.getPrice()));
                                }
                                sysWare.setLsPrice(sclp.getLsPrice());
                                sysWare.setCxPrice(sclp.getCxPrice());
                                sysWare.setFxPrice(sclp.getFxPrice());
                                if (!StrUtil.isNumberNullOrZero(sclp.getSunitPrice())) {
                                    sysWare.setSunitPrice(new BigDecimal(sclp.getSunitPrice()));
                                }
                                sysWare.setMinCxPrice(sclp.getMinCxPrice());
                                sysWare.setMinFxPrice(sclp.getMinFxPrice());
                                sysWare.setMinLsPrice(sclp.getMinLsPrice());
                                sysWare.setRate(sclp.getRate());
                                break;
                            }
                        }
                    }

                }
            }

            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("", e);
        }
    }


    @RequestMapping("/updateCustomerTypeWarePrice")
    public void updateCustomerLevelWarePrice(HttpServletResponse response, HttpServletRequest request, Integer wareId, Double price, String field) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            String relaId = request.getParameter("relaId");
            SysQdTypePrice qdTypePrice = qdTypePriceService.queryQdTypePriceByWareIdAndRelaId(Integer.valueOf(relaId), wareId, info.getDatasource());
            if (qdTypePrice == null) {
                qdTypePrice = new SysQdTypePrice();
                qdTypePrice.setWareId(wareId);
                qdTypePrice.setRelaId(Integer.valueOf(relaId));
            }
            if ("wareDj".equals(field)) {
                qdTypePrice.setPrice(price + "");
            } else if ("lsPrice".equals(field)) {
                qdTypePrice.setLsPrice(price);
            } else if ("fxPrice".equals(field)) {
                qdTypePrice.setFxPrice(price);
            } else if ("cxPrice".equals(field)) {
                qdTypePrice.setCxPrice(price);
            } else if ("sunitPrice".equals(field)) {
                qdTypePrice.setSunitPrice(price);
            } else if ("minLsPrice".equals(field)) {
                qdTypePrice.setMinLsPrice(price);
            } else if ("minFxPrice".equals(field)) {
                qdTypePrice.setMinFxPrice(price);
            } else if ("minCxPrice".equals(field)) {
                qdTypePrice.setMinCxPrice(price);
            } else if ("rate".equals(field)) {
                qdTypePrice.setRate(new BigDecimal(price));

                SysWare ware = this.sysWaresService.queryWareById(wareId, info.getDatasource());
                if (ware.getLsPrice() != null) {
                    qdTypePrice.setPrice(""+MathUtils.setScale(MathUtils.multiply(ware.getLsPrice(),MathUtils.divideByScale(qdTypePrice.getRate(),100,5))));

                }else{
                    qdTypePrice.setPrice(null);
                }
                if (ware.getMinLsPrice()!= null) {
                    qdTypePrice.setSunitPrice(MathUtils.setScale(MathUtils.multiply(ware.getMinLsPrice(),MathUtils.divideByScale(qdTypePrice.getRate(),100,5))).doubleValue());

                }else {
                  qdTypePrice.setSunitPrice(null);
                }

            }

            int i = 0;
            if (StrUtil.isNull(qdTypePrice.getId())) {
                i = this.qdTypePriceService.addQdTypePrice(qdTypePrice, info.getDatasource());
            } else {
                i = this.qdTypePriceService.updateQdTypePrice(qdTypePrice, info.getDatasource());
            }
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("", e);
        }
    }

    @RequestMapping("toCustomerTypePage")
    public String toCustomerTypePage(Model model, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            String qdtpNm = request.getParameter("qdtpNm");
            model.addAttribute("qdtpNm", qdtpNm);
        } catch (Exception e) {
            log.error("", e);
        }
        return "/uglcw/khgxsx/customer_type_page";
    }
}
