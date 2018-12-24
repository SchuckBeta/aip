/**
 * .
 */

package com.oseasy.initiate.data;

import java.util.List;

/**
 * 测试数据提供者.
 * @author chenhao
 */
public interface BaseDataProvider<T> {
    /**
     * 获取列表.
     * @return List
     */
    public List<T> getDatas();

    /**
     *Json文件 获取列表.
     * @return List
     */
    public List<T> getDataByJson();


    /**
     *Cvs文件 获取列表.
     * @return List
     */
    public List<T> getDataByCvs();

    /**
     *Json文件 获取列表.
     * @param datafile 文件路径
     * @return List
     */
    public List<T> getDataByJson(String datafile);

    /**
     *Cvs文件 获取列表.
     * @param datafile 文件路径
     * @return List
     */
    public List<T> getDataByCvs(String datafile);
}
