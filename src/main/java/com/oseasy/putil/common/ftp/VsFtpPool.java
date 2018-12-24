package com.oseasy.putil.common.ftp;

import org.apache.commons.net.ftp.FTPReply;
import org.apache.commons.pool.impl.GenericObjectPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.oseasy.putil.common.utils.exception.ExceptionUtil;

/**
 * Created by victor on 2017/7/20.
 */
public class VsFtpPool {
    protected Logger logger = LoggerFactory.getLogger(getClass());
    private GenericObjectPool pool = null;


    public VsFtpPool(PoolConfig config, String host, String port, String username, String passwd) {
        Long start = System.currentTimeMillis();
        pool = new GenericObjectPool(new VsftpFactory(host, Integer.valueOf(port), username, passwd), config.getConfig());
        try {
            int maxIdle = config.getConfig().maxIdle;
            for (int i = 0; i < maxIdle; i++) {
                pool.addObject();
            }
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
        }
        //测试连接池取出还入的  正式环境注释
        logger.info("vsftpPool    :" + (System.currentTimeMillis() - start) + "ms   MaxActive" + pool.getMaxActive() + "  MaxIdle:" + pool.getMaxIdle());
    }
    public int getNumIdle() {
		return pool.getNumIdle();
    }

    private Vsftp init() throws Exception {
        int i = 0;
        return getEffectiveVsftp(i);

    }

    private Vsftp getEffectiveVsftp(int i) throws Exception {
        if ((pool == null) || (i > pool.getMaxIdle())) {
            return null;
        }
        ++i;
        Vsftp vsftp = null;
		try {
			vsftp=pool != null ? (Vsftp) pool.borrowObject() : null;
		} catch (Exception e) {
			logger.error("无空闲链接可获取");
			return null;
		}
        try {
        	vsftp.getFtpclient().sendNoOp();//检测链接是否可用
        } catch (Exception e) {
        	pool.invalidateObject(vsftp);//不可用的先销毁
        	return getEffectiveVsftp(i);
        }
        boolean connected = vsftp.getFtpclient().isConnected();

        int reply = vsftp.getFtpclient().getReplyCode();
        boolean positiveCompletion = FTPReply.isPositiveCompletion(reply);

        if (vsftp != null && connected && positiveCompletion) {  //获取的可用
            return vsftp;
        } else {
            pool.invalidateObject(vsftp);//不可用的先销毁
            return getEffectiveVsftp(i); //在去取
        }
    }

    public void returnResource(Vsftp vsftp) {
    	try {
			pool.returnObject(vsftp);
		} catch (Exception e) {
			logger.error(ExceptionUtil.getStackTrace(e));
		}
    }
    public Vsftp getResource() {
        Vsftp vsftp = null;
        try {
            vsftp = this.init();
            if (vsftp == null) {
            	pool.invalidateObject(vsftp);
            }
        } catch (Exception e) {
        	logger.error(ExceptionUtil.getStackTrace(e));
            if (pool != null) {
                try {
					pool.invalidateObject(vsftp);
				} catch (Exception e1) {
					logger.error(ExceptionUtil.getStackTrace(e));
				}
            }
        }
        return vsftp;
    }
}
