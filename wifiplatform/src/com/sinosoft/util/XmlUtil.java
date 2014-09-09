package com.sinosoft.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;

/**
 * xml文件解析类
 * 
 * @author zhaolj
 * 
 */
public class XmlUtil {
	public static final String ATTR = "attr";
	public static final String TEXT = "text";

	private static Document document = null;

	public XmlUtil(String file) {
		this.document = read(file);
	}

	/**
	 * 读取xml
	 * @param file  xml文件
	 * @return
	 */
	public static Document read(String file) {
		SAXReader saxReader = new SAXReader();
		try {
			document = saxReader.read(file);
		} catch (DocumentException e) {
			e.printStackTrace();
			return null;
		}
		return document;
	}

	/**
	 * 获得document中的root元素
	 * 
	 * @return
	 */
	public static Element getRoot() {
		return document.getRootElement();
	}

	/**
	 * 获得某个元素下的所有子元素
	 * 
	 * @param parentElement
	 * @return
	 */
	public static List<Element> getChildElements(Element parentElement) {
		return parentElement.elements();
	}

	/**
	 * 获得元素中的某个属性
	 * @param element    元素
	 * @param attr       元素
	 * @return
	 */
	public static Attribute getAttribute(Element element, String attr) {
		return element.attribute(attr);
	}

	/**
	 * 获得根节点下的所有子元素
	 * @return
	 */
	public static List<Element> getAllElements() {
		Element root = getRoot();
		return getChildElements(root);
	}

	/**
	 * 根据id属获取某个元素
	 * @param id   只有当id为ID时该方法才有效
	 * @return
	 */
	public static Element getElementById(String id) {
		return getRoot().elementByID(id);
	}

	/**
	 * 根据元素名称获取某个元素，有多个时只获取第一个
	 * @param name   元素名
	 * @return
	 */
	public static Element getElementByName(String name) {
		return getRoot().element(name);
	}

	/**
	 * 根据xpath路径获取某个元素,可以获取任何位置上的元素
	 * @param path     xpath路径
	 * @return
	 */
	public static Element getElementByPath(String path) {
		Node node = document.selectSingleNode(path);
		return (node == null) ? null : (Element) node;
	}

	/**
	 * 从元素属性或者文本节点中获得json对象结果
	 * @param json     json结果
	 * @param element  元素
	 * @param type     元素类型,如果type为text从文本节点中获取，若果为attr为从属性中获得
	 * @return
	 */
	public static JSONObject generateJsonFromElement(JSONObject json,
			Element element, String type) {
		Map<String, String> map = new HashMap<String, String>();
		List<Element> elements = getChildElements(element);
		for (Element e : elements) {
			if (type.equals(ATTR)) {
				map.put(e.getName(), e.attributeValue("value"));
			}
			if (type.equals(TEXT)) {
				map.put(e.getName(), e.getText());
			}
		}
		json.put(element.getName(), map);
		return json;
	}
	
	public static JSONObject generateJsonFromElement() {
		JSONObject json = new JSONObject();
		Map<String, String> map = new HashMap<String, String>();
		Element root = getRoot();
		List<Element> rcElements = getChildElements(root);
		for (Element rcElement : rcElements) {
			List<Element> elements = getChildElements(rcElement);
			for (Element e : elements) {
				map.put(e.getName(), e.attributeValue("value"));
			}
			json.put(rcElement.getName(), map);
		}
		return json;
	}

	// ------------------------------------测试方法------------------------------------
	public static void main(String[] args) {
		read(".\\public\\xml\\pckrcmdConfig.xml");
		// read("E:\\Workspace\\TCMS\\public\\xml\\pckrcmdConfig.xml");
		List<Element> elements = getAllElements();
		for (Element e : elements) {
			System.out.println(e.getName());

		}
		Element element = getElementByPath("//voice[@id='voice']");
		elements = getChildElements(element);
		for (Element e : elements) {
			System.out.println(e.getName());
		}
		generateJson();

	}

	public static JSONObject generateJson() {
		JSONObject json = new JSONObject();
		Element element = getElementByPath("//voice[@id='voice']");
		json = generateJsonFromElement(json, element, "attr");
		element = getElementByPath("//flow[@id='flow']");
		json = generateJsonFromElement(json, element, "attr");
		element = getElementByPath("//sms[@id='sms']");
		json = generateJsonFromElement(json, element, "attr");
		element = getElementByPath("//roamUsage[@id='roamUsage']");
		json = generateJsonFromElement(json, element, "text");

		return json;
	}
	

}
