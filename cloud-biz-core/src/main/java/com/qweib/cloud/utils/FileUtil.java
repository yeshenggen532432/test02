package com.qweib.cloud.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.util.List;


public class FileUtil {
    private static Logger logger = LoggerFactory.getLogger(FileUtil.class);

    public FileUtil() {
    }

    /**
     * check if the file is exists.
     *
     * @param file
     *            String
     * @return boolean
     */
    public boolean ifExist(String file) {
        File f = new File(file);
        boolean returnValue = f.exists();
        f = null;
        return returnValue;
    }

    public boolean ifExist(String path, String fileName) {
        return ifExist(path + fileName);
    }

    /**
     * create file.
     *
     * @param file
     *            String
     * @return boolean
     */
    public boolean createFile(String file) {
        File f = new File(file);
        boolean b = false;
        if (!f.exists()) {
            try {
                b = f.createNewFile();
            } catch (IOException e) {
                logger.error("Exception in FileUtil,method createFile().", e);
            }
        }
        f = null;
        return b;
    }

    public static boolean deleteFile(String fileName) {
        File file = new File(fileName);
        return file.delete();
    }

    /**
     * add content to file
     *
     * @param file
     *            String
     * @param txt
     *            String
     */
    public boolean writeFile(String file, String txt) {
        File f = new File(file);
        if (!f.exists()) {
            createFile(file);
        }
        logger.info("输出文件内容:"+txt);
        String separator = System.getProperty("line.separator");
        logger.info("separator:"+separator);
        try {
            FileWriter writer = new FileWriter(f, true);
            writer.write(txt);
            writer.close();
            f = null;
            return true;
        } catch (IOException e) {
            logger.error("Exception in FileUtil,method writeFile().", e);
            return false;
        }
    }
    /**
     * 重写了导出文件的方法
     * @author xushh
     * @param filePath
     * @param columnsValue
     * @param columnsName
     * @return
     */
    public boolean writeFile(String filePath,List<String> columnsValue, String columnsName) {
        File f = new File(filePath);
        if (!f.exists()) {
            createFile(filePath);
        }
        logger.info("重写了导出文件的方法"+filePath);
        BufferedWriter bw=null;
        try {
        	bw=new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f,true),"gbk"));

        	logger.info("title conent:"+columnsName);
			bw.write(columnsName);
            bw.newLine();
            for(String value:columnsValue){
            	bw.write(value);
				bw.newLine();
				logger.info("date conent:"+value);
            }
            bw.flush();
            bw.close();
            return true;
        } catch (IOException e) {
            logger.debug("Exception in FileUtil,method writeFile().", e);
            return false;
        }
        catch (Exception e) {
            logger.debug("Exception in FileUtil,method writeFile().", e);
            return false;
        }
        finally{
        	bw=null;
        	f=null;
        }

    }

    public String toString() {
        return "version 1.0, date 2004.11.10, author river";
    }

    public static StringBuffer loadFileIntoBuffer(String file) {
        try {
            FileReader freader = new FileReader(file);
            BufferedReader reader = new BufferedReader(freader);
            StringBuffer buffer = new StringBuffer();
            String line = null;
            String separator = System.getProperty("line.separator");
            while ((line = reader.readLine()) != null) {
                buffer.append(line);
                buffer.append(separator);
            }
            reader.close();
            freader.close();
            return buffer;
        } catch (Exception e) {
            return null;
        }
    }

    public void replaceFileContent(String file, String regexp,
                                   String replacement) {
        StringBuffer buffer = loadFileIntoBuffer(file);
        if (buffer == null) {
            return;
        }
        String txt = buffer.toString();
        txt = txt.replaceAll(regexp, replacement);
        this.deleteFile(file);
        this.writeFile(file, txt);

    }

/**
     * 创建文件夹
     * @param folderPath
     */
    public static void createDirec(String folderPath) {
        try {
            String filePath = folderPath;
            String temp="";
            filePath = filePath.toString();

            while(filePath.indexOf("\\") >= 0){
                temp=temp+filePath.substring(0,filePath.indexOf("\\")+1);
                File myFilePath = new File(temp);
                if (!myFilePath.exists()) {
                    myFilePath.mkdir();
                }
                filePath=filePath.substring(filePath.indexOf("\\")+1);
            }

        } catch (Exception e) {
            e.getMessage();
        }
    }
    /**
     * 拷贝文件
     * @param sourceFile
     * @param targetFile
     * @throws IOException
     */
    public static void copyFile(File sourceFile, File targetFile) throws IOException {
		// 新建文件输入流并对它进行缓冲
		FileInputStream input = new FileInputStream(sourceFile);
		BufferedInputStream inBuff = new BufferedInputStream(input);

		// 新建文件输出流并对它进行缓冲
		FileOutputStream output = new FileOutputStream(targetFile);
		BufferedOutputStream outBuff = new BufferedOutputStream(output);
		try {
			// 缓冲数组
			byte[] b = new byte[1024];
			int len;
			while ((len = inBuff.read(b)) != -1) {
				outBuff.write(b, 0, len);
			}
			// 刷新此缓冲的输出流
			outBuff.flush();
		} catch (IOException io) {

		} finally {
			// 关闭流
			inBuff.close();
			outBuff.close();
			output.close();
			input.close();
		}
	}
    /**
     * 拷贝文件
     * @param sourceFile
     * @param targetFile
     * @throws zrp
     */
    public static void copyFile(String path,String sourcePath, String targetPath,String ym) throws Exception {
    	File dirPath = new File(path);
    	if (!dirPath.exists()) {
    		dirPath.mkdirs();
    	}
    	File ymfile = new File(path+"/upload/head/"+ym);
    	if(ymfile==null||!ymfile.exists()){
    		ymfile.mkdirs();
    	}
    	// 新建文件输入流并对它进行缓冲
    	File sourceFile = new File(sourcePath);
    	File targetFile = new File(targetPath);
    	if(sourceFile == null || !sourceFile.exists()){
    		throw new Exception("源文件不存在");
    	}
    	if(targetFile == null || !targetFile.exists()){
    		if(!targetFile.createNewFile()){
    			throw new Exception("创建文件失败");
    		}
    	}
    	BufferedInputStream inBuff = new BufferedInputStream(new FileInputStream(sourceFile));

    	// 新建文件输出流并对它进行缓冲
    	BufferedOutputStream outBuff = new BufferedOutputStream(new FileOutputStream(targetFile));
    	try {
    		// 缓冲数组
    		byte[] b = new byte[1024];
    		int len;
    		while ((len = inBuff.read(b)) != -1) {
    			outBuff.write(b, 0, len);
    		}
    		// 刷新此缓冲的输出流
    		outBuff.flush();
    	} finally {
    		// 关闭流
    		try{
    			inBuff.close();
    		}finally{
    			outBuff.close();
    		}
    	}
    }
}
