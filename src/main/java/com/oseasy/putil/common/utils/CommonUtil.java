package com.oseasy.putil.common.utils;

import org.apache.commons.lang3.StringUtils;

import java.text.DecimalFormat;
import java.text.NumberFormat;

/**
 * Created by zhangzheng on 2017/7/18.
 */
public class CommonUtil {
    public static String deleteZero(Object obj) {
        String value = String.valueOf(obj);
        if (value.indexOf(".") > 0) {
            value = value.replaceAll("0+?$", "");//去掉多余的0
            value = value.replaceAll("[.]$", "");//如最后一位是.则去掉
        }
        if (StringUtils.equals("0",value)||StringUtils.equals("null",value)) {
            value="0";
        }
        return value;
    }

    public static String saveNum(Object obj,int n) {
        NumberFormat ddf1=NumberFormat.getNumberInstance() ;
        ddf1.setMaximumFractionDigits(n);
        String s= ddf1.format(obj) ;
        return s;
    }


}
