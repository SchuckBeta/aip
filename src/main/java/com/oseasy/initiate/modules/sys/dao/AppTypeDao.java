package com.oseasy.initiate.modules.sys.dao;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.putil.common.utils.Tree;

import java.util.List;
import java.util.Map;


@MyBatisDao
public interface AppTypeDao extends CrudDao<Tree> {

    List<Tree> getAppTypeList(Map<String, Object> params);
}