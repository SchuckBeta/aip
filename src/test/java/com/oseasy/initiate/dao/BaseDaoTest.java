package com.oseasy.initiate.dao;

import com.github.springtestdbunit.DbUnitTestExecutionListener;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.context.support.DependencyInjectionTestExecutionListener;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;


@ActiveProfiles("dev")
@ContextConfiguration(locations = {
        "classpath:dao/spring-context-tdatasource-prod.xml"
        ,"classpath:dao/spring-context-tdatasource-dev.xml"
        ,"classpath:dao/spring-context-tdatasource.xml"
        ,"classpath:dao/spring-context-tinit-data.xml"
})
@TestExecutionListeners({DependencyInjectionTestExecutionListener.class, DbUnitTestExecutionListener.class})
public abstract class BaseDaoTest extends AbstractTestNGSpringContextTests {

}
