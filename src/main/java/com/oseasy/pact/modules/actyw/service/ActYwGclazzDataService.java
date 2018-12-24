package com.oseasy.pact.modules.actyw.service;

import java.util.List;

import com.oseasy.pact.modules.actyw.dao.ActYwGclazzDataDao;
import com.oseasy.pact.modules.actyw.entity.ActYwGclazzData;
import com.oseasy.pact.modules.actyw.tool.process.vo.ClazzThemeListener;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;

/**
 * 监听数据Service.
 * @author chenh
 * @version 2018-03-08
 */
@Service
@Transactional(readOnly = true)
public class ActYwGclazzDataService extends CrudService<ActYwGclazzDataDao, ActYwGclazzData> {
    private static Logger logger = LoggerFactory.getLogger(ActYwGclazzDataService.class);

	public ActYwGclazzData get(String id) {
		return super.get(id);
	}

    /**
     * 获取开始
     * @param id
     * @return ActYwGclazzData
     */
    public ActYwGclazzData getStart(String applyId, String type){
        return dao.getStart(applyId, type);
    }

	public List<ActYwGclazzData> findList(ActYwGclazzData actYwGclazzData) {
		return super.findList(actYwGclazzData);
	}

	public Page<ActYwGclazzData> findPage(Page<ActYwGclazzData> page, ActYwGclazzData actYwGclazzData) {
		return super.findPage(page, actYwGclazzData);
	}

    /**
     * 根据申报ID和节点ID查询数据列表
     * @param entity
     * @return List
     */
	public List<ActYwGclazzData> findListByAgnode(String applyId, String gnodeId, ActYwGclazzData entity) {
	    return dao.findListByAgnode(applyId, gnodeId, entity);
	}

    /**
     * 根据申报ID和节点ID查询数据列表，如果需要分页，请设置分页对象，如：entity.setPage(new Page<T>());
     * @param entity
     * @return Page
     */
	public Page<ActYwGclazzData> findPageByAgnode(Page<ActYwGclazzData> page, String applyId, String gnodeId, ActYwGclazzData entity) {
	    entity.setPage(page);
        page.setList(findListByAgnode(applyId, gnodeId, entity));
        return page;
	}

	@Transactional(readOnly = false)
	public void save(ActYwGclazzData actYwGclazzData) {
		super.save(actYwGclazzData);
	}

	@Transactional(readOnly = false)
	public void savePl(List<ActYwGclazzData> entitys) {
	    dao.savePl(entitys);
	}

	@Transactional(readOnly = false)
	public void delete(ActYwGclazzData actYwGclazzData) {
		super.delete(actYwGclazzData);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(ActYwGclazzData actYwGclazzData) {
  	  dao.deleteWL(actYwGclazzData);
  	}

  	@Transactional(readOnly = false)
  	public void deleteWLPL(List<String> ids) {
  	    dao.deleteWLPL(ids);
  	}

    /**
     * 根据申报ID物理删除.
     * @param entity
     */
  	@Transactional(readOnly = false)
  	public void deleteWLPLByApply(String applyId) {
  	    dao.deleteWLPLByApply(applyId);
  	}

    /**
     * 根据节点监听ID物理删除.
     * @param entity
     */
  	@Transactional(readOnly = false)
  	public void deleteWLPLByGzlazz(String gclazzId) {
  	    dao.deleteWLPLByGzlazz(gclazzId);
  	}

  	/**
  	 * 根据监听类ID物理删除.
  	 * @param entity
  	 */
  	@Transactional(readOnly = false)
  	public void deleteWLPLByClazz(String clazzId) {
  	    dao.deleteWLPLByClazz(clazzId);
  	}

    /**
     * 根据申报ID和节点ID物理删除.
     * @param entity
     */
    @Transactional(readOnly = false)
    public void deleteWLPLByAgnode(String applyId, String gnodeId) {
  	    dao.deleteWLPLByAgnode(applyId, gnodeId);
  	}


    /*************************************************************************************************************
     * 从存储对象中获取指定gnodeId传递数据,返回结果为Null表示当前结点是存储节点 .
     * @param applyId 申报ID
     * @param gnodeId 节点
     * @param gcData 保存参数
     * @return List
     */
    public List<ActYwGclazzData> getDatas(String applyId, String gnodeId, ActYwGclazzData gcData) {
        return ActYwGclazzData.filterByGnode(findListByAgnode(applyId, gnodeId, gcData), applyId, gnodeId);
    }

    /**
     * 从存储对象中获取指定gnodeId传递数据,返回结果为Null表示当前结点是存储节点 .
     * @param applyId 申报ID
     * @param type 类型
     * @param gnodeId 节点
     * @param gcData 保存参数
     * @return ActYwGclazzData
     */
    public ActYwGclazzData getData(String applyId, String type, String gnodeId, ActYwGclazzData gcData) {
        return ActYwGclazzData.filter(findListByAgnode(applyId, gnodeId, gcData), applyId, type, gnodeId);
    }

    /**
     * 更新存储对象中传递数据,如果不存在，则Start标志为true,否则为false.
     * @param gcData 保存参数
     * @param isStart 检查是否为开始参数
     * @return ActYwGclazzData
     */
    @Transactional(readOnly = false)
    public ActYwGclazzData putData(ActYwGclazzData gcData, Boolean isStart) {
        if(StringUtil.isEmpty(gcData.getApplyId())){
            logger.warn("参数申报标识不能为空");
            return null;
        }
        if(StringUtil.isEmpty(gcData.getType())){
            logger.warn("参数申报类型不能为空");
            return null;
        }
        if((gcData.getGclazz() == null) || StringUtil.isEmpty(gcData.getGclazz().getId())){
            logger.warn("参数监听不能为空");
            return null;
        }

        gcData.setIsStart(isStart);
        save(gcData);
        return gcData;
    }

    /**
     * 更新存储对象中传递数据,如果不存在，则Start标志为true,否则为false.
     * @param applyId 申报ID
     * @param type 类型
     * @param gcData 保存参数
     * @return ActYwGclazzData
     */
    @Transactional(readOnly = false)
    public ActYwGclazzData putData(String applyId, String type, ActYwGclazzData gcData) {
        if(StringUtil.checkEmpty(findList(new ActYwGclazzData(applyId, type)))){
            gcData.setIsStart(true);
        }else{
            gcData.setIsStart(false);
        }
        return putData(gcData, gcData.getIsStart());
    }

    /**
     * 更新存储对象中传递数据,如果不存在，则Start标志为true,否则为false.
     * @param applyId 申报ID
     * @param gcData 保存参数
     * @return List
     */
    @Transactional(readOnly = false)
    public List<ActYwGclazzData> putDatas(String applyId, List<ActYwGclazzData> gcDatas) {
        List<String> gcdIds = Lists.newArrayList();
        List<String> types = Lists.newArrayList();
        ActYwGclazzData gclazzData = new ActYwGclazzData();
        gclazzData.setApplyId(applyId);
        List<ActYwGclazzData> gclazzDatas = findList(gclazzData);
        for (ActYwGclazzData curGzdata : gcDatas) {
            gcdIds.add(curGzdata.getId());
            if(types.contains(curGzdata.getType())){
                curGzdata.setIsStart(false);
                continue;
            }

            if(StringUtil.checkEmpty(ActYwGclazzData.filterByType(gclazzDatas, curGzdata.getApplyId(), curGzdata.getType()))){
                curGzdata.setIsStart(true);
                types.add(curGzdata.getType());
            }else{
                curGzdata.setIsStart(false);
            }
        }

        deleteWLPL(gcdIds);
        savePl(gcDatas);
        return gcDatas;
    }

	public ActYwGclazzData getStartData(String id,String type) {
		ActYwGclazzData start = getStart(id, type);
		if(start!=null){
			ActYwGclazzData claszzData = getData(id,type, start.getGclazz().getGnode().getId(), null);
			return claszzData;
		}else{
			return null;
		}

	}
}