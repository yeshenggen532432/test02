package com.qweib.cloud.utils;

import com.google.common.io.Files;
import com.qweib.commons.StringUtils;
import com.qweib.fs.FileInfo;
import com.qweib.fs.path.DateBasedNamingStrategy;
import com.qweib.fs.path.FileNamingStrategy;
import com.qweib.fs.utils.MimeTypes;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.InputStream;

public class MyFileService {
    protected String domain;
    private String basePath;
    private String subPath;
    private FileNamingStrategy namingStrategy = new DateBasedNamingStrategy();

    public FileInfo store(String bucket, String path, InputStream inputStream, String rawName) throws Exception {
        String contentType = MimeTypes.getMimeType(Files.getFileExtension(rawName));
        return this.store(bucket, path, inputStream, rawName, contentType, (long)inputStream.available());
    }

    public FileInfo store(String bucket, InputStream inputStream, String path, String name, String rawName) throws Exception {
        String contentType = MimeTypes.getMimeType(Files.getFileExtension(rawName));
        long size = (long)inputStream.available();
        if (StringUtils.isNotEmpty(path)) {
            name = path + "/" + name;
        }

        FileInfo file = this.save(inputStream, bucket, name, contentType, size);
        file.setBucket(bucket);
        file.setName("/" + bucket + "/" + name);
        file.setOrigin(rawName);
        file.setExt(contentType);
        file.setMime(contentType);
        file.setSize(size);
        file.setDomain(this.domain);
        return file;
    }

    public FileInfo store(String bucket, String path, InputStream inputStream, String rawName, String contentType, long size) throws Exception {
        String fileName = this.namingStrategy.name(rawName);
        if (StringUtils.isNotEmpty(path)) {
            fileName = path + "/" + fileName;
        }

        FileInfo file = this.save(inputStream, bucket, fileName, contentType, size);
        file.setBucket(bucket);
        file.setName("/" + bucket + "/" + fileName);
        file.setOrigin(rawName);
        file.setExt(Files.getFileExtension(rawName));
        file.setMime(contentType);
        file.setSize(size);
        file.setDomain(this.domain);
        return file;
    }



    public void setDomain(String domain) {
        this.domain = domain;
    }

    public void setNamingStrategy(FileNamingStrategy namingStrategy) {
        this.namingStrategy = namingStrategy;
    }

    public FileInfo save(InputStream in, String bucket, String fileName, String contentType, long size) throws Exception {
        FileInfo fileInfo = new FileInfo();
        String path = this.basePath + "/" + this.subPath + "/" + Files.getNameWithoutExtension(fileName);
        int i = StringUtils.lastIndexOf(path, "/");
        String dir = StringUtils.substring(path, 0, i);
        File parent = new File(dir);
        if (!parent.exists()) {
            parent.mkdirs();
        }

        fileName = bucket + "/" + fileName;
        FileUtils.copyInputStreamToFile(in, new File(this.basePath + "/" + this.subPath + "/" + fileName));
        fileInfo.setUrl(this.domain + "/" + this.subPath + "/" + fileName);
        return fileInfo;
    }

    public void remove(String bucket, String object) {
        FileUtils.deleteQuietly(new File(this.basePath + "/" + this.subPath + "/" + object));
    }

    public void setBasePath(String basePath) {
        this.basePath = basePath;
    }

    public void setSubPath(String subPath) {
        this.subPath = subPath;
    }
}
