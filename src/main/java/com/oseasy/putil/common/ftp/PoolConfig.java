package com.oseasy.putil.common.ftp;

import org.apache.commons.pool.impl.GenericObjectPool.Config;

/**
 * Created by victor on 2017/12/22.
 */
public class PoolConfig  {
    public  Config config = new Config();

    public PoolConfig(int maxActive, int maxIdle, int maxWait) {
        config.maxActive = maxActive;
        config.maxIdle = maxIdle;
        config.maxWait = maxWait; ////        Config cWait = 3000; //设置这个，会抛Exception in thread "main" java.util.NoSuchElementException: Timeout waiting for idle object
    }

    public Config getConfig() {
        return config;
    }

}
