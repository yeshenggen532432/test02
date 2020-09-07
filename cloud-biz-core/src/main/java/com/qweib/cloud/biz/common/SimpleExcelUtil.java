package com.qweib.cloud.biz.common;

import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTitleVo;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.JsonUtil;
import com.qweib.commons.StringUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.util.Iterator;
import java.util.List;

public class SimpleExcelUtil {

    public static void downExcel(HttpServletResponse response, List<String> list, String fileName) throws Exception {
        if (StringUtils.isEmpty(fileName))
            fileName = System.currentTimeMillis() + "";// Excel文件名
        OutputStream os = response.getOutputStream();// 取得输出流
        try {
            response.reset();// 清空输出流
            response.setHeader("Content-disposition", "attachment; filename="
                    + fileName + ".xls"); // 设定输出文件头,该方法有两个参数，分别表示应答头的名字和值。
            response.setContentType("application/msexcel");

            // 创建工作薄
            HSSFWorkbook wb = new HSSFWorkbook();
            // 在工作薄上建一张工作表
            HSSFSheet sheet = wb.createSheet();
            HSSFRow row = sheet.createRow((short) 0);
            sheet.createFreezePane(0, 1);
            for (int i = 0; i < list.size(); i++) {
                HSSFCell cell = row.createCell(i);
                cell.setCellValue(list.get(i));
            }
            wb.write(os);
        } finally {
            os.flush();
            os.close();
        }
    }

    /**
     * 把内容写入Excel
     */
    public static File getImportEditExcel(HttpServletRequest request, SysLoginInfo info, Integer type, String titleJson, String contextJson) throws Exception {
        if (titleJson == null && contextJson == null) return null;
        List<ImportTitleVo> titleList = JsonUtil.readJsonList(titleJson, ImportTitleVo.class);
        List<Object> dataList = JsonUtil.readJsonList(contextJson, Object.class);
        //创建工作簿
        XSSFWorkbook xssfWorkbook = null;
        xssfWorkbook = new XSSFWorkbook();

        //创建工作表
        XSSFSheet xssfSheet = xssfWorkbook.createSheet();

        //创建行
        XSSFRow xssfRow;

        //创建列，即单元格Cell
        XSSFCell xssfCell;

        //把List里面的数据写到excel中
        //从第一行开始写入
        xssfRow = xssfSheet.createRow(0);
        //设置表头
        int hi = 0;
        Iterator<ImportTitleVo> it = titleList.iterator();
        while (it.hasNext()) {
            ImportTitleVo importTitleVo = it.next();
            xssfCell = xssfRow.createCell(hi); //创建单元格
            xssfCell.setCellValue(importTitleVo.getTitle()); //设置单元格内容
            hi++;
        }

        //把List里面的数据写到excel中
        for (int i = 0; i < dataList.size(); i++) {
            Object obj = dataList.get(i);
            if (obj == null) continue;
            xssfRow = xssfSheet.createRow(i + 1);//表头使用了一行
            it = titleList.iterator();
            int j = 0;
            while (it.hasNext()) {
                ImportTitleVo importTitleVo = it.next();
                xssfCell = xssfRow.createCell(j); //创建单元格
                //if (PropertyUtils.isReadable(obj, importTitleVo.getField())) {
                try {
                    String field = importTitleVo.getField();
                    if ("Integer".equals(importTitleVo.getType())) {
                        xssfCell.setCellValue((Integer) PropertyUtils.getProperty(obj, field)); //设置单元格内容
                    } else {
                        xssfCell.setCellValue((String) PropertyUtils.getProperty(obj, field)); //设置单元格内容
                    }
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                } catch (NoSuchMethodException e) {
                    e.printStackTrace();
                }
                //}
                j++;
            }
        }
        ServletContext servletContext = request.getSession().getServletContext();
        String rootPath = servletContext.getRealPath("/upload");
        String fileName = info.getFdCompanyId() + "" + type;
        String fileSuffix = ".xls";
        File dirFile = new File(rootPath);
        if (!dirFile.exists()) {
            dirFile.mkdirs();
        }
        File importFile = new File(rootPath, fileName + fileSuffix);
        OutputStream out = null;
        try {
            out = new FileOutputStream(importFile);
            xssfWorkbook.write(out);
        } finally {
            if (out != null) {
                out.flush();
                out.close();
            }
        }
        return importFile;
    }

}
