package com.sinosoft.addrtree.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sinosoft.account.bean.Account;
import com.sinosoft.account.bean.AccountDistrictRel;
import com.sinosoft.account.service.AccountService;
import com.sinosoft.addrtree.bean.Position;
import com.sinosoft.addrtree.service.PositionService;
import com.sinosoft.base.controller.BaseController;
import com.sinosoft.dataSource.DbContextHolder;
/**
 * 位置信息的控制层
 * @author 于永波
 * @since  2014-5-27
 */
@Controller
public class PositionController extends BaseController{
	@Autowired
	private PositionService positionService;
	@Autowired
	private AccountService accountService;
	/**
	 * 获取树的节点数据
	 * @param req 请求参数
	 * @return
	 */
	@RequestMapping(value="/PositionController!getTreeData",method=RequestMethod.GET)
	@ResponseBody
	public String getTreeData(HttpServletRequest req){
		DbContextHolder.clearDbType();
		HashMap<String, String> map = new HashMap<String, String>();
		List<Position> treeDataByCode = new ArrayList<Position>();
		String path = req.getContextPath();
		String basePath = path+"/";
		String uid = req.getParameter("userid");
		//通过用户取
		Account acc = (Account) req.getSession().getAttribute("user");
		if(uid != null && !"".equals(uid)){
			HashMap<String, Object> args = new HashMap<String, Object>();
			args.put("id", uid);
			List<Account> accounts = accountService.getAccount(args);
			if(accounts != null&&accounts.size()>0){
				acc = accounts.get(0);
			}
		}
		if((acc.getParent_userid() == null || acc.getParent_userid() == 0)){
			map.put("parent_code", "0");
			treeDataByCode = positionService.getAddrTree(map);
			for (Position position : treeDataByCode) {
				if(position != null){
					//看看是省、市、区
					setIcon(basePath, position);
				}
			}
		}else{
			treeDataByCode = positionService.getPositionByUserid(acc.getId().toString());
			for (Position position : treeDataByCode) {
				if(position != null){
					setIcon(basePath, position);
				}
			}
			List<AccountDistrictRel> adRel = accountService.queryAccountDistrictRel(acc);
			for (int i = 0; i < adRel.size(); i++) {
				AccountDistrictRel ar = adRel.get(i);
				Position p = new Position();
				p.setId(ar.getCode());
				p.setLeaf(0);
				p.setLevels(0);
				p.setName(ar.getName());
				p.setExpand(true);
				p.setpId(ar.getParent_code());
				//看看是省、市、区
				setIcon(basePath, p);
				treeDataByCode.add(p);
				
			}
		}
		JSONArray treeNodes = new JSONArray();
		treeNodes.addAll(treeDataByCode);
		return treeNodes.toString();
	}
	/**
	 * 根据树节点的ID获取该节点的字节点的数据
	 * @param req 请求参数
	 * @return
	 */
	@RequestMapping(value="/PositionController!getTreeDataById",method=RequestMethod.GET)
	@ResponseBody
	public String getTreeDataById(HttpServletRequest req){
		DbContextHolder.clearDbType();
		String path = req.getContextPath();
		String basePath = path+"/";
		String id = req.getParameter("id");
		List<Position> treeDataByCode = null;
		//检查USER
		Account user = (Account) req.getSession().getAttribute("user");
		if(user.getLevel() != 0){
			//市级用户
			if(id.matches("[1-9][0-9][0]{4}")){
				//
				treeDataByCode = positionService.getPositionByUserid(user.getId().toString());
				for (Position position : treeDataByCode) {
					if(position != null){
						setIcon(basePath, position);
					}
				}
				List<AccountDistrictRel> adRel = accountService.queryAccountDistrictRel(user);
				for (int i = 0; i < adRel.size(); i++) {
					AccountDistrictRel ar = adRel.get(i);
					Position p = new Position();
					p.setId(ar.getCode());
					p.setLeaf(0);
					p.setLevels(0);
					p.setName(ar.getName());
					p.setExpand(true);
					p.setpId(ar.getParent_code());
					//看看是省、市、区
					setIcon(basePath, p);
					treeDataByCode.add(p);
				}
				JSONArray treeNodes = new JSONArray();
				treeNodes.addAll(treeDataByCode);
				return treeNodes.toString();
			}
		}
		
		Map<String, String> arguments = new HashMap<String, String>();
		arguments.put("parent_code", id);
		treeDataByCode = positionService.getAddrTree(arguments);
		for (Position position : treeDataByCode) {
			if(position != null){
				setIcon(basePath, position);
			}
			
		}
		JSONArray treeNodes = new JSONArray();
		treeNodes.addAll(treeDataByCode);
		return treeNodes.toString();
	}
	/**
	 * 设置树节点的图片
	 * @param basePath
	 * @param position
	 */
	private void setIcon(String basePath, Position position) {
		if(position.getId().matches("[1-9][0-9]{1}[0]{4}")){
			//省
			position.setIcon(basePath+"source"+"/"+"images"+"/"+"province.png");
			position.setIsParent(true);
		}else if(position.getId().matches("[1-9][0-9][1-9][0-9][0]{2}|[1-9][0-9][0-9][1-9][0]{2}")){
			//市
			position.setIcon(basePath+"source"+"/"+"images"+"/"+"city.png");
			position.setIsParent(true);
		}else if(position.getId().matches("[0-9]{4}[1-9][0-9]|[0-9]{4}[0-9][1-9]")){
			//区
			position.setIcon(basePath+"source"+"/"+"images"+"/"+"district.png");
			position.setIsParent(false);
		}
	}
	/**
	 * 获取树的节点数据
	 * @param req 请求参数
	 * @return
	 */
	@RequestMapping(value="/euTreeData!getTreeData",method=RequestMethod.GET)
	@ResponseBody
	public JSONArray getEasyUiTreeData(HttpServletRequest req){
		DbContextHolder.clearDbType();
		HashMap<String, String> map = new HashMap<String, String>();
		List<Position> treeDataByCode = new ArrayList<Position>();
		Account user = (Account) req.getSession().getAttribute("user");
		List<AccountDistrictRel> adRel = new ArrayList<AccountDistrictRel>();
		if(user.getParent_userid()==0){
			//管理员查询所有
			map.put("parent_code", "0");
			treeDataByCode = positionService.getAddrTree(map);
			for (Position position : treeDataByCode) {
				if(position != null){
					if(position.getLeaf() != 2){
						position.setIsParent(true);
					}
				}
			}
			user.setLevel(-1);
		}else{
			treeDataByCode = positionService.getPositionByUserid(user.getId().toString());
			adRel = accountService.queryAccountDistrictRel(user);
		}
		Map<String, EasyUiTreeData> treeDatas = new HashMap<String, PositionController.EasyUiTreeData>();
		List<PositionController.EasyUiTreeData> mp = new ArrayList<PositionController.EasyUiTreeData>();
		for (AccountDistrictRel ad : adRel) {
			EasyUiTreeData data = new EasyUiTreeData();
			data.setText(ad.getName());
			data.setId(ad.getCode());
			Map<String, String> attributes = new HashMap<String, String>();
			attributes.put("level", user.getLevel().toString());
			attributes.put("pid", ad.getParent_code());
			data.setAttributes(attributes);
			treeDatas.put(ad.getCode(), data);
		}
		for (Position position : treeDataByCode) {
			EasyUiTreeData data = new EasyUiTreeData();
			if(position != null){
				data.setId(position.getId());
				data.setText(position.getName());
				Map<String, String> attributes = new HashMap<String, String>();
				attributes.put("level", String.valueOf((user.getLevel()+1)));
				attributes.put("pid", position.getpId());
				data.setAttributes(attributes);
				EasyUiTreeData easyUiTreeData = treeDatas.get(position.getpId());
				if(easyUiTreeData != null){
					easyUiTreeData.getChildren().add(data);
				}else{
					mp.add(data);
				}
//				mp.add(data);
			}
		}
		mp.addAll(treeDatas.values());
		JSONArray treeNodes = new JSONArray();
		treeNodes.addAll(mp);
		return treeNodes;
	}
	
	/**
	 * 下拉多选树数据原型
	 * @author 于永波
	 */
	public static class EasyUiTreeData{
		private String id;
		private String text;
//		private String state = "closed";
		private boolean checked;
		private Map<String, String> attributes;
		private List<EasyUiTreeData> children = new ArrayList<PositionController.EasyUiTreeData>();
		
		public Map<String, String> getAttributes() {
			return attributes;
		}
		public void setAttributes(Map<String, String> attributes) {
			this.attributes = attributes;
		}
		public boolean isChecked() {
			return checked;
		}
		public void setChecked(boolean checked) {
			this.checked = checked;
		}
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getText() {
			return text;
		}
		public void setText(String text) {
			this.text = text;
		}
		public List<EasyUiTreeData> getChildren() {
			return children;
		}
		public void setChildren(List<EasyUiTreeData> children) {
			this.children = children;
		}
	}
	
}
