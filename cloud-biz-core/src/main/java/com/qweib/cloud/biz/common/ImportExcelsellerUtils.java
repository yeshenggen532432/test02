package com.qweib.cloud.biz.common;

import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTitleVo;
import com.qweib.cloud.utils.StrUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.poi.ss.usermodel.*;

import java.io.InputStream;
import java.lang.reflect.Field;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * EXCEL导入封装成List zzx
 */
@Slf4j
public class ImportExcelsellerUtils {

    /**
     * 读取Excel表格表头的内容
     *
     * @param in
     * @return String 表头内容的数组
     * @throws Exception
     */
    public static List<?> readExcel(InputStream in, Object obj, List<ImportTitleVo> titleVoList) throws Exception {
        List<Object> list = new ArrayList<Object>();
        try {
            Sheet sheet = null;
            try {
                Workbook wb = WorkbookFactory.create(in);
                sheet = wb.getSheetAt(0);
            } catch (Exception e) {
                throw new RuntimeException("导入格式无法识别");
            }
            Row row = sheet.getRow(0);
            //获得object类的属性
            Class<?> clazz = Class.forName(obj.getClass().getCanonicalName());
            Field[] field = clazz.getDeclaredFields();

            //标题总列数
            int colNum = row.getPhysicalNumberOfCells();//Excal中有多少列
            //判断对象属性和excal的属性的数目是否相同
          /*  if (field.length < colNum) {
                return null;
            }*/

            Map<Integer, String> coleMap = new HashMap<>(colNum);
            row = sheet.getRow(0);
            for (int j = 0; j < colNum; j++) {
                Object va = getCellValue(row.getCell(j));
                if (StrUtil.isNull(va))
                    continue;
                for (ImportTitleVo titleVo : titleVoList) {
                    if (va != null && titleVo.getTitle().equals(va.toString().trim())) {
                        coleMap.put(j, titleVo.getField());
                        break;
                    }
                }
            }
            if (coleMap == null || coleMap.isEmpty()) {
                throw new RuntimeException("数据格式未找到匹配");
            }
            //循环,将Excal中的数据放入到对象中
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                //得到excal内的一行
                obj = obj.getClass().newInstance();
                row = sheet.getRow(i);
                if (row == null) continue;
                boolean isNull = true;
                for (int j = 0; j < colNum; j++) {
                    String fieldName = coleMap.get(j);
                    try {
                        if (fieldName == null || fieldName.length() == 0) continue;
                        Class fieldType = PropertyUtils.getPropertyType(obj, fieldName);
                        Object va = getCellValue(row.getCell(j), fieldType);
                        PropertyUtils.setProperty(obj, fieldName, va);
                        if (isNull && !StrUtil.isNull(va)) {
                            isNull = false;
                        }
                    } catch (Exception e) {
                        log.error("导入" + fieldName + "出现错误", e);
                    }
                }
                //验证所有列数据是否为空
                if (!isNull)
                    list.add(obj);
            }
        } finally {
            if (in != null)
                in.close();
        }
        return list;
    }

    /**
     * 读取Excel表格表头的内容
     *
     * @param in
     * @param storeTitleList 存放标题
     * @param storeDataList  存放内容
     * @throws Exception
     */
    public static void readExcel(InputStream in, List<String> storeTitleList, List<List> storeDataList) throws Exception {
        try {
            Workbook wb = WorkbookFactory.create(in);
            Sheet sheet = wb.getSheetAt(0);
            Row row = sheet.getRow(0);
            //标题总列数
            int colNum = row.getPhysicalNumberOfCells();//Excal中有多少列
            List<Object> rowCellList = null;
            //循环,将Excal中的数据放入到对象中
            for (int i = 0; i <= sheet.getLastRowNum(); i++) {
                //得到excal内的一行
                row = sheet.getRow(i);
                if (row == null) continue;
                if (!Objects.equals(i, 0))
                    rowCellList = new ArrayList<Object>();
                boolean isNull = true;
                for (int j = 0; j < colNum; j++) {
                    Cell cell = row.getCell(j);
                    if (Objects.equals(i, 0)) {//第0行是标题
                        if (cell != null)
                            storeTitleList.add(cell.getStringCellValue().trim());
                        else storeTitleList.add("");
                    } else {
                        Object va = getCellValue(cell);
                        rowCellList.add(va);
                        if (isNull && !StrUtil.isNull(va)) {
                            isNull = false;
                        }
                    }
                }
                //验证所有列数据是否为空
                if (!isNull)
                    storeDataList.add(rowCellList);
            }
        } finally {
            if (in != null)
                in.close();
        }
    }

    private static Object getCellValue(Cell cell) {
        return getCellValue(cell, null);
    }

    private static Object getCellValue(Cell cell, Class obj) {
        Object value = "";
        if (cell == null) return value;
        if (obj != null && "String".equals(obj.getSimpleName()))
            cell.setCellType(CellType.STRING);
        switch (cell.getCellTypeEnum()) {
            case STRING:
                value = cell.getRichStringCellValue().getString();
                break;
            case NUMERIC:

                DecimalFormat df = new DecimalFormat("#.##");//格式化number String字符串
                if ("General".equals(cell.getCellStyle().getDataFormatString())) {
                    value = df.format(cell.getNumericCellValue());
                } else if ("m/d/yy".equals(cell.getCellStyle().getDataFormatString())) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");//日期格式化
                    value = sdf.format(cell.getDateCellValue());
                } else {
                    value = df.format(cell.getNumericCellValue());
                }
                break;
            case BOOLEAN:
                value = cell.getBooleanCellValue();
                break;
            case BLANK:
                value = "";
                break;
            default:
                value = cell.toString();
                break;
        }
        if (value != null && value instanceof String)
            value = value.toString().trim();
        return value;
    }

    /**
     * 描述：对表格中数值进行格式化
     *
     * @param cell
     * @return
     */
    /*public static Object getCellValue(Cell cell) {
        String result = new String();
        switch (cell.getCellType()) {
            case HSSFCell.CELL_TYPE_FORMULA:  //Excel公式
                try {
                    result = String.valueOf(cell.getNumericCellValue());
                } catch (IllegalStateException e) {
                    result = String.valueOf(cell.getRichStringCellValue());
                }
                break;
            case HSSFCell.CELL_TYPE_NUMERIC:// 数字类型
                if (HSSFDateUtil.isCellDateFormatted(cell)) {// 处理日期格式、时间格式
                    SimpleDateFormat sdf;
                    if (cell.getCellStyle().getDataFormat() == HSSFDataFormat
                            .getBuiltinFormat("h:mm")) {
                        sdf = new SimpleDateFormat("HH:mm");
                    } else {// 日期
                        sdf = new SimpleDateFormat("yyyy-MM-dd");
                    }
                    Date date = cell.getDateCellValue();
                    result = sdf.format(date);
                } else if (cell.getCellStyle().getDataFormat() == 58) {
                    // 处理自定义日期格式：m月d日(通过判断单元格的格式id解决，id的值是58)
                    SimpleDateFormat sdf = new SimpleDateFormat("M月d日");
                    double value = cell.getNumericCellValue();
                    Date date = org.apache.poi.ss.usermodel.DateUtil
                            .getJavaDate(value);
                    result = sdf.format(date);
                } else {
                    CellStyle style = cell.getCellStyle();
                    DecimalFormat format = new DecimalFormat();
                    String temp = style.getDataFormatString();
                    // 单元格设置成常规
                    if ("General".equals(temp)) {
                        format.applyPattern("#.##");
                    }
                    double value = cell.getNumericCellValue();
                    result = format.format(value);
                }
                break;
            case HSSFCell.CELL_TYPE_STRING:// String类型
                result = cell.getRichStringCellValue().toString();
                break;
            case HSSFCell.CELL_TYPE_BLANK:
                result = "";
            default:
                result = "";
                break;
        }
        return result;
    }*/

}
