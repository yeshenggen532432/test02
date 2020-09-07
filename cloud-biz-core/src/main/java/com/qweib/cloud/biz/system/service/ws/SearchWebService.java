package com.qweib.cloud.biz.system.service.ws;


import com.qweib.cloud.core.domain.SearchModel;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.ws.SearchWebDao;
import com.qweib.cloud.repository.ws.BscEmpGroupWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
public class SearchWebService {
    @Resource
    private SearchWebDao searchWebDao;
    @Resource
    private BscEmpGroupWebDao empGroupWebDao;

    /**
     * 查询公共平台上人员和公司
     *
     * @param searchContent
     * @return
     * @创建：作者:YYP 创建时间：2015-3-9
     */
    public List<SearchModel> queryMemOrCompany(String searchContent, Integer memId) {
        List<SearchModel> list = new ArrayList<SearchModel>();
        try {
            List<SearchModel> aList = searchWebDao.queryMemOrCompany(searchContent, memId);//人员和公司
            list.addAll(aList);
            return list;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 有所属企业的人员查询
     *
     * @param database
     * @param searchContent
     * @return
     * @创建：作者:YYP 创建时间：2015-3-9
     */
    public List<SearchModel> querySearch(String database, String searchContent, Integer memId) {
        List<SearchModel> list = new ArrayList<SearchModel>();
        try {
            List<SearchModel> memList = searchWebDao.querypMem(searchContent, memId);//人员
            List<SearchModel> deptList = searchWebDao.querycDept(searchContent, database);//部门
            if (deptList.size() != 0) {
                for (SearchModel searchModel : deptList) {
                    Integer whetherIn = searchWebDao.queryIfIndept(searchModel.getHeadUrl(), memId, database);
                    searchModel.setWhetherIn(whetherIn);
                    searchModel.setHeadUrl(null);
                }
            }
            List<SearchModel> olist = empGroupWebDao.querySearch(searchContent, memId, database);//员工圈搜索
            list.addAll(memList);
            list.addAll(deptList);
            list.addAll(olist);
            return list;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

}
