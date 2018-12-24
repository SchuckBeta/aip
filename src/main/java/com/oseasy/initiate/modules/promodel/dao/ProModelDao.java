package com.oseasy.initiate.modules.promodel.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.oseasy.initiate.modules.promodel.entity.ProMidSubmit;
import com.oseasy.initiate.modules.promodel.entity.ProModel;
import com.oseasy.initiate.modules.promodel.vo.GcontestExpData;
import com.oseasy.initiate.modules.promodel.vo.GcontestStuExpData;
import com.oseasy.initiate.modules.promodel.vo.GcontestTeaExpData;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * proModelDAO接口.
 *
 * @author zy
 * @version 2017-07-13
 */
@MyBatisDao
public interface ProModelDao  extends CrudDao<ProModel>{
//public interface ProModelDao extends WorkFlowDao<ProModel, ExpProModelVo> {
	public Integer getByNumberAndId(@Param("number")String number,@Param("id")String id);
    public Integer getCountByName(@Param("protype")String protype,@Param("type")String type,@Param("name")String name);
	public void updateSubStatus(@Param("pid")String pid,@Param("subStatus")String subStatus);
	int checkProName(@Param("pname") String pname, @Param("pid") String pid, @Param("actywId") String actywId);
	public List<String> getProcinsidByActywid(String actywid);
	public void deleteReportByActywid(String actywid);
	public void deleteTeamUserHisByActywid(String actywid);
	public void deleteByActywid(String actywid);
	public List<GcontestExpData> getGcontestExpData(ProModel param);
	public List<GcontestStuExpData> getGcontestStuExpData(ProModel param);
	public List<GcontestTeaExpData> getGcontestTeaExpData(ProModel param);

	String getUnSubProIdByCdn(@Param("uid") String uid, @Param("protype") String protype, @Param("subtype") String subtype);

    public void modifyLeaderAndTeam(@Param("uid") String uid, @Param("tid") String tid, @Param("pid") String pid);

    public void myDelete(String id);


    public ProModel getByProInsId(String proInsId);

    Page<ProModel> getPromodelList(ProModel proModel);

    public void updateResult(@Param("result") String result, @Param("pid") String promodelid);

    int getProModelAuditListCount(ProModel proModel);


    public ProModel getProScoreConfigure(String proId);

    /**
     * 根据leaderId获取我的项目.
     *
     * @param leaderId 团队负责人
     * @return List
     */
    public List<ProModel> findListByLeader(@Param("uid") String uid);

    /**
     * 根据leaderId获取我的项目和大赛.
     *
     * @param leaderId 团队负责人
     * @return List
     */
    public List<ProModel> findListAllByLeader(@Param("uid") String uid);

    void updateState(@Param("state") String state, @Param("id") String id);

    List<ProModel> findListByIds(ProModel proModel);
    List<ProModel> findListByIdsUnAudit(ProModel proModel);

    List<ProModel> findIsOverHaveData(@Param("actYwId") String actYwId, @Param("state") String state);

    List<ProModel> findIsHaveData(@Param("actYwId") String actYwId);

    List<ProModel> getListByGroupId(@Param("groupId") String groupId);

    List<ProModel> findListByIdsWithoutJoin(ProModel proModel);

    List<ProModel> findImportList(ProModel proModel);

	void deleteTeamUserHisByProModelId(@Param("id") String id);

 	void deleteReportByProModelId(@Param("id") String id);

//    List<ExpProModelVo> export(ProModel proModel);

	void updateFinalStatus(@Param("id") String id, @Param("finalStatus")String finalStatus);

	void updateFinalStatusPl(@Param("idsList")List<String> idsList, @Param("finalStatus")String finalStatus);

	ProModel getExcellentById(String id);

	ProModel getGcontestExcellentById(String id);
}