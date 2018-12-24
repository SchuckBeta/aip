package com.oseasy.initiate.test;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Created by Administrator on 2017/3/11.
 */
@RunWith(SpringJUnit4ClassRunner.class) 
@ContextConfiguration(locations = "classpath*:/spring-context*.xml")
public class RuleTest {

    public static void main(String[] args )  throws ParseException {

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date graduation=sdf.parse("2014-6-3");

            Date date=new Date();
            long day=(date.getTime()-graduation.getTime())/(24*60*60*1000) + 1;
            String year=new DecimalFormat("#").format(day/365f);
            System.out.println(year);



        }
    }


