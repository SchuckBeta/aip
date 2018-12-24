package com.oseasy.initiate.modules.sys.utils;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.oseasy.pcore.common.config.Global;

public class ThreadPoolUtils {
	public static ExecutorService fixedThreadPool = Executors.newFixedThreadPool(Integer.parseInt(Global.getConfig("threadMaxNum")));
}
