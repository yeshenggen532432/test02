package com.qweib.cloud.utils;

import java.io.*;
import java.util.Properties;

public class PropertiesUtils {
	/**
	 * 根据key查询properties的value
	 * @param filePath properties文件地址
	 * @param key
	 * @return
	 */
	public static String readProperties(String filePath,String key){
		Properties properties = new Properties();
		String value = "";
		try{
			InputStream is = PropertiesUtils.class.getResourceAsStream(filePath);
			properties.load(is);
			value = properties.getProperty(key);
		}catch (FileNotFoundException ex){
//            System.out.println("读取属性文件--->失败！- 原因：文件路径错误或者文件不存在");
            ex.printStackTrace();
        } catch (IOException ex){
//            System.out.println("装载文件--->失败!");
            ex.printStackTrace();
        }catch(Exception e){
			e.printStackTrace();
		}
		return value;
	}

	/**
	 * 查询properties
	 * @param filePath properties文件地址
	 * @return
	 */
	public static Properties readProperties(String filePath){
		Properties properties = new Properties();
		try{
			InputStream is = PropertiesUtils.class.getResourceAsStream(filePath);
			properties.load(is);
		}catch (FileNotFoundException ex){
            System.out.println("读取属性文件--->失败！- 原因：文件路径错误或者文件不存在");
            ex.printStackTrace();
        } catch (IOException ex){
            System.out.println("装载文件--->失败!");
            ex.printStackTrace();
        }catch(Exception e){
			e.printStackTrace();
		}
		return properties;
	}

	/**
	 * 写properties
	 * @param filePath properties文件地址
	 * @param key
	 * @param value
	 * @return
	 */
	public static boolean writeProperties(String filePath,String key,String value){
		Properties properties = new Properties();
		boolean flag = false;
		try{
			OutputStream os = new FileOutputStream(filePath);
			properties.setProperty(key, value);
			properties.store(os, "write properties");
			os.flush();
			os.close();
			flag = true;
		}catch (FileNotFoundException ex){
            System.out.println("读取属性文件--->失败！- 原因：文件路径错误或者文件不存在");
            ex.printStackTrace();
        } catch (IOException ex){
            System.out.println("装载文件--->失败!");
            ex.printStackTrace();
        }catch(Exception e){
			e.printStackTrace();
		}
		return flag;
	}

	/**
	 * 写properties
	 * @param filePath properties文件地址
	 * @param key
	 * @param value
	 * @return
	 */
	public static boolean updateProperties(String filePath,String key,String value){
		Properties properties = new Properties();
		boolean flag = false;
		try{
			InputStream is = PropertiesUtils.class.getResourceAsStream(filePath);
			properties.load(is);
			is.close();

			OutputStream os = new FileOutputStream(filePath);
			properties.setProperty(key, value);
			properties.store(os, "update properties");
			os.flush();
			os.close();
			flag = true;
		}catch (FileNotFoundException ex){
			System.out.println("读取属性文件--->失败！- 原因：文件路径错误或者文件不存在");
			ex.printStackTrace();
		} catch (IOException ex){
			System.out.println("装载文件--->失败!");
			ex.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}
		return flag;
	}

}
