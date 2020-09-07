package com.qweib.cloud.biz.api;

import com.qweib.cloud.service.basedata.domain.platform.PlatCategoryDTO;
import com.qweib.cloud.service.basedata.domain.platform.PlatCategoryQuery;
import com.qweib.cloud.service.basedata.domain.platform.PlatIndustryDTO;
import com.qweib.cloud.service.basedata.retrofit.platform.PlatCategoryRequest;
import com.qweib.cloud.service.basedata.retrofit.platform.PlatIndustryRequest;
import com.qweib.fs.FileInfo;
import com.qweib.fs.FileService;
import com.qweib.fs.local.LocalFileService;
import com.qweibframework.commons.domain.DelFlagEnum;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import jdk.nashorn.internal.ir.annotations.Reference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import retrofit2.Call;

import java.io.IOException;
import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/11/5 17:24
 * @description:
 */
@RestController
@RequestMapping({"api/common", "web/common"})
public class CommonApiController extends BaseController {
//    @Autowired
//    private PlatIndustryRequest industryRequest;
//    @Autowired
//    private PlatCategoryRequest platCategoryRequest;

    private FileService fileService = new LocalFileService();


    @RequestMapping("industry")
    public Response platIndustryRequest() throws IOException {
       // Call<Response<List<PlatIndustryDTO>>> call = industryRequest.list(DelFlagEnum.NORMAL);
        //return call.execute().body();
        return new Response();
    }

    @RequestMapping("category")
    public Response platCategoryRequest(PlatCategoryQuery platCategoryQuery) throws IOException {
//        if (platCategoryQuery.getIndustryId() == null) {
//            return new Response();
//        }
//        Call<Response<List<PlatCategoryDTO>>> call = platCategoryRequest.list(platCategoryQuery);
//        Response<List<PlatCategoryDTO>> response = call.execute().body();
//        if (response.isSuccess()) {
//            return response;
//        }
        return new Response();
    }

    @RequestMapping("upload")
    public Response upload(MultipartFile file) throws Exception {
        FileInfo info = fileService.store("cloud", "license", file.getInputStream(), file.getOriginalFilename());
        return success().data(info);
    }

}
