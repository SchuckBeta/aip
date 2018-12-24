package com.oseasy.initiate.util;

import org.codehaus.groovy.ast.tools.GeneralUtils;

import com.oseasy.pcore.common.utils.IdGen;

import java.io.*;
import java.util.Arrays;
import java.util.List;
import java.io.*;
import java.util.Arrays;
import java.util.List;

public class sqlUtil {

    public static void main(String[] args) throws Exception {
        String sql = "INSERT INTO `sys_dict` (`id`, `value`, `label`, `type`, `description`, `sort`, `parent_id`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`, `is_sys`) VALUES ('${id}', '${value}', '${lable}', 'postTitle_type', '职称类型', '${value}', 'e9dea40400a145558b95d85fe79481c6', '1', '2017-03-31 20:25:00', '1', '2017-06-08 16:35:19', '', '0', '1');";
        try {
            String fileName =System.getProperty("user.dir") +"\\src\\test\\java\\com\\oseasy\\initiate\\util\\3.txt";
            File filename = new File(fileName);
            InputStreamReader reader = new InputStreamReader(new FileInputStream(filename)); // 建立一个输入流对象reader
            BufferedReader br = new BufferedReader(reader);
            String line = "";
            line = br.readLine();
            int i = 0;
            while (line != null) {
                line = br.readLine(); // 一次读入一行数据
                if (line == null) {
                    break;
                }
//                System.out.println(line);
                String[] ids = line.split(",");
                List<String> datas = Arrays.asList(ids);

                final int finalI = i;
                datas.forEach((String s) -> {
                    String n=String.valueOf(finalI);
                    String temp = sql.replace("${id}", IdGen.uuid())
                            .replace("${value}", n)
                            .replace("${lable}", s);
                    System.out.println(temp);
                });
                i++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
