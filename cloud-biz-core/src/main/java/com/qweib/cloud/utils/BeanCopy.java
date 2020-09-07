package com.qweib.cloud.utils;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;

import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;

public class BeanCopy {
	
    /**
     * 说明：修改了BeanUtils的属性拷贝逻辑，仅拷贝不相等的属性，并由调用方决定是否拷贝Null属性
     *@创建：作者:yqh，创建时间：2007-7-4
     *@param dest
     *@param orig
     *@param copyNull
     *@throws IllegalAccessException
     *@throws InvocationTargetException
     */
    public static void copyBeanSimpleProperties(Object dest, Object orig, boolean copyNull)
            throws IllegalAccessException, InvocationTargetException {

        PropertyDescriptor origDescriptors[] = PropertyUtils.getPropertyDescriptors(orig);

        for (int i = 0; i < origDescriptors.length; i++) {
            String name = origDescriptors[i].getName();
            if ("class".equals(name)) {
                continue;
            }
            if (PropertyUtils.isReadable(orig, name)
                    && PropertyUtils.isWriteable(dest, name)) {
                try {
                    Object value = PropertyUtils.getSimpleProperty(orig, name);
                    if (copyNull || (null != value)){
                        if(value == null)
                            BeanUtils.copyProperty(dest, name, value);
                        else{
                            Object destValue = PropertyUtils.getSimpleProperty(dest, name);
                            if(!value.equals(destValue))
                                BeanUtils.copyProperty(dest, name, value);
                        }
                    }
                } catch (NoSuchMethodException e) {
                }
            }
        }
    }
    
    /**
     * 说明：修改了BeanUtils的属性拷贝逻辑，由调用方决定是否拷贝Null属性
     *
     *@创建：作者:yqh，创建时间：2007-7-4
     *@param dest
     *@param orig
     *@param copyNull
     *@throws IllegalAccessException
     *@throws InvocationTargetException
     */
    public static void copyBeanAllSimpleProperties(Object dest, Object orig, boolean copyNull)
            throws IllegalAccessException, InvocationTargetException {

        PropertyDescriptor origDescriptors[] = PropertyUtils
                .getPropertyDescriptors(orig);

        for (int i = 0; i < origDescriptors.length; i++) {
            String name = origDescriptors[i].getName();
            if ("class".equals(name)) {
                continue;
            }
            if (PropertyUtils.isReadable(orig, name)
                    && PropertyUtils.isWriteable(dest, name)) {
                try {
                    Object value = PropertyUtils.getSimpleProperty(orig, name);
                    if (copyNull || (null != value)){
                        BeanUtils.copyProperty(dest, name, value);
                    }
                } catch (NoSuchMethodException e) {
                }
            }
        }
    }
    /**
     * 说明：BeanUtils的属性拷贝逻辑
     *
     *@创建：作者:yqh，创建时间：2007-7-4
     *@param dest
     *@param orig
     *@return
     */
    public static boolean copyBeanProperties(Object dest, Object orig){
    	
    	boolean bool = false;
    	try{
			copyBeanAllSimpleProperties(dest,orig,false);
			bool = true;
		}catch(IllegalAccessException iaEx){
			System.err.println(iaEx.toString());
		}catch(InvocationTargetException itEx){
			System.err.println(itEx.toString());
		}
		return bool;
    }
//    public static void copyBeanPfToVO(Object dest,
//    								 publicForm Pf){
//    	try{
//    		PropertyDescriptor origDescriptors[] = PropertyUtils.getPropertyDescriptors(dest);
//			for(int i = 0; i < origDescriptors.length; i++){
//				String name  = origDescriptors[i].getName();
//		        if("class".equals(name)||"MultipartRequestHandler".equalsIgnoreCase(name)
//		        		 			   ||"Servlet".equalsIgnoreCase(name)
//		        		 			   ||"servletWrapper".equalsIgnoreCase(name)){
//		        	continue;
//		        }
//		        String sType= String.valueOf(dest.getClass().getDeclaredField(name).getType());
//				Object value=null;
//		        if(sType.indexOf("String")!=-1){
//		        	 value = Pf.getString(name);
//		        }else if(sType.indexOf("Number")!=-1){
//		        	 value = Pf.getDouble(name);
//		        }else if(sType.indexOf("long")!=-1){
//		        	 value = Pf.getLong(name);
//		        }else if(sType.indexOf("Float")!=-1){
//		        	 value = Pf.getFloat(name);
//		        }else if(sType.indexOf("int")!=-1){
//		        	 value = Pf.getInt(name);
//		        }else if(sType.indexOf("Date")!=-1){
//		        	 value = Pf.getDate(name);
//		        }else if(sType.indexOf("double")!=-1){
//		        	 value = Pf.getDouble(name);
//		        }
//		        if(value==null) continue;
//		        BeanUtils.copyProperty(dest, name,value);
//				
//			}
//		
//		} catch (SecurityException e) {
//			e.printStackTrace();
//		} catch (NoSuchFieldException e) {
//			e.printStackTrace();
//		} catch (IllegalAccessException e) {
//			e.printStackTrace();
//		} catch (InvocationTargetException e) {
//			e.printStackTrace();
//		}
//    	
//    }
    public static int valieFiledLength(String sStr){
    	String regex="\\W";
    	String regex1 = "&@!#$%^)(-+=_\\'?><,~`! {}";
    	int lengthg=0;
    	int j = 0;
    	String srr = "";
    	for(int i =0;i<sStr.length();i++){
    			if(i<sStr.length()) j=i+1;
    			else j=i;
    			
    			srr = sStr.substring(i,j).replace("<",".").replace("{",".").replace("[",".").replace("(",".").replace("《","早").replace("》","早").replace(">",".").replace("]",".").replace("}",".").replace("*",".").replace(")",".");
    			srr = srr.replace("+",".").replace("-",".").replace("\\",".").replace("?",".").replace("?",".");
    			
    			if(!regex.matches(srr)&& regex1.indexOf(sStr.substring(i,j))!=1){
    				lengthg=lengthg+2;
    			}else{
    				lengthg= lengthg+1;
    			}
    		
    	
    	
    	}
    	return lengthg;
    }
    public static void main(String[] argc){
////    	int i = valieFiledLength("村田机械!~@#%^&-()_+=></''!？\"、、。，/  早早';上海有限公司对龙岩卷烟厂的四台巷道堆垛机进行点检，每天一台。");
////    	System.out.println(i);
//    	Test my1=new Test();
//    	my1.setName("AAADDD");
//    	Test my2=new Test();
//    	my2.setName("CCC");
//    	try {
//			copyBeanSimpleProperties(my2,my1,false);
//			System.out.println(my2.getName());
//			
//		} catch (IllegalAccessException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (InvocationTargetException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
    	
    	
    }
    
    
}
