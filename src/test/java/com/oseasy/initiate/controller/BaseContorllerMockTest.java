package com.oseasy.initiate.controller;

//import org.springframework.mock.web.MockHttpServletRequest;
//import org.springframework.mock.web.MockHttpServletResponse;
//import org.springframework.mock.web.MockHttpSession;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
//import org.testng.annotations.BeforeMethod;
//
//import java.util.Hashtable;
//import java.util.Map;
//
//@ContextConfiguration(locations = {
//        "classpath:service/mockservice.xml",
//        "classpath:dispatcher-servlet.xml",
//})
//public abstract class BaseContorllerMockTest extends AbstractTestNGSpringContextTests {
//
//    protected MockHttpServletRequest request;
//    protected MockHttpServletResponse response;
//
//    protected Map<Object, Object> sessionMap;
//    protected MockHttpSession session;
//
//    @BeforeMethod
//    public void beforeMethod() {
//        request = new MockHttpServletRequest();
//        response = new MockHttpServletResponse();
//        sessionMap = new Hashtable<Object, Object>();
//        session = new MockHttpSession();
//        request.setSession(session);
//    }
//}
