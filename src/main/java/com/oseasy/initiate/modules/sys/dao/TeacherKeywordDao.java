package com.oseasy.initiate.modules.sys.dao;

import com.oseasy.initiate.modules.sys.entity.TeacherKeyword;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

import java.util.List;

/**
 * teacherKeywordDAO接口.
 * @author zy
 * @version 2017-07-03
 */
@MyBatisDao
public interface TeacherKeywordDao extends CrudDao<TeacherKeyword> {
    public void delByTeacherid(String teacherId);

    public List<TeacherKeyword> findByTeacherid(String teacherId);
    public List<String> findStringByTeacherid(String teacherId);
}