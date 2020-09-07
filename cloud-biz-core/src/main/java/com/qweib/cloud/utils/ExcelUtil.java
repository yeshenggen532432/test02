package com.qweib.cloud.utils;

import org.apache.poi.hssf.usermodel.*;

import java.util.Date;

public class ExcelUtil {
	/**
	 * 設置單元格 row 那一行 col 哪一列 colValue 列的值 font 字体 sheet Excel sheet
	 */
	public static void setCells(int row, int col, Object colValue,
			HSSFFont font, HSSFSheet sheet) {
		HSSFRow r = sheet.getRow(row);
		if(null==r){
			r = sheet.createRow(row);
		}
		HSSFCell cell = r.getCell(col);
		if(null==cell){
			cell=sheet.getRow(row).createCell(col);
		}
		setCellValueOfCn(cell, colValue);
		cell.getCellStyle().setFont(font);
	}
	/**
	 * 設置單元格 row 那一行 col 哪一列 colValue 列的值 font 字体 sheet Excel sheet
	 */
	public static void setCells(int row, int col, Object colValue,HSSFSheet sheet,HSSFCellStyle style) {
		HSSFRow r = sheet.getRow(row);
		if(null==r){
			r = sheet.createRow(row);
		}
		HSSFCell cell = r.getCell(col);
		if(null==cell){
			cell=sheet.getRow(row).createCell(col);
		}
		setCellValueOfCn(cell, colValue);
		cell.setCellStyle(style);
	}

	/**
	 * 設置cell值 cell 列 value 列的值
	 */
	public static void setCellValueOfCn(HSSFCell cell, Object value) {
		if (value instanceof String) {
			cell.setCellValue(value.toString());
		}else if(value instanceof Double){
			cell.setCellValue((Double) value);
		}else if(value instanceof Integer){
			cell.setCellValue((Integer)value);
		}else{
			cell.setCellValue(value.toString());
		}
	}
	/**
	 * 設置cell的样式
	 */
	public static void setCellStyle(int row,int col,HSSFSheet sheet,HSSFCellStyle style) {
		HSSFRow r = sheet.getRow(row);
		if(null==r){
			r = sheet.createRow(row);
		}
		HSSFCell cell = r.getCell(col);
		if(null==cell){
			cell=sheet.getRow(row).createCell(col);
		}
		cell.setCellStyle(style);
	}
	/**
	 * 添加行 sheet sheet startRow 开始行 rows 行数 colLength 列数
	 */
	public static void addRow(HSSFSheet sheet, int startRow, int rows,
			Integer colLength) {
		for (int i = 0; i < rows; i++) {
			HSSFRow row = sheet.createRow(startRow + i);
			for (int j = 0; j < colLength; j++) {
				row.createCell(j);
			}
		}
	}
	/**
	 * 單元格的字体 workbook excel font --字体模型
	 */
	public static HSSFFont getHSSFFont(HSSFWorkbook workbook, Font f) {
		HSSFFont font = workbook.createFont();
		//字体名称
		font.setFontName(f.getFontNm());
		//字号
		font.setFontHeightInPoints(f.getFontSize());
		//字体颜色
		font.setColor(f.getFontColor());
		//下划线
		font.setUnderline(f.getUnderline());
		//上标下标
		font.setTypeOffset(f.getOffset());
		//删除线
		font.setStrikeout(f.getDelLine());
		//加粗
		font.setBoldweight(f.getBold());
		//斜线
		font.setItalic(f.getItalic());
		//字体高度
		//font.setFontHeight(arg0);
		return font;
	}


	public static HSSFCellStyle getNewStyle(HSSFWorkbook workBook,CellStyle cellStyle) {
		HSSFCellStyle style = workBook.createCellStyle();
		//对齐方式
		style.setAlignment(cellStyle.getAlignment());
		style.setVerticalAlignment(cellStyle.getVAlignment());
		//设置背景颜色
		//最好的设置Pattern
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		//单元格背景的显示模式
		style.setFillForegroundColor(cellStyle.getColor());				// 单元格背景的显示模式．
		//设置边框
		style.setBorderBottom(cellStyle.getBorderBottom()); //下边框
		style.setBorderLeft(cellStyle.getBorderLeft());//左边框
		style.setBorderTop(cellStyle.getBorderTop());//上边框
		style.setBorderRight(cellStyle.getBorderRight());//右边框
		//设置边框颜色
		style.setBottomBorderColor(cellStyle.getBottomBorderColor());
		style.setTopBorderColor(cellStyle.getTopBorderColor());
		style.setLeftBorderColor(cellStyle.getLeftBorderColor());
		style.setRightBorderColor(cellStyle.getRightBorderColor());
		//设置自动换行
		style.setWrapText(cellStyle.getWrapText());

		style.setHidden(cellStyle.getHidden());
		//数据格式
		style.setDataFormat(cellStyle.getDataFormate());
		style.setLocked(cellStyle.getLocked());
		//文本旋转 请注意，这里的Rotation取值是从-90到90，而不是0-180度
		style.setRotation(cellStyle.getRotation());
		//文本缩进
		style.setIndention(cellStyle.getIndention());
		return style;
	}
	/**
	 *
	 *摘要：
	 *@说明：Excel样式
	 *@创建：作者:yxy 	创建时间：2011-8-17
	 *@param workBook
	 *@param cellStyle 样式模型
	 *@return
	 *@修改历史：
	 *		[序号](yxy	2011-8-17)<修改说明>
	 */
	public static HSSFCellStyle getNewStyle(HSSFWorkbook workBook,CellStyle cellStyle,HSSFFont font) {
		HSSFCellStyle style = workBook.createCellStyle();
		//对齐方式
		style.setAlignment(cellStyle.getAlignment());
		style.setVerticalAlignment(cellStyle.getVAlignment());
		//设置背景颜色
		//最好的设置Pattern
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		//单元格背景的显示模式
		style.setFillForegroundColor(cellStyle.getColor());				// 单元格背景的显示模式．
		//style.setFillBackgroundColor(arg0);
		//设置边框
		style.setBorderBottom(cellStyle.getBorderBottom()); //下边框
		style.setBorderLeft(cellStyle.getBorderLeft());//左边框
		style.setBorderTop(cellStyle.getBorderTop());//上边框
		style.setBorderRight(cellStyle.getBorderRight());//右边框
		//设置边框颜色
		style.setBottomBorderColor(cellStyle.getBottomBorderColor());
		style.setTopBorderColor(cellStyle.getTopBorderColor());
		style.setLeftBorderColor(cellStyle.getLeftBorderColor());
		style.setRightBorderColor(cellStyle.getRightBorderColor());
		//设置自动换行
		style.setWrapText(cellStyle.getWrapText());

		style.setHidden(cellStyle.getHidden());
		//数据格式
		style.setDataFormat(cellStyle.getDataFormate());
		style.setLocked(cellStyle.getLocked());
		//文本旋转 请注意，这里的Rotation取值是从-90到90，而不是0-180度
		style.setRotation(cellStyle.getRotation());
		//文本缩进
		style.setIndention(cellStyle.getIndention());
		//设置字体
		style.setFont(font);
		return style;
	}
	/**
	 *
	 *摘要：
	 *@说明：获取excel单元格的值
	 *@创建：作者:yxy 	创建时间：2012-2-2
	 *@param sheet
	 *@param row
	 *@param cell
	 *@return
	 *@修改历史：
	 *		[序号](yxy	2012-2-2)<修改说明>
	 */
	public static String getCellStr(HSSFSheet sheet,int row,int cell){
		try{
			return sheet.getRow(row).getCell(cell).getStringCellValue();
		}catch(Exception ex){
			return "";
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：获取excel单元格的值
	 *@创建：作者:yxy 	创建时间：2012-2-2
	 *@param sheet
	 *@param row
	 *@param cell
	 *@return
	 *@修改历史：
	 *		[序号](yxy	2012-2-2)<修改说明>
	 */
	public static Double getCellDb(HSSFSheet sheet,int row,int cell){
		try{
			return sheet.getRow(row).getCell(cell).getNumericCellValue();
		}catch(Exception ex){
			return 0.0;
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：获取excel单元格的值
	 *@创建：作者:yxy 	创建时间：2012-2-2
	 *@param sheet
	 *@param row
	 *@param cell
	 *@return
	 *@修改历史：
	 *		[序号](yxy	2012-2-2)<修改说明>
	 */
	public static String getCellStr(HSSFRow row,int cell){
		try{
			return row.getCell(cell).getStringCellValue();
		}catch(Exception ex){
			return "";
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：获取excel单元格的值
	 *@创建：作者:yxy 	创建时间：2012-2-2
	 *@param sheet
	 *@param row
	 *@param cell
	 *@return
	 *@修改历史：
	 *		[序号](yxy	2012-2-2)<修改说明>
	 */
	public static Double getCellDb(HSSFRow row,int cell){
		try{
			return row.getCell(cell).getNumericCellValue();
		}catch(Exception ex){
			return 0.0;
		}
	}
	/**
	  *摘要：
	  *@说明：获取单元格值
	  *@创建：作者:yxy		创建时间：2013-11-7
	  *@param @param cell
	  *@param @return
	  *@修改历史：
	  *		[序号](yxy	2013-11-7)<修改说明>
	 */
	public static Object getCellValue(HSSFCell cell){
		switch (cell.getCellType()){
			case HSSFCell.CELL_TYPE_BOOLEAN:
				return cell.getBooleanCellValue();
			case HSSFCell.CELL_TYPE_NUMERIC:
				if(HSSFDateUtil.isCellDateFormatted(cell)){
					Date dt = cell.getDateCellValue();
					try {
						return DateTimeUtil.getDateToStr(dt, "yyyy-MM-dd HH:mm:ss");
					} catch (Exception e) {
						return null;
					}
				}else{
					return cell.getNumericCellValue();
				}
			case HSSFCell.CELL_TYPE_STRING:
				return cell.getStringCellValue();
			default:
				return null;
		}
	}
}
