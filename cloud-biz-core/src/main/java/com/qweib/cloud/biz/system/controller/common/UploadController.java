package com.qweib.cloud.biz.system.controller.common;

import cn.jpush.api.utils.StringUtils;
import com.google.common.collect.Lists;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.fs.FileInfo;
import com.qweib.fs.FileService;
import com.qweib.fs.local.LocalFileService;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import jdk.nashorn.internal.ir.annotations.Reference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * @author jimmy.lin
 * create at 2020/3/13 16:13
 */
@RestController
@RequestMapping({"web/upload", "manager/upload"})
public class UploadController extends BaseController {


    private FileService fileService = new LocalFileService();

    @PostMapping("single")
    public Response uploadSingle(@RequestParam("file") MultipartFile multipartFile,
                                 @RequestParam(name = "name", required = false) String name,
                                 @RequestParam(name = "path") String path) throws Exception {
        SysLoginInfo info = UserContext.getLoginInfo();
        String bucket = info.getDatasource();
        FileInfo fileInfo;
        if (StringUtils.isNotEmpty(name)) {
            fileInfo = fileService.store(bucket, multipartFile.getInputStream(), path, name, multipartFile.getOriginalFilename());
        } else {
            fileInfo = fileService.store(bucket, path, multipartFile.getInputStream(), multipartFile.getOriginalFilename());
        }
        return success().data(fileInfo);
    }

    @PostMapping("multiple")
    public Response uploadMultiple(@RequestParam("file") List<MultipartFile> files,
                                   @RequestParam(name = "path") String path) throws Exception {
        List<FileInfo> fileList = Lists.newArrayList();
        SysLoginInfo info = UserContext.getLoginInfo();
        String bucket = info.getDatasource();
        if (Collections3.isNotEmpty(files)) {
            for (MultipartFile multipartFile : files) {
                fileList.add(fileService.store(bucket, path, multipartFile.getInputStream(), multipartFile.getOriginalFilename()));
            }
        }
        return success(fileList);
    }

    @PostMapping("remove")
    public Response remove(@RequestParam("object") String object) throws Exception {
        SysLoginInfo info = UserContext.getLoginInfo();
        String bucket = info.getDatasource();
        fileService.remove(bucket, object);
        return success();
    }


    /**
     * 多图上传加压缩
     *
     * @param request
     * @param multipartFile
     * @param path
     * @return
     * @throws Exception
     */
    @PostMapping("multipleAndCompression")
    public Response multipleAndCompression(HttpServletRequest request, @RequestParam("file") MultipartFile multipartFile, @RequestParam(name = "path", defaultValue = "temp/pic") String path) throws Exception {
        SysLoginInfo info = UserContext.getLoginInfo();
        Map<String, Object> map = UploadFile.updatePhotos(request, info.getDatasource(), path, 1);
        if ("1".equals(map.get("state"))) {
            return success().data(map);
        }

        return error("上传失败");
    }
}
