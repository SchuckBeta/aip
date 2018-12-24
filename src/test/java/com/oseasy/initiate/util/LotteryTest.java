package com.oseasy.initiate.util;

import com.google.common.collect.Lists;

import java.util.ArrayList;
import java.util.List;

public class LotteryTest {


    public static void main(String[] args) {
        //step .0 模拟数据
        ArrayList specList = LotteryUtil.mockspecTotal(); //模拟 专家集合
        // 模拟 参数设置
        int speciaNum = 5; //参与评审专家数
        int gradeSpeEachTotal = 2;//每个项目需要多少个专家打分
        int gradeCancelTotal = 2;// 每组专家不能同时审核多少个项目  【默认为-1  未设置限制】
        int proTotal = 100; //项目总数

        //step .1  抽取参与评审的专家集合
        ArrayList takeSpecs = LotteryUtil.getListByShuffle(specList, speciaNum); //抽取参与评审的专家，抽一次就应该存起来。
        System.out.println(takeSpecs);

        for (int n = 0; n < proTotal; n++) {//开始分配项目给专家打分。每个项目抽gradeSpeEachTotal个专家
            ////step .2   分配专家
            ArrayList result = LotteryUtil.getArrayList(gradeSpeEachTotal, gradeCancelTotal, takeSpecs, n+"");
        }//end for

        // //step .3  验证    打印项目分配专家的情况   （排序是为了更好的查看抽取的结果是否符合要求）
        LotteryUtil.sortSpecsList(LotteryUtil.sortList);
        System.out.println(  LotteryUtil.sortList.size()+ " 验证：\n\n "+LotteryUtil.sortList);
    }

}
