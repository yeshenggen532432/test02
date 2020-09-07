package com.qweib.cloud;

import com.qweib.cloud.utils.ImageUtil;
import com.qweib.cloud.utils.ImgCoordinate;
import com.qweib.commons.mapper.JsonMapper;
import com.qweib.fs.FileInfo;
import com.qweib.fs.FileService;
import com.qweib.fs.minio.MinIOClientFactoryBean;
import com.qweib.fs.minio.MinIOFileService;
import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.geometry.Positions;
import org.apache.commons.io.FileUtils;
import org.junit.Before;
import org.junit.Test;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

/**
 * @author: jimmy.lin
 * @time: 2019/9/24 11:18
 * @description:
 */
public class ThumnailTest {

    private FileService fileService;
    private String bucket = "aaatest";

    @Before
    public void init() throws Exception {
        MinIOFileService fs = new MinIOFileService();
        MinIOClientFactoryBean factory = new MinIOClientFactoryBean();
        factory.setAccessKey("3EB79FB677AC1E49");
        factory.setSecretKey("Duxf8x2Ij5jX5z40UTrjPUNZ5RlTG9ih");
        factory.setEndpoint("http://192.168.1.11:9500");
        factory.afterPropertiesSet();
        fs.setClient(factory.getObject());
        fs.setDomain("http://192.168.1.11:9500");
        this.fileService = fs;
    }

    @Test
    public void cropTest() throws Exception {
        String name = "IMG_3354";
        String ext = "PNG";
        String file = "F://tmp/" + name + "." + ext;
        String thumbName = "F://tmp/" + name + "-thumb." + ext;
        FileInputStream in = new FileInputStream(new File(file));
        FileInfo f1 = fileService.store(bucket, "image/raw", in, name+"."+ext);
        //in.reset();
        InputStream compressedStream = ImageUtil.compressImageStream(new FileInputStream(new File(file)), 300, 0, ext);
        InputStream thumbnail = ImageUtil.tailor(new ImgCoordinate(), compressedStream, ext);
        compressedStream.reset();
        FileUtils.copyInputStreamToFile(compressedStream, new File("F://tmp/"+name+"-thumb1."+ext));
        compressImsg(file, thumbName, 300, 0);
        compressedStream.reset();

        FileInfo f2 = fileService.store(bucket, "image/thumb", thumbnail, name+"-thumb."+ext);
        System.out.println(JsonMapper.toJsonString(f1));
        System.out.println(JsonMapper.toJsonString(f2));

    }

    @Test
    public void gifTest() throws Exception {
        FileInputStream in = new FileInputStream(new File("F://tmp/aaa.gif"));
        Thumbnails.of(in).outputFormat("gif")
                .outputQuality(0.8)
                .scale(0.6).toFile("F://tmp/aaa-1.gif");
    }

    private static void compressImsg(String src, String target,Integer maxWidth,Integer maxHeight) throws Exception {
        String dirStr = target.substring(0, target.lastIndexOf("/") + 1);
        File dir = new File(dirStr);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File srcFile = new File(src);
        File targetFile = new File(target);
        AffineTransform transform = new AffineTransform();
        BufferedImage biSrc = ImageIO.read(srcFile);
        int width = biSrc.getWidth();
        int height = biSrc.getHeight();
        int newWidth = maxWidth;
        int newHeight = (int) (((double) newWidth / width) * height);
        if (newHeight > maxHeight && 0!=maxHeight) {
            newHeight = maxHeight;
            newWidth = (int) (((double) newHeight / height) * width);
        }
        double scaleX = (double) newWidth / width;
        double scaleY = (double) newHeight / height;
        transform.setToScale(scaleX, scaleY);
        BufferedImage biTarget = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_3BYTE_BGR);
        Graphics2D gd2 = biTarget.createGraphics();
        gd2.drawImage(biSrc, transform,null);
        gd2.dispose();
        ImageIO.write(biTarget, "jpeg", targetFile);
    }

    @Test
    public void thumbTest() throws Exception {
        FileInputStream in = new FileInputStream(new File("F://tmp/gitlab-ci.png"));
        BufferedImage image = ImageIO.read(new File("F://tmp/gitlab-ci.png"));
        int width = image.getWidth();
        int height = image.getHeight();
        float rate = width / height;
        int size = rate > 1 ? height : width;
        Thumbnails.of(in).crop(Positions.CENTER)
                .size(size, size)
                .toFile("F://tmp/gitlab-ci_thumb.png");
    }

}
