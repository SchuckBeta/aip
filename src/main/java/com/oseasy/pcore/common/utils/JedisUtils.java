/**
 *
 */
package com.oseasy.pcore.common.utils;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import org.springframework.data.redis.core.RedisTemplate;

import com.oseasy.putil.common.utils.ObjectUtil;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * Jedis Cache 工具类
 *

 * @version 2014-6-29
 */
@SuppressWarnings("unchecked")
public class JedisUtils {
	@SuppressWarnings("rawtypes")
	private static RedisTemplate redisTemplate= SpringContextHolder.getBean(RedisTemplate.class);
	/**发布消息给订阅者
	 * @param channel
	 * @param message
	 */
	public static void  publishMsg(String channel, String message) {
		redisTemplate.convertAndSend(channel, message);
	}
	/**设置超时时间
	 * @param cacheName
	 * @param timeoutSeconds
	 * @return
	 */
	public static Long expire(String cacheName,int timeoutSeconds) {
		redisTemplate.expire(cacheName, timeoutSeconds, TimeUnit.SECONDS);
		return  redisTemplate.getExpire(cacheName);
	}

	/**设置超时时间
	 * @param cacheName
	 * @param timeoutSeconds
	 * @return
	 */
	public static Long expire(byte[] cacheName,int timeoutSeconds) {
		redisTemplate.expire(cacheName, timeoutSeconds, TimeUnit.SECONDS);
		return  redisTemplate.getExpire(cacheName);
	}
	/**存储string类型数据
	 * @param cacheName
	 * @param value
	 */
	public static void set(byte[] cacheName,byte[] value) {
		redisTemplate.opsForValue().set(cacheName, value);
	}
	/**存储hash类型数据
	 * @param cacheName
	 * @param key
	 * @param value
	 */
	public static void hset(String cacheName,String key,String value) {
		redisTemplate.opsForHash().put(cacheName, key, value);
	}
	/**存储hash类型数据
	 * @param cacheName
	 * @param key
	 * @param value
	 */
	public static void hset(byte[] cacheName,byte[] key,byte[] value) {
		redisTemplate.opsForHash().put(cacheName, key, value);
	}
	/**获取hash类型数据
	 * @param cacheName
	 * @param key
	 * @return
	 */
	public static byte[] hget(byte[] cacheName,byte[] key) {
		return (byte[])redisTemplate.opsForHash().get(cacheName, key);
	}
	/**根据大小key删除hash类型数据
	 * @param cacheName
	 * @param key
	 */
	public static void hdel(byte[] cacheName,byte[] key) {
		redisTemplate.opsForHash().delete(cacheName, key);
	}
	/**根据大小key删除hash类型数据
	 * @param cacheName
	 * @param key
	 */
	public static void hdel(String cacheName,String key) {
		redisTemplate.opsForHash().delete(cacheName, key);
	}
	/**根据大key删除hash类型数据
	 * @param cacheName
	 * @param key
	 */
	public static void hdel(byte[] cacheName) {
		redisTemplate.opsForHash().delete(cacheName);
	}
	/**查询某大key的hash类型数据数量
	 * @param cacheName
	 * @param key
	 */
	public static Long hlen(byte[] cacheName) {
		return redisTemplate.opsForHash().size(cacheName);
	}
	/**查询某大key的hash类型数据所有小key
	 * @param cacheName
	 * @param key
	 */
	public static Set<byte[]> hkeys(byte[] cacheName) {
		return redisTemplate.opsForHash().keys(cacheName);
	}
	/**查询某大key的hash类型数据所有值
	 * @param cacheName
	 * @param key
	 */
	public static List<byte[]> hvals(byte[] cacheName) {
		return redisTemplate.opsForHash().values(cacheName);
	}
	/**在list类型数据首部塞入一个值
	 * @param cacheName
	 * @param value
	 * @return
	 */
	public static Long lpush(byte[] cacheName,byte[] value) {
		return redisTemplate.opsForList().leftPush(cacheName, value);
	}
	/**在list类型数据尾部塞入一个值
	 * @param cacheName
	 * @param value
	 * @return
	 */
	public static Long rpush(byte[] cacheName,byte[] value) {
		return redisTemplate.opsForList().rightPush(cacheName, value);
	}
	/**在list类型数据尾部弹出一个值并存入另一个list的首部，并返回该值
	 * @param cacheName
	 * @param value
	 * @return
	 */
	public static byte[] rpoplpush(byte[] cacheName,byte[] othercacheName) {
		return (byte[])redisTemplate.opsForList().rightPopAndLeftPush(cacheName, othercacheName);
	}
	/**弹出list类型数据尾部一个值
	 * @param cacheName
	 * @return
	 */
	public static byte[] rpop(byte[] cacheName) {
		return (byte[])redisTemplate.opsForList().rightPop(cacheName);
	}
	/**取出hash类型数据某大key下所有键和值
	 * @param cacheName
	 * @return
	 */
	public static Map<String,String> hgetAll(String cacheName) {
		return redisTemplate.opsForHash().entries(cacheName);
	}

	/**获取string类型数据的值
	 * @param cacheName
	 * @return
	 */
	public static byte[] get(byte[] cacheName) {
		return (byte[])redisTemplate.opsForValue().get(cacheName);
	}
	/**删除一个值
	 * @param cacheName
	 */
	public static void del(byte[] cacheName) {
		redisTemplate.delete(cacheName);
	}

	/**
	 * 获取byte[]类型Key
	 * @param key
	 * @return byte
	 */
	public static byte[] getBytesKey(Object object) {
		if (object instanceof String) {
    		return StringUtil.getBytes((String)object);
    	}else{
    		return ObjectUtil.serialize(object);
    	}
	}

	/**
	 * 获取byte[]类型Key
	 * @param key
	 * @return Object
	 */
	public static Object getObjectKey(byte[] key) {
		try{
			return StringUtil.toString(key);
		}catch(UnsupportedOperationException uoe) {
			try{
				return JedisUtils.toObject(key);
			}catch(UnsupportedOperationException uoe2) {
				uoe2.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * Object转换byte[]类型
	 * @param key
	 * @return
	 */
	public static byte[] toBytes(Object object) {
    	return ObjectUtil.serialize(object);
	}

	/**
	 * byte[]型转换Object
	 * @param key
	 * @return
	 */
	public static Object toObject(byte[] bytes) {
		return ObjectUtil.unserialize(bytes);
	}
}
