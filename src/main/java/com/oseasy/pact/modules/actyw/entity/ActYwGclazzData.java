package com.oseasy.pact.modules.actyw.entity;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import com.google.common.collect.Lists;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 监听数据Entity.
 * @author chenh
 * @version 2018-03-08
 */
public class ActYwGclazzData extends DataEntity<ActYwGclazzData> {

	private static final long serialVersionUID = 1L;
    private String applyId;     // 申报ID
    private String type;     // 监听类型:ClazzThemeListener.key
	private ActYwGclazz gclazz;		// 监听ID
	private Boolean isStart;		// 是否为第一次触发监听生成的数据
	private String datas;		// 传递数据Json

	public ActYwGclazzData() {
		super();
	}

	public ActYwGclazzData(String id){
		super(id);
	}

	public ActYwGclazzData(String applyId, String type){
	    this.applyId = applyId;
	    this.type = type;
	}

	public ActYwGclazzData(String applyId, String type, String gnodeId){
	    this.applyId = applyId;
	    this.type = type;
	    this.gclazz = new ActYwGclazz(new ActYwGnode(gnodeId));
	}

	public ActYwGclazzData(String applyId, String type, ActYwGclazz gclazz, Boolean isStart, String datas) {
        super();
        this.applyId = applyId;
        this.type = type;
        this.gclazz = gclazz;
        this.isStart = isStart;
        this.datas = datas;
    }

    @Length(min=0, max=64, message="申报ID长度必须介于 0 和 64 之间")
	public String getApplyId() {
		return applyId;
	}

	public void setApplyId(String applyId) {
		this.applyId = applyId;
	}

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public ActYwGclazz getGclazz() {
        return gclazz;
    }

    public void setGclazz(ActYwGclazz gclazz) {
        this.gclazz = gclazz;
    }

    public Boolean getIsStart() {
        return isStart;
    }

    public void setIsStart(Boolean isStart) {
        this.isStart = isStart;
    }

    public String getDatas() {
		return datas;
	}

	public void setDatas(String datas) {
		this.datas = datas;
	}

    /**
     * 根据申报ID，节点ID获取结果.
     * @param actYwGclazzData
     * @param applyId 申报ID
     * @param gnodeId 节点ID
     * @return List
     */
	public static List<ActYwGclazzData> filterByGnode(List<ActYwGclazzData> actYwGclazzData, String applyId, String gnodeId) {
	    List<ActYwGclazzData> gclazzDatas = Lists.newArrayList();
	    for (ActYwGclazzData gclazzData : actYwGclazzData) {
            if(gclazzData.getGclazz() != null){
                continue;
            }
            if(gclazzData.getGclazz().getGnode() != null){
                continue;
            }
            if(StringUtil.isEmpty(gnodeId) || StringUtil.isEmpty(gclazzData.getGclazz().getGnode().getId())){
                continue;
            }
            if(StringUtil.isEmpty(applyId) || StringUtil.isEmpty(gclazzData.getApplyId())){
                continue;
            }

            if((applyId).equals(gclazzData.getApplyId()) && (gnodeId).equals(gclazzData.getGclazz().getGnode().getId())){
                gclazzDatas.add(gclazzData);
            }
        }
	    return gclazzDatas;
	}

	/**
	 * 根据申报ID，申报类型获取结果.
	 * @param actYwGclazzData
	 * @param applyId 申报ID
	 * @param gnodeId 节点ID
	 * @return List
	 */
	public static List<ActYwGclazzData> filterByType(List<ActYwGclazzData> actYwGclazzData, String applyId, String gnodeId) {
	    List<ActYwGclazzData> gclazzDatas = Lists.newArrayList();
	    for (ActYwGclazzData gclazzData : actYwGclazzData) {
	        if(gclazzData.getGclazz() != null){
	            continue;
	        }
	        if(gclazzData.getGclazz().getGnode() != null){
	            continue;
	        }
	        if(StringUtil.isEmpty(gnodeId) || StringUtil.isEmpty(gclazzData.getGclazz().getGnode().getId())){
	            continue;
	        }
	        if(StringUtil.isEmpty(applyId) || StringUtil.isEmpty(gclazzData.getApplyId())){
	            continue;
	        }

	        if((applyId).equals(gclazzData.getApplyId()) && (gnodeId).equals(gclazzData.getGclazz().getGnode().getId())){
	            gclazzDatas.add(gclazzData);
	        }
	    }
	    return gclazzDatas;
	}

	/**
	 * 根据申报ID，节点ID，申报类型获取结果.
	 * @param actYwGclazzData
	 * @param applyId 申报ID
     * @param type 申报类型
	 * @param gnodeId 节点ID
	 * @return ActYwGclazzData
	 */
	public static ActYwGclazzData filter(List<ActYwGclazzData> actYwGclazzData, String applyId, String type, String gnodeId) {
	    for (ActYwGclazzData gclazzData : actYwGclazzData) {
	        if((gclazzData.getGclazz() == null) || StringUtil.isEmpty(gclazzData.getGclazz().getId())){
	            continue;
	        }
	        if(gclazzData.getGclazz().getGnode() == null){
	            continue;
	        }
	        if(StringUtil.isEmpty(gnodeId) || StringUtil.isEmpty(gclazzData.getGclazz().getGnode().getId())){
	            continue;
	        }
	        if(StringUtil.isEmpty(type) || StringUtil.isEmpty(gclazzData.getType())){
	            continue;
	        }
	        if(StringUtil.isEmpty(applyId) || StringUtil.isEmpty(gclazzData.getApplyId())){
	            continue;
	        }

	        if((applyId).equals(gclazzData.getApplyId()) && (gnodeId).equals(gclazzData.getGclazz().getGnode().getId()) && (type).equals(gclazzData.getType())){
	            return gclazzData;
	        }
	    }
	    return null;
	}
}