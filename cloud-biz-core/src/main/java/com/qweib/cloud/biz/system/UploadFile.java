package com.qweib.cloud.biz.system;

import com.qweib.cloud.biz.common.FileUtils;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.*;
import com.qweib.fs.FileInfo;
import com.qweib.fs.FileService;
import com.qweib.fs.local.LocalFileService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.List;
import java.util.*;


@Slf4j
public class UploadFile extends GeneralControl {

    /**
     * 保存聊天的图片和录音
     *
     * @param request
     * @param response
     * @return
     */
    public static String savePhotoOrVoice(HttpServletRequest request, HttpServletResponse response, String database) {
        /*MultipartHttpServletRequest imgRequest = (MultipartHttpServletRequest) request;
        try {
            MultipartFile file = imgRequest.getFile("file");
            String photoType = StrUtil.returnFileType(file);
            if (!StrUtil.isNull(photoType)) {
                String path = "";
                path = QiniuConfig.getValue("FILE_UPLOAD_URL");
				*//*if(StrUtil.isNull(path)){
					path = request.getSession().getServletContext().getRealPath("/upload/");
				}*//*
                String photoName = System.currentTimeMillis() + photoType;
                StrUtil.upLoadFile(file, path + "/" + database + "/chat", photoName);
                return database + "/chat/" + photoName;
            } else {
                return null;
            }
        } catch (Exception e) {
            return null;
        }*/
        return upload(request, database, "file", "chat");
    }

    public static String upload(InputStream inputStream, String originalName, String database, String subPath) {
        FileService fileService = SpringContextHolder.getBean(FileService.class);
        FileInfo fileInfo;
        try {
            fileInfo = fileService.store(database, subPath, inputStream, originalName);
            return fileInfo.getName();
        } catch (Exception e) {
            log.error("upload fail", e);
        }
        return null;
    }

    public static String upload(HttpServletRequest request, String field, String database, String subPath) {
        MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
        MultipartFile file = multipartHttpServletRequest.getFile(field);
        try {
            return upload(file.getInputStream(), file.getOriginalFilename(), database, subPath);
        } catch (Exception e) {
            log.error("upload fail", e);
        }
        return null;
    }

    /**
     * 保存拜访总结语音
     *
     * @param request
     * @param response
     * @return
     */
    public static String saveBfVoice(HttpServletRequest request, HttpServletResponse response, String database) {
        return upload(request, "voice", database, "bfvoice");
        /*MultipartHttpServletRequest imgRequest = (MultipartHttpServletRequest) request;
        try {
            MultipartFile file = imgRequest.getFile("voice");
            String photoType = StrUtil.returnFileType(file);
            if (!StrUtil.isNull(photoType)) {
                String path = "";
                path = QiniuConfig.getValue("FILE_UPLOAD_URL");
                if (StrUtil.isNull(path)) {
                    path = request.getSession().getServletContext().getRealPath("/upload/");
                }
                String photoName = System.currentTimeMillis() + photoType;
                StrUtil.upLoadFile(file, path + "/" + database + "/bfvoice", photoName);
                return database + "/bfvoice/" + photoName;
            } else {
                return null;
            }
        } catch (Exception e) {
            return null;
        }*/

    }

    public static String saveVoice(HttpServletRequest request, HttpServletResponse response, String folder, String database) {
        return upload(request, "voice", database, folder);/*
        MultipartHttpServletRequest imgRequest = (MultipartHttpServletRequest) request;
        try {
            MultipartFile file = imgRequest.getFile("voice");
            String photoType = StrUtil.returnFileType(file);
            if (!StrUtil.isNull(photoType)) {
                String path = "";
                path = QiniuConfig.getValue("FILE_UPLOAD_URL");
                if (StrUtil.isNull(path)) {
                    path = request.getSession().getServletContext().getRealPath("/upload/");
                }
                String photoName = System.currentTimeMillis() + photoType;
                StrUtil.upLoadFile(file, path + "/" + database + "/" + folder, photoName);
                return database + "/" + folder + "/" + photoName;
            } else {
                return null;
            }
        } catch (Exception e) {
            return null;
        }*/
    }


    /**
     * 上传一组图片
     * @param request
     * @param
     * @return
     */
    public static Map<String, Object> updatePhotos(HttpServletRequest request,String database,String folder,Integer type){
        List<String> fileNames = new ArrayList<String>();
        List<String> smallFile = new ArrayList<String>();
        List<MultipartFile> files = new ArrayList<MultipartFile>();
        Map<String, Object> map = new HashMap<String, Object>();
        String ifImg="1";//默认有图片
        String state="1";//默认处理状态为true
        try {
            MultipartHttpServletRequest imgRequest =null;
            try{
                imgRequest = (MultipartHttpServletRequest)request;
            }catch (Exception e) {
                ifImg="-1";//无图片
                map.put("ifImg", ifImg);
                map.put("state", state);
                return map;
            }
            Iterator<String> list = imgRequest.getFileNames();
            while (list.hasNext()) {
                MultipartFile file = imgRequest.getFile(list.next());
                files.add(file);
            }
            for (int i = 0; i < files.size(); i++) {
                String path="";
                String photoName="";
                MultipartFile file = files.get(i);
                int count=file.getName().indexOf("file");
                if(count>-1){
                    String photoType = StrUtil.returnFileType(file);
                    if(!StrUtil.isNull(photoType)){
                        path = request.getSession().getServletContext().getRealPath("/upload/");
                        //path = QiniuConfig.getValue("FILE_UPLOAD_URL");
                        if(StrUtil.isNull(path)){
                            path = request.getSession().getServletContext().getRealPath("/upload/");
                        }
                        photoName = System.currentTimeMillis()+i+photoType;
                        StrUtil.upLoadFile(file, path+"/" + database + "/" +folder,photoName);
                        fileNames.add(database + "/" +folder+"/"+photoName);
                        //进行图片压缩
                        ImageUtil.compressImsg(path+"/" + database + "/" +folder+"/"+photoName,path+"/" +database + "/"+folder+"/"+"/small_"+photoName,300,0);
                        String smallName = "small_"+photoName;
                        //裁剪图片
                        ImgCoordinate imgCoordinate = new ImgCoordinate();
                        imgCoordinate.setSrcpath(path+"/" + database + "/" +folder+"/"+smallName);
                        imgCoordinate.setFolder(path+"/"+ database + "/"+folder+"/");
                        imgCoordinate.setImgNm("small_"+ EncryptUtils.Encrypt(String.valueOf(System.currentTimeMillis())+(Math.random()*1000), "MD5"));
                        //imgCoordinate.setWidth(300);
                        //imgCoordinate.setHeight(200);
                        String cutName = ImageUtil.tailor(imgCoordinate,path+"/"+ database + "/"+folder+"/",smallName);//裁成正方形（裁长方形的方法安卓会报错未找到处理方式）
                        if(null==cutName){
                            state="-1";
                        }
//					ImageUtil.compressImsg(path+"/"+folder+"/"+photoName,path+"/"+folder+"/"+"/simage_"+photoName,100,100);
//					String simage = "simage_"+photoName;
                        smallFile.add(database + "/" + folder+"/"+cutName);
                    }
                }
            }
            map.put("fileNames",fileNames);
            map.put("smallFile",smallFile);
        } catch (Exception e) {
            state="-1";//处理状态失败
            e.printStackTrace();
        }
        map.put("ifImg", ifImg);
        map.put("state", state);
        return map;
    }
    /**
     * 上传一组图片
     *
     * @param request
     * @return
     */
    public static Map<String, Object> updatePhotos11(HttpServletRequest request, String bucket, String subPath, Integer type) {
        FileService fileService = SpringContextHolder.getBean(FileService.class);//new LocalFileService();//
        List<String> fileNames = new ArrayList<String>();
        List<String> smallFile = new ArrayList<String>();
        List<MultipartFile> files = new ArrayList<MultipartFile>();
        Map<String, Object> map = new HashMap<String, Object>();
        String folder = "other";
        String ifImg = "1";//默认有图片
        String state = "1";//默认处理状态为true
        try {
            MultipartHttpServletRequest imgRequest = null;
            try {
                imgRequest = (MultipartHttpServletRequest) request;
            } catch (Exception e) {
                ifImg = "-1";//无图片
                map.put("ifImg", ifImg);
                map.put("state", state);
                return map;
            }
            Iterator<String> list = imgRequest.getFileNames();
            while (list.hasNext()) {
                List<MultipartFile> file = imgRequest.getFiles(list.next());
                files.addAll(file);
            }
            for (int i = 0; i < files.size(); i++) {
                MultipartFile file = files.get(i);
                int count = file.getName().indexOf("file");
                if (count > -1) {
                    String photoType = StrUtil.returnFileType(file);
                    if (!StrUtil.isNull(photoType)) {

                        String path = request.getSession().getServletContext().getRealPath("/upload/");
                        path = QiniuConfig.getValue("FILE_UPLOAD_URL");
                        if (StrUtil.isNull(path)) {
                            path = request.getSession().getServletContext().getRealPath("/upload/");
                        }
                        String photoName = System.currentTimeMillis() + i + photoType;
                        StrUtil.upLoadFile(file, path + "/" + folder, photoName);
                        fileNames.add(folder + "/" + photoName);

                        InputStream inputStream = file.getInputStream();
                        //原图
                       // FileInfo fileInfo = fileService.store(bucket, subPath, inputStream, file.getOriginalFilename());
                       // fileNames.add(fileInfo.getName());
                        if (inputStream.markSupported()) {
                            inputStream.reset();
                        } else {
                            inputStream = new BufferedInputStream(file.getInputStream());
                        }
                        //缩略图
                        Optional<FileInfo> optional = FileUtils.compressionAndUpload(inputStream, bucket, subPath, file.getOriginalFilename(), fileService);
                        if (optional.isPresent()) {
                            FileInfo fileInfo = optional.get();
                            smallFile.add(fileInfo.getName());
                        } else {
                            state = "-1";
                        }

                        //InputStream compressedStream = ImageUtil.compressImageStream(inputStream, 300, 0, photoType);
                        //ImageUtil.compressImsg(path + "/" + folder + "/" + photoName, path + "/" + folder + "/" + "/small_" + photoName, 300, 0);
                        /*String smallName = "small_" + photoName;
                        //裁剪图片

                        imgCoordinate.setSrcpath(path + "/" + folder + "/" + smallName);
                        imgCoordinate.setFolder(path + "/" + folder + "/");
                        imgCoordinate.setImgNm("small_" + EncryptUtils.Encrypt(String.valueOf(System.currentTimeMillis()) + (Math.random() * 1000), "MD5"));*/
                        //imgCoordinate.setWidth(300);
                        //imgCoordinate.setHeight(200);
                        //String cutName = ImageUtil.tailor(imgCoordinate, path + "/" + folder + "/", smallName);//裁成正方形（裁长方形的方法安卓会报错未找到处理方式）
                       /* ImgCoordinate imgCoordinate = new ImgCoordinate();
                        InputStream thumbnailStream = ImageUtil.tailor(imgCoordinate, compressedStream, photoType);
                        compressedStream.reset();
                        if (null == thumbnailStream) {
                            state = "-1";
                        }*/


                        //FileInfo thumbnailFile = fileService.store(bucket, subPath, thumbnailStream, file.getOriginalFilename());
                        //fileNames.add(rawFile.getName());
                        //smallFile.add(thumbnailFile.getName());

//					ImageUtil.compressImsg(path+"/"+folder+"/"+photoName,path+"/"+folder+"/"+"/simage_"+photoName,100,100);
//					String simage = "simage_"+photoName;
                        //smallFile.add(folder + "/" + cutName);
                    }
                }
            }
            map.put("fileNames", fileNames);
            map.put("smallFile", smallFile);
        } catch (Exception e) {
            state = "-1";//处理状态失败
            e.printStackTrace();
        }
        map.put("ifImg", ifImg);
        map.put("state", state);
        return map;
    }

    /**
     * 上传一组图片
     *
     * @param request
     * @return
     */
    public static Map<String, Object> updatePhotosdg(HttpServletRequest request, String bucket, String subPath, Integer type, String num) {
        FileService fileService = SpringContextHolder.getBean(FileService.class);

        List<String> fileNames = new ArrayList<String>();
        List<String> smallFile = new ArrayList<String>();
        List<MultipartFile> files = new ArrayList<MultipartFile>();
        Map<String, Object> map = new HashMap<String, Object>();
        String ifImg = "1";//默认有图片
        String state = "1";//默认处理状态为true
        try {
            MultipartHttpServletRequest imgRequest;
            try {
                imgRequest = (MultipartHttpServletRequest) request;
            } catch (Exception e) {
                ifImg = "-1";//无图片
                map.put("ifImg", ifImg);
                map.put("state", state);
                return map;
            }
            Iterator<String> list = imgRequest.getFileNames();
            while (list.hasNext()) {
                List<MultipartFile> file = imgRequest.getFiles(list.next());
                files.addAll(file);
            }
            for (int i = 0; i < files.size(); i++) {
           /*     String path = "";
                String photoName = "";*/
                MultipartFile file = files.get(i);
                int count = file.getName().indexOf("file" + num);
                if (count > -1) {
                    String photoType = StrUtil.returnFileType(file);
                    if (!StrUtil.isNull(photoType)) {
                        //path = request.getSession().getServletContext().getRealPath("/upload/");
                        /*path = QiniuConfig.getValue("FILE_UPLOAD_URL");
                        if (StrUtil.isNull(path)) {
                            path = request.getSession().getServletContext().getRealPath("/upload/");
                        }
                        photoName = System.currentTimeMillis() + i + photoType;
                        StrUtil.upLoadFile(file, path + "/" + folder, photoName);
                        fileNames.add(folder + "/" + photoName);*/

                        InputStream inputStream = file.getInputStream();
                        FileInfo fileInfo = fileService.store(bucket, subPath, inputStream, file.getOriginalFilename());
                        fileNames.add(fileInfo.getName());


                        if (inputStream.markSupported()) {
                            inputStream.reset();
                        } else {
                            inputStream = new BufferedInputStream(file.getInputStream());
                        }
                        //缩略图
                        Optional<FileInfo> optional = FileUtils.compressionAndUpload(inputStream, bucket, subPath, file.getOriginalFilename(), fileService);

                        if (optional.isPresent()) {
                            fileInfo = optional.get();
                            smallFile.add(fileInfo.getName());
                        } else {
                            state = "-1";
                        }


                        //inputStream.reset();

                        //进行图片压缩
                        //InputStream compressedImageStream = ImageUtil.compressImageStream(inputStream, 300, 0, photoType);


                        //ImageUtil.compressImsg(path + "/" + folder + "/" + photoName, path + "/" + folder + "/" + "/small_" + photoName, 300, 0);
//                       // String smallName = "small_" + photoName;
                        //裁剪图片
                        //ImgCoordinate imgCoordinate = new ImgCoordinate();
                     /*   imgCoordinate.setSrcpath(path + "/" + folder + "/" + smallName);
                        imgCoordinate.setFolder(path + "/" + folder + "/");
                        imgCoordinate.setImgNm("small_" + EncryptUtils.Encrypt(String.valueOf(System.currentTimeMillis()) + (Math.random() * 1000), "MD5"));*/
                        //imgCoordinate.setWidth(300);
                        //imgCoordinate.setHeight(200);
                        //String cutName = ImageUtil.tailor(imgCoordinate, path + "/" + folder + "/", smallName);//裁成正方形（裁长方形的方法安卓会报错未找到处理方式）
                        /*InputStream thumbnailStream = ImageUtil.tailor(imgCoordinate, compressedImageStream, photoType);
                        compressedImageStream.reset();
                        if (null == thumbnailStream) {
                            state = "-1";
                        }


                        FileInfo thumbFile = fileService.store(bucket, subPath, thumbnailStream, file.getOriginalFilename());
                        smallFile.add(thumbFile.getName());*/

//					ImageUtil.compressImsg(path+"/"+folder+"/"+photoName,path+"/"+folder+"/"+"/simage_"+photoName,100,100);
//					String simage = "simage_"+photoName;
                        //smallFile.add(folder + "/" + cutName);
                    }
                }
            }
            map.put("fileNames", fileNames);
            map.put("smallFile", smallFile);
        } catch (Exception e) {
            state = "-1";//处理状态失败
            e.printStackTrace();
        }
        map.put("ifImg", ifImg);
        map.put("state", state);
        return map;
    }

    /**
     * 上传群图片
     *
     * @param request
     * @param response
     * @return
     */
    public static Map<String, Object> updatePhoto(HttpServletRequest request, HttpServletResponse response, Integer type, String groupHead, String groupBg, String database) {
        MultipartHttpServletRequest imgRequest = (MultipartHttpServletRequest) request;
        try {
            Map<String, MultipartFile> flies = new HashMap<String, MultipartFile>();
            MultipartFile file = null;
            Iterator<String> filedS = imgRequest.getFileNames();
            int i = 0;
            while (filedS.hasNext()) {
                i++;
                String temp = filedS.next();
                if (temp.equals("groupHead")) {
                    file = imgRequest.getFile(temp);
                    flies.put(groupHead, file);
                }
                if (temp.equals("groupBg")) {
                    file = imgRequest.getFile(temp);
                    flies.put(groupBg, file);
                }
                if (i > 2) {
                    break;
                }
            }

            if (type != null) {
                file = imgRequest.getFile("file");
                flies.put("file", file);
            }
            String photoType = StrUtil.returnFileType(file);
            Map<String, Object> map = new HashMap<String, Object>();
            if (!StrUtil.isNull(photoType)) {
                //String path = request.getSession().getServletContext().getRealPath("/upload");
                for (String fileName : flies.keySet()) {
                    i++;
                    //String photoName = System.currentTimeMillis() + i + photoType;
                    MultipartFile multipartFile = flies.get(fileName);
                    //StrUtil.upLoadFile(multipartFile, path + "/" + database + "/group", photoName);
                    String url = upload(multipartFile.getInputStream(), multipartFile.getOriginalFilename(), database, "group");
                    //map.put(fileName, database + "/group/" + photoName);
                    map.put(fileName, url);
                }
                return map;
            } else {
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    //上传个人背景图
    public static String upLoadUserBg(MultipartFile source, String basePath, String oldName) throws Exception {
        String cutName = null;
        if (null != source) {
            String photoType = StrUtil.returnFileType(source);
            if (!StrUtil.isNull(photoType)) {
//				path = request.getSession().getServletContext().getRealPath("/upload/");
                String photoName = System.currentTimeMillis() + photoType;
                StrUtil.upLoadFile(source, basePath, photoName);
//				fileNames.add(folder+"/"+photoName);
                //进行图片压缩
				/*ImageUtil.compressImsg(basePath+"/"+photoName,basePath+"/"+"/small_"+photoName,300,0);
				String smallName = "small_"+photoName;*/
                //裁剪图片
                ImgCoordinate imgCoordinate = new ImgCoordinate();
                imgCoordinate.setSrcpath(basePath + "/" + photoName);
                imgCoordinate.setFolder(basePath + "/");
                imgCoordinate.setImgNm("small_" + EncryptUtils.Encrypt(String.valueOf(System.currentTimeMillis()) + (Math.random() * 1000), "MD5"));
                imgCoordinate.setWidth(300);
                imgCoordinate.setHeight(200);
                cutName = ImageUtil.tailor(imgCoordinate, basePath + "/", photoName);
//				ImageUtil.compressImsg(path+"/"+folder+"/"+photoName,path+"/"+folder+"/"+"/simage_"+photoName,100,100);
//				String simage = "simage_"+photoName;
            }
        }
        return cutName;
    }


    /*
     * 根据尺寸图片居中裁剪
     */
    public static void cutCenterImage(String src, String dest, int w, int h) throws IOException {
        Iterator iterator = ImageIO.getImageReadersByFormatName("jpg");
        ImageReader reader = (ImageReader) iterator.next();
        InputStream in = new FileInputStream(src);
        ImageInputStream iis = ImageIO.createImageInputStream(in);
        reader.setInput(iis, true);
        ImageReadParam param = reader.getDefaultReadParam();
        int imageIndex = 0;
        Rectangle rect = new Rectangle((reader.getWidth(imageIndex) - w) / 2, (reader.getHeight(imageIndex) - h) / 2, w, h);
        param.setSourceRegion(rect);
        BufferedImage bi = reader.read(0, param);
        ImageIO.write(bi, "jpg", new File(dest));

    }


    /*
     * 图片缩放
     */
    public static void zoomImage(String src, String dest, int w, int h) throws Exception {
        double wr = 0, hr = 0;
        File srcFile = new File(src);
        File destFile = new File(dest);
        BufferedImage bufImg = ImageIO.read(srcFile);
        Image Itemp = bufImg.getScaledInstance(w, h, bufImg.SCALE_SMOOTH);
        wr = w * 1.0 / bufImg.getWidth();
        hr = h * 1.0 / bufImg.getHeight();
        AffineTransformOp ato = new AffineTransformOp(AffineTransform.getScaleInstance(wr, hr), null);
        Itemp = ato.filter(bufImg, null);
        try {
            ImageIO.write((BufferedImage) Itemp, dest.substring(dest.lastIndexOf(".") + 1), destFile);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /**
     * 上传一组图片(WangEditor插件)
     */
    public static Map<String, Object> updateWangEditorPhotos(HttpServletRequest request, HttpServletResponse response, String folder, Integer type) {
        List<String> fileNames = new ArrayList<String>();
        List<String> smallFile = new ArrayList<String>();
        List<MultipartFile> files = new ArrayList<MultipartFile>();
        Map<String, Object> map = new HashMap<String, Object>();
        String ifImg = "1";//默认有图片
        String state = "1";//默认处理状态为true
        try {
            MultipartHttpServletRequest imgRequest = null;
            try {
                imgRequest = (MultipartHttpServletRequest) request;
            } catch (Exception e) {
                ifImg = "-1";//无图片
                map.put("ifImg", ifImg);
                map.put("state", state);
                return map;
            }
            List<MultipartFile> multipartFileList = imgRequest.getFiles("file");
            for (int i = 0; i < multipartFileList.size(); i++) {
                MultipartFile file = multipartFileList.get(i);
                files.add(file);
            }
            for (int i = 0; i < files.size(); i++) {
                String path = "";
                String photoName = "";
                MultipartFile file = files.get(i);
                int count = file.getName().indexOf("file");
                if (count > -1) {
                    String photoType = StrUtil.returnFileType(file);
                    if (!StrUtil.isNull(photoType)) {
                        path = QiniuConfig.getValue("FILE_UPLOAD_URL");
                        if (StrUtil.isNull(path)) {
                            path = request.getSession().getServletContext().getRealPath("/upload/");
                        }
                        photoName = System.currentTimeMillis() + i + photoType;
                        StrUtil.upLoadFile(file, path + "/" + folder, photoName);
                        fileNames.add(folder + "/" + photoName);
                        //进行图片压缩
                        ImageUtil.compressImsg(path + "/" + folder + "/" + photoName, path + "/" + folder + "/" + "/small_" + photoName, 300, 0);
                        String smallName = "small_" + photoName;
                        //裁剪图片
                        ImgCoordinate imgCoordinate = new ImgCoordinate();
                        imgCoordinate.setSrcpath(path + "/" + folder + "/" + smallName);
                        imgCoordinate.setFolder(path + "/" + folder + "/");
                        imgCoordinate.setImgNm("small_" + EncryptUtils.Encrypt(String.valueOf(System.currentTimeMillis()) + (Math.random() * 1000), "MD5"));
                        String cutName = ImageUtil.tailor(imgCoordinate, path + "/" + folder + "/", smallName);//裁成正方形（裁长方形的方法安卓会报错未找到处理方式）
                        if (null == cutName) {
                            state = "-1";
                        }
                        smallFile.add(folder + "/" + cutName);
                    }
                }
            }
            map.put("fileNames", fileNames);
            map.put("smallFile", smallFile);
        } catch (Exception e) {
            state = "-1";//处理状态失败
            e.printStackTrace();
        }
        map.put("ifImg", ifImg);
        map.put("state", state);
        return map;
    }
}
