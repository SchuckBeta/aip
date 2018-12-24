package com.oseasy.pact.modules.actyw.tool.process;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.oseasy.pact.modules.actyw.entity.ActYwGclazz;
import com.oseasy.pact.modules.actyw.entity.ActYwGclazzData;
import com.oseasy.pact.modules.actyw.tool.process.vo.ClazzThemeListener;

public class GclzzUtils {
    public final static Logger log = Logger.getLogger(GclzzUtils.class);

    /**
     * 通过反射调用gclazz中定义的方法
     * @param gclazz
     */
    @SuppressWarnings("unchecked")
    public static ActYwGclazzData invokMethod(ActYwGclazzData gclazzData) {
        if ((gclazzData == null) || (gclazzData.getGclazz() == null)) {
            return null;
        }

        ActYwGclazz gclazz = gclazzData.getGclazz();
        if ((gclazz.getListener() == null) || StringUtils.isEmpty(gclazz.getListener().getType())) {
            return null;
        }

        try {
            ClazzThemeListener ctl = ClazzThemeListener.getByKey(gclazz.getListener().getType());
            if((ctl == null) || StringUtils.isEmpty(ctl.getCmethod())){
                return null;
            }
            Class clazz = ctl.getListener();
            Object object = clazz.newInstance();

            if (object == null) {
                log.error("监听类 = [" + ctl.getName() + "] 未初始化成功，请检查是否配置正确！！！");
                return null;
            }

            clazz = object.getClass();
            Method method = null;
            method = clazz.getDeclaredMethod(ctl.getCmethod());


            if (method == null) {
                log.error("监听类 = [" + ctl.getName() + "] 未初始化成功，请检查是否配置正确！！！");
                return null;
            }
            try {
                method.invoke(object);
            } catch (IllegalAccessException e) {
                log.error(e);
            } catch (IllegalArgumentException e) {
                log.error(e);
            } catch (InvocationTargetException e) {
                log.error(e);
            }
            log.info("监听类 = [" + ctl.getCmethod() + "] 初始化成功");
        } catch (NoSuchMethodException e) {
            log.error("监听类= [" + gclazz.getId() + "] 未初始化成功，方法名设置错误！！！");
        } catch (SecurityException e) {
            log.error(e);
        } catch (Exception e) {
            log.error(e);
        }
        return null;
    }


    /**
     * 通过反射调用gclazz中定义的方法
     * @param gclazz
     */
    @SuppressWarnings("unchecked")
    public static ActYwGclazzData invokMethodParam(ActYwGclazzData gclazzData) {
        if ((gclazzData == null) || (gclazzData.getGclazz() == null)) {
            return null;
        }

        ActYwGclazz gclazz = gclazzData.getGclazz();
        if ((gclazz.getListener() == null) || StringUtils.isEmpty(gclazz.getListener().getType())) {
            return null;
        }

        try {
            ClazzThemeListener ctl = ClazzThemeListener.getByKey(gclazz.getListener().getType());
            if((ctl == null) || StringUtils.isEmpty(ctl.getCmethod())){
                return null;
            }
            Class clazz = ctl.getListener();
            Object object = clazz.newInstance();

            if (object == null) {
                log.error("监听类 = [" + ctl.getName() + "] 未初始化成功，请检查是否配置正确！！！");
                return null;
            }

            clazz = object.getClass();
            Method method = null;
            method = clazz.getDeclaredMethod(ctl.getCmethod());


            if (method == null) {
                log.error("监听类 = [" + ctl.getName() + "] 未初始化成功，请检查是否配置正确！！！");
                return null;
            }
            try {
                method.invoke(object, gclazzData);
            } catch (IllegalAccessException e) {
                log.error(e);
            } catch (IllegalArgumentException e) {
                log.error(e);
            } catch (InvocationTargetException e) {
                log.error(e);
            }
            log.info("监听类 = [" + ctl.getCmethod() + "] 初始化成功");
        } catch (NoSuchMethodException e) {
            log.error("监听类= [" + gclazz.getId() + "] 未初始化成功，方法名设置错误！！！");
        } catch (SecurityException e) {
            log.error(e);
        } catch (Exception e) {
            log.error(e);
        }
        return null;
    }
}
