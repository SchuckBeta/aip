/**
 *
 */
package com.oseasy.initiate.modules.sys.web;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.vo.SysValCode;

/**
 * 生成随机验证码

 * @version 2014-7-27
 */
@Controller
public class ValidateCodeController extends BaseController{
	private int w = 70;
	private int h = 26;

	/**
	 * 默认验证码Session存储.
	 * @param request
	 * @param validateCode
	 * @return
	 */
	private boolean validate(HttpServletRequest request, String validateCode) {
        return validate(null, request, validateCode);
    }

	private boolean validate(String type, HttpServletRequest request, String validateCode) {
	    String vkey = SysValCode.VKEY;
        if(StringUtils.isNotEmpty(type)){
            SysValCode sysvalCode = SysValCode.getByKey(type);
            if(sysvalCode != null){
                vkey =  SysValCode.genVcodeKey(sysvalCode);
            }else{
                logger.warn("验证码类型未定义！当前 类型为："+type);
            }
        }
		String code = (String)request.getSession().getAttribute(vkey);
		return validateCode.toUpperCase().equals(code);
	}
	@ResponseBody
	@RequestMapping(value = "${adminPath}/validateCode/checkValidateCode")
	public String checkValidateCodeA(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		return checkValidateCode(request, response);
	}
	@ResponseBody
	@RequestMapping(value = "${frontPath}/validateCode/checkValidateCode")
	public String checkValidateCodeF(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		return checkValidateCode(request, response);
	}

	@ResponseBody
	@RequestMapping(value = "${adminPath}/validateCode/checkValidateCodeBy/{type}")
	public String checkValidateCodeByA(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    return checkValidateCode(request, response);
	}
	@ResponseBody
	@RequestMapping(value = "${frontPath}/validateCode/checkValidateCodeBy/{type}")
	public String checkValidateCodeByF(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    return checkValidateCode(request, response);
	}

	private String checkValidateCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		return checkValidateCode(null, request, response);
	}

	private String checkValidateCode(String type, HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
        String validateCode = request.getParameter(SysValCode.VKEY); // AJAX验证，成功返回true
	    if (StringUtils.isNotBlank(validateCode)) {
	        return validate(type, request, validateCode)?"true":"false";
	    }else{
	        createImage(request, response);
	        return "false";
	    }
	}
	@RequestMapping(value = "${adminPath}/validateCode/createValidateCode")
	public void createValidateCodeA(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		createImage(request,response);
	}
	@RequestMapping(value = "${frontPath}/validateCode/createValidateCode")
	public void createValidateCodeF(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		createImage(request,response);
	}

	private void createImage(HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		response.setHeader("Pragma", "no-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("image/jpeg");

		/*
		 * 得到参数高，宽，都为数字时，则使用设置高宽，否则使用默认值
		 */
		String width = request.getParameter("width");
		String height = request.getParameter("height");
		if (StringUtils.isNumeric(width) && StringUtils.isNumeric(height)) {
			w = NumberUtils.toInt(width);
			h = NumberUtils.toInt(height);
		}

		BufferedImage image = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
		Graphics g = image.getGraphics();

		/*
		 * 生成背景
		 */
		createBackground(g);

		/*
		 * 生成字符
		 */
		String s = createCharacter(g);
		request.getSession().setAttribute(SysValCode.VKEY, s);

		g.dispose();
		OutputStream out = response.getOutputStream();
		ImageIO.write(image, "JPEG", out);
		out.close();

	}

	private Color getRandColor(int fc,int bc) {
		int f = fc;
		int b = bc;
		Random random=new Random();
        if (f>255) {
        	f=255;
        }
        if (b>255) {
        	b=255;
        }
        return new Color(f+random.nextInt(b-f),f+random.nextInt(b-f),f+random.nextInt(b-f));
	}

	private void createBackground(Graphics g) {
		// 填充背景
		g.setColor(getRandColor(220,250));
		g.fillRect(0, 0, w, h);
		// 加入干扰线条
		for (int i = 0; i < 8; i++) {
			g.setColor(getRandColor(40,150));
			Random random = new Random();
			int x = random.nextInt(w);
			int y = random.nextInt(h);
			int x1 = random.nextInt(w);
			int y1 = random.nextInt(h);
			g.drawLine(x, y, x1, y1);
		}
	}

	private String createCharacter(Graphics g) {
		char[] codeSeq = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J',
				'K', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
				'X', 'Y', 'Z', '2', '3', '4', '5', '6', '7', '8', '9' };
		String[] fontTypes = {"Arial","Arial Black","AvantGarde Bk BT","Calibri"};
		Random random = new Random();
		StringBuilder s = new StringBuilder();
		for (int i = 0; i < 4; i++) {
			String r = String.valueOf(codeSeq[random.nextInt(codeSeq.length)]);//random.nextInt(10));
			g.setColor(new Color(50 + random.nextInt(100), 50 + random.nextInt(100), 50 + random.nextInt(100)));
			g.setFont(new Font(fontTypes[random.nextInt(fontTypes.length)],Font.BOLD,26));
			g.drawString(r, 15 * i + 5, 19 + random.nextInt(8));
//			g.drawString(r, i*w/4, h-5);
			s.append(r);
		}
		return s.toString();
	}

}
