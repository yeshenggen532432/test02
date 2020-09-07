package com.qweib.cloud.biz.common;

import com.qweib.cloud.core.exception.BizException;
import com.qweib.fs.FileInfo;
import com.qweib.fs.FileService;
import com.qweibframework.commons.StringUtils;
import net.coobird.thumbnailator.Thumbnails;
import org.apache.commons.io.IOUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/10/30 - 11:00
 */
public class FileUtils {

    private static final int LIMIT_SIZE = 500;

    private static final Pattern IMAGE_PATTERN = Pattern.compile("<img[^>]+>");

    private static final Pattern IMAGE_DATA_PATTERN = Pattern.compile("data:image\\S+?base64,([^\"]+)");

    public static String convertImageData(String content, String baseDomain, String bucket, String path, FileService fileService) {
        StringBuffer sb = new StringBuffer(content.length());
        Matcher matcher = IMAGE_PATTERN.matcher(content);
        while (matcher.find()) {
            String imageTag = matcher.group();
            Matcher imageMatcher = IMAGE_DATA_PATTERN.matcher(imageTag);
            if (imageMatcher.find()) {
                StringBuffer imgSb = new StringBuffer(imageTag.length());
                imageMatcher.appendReplacement(imgSb, baseDomain + convertImageUrl(imageMatcher.group(1), bucket, path, fileService));
                imageMatcher.appendTail(imgSb);

                matcher.appendReplacement(sb, imgSb.toString());
            } else {
                matcher.appendReplacement(sb, imageTag);
            }
        }

        matcher.appendTail(sb);

        return sb.toString();
    }

    private static String convertImageUrl(String imageData, String bucket, String path, FileService fileService) {
        byte[] imageBytes = Base64.getDecoder().decode(imageData);
        Optional<FileInfo> optional = compressionAndUpload(imageBytes, bucket, path, null, fileService);

        return optional.isPresent() ? optional.get().getName() : StringUtils.EMPTY;
    }

    public static Optional<FileInfo> compressionAndUpload(InputStream inputStream, String bucket, String path, String fileName, FileService fileService) throws IOException {
        byte[] imageBytes = IOUtils.toByteArray(inputStream);
        return compressionAndUpload(imageBytes, bucket, path, fileName, fileService);
    }

    private final static Map<String, String> IMAGE_TYPE_CACHE = new HashMap<>();

    static {
        IMAGE_TYPE_CACHE.put("jpg", "FFD8FF");
        IMAGE_TYPE_CACHE.put("png", "89504E47");
        IMAGE_TYPE_CACHE.put("bmp", "424D");
    }

    public static boolean isImage(byte[] bytes) {
        String fileType = getFileHexString(bytes).toUpperCase();
        if (Objects.isNull(fileType)) {
            return false;
        }

        for (Map.Entry<String, String> entry : IMAGE_TYPE_CACHE.entrySet()) {
            String value = entry.getValue();
            if (fileType.startsWith(value)) {
                return true;
            }
        }

        return false;
    }

    public static void main(String[] args) throws IOException {
        byte[] imageBytes = IOUtils.toByteArray(new FileInputStream("G:/11/44.png"));
        //byte[] fileTypeBytes = Arrays.copyOf(imageBytes, 50);
        //System.out.println(isImage(fileTypeBytes));
        byte[] target = compression(imageBytes, "33.png");
        File file = new File("G:/11/444.png");
        FileOutputStream out = new FileOutputStream(file);
        out.write(target);
        out.close();
        /*try {
            InputStream inputStream = ImageUtil.compressImageStream(new FileInputStream("G:/11/33.jpg"), 500,500, "1.jpg");
            File file = new File("G:/11/22.jpg");
            FileOutputStream out = new FileOutputStream(file);
            byte[] bytes = new byte[1024];
            while (inputStream.read(bytes) > 0) {
                out.write(bytes);
            }
            out.close();
        } catch (Exception e) {

        }*/

    }

    private static String getFileHexString(byte[] bytes) {
        if (Objects.isNull(bytes) || bytes.length < 1) {
            return null;
        }
        StringBuilder str = new StringBuilder(64);
        for (byte b : bytes) {
            int value = b & 0xFF;
            String hexValue = Integer.toHexString(value);
            if (hexValue.length() < 2) {
                str.append(0);
            }
            str.append(hexValue);
        }

        return str.toString();
    }

    public static byte[] compress(InputStream in, String fileName) throws IOException {
        byte[] imageBytes = IOUtils.toByteArray(in);
        return compress(imageBytes, fileName);
    }

    public static byte[] compress(byte[] origin, String fileName){
        byte[] fileTypeBytes = Arrays.copyOf(origin, 50);
        fileName = StringUtils.isNotBlank(fileName) ? fileName : "image.jpg";
        if (isImage(fileTypeBytes)) {
            origin = compression(origin, fileName);
        }
        return origin;
    }

    public static Optional<FileInfo> compressionAndUpload(byte[] originDatas, String bucket, String path, String fileName, FileService fileService) {
        byte[] fileTypeBytes = Arrays.copyOf(originDatas, 50);
        fileName = StringUtils.isNotBlank(fileName) ? fileName : "image.jpg";
        if (isImage(fileTypeBytes)) {
            originDatas = compression(originDatas, fileName);
        }
        try (ByteArrayInputStream inputStream = new ByteArrayInputStream(originDatas)) {
            FileInfo fileInfo = fileService.store(bucket, path, inputStream, fileName);

            return Optional.ofNullable(fileInfo);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return Optional.empty();
    }

    private static byte[] compression(byte[] originDatas, String fileName) {
        try (ByteArrayInputStream inputStream = new ByteArrayInputStream(originDatas)) {
            BufferedImage bufferedImage = ImageIO.read(inputStream);
            int width = bufferedImage.getWidth();
            int height = bufferedImage.getHeight();
            int maxSize = Math.max(width, height);

            if (maxSize > LIMIT_SIZE) {
                float factor = (float) maxSize / LIMIT_SIZE;
                if (width > height) {
                    width = LIMIT_SIZE;
                    height = (int) ((float) height / factor);
                } else {
                    width = (int) ((float) width / factor);
                    height = LIMIT_SIZE;
                }
            } else {
                return originDatas;
            }
            String type = null;
            //获取图片后缀
            if (StringUtils.isNotBlank(fileName) && fileName.indexOf(".") > 0)
                type = fileName.substring(fileName.lastIndexOf(".") + 1);
            try (ByteArrayOutputStream os = new ByteArrayOutputStream(1024)) {
                Thumbnails.of(bufferedImage)
                        .size(width, height)
                        .outputFormat(StringUtils.isNotBlank(type) ? type : "jpg")
                        .toOutputStream(os);
                return os.toByteArray();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return originDatas;
    }

    public static File copyFile(MultipartFile uploadFile, HttpServletRequest request) {
        if (uploadFile == null) {
            throw new BizException("请选择文件上传");
        }

        ServletContext servletContext = request.getSession().getServletContext();
        String rootPath = servletContext.getRealPath("/upload");

        String fileName = ((CommonsMultipartFile) uploadFile).getFileItem().getName();
        String fileSuffix = fileName.substring(fileName.lastIndexOf("."));

        File dirFile = new File(rootPath);
        if (!dirFile.exists()) {
            dirFile.mkdirs();
        }
        File importFile = new File(rootPath, UUID.randomUUID().toString() + fileSuffix);
        try {
            uploadFile.transferTo(importFile);
        } catch (IOException e) {
            throw new BizException("该文件有错误");
        }

        return importFile;
    }
}
