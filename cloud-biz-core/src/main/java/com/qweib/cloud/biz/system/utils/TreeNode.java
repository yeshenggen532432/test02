package com.qweib.cloud.biz.system.utils;
import java.util.List;

/**
 * Created by Massive on 2016/12/26.
 */
public class TreeNode {
 
    private String id;
 
    private String pId;
 
    private String text;
    
    private boolean expanded = false;
    
    private boolean checked = false;

	private String menuTp;//菜单类型(必填)  0--功能菜单  1-功能按钮（最后一级）
	private int applyNo;
	private String tp;//类型 1 menu 2 应用
	private String menuId;
	private String menuLeaf;//是否明细菜单  0--否  1--是
	private String sgtjz;
	private String mids;

    private List<TreeNode> children;
    
    public TreeNode() {
	}

	public TreeNode(String id, String text,String pId) {
		this.id = id;
		this.pId = pId;
		this.text = text;
	}
    
    public TreeNode(String id, String pId, String text, boolean expanded,boolean checked) {
		this.id = id;
		this.pId = pId;
		this.text = text;
		this.expanded = expanded;
		this.checked = checked;
	}

	public TreeNode(String id, String pId, String text, boolean expanded, boolean checked, String menuTp, int applyNo, String tp, String menuId, String menuLeaf, String sgtjz, String mids) {
		this.id = id;
		this.pId = pId;
		this.text = text;
		this.expanded = expanded;
		this.checked = checked;
		this.menuTp = menuTp;
		this.applyNo = applyNo;
		this.tp = tp;
		this.menuId = menuId;
		this.menuLeaf = menuLeaf;
		this.sgtjz = sgtjz;
		this.mids = mids;
	}

	public String getpId() {
		return pId;
	}

	public void setpId(String pId) {
		this.pId = pId;
	}

	public void setChecked(boolean checked) {
		this.checked = checked;
	}

	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public Boolean getChecked() {
		return checked;
	}
	public void setChecked(Boolean checked) {
		this.checked = checked;
	}
	public String getId() {
        return id;
    }
 
    public void setId(String id) {
        this.id = id;
    }

	public boolean isExpanded() {
		return expanded;
	}

	public void setExpanded(boolean expanded) {
		this.expanded = expanded;
	}

	public boolean isChecked() {
		return checked;
	}

	public String getMenuTp() {
		return menuTp;
	}

	public void setMenuTp(String menuTp) {
		this.menuTp = menuTp;
	}

	public int getApplyNo() {
		return applyNo;
	}

	public void setApplyNo(int applyNo) {
		this.applyNo = applyNo;
	}

	public String getTp() {
		return tp;
	}

	public void setTp(String tp) {
		this.tp = tp;
	}

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getMenuLeaf() {
		return menuLeaf;
	}

	public void setMenuLeaf(String menuLeaf) {
		this.menuLeaf = menuLeaf;
	}

	public String getSgtjz() {
		return sgtjz;
	}

	public void setSgtjz(String sgtjz) {
		this.sgtjz = sgtjz;
	}

	public String getMids() {
		return mids;
	}

	public void setMids(String mids) {
		this.mids = mids;
	}

	public List<TreeNode> getChildren() {
        return children;
    }
 
    public void setChildren(List<TreeNode> children) {
        this.children = children;
    }
 
    @Override
    public String toString() {
    	StringBuilder str = new StringBuilder();
    	str.append("{");
    	str.append("\"id\":"+id);
    	str.append(",\"pId\":"+pId);
    	str.append(",\"text\":\""+text+"\"");
    	str.append(",\"checked\":"+checked);
		str.append(",\"tp\":\""+tp+"\"");
		str.append(",\"menuId\":\""+menuId+"\"");
		str.append(",\"sgtjz\":\""+sgtjz+"\"");
		str.append(",\"mids\":\""+mids+"\"");
		str.append(",\"menuLeaf\":\""+menuLeaf+"\"");
    	if(children!=null && children.size()>0){
    		this.expanded=false;
    		if("0".equals(this.id)){//"0"为"根节点"（默认打开）
    			this.expanded=true;
    		}
			str.append(",\"expanded\":"+expanded);
			str.append(",\"children\":"+children);
    	}
    	str.append("}");
    	return str.toString();
    }
 
}

