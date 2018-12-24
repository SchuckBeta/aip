package com.oseasy.putil.common.ftp;

import java.io.IOException;

import org.apache.commons.pool.BasePoolableObjectFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.oseasy.putil.common.ftp.exceptions.FtpConnectionException;

/**
 * Created by victor on 2017/7/20.
 */
public class VsftpFactory extends BasePoolableObjectFactory {
    protected Logger logger = LoggerFactory.getLogger(getClass());
    private String host;
    private int port;
    private String username;
    private String passwd;

    public VsftpFactory(final String host, final int port, final String username, final String passwd) {
        this.host = host;
        this.port = port;
        this.username = username;
        this.passwd = passwd;
    }

    //重新初始化实例返回池
    @Override
    public void activateObject(Object arg0) throws Exception {
        logger.info("进入 activateObject 方法");
    }

    //销毁被破坏的实例
    @Override
    public void destroyObject(Object arg0) throws Exception {
        logger.info("进入 destroyObject 方法");
        Vsftp vsftp = (Vsftp) arg0;
        if (vsftp != null && vsftp.getFtpclient().isConnected()) {
            try {
                vsftp.getFtpclient().disconnect();
            } catch (IOException ioe) {
                throw new FtpConnectionException(ioe);
            }
        }
    }

    //创建一个实例到对象池
    @Override
    public Object makeObject() throws Exception {
        logger.info("进入makeObject 方法");
        Vsftp vsftp = new Vsftp(host, port, username, passwd);
        return vsftp;
    }

    //取消初始化实例返回到空闲对象池
    @Override
    public void passivateObject(Object arg0) throws Exception {
        logger.info("进入 passivateObject 方法");
    }

    //验证该实例是否安全
    @Override
    public boolean validateObject(Object arg0) {
        logger.info("进入 validateObject 方法");
        if (arg0 == null) {
            return false;
        }
        Vsftp vsftp = (Vsftp) arg0;
        if (vsftp.getFtpclient().isConnected()) {//连接关了 在打开
            logger.info("进入 validateObject   vsftp.getFtpclient().isConnected() 方法");
            return false;
        }
        return true;
    }
}
