package com.oseasy.initiate.test;

import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

import com.oseasy.pcore.common.utils.IdGen;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.util.Iterator;

/**
 * Created by zhangzheng on 2017/8/10. 文件裁剪测试
 */
public class ImgTest {

    //裁剪本地图片
    public  static  String  cutLocalImage(String imagePath,String suffix) throws  Exception{
        int x=20;  /**剪切点X坐标*/
        int y=20; /**剪切点Y坐标*/
        int width=400; /**剪切点宽度*/
        int height=400;   /**剪切点高度*/
        String fileName="";
        String fileNameAndPath="";
        FileInputStream fis = null;
        ImageInputStream iis = null;
        /**读取图片*/
        Iterator<ImageReader> it = ImageIO.getImageReadersByFormatName(suffix);
        ImageReader reader = it.next();
        /**获取图片流*/
        fis = new FileInputStream(imagePath);
        iis = ImageIO.createImageInputStream(fis);
        reader.setInput(iis, true);
        ImageReadParam param = reader.getDefaultReadParam();
        Rectangle rect = new Rectangle(x, y, width, height);
        param.setSourceRegion(rect);
        BufferedImage bi = reader.read(0, param);
        fileName = IdGen.uuid() +"."+suffix;
        fileNameAndPath = "D:/test/"+fileName;
        ImageIO.write(bi, suffix , new File(fileNameAndPath));
        return fileNameAndPath;
    }

    public static void main(String[] args)  throws  Exception{
        cutLocalImage("D:/upload/zz.jpg","jpg");
    }

}
