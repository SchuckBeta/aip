package com.oseasy.initiate.dao.user;

import javax.annotation.Resource;

import org.testng.annotations.Test;

import com.github.springtestdbunit.annotation.DatabaseSetup;
import com.github.springtestdbunit.annotation.ExpectedDatabase;
import com.oseasy.initiate.dao.BaseDaoTest;
import com.oseasy.pcore.modules.sys.dao.UserDao;

public class UserMapperDbUnitTest extends BaseDaoTest {


    @Resource
    private UserDao userDao;

    /**
     * 运行没有初始化数据
     * @throws Exception
     */
    @Test
    public void testNotExits() throws Exception {
//        User user = userDao.queryByUserName("admin2");
//        System.out.println(user);
//        assertNull(user);
    }

    /**
     * 额外初始化数据集
     *
     * @throws Exception
     */
    @Test
    @DatabaseSetup("/dao/user/Users.xml")
    public void testExits() throws Exception {
//        User user = userDao.queryByUserName("admin2");
//        System.out.println(user);
//        assertNotNull(user);
//        user.setAge(99);
//        assertEquals(userDao.update(user), 1);
//        user = userDao.queryByUserName("admin2");
//        assertTrue(99 == user.getAge());
    }

    /**
     * DatabaseSetup初始化数据集，操作delete admin2，期望的数据集ExpectedDatabase
     *
     * @throws Exception
     */
    @Test
    @DatabaseSetup("/dao/user/Users.xml")
    @ExpectedDatabase("/dao/user/left.xml")
    public void testRemove() throws Exception {
//        this.userDao.delete("admin2");
    }


    @Test
    @DatabaseSetup("/dao/user/Users.xml")
    @ExpectedDatabase("/dao/user/Users2.xml")
    public void testInsert() throws Exception {
//        userDao.create(new User("admin3", "admin3", 3));
    }

    /**
     * datasetup 会初始化数据admin2，所以在插入数据会报主键冲突
     */
    @Test(expectedExceptions = Exception.class)
    @DatabaseSetup("/dao/user/Users.xml")
    public void test() {
//        userDao.create(new User("admin2", "admin2", 1));
    }
}