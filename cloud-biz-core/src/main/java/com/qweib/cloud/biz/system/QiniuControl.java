package com.qweib.cloud.biz.system;


import com.qiniu.common.QiniuException;
import com.qiniu.http.Response;
import com.qiniu.storage.BucketManager;
import com.qiniu.storage.UploadManager;
import com.qiniu.storage.model.FileInfo;
import com.qiniu.storage.model.FileListing;
import com.qiniu.util.Auth;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.biz.system.service.ws.SysYfileWebService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.SysYfile;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;


@Controller
@RequestMapping("/web")
public class QiniuControl extends BaseWebService {
	//设置好账号的ACCESS_KEY和SECRET_KEY
	public final static String ACCESS_KEY = QiniuConfig.getValue("ACCESS_KEY");
	public final static String SECRET_KEY = QiniuConfig.getValue("SECRET_KEY");
	//空间
	public final static String bucketname = QiniuConfig.getValue("bucketname");
    //长链接
    public final static String GPS_SERVICE_URL = QiniuConfig.getValue("GPS_SERVICE_URL");

	@Resource
	private SysYfileWebService yfileWebService;
	@Resource
	private SysMemberWebService memberWebService;
	
	/**
	 * 获取上传的token
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/getUploadToken",method = RequestMethod.POST)
	public void getUploadToken(HttpServletRequest request, HttpServletResponse response){
		  try {
			  Auth auth = Auth.create(ACCESS_KEY, SECRET_KEY);
			  String token = auth.uploadToken(bucketname);
			  JSONObject json = new JSONObject();
			  json.put("token", token);
			  this.sendJsonResponse(response, json.toString());
		} catch (JSONException e) {
			e.printStackTrace();
		}		
	}
	
	/**
	 * 获取文件信息
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/getBucketInfo",method = RequestMethod.POST)
	public void getBucketInfo(HttpServletRequest request, HttpServletResponse response, String key){
		Auth auth = Auth.create(ACCESS_KEY, SECRET_KEY);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//实例化一个BucketManager对象
	    BucketManager bucketManager = new BucketManager(auth);
	  //调用stat()方法获取文件的信息
	      try {
			FileInfo info = bucketManager.stat(bucketname, key);
			JSONObject json = new JSONObject();
			json.put("fsize", info.fsize);
//			json.put("infoPutTime",sdf.format(info.putTime));
//			json.put("infoMimeType", info.mimeType);
//			json.put("infoKey", info.key);
			this.sendJsonResponse(response, json.toString());
		} catch (QiniuException e) {
			e.printStackTrace();
			Response r = e.response;
		    System.out.println(r.toString());
		} catch (JSONException e) {
			e.printStackTrace();
		}			
	}
	
	/**
	 * 列举文件条目
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/getBucketList",method = RequestMethod.POST)
	public void getBucketList(HttpServletRequest request, HttpServletResponse response){
		Auth auth = Auth.create(ACCESS_KEY, SECRET_KEY);
		//实例化一个BucketManager对象
	   BucketManager bucketManager = new BucketManager(auth);
	   try {
		   	FileListing fileListing = bucketManager.listFiles(bucketname,null,null,10000,"/");
		    FileInfo[] items = fileListing.items;
		    JSONObject json=null;
		    List<JSONObject> list = new ArrayList<JSONObject>();
			for(FileInfo fileInfo:items){
					json = new JSONObject();
					FileInfo info = bucketManager.stat(bucketname, fileInfo.key);	
					File f =new File(fileInfo.key);
				    String fileName=f.getName();
				    String prefix=fileName.substring(fileName.lastIndexOf(".")+1);
				    json.put("fileName",fileInfo.key);
				    json.put("fsize", convertFileSize(info.fsize));
				    json.put("putTime",info.putTime);
				    json.put("mimeType",info.mimeType);
				    json.put("fileType",prefix);
					list.add(json);
				}		
			this.sendJsonResponse(response, list.toString());
	   } catch (QiniuException e) {
		   	Response r = e.response;
	        System.out.println(r.toString());
	   } catch (JSONException e) {
		e.printStackTrace();
	} 
	}

	/**
	 * 上传文件
	 * @param request
	 * @param response
	 */
	@RequestMapping("/uploadBucke")
	public void uploadBucke(HttpServletRequest request, HttpServletResponse response ){
		try {
			 Auth auth = Auth.create(ACCESS_KEY, SECRET_KEY);
			 String token = auth.uploadToken(bucketname);
			//上传到七牛后保存的文件名
			 String key = "my-java/1234.jpg";
			 String filePath ="D:/1234.jpg";
			 UploadManager uploadManager = new UploadManager();
			 //调用put方法上传
		     Response res = uploadManager.put(filePath, key, token);
		     //打印返回的信息
		     System.out.println(res.bodyString()); 
		} catch (QiniuException e) {
			 Response r = e.response;
	          // 请求失败时打印的异常的信息
	        System.out.println(r.toString());
			e.printStackTrace();
			  //响应的文本信息
            try {
				System.out.println(r.bodyString());
			} catch (QiniuException e1) {
				e1.printStackTrace();
			}
		}
	    	
	} 
	
	/**
	 * 删除文件
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/deleteBucke",method = RequestMethod.POST)
	public void deleteBucke(HttpServletResponse res, HttpServletResponse response, String token, String key , String dataTp){
		      JSONObject json = new JSONObject();
			  try {
				    if(!checkParam(response, token,key, dataTp)){
						return;
					}
					OnlineMessage message = TokenServer.tokenCheck(token);
					if(message.isSuccess()==false){
						sendWarm(response, message.getMessage());
						return;
					}
					if (StrUtil.isNull(dataTp)) {//未传
						sendWarm(response, "app版本过低，不能删除");
						return;
					}
					String tp="";
					SysMember member=this.memberWebService.queryAllById(message.getOnlineMember().getMemId());
					SysYfile yfile3=this.yfileWebService.queryYfile3(message.getOnlineMember().getDatabase(), key);
					if(!StrUtil.isNull(yfile3)){
						if(!yfile3.getMemberId().equals(message.getOnlineMember().getMemId())){
							if("1".equals(dataTp)){
								sendWarm(response, "权限不足，不能删除！");
								return;
							}else{
								tp="1";
							}
						}
					}
					int a=key.indexOf(".");
			    	//七牛
					if(a>0){ 
						 Auth auth = Auth.create(ACCESS_KEY, SECRET_KEY);
						 String bucket = bucketname;
						 //实例化一个BucketManager对象
						 BucketManager bucketManager = new BucketManager(auth);
						 //调用put方法上传  
						 //调用delete方法移动文件
						 bucketManager.delete(bucket, key);
					}else{
						SysYfile yfile=this.yfileWebService.queryYfile2(message.getOnlineMember().getDatabase(), message.getOnlineMember().getMemId(), key);
						int num=this.yfileWebService.queryIsfilePid(message.getOnlineMember().getDatabase(), yfile.getId());
						if(num>0){
							sendWarm(response, "该文件夹下有文件，不能删除");
							return;
						}
					}
					if(StrUtil.isNull(tp)){
						this.yfileWebService.deletefile(message.getOnlineMember().getDatabase(), message.getOnlineMember().getMemId(), key);
					}else{
						this.yfileWebService.deletefile2(message.getOnlineMember().getDatabase(), key);
					}
					json.put("state", true);
				    json.put("msg", "删除成功");
				    this.sendJsonResponse(response, json.toString());
			} catch (QiniuException e) {
				  //捕获异常信息			    
			      try {
			    	Response r = e.response;
			    	json.put("state", false);
					json.put("msg", "删除失败！");
					this.sendJsonResponse(response, json.toString());
					System.out.println(r.toString());
				} catch (JSONException e1) {
					e1.printStackTrace();
				}			      
			} catch (JSONException e) {
					e.printStackTrace();
			}
		} 
	
	
	/**
	 * 获取下载链接
	 * @param res
	 * @param response
	 */
	@RequestMapping(value="/downloadBucke",method = RequestMethod.POST)
	public void downloadBucke(HttpServletResponse res, HttpServletResponse response, String key){
	
		 try {
			    
				Auth auth = Auth.create(ACCESS_KEY, SECRET_KEY);
				String URL = "http://oflldcc2r.bkt.clouddn.com/"+URLEncoder.encode(key,"UTF-8");
				//调用privateDownloadUrl方法生成下载链接,第二个参数可以设置Token的过期时间
				String downloadRUL = auth.privateDownloadUrl(URL,3600);
				JSONObject json = new JSONObject();
				json.put("downloadRUL", downloadRUL);
				json.put("msg", "获取下载链接成功！");
				this.sendJsonResponse(response, json.toString());
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 转换文件大小
	 * @param size
	 * @return
	 */
	public static String convertFileSize(long size) {
        long kb = 1024;
        long mb = kb * 1024;
        long gb = mb * 1024;
 
        if (size >= gb) {
            return String.format("%.1f GB", (float) size / gb);
        } else if (size >= mb) {
            float f = (float) size / mb;
            return String.format(f > 100 ? "%.0f MB" : "%.1f MB", f);
        } else if (size >= kb) {
            float f = (float) size / kb;
            return String.format(f > 100 ? "%.0f KB" : "%.1f KB", f);
        } else
            return String.format("%d B", size);
    }
	
	/**
	 * 重命名
	 * @param res
	 * @param response
	 * @param key
	 * 要测试的空间和key，并且这个key在你空间中存在
	 * 将文件从文件key移动到文件newkey, 可以在不同bucket移动，同空间移动相当于重命名
	 */
	@RequestMapping(value="/moveBucke",method = RequestMethod.POST)
	public void moveBucke(HttpServletResponse res, HttpServletResponse response, String token, Integer id, String key, String newKey){
		  
	    try {
	    	if(!checkParam(response, token,id,newKey)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
	    	int a=newKey.indexOf(".");
	    	//七牛
            //设置需要操作的账号的AK和SK
		    Auth auth = Auth.create(ACCESS_KEY, SECRET_KEY);
		    //实例化一个BucketManager对象
		    BucketManager bucketManager = new BucketManager(auth);
		    //要测试的空间和key，并且这个key在你空间中存在
		    //String tokens = auth.uploadToken(bucketname);
			if(a>0){
                //调用move方法移动文件
		    	bucketManager.move(bucketname, key, bucketname, newKey);
		    }
			OnlineUser onlineUser = message.getOnlineMember();
			SysYfile yfile=this.yfileWebService.queryYfileById(onlineUser.getDatabase(), id);
			int num=this.yfileWebService.queryIsfileNm(onlineUser.getDatabase(), newKey, onlineUser.getMemId());
			if(!yfile.getFileNm().equals(newKey)){
				if(num>0){
					sendWarm(response, "文件名已存在");
					return;
				}
			}
			this.yfileWebService.updatefileNm(onlineUser.getDatabase(), newKey, id);
	    	JSONObject json = new JSONObject();
	    	json.put("state", true);
		    json.put("msg", "重命名成功！");
			this.sendJsonResponse(response, json.toString());
	    } catch (QiniuException e) {
	      //捕获异常信息
	      Response r = e.response;
	      System.out.println(r.toString());
	    } catch (JSONException e) {
			e.printStackTrace();
		}
	  }

}
