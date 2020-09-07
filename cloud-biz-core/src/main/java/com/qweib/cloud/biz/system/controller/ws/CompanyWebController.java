package com.qweib.cloud.biz.system.controller.ws;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.basedata.domain.platform.PlatCategoryDTO;
import com.qweib.cloud.service.basedata.domain.platform.PlatCategoryQuery;
import com.qweib.cloud.service.basedata.domain.platform.PlatIndustryDTO;
import com.qweib.cloud.service.basedata.retrofit.platform.PlatCategoryRequest;
import com.qweib.cloud.service.basedata.retrofit.platform.PlatIndustryRequest;
import com.qweib.cloud.service.member.domain.corporation.CompanyExtDTO;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.domain.DelFlagEnum;
import com.qweibframework.commons.http.ResponseUtils;
import com.qweibframework.commons.web.dto.Response;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import retrofit2.Call;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 公司信息
 */
@Controller
@RequestMapping("/web/company")
public class CompanyWebController extends BaseWebService {
//    @Autowired
//    private PlatIndustryRequest industryRequest;
//    @Autowired
//    private PlatCategoryRequest platCategoryRequest;
//    @Autowired
//    private SysCorporationRequest companyApi;

    @Resource
    private SysCorporationService sysCorporationService;

    @RequestMapping("info")
    @ResponseBody
    public Map<String, Object> queryCompanyInfo(String token) throws IOException{
        Map<String, Object> result = Maps.newHashMapWithExpectedSize(3);
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (!message.isSuccess()) {
            result.put("state", false);
            result.put("msg", message.getMessage());
            return result;
        }
        OnlineUser loginDto = message.getOnlineMember();

        SysCorporation company = this.sysCorporationService.get(Integer.parseInt(loginDto.getFdCompanyId())); //HttpResponseUtils.convertResponse(companyApi.getExt(Integer.valueOf(loginDto.getFdCompanyId())));
        result.put("state", true);
        result.put("msg", "获取公司信息成功");
        result.put("data", company);
        return result;
    }

    @RequestMapping("save")
    @ResponseBody
    public Map<String, Object> save(HttpServletRequest request, String token, CompanyExtDTO company) throws IOException {
        Map<String, Object> result = Maps.newHashMapWithExpectedSize(3);
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (!message.isSuccess()) {
            result.put("state", false);
            result.put("msg", message.getMessage());
            return result;
        }
        OnlineUser loginDto = message.getOnlineMember();
        //使用request取图片
        Map<String, Object> map = UploadFile.updatePhotos(request, loginDto.getDatabase(), "logo",1);
        if("1".equals(map.get("state"))){
            List<String> pic = (List<String>)map.get("fileNames");
            if (pic != null && pic.size() > 0) {
                company.setBizLicensePic(pic.get(0));
            }
        }else{
            result.put("state", false);
            result.put("msg", "图片上传失败");
            return result;
        }
        company.setId(Integer.valueOf(loginDto.getFdCompanyId()));
        Response response =new Response(); //companyApi.updateCompanyExt(company).execute().body();
        if(200 == response.getCode()){
            result.put("state", true);
            result.put("msg", "修改成功");
        }else{
            result.put("state", true);
            result.put("msg", response.getMessage());
        }
        return result;
    }

    @RequestMapping("industry")
    @ResponseBody
    public Map<String, Object> getIndustry() throws IOException {
        Map<String, Object> result = Maps.newHashMapWithExpectedSize(3);
        Response response = new Response();
        //Response<List<PlatIndustryDTO>> response = ResponseUtils.syncRequest(industryRequest.list(DelFlagEnum.NORMAL));
        if (response.getCode() == 200) {
            result.put("state", true);
            result.put("msg", "获取所属行业成功");
            result.put("data", response.getData());
        } else {
            result.put("state", false);
            result.put("msg", response.getMessage());
        }
        return result;
    }

    @RequestMapping("category")
    @ResponseBody
    public Map<String, Object> getCategory(PlatCategoryQuery platCategoryQuery) throws IOException {
        Map<String, Object> result = Maps.newHashMapWithExpectedSize(3);
        if (platCategoryQuery.getIndustryId() == null) {
            result.put("state", false);
            result.put("msg", "参数不完整");
            return result;
        }
        Response response = new Response();
        //Response<List<PlatCategoryDTO>> response = ResponseUtils.syncRequest(platCategoryRequest.list(platCategoryQuery));
        if (response.getCode() == 200) {
            result.put("state", true);
            result.put("msg", "获取所属行业分类成功");
            result.put("data", response.getData());
        } else {
            result.put("state", false);
            result.put("msg", response.getMessage());
        }
        return result;
    }
}
