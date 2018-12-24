/**
 * 
 */
package com.oseasy.pcore.common.supcan.common;

import java.util.List;

import com.google.common.collect.Lists;
import com.oseasy.pcore.common.supcan.common.fonts.Font;
import com.oseasy.pcore.common.supcan.common.properties.Properties;
import com.oseasy.pcore.common.utils.IdGen;
import com.thoughtworks.xstream.annotations.XStreamAlias;

/**
 * 硕正Common
 * @author WangZhen

 */
public class Common {

	/**
	 * 属性对象
	 */
	@XStreamAlias("Properties")
	protected Properties properties;
	
	/**
	 * 字体对象
	 */
	@XStreamAlias("Fonts")
	protected List<Font> fonts;

	public Common() {
		properties = new Properties(IdGen.uuid());
		fonts = Lists.newArrayList(
				new Font("宋体", "134", "-12"),
				new Font("宋体", "134", "-13", "700"));
	}
	
	public Common(Properties properties) {
		this();
		this.properties = properties;
	}
	
	public Properties getProperties() {
		return properties;
	}

	public void setProperties(Properties properties) {
		this.properties = properties;
	}

	public List<Font> getFonts() {
		return fonts;
	}

	public void setFonts(List<Font> fonts) {
		this.fonts = fonts;
	}

}
