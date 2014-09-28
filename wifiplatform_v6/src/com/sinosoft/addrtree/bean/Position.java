package com.sinosoft.addrtree.bean;
/**
 * 位置节点
 * @Author 于永波
 * @since  2014/05/26
 */
public class Position {
	    // 菜单id
		private String id;
		// 上级菜单
		private String pId;
		// 菜单名称
		private String name;
		// 展开状态
		private boolean expand;
		// 是否是叶子节点
		private int leaf;
		// 图标
		private String icon;
		// 层次
		private Integer levels;
		// 跳转目标
		private String target;
		private Boolean isParent;
		// URI
		private String url;
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getpId() {
			return pId;
		}
		public void setpId(String pId) {
			this.pId = pId;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public boolean isExpand() {
			return expand;
		}
		public void setExpand(boolean expand) {
			this.expand = expand;
		}
		public int getLeaf() {
			return leaf;
		}
		public void setLeaf(int leaf) {
			this.leaf = leaf;
		}
		public String getIcon() {
			return icon;
		}
		public void setIcon(String icon) {
			this.icon = icon;
		}
		public Integer getLevels() {
			return levels;
		}
		public void setLevels(Integer levels) {
			this.levels = levels;
		}
		public String getTarget() {
			return target;
		}
		public void setTarget(String target) {
			this.target = target;
		}
		public String getUrl() {
			return url;
		}
		public void setUrl(String url) {
			this.url = url;
		}
		public Boolean getIsParent() {
			return isParent;
		}
		public void setIsParent(Boolean isParent) {
			this.isParent = isParent;
		}
		
		
}
