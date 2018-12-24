/**
 * .
 */

package com.oseasy.initiate.data;

import java.util.List;

/**
 * 测试数据提供者.
 * @author chenhao
 */
public interface BaseDataRecords<T, R>{
    /**
     * 获取 Json文件中的RECORDS键.
     * @param mainClass 转换Class
     * @param datafile 文件
     * @return List
     */
    public abstract List<T> getRecords(Class<T> mainClass, String datafile);

    /**
     * 获取 数据库对象转换为目标对象.
     * @param tables 表对象
     * @return List
     */
    public abstract List<R> convert(List<T> tables);
}
