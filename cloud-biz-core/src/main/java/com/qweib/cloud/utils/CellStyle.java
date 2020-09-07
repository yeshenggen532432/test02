
package com.qweib.cloud.utils;


/**
 *说明：单元格样式
 *@创建：作者:yxy		创建时间：2011-8-17
 *@修改历史：
 *		[序号](yxy	2011-8-17)<修改说明>
 */
public class CellStyle {
	private Short alignment=1;				//水平对齐方式
											//HSSFCellStyle.ALIGN_CENTER=2
											//SSFCellStyle.ALIGN_LEFT=1
											//HSSFCellStyle.ALIGN_RIGHT=3 默认居左
	private Short vAlignment=1;				//垂直对齐方式
											//HSSFCellStyle.VERTICAL_CENTER=1
											//HSSFCellStyle.VERTICAL_TOP=0
											//HSSFCellStyle.VERTICAL_BOTTOM=2
	private Short color=9;					//背景颜色,默认黑色
	private Short borderBottom=1;			//底部边框样式
	private Short borderLeft=1;				//左边框样式
	private Short borderTop=1;				//顶边框样式
	private Short borderRight=1;			//右边框样式
											//细边框 HSSFCellStyle.BORDER_THIN=1
											//双边框 HSSFCellStyle.BORDER_DOUBLE=6
											//小粗边框 HSSFCellStyle.BORDER_MEDIUM=2
											//粗边框 HSSFCellStyle.BORDER_THICK=5
											//虚边框 HSSFCellStyle.BORDER_DASHED=3
											//虚细边框 7
	private Short bottomBorderColor=8;		//底边框颜色,默认黑色
	private Short topBorderColor=8;			//顶边框颜色,默认黑色
	private Short leftBorderColor=8;		//左边框颜色,默认黑色
	private Short rightBorderColor=8;		//右边框颜色,默认黑色
	private Boolean wrapText=true;			//自动换行
	private Boolean locked=false;			//是否锁定
	private Short rotation=0;				//文本旋转 Rotation取值是从-90到90
	private Short indention=0;				//文本缩进,默认无缩进
	private Boolean hidden=false;			//隐藏
	private Short dataFormate=0;			//0-无格式 4-数字样式(1,234.00)
	public Short getAlignment() {
		return alignment;
	}
	public void setAlignment(Short alignment) {
		this.alignment = alignment;
	}
	public Short getBorderBottom() {
		return borderBottom;
	}
	public void setBorderBottom(Short borderBottom) {
		this.borderBottom = borderBottom;
	}
	public Short getBorderLeft() {
		return borderLeft;
	}
	public void setBorderLeft(Short borderLeft) {
		this.borderLeft = borderLeft;
	}
	public Short getBorderRight() {
		return borderRight;
	}
	public void setBorderRight(Short borderRight) {
		this.borderRight = borderRight;
	}
	public Short getBorderTop() {
		return borderTop;
	}
	public void setBorderTop(Short borderTop) {
		this.borderTop = borderTop;
	}
	public Short getBottomBorderColor() {
		return bottomBorderColor;
	}
	public void setBottomBorderColor(Short bottomBorderColor) {
		this.bottomBorderColor = bottomBorderColor;
	}
	public Short getColor() {
		return color;
	}
	public void setColor(Short color) {
		this.color = color;
	}
	public Short getIndention() {
		return indention;
	}
	public void setIndention(Short indention) {
		this.indention = indention;
	}
	public Short getLeftBorderColor() {
		return leftBorderColor;
	}
	public void setLeftBorderColor(Short leftBorderColor) {
		this.leftBorderColor = leftBorderColor;
	}
	public Boolean getLocked() {
		return locked;
	}
	public void setLocked(Boolean locked) {
		this.locked = locked;
	}
	public Short getRightBorderColor() {
		return rightBorderColor;
	}
	public void setRightBorderColor(Short rightBorderColor) {
		this.rightBorderColor = rightBorderColor;
	}
	public Short getRotation() {
		return rotation;
	}
	public void setRotation(Short rotation) {
		this.rotation = rotation;
	}
	public Short getTopBorderColor() {
		return topBorderColor;
	}
	public void setTopBorderColor(Short topBorderColor) {
		this.topBorderColor = topBorderColor;
	}
	public Short getVAlignment() {
		return vAlignment;
	}
	public void setVAlignment(Short alignment) {
		vAlignment = alignment;
	}
	public Boolean getWrapText() {
		return wrapText;
	}
	public void setWrapText(Boolean wrapText) {
		this.wrapText = wrapText;
	}
	public Short getDataFormate() {
		return dataFormate;
	}
	public void setDataFormate(Short dataFormate) {
		this.dataFormate = dataFormate;
	}
	public Boolean getHidden() {
		return hidden;
	}
	public void setHidden(Boolean hidden) {
		this.hidden = hidden;
	}
}

