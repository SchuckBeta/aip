/**
 * .
 */

package com.oseasy.initiate.data.actyw;

import java.util.ArrayList;
import java.util.List;

import com.oseasy.initiate.data.BaseDataProvider;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.putil.common.utils.CvsUtils;
import com.oseasy.putil.common.utils.FileUtil;

/**
 * 获取 ActYwGnode 数据.
 * @author chenhao
 */
public class ActYwGnodeDataProvider implements BaseDataProvider<ActYwGnode>{
    /**
     * 数据文件路径.
     */
    private static final String SERVICE_ACTYW_GNODE_JSON = "/service/actyw/act_yw_gnode.json";
    private static final String SERVICE_ACTYW_GNODE_CVS = "/service/actyw/act_yw_gnode.cvs";
    private static ActYwGnodeDataProvider provider =  new ActYwGnodeDataProvider();

    private ActYwGnodeDataProvider() {
        super();
    }

    public static List<ActYwGnode> getJsonData() {
        return provider.getDataByJson();
    }

    public static List<ActYwGnode> getCvsData() {
        return provider.getDataByCvs();
    }

    public static List<ActYwGnode> getData() {
        return provider.getDatas();
    }

    @Override
    public List<ActYwGnode> getDatas() {
        List<ActYwGnode> datas = new ArrayList<ActYwGnode>();
        datas.add(new ActYwGnode());
        datas.add(new ActYwGnode());
        datas.add(new ActYwGnode());
        datas.add(new ActYwGnode());
        datas.add(new ActYwGnode());
        datas.add(new ActYwGnode());
        datas.add(new ActYwGnode());
        return datas;
    }

    @Override
    public List<ActYwGnode> getDataByJson(String datafile) {
        ActYwGnodeTable tb = new ActYwGnodeTable();
        return tb.convert(tb.getRecords(ActYwGnodeTable.class, datafile));
    }

    @Override
    public List<ActYwGnode> getDataByJson() {
        return getDataByJson(FileUtil.getClassPath(SERVICE_ACTYW_GNODE_JSON));
    }

    @Override
    public List<ActYwGnode> getDataByCvs(String datafile) {
        List<ActYwGnode> datas = new ArrayList<ActYwGnode>();
        List<String[]> list =  CvsUtils.readAll(datafile);
        for (int i = 0; i < list.size(); i++) {
            ActYwGnode cur = new ActYwGnode();
            String[] strings = list.get(i);
            if ((strings != null) && (strings.length >= 1)) {
                cur.setId(strings[0]);
            }
            datas.add(cur);
        }
        return datas;
    }

    @Override
    public List<ActYwGnode> getDataByCvs() {
        return getDataByCvs(FileUtil.getClassPath(SERVICE_ACTYW_GNODE_CVS));
    }
}
