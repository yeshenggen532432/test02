package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.controller.vo.CompanyExtDTO1;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.basedata.domain.platform.PlatCategoryDTO;
import com.qweib.cloud.service.basedata.domain.platform.PlatCategoryQuery;
import com.qweib.cloud.service.basedata.domain.platform.PlatIndustryDTO;
import com.qweib.cloud.service.basedata.retrofit.platform.PlatCategoryRequest;
import com.qweib.cloud.service.basedata.retrofit.platform.PlatIndustryRequest;
import com.qweib.cloud.service.member.domain.corporation.CompanyExtDTO;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweibframework.commons.domain.DelFlagEnum;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import retrofit2.Call;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * @author: yueji.hu
 * @time: 2019-09-10 10:47
 * @description:
 */
@Controller
@RequestMapping("/manager/company")
public class CompanyController extends GeneralControl {
//    @Autowired
//    private PlatIndustryRequest industryRequest;
//    @Autowired
//    private PlatCategoryRequest platCategoryRequest;
//    @Autowired
//    private SysCorporationRequest companyApi;
    @Autowired
    private SysCorporationService sysCorporationService;

    @RequestMapping("info")
    public String toIndex(Model model) {
        SysLoginInfo info = UserContext.getLoginInfo();
        SysCorporation company = this.sysCorporationService.queryCorporationById(Integer.parseInt(info.getFdCompanyId()));
        //CompanyExtDTO company = HttpResponseUtils.convertResponse(companyApi.getExt(Integer.valueOf(info.getFdCompanyId())));
        CompanyExtDTO1 com = new CompanyExtDTO1();
        com.setId(company.getDeptId().intValue());
        com.setName(company.getDeptNm());
        com.setIndustryId(company.getDeptTrade() );
        com.setCategoryId(company.getTpNm());
        com.setBrand(company.getBrand());
        com.setLeader(company.getLeader());
        com.setTel(company.getDeptPhone());
        com.setEmail(company.getEmail());
        com.setEmployeeCount(company.getEmpQty());
        com.setSalesmanCount(company.getStaffQty());
        com.setAddress(company.getDeptAddr());


        model.addAttribute("company", com);
        return "uglcw/company/index";
    }

    @PostMapping
    @ResponseBody
    public Response save(CompanyExtDTO1 company) throws IOException {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        company.setId(Integer.valueOf(loginInfo.getFdCompanyId()));
        SysCorporation corporation = this.sysCorporationService.queryCorporationById(company.getId());
        corporation.setDeptNm(company.getName());
        corporation.setDeptTrade(company.getIndustryId());
        corporation.setTpNm(company.getCategoryId());
        corporation.setBrand(company.getBrand());
        corporation.setLeader(company.getLeader());
        corporation.setDeptPhone(company.getTel());
        corporation.setEmail(company.getEmail());
        corporation.setEmpQty(company.getEmployeeCount());
        corporation.setStaffQty(company.getSalesmanCount());
        corporation.setDeptAddr(company.getAddress());
        this.sysCorporationService.updateCorporation(corporation);
        //companyApi.updateCompanyExt(company).execute().body();
        return new Response().data(company.getId());
    }

    @RequestMapping(value = "uploadLogo", method = RequestMethod.POST)
    @ResponseBody
    public Response uploadQrcode(HttpServletRequest request, HttpServletResponse response) {
        SysLoginInfo info = this.getLoginInfo(request);
        Map<String, Object> files = UploadFile.updatePhotos(request, info.getDatasource() ,"logo", 1);
        return new Response().data(files);
    }

    @RequestMapping("industry")
    @ResponseBody
    public Response platIndustryRequest() throws IOException {
        //Call<Response<List<PlatIndustryDTO>>> call = industryRequest.list(DelFlagEnum.NORMAL);
        return new Response();//call.execute().body();
    }

    @RequestMapping("category")
    @ResponseBody
    public Response platCategoryRequest(PlatCategoryQuery platCategoryQuery) throws IOException {
        if (platCategoryQuery.getIndustryId() == null) {
            return new Response();
        }
//        Call<Response<List<PlatCategoryDTO>>> call = platCategoryRequest.list(platCategoryQuery);
//        Response<List<PlatCategoryDTO>> response = call.execute().body();
//        if (response.isSuccess()) {
//            return response;
//        }
        return new Response();
    }
}
