package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysBforderXlsService;
import com.qweib.cloud.core.domain.SysBforderXls;
import com.qweib.cloud.core.domain.SysLoginInfo;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.ExcelUtil;
import com.qweib.cloud.utils.FileUtil;
import com.qweib.cloud.utils.Font;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysBforderXlsControl extends GeneralControl{
	@Resource
	private SysBforderXlsService bforderXlsService;
	
	@RequestMapping("orderExcel")
	public void loadForExcel(HttpServletRequest request, HttpServletResponse response, String orderNo2, String khNm2,
                             String memberNm2, String sdate2, String edate2, String orderZt2, String pszd2){
		FileInputStream in = null;
		FileOutputStream out = null;
		POIFSFileSystem fs = null;
		InputStream inStream = null;
		File tempFile = null;
		try{
			SysLoginInfo info = getInfo(request);
			List<SysBforderXls> list1=this.bforderXlsService.queryBforderXls1(orderNo2, khNm2, memberNm2, sdate2, edate2,orderZt2,pszd2, info.getDatasource());
			String path = request.getSession().getServletContext().getRealPath("exefile");
			File file = new File(path+"\\order.xls");
			tempFile = new File(request.getSession().getServletContext().getRealPath("/upload")+"\\temp\\"+System.currentTimeMillis()+".xls");
			//拷贝临时文件
			FileUtil.copyFile(file, tempFile);
			file = null;
			in = new FileInputStream(tempFile);
			fs = new POIFSFileSystem(in);
			HSSFWorkbook workBook = new HSSFWorkbook(fs);
			Font f = new Font();
			f.setFontSize((short)12);
			HSSFFont font = ExcelUtil.getHSSFFont(workBook, f);
			HSSFSheet sheet0 = workBook.getSheetAt(0);
			//excel标题--导出条件
			//String condition = getConditionStr(memNm, time1, time2);
			Font f1 = new Font();
			f1.setFontSize((short)14);
			f1.setBold(HSSFFont.BOLDWEIGHT_BOLD);
			HSSFFont font1 = ExcelUtil.getHSSFFont(workBook, f1);
			ExcelUtil.setCells(0, 0,"销售订单表", font1, sheet0);
			int index = 2;
			if(list1.size()>0 && list1!=null){
				for (SysBforderXls orderXls1: list1) {
					ExcelUtil.setCells(index, 0, index-1, font, sheet0);//序号
					ExcelUtil.setCells(index, 1,null==orderXls1.getOrderNo()?"":orderXls1.getOrderNo(), font, sheet0);//订单号
					ExcelUtil.setCells(index, 2,null==orderXls1.getPszd()?"":orderXls1.getPszd(), font, sheet0);//配送指定
					ExcelUtil.setCells(index, 3,null==orderXls1.getOrderZt()?"":orderXls1.getOrderZt(), font, sheet0);//订单状态
					ExcelUtil.setCells(index, 4,null==orderXls1.getOddate()?"":orderXls1.getOddate(), font, sheet0);//下单日期
					ExcelUtil.setCells(index, 5,null==orderXls1.getOdtime()?"":orderXls1.getOdtime(), font, sheet0);//时间
					ExcelUtil.setCells(index, 6,null==orderXls1.getShTime()?"":orderXls1.getShTime(), font, sheet0);//送货时间
					ExcelUtil.setCells(index, 7,null==orderXls1.getKhNm()?"":orderXls1.getKhNm(), font, sheet0);//客户名称
					ExcelUtil.setCells(index, 8,null==orderXls1.getMemberNm()?"":orderXls1.getMemberNm(), font, sheet0);//业务员名称 
					ExcelUtil.setCells(index, 9,null==orderXls1.getWareNm()?"":orderXls1.getWareNm(), font, sheet0);//商品名称
					ExcelUtil.setCells(index, 10,null==orderXls1.getXsTp()?"":orderXls1.getXsTp(), font, sheet0);//销售类型
					ExcelUtil.setCells(index, 11,null==orderXls1.getWareDw()?"":orderXls1.getWareDw(), font, sheet0);//单位
					ExcelUtil.setCells(index, 12,null==orderXls1.getWareGg()?"":orderXls1.getWareGg(), font, sheet0);//规格
					ExcelUtil.setCells(index, 13,null==orderXls1.getWareNum()?"":orderXls1.getWareNum(), font, sheet0);//数量
					ExcelUtil.setCells(index, 14,null==orderXls1.getWareDj()?"":orderXls1.getWareDj(), font, sheet0);//单价
					ExcelUtil.setCells(index, 15,null==orderXls1.getWareZj()?"":orderXls1.getWareZj(), font, sheet0);//总价
					ExcelUtil.setCells(index, 16,null==orderXls1.getZje()?"":orderXls1.getZje(), font, sheet0);//总金额
					ExcelUtil.setCells(index, 17,null==orderXls1.getZdzk()?"":orderXls1.getZdzk(), font, sheet0);//整单折扣
					ExcelUtil.setCells(index, 18,null==orderXls1.getCjje()?"":orderXls1.getCjje(), font, sheet0);//成交金额
					ExcelUtil.setCells(index, 19,null==orderXls1.getRemo()?"":orderXls1.getRemo(), font, sheet0);//备注
					index++;
					if(orderXls1.getCounts()>1){
						List<SysBforderXls> list2=this.bforderXlsService.queryBforderXls2(orderXls1.getOrderId(), orderXls1.getCounts()-1, info.getDatasource());
						for (SysBforderXls orderXls2: list2) {
							ExcelUtil.setCells(index, 0, index-1, font, sheet0);//序号
							ExcelUtil.setCells(index, 1,null==orderXls2.getOrderNo()?"":orderXls2.getOrderNo(), font, sheet0);//订单号
							ExcelUtil.setCells(index, 2,null==orderXls2.getPszd()?"":orderXls2.getPszd(), font, sheet0);//配送指定
							ExcelUtil.setCells(index, 3,null==orderXls2.getOrderZt()?"":orderXls2.getOrderZt(), font, sheet0);//订单状态
							ExcelUtil.setCells(index, 4,null==orderXls2.getOddate()?"":orderXls2.getOddate(), font, sheet0);//下单日期
							ExcelUtil.setCells(index, 5,null==orderXls2.getOdtime()?"":orderXls2.getOdtime(), font, sheet0);//时间
							ExcelUtil.setCells(index, 6,null==orderXls2.getShTime()?"":orderXls2.getShTime(), font, sheet0);//送货时间
							ExcelUtil.setCells(index, 7,null==orderXls2.getKhNm()?"":orderXls2.getKhNm(), font, sheet0);//客户名称
							ExcelUtil.setCells(index, 8,null==orderXls2.getMemberNm()?"":orderXls2.getMemberNm(), font, sheet0);//业务员名称 
							ExcelUtil.setCells(index, 9,null==orderXls2.getWareNm()?"":orderXls2.getWareNm(), font, sheet0);//商品名称
							ExcelUtil.setCells(index, 10,null==orderXls2.getXsTp()?"":orderXls2.getXsTp(), font, sheet0);//销售类型
							ExcelUtil.setCells(index, 11,null==orderXls2.getWareDw()?"":orderXls2.getWareDw(), font, sheet0);//单位
							ExcelUtil.setCells(index, 12,null==orderXls2.getWareGg()?"":orderXls2.getWareGg(), font, sheet0);//规格
							ExcelUtil.setCells(index, 13,null==orderXls2.getWareNum()?"":orderXls2.getWareNum(), font, sheet0);//数量
							ExcelUtil.setCells(index, 14,null==orderXls2.getWareDj()?"":orderXls2.getWareDj(), font, sheet0);//单价
							ExcelUtil.setCells(index, 15,"", font, sheet0);//总价
							ExcelUtil.setCells(index, 16,"", font, sheet0);//总金额
							ExcelUtil.setCells(index, 17,"", font, sheet0);//整单折扣
							ExcelUtil.setCells(index, 18,"", font, sheet0);//成交金额
							ExcelUtil.setCells(index, 19,null==orderXls2.getRemo()?"":orderXls2.getRemo(), font, sheet0);//备注
							index++;
						}
					}
				}
			}
			
			out = new FileOutputStream(tempFile);
			workBook.write(out);//写入文件
			String fileName = "销售订单数据"+DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd")+".xls";
			if (request.getHeader("User-Agent").toLowerCase().indexOf("firefox") > 0)
				fileName = new String(fileName.getBytes("UTF-8"), "ISO8859-1");// firefox浏览器
			else if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0)
				fileName = URLEncoder.encode(fileName, "UTF-8");// IE浏览器
			inStream = new FileInputStream(tempFile);
			response.reset();
			response.setContentType("application/vnd.ms-excel;");
			response.setContentType("text/html;charset=UTF-8"); // 设置输出编码格式
			response.setHeader("Content-Disposition", "attachment; filename=\""+ fileName + "\"");
			//循环取出流中的数据
			byte[] b = new byte[inStream.available()];
			int len;
			while ((len = inStream.read(b)) > 0)
				response.getOutputStream().write(b, 0, len);
			inStream.close();
			tempFile.delete();
			tempFile=null;
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			try{
				if(null!=in){
					in.close();
				}
				if(null!=out){
					out.close();
				}
				fs = null;
				if(null!=inStream){
					inStream.close();
				}
				if(null!=tempFile){
					tempFile.delete();
				}
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	public static void main(String[] args) {
		int a=2;
		for(int i=0;i<10;i++){
			System.out.println(a);
			a++;
			for(int j=0;j<3;j++){
				System.out.println(a);
				a++;
			}
		}
	}
}
