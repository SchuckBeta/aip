package com.oseasy.initiate.dao.user;

import javax.annotation.Resource;

import org.springframework.transaction.annotation.Transactional;
import org.testng.annotations.Test;

import com.oseasy.initiate.dao.BaseDaoTest;
import com.oseasy.pcore.modules.sys.dao.UserDao;
import com.oseasy.pcore.modules.sys.entity.User;

public class UserDaoTest extends BaseDaoTest {

    @Resource
    private UserDao userDao;


    @Test(expectedExceptions = Exception.class)
    public void test() {
        User user = userDao.get("044a5808fb64470185db4fc4d3a85ad8");
        System.out.println(user.getName());
//        userDao.create(new User("admin", "admin", 1));
    }

    @Test
    @Transactional
    public void testUpdate() throws Exception {
//        User user = userDao.queryByUserName("admin");
//        user.setAge(99);
//        assertEquals(userDao.update(user), 1);
    }


    @Test
    public void testGetUser() throws Exception {
//        assertNotNull(userDao.query("admin", "admin"));
    }

    @Test
    public void testCreate() throws Exception {
//        User user = new User("yxz", "yxz", 1);
//        assertEquals(userDao.create(user), 1);
    }

    @Test
    public void testQuery() throws Exception {
//        User user = new User("yxz", "yxz", 1);
//        assertEquals(userDao.create(user), 1);
//        assertNotNull(userDao.query("yxz", "yxz"));
//        assertEquals(userDao.delete("yxz"), 1);
    }

    @Test(dependsOnMethods = "testCreate")
    public void testGetAllUsers() throws Exception {
//        assertTrue(userDao.getAllUsers().size() == 2);
    }


    @Test(dependsOnMethods = "testCreate")
    public void testDelete() throws Exception {
//        assertEquals(userDao.delete("yxz"), 1);
    }


}