/**
 *
 */
package com.oseasy.initiate.modules.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.oseasy.initiate.modules.oa.entity.OaNotify;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pcore.modules.sys.entity.User;

/**
 * 通知通告DAO接口

 * @version 2014-05-16
 */
@MyBatisDao
public interface OaNotifyDao extends CrudDao<OaNotify> {
	public Integer getUnreadCount(String uid);
	public Integer getUnreadCountByUser(User user);
	/**
	 * 获取通知数目
	 * @param oaNotify
	 * @return
	 */
	public Long findCount(OaNotify oaNotify);
	public List<OaNotify> loginList(Integer number);
	public List<OaNotify> findLoginList(OaNotify oaNotify);
	public List<OaNotify> unReadOaNotifyList(OaNotify oaNotify);
	public Integer findNotifyCount(String createBy,String userId);
	public OaNotify findOaNotifyByTeamID(String userId,String sId);
	List<OaNotify> findSendList(OaNotify oaNotify);
	public List<Map<String,Object>> getMore(@Param(value="type")String type,@Param(value="id")String id,@Param(value="keys") List<String> keys);
	public void updateViews(@Param("param") Map<String,Integer> param);
    public List<OaNotify> findAllRecord(OaNotify entity);
}