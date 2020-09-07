package com.qweib.cloud.utils;

import java.util.List;

/**
 * 说明：分页的包装类
 */
public class Page {
	private int total = 0;		                  //总记录数
	private int curPage = 1;					  //当前页
	private int pageSize = 10;					  //每页大小
	private int totalPage = 0;                    //总页数
	private List rows;			                  //显示所有行的信息集合
	private Double tolprice;                      //金额统计
	private Integer tolnum;                       //数量统计
	private Double tolprice1;                      //金额统计1
	private Double tolprice2;                      //金额统计2
	public Double getTolprice1() {
		if(null==tolprice1){
			tolprice1=0.0;
		}
		return tolprice1;
	}
	public void setTolprice1(Double tolprice1) {
		this.tolprice1 = tolprice1;
	}
	public Double getTolprice2() {
		if(null==tolprice2){
			tolprice2=0.0;
		}
		return tolprice2;
	}
	public void setTolprice2(Double tolprice2) {
		this.tolprice2 = tolprice2;
	}
	public int getTotalPage() {
		if(total==0 || pageSize==0){
			totalPage = 0;
		}else{
			int temp = total%pageSize;
			totalPage = total/pageSize;
			if(temp!=0){
				totalPage++;
			}
		}
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getCurPage() {
		return curPage;
	}
	public void setCurPage(int curPage) {
		this.curPage = curPage;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public List getRows() {
		return rows;
	}
	public void setRows(List rows) {
		this.rows = rows;
	}
	public Double getTolprice() {
		if(null==tolprice){
			tolprice=0.0;
		}
		return tolprice;
	}
	public void setTolprice(Double tolprice) {
		this.tolprice = tolprice;
	}
	public Integer getTolnum() {
		return tolnum;
	}
	public void setTolnum(Integer tolnum) {
		this.tolnum = tolnum;
	}
	
	
}

