package com.oseasy.pact.modules.actyw.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pact.modules.actyw.entity.ActYwGtime;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 时间和组件关联关系DAO接口.
 * @author zy
 * @version 2017-06-27
 */
@MyBatisDao
public interface ActYwGtimeDao extends CrudDao<ActYwGtime> {

	void deleteByGroupId(ActYwGtime actYwGtime);

	ActYwGtime getTimeByGnodeId(ActYwGtime actYwGtime);

	ActYwGtime getTimeByYnodeId(@Param("ywId") String ywId, @Param("gnodeId") String gnodeId);

	/**
	   * 批量保存.
	   * @param list
	   * @return
	   */
	public int savePl(@Param("list") List<ActYwGtime> list);

	/**
	* 根据groupId批量物理删除.
	* @param groupId 流程ID
	*/
	public void deletePlwlByGroup(@Param("groupId") String groupId);
	/**
	* 根据groupId和gnodeId批量物理删除.
	* @param groupId 流程ID
	* @param gnodeId 节点ID
	*/
  	public void deletePlwl(@Param("groupId") String groupId, @Param("gnodeId") String gnodeId);

	void deleteYearPlwl(@Param("projectId")String projectId,@Param("yearId")String yearId);

	List<String> getProByProjectIdAndYear(@Param("projectId")String projectId, @Param("year")String year);

	List<ActYwGtime> checkTimeByActYw(@Param("actYwId")String actYwId);

	int checkTimeIndex(@Param("actywId")String actYwId);
}