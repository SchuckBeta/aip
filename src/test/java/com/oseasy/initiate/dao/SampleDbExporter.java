package com.oseasy.initiate.dao;

import org.testng.annotations.Test;

/**
 * 导出数据
 */
public class SampleDbExporter extends AbstractDbBaseExporter {
    @Test
    public void exportUser() throws Exception {
        exportDataSet("Userss");
    }

    @Test
    public void exportUser2() throws Exception {
//        exportDataSet("Users", "user_data.xml");
    }
}
