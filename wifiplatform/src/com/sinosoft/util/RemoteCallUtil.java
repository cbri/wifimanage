package com.sinosoft.util;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;
import java.util.Properties;

import net.sf.json.JSONObject;

public class RemoteCallUtil {

	/**
	 * 远程调用带有javabean
	 * @param javabean保存信息
	 * @return
	 */
	public static String remoteCall(Map<String,Object> javabean) {
		// 读取配置文件中的信息
		InputStream in = RemoteCallUtil.class
				.getResourceAsStream("remoteCall.properties");
		Properties p = new Properties();
		String path="";
		// 拼接字符串
		JSONObject obj = new JSONObject();
		try {
			//读取
			p.load(in);
			//用户名密码设置
			obj.element("username", p.get("username"));
			obj.element("password", p.get("password"));
			System.out.println(p.get("username"));
		} catch (IOException e1) {
			e1.printStackTrace();
		}

		// 取出type根据type配置各种数据信息
		String type = (String) javabean.get("type");
		// 根据不同type将参数配置
		if ("portal_set".equals(type)) {
			path = (String) p.get("path");
			obj.element("data","[{'name':'"+javabean.get("portalname")+"'," +
					"'mac':'"+javabean.get("mac")+"'," +
					"'redirect_url':'"+javabean.get("redirect_url")+"'," +
					"'portal_url':'"+javabean.get("portal_url")+"'}]");
		} else if ("agreement".equals(type)) {
			path = "http://"+javabean.get("ip")+"/update_conf.json";
			obj.element("mac", javabean.get("mac"));
			obj.element("checkinterval", javabean.get("heartbeat"));
			obj.element("authinterval", javabean.get("authenticate"));
			obj.element("clienttimeout", javabean.get("offline_judge"));
			obj.element("httpmaxconn", javabean.get("visitor_num"));
			obj.element("times", "3");
			obj.element("available", "5");
		} else if ("whitelist".equals(type)) {
			path = "http://"+javabean.get("ip")+"/update_publicip.json";
			obj.element("mac", javabean.get("mac"));
			String ips=(String) javabean.get("whitelist_ip");
			String[] ipArr=ips.split(";");
			String data="[";
			for(int i=0;i<ipArr.length;i++){
				if(i==ipArr.length-1){
					data+="{'publicip':'"+ipArr[i]+"'}";
					continue;
				}
				data+="{'publicip':'"+ipArr[i]+"'},";
			}
			data+="]";
			obj.element("data",data);
		}else if("whitemaclist".equals(type)){
			path = "http://"+javabean.get("ip")+"/update_trustedmacs.json";
			obj.element("mac", javabean.get("mac"));
			String ips=(String) javabean.get("whitelist_ip");
			String[] ipArr=ips.split(";");
			String data="[";
			for(int i=0;i<ipArr.length;i++){
				if(i==ipArr.length-1){
					data+="{'mac':'"+ipArr[i]+"'}";
					continue;
				}
				data+="{'mac':'"+ipArr[i]+"'},";
			}
			data+="]";
			obj.element("data",data);
		}else if("auth_type".equals(type)){
			path = "http://"+javabean.get("ip")+"/update_auth_type.json";
			obj.element("mac", javabean.get("mac"));
			String cmd=(String) javabean.get("cmd_flag");
			obj.element("authtype", "7".equals(cmd)?"radius":"local");
			obj.element("times", "3");
			obj.element("available", "5");
		}else if("authInterval".equals(type)){
			path = "http://"+javabean.get("ip")+"/update_access_time.json";
			obj.element("mac", javabean.get("mac"));
			obj.element("time_delay", javabean.get("authinterval"));
			obj.element("times", "3");
			obj.element("available", "5");
		}
		else{
			path = "http://"+javabean.get("ip")+"/update_cmdline.json";
			obj.element("mac", javabean.get("mac"));
			obj.element("nodecmd_id", javabean.get("cmd_flag"));
			obj.element("times", "3");
			obj.element("available", "5");
		}

		// 回馈信息
		StringBuffer sb = new StringBuffer("");
		// 创建连接
		try {
			URL url = new URL(path);
			HttpURLConnection connection = (HttpURLConnection) url
					.openConnection();
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod("POST");
			connection.setUseCaches(false);
			connection.setInstanceFollowRedirects(true);
			connection.setRequestProperty("Content-Type", "application/json");
			connection.connect();
			// POST请求
			DataOutputStream out = new DataOutputStream(connection
					.getOutputStream());
			out.writeBytes(obj.toString());

			out.flush();
			out.close();

			// 读取响应
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					connection.getInputStream()));
			String lines;

			while ((lines = reader.readLine()) != null) {
				lines = new String(lines.getBytes(), "utf-8");
				sb.append(lines);
			}
			reader.close();
			// 断开连接
			connection.disconnect();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return sb.toString();
	}

}
