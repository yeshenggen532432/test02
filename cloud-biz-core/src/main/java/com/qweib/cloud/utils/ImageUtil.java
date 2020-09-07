package com.qweib.cloud.utils;

import com.qweib.cloud.core.exception.BizException;
import com.qweib.commons.StringUtils;
import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;

import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URL;
import java.util.Iterator;


/**
 * 说明：
 *
 * @创建：作者:yxy 创建时间：2012-11-21
 * @修改历史： [序号](yxy 2012 - 11 - 21)<修改说明>
 */
@Slf4j
public class ImageUtil {
    /**
     * 摘要：
     *
     * @param baseFile  原图片
     * @param newFolder 新图片文件夹
     * @param newFile   新图片名称
     * @param width     宽度
     * @param height    高度
     * @说明：缩放图片
     * @创建：作者:yxy 创建时间：2012-11-21
     * @修改历史： [序号](yxy 2012 - 11 - 21)<修改说明>
     */
    @SuppressWarnings("static-access")
    public static void scImgBySize(String baseFile, String newFolder,
                                   String newFile, int width, int height) throws RuntimeException {
        File bf = new File(baseFile);
        if (!bf.isFile()) {
            throw new RuntimeException("不是一个文件");
        }
        try {
            String suffix = baseFile.substring(baseFile.lastIndexOf(".") + 1)
                    .toLowerCase();
            double ratio = 0.0;
            File tempFile = new File(newFolder);
            if (!tempFile.exists()) {
                tempFile.mkdirs();
            }
            tempFile = new File(newFile);
            if (tempFile.exists()) {
                tempFile.delete();
            }
            BufferedImage bi = ImageIO.read(bf);
            int sourceWidth = bi.getWidth();
            int sourceHeight = bi.getHeight();
            double rateWidth = ((double) width) / sourceWidth;
            double rateHeight = ((double) height) / sourceHeight;
            if (rateWidth > rateHeight) {
                ratio = rateWidth;
            } else {
                ratio = rateHeight;
            }
            Image image = bi.getScaledInstance(width, height, bi.SCALE_SMOOTH);
            AffineTransformOp op = new AffineTransformOp(AffineTransform
                    .getScaleInstance(ratio, ratio), null);
            image = op.filter(bi, null);
            ImageIO.write((BufferedImage) image, suffix, tempFile);
        } catch (Exception ex) {
            throw new RuntimeException("缩放图片出错：" + ex.getMessage());
        } finally {
            if (null != bf && bf.exists()) {
                bf.delete();
            }
        }
    }

    /**
     * 摘要：
     *
     * @param baseFile 源文件
     * @param newFile  新文件
     * @param width    宽度
     * @param height   高度
     * @说明：缩放图片
     * @创建：作者:yxy 创建时间：2012-11-21
     * @修改历史： [序号](yxy 2012 - 11 - 21)<修改说明>
     */
    @SuppressWarnings("static-access")
    public static void scImgBySize(String baseFile, String newFile, int width,
                                   int height) throws RuntimeException {
        File bf = new File(baseFile);
        if (!bf.isFile()) {
            throw new RuntimeException("不是一个文件");
        }
        try {
            String suffix = baseFile.substring(baseFile.lastIndexOf(".") + 1)
                    .toLowerCase();
            double ratio = 0.0;
            File tempFile = new File(newFile);
            if (tempFile.exists()) {
                tempFile.delete();
            }
            String newForder = newFile.substring(0, newFile.lastIndexOf("/"));
            File file = new File(newForder);
            if (!file.exists()) {
                file.mkdir();
            }
            BufferedImage bi = ImageIO.read(bf);
            int sourceWidth = bi.getWidth();
            int sourceHeight = bi.getHeight();
            double rateWidth = ((double) width) / sourceWidth;
            double rateHeight = ((double) height) / sourceHeight;
            if (rateWidth > rateHeight) {
                ratio = rateWidth;
            } else {
                ratio = rateHeight;
            }
            Image image = bi.getScaledInstance(width, height, bi.SCALE_SMOOTH);
            AffineTransformOp op = new AffineTransformOp(AffineTransform
                    .getScaleInstance(ratio, ratio), null);
            image = op.filter(bi, null);
            ImageIO.write((BufferedImage) image, suffix, tempFile);
        } catch (Exception ex) {
            throw new RuntimeException("缩放图片出错：" + ex.getMessage());
        } finally {
            if (null != bf && bf.exists()) {
                bf.delete();
            }
        }
    }

    /**
     * 说明：图片剪裁
     *
     * @创建：作者:llp 创建时间：2013-8-21
     * @修改历史： [序号](llp 2013 - 8 - 21)<修改说明>
     */
    public static String clipping(ImgCoordinate imgCoordinate) {
        FileInputStream is = null;
        ImageInputStream iis = null;
        File file = new File("");
        try {
            String srcpath = imgCoordinate.getSrcpath();
            is = new FileInputStream(srcpath);
            String postFix = srcpath.substring(srcpath.lastIndexOf(".") + 1)
                    .toLowerCase();
            Iterator<ImageReader> it = getImageReadersByFormatName(postFix);
            ImageReader reader = it.next();
            iis = ImageIO.createImageInputStream(is);
            reader.setInput(iis, true);
            ImageReadParam param = reader.getDefaultReadParam();
            Rectangle rect = new Rectangle(imgCoordinate.getX1(), imgCoordinate
                    .getY1(), imgCoordinate.getWidth(), imgCoordinate
                    .getHeight());
            param.setSourceRegion(rect);
            BufferedImage bi = reader.read(0, param);
            file = new File(srcpath);
            // 保存新图片
            String folder = imgCoordinate.getFolder();
            File f = new File(folder);
            if (!f.exists()) {
                f.mkdirs();
            }
            String imgNm = imgCoordinate.getImgNm() + "." + postFix;
            ImageIO.write(bi, postFix, new File(folder + "/" + imgNm));
            return imgNm;
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        } finally {
            if (is != null) {
                try {
                    is.close();
                    if (file.exists() || file != null) {
                        file.delete();
                    }
                } catch (IOException e) {
                }
            }
            if (iis != null) {
                try {
                    iis.close();
                    if (file.exists() || file != null) {
                        file.delete();
                    }
                } catch (IOException e) {
                }
            }
        }
    }

    private static Iterator<ImageReader> getImageReadersByFormatName(
            String postFix) {
        postFix = postFix.toLowerCase();
        if (postFix.equals("jpg") || postFix.equals("jpeg")) {
            return ImageIO.getImageReadersByFormatName("jpg");
        } else if (postFix.equals("png")) {
            return ImageIO.getImageReadersByFormatName("png");
        } else {
            return ImageIO.getImageReadersByFormatName("jpg");
        }
    }

    /**
     * 摘要：
     *
     * @param baseFile 原图片
     * @param newFile  新图片名称
     * @param width    宽度
     * @param height   高度
     * @说明：缩放图片
     * @创建：作者:yxy 创建时间：2012-11-21
     * @修改历史： [序号](yjp 2014 - 05 - 08)<修改说明>不删除原文件
     */
    @SuppressWarnings("static-access")
    public static void scImgBySizes(String baseFile, String newFile, int width,
                                    int height) throws RuntimeException {
        File bf = new File(baseFile);
        if (!bf.isFile()) {
            throw new RuntimeException("不是一个文件");
        }
        try {
            String suffix = baseFile.substring(baseFile.lastIndexOf(".") + 1)
                    .toLowerCase();
            double ratio = 0.0;
            File tempFile = new File(newFile);
            if (tempFile.exists()) {
                tempFile.delete();
            }
            BufferedImage bi = ImageIO.read(bf);
            int sourceWidth = bi.getWidth();
            int sourceHeight = bi.getHeight();
            double rateWidth = ((double) width) / sourceWidth;
            double rateHeight = ((double) height) / sourceHeight;
            if (rateWidth > rateHeight) {
                ratio = rateWidth;
            } else {
                ratio = rateHeight;
            }
            Image image = null;
            if (sourceWidth <= width && sourceHeight <= height) {
                image = bi.getScaledInstance(sourceWidth, sourceHeight,
                        bi.SCALE_SMOOTH);
            } else {
                image = bi.getScaledInstance(width, height, bi.SCALE_SMOOTH);
            }
            AffineTransformOp op = new AffineTransformOp(AffineTransform
                    .getScaleInstance(ratio, ratio), null);
            image = op.filter(bi, null);
            ImageIO.write((BufferedImage) image, suffix, tempFile);
        } catch (Exception ex) {
            throw new RuntimeException("缩放图片出错：" + ex.getMessage());
        }
    }

    /**
     * @param basePath
     * @param filePath
     * @param strUr1
     * @说明：HTTP下载图片
     */
    public static void downPictureToInternet(String basePath, String filePath,
                                             String strUr1) {
        try {
            URL url = new URL(strUr1);
            InputStream fStream = url.openConnection().getInputStream();
            int b = 0;
            // 正式图片目录
            File folder = new File(basePath);
            // 目录不存在创建
            if (!folder.exists()) {
                folder.mkdir();
            }
            FileOutputStream fos = new FileOutputStream(new File(filePath));
            while ((b = fStream.read()) != -1) {
                fos.write(b);
            }
            fStream.close();
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static InputStream clip(int width, int height, InputStream stream, String type) {
        try {
            type = StringUtils.replace(type,".", "");
            ByteArrayOutputStream bao = new ByteArrayOutputStream();
            Thumbnails.of(stream).size(width, height)
                    .outputFormat(type)
                    .toOutputStream(bao);
            return new ByteArrayInputStream(bao.toByteArray());
        } catch (IOException e) {
            log.error("图片裁剪失败", e);
        }
        return null;
    }

    /**
     * 说明：图片剪裁
     *
     * @throws Exception
     * @创建：作者:llp 创建时间：2013-8-21
     * @修改历史： [序号](llp 2013 - 8 - 21)<计算等比例>
     */
    @Deprecated
    public static String clipping(ImgCoordinate imgCoordinate, String realPath,
                                  String fileName) throws Exception {
        FileInputStream is = null;
        ImageInputStream iis = null;
        // 进行在截取零时文件
        compressImsg(realPath + fileName, realPath + "temp_" + fileName, 300,
                0);
        File tempFile = new File(realPath + "temp_" + fileName);
        try {
            BufferedImage bis = ImageIO.read(tempFile);

            int sourceWidth = bis.getWidth();
            int sourceHeight = bis.getHeight();
            int x1 = imgCoordinate.getX1();//默认为0
            int y1 = imgCoordinate.getY1();//默认为0
            int targeWidth = imgCoordinate.getWidth();
            int targeHeight = imgCoordinate.getHeight();
            // 根据原图大小中间裁剪图片
            if (sourceWidth <= targeWidth) {
                targeWidth = sourceWidth;
            } else {
                x1 = (sourceWidth - targeWidth) / 2;
            }
            if (sourceHeight <= targeHeight) {
                targeHeight = sourceHeight;
            } else {
                y1 = (sourceHeight - targeHeight) / 2;
            }
            // 截取start----------------------------------
            String srcpath = realPath + "temp_" + fileName;
            is = new FileInputStream(srcpath);
            String postFix = srcpath.substring(srcpath.lastIndexOf(".") + 1)
                    .toLowerCase();
            Iterator<ImageReader> it = getImageReadersByFormatName(postFix);
            ImageReader reader = it.next();
            iis = ImageIO.createImageInputStream(is);

            reader.setInput(iis, true);

            ImageReadParam param = reader.getDefaultReadParam();

            Rectangle rect = new Rectangle(x1, y1, targeWidth, targeHeight);
            param.setSourceRegion(rect);
            BufferedImage bi = reader.read(0, param);
            // 保存新图片
            String folder = imgCoordinate.getFolder();
            File f = new File(folder);
            if (!f.exists()) {
                f.mkdirs();
            }
            String imgNm = imgCoordinate.getImgNm() + "." + postFix;
            ImageIO.write(bi, postFix, new File(folder + "\\" + imgNm));

            return imgNm;
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                }
            }
            if (iis != null) {
                try {
                    iis.close();
                } catch (IOException e) {
                }
            }
            tempFile.delete();
            File files = new File(imgCoordinate.getSrcpath());
            if (files.exists()) {
                files.delete();
            }
        }
    }


    //按宽高裁剪图片，裁成正方形，以宽高小的一边为尺寸
    public static String tailor(ImgCoordinate imgCoordinate, String realPath,
                                String fileName) {
        FileInputStream is = null;
        ImageInputStream iis = null;
        // 进行在截取零时文件
        scImgBySizes(realPath + fileName, realPath + "temp_" + fileName, 200,
                200);
        File tempFile = new File(realPath + "temp_" + fileName);
        try {
            BufferedImage bis = ImageIO.read(tempFile);
            int sourceWidth = bis.getWidth();
            int sourceHeight = bis.getHeight();
            if (sourceWidth > sourceHeight) {
                imgCoordinate.setY1(0);
                int _y = (sourceWidth - sourceHeight) / 2;
                imgCoordinate.setX1(_y);
                imgCoordinate.setWidth(sourceHeight);
                imgCoordinate.setHeight(sourceHeight);
            } else if (sourceWidth < sourceHeight) {
                imgCoordinate.setX1(0);
                int _y = (sourceHeight - sourceWidth) / 2;
                imgCoordinate.setY1(_y);
                imgCoordinate.setWidth(sourceWidth);
                imgCoordinate.setHeight(sourceWidth);
            } else {
                imgCoordinate.setY1(0);
                imgCoordinate.setY1(0);
                imgCoordinate.setWidth(sourceWidth);
                imgCoordinate.setHeight(sourceWidth);
            }

            // 截取start----------------------------------
            String srcpath = realPath + "temp_" + fileName;
            is = new FileInputStream(srcpath);
            String postFix = srcpath.substring(srcpath.lastIndexOf(".") + 1)
                    .toLowerCase();
            Iterator<ImageReader> it = getImageReadersByFormatName(postFix);
            ImageReader reader = it.next();
            iis = ImageIO.createImageInputStream(is);

            reader.setInput(iis, true);

            ImageReadParam param = reader.getDefaultReadParam();

            Rectangle rect = new Rectangle(imgCoordinate.getX1(), imgCoordinate
                    .getY1(), imgCoordinate.getWidth(), imgCoordinate
                    .getHeight());
            param.setSourceRegion(rect);
            BufferedImage bi = reader.read(0, param);
            // 保存新图片
            String folder = imgCoordinate.getFolder();
            File f = new File(folder);
            if (!f.exists()) {
                f.mkdirs();
            }
            String imgNm = imgCoordinate.getImgNm() + "." + postFix;
            ImageIO.write(bi, postFix, new File(folder + "/" + imgNm));

            return imgNm;
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                }
            }
            if (iis != null) {
                try {
                    iis.close();
                } catch (IOException e) {
                }
            }
            tempFile.delete();
            File files = new File(imgCoordinate.getSrcpath());
            if (files.exists()) {
                files.delete();
            }
//			System.out.println(fileName);
        }
    }


    //按宽高裁剪图片，裁成正方形，以宽高小的一边为尺寸
    public static InputStream tailor(ImgCoordinate imgCoordinate, InputStream rawImageStream, String type) {
        try {
            type = StringUtils.replace(type,".", "");
            BufferedImage bis = ImageIO.read(rawImageStream);

            int sourceWidth = bis.getWidth();
            int sourceHeight = bis.getHeight();
            if (sourceWidth > sourceHeight) {
                imgCoordinate.setY1(0);
                int _y = (sourceWidth - sourceHeight) / 2;
                imgCoordinate.setX1(_y);
                imgCoordinate.setWidth(sourceHeight);
                imgCoordinate.setHeight(sourceHeight);
            } else if (sourceWidth < sourceHeight) {
                imgCoordinate.setX1(0);
                int _y = (sourceHeight - sourceWidth) / 2;
                imgCoordinate.setY1(_y);
                imgCoordinate.setWidth(sourceWidth);
                imgCoordinate.setHeight(sourceWidth);
            } else {
                imgCoordinate.setY1(0);
                imgCoordinate.setY1(0);
                imgCoordinate.setWidth(sourceWidth);
                imgCoordinate.setHeight(sourceWidth);
            }

            ByteArrayOutputStream arrayOutputStream = new ByteArrayOutputStream();
            Thumbnails.of(bis)
                    .size(imgCoordinate.getWidth(), imgCoordinate.getHeight())
                    .sourceRegion(imgCoordinate.getX1(), imgCoordinate.getY1(),
                            imgCoordinate.getWidth(), imgCoordinate.getHeight())
                    .outputFormat(type)
                    .toOutputStream(arrayOutputStream);
            return new ByteArrayInputStream(arrayOutputStream.toByteArray());
        } catch (Exception e) {
            log.error("crop failed", e);
            throw new BizException("图片裁剪失败");
        }
    }


    /**
     * 等比压缩图像
     *
     * @param src       源图像文件
     * @param target    压缩后要存放的目标文件
     * @param maxWidth  压缩后允许的最大宽度
     * @param maxHeight 压缩后允许的最大高度 （0：宽固定，高等比缩放）
     * @throws IOException
     */
    public static void compressImsg(String src, String target, Integer maxWidth, Integer maxHeight) throws Exception {
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
        if (newHeight > maxHeight && 0 != maxHeight) {
            newHeight = maxHeight;
            newWidth = (int) (((double) newHeight / height) * width);
        }
        double scaleX = (double) newWidth / width;
        double scaleY = (double) newHeight / height;
        transform.setToScale(scaleX, scaleY);
        BufferedImage biTarget = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_3BYTE_BGR);
        Graphics2D gd2 = biTarget.createGraphics();
        gd2.drawImage(biSrc, transform, null);
        gd2.dispose();
        ImageIO.write(biTarget, "jpeg", targetFile);
    }

    public static void main(String[] args) {
        System.out.println(StringUtils.replace(".png", ".", ""));
    }

    /**
     * 图片流压缩
     *
     * @param inputStream
     * @param maxWidth
     * @param maxHeight
     * @return
     * @throws Exception
     */
    public static InputStream compressImageStream(InputStream inputStream, Integer maxWidth, Integer maxHeight, String type) throws Exception {
        type = StringUtils.replace(type,".", "");
        BufferedImage biSrc = ImageIO.read(inputStream);
        int width = biSrc.getWidth();
        int height = biSrc.getHeight();
        int newWidth = maxWidth;
        int newHeight = (int) (((double) newWidth / width) * height);
        if (newHeight > maxHeight && 0 != maxHeight) {
            newHeight = maxHeight;
            newWidth = (int) (((double) newHeight / height) * width);
        }
        double scaleX = (double) newWidth / width;
        double scaleY = (double) newHeight / height;
        AffineTransform transform = new AffineTransform();
        transform.setToScale(scaleX, scaleY);
        BufferedImage biTarget = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_3BYTE_BGR);
        Graphics2D gd2 = biTarget.createGraphics();
        gd2.drawImage(biSrc, transform, null);
        gd2.dispose();
        ByteArrayOutputStream bao = new ByteArrayOutputStream();
        ImageIO.write(biTarget, "jpeg", bao);
        return new ByteArrayInputStream(bao.toByteArray());
    }


    public static void resize(String filePath, int height, int width, boolean bb) {
        try {
            double ratio = 0; // 缩放比例
            File f = new File(filePath);
            BufferedImage bi = ImageIO.read(f);
            Image itemp = bi.getScaledInstance(width, height,
                    BufferedImage.SCALE_SMOOTH);
            // 计算比例
            if ((bi.getHeight() > height) || (bi.getWidth() > width)) {
                if (bi.getHeight() > bi.getWidth()) {
                    ratio = (new Integer(height)).doubleValue()
                            / bi.getHeight();
                } else {
                    ratio = (new Integer(width)).doubleValue() / bi.getWidth();
                }
                AffineTransformOp op = new AffineTransformOp(AffineTransform
                        .getScaleInstance(ratio, ratio), null);
                itemp = op.filter(bi, null);
            }
            if (bb) {
                BufferedImage image = new BufferedImage(width, height,
                        BufferedImage.TYPE_INT_RGB);
                Graphics2D g = image.createGraphics();
                g.setColor(Color.white);
                g.fillRect(0, 0, width, height);
                if (width == itemp.getWidth(null))
                    g.drawImage(itemp, 0, (height - itemp.getHeight(null)) / 2,
                            itemp.getWidth(null), itemp.getHeight(null),
                            Color.white, null);
                else
                    g.drawImage(itemp, (width - itemp.getWidth(null)) / 2, 0,
                            itemp.getWidth(null), itemp.getHeight(null),
                            Color.white, null);
                g.dispose();
                itemp = image;
            }
            ImageIO.write((BufferedImage) itemp, "jpg", f);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * @param start 文件路径
     * @param end   目标路径(包含文件名)
     * @创建：作者:YYP 创建时间：2014-11-28
     * @see 复制文件
     */
    public static void copyFile(String start, String end) {
        try {
            //要拷贝的文件
            BufferedInputStream bis = new BufferedInputStream(new FileInputStream(new File(start)));
            //目标的地址
            BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(new File(end)));
            try {
                int val = -1;
                while ((val = bis.read()) != -1) {
                    bos.write(val);
                }
                bos.flush();
                bos.close();
                bis.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }
}
