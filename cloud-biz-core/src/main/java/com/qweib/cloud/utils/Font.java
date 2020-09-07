
package com.qweib.cloud.utils;


public class Font {
	private String fontNm="宋体";	//字体名称,默认宋体
	private Short fontSize=11;		//字体大小,默认12
	private Short bold=400;			//700--加粗400--不加粗 默认
	private Boolean italic=false;	//是否是斜线false--否true--是,默认false
	private Byte underline=0;		//下划线
									//单下划线 HSSFFont.U_SINGLE=1 
									//双下划线 HSSFFont.U_DOUBLE=2
									//会计用单下划线 HSSFFont.U_SINGLE_ACCOUNTING=33 
									//会计用双下划线 HSSFFont.U_DOUBLE_ACCOUNTING=34
									//无下划线 HSSFFont.U_NONE=0 默认
	private Short offset=0;			//1--上标2--下标0--普通 默认
	private Boolean delLine=false;	//删除线true--有  false--无
	private Short fontColor=8;		//字体颜色,默认黑色
	public Short getFontColor() {
		return fontColor;
	}
	public void setFontColor(Short fontColor) {
		this.fontColor = fontColor;
	}
	public String getFontNm() {
		return fontNm;
	}
	public void setFontNm(String fontNm) {
		this.fontNm = fontNm;
	}
	public Short getFontSize() {
		return fontSize;
	}
	public void setFontSize(Short fontSize) {
		this.fontSize = fontSize;
	}
	public Byte getUnderline() {
		return underline;
	}
	public void setUnderline(Byte underline) {
		this.underline = underline;
	}
	public Boolean getDelLine() {
		return delLine;
	}
	public void setDelLine(Boolean delLine) {
		this.delLine = delLine;
	}
	public Short getOffset() {
		return offset;
	}
	public void setOffset(Short offset) {
		this.offset = offset;
	}
	public Short getBold() {
		return bold;
	}
	public void setBold(Short bold) {
		this.bold = bold;
	}
	public Boolean getItalic() {
		return italic;
	}
	public void setItalic(Boolean italic) {
		this.italic = italic;
	}
}

