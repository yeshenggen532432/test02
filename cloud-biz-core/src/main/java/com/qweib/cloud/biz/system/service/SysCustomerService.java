package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.common.CommonUtil;
import com.qweib.cloud.biz.common.ValidationBeanUtil;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportResults;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportSysCustomerVo;
import com.qweib.cloud.biz.system.service.address.AddressLatLngService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.utils.ProgressUtil;
import com.qweib.cloud.biz.system.utils.RegionExecutor;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.customer.BaseCustomer;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.memberEvent.MemberPublisher;
import com.qweib.cloud.repository.*;
import com.qweib.cloud.repository.company.SysDeptmempowerDao;
import com.qweib.cloud.repository.plat.ShopMemberCompanyDao;
import com.qweib.cloud.repository.plat.SysCorporationDao;
import com.qweib.cloud.repository.plat.SysMemberDao;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.repository.ws.SysDepartDao;
import com.qweib.cloud.utils.*;
import com.qweib.cloud.utils.annotation.DataSourceAnnotation;
import com.qweib.commons.DateUtils;
import com.qweib.commons.StringUtils;
import com.qweibframework.async.handler.AsyncProcessHandler;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

@Service
public class SysCustomerService {
    @Resource
    private SysCustomerDao customerDao;
    @Resource
    private SysDepartDao departDao;
    @Resource
    private SysDeptmempowerDao deptmempowerDao;
    @Resource
    private SysMemberWebDao memberWebDao;
    @Autowired
    private SysCustomerPicDao customerPicDao;
    @Resource
    private SysMemberDao memberDao;
    @Resource
    private ShopMemberCompanyDao shopMemberCompanyDao;
    @Resource
    private SysCorporationDao corporationDao;

    @Resource
    private SysCustomerLevelPriceDao customerLevelPriceDao;
    @Resource
    private SysQdTypePriceDao qdTypePriceDao;
    @Resource
    private SysKhlevelDao khlevelDao;
    @Resource
    private SysQdtypeDao qdtypeDao;
    @Resource
    private SysQdTypeRateDao qdTypeRateDao;
    @Resource
    private SysCustomerLevelRateDao customerLevelRateDao;
    @Resource
    private SysWaretypeDao waretypeDao;
    @Resource
    private SysInportTempService sysInportTempService;
    @Resource
    private AsyncProcessHandler asyncProcessHandler;
    @Resource
    private SysMemberService memberService;
    @Autowired
    private Mapper mapper;
    @Autowired
    private MemberPublisher memberPublisher;
    @Resource
    private SysRegionService sysRegionService;
    @Resource
    private SysConfigService configService;
    @Resource
    private AddressLatLngService addressLatLngService;

    /**
     * 说明：分页查询客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public Page queryCustomer(SysCustomer customer, String dataTp, SysLoginInfo info, Integer page, Integer limit) {
        try {
            String datasource = info.getDatasource();
            Integer memberId = info.getIdKey();
            String depts = "";//部门
            String visibleDepts = "";//可见部门
            String invisibleDepts = "";//不可见部门
            Integer mId = null;//是否个人
            if ("1".equals(dataTp)) {//查询全部部门
                Map<String, Object> allDeptsMap = departDao.queryAllDeptsForMap(datasource);
                if (null != allDeptsMap && !StrUtil.isNull(allDeptsMap.get("depts"))) {//不为空
                    depts = (String) allDeptsMap.get("depts");
                }
            } else if ("2".equals(dataTp)) {//部门及子部门
                Map<String, Object> map = departDao.queryBottomDepts(memberId, datasource);
                if (null != map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
                    String dpt = (String) map.get("depts");
                    depts = dpt.substring(0, dpt.length() - 1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
                }
            } else if ("3".equals(dataTp)) {//个人
                mId = memberId;
            }
            //查询可见部门(如：-4-，-7-4-)
            visibleDepts = getPowerDepts(datasource, memberId, "1", visibleDepts);
            //查询不可见部门
            invisibleDepts = getPowerDepts(datasource, memberId, "2", invisibleDepts);
            String allDepts = StrUtil.addStr(depts, visibleDepts);//整合要查询的部门和可见部门
            return this.customerDao.queryCustomer(customer, dataTp, mId, allDepts, invisibleDepts, page, limit);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServiceException(e);
        }
    }

    public List<SysCustomer> queryCustomerList(SysCustomer customer, String dataTp, SysLoginInfo info) {
        try {
            String datasource = info.getDatasource();
            Integer memberId = info.getIdKey();
            String depts = "";//部门
            String visibleDepts = "";//可见部门
            String invisibleDepts = "";//不可见部门
            Integer mId = null;//是否个人
            if ("1".equals(dataTp)) {//查询全部部门
                Map<String, Object> allDeptsMap = departDao.queryAllDeptsForMap(datasource);
                if (null != allDeptsMap && !StrUtil.isNull(allDeptsMap.get("depts"))) {//不为空
                    depts = (String) allDeptsMap.get("depts");
                }
            } else if ("2".equals(dataTp)) {//部门及子部门
                Map<String, Object> map = departDao.queryBottomDepts(memberId, datasource);
                if (null != map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
                    String dpt = (String) map.get("depts");
                    depts = dpt.substring(0, dpt.length() - 1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
                }
            } else if ("3".equals(dataTp)) {//个人
                mId = memberId;
            }
            //查询可见部门(如：-4-，-7-4-)
            visibleDepts = getPowerDepts(datasource, memberId, "1", visibleDepts);
            //查询不可见部门
            invisibleDepts = getPowerDepts(datasource, memberId, "2", invisibleDepts);
            String allDepts = StrUtil.addStr(depts, visibleDepts);//整合要查询的部门和可见部门
            return this.customerDao.queryCustomerList(customer, mId, allDepts, invisibleDepts, info.getDatasource());
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int batchUpdateShopCustomerType(String ids, String qdtpNm, String khdjNm, Integer regionId, String database) {
        return this.customerDao.batchUpdateShopCustomerType(ids, qdtpNm, khdjNm, regionId, database);
    }

    public int batchUAddCustomer(String ids, Integer id, String database) {
        return this.customerDao.batchUAddCustomer(ids, id, database);
    }

    public int batchRemoveCustomerType(String ids, String database) {
        return this.customerDao.batchRemoveCustomerType(ids, database);
    }

    public int batchRemoveCustomerGrade(String ids, String database) {
        return this.customerDao.batchRemoveCustomerGrade(ids, database);
    }

    public int batchUpdateShopCustomerGrade(String ids, String qdtpNm, String khdjNm, String database) {
        return this.customerDao.batchUpdateShopCustomerGrade(ids, qdtpNm, khdjNm, database);
    }

    public int batchAddCustomerGrade(String ids, Integer id, String database) {
        return this.customerDao.batchAddCustomerGrade(ids, id, database);
    }

    public List<SysCustomer> queryCustomerList(SysCustomer customer, String database) {
        return this.customerDao.queryCustomerList(customer, database);
    }

    public Page queryCustomer2(SysCustomer customer, Integer page, Integer limit) {
        try {
            return this.customerDao.queryCustomer(customer, null, null, null, null, page, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page customerGradePage(SysCustomer customer, int page, int rows, String database, String qdtpNm, String khdjNm, Integer type) {
        try {
            return this.customerDao.customerGradePage(customer, page, rows, database, qdtpNm, khdjNm, type);
        } catch (Exception var9) {
            throw new ServiceException(var9);
        }
    }

    public Page queryNoneGradeCustomer(SysCustomer sysCustomer, int page, int rows, int qdId, String database) {
        try {
            return this.customerDao.queryNoneGradeCustomer(sysCustomer, page, rows, qdId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page queryCustomerByKhlevelId(SysCustomer sysCustomer, int page, int rows, int id, int qdId, String database) {
        try {
            return this.customerDao.queryCustomerByKhlevelId(sysCustomer, page, rows, id, qdId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page queryNoneTypedCustomer(SysCustomer sysCustomer, int page, int rows, String database) {
        try {
            return this.customerDao.queryNoneTypedCustomer(sysCustomer, page, rows, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    public Page queryCustomerByQdtypeId(SysCustomer sysCustomer, int page, int rows, int id, String database) {
        try {
            return this.customerDao.queryCustomerByQdtypeId(sysCustomer, page, rows, id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page page2(SysCustomer customer, int page, int rows, String database, String qdtpNm, Integer type, Integer[] regionId) {
        try {
            return this.customerDao.page2(customer, page, rows, database, qdtpNm, type, regionId);
        } catch (Exception var9) {
            throw new ServiceException(var9);
        }
    }


    public int queryQdtypeId(Integer id, String database) {
        try {
            return this.customerDao.queryQdtypeId(id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }

    public int queryKhleveId(Integer id, String database) {
        try {
            return this.customerDao.queryKhleveId(id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }

    public int queryShopId(Integer id, String database) {
        try {
            return this.customerDao.queryShopId(id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }

    //获取权限部门（可见或不可见）
    private String getPowerDepts(String datasource, Integer memberId, String tp,
                                 String visibleDepts) {
        Map<String, Object> visibleMap = deptmempowerDao.queryPowerDeptsByMemberId(memberId, tp, datasource);
        if (null != visibleMap && !StrUtil.isNull(visibleMap.get("depts"))) {//将查出来的格式（如：-4-，-7-4-）转换成逗号隔开（如：4,7，4）
            visibleDepts = visibleMap.get("depts").toString().replace("-,-", "-");
            visibleDepts = visibleDepts.substring(1, visibleDepts.length() - 1).replace("-", ",");
        }
        return visibleDepts;
    }

    /**
     * 说明：获取客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public SysCustomer queryCustomerById(String database, Integer Id) {
        try {
            SysCustomer sysCustomer = this.customerDao.queryCustomerById(database, Id);
            if (StrUtil.isNull(sysCustomer.getQdtpNm()) && !Objects.isNull(sysCustomer.getQdtypeId())) {
                SysQdtype sysQdtype = qdtypeDao.queryQdtypeById(sysCustomer.getQdtypeId(), database);
                sysCustomer.setQdtpNm(sysQdtype.getQdtpNm());
            }
            if (StrUtil.isNull(sysCustomer.getKhdjNm()) && !Objects.isNull(sysCustomer.getKhlevelId())) {
                SysKhlevel sysKhlevel = khlevelDao.querykhlevelById(sysCustomer.getKhlevelId(), database);
                sysCustomer.setKhdjNm(sysKhlevel.getKhdjNm());
            }
            if (sysCustomer != null) {
                SysCustomerPic scp = new SysCustomerPic();
                scp.setCustomerId(Id);
                List<SysCustomerPic> customerPicList = customerPicDao.queryCustomerPic(database, scp);
                if (customerPicList != null) {
                    sysCustomer.setCustomerPicList(customerPicList);
                }
            }
            return sysCustomer;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int queryRegionById(Integer id, String database) {
        try {
            return this.customerDao.queryRegionById(id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }

    public SysCustomer querySysCustomerById(Integer Id, String database) {
        try {
            return this.customerDao.querySysCustomerById(Id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：添加客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public int addCustomer(SysCustomer customer, String database) {
        Date openDate = DateUtils.parseDate(customer.getOpenDate());
        Date closeDate = DateUtils.parseDate(customer.getCloseDate());
        if (openDate != null && closeDate != null) {
            long open = openDate.getTime();
            long close = closeDate.getTime();
            if (open > close) {
                throw new BizException("开户日期大于闭户日期");
            }
        }
        customer.setPy(ChineseCharToEnUtil.getFirstSpell(customer.getKhNm()));
        this.customerDao.addCustomer(customer, database);
        int id = this.customerDao.getAutoId();
        if (StrUtil.isNull(customer.getKhCode())) {
            this.customerDao.updatekhCode(database, "x" + id, id);
        }
        //图片
        List<SysCustomerPic> picList = customer.getCustomerPicList();
        if (picList != null && picList.size() > 0) {
            for (int k = 0; k < picList.size(); k++) {
                picList.get(k).setCustomerId(id);
                this.customerPicDao.addCustomerPic(picList.get(k), database);
            }
        }
        return id;
    }

    /**
     * 说明：修改客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public int updateCustomer(SysCustomer customer, String database, String delPicIds, SysLoginInfo info) {
        try {
            if (!StrUtil.isNull(delPicIds)) {
                SysCustomerPic customerPic = new SysCustomerPic();
                customerPic.setCustomerId(customer.getId());
                List<SysCustomerPic> list = this.customerPicDao.queryCustomerPic(database, customerPic);
                if (list.size() > 0) {
                    FileUtil fileUtil = new FileUtil();
                    String path = CnlifeConstants.url() + "upload/customer/pic";
                    delPicIds = "," + delPicIds + ",";
                    for (int i = 0; i < list.size(); i++) {
                        String picId = "," + list.get(i).getId() + ",";
                        if (delPicIds.contains(picId)) {
                            String paths = path + list.get(i).getPicMini();
                            String picPath = path + list.get(i).getPic();
                            //删除图片
                            if (fileUtil.ifExist(paths)) {
                                FileUtil.deleteFile(paths);
                                FileUtil.deleteFile(picPath);
                            }
                            this.customerPicDao.deleteCustomerPic(database, list.get(i));
                        }
                    }
                }
            }
            List<SysCustomerPic> customerPicList = customer.getCustomerPicList();
            if (customerPicList != null) {
                if (customerPicList.size() > 0) {
                    for (int i = 0; i < customerPicList.size(); i++) {
                        customerPicList.get(i).setCustomerId(customer.getId());
                        this.customerPicDao.addCustomerPic(customerPicList.get(i), database);
                    }
                }
            }

            //如果客户状态有变动时，通知商城关联会员改为普通会员
            SysCustomer oldCustomer = querySysCustomerById(customer.getId(), database);
            if (!Objects.equals(oldCustomer.getIsDb(), customer.getIsDb()))
                memberPublisher.customerIsDbChange(customer.getId(), customer.getIsDb(), info);

            return this.customerDao.updateCustomer(customer, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：删除客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public int[] deleteCustomer(Integer[] ids, SysLoginInfo info) {
        if (ids != null && ids.length > 0) {
            //通知商城会员改为普通会员
            for (Integer id : ids) {
                memberPublisher.customerIsDbChange(id, 3, info);
            }
            return this.customerDao.deleteCustomer(ids, info.getDatasource());
        }
        return null;
    }

    /**
     * 说明：修改客户种类
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public void updatekhTp(String database, Integer khTp, Integer[] ids) {
        try {
            for (int i = 0; i < ids.length; i++) {
                this.customerDao.updatekhTp(database, khTp, ids[i]);
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：判断客户编码是否存在
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public int queryIskhCode(String database, String khCode) {
        try {
            return this.customerDao.queryIskhCode(database, khCode);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：审核操作
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 18)<修改说明>
     */
    public void updateShZt(String database, String shZt, Integer shMid, String shTime, Integer[] ids) {
        try {
            for (int i = 0; i < ids.length; i++) {
                this.customerDao.updateShZt(database, shZt, shMid, shTime, ids[i]);
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：判断客户名称是否存在
     *
     * @创建：作者:llp 创建时间：2016-3-1
     * @修改历史： [序号](llp 2016 - 3 - 1)<修改说明>
     */
    public int queryIskhNm(String database, String khNm, String city) {
        try {
            return this.customerDao.queryIskhNm(database, khNm, city);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：获取所有客户分布图
     *
     * @创建：作者:llp 创建时间：2016-4-5
     * @修改历史： [序号](llp 2016 - 4 - 5)<修改说明>
     */
    public List<SysCustomer> querycustomerMap(SysLoginInfo info, String khNm, String memberNm, String dataTp) {
        try {
            String datasource = info.getDatasource();
            Integer memberId = info.getIdKey();
            String depts = "";//部门
            String visibleDepts = "";//可见部门
            String invisibleDepts = "";//不可见部门
            Integer mId = null;//是否个人
            if ("1".equals(dataTp)) {//查询全部部门
                Map<String, Object> allDeptsMap = departDao.queryAllDeptsForMap(datasource);
                if (null != allDeptsMap && !StrUtil.isNull(allDeptsMap.get("depts"))) {//不为空
                    depts = (String) allDeptsMap.get("depts");
                }
            } else if ("2".equals(dataTp)) {//部门及子部门
                Map<String, Object> map = departDao.queryBottomDepts(memberId, datasource);
                if (null != map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
                    String dpt = (String) map.get("depts");
                    depts = dpt.substring(0, dpt.length() - 1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
                }
            } else if ("3".equals(dataTp)) {//个人
                mId = memberId;
            }
            //查询可见部门(如：-4-，-7-4-)
            visibleDepts = getPowerDepts(datasource, memberId, "1", visibleDepts);
            //查询不可见部门
            invisibleDepts = getPowerDepts(datasource, memberId, "2", invisibleDepts);
            String allDepts = StrUtil.addStr(depts, visibleDepts);//整合要查询的部门和可见部门
            return this.customerDao.querycustomerMap(datasource, khNm, memberNm, mId, allDepts, invisibleDepts);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：获取所有客户分布图Web
     *
     * @创建：作者:llp 创建时间：2016-7-22
     * @修改历史： [序号](llp 2016 - 7 - 22)<修改说明>
     */
    public List<SysCustomer> querycustomerWebMap(String database, String memIds) {
        try {
            return this.customerDao.querycustomerWebMap(database, memIds);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：修改客户是否倒闭
     *
     * @创建：作者:llp 创建时间：2016-7-20
     * @修改历史： [序号](llp 2016 - 7 - 20)<修改说明>
     */
    public void updatekhIsdb(String database, Integer isDb, Integer id, SysLoginInfo info) {
        try {
            this.customerDao.updatekhIsdb(database, isDb, id);
            //通知商城会员改为普通会员
            memberPublisher.customerIsDbChange(id, isDb, info);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    /**
     * 说明：根据手机号码获取成员条数
     *
     * @创建：作者:llp 创建时间：2015-2-3
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    public int querySysCustomerByTel(String database, String name) {
        try {
            return this.customerDao.querySysCustomerByTel(database, name);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysCustomer querySysCustomerByMobile(String database, String mobile) {
        return this.customerDao.querySysCustomerByMobile(database, mobile);
    }

    public SysCustomer querySysCustomerByName(String database, String name) {
        try {
            return this.customerDao.querySysCustomerByName(database, name);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：添加成员(excel导入)
     *
     * @创建：作者:llp 创建时间：2015-2-6
     * @修改历史： [序号](llp 2015 - 2 - 6)<修改说明>
     */
    @Deprecated
    public int addSysCustomerls(List<SysCustomer> Customerls, SysLoginInfo info) {
        try {
            this.customerDao.addSysCustomerls(info.getDatasource(), Customerls);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
        return 0;
    }

    /**
     * 说明：转让业代
     *
     * @创建：作者:llp 创建时间：2016-10-11
     * @修改历史： [序号](llp 2016 - 10 - 11)<修改说明>
     */
    public void updateZryd(String database, Integer Mid, Integer[] ids) {
        try {
            for (int i = 0; i < ids.length; i++) {
                SysMember member = this.memberDao.querySysMemberById1(database, Mid);
                this.customerDao.updateZryd(database, Mid, member.getBranchId(), ids[i]);
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateSysCustomerWarePrice(String database, SysCustomerWarePrice model) {
        return this.customerDao.updateSysCustomerWarePrice(database, model);
    }

    ;

    public List<SysCustomerWarePrice> listSysCustomerWarePrice(String database, Integer customerId) {
        return this.customerDao.listSysCustomerWarePrice(database, customerId);
    }

    ;

    public int updateSysCustomerSalePrice(String database, SysCustomerSalePrice model) {
        return this.customerDao.updateSysCustomerSalePrice(database, model);
    }

    ;

    public List<SysCustomerSalePrice> listSysCustomerSalePrice(String database, Integer customerId) {
        return this.customerDao.listSysCustomerSalePrice(database, customerId);
    }

    ;

    public int updateSysCustomerPrice(String database, SysCustomerPrice model) {
        return this.customerDao.updateSysCustomerPrice(database, model);
    }

    ;

    public int updateSysCustomerPrice(String database, Integer customerId, Integer wareId, Double price, String field) {
        SysCustomerPrice param = new SysCustomerPrice();
        param.setCustomerId(Integer.valueOf(customerId));
        param.setWareId(wareId);
        SysCustomerPrice sysCustomerPrice = customerDao.queryCustomerPrice(param, database);
        if (sysCustomerPrice == null) {
            sysCustomerPrice = new SysCustomerPrice();
            sysCustomerPrice.setWareId(wareId);
            sysCustomerPrice.setCustomerId(Integer.valueOf(customerId));
        }
        if ("wareDj".equals(field)) {
            if (StrUtil.isNull(price)) {
                price = 0.0;
            }
            sysCustomerPrice.setSaleAmt(new BigDecimal(price));
        } else if ("sunitPrice".equals(field)) {
            sysCustomerPrice.setSunitPrice(price);
        } else if ("maxHisPfPrice".equals(field)) {
            if (StrUtil.isNull(sysCustomerPrice.getMaxHisPfPrices())) {
                sysCustomerPrice.setMaxHisPfPrice(price);
                sysCustomerPrice.setMaxHisPfPrices(price + ",");
                sysCustomerPrice.setMaxHisGyPrice(null);
                sysCustomerPrice.setMinHisGyPrice(null);
            } else {
                String maxHisPfPrices = "," + sysCustomerPrice.getMaxHisPfPrices();
                String cmpPrice = price + ",";
                if (!maxHisPfPrices.contains(cmpPrice)) {
                    sysCustomerPrice.setMaxHisPfPrices(sysCustomerPrice.getMaxHisPfPrices() + price + ",");
                }
                sysCustomerPrice.setMaxHisPfPrice(price);
                sysCustomerPrice.setMaxHisGyPrice(null);
                sysCustomerPrice.setMinHisGyPrice(null);
                return this.customerDao.updateSysCustomerPrice(database, sysCustomerPrice);
            }
        } else if ("minHisPfPrice".equals(field)) {
            if (StrUtil.isNull(sysCustomerPrice.getMinHisPfPrices())) {
                sysCustomerPrice.setMinHisPfPrice(price);
                sysCustomerPrice.setMinHisPfPrices(price + ",");
                sysCustomerPrice.setMaxHisGyPrice(null);
                sysCustomerPrice.setMinHisGyPrice(null);
            } else {
                String minHisPfPrices = "," + sysCustomerPrice.getMinHisPfPrices();
                String cmpPrice = price + ",";
                if (!minHisPfPrices.contains(cmpPrice)) {
                    sysCustomerPrice.setMinHisPfPrices(sysCustomerPrice.getMinHisPfPrices() + price + ",");
                }
                sysCustomerPrice.setMinHisPfPrice(price);
                sysCustomerPrice.setMaxHisGyPrice(null);
                sysCustomerPrice.setMinHisGyPrice(null);
                return this.customerDao.updateSysCustomerPrice(database, sysCustomerPrice);
            }
        }
        return this.customerDao.updateSysCustomerPrice(database, sysCustomerPrice);
    }

    ;

    public List<SysCustomerPrice> listSysCustomerPrice(String database, Integer customerId) {
        return this.customerDao.listSysCustomerPrice(database, customerId, "");
    }

    public List<SysCustomerPrice> listSysCustomerPrice(String database, SysCustomerPrice scp) {
        return this.customerDao.listSysCustomerPrice(database, scp);
    }

    public Page queryCustomerPriceWarePage(SysWare ware, Integer customerId, int page, int rows, String database) {
        return this.customerDao.queryCustomerPriceWarePage(ware, customerId, page, rows, database);
    }

    public void updateAllPy(String database) {
        this.customerDao.updateAllPy(database);
    }

    public int updateBatchCustomer(String ids, String customerType, String hzfsNm, Integer isDb, String khdjNm, String regionId, SysLoginInfo info) {
        int count = this.customerDao.updateBatchCustomer(ids, customerType, hzfsNm, isDb, khdjNm, regionId, info.getDatasource());
        //如果客户状态有变动时，通知商城关联会员改为普通会员
        if (count > 0) {
            String[] ss = ids.split(",");
            for (String id : ss) {
                memberPublisher.customerIsDbChange(Integer.valueOf(id), isDb, info);
            }
        }
        return count;
    }

    public List<SysCustomer> queryCustomerListByIds(String ids, String database) {
        return this.customerDao.queryCustomerListByIds(ids, database);
    }

    public SysCustomerPrice queryCustomerPrice(SysCustomerPrice customerPrice, String database) {

        return customerDao.queryCustomerPrice(customerPrice, database);
    }

    /**
     * 根据openId查询会员
     */
    //不使用此认证方法商城会员统一走事件监听机制
    /*@Deprecated
    public String updateCustomerByRzMobile(String database, String rzMobile, Integer cid, String oldMobile) {
        //1.认证成功；2.该手机号在员工管理中已认证过；3.该手机号在客户管理中已认证过
        try {
            if (!StrUtil.isNull(rzMobile) && rzMobile.length() == 11) {
//				1.根据认证手机号查询客户表
//				1）存在-提示该手机号已认证
//				2）不存在；再处理（客户表添加认证手机（放后面处理））
//				2. 根据认证手机号查询会员表
//				1）存在：根据source判定是员工，客户还是普通会员；如果是员工或客户-提示已存在；如果是普通则修改为客户会员（放后面处理）
//				2）不存在：再处理；（添加客户会员，可能注册总平台会员，会员加入平台会员企业记录（app查询供货商），客户表添加认证手机）
//				3.根据认证手机号查询总平台会员
//				1）存在：会员修改平台会员企业记录（app查询供货商）
//				2）不存在：注册总平台会员；会员加入平台会员企业记录（app查询供货商）；注册该企业客户会员；


                //1.根据认证手机号查询客户表
                SysCustomer oldCustomer = this.customerDao.queryCustomerByRzMobile(rzMobile, database);
                if (oldCustomer != null)
                    return "该手机号已在客户管理中认证过";
                //2.根据认证手机号查询商城会员表
                Map<String, Object> shopMemberMap = this.memberDao.queryShopMemberByOpenId(null, rzMobile, database);
                boolean isAdd = true;
                if (shopMemberMap == null || shopMemberMap.isEmpty()) {
                    //TODO:添加会员（员工）
                    shopMemberMap = new HashMap<>();
                    isAdd = true;
                } else {
                    //TODO:修改会员（判定会员是否属于员工)--------如果会员是客户，要怎么处理？？？
                    String source = (String) shopMemberMap.get("source");////会员来源1：普通；2：员工；3：经销存客户 4：门店
                    if (!StrUtil.isNull(source)) {
                        if ("3".equals(source)) {
                            return "会员中找到该手机号已认证过客户";
                        }
                        if ("2".equals(source)) {
                            return "该手机号已认证过员工";
                        }
                    }
                    isAdd = false;
                }
                //修改客户表添加认证手机号
                SysCustomer customer = this.customerDao.queryCustomerById(database, cid);
                customer.setRzMobile(rzMobile);
                customer.setRzState(1);
                this.customerDao.updateCustomerByRzMobile(customer, database);

                //删除原有会员的客户认证
                if (!StrUtil.isNull(oldMobile)) {
                    this.memberDao.updateOldMemberCustomerId(oldMobile, database);
                }

                //增加或修改商城用户表
                shopMemberMap.put("name", customer.getKhNm());
                shopMemberMap.put("mobile", customer.getRzMobile());
//					shopMemberMap.put("mem_id",customer.getId());
                shopMemberMap.put("active_date", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd hh:mm"));
                shopMemberMap.put("reg_date", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd hh:mm"));
                //判断是否倒闭
                if (1 == customer.getIsDb()) {
                    shopMemberMap.put("source", 1);//(来源：：普通1；员工2；客户3)
                    shopMemberMap.put("customer_id", null);
                    shopMemberMap.put("customer_name", null);
                } else {
                    shopMemberMap.put("customer_id", customer.getId());
                    shopMemberMap.put("customer_name", customer.getKhNm());
                    shopMemberMap.put("source", 3);//(来源：：普通1；员工2；客户3)
                }
                shopMemberMap.put("status", 1);
                shopMemberMap.put("shop_no", 9996);//店号(来源：客户：9996；app：9997；员工：9998，微信公众号：9999，门店如：0001,0002)
                shopMemberMap.put("hy_source", "客户管理");

                //3.根据认证手机号查询总平台会员（如果已经认证会员直接关连，否则商城登陆认证时加入总平台后在关连会员）
                SysMember sysMember = memberWebDao.queryMemberByMobile(rzMobile);
                if (sysMember != null) {
                    shopMemberMap.put("mem_id", sysMember.getMemberId());
                    //总平台：会员加入平台会员企业记录（供货商）
                    this.addShopMemberCompany(shopMemberMap, database);
                } else {
                    shopMemberMap.put("mem_id", 0);
                }
                if (isAdd) {
                    this.memberDao.addShopMember(shopMemberMap, database);
                } else {
                    this.memberDao.updateShopMember(shopMemberMap, database);
                }
            }
            //1.认证成功；2.该手机号已认证过；3.该手机号已在客户管理中认证过
            return "操作成功";
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }*/

    //--------------------------------------------------------------------------------
    //总平台：会员加入平台会员企业记录（app查询供货商）
    public void addShopMemberCompany(Map<String, Object> shopMemberMap, String dataSource) {
        try {
            SysCorporation corporation = this.corporationDao.queryCorporationBydata(dataSource);
            ShopMemberCompany smc = new ShopMemberCompany();
            smc.setCompanyId(corporation.getDeptId().intValue());
            smc.setMemberId((Integer) shopMemberMap.get("mem_id"));
            smc.setMemberMobile((String) shopMemberMap.get("mobile"));
            List<ShopMemberCompany> rtnList = this.shopMemberCompanyDao.queryShopMemberCompanyList(smc);
            if (rtnList != null && rtnList.size() > 0) {
                smc = rtnList.get(0);
                smc.setOutTime("");
                smc.setMemberNm((String) shopMemberMap.get("name"));
                this.shopMemberCompanyDao.updateShopMemberCompany(smc);
            } else {
                smc.setInTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
                smc.setMemberCompany(corporation.getDeptNm());
                smc.setMemberNm((String) shopMemberMap.get("name"));
                shopMemberCompanyDao.addShopMemberCompany(smc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @param list
     * @param
     * @param
     * @param
     * @throws Exception
     */
    public void loadCustomerPrice(List<? extends SysWare> list, SysLoginInfo info, String customerId, String... o) throws Exception {
        String database = info.getDatasource();
        SysCustomer sysCustomer = this.customerDao.queryCustomerById(database, Integer.valueOf(customerId));
        String wareTypeIds = "";
        String wareIds = "";
        for (int i = 0; i < list.size(); i++) {
            SysWare wareVo = list.get(i);
            wareVo.setPfPriceType(0);
            wareVo.setLsPriceType(0);
            wareVo.setFxPriceType(0);
            wareVo.setCxPriceType(0);
            wareVo.setMinPfPriceType(0);
            wareVo.setMinLsPriceType(0);
            wareVo.setMinFxPriceType(0);
            wareVo.setMinCxPriceType(0);
            if (!StrUtil.isNumberNullOrZero(wareVo.getWareDj())) {
                BigDecimal saleAmt = new BigDecimal(wareVo.getWareDj());
                if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                    wareVo.setWareDj(Double.valueOf(saleAmt.toString()));
                    if (StrUtil.isNumberNullOrZero(wareVo.getSunitPrice())) {
                        wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), saleAmt.doubleValue())).setScale(3, BigDecimal.ROUND_HALF_DOWN));
                    }
                }
            }
            if (!StrUtil.isNumberNullOrZero(wareVo.getSunitPrice())) {
                wareVo.setSunitPrice(wareVo.getSunitPrice());
                if (StrUtil.isNumberNullOrZero(wareVo.getWareDj())) {
                    wareVo.setWareDj(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), wareVo.getSunitPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(wareVo.getLsPrice())) {
                wareVo.setLsPrice(wareVo.getLsPrice());
                if (StrUtil.isNumberNullOrZero(wareVo.getMinLsPrice())) {
                    wareVo.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), wareVo.getLsPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(wareVo.getMinLsPrice())) {
                wareVo.setMinLsPrice(wareVo.getMinLsPrice());
                if (StrUtil.isNumberNullOrZero(wareVo.getLsPrice())) {
                    wareVo.setLsPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), wareVo.getMinLsPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(wareVo.getCxPrice())) {
                wareVo.setCxPrice(wareVo.getCxPrice());
                if (StrUtil.isNumberNullOrZero(wareVo.getMinCxPrice())) {
                    wareVo.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), wareVo.getCxPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(wareVo.getMinCxPrice())) {
                wareVo.setMinCxPrice(wareVo.getMinCxPrice());
                if (StrUtil.isNumberNullOrZero(wareVo.getCxPrice())) {
                    wareVo.setCxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), wareVo.getMinCxPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(wareVo.getFxPrice())) {
                wareVo.setFxPrice(wareVo.getFxPrice());
                if (StrUtil.isNumberNullOrZero(wareVo.getMinFxPrice())) {
                    wareVo.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), wareVo.getFxPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(wareVo.getMinFxPrice())) {
                wareVo.setMinFxPrice(wareVo.getMinFxPrice());
                if (StrUtil.isNumberNullOrZero(wareVo.getFxPrice())) {
                    wareVo.setFxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), wareVo.getMinFxPrice().doubleValue()));
                }
            }
            wareVo.setTempWareDj(wareVo.getLsPrice());
            //wareVo.setTempSunitPrice(new BigDecimal(0));
            if (!StrUtil.isNumberNullOrZero(wareVo.getMinLsPrice())) {
                wareVo.setTempSunitPrice(new BigDecimal(wareVo.getMinLsPrice()).setScale(3, BigDecimal.ROUND_HALF_DOWN));
            }

            if (StrUtil.isNumberNullOrZero(wareVo.getWareDj())) {
                if (!StrUtil.isNumberNullOrZero(wareVo.getLsPrice())) {
                    wareVo.setWareDj(wareVo.getLsPrice());
                    if (StrUtil.isNumberNullOrZero(wareVo.getSunitFront())) {
                        wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), wareVo.getWareDj())));
                    }
                }
                if (!StrUtil.isNumberNullOrZero(wareVo.getMinLsPrice())) {
                    wareVo.setSunitPrice(new BigDecimal(wareVo.getMinLsPrice()));
                    if (StrUtil.isNumberNullOrZero(wareVo.getWareDj())) {
                        wareVo.setWareDj(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), wareVo.getSunitFront().doubleValue()));
                    }
                }
            }
            if (wareTypeIds != "") {
                wareTypeIds += ",";
            }
            wareTypeIds += wareVo.getWaretype();
            if (wareIds != "") {
                wareIds += ",";
            }
            wareIds += wareVo.getWareId();
        }

        List<Map<String, Object>> typeMapList = this.waretypeDao.queryWarePathMapList(wareTypeIds, database);
        Map<Integer, String> waretypeMap = new HashMap<Integer, String>();
        if (null != typeMapList) {
            for (int i = 0; i < typeMapList.size(); i++) {
                Map<String, Object> map = typeMapList.get(i);
                Integer waretypeId = Integer.valueOf(map.get("waretype_id") + "");
                String waretypePath = map.get("waretype_path") + "";
                waretypeMap.put(waretypeId, waretypePath);
            }
        }

        if (sysCustomer != null && (!StrUtil.isNull(sysCustomer.getQdtpNm()) || !StrUtil.isNull(sysCustomer.getQdtypeId()))) {
            SysQdtype typep = null;
            if (!StrUtil.isNull(sysCustomer.getQdtypeId())) {
                typep = this.qdtypeDao.queryQdtypeById(sysCustomer.getQdtypeId(), database);
            } else {
                if (sysCustomer.getQdtpNm() != "null") {
                    typep = qdtypeDao.queryQdtypeByName(sysCustomer.getQdtpNm(), database);
                }
            }

            if (typep != null) {
                SysQdTypePrice typePrice = new SysQdTypePrice();
                typePrice.setRelaId(typep.getId());
                List<SysQdTypePrice> typeList = new ArrayList<SysQdTypePrice>();
                List<SysQdTypeRate> typeRateList = new ArrayList<SysQdTypeRate>();
                if (!StrUtil.isNull(typep.getId())) {
                    typeList = qdTypePriceDao.queryList(typePrice, database, wareIds);
                    SysQdTypeRate typeRate = new SysQdTypeRate();
                    typeRate.setRelaId(typep.getId());
                    //折扣率
                    typeRateList = qdTypeRateDao.queryList(typeRate, database, "");
                }
                Map<Integer, SysQdTypePrice> typeListMap = new HashMap<Integer, SysQdTypePrice>();
                if (typeList != null && typeList.size() > 0) {
                    for (int i = 0; i < typeList.size(); i++) {
                        SysQdTypePrice typePrice1 = typeList.get(i);
                        typeListMap.put(typePrice1.getWareId(), typePrice1);
                    }
                }

                //=========设置客户类型中的销售折扣率===========
                if (typep != null && !StrUtil.isNumberNullOrZero(typep.getRate())) {
                    for (int i = 0; i < list.size(); i++) {
                        SysWare wareVo = list.get(i);
                        setSysWarePrice(typep.getRate(), wareVo);
                        wareVo.setPfPriceType(1);
                        wareVo.setMinPfPriceType(1);
                    }
                }
                //=========设置客户类型中的销售折扣率===========

                if (typeRateList != null && typeRateList.size() > 0) {//折扣率
                    for (int i = 0; i < list.size(); i++) {
                        SysWare wareVo = list.get(i);
                        String waretypePath = waretypeMap.get(wareVo.getWaretype());
                        BigDecimal rate = new BigDecimal(0);
                        for (int j = 0; j < typeRateList.size(); j++) {
                            SysQdTypeRate typeRate1 = typeRateList.get(j);
                            String wareTypeId = "-" + typeRate1.getWaretypeId() + "-";
                            if (waretypePath.contains(wareTypeId)) {
                                rate = typeRate1.getRate();
                            }
                        }
                        if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
                            setSysWarePrice(rate, wareVo);
                            wareVo.setPfPriceType(1);
                            wareVo.setMinPfPriceType(1);
                        }
                    }
                }

                for (int i = 0; i < list.size(); i++) {
                    SysWare wareVo = list.get(i);
                    Integer wareId = wareVo.getWareId();
                    if (typeListMap.containsKey(wareId)) {
                        SysQdTypePrice type = typeListMap.get(wareId);
                        BigDecimal rate = type.getRate();
                        if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
                            setSysWarePrice(rate, wareVo);
                            wareVo.setPfPriceType(1);
                            wareVo.setMinPfPriceType(1);
                        }
                        if (!StrUtil.isNull(wareVo.getWareId()) && !StrUtil.isNull(type.getWareId())) {
                            if (wareVo.getWareId().equals(type.getWareId())) {
                                if (!StrUtil.isNumberNullOrZero(type.getPrice()) && StrUtil.isNumeric(type.getPrice())) {
                                    BigDecimal saleAmt = new BigDecimal(type.getPrice());
                                    if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                                        wareVo.setWareDj(Double.valueOf(saleAmt.toString()));
                                        wareVo.setPfPriceType(1);
                                        if (StrUtil.isNumberNullOrZero(type.getSunitPrice())) {
                                            wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), saleAmt.doubleValue())));
                                            wareVo.setMinPfPriceType(1);
                                        }
                                    }
                                }
                                if (!StrUtil.isNumberNullOrZero(type.getSunitPrice())) {
                                    wareVo.setSunitPrice(new BigDecimal(type.getSunitPrice()));
                                    wareVo.setMinPfPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getPrice())) {
                                        wareVo.setWareDj(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), type.getSunitPrice().doubleValue()));
                                        wareVo.setPfPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getLsPrice())) {
                                    wareVo.setLsPrice(type.getLsPrice());
                                    wareVo.setLsPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getMinLsPrice())) {
                                        wareVo.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), type.getLsPrice().doubleValue()));
                                        wareVo.setMinLsPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getMinLsPrice())) {
                                    wareVo.setMinLsPrice(type.getMinLsPrice());
                                    wareVo.setMinLsPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getLsPrice())) {
                                        wareVo.setLsPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), type.getMinLsPrice().doubleValue()));
                                        wareVo.setLsPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getCxPrice())) {
                                    wareVo.setCxPrice(type.getCxPrice());
                                    wareVo.setCxPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getMinCxPrice())) {
                                        wareVo.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), type.getCxPrice().doubleValue()));
                                        wareVo.setMinCxPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getMinCxPrice())) {
                                    wareVo.setMinCxPrice(type.getMinCxPrice());
                                    wareVo.setMinCxPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getCxPrice())) {
                                        wareVo.setCxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), type.getMinCxPrice().doubleValue()));
                                        wareVo.setCxPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getFxPrice())) {
                                    wareVo.setFxPrice(type.getFxPrice());
                                    wareVo.setFxPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getMinFxPrice())) {
                                        wareVo.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), type.getFxPrice().doubleValue()));
                                        wareVo.setMinFxPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getMinFxPrice())) {
                                    wareVo.setMinFxPrice(type.getMinFxPrice());
                                    wareVo.setMinFxPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getFxPrice())) {
                                        wareVo.setFxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), type.getMinFxPrice().doubleValue()));
                                        wareVo.setFxPriceType(1);
                                    }
                                }


                            }
                        }
                    }
                }
            }
        }

        if (sysCustomer != null && (!StrUtil.isNull(sysCustomer.getKhdjNm()) || !StrUtil.isNull(sysCustomer.getKhlevelId()))) {
            SysKhlevel levelp = null;
            if (!StrUtil.isNull(sysCustomer.getKhlevelId())) {
                levelp = this.khlevelDao.querykhlevelById(sysCustomer.getKhlevelId(), database);
            } else {
                if (sysCustomer.getKhdjNm() != "null") {
                    levelp = khlevelDao.querykhlevelByName(sysCustomer.getKhdjNm(), database);
                }
            }

            if (levelp != null) {
                Integer levelId = levelp.getId();
                SysCustomerLevelPrice levelPrice = new SysCustomerLevelPrice();
                levelPrice.setLevelId(levelId);
                List<SysCustomerLevelPrice> levelList = new ArrayList<SysCustomerLevelPrice>();
                List<SysCustomerLevelRate> levelRateList = new ArrayList<SysCustomerLevelRate>();
                if (!StrUtil.isNull(levelId)) {
                    levelList = customerLevelPriceDao.queryList(levelPrice, database, wareIds);
                    SysCustomerLevelRate levelRate = new SysCustomerLevelRate();
                    levelRate.setRelaId(levelId);
                    levelRateList = customerLevelRateDao.queryList(levelRate, database, "");
                }
                Map<Integer, SysCustomerLevelPrice> levelListMap = new HashMap<Integer, SysCustomerLevelPrice>();
                if (levelList != null && levelList.size() > 0) {
                    for (int i = 0; i < levelList.size(); i++) {
                        SysCustomerLevelPrice levelPrice1 = levelList.get(i);
                        levelListMap.put(levelPrice1.getWareId(), levelPrice1);
                    }
                }

                if (levelRateList != null & levelRateList.size() > 0) {

                    for (int i = 0; i < list.size(); i++) {
                        SysWare wareVo = list.get(i);
                        String waretypePath = waretypeMap.get(wareVo.getWaretype());
                        BigDecimal rate = new BigDecimal(0);
                        for (int j = 0; j < levelRateList.size(); j++) {
                            SysCustomerLevelRate levelRate1 = levelRateList.get(j);
                            String wareTypeId = "-" + levelRate1.getWaretypeId() + "-";
                            if (waretypePath.contains(wareTypeId)) {
                                rate = levelRate1.getRate();
                            }
                        }
                        if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
                            setSysWarePrice(rate, wareVo);
                            wareVo.setPfPriceType(2);
                            wareVo.setMinPfPriceType(2);
                        }
                    }

                }

                for (int i = 0; i < list.size(); i++) {
                    SysWare wareVo = list.get(i);
                    Integer wareId = wareVo.getWareId();
                    if (levelListMap.containsKey(wareId)) {
                        SysCustomerLevelPrice level = levelListMap.get(wareId);
                        BigDecimal rate = level.getRate();
                        if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
                            setSysWarePrice(rate, wareVo);
                            wareVo.setPfPriceType(2);
                            wareVo.setMinPfPriceType(2);
                        }
                        if (!StrUtil.isNull(wareVo.getWareId()) && !StrUtil.isNull(level.getWareId())) {
                            if (wareVo.getWareId().equals(level.getWareId())) {
                                if (!StrUtil.isNumberNullOrZero(level.getPrice()) && StrUtil.isNumeric(level.getPrice())) {
                                    BigDecimal saleAmt = new BigDecimal(level.getPrice());
                                    if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                                        wareVo.setWareDj(Double.valueOf(saleAmt.toString()));
                                        wareVo.setPfPriceType(2);
                                        if (StrUtil.isNumberNullOrZero(level.getSunitPrice())) {
                                            wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), saleAmt.doubleValue())));
                                            wareVo.setMinPfPriceType(2);
                                        }
                                    }
                                }
                                if (!StrUtil.isNumberNullOrZero(level.getSunitPrice())) {
                                    wareVo.setSunitPrice(new BigDecimal(level.getSunitPrice()));
                                    wareVo.setMinPfPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getPrice())) {
                                        wareVo.setWareDj(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), level.getSunitPrice().doubleValue()));
                                        wareVo.setPfPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getLsPrice())) {
                                    wareVo.setLsPrice(level.getLsPrice());
                                    wareVo.setLsPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getMinLsPrice())) {
                                        wareVo.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), level.getLsPrice().doubleValue()));
                                        wareVo.setMinLsPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getMinLsPrice())) {
                                    wareVo.setMinLsPrice(level.getMinLsPrice());
                                    wareVo.setMinLsPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getLsPrice())) {
                                        wareVo.setLsPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), level.getMinLsPrice().doubleValue()));
                                        wareVo.setLsPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getCxPrice())) {
                                    wareVo.setCxPrice(level.getCxPrice());
                                    wareVo.setCxPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getMinCxPrice())) {
                                        wareVo.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), level.getCxPrice().doubleValue()));
                                        wareVo.setMinCxPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getMinCxPrice())) {
                                    wareVo.setMinCxPrice(level.getMinCxPrice());
                                    wareVo.setMinCxPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getCxPrice())) {
                                        wareVo.setCxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), level.getMinCxPrice().doubleValue()));
                                        wareVo.setCxPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getFxPrice())) {
                                    wareVo.setFxPrice(level.getFxPrice());
                                    if (StrUtil.isNumberNullOrZero(level.getMinFxPrice())) {
                                        wareVo.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), level.getFxPrice().doubleValue()));
                                        wareVo.setFxPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getMinFxPrice())) {
                                    wareVo.setMinFxPrice(level.getMinFxPrice());
                                    wareVo.setMinFxPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getFxPrice())) {
                                        wareVo.setFxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), level.getMinFxPrice().doubleValue()));
                                        wareVo.setFxPriceType(2);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        List<SysCustomerPrice> cpList = this.customerDao.listSysCustomerPrice(database, Integer.valueOf(customerId), wareIds);
        if (cpList != null && cpList.size() > 0) {
            Map<Integer, SysCustomerPrice> customerPriceMap = new HashMap<Integer, SysCustomerPrice>();
            for (int i = 0; i < cpList.size(); i++) {
                SysCustomerPrice scp1 = cpList.get(i);
                customerPriceMap.put(scp1.getWareId(), scp1);
            }
            for (int i = 0; i < list.size(); i++) {
                SysWare wareVo = list.get(i);
                Integer wareId = wareVo.getWareId();
                if (customerPriceMap.containsKey(wareId)) {
                    SysCustomerPrice cPrice = customerPriceMap.get(wareId);
                    if (!StrUtil.isNull(wareVo.getWareId()) && !StrUtil.isNull(cPrice.getWareId())) {
                        if (wareVo.getWareId().equals(cPrice.getWareId())) {
                            if (!StrUtil.isNumberNullOrZero(cPrice.getSaleAmt())) {
                                BigDecimal saleAmt = cPrice.getSaleAmt();
                                wareVo.setPfPriceType(3);
                                if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                                    wareVo.setWareDj(Double.valueOf(saleAmt.toString()));
                                    if (StrUtil.isNumberNullOrZero(cPrice.getSunitPrice())) {
                                        wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), saleAmt.doubleValue())));
                                        wareVo.setMinPfPriceType(3);
                                    }
                                }
                            }
                            if (!StrUtil.isNumberNullOrZero(cPrice.getSunitPrice())) {
                                wareVo.setSunitPrice(new BigDecimal(cPrice.getSunitPrice()));
                                wareVo.setMinPfPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getSaleAmt())) {
                                    wareVo.setWareDj(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getSunitPrice().doubleValue()));
                                    wareVo.setPfPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getLsPrice())) {
                                wareVo.setLsPrice(cPrice.getLsPrice());
                                wareVo.setLsPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinLsPrice())) {
                                    wareVo.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), cPrice.getLsPrice().doubleValue()));
                                    wareVo.setMinLsPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinLsPrice())) {
                                wareVo.setMinLsPrice(cPrice.getMinLsPrice());
                                wareVo.setMinLsPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getLsPrice())) {
                                    wareVo.setLsPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getMinLsPrice().doubleValue()));
                                    wareVo.setLsPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getCxPrice())) {
                                wareVo.setCxPrice(cPrice.getCxPrice());
                                wareVo.setCxPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinCxPrice())) {
                                    wareVo.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), cPrice.getCxPrice().doubleValue()));
                                    wareVo.setMinCxPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinCxPrice())) {
                                wareVo.setMinCxPrice(cPrice.getMinCxPrice());
                                wareVo.setMinCxPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getCxPrice())) {
                                    wareVo.setCxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getMinCxPrice().doubleValue()));
                                    wareVo.setCxPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getFxPrice())) {
                                wareVo.setFxPrice(cPrice.getFxPrice());
                                wareVo.setFxPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinFxPrice())) {
                                    wareVo.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), cPrice.getFxPrice().doubleValue()));
                                    wareVo.setMinFxPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinFxPrice())) {
                                wareVo.setMinFxPrice(cPrice.getMinFxPrice());
                                wareVo.setMinFxPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getFxPrice())) {
                                    wareVo.setFxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getMinFxPrice().doubleValue()));
                                    wareVo.setFxPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getMaxHisGyPrice())) {
                                wareVo.setMaxHisGyPrice(cPrice.getMaxHisGyPrice());
                                cPrice.setMaxHisPfPrice(cPrice.getMaxHisGyPrice());
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinHisGyPrice())) {
                                    wareVo.setMinHisGyPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), cPrice.getMaxHisGyPrice().doubleValue()));
                                }
                            }
                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinHisGyPrice())) {
                                wareVo.setMinHisGyPrice(cPrice.getMinHisGyPrice());
                                cPrice.setMinHisPfPrice(cPrice.getMinHisGyPrice());
                                if (StrUtil.isNumberNullOrZero(cPrice.getMaxHisGyPrice())) {
                                    wareVo.setMaxHisGyPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getMinHisGyPrice().doubleValue()));
                                }
                            }


                            if (!StrUtil.isNumberNullOrZero(cPrice.getMaxHisPfPrice())) {
                                wareVo.setMaxHisPfPrice(cPrice.getMaxHisPfPrice());
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinHisPfPrice())) {
                                    wareVo.setMinHisPfPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), cPrice.getMaxHisPfPrice().doubleValue()));
                                }
                            }
                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinHisPfPrice())) {
                                wareVo.setMinHisPfPrice(cPrice.getMinHisPfPrice());
                                if (StrUtil.isNumberNullOrZero(cPrice.getMaxHisPfPrice())) {
                                    wareVo.setMaxHisPfPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getMinHisPfPrice().doubleValue()));
                                }
                            }

                            if (!StrUtil.isNull(cPrice.getMaxHisPfPrices())) {
                                wareVo.setMaxHisPfPrices(cPrice.getMaxHisPfPrices());
                            }
                            if (!StrUtil.isNull(cPrice.getMinHisPfPrices())) {
                                wareVo.setMinHisPfPrices(cPrice.getMinHisPfPrices());
                            }


                        }
                    }
                }
            }
        }

        if (!StrUtil.isNull(o)) {
            if (o.length > 0 && "1".equals(o[0])) {
                /*是否开启了自动设置历史价格*/
                SysConfig config = this.configService.querySysConfigByCode("CONFIG_SHOP_SYC_JXC_HIS_PRICE", database);
                //假如开启了历史价，则把对应的执行价置为历史价
                if (config != null && "1".equals(config.getStatus())) {
                    for (int i = 0; i < list.size(); i++) {
                        SysWare wareVo = list.get(i);
                        if (!StrUtil.isNumberNullOrZero(wareVo.getMaxHisPfPrice())) {
                            wareVo.setWareDj(wareVo.getMaxHisPfPrice());
                        }
                        if (!StrUtil.isNumberNullOrZero(wareVo.getMinHisPfPrice())) {
                            wareVo.setSunitPrice(new BigDecimal(wareVo.getMinHisPfPrice()));
                        }
                    }
                }
            }
        }

        Map<Integer, Map<Integer, BigDecimal>> awpMap = this.customerDao.queryAdjustWarePrice(database, Integer.valueOf(customerId), null);
        if (awpMap != null) {

            for (int i = 0; i < list.size(); i++) {
                SysWare wareVo = list.get(i);
                Integer wareId = wareVo.getWareId();
                if (awpMap.containsKey(wareId)) {
                    Map<Integer, BigDecimal> oMap = awpMap.get(wareId);
                    if (oMap.containsKey(1)) {
                        wareVo.setWareDj(oMap.get(1).doubleValue());
                        wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), wareVo.getWareDj().doubleValue())));
                        if (!StrUtil.isNumberNullOrZero(wareVo.getMaxHisPfPrice())) {
                            //wareVo.setMaxHisPfPrice(oMap.get(1).doubleValue());
                        }
                        if (!StrUtil.isNumberNullOrZero(wareVo.getMinHisPfPrice())) {
                            //wareVo.setMinHisPfPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(),wareVo.getWareDj().doubleValue()));
                        }
                        wareVo.setPfPriceType(4);
                        wareVo.setMinPfPriceType(4);
                    } else {
                        BigDecimal disPrice = oMap.get(2);
                        Double minDisPrice = StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), disPrice.doubleValue());
                        if (!StrUtil.isNumberNullOrZero(disPrice)) {
                            wareVo.setWareDj(wareVo.getWareDj() + disPrice.doubleValue());
                            if (!StrUtil.isNumberNullOrZero(wareVo.getMaxHisPfPrice())) {
                                // wareVo.setMaxHisPfPrice(wareVo.getMaxHisPfPrice()+disPrice.doubleValue());
                            }
                            if (!StrUtil.isNumberNullOrZero(wareVo.getMinHisPfPrice())) {
                                // wareVo.setMinHisPfPrice(wareVo.getMinHisPfPrice()+minDisPrice);
                            }
                            wareVo.setSunitPrice(wareVo.getSunitPrice().add(new BigDecimal(minDisPrice)));
                            wareVo.setPfPriceType(4);
                            wareVo.setMinPfPriceType(4);
                        }
                    }
                }
            }

        }
    }


    /**
     * 商品分组价格
     *
     * @param sysWare
     * @param info
     * @throws Exception
     */
    public List<SysCustomerPrice> groupCustomerWarePrice(SysWare sysWare, SysLoginInfo info) throws Exception {

        if (!StrUtil.isNumberNullOrZero(sysWare.getWareDj())) {
            BigDecimal saleAmt = new BigDecimal(sysWare.getWareDj());
            if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                sysWare.setWareDj(Double.valueOf(saleAmt.toString()));
                if (StrUtil.isNumberNullOrZero(sysWare.getSunitPrice())) {
                    sysWare.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), saleAmt.doubleValue())));
                }
            }
        }
        if (!StrUtil.isNumberNullOrZero(sysWare.getSunitPrice())) {
            sysWare.setSunitPrice(sysWare.getSunitPrice());
            if (StrUtil.isNumberNullOrZero(sysWare.getWareDj())) {
                sysWare.setWareDj(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), sysWare.getSunitPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(sysWare.getLsPrice())) {
            sysWare.setLsPrice(sysWare.getLsPrice());
            if (StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
                sysWare.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), sysWare.getLsPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
            sysWare.setMinLsPrice(sysWare.getMinLsPrice());
            if (StrUtil.isNumberNullOrZero(sysWare.getLsPrice())) {
                sysWare.setLsPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), sysWare.getMinLsPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(sysWare.getCxPrice())) {
            sysWare.setCxPrice(sysWare.getCxPrice());
            if (StrUtil.isNumberNullOrZero(sysWare.getMinCxPrice())) {
                sysWare.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), sysWare.getCxPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(sysWare.getMinCxPrice())) {
            sysWare.setMinCxPrice(sysWare.getMinCxPrice());
            if (StrUtil.isNumberNullOrZero(sysWare.getCxPrice())) {
                sysWare.setCxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), sysWare.getMinCxPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(sysWare.getFxPrice())) {
            sysWare.setFxPrice(sysWare.getFxPrice());
            if (StrUtil.isNumberNullOrZero(sysWare.getMinFxPrice())) {
                sysWare.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), sysWare.getFxPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(sysWare.getMinFxPrice())) {
            sysWare.setMinFxPrice(sysWare.getMinFxPrice());
            if (StrUtil.isNumberNullOrZero(sysWare.getFxPrice())) {
                sysWare.setFxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), sysWare.getMinFxPrice().doubleValue()));
            }
        }


        if (StrUtil.isNumberNullOrZero(sysWare.getWareDj())) {
            sysWare.setWareDj(0.0);
        }
        if (StrUtil.isNumberNullOrZero(sysWare.getSunitPrice())) {
            sysWare.setSunitPrice(new BigDecimal(0));
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getLsPrice())) {
            sysWare.setLsPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
            sysWare.setMinLsPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getCxPrice())) {
            sysWare.setCxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getMinCxPrice())) {
            sysWare.setMinCxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getFxPrice())) {
            sysWare.setFxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getMinFxPrice())) {
            sysWare.setMinFxPrice(0.0);
        }

        List<SysCustomerPrice> customerWareGroup = this.customerDao.groupSysCustomerPriceByWareId(info.getDatasource(), sysWare.getWareId());
        int flag = 0;
        for (int i = 0; i < customerWareGroup.size(); i++) {
            SysCustomerPrice customerPrice = customerWareGroup.get(i);
            customerPrice.setWareNm(sysWare.getWareNm());
            if (StrUtil.isNumberNullOrZero(customerPrice.getSaleAmt())) {
                customerPrice.setSaleAmt(new BigDecimal(0));
            }
            if (StrUtil.isNumberNullOrZero(customerPrice.getSunitPrice())) {
                customerPrice.setSunitPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(customerPrice.getLsPrice())) {
                customerPrice.setLsPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(customerPrice.getMinLsPrice())) {
                customerPrice.setMinLsPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(customerPrice.getCxPrice())) {
                customerPrice.setCxPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(customerPrice.getMinCxPrice())) {
                customerPrice.setMinCxPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(customerPrice.getFxPrice())) {
                customerPrice.setFxPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(customerPrice.getMinFxPrice())) {
                customerPrice.setMinFxPrice(0.0);
            }
            if (
                    customerPrice.getSaleAmt().doubleValue() == sysWare.getWareDj().doubleValue()
                            && customerPrice.getSunitPrice().doubleValue() == sysWare.getSunitPrice().doubleValue()
                            && customerPrice.getCxPrice().doubleValue() == sysWare.getCxPrice().doubleValue()
                            && customerPrice.getFxPrice().doubleValue() == sysWare.getFxPrice().doubleValue()
                            && customerPrice.getMinCxPrice().doubleValue() == sysWare.getMinCxPrice().doubleValue()
                            && customerPrice.getMinLsPrice().doubleValue() == sysWare.getMinLsPrice().doubleValue()
                            && customerPrice.getMinFxPrice().doubleValue() == sysWare.getMinFxPrice().doubleValue()
                            && customerPrice.getLsPrice().doubleValue() == sysWare.getLsPrice().doubleValue()
            ) {

                flag = 1;
                break;
            }
        }
        if (flag == 0) {
            SysCustomerPrice customerPrice = new SysCustomerPrice();
            customerPrice.setWareId(sysWare.getWareId());
            customerPrice.setWareNm(sysWare.getWareNm());
            customerPrice.setSaleAmt(new BigDecimal(sysWare.getWareDj()));
            customerPrice.setSunitPrice(sysWare.getSunitPrice().doubleValue());
            customerPrice.setCxPrice(sysWare.getCxPrice());
            customerPrice.setFxPrice(sysWare.getFxPrice());
            customerPrice.setMinCxPrice(sysWare.getMinCxPrice());
            customerPrice.setMinLsPrice(sysWare.getMinLsPrice());
            customerPrice.setLsPrice(sysWare.getLsPrice());
            customerPrice.setMinFxPrice(sysWare.getMinFxPrice());
            customerWareGroup.add(customerPrice);
        }
        return customerWareGroup;
    }


    /*
        计算所有客户该商品的价格
    */
    public List<SysCustomer> calGroupCustomerPrice(SysWare sysWare, SysWare cusSysWare, SysLoginInfo info) throws Exception {
        SysCustomer customer = new SysCustomer();
        customer.setIsDb(2);
        List<SysCustomer> rtnCustomerList = new ArrayList<SysCustomer>();
        List<SysCustomer> customerList = this.customerDao.queryCustomerList(customer, info.getDatasource());
        SysQdTypePrice typePrice = new SysQdTypePrice();
        typePrice.setWareId(sysWare.getWareId());
        List<SysQdTypePrice> typeList = new ArrayList<SysQdTypePrice>();
        typeList = qdTypePriceDao.queryList(typePrice, info.getDatasource(), "");

        SysCustomerLevelPrice levelPrice = new SysCustomerLevelPrice();
        levelPrice.setWareId(sysWare.getWareId());
        List<SysCustomerLevelPrice> levelList = new ArrayList<SysCustomerLevelPrice>();
        levelList = customerLevelPriceDao.queryList(levelPrice, info.getDatasource(), "");

        SysCustomerPrice customerPrice = new SysCustomerPrice();
        customerPrice.setWareId(sysWare.getWareId());
        List<SysCustomerPrice> cpList = this.customerDao.listSysCustomerPrice(info.getDatasource(), customerPrice);
        List<SysQdtype> qdTypeList = qdtypeDao.queryQdtypels(info.getDatasource());
        List<SysKhlevel> khLevelList = khlevelDao.queryList(null, info.getDatasource());

        /****************************************************/
        if (StrUtil.isNumberNullOrZero(cusSysWare.getWareDj())) {
            cusSysWare.setWareDj(0.0);
        }
        if (StrUtil.isNumberNullOrZero(cusSysWare.getSunitPrice())) {
            cusSysWare.setSunitPrice(new BigDecimal(0));
        }

        if (StrUtil.isNumberNullOrZero(cusSysWare.getLsPrice())) {
            cusSysWare.setLsPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(cusSysWare.getMinLsPrice())) {
            cusSysWare.setMinLsPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(cusSysWare.getCxPrice())) {
            cusSysWare.setCxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(cusSysWare.getMinCxPrice())) {
            cusSysWare.setMinCxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(cusSysWare.getFxPrice())) {
            cusSysWare.setFxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(cusSysWare.getMinFxPrice())) {
            cusSysWare.setMinFxPrice(0.0);
        }

        /************************************************/

        if (StrUtil.isNumberNullOrZero(sysWare.getWareDj())) {
            sysWare.setWareDj(0.0);
        }
        if (StrUtil.isNumberNullOrZero(sysWare.getSunitPrice())) {
            sysWare.setSunitPrice(new BigDecimal(0));
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getLsPrice())) {
            sysWare.setLsPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
            sysWare.setMinLsPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getCxPrice())) {
            sysWare.setCxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getMinCxPrice())) {
            sysWare.setMinCxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getFxPrice())) {
            sysWare.setFxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getMinFxPrice())) {
            sysWare.setMinFxPrice(0.0);
        }

        List<SysQdTypeRate> typeRateList = new ArrayList<SysQdTypeRate>();
        SysQdTypeRate typeRate = new SysQdTypeRate();
        typeRate.setWaretypeId(sysWare.getWaretype());
        //客户类别折扣率
        typeRateList = qdTypeRateDao.queryList(typeRate, info.getDatasource(), "");


        List<SysCustomerLevelRate> levelRateList = new ArrayList<SysCustomerLevelRate>();
        SysCustomerLevelRate levelRate = new SysCustomerLevelRate();
        levelRate.setWaretypeId(sysWare.getWaretype());
        //客户等级折扣率
        levelRateList = customerLevelRateDao.queryList(levelRate, info.getDatasource(), "");
        String waretypePath = this.waretypeDao.queryWarePath(cusSysWare.getWaretype(), info.getDatasource());

        for (int i = 0; i < customerList.size(); i++) {
            SysCustomer sysCustomer = customerList.get(i);
            setCustomerTypeLevel(qdTypeList, khLevelList, sysCustomer);
            SysWare cmpSysWare = new SysWare();
            BeanCopy.copyBeanProperties(cmpSysWare, cusSysWare);
            String key1 = sysWare.getWareId() + ":" + sysWare.getWareDj() + ":" + sysWare.getSunitPrice() + ":"
                    + sysWare.getLsPrice() + ":" + sysWare.getMinLsPrice() + ":" + sysWare.getCxPrice() + ":" + sysWare.getMinCxPrice() + ":"
                    + sysWare.getFxPrice() + ":" + sysWare.getMinFxPrice();
            //System.out.println("key1:"+key1);
            loadGroupCustomerPrice(cmpSysWare, qdTypeList, typeList, levelList, cpList, sysCustomer, typeRateList, levelRateList, waretypePath);
            String key2 = cmpSysWare.getWareId() + ":" + cmpSysWare.getWareDj() + ":" + cmpSysWare.getSunitPrice() + ":"
                    + cmpSysWare.getLsPrice() + ":" + cmpSysWare.getMinLsPrice() + ":" + cmpSysWare.getCxPrice() + ":" + cmpSysWare.getMinCxPrice() + ":"
                    + cmpSysWare.getFxPrice() + ":" + cmpSysWare.getMinFxPrice();
            //System.out.println("key2:"+key2);

            if (cmpSysWare.getWareId().equals(sysWare.getWareId())
                    && cmpSysWare.getWareDj().doubleValue() == sysWare.getWareDj().doubleValue()
                    && cmpSysWare.getSunitPrice().doubleValue() == sysWare.getSunitPrice().doubleValue()
                    && cmpSysWare.getCxPrice().doubleValue() == sysWare.getCxPrice().doubleValue()
                    && cmpSysWare.getFxPrice().doubleValue() == sysWare.getFxPrice().doubleValue()
                    && cmpSysWare.getMinCxPrice().doubleValue() == sysWare.getMinCxPrice().doubleValue()
                    && cmpSysWare.getMinLsPrice().doubleValue() == sysWare.getMinLsPrice().doubleValue()
                    && cmpSysWare.getMinFxPrice().doubleValue() == sysWare.getMinFxPrice().doubleValue()
                    && cmpSysWare.getLsPrice().doubleValue() == sysWare.getLsPrice().doubleValue()
            ) {
                rtnCustomerList.add(sysCustomer);
            }
        }
        return rtnCustomerList;
    }


    public List<SysWare> groupCustomerPrice(SysWare sysWare, SysLoginInfo info) throws Exception {
        SysCustomer customer = new SysCustomer();
        customer.setIsDb(2);
        List<SysCustomer> customerList = this.customerDao.queryCustomerList(customer, info.getDatasource());
        SysQdTypePrice typePrice = new SysQdTypePrice();
        typePrice.setWareId(sysWare.getWareId());
        List<SysQdTypePrice> typeList = new ArrayList<SysQdTypePrice>();
        typeList = qdTypePriceDao.queryList(typePrice, info.getDatasource(), "");

        SysCustomerLevelPrice levelPrice = new SysCustomerLevelPrice();
        levelPrice.setWareId(sysWare.getWareId());
        List<SysCustomerLevelPrice> levelList = new ArrayList<SysCustomerLevelPrice>();
        levelList = customerLevelPriceDao.queryList(levelPrice, info.getDatasource(), "");

        SysCustomerPrice customerPrice = new SysCustomerPrice();
        customerPrice.setWareId(sysWare.getWareId());
        List<SysCustomerPrice> cpList = this.customerDao.listSysCustomerPrice(info.getDatasource(), customerPrice);

        List<SysQdtype> qdTypeList = qdtypeDao.queryQdtypels(info.getDatasource());
        List<SysKhlevel> khLevelList = khlevelDao.queryList(null, info.getDatasource());


        List<SysQdTypeRate> typeRateList = new ArrayList<SysQdTypeRate>();
        SysQdTypeRate typeRate = new SysQdTypeRate();
        typeRate.setWaretypeId(sysWare.getWaretype());
        //客户类别折扣率
        typeRateList = qdTypeRateDao.queryList(typeRate, info.getDatasource(), "");


        List<SysCustomerLevelRate> levelRateList = new ArrayList<SysCustomerLevelRate>();
        SysCustomerLevelRate levelRate = new SysCustomerLevelRate();
        levelRate.setWaretypeId(sysWare.getWaretype());
        //客户等级折扣率
        levelRateList = customerLevelRateDao.queryList(levelRate, info.getDatasource(), "");

        String waretypePath = this.waretypeDao.queryWarePath(sysWare.getWaretype(), info.getDatasource());


        if (StrUtil.isNumberNullOrZero(sysWare.getWareDj())) {
            sysWare.setWareDj(0.0);
        }
        if (StrUtil.isNumberNullOrZero(sysWare.getSunitPrice())) {
            sysWare.setSunitPrice(new BigDecimal(0));
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getLsPrice())) {
            sysWare.setLsPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
            sysWare.setMinLsPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getCxPrice())) {
            sysWare.setCxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getMinCxPrice())) {
            sysWare.setMinCxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getFxPrice())) {
            sysWare.setFxPrice(0.0);
        }

        if (StrUtil.isNumberNullOrZero(sysWare.getMinFxPrice())) {
            sysWare.setMinFxPrice(0.0);
        }

        //获取客户执行的价格
        List<SysWare> customerWares = new ArrayList<SysWare>();
        for (int i = 0; i < customerList.size(); i++) {
            SysCustomer sysCustomer = customerList.get(i);
            setCustomerTypeLevel(qdTypeList, khLevelList, sysCustomer);
            SysWare cmpSysWare = new SysWare();
            BeanCopy.copyBeanProperties(cmpSysWare, sysWare);
            loadGroupCustomerPrice(cmpSysWare, qdTypeList, typeList, levelList, cpList, sysCustomer, typeRateList, levelRateList, waretypePath);
            customerWares.add(cmpSysWare);
        }
        //合并所有客户执行的相同价格
        List<SysWare> groupWarePriceList = new ArrayList<SysWare>();

        Map<String, Object> map = new HashMap<String, Object>();
        Map<String, Integer> mapCount = new HashMap<String, Integer>();
        for (int i = 0; i < customerWares.size(); i++) {
            SysWare sw = customerWares.get(i);
            if (StrUtil.isNumberNullOrZero(sw.getWareDj())) {
                sw.setWareDj(0.0);
            }
            if (StrUtil.isNumberNullOrZero(sw.getSunitPrice())) {
                sw.setSunitPrice(new BigDecimal(0));
            }

            if (StrUtil.isNumberNullOrZero(sw.getLsPrice())) {
                sw.setLsPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(sw.getMinLsPrice())) {
                sw.setMinLsPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(sw.getCxPrice())) {
                sw.setCxPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(sw.getMinCxPrice())) {
                sw.setMinCxPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(sw.getFxPrice())) {
                sw.setFxPrice(0.0);
            }

            if (StrUtil.isNumberNullOrZero(sw.getMinFxPrice())) {
                sw.setMinFxPrice(0.0);
            }

            String key = sw.getWareId() + ":" + sw.getWareDj() + ":" + sw.getSunitPrice() + ":"
                    + sw.getLsPrice() + ":" + sw.getMinLsPrice() + ":" + sw.getCxPrice() + ":" + sw.getMinCxPrice() + ":"
                    + sw.getFxPrice() + ":" + sw.getMinFxPrice();
            if (map.containsKey(key)) {
                Integer count = mapCount.get(key);
                count += 1;
                mapCount.put(key, count);
            } else {
                map.put(key, sw);
                mapCount.put(key, 1);
            }
        }

        if (map != null) {
            for (String key : map.keySet()) {
                SysWare sw = (SysWare) map.get(key);
                Integer count = mapCount.get(key);
                sw.setWareNm(sw.getWareNm() + "(" + count + ")");
                groupWarePriceList.add(sw);
            }
        }
        return groupWarePriceList;
    }


    private void setCustomerTypeLevel(List<SysQdtype> qdTypeList, List<SysKhlevel> khLevelList, SysCustomer sysCustomer) {
        if (!StrUtil.isNull(sysCustomer.getQdtpNm()) && qdTypeList != null) {
            for (int i = 0; i < qdTypeList.size(); i++) {
                SysQdtype type = qdTypeList.get(i);
                if (type.getQdtpNm().equals(sysCustomer.getQdtpNm()) || type.getId().equals(sysCustomer.getQdtypeId())) {
                    sysCustomer.setQdtpNm(type.getId() + "");
                    break;
                }
            }
        }
        if (!StrUtil.isNull(sysCustomer.getKhdjNm()) && khLevelList != null) {
            for (int i = 0; i < khLevelList.size(); i++) {
                SysKhlevel level = khLevelList.get(i);
                if (level.getKhdjNm().equals(sysCustomer.getKhdjNm()) || level.getId().equals(sysCustomer.getKhlevelId())) {
                    sysCustomer.setKhdjNm(level.getId() + "");
                    break;
                }
            }
        }
    }

    private void loadGroupCustomerPrice(SysWare wareVo, List<SysQdtype> qdtypeList, List<SysQdTypePrice> typeList, List<SysCustomerLevelPrice> levelList, List<SysCustomerPrice> cpList, SysCustomer sysCustomer, List<SysQdTypeRate> typeRateList, List<SysCustomerLevelRate> levelRateList, String waretypePath) throws Exception {
        wareVo.setPfPriceType(0);
        wareVo.setLsPriceType(0);
        wareVo.setFxPriceType(0);
        wareVo.setCxPriceType(0);
        wareVo.setMinPfPriceType(0);
        wareVo.setMinLsPriceType(0);
        wareVo.setMinFxPriceType(0);
        wareVo.setMinCxPriceType(0);
        if (!StrUtil.isNumberNullOrZero(wareVo.getWareDj())) {
            BigDecimal saleAmt = new BigDecimal(wareVo.getWareDj());
            if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                wareVo.setWareDj(Double.valueOf(saleAmt.toString()));
                if (StrUtil.isNumberNullOrZero(wareVo.getSunitPrice())) {
                    wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), saleAmt.doubleValue())));
                }
            }

        }
        if (!StrUtil.isNumberNullOrZero(wareVo.getSunitPrice())) {
            wareVo.setSunitPrice(wareVo.getSunitPrice());
            if (StrUtil.isNumberNullOrZero(wareVo.getWareDj())) {
                wareVo.setWareDj(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), wareVo.getSunitPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(wareVo.getLsPrice())) {
            wareVo.setLsPrice(wareVo.getLsPrice());
            if (StrUtil.isNumberNullOrZero(wareVo.getMinLsPrice())) {
                wareVo.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), wareVo.getLsPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(wareVo.getMinLsPrice())) {
            wareVo.setMinLsPrice(wareVo.getMinLsPrice());
            if (StrUtil.isNumberNullOrZero(wareVo.getLsPrice())) {
                wareVo.setLsPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), wareVo.getMinLsPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(wareVo.getCxPrice())) {
            wareVo.setCxPrice(wareVo.getCxPrice());
            if (StrUtil.isNumberNullOrZero(wareVo.getMinCxPrice())) {
                wareVo.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), wareVo.getCxPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(wareVo.getMinCxPrice())) {
            wareVo.setMinCxPrice(wareVo.getMinCxPrice());
            if (StrUtil.isNumberNullOrZero(wareVo.getCxPrice())) {
                wareVo.setCxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), wareVo.getMinCxPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(wareVo.getFxPrice())) {
            wareVo.setFxPrice(wareVo.getFxPrice());
            if (StrUtil.isNumberNullOrZero(wareVo.getMinFxPrice())) {
                wareVo.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), wareVo.getFxPrice().doubleValue()));
            }
        }

        if (!StrUtil.isNumberNullOrZero(wareVo.getMinFxPrice())) {
            wareVo.setMinFxPrice(wareVo.getMinFxPrice());
            if (StrUtil.isNumberNullOrZero(wareVo.getFxPrice())) {
                wareVo.setFxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), wareVo.getMinFxPrice().doubleValue()));
            }
        }
        wareVo.setTempWareDj(wareVo.getLsPrice());
        wareVo.setTempSunitPrice(new BigDecimal(0));
        if (!StrUtil.isNumberNullOrZero(wareVo.getMinLsPrice())) {
            wareVo.setTempSunitPrice(new BigDecimal(wareVo.getMinLsPrice()));
        }


        if (StrUtil.isNull(wareVo.getWareDj())) {
            wareVo.setWareDj(wareVo.getLsPrice());
            wareVo.setSunitPrice(wareVo.getSunitPrice());
        }

        if (!StrUtil.isNull(sysCustomer.getQdtpNm()) && sysCustomer.getQdtpNm() != "null") {

            //============begin 设置客户类别折扣率 begin==========================
            if (qdtypeList != null && qdtypeList.size() > 0) {//客户类型折扣
                for (int j = 0; j < qdtypeList.size(); j++) {
                    SysQdtype qdtype = qdtypeList.get(j);
                    if (sysCustomer.getQdtpNm().equals(qdtype.getId() + "") && !StrUtil.isNumberNullOrZero(qdtype.getRate())) {
                        setSysWarePrice(qdtype.getRate(), wareVo);
                        wareVo.setPfPriceType(1);
                        wareVo.setMinPfPriceType(1);
                    }
                }
            }
            //============end 设置客户类别折扣率 end==========================

            if (typeRateList != null && typeRateList.size() > 0) {//折扣率
                BigDecimal rate = new BigDecimal(0);
                for (int j = 0; j < typeRateList.size(); j++) {
                    SysQdTypeRate typeRate1 = typeRateList.get(j);
                    String wareTypeId = "-" + typeRate1.getWaretypeId() + "-";
                    if (waretypePath.contains(wareTypeId)) {
                        rate = typeRate1.getRate();
                    }
                }
                if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
                    setSysWarePrice(rate, wareVo);
                    wareVo.setPfPriceType(1);
                    wareVo.setMinPfPriceType(1);
                }
            }
            for (int j = 0; j < typeList.size(); j++) {
                SysQdTypePrice type = typeList.get(j);
                if (!StrUtil.isNull(wareVo.getWareId()) && !StrUtil.isNull(type.getWareId()) && sysCustomer.getQdtpNm().equals(type.getRelaId() + "")) {
                    if (wareVo.getWareId().equals(type.getWareId())) {
                        if (!StrUtil.isNumberNullOrZero(type.getPrice()) && StrUtil.isNumeric(type.getPrice())) {
                            BigDecimal saleAmt = new BigDecimal(type.getPrice());
                            if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                                wareVo.setWareDj(Double.valueOf(saleAmt.toString()));
                                wareVo.setPfPriceType(1);
                                if (StrUtil.isNumberNullOrZero(type.getSunitPrice())) {
                                    wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), saleAmt.doubleValue())));
                                    wareVo.setMinPfPriceType(1);
                                }
                            }

                        }
                        if (!StrUtil.isNumberNullOrZero(type.getSunitPrice())) {
                            wareVo.setSunitPrice(new BigDecimal(type.getSunitPrice()));
                            wareVo.setMinPfPriceType(1);
                            if (StrUtil.isNumberNullOrZero(type.getPrice())) {
                                wareVo.setWareDj(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), type.getSunitPrice().doubleValue()));
                                wareVo.setPfPriceType(1);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(type.getLsPrice())) {
                            wareVo.setLsPrice(type.getLsPrice());
                            wareVo.setLsPriceType(1);
                            if (StrUtil.isNumberNullOrZero(type.getMinLsPrice())) {
                                wareVo.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), type.getLsPrice().doubleValue()));
                                wareVo.setMinLsPriceType(1);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(type.getMinLsPrice())) {
                            wareVo.setMinLsPrice(type.getMinLsPrice());
                            wareVo.setMinLsPriceType(1);
                            if (StrUtil.isNumberNullOrZero(type.getLsPrice())) {
                                wareVo.setLsPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), type.getMinLsPrice().doubleValue()));
                                wareVo.setLsPriceType(1);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(type.getCxPrice())) {
                            wareVo.setCxPrice(type.getCxPrice());
                            wareVo.setCxPriceType(1);
                            if (StrUtil.isNumberNullOrZero(type.getMinCxPrice())) {
                                wareVo.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), type.getCxPrice().doubleValue()));
                                wareVo.setMinCxPriceType(1);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(type.getMinCxPrice())) {
                            wareVo.setMinCxPrice(type.getMinCxPrice());
                            wareVo.setMinCxPriceType(1);
                            if (StrUtil.isNumberNullOrZero(type.getCxPrice())) {
                                wareVo.setCxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), type.getMinCxPrice().doubleValue()));
                                wareVo.setCxPriceType(1);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(type.getFxPrice())) {
                            wareVo.setFxPrice(type.getFxPrice());
                            wareVo.setFxPriceType(1);
                            if (StrUtil.isNumberNullOrZero(type.getMinFxPrice())) {
                                wareVo.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), type.getFxPrice().doubleValue()));
                                wareVo.setMinFxPriceType(1);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(type.getMinFxPrice())) {
                            wareVo.setMinFxPrice(type.getMinFxPrice());
                            wareVo.setMinFxPriceType(1);
                            if (StrUtil.isNumberNullOrZero(type.getFxPrice())) {
                                wareVo.setFxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), type.getMinFxPrice().doubleValue()));
                                wareVo.setFxPriceType(1);
                            }
                        }
                        break;
                    }
                }
            }
        }

        if (!StrUtil.isNull(sysCustomer.getKhdjNm()) && sysCustomer.getKhdjNm() != "null") {

            if (levelRateList != null & levelRateList.size() > 0) {
                BigDecimal rate = new BigDecimal(0);
                for (int j = 0; j < levelRateList.size(); j++) {
                    SysCustomerLevelRate levelRate1 = levelRateList.get(j);
                    String wareTypeId = "-" + levelRate1.getWaretypeId() + "-";
                    if (waretypePath.contains(wareTypeId)) {
                        rate = levelRate1.getRate();
                    }
                }
                if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
                    setSysWarePrice(rate, wareVo);
                    wareVo.setPfPriceType(2);
                    wareVo.setMinPfPriceType(2);
                }
            }

            for (int j = 0; j < levelList.size(); j++) {
                SysCustomerLevelPrice level = levelList.get(j);
                if (!StrUtil.isNull(wareVo.getWareId()) && !StrUtil.isNull(level.getWareId()) && sysCustomer.getKhdjNm().equals(level.getLevelId() + "")) {
                    if (wareVo.getWareId().equals(level.getWareId())) {
                        if (!StrUtil.isNumberNullOrZero(level.getPrice()) && StrUtil.isNumeric(level.getPrice())) {
                            BigDecimal saleAmt = new BigDecimal(level.getPrice());
                            if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                                wareVo.setWareDj(Double.valueOf(saleAmt.toString()));
                                wareVo.setPfPriceType(2);
                                if (StrUtil.isNumberNullOrZero(level.getSunitPrice())) {
                                    wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), saleAmt.doubleValue())));
                                    wareVo.setMinPfPriceType(2);
                                }
                            }
                        }
                        if (!StrUtil.isNumberNullOrZero(level.getSunitPrice())) {
                            wareVo.setSunitPrice(new BigDecimal(level.getSunitPrice()));
                            wareVo.setMinPfPriceType(2);
                            if (StrUtil.isNumberNullOrZero(level.getPrice())) {
                                wareVo.setWareDj(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), level.getSunitPrice().doubleValue()));
                                wareVo.setPfPriceType(2);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(level.getLsPrice())) {
                            wareVo.setLsPrice(level.getLsPrice());
                            wareVo.setLsPriceType(2);
                            if (StrUtil.isNumberNullOrZero(level.getMinLsPrice())) {
                                wareVo.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), level.getLsPrice().doubleValue()));
                                wareVo.setMinLsPriceType(2);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(level.getMinLsPrice())) {
                            wareVo.setMinLsPrice(level.getMinLsPrice());
                            wareVo.setMinLsPriceType(2);
                            if (StrUtil.isNumberNullOrZero(level.getLsPrice())) {
                                wareVo.setLsPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), level.getMinLsPrice().doubleValue()));
                                wareVo.setLsPriceType(2);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(level.getCxPrice())) {
                            wareVo.setCxPrice(level.getCxPrice());
                            wareVo.setCxPriceType(2);
                            if (StrUtil.isNumberNullOrZero(level.getMinCxPrice())) {
                                wareVo.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), level.getCxPrice().doubleValue()));
                                wareVo.setMinCxPriceType(2);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(level.getMinCxPrice())) {
                            wareVo.setMinCxPrice(level.getMinCxPrice());
                            wareVo.setMinCxPriceType(2);
                            if (StrUtil.isNumberNullOrZero(level.getCxPrice())) {
                                wareVo.setCxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), level.getMinCxPrice().doubleValue()));
                                wareVo.setCxPriceType(2);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(level.getFxPrice())) {
                            wareVo.setFxPrice(level.getFxPrice());
                            if (StrUtil.isNumberNullOrZero(level.getMinFxPrice())) {
                                wareVo.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), level.getFxPrice().doubleValue()));
                                wareVo.setFxPriceType(2);
                            }
                        }

                        if (!StrUtil.isNumberNullOrZero(level.getMinFxPrice())) {
                            wareVo.setMinFxPrice(level.getMinFxPrice());
                            wareVo.setMinFxPriceType(2);
                            if (StrUtil.isNumberNullOrZero(level.getFxPrice())) {
                                wareVo.setFxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), level.getMinFxPrice().doubleValue()));
                                wareVo.setFxPriceType(2);
                            }
                        }
                    }
                    break;
                }
            }
        }

        if (cpList == null) {
            cpList = new ArrayList<SysCustomerPrice>();
        }
        for (int j = 0; j < cpList.size(); j++) {
            SysCustomerPrice cPrice = cpList.get(j);
            if (!StrUtil.isNull(wareVo.getWareId()) && !StrUtil.isNull(cPrice.getWareId()) && cPrice.getCustomerId().equals(sysCustomer.getId())) {
                if (wareVo.getWareId().equals(cPrice.getWareId())) {
                    if (!StrUtil.isNumberNullOrZero(cPrice.getSaleAmt())) {
                        BigDecimal saleAmt = cPrice.getSaleAmt();
                        wareVo.setPfPriceType(3);
                        if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                            wareVo.setWareDj(Double.valueOf(saleAmt.toString()));
                            if (StrUtil.isNumberNullOrZero(cPrice.getSunitPrice())) {
                                wareVo.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), saleAmt.doubleValue())));
                                wareVo.setMinPfPriceType(3);
                            }
                        }
                    }
                    if (!StrUtil.isNumberNullOrZero(cPrice.getSunitPrice())) {
                        wareVo.setSunitPrice(new BigDecimal(cPrice.getSunitPrice()));
                        wareVo.setMinPfPriceType(3);
                        if (StrUtil.isNumberNullOrZero(cPrice.getSaleAmt())) {
                            wareVo.setWareDj(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getSunitPrice().doubleValue()));
                            wareVo.setPfPriceType(3);
                        }
                    }

                    if (!StrUtil.isNumberNullOrZero(cPrice.getLsPrice())) {
                        wareVo.setLsPrice(cPrice.getLsPrice());
                        wareVo.setLsPriceType(3);
                        if (StrUtil.isNumberNullOrZero(cPrice.getMinLsPrice())) {
                            wareVo.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), cPrice.getLsPrice().doubleValue()));
                            wareVo.setMinLsPriceType(3);
                        }
                    }

                    if (!StrUtil.isNumberNullOrZero(cPrice.getMinLsPrice())) {
                        wareVo.setMinLsPrice(cPrice.getMinLsPrice());
                        wareVo.setMinLsPriceType(3);
                        if (StrUtil.isNumberNullOrZero(cPrice.getLsPrice())) {
                            wareVo.setLsPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getMinLsPrice().doubleValue()));
                            wareVo.setLsPriceType(3);
                        }
                    }

                    if (!StrUtil.isNumberNullOrZero(cPrice.getCxPrice())) {
                        wareVo.setCxPrice(cPrice.getCxPrice());
                        wareVo.setCxPriceType(3);
                        if (StrUtil.isNumberNullOrZero(cPrice.getMinCxPrice())) {
                            wareVo.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), cPrice.getCxPrice().doubleValue()));
                            wareVo.setMinCxPriceType(3);
                        }
                    }

                    if (!StrUtil.isNumberNullOrZero(cPrice.getMinCxPrice())) {
                        wareVo.setMinCxPrice(cPrice.getMinCxPrice());
                        wareVo.setMinCxPriceType(3);
                        if (StrUtil.isNumberNullOrZero(cPrice.getCxPrice())) {
                            wareVo.setCxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getMinCxPrice().doubleValue()));
                            wareVo.setCxPriceType(3);
                        }
                    }

                    if (!StrUtil.isNumberNullOrZero(cPrice.getFxPrice())) {
                        wareVo.setFxPrice(cPrice.getFxPrice());
                        wareVo.setFxPriceType(3);
                        if (StrUtil.isNumberNullOrZero(cPrice.getMinFxPrice())) {
                            wareVo.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), cPrice.getFxPrice().doubleValue()));
                            wareVo.setMinFxPriceType(3);
                        }
                    }

                    if (!StrUtil.isNumberNullOrZero(cPrice.getMinFxPrice())) {
                        wareVo.setMinFxPrice(cPrice.getMinFxPrice());
                        wareVo.setMinFxPriceType(3);
                        if (StrUtil.isNumberNullOrZero(cPrice.getFxPrice())) {
                            wareVo.setFxPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getMinFxPrice().doubleValue()));
                            wareVo.setFxPriceType(3);
                        }
                    }

                    if (!StrUtil.isNumberNullOrZero(cPrice.getMaxHisPfPrice())) {
                        wareVo.setMaxHisPfPrice(cPrice.getMaxHisPfPrice());
                        if (StrUtil.isNumberNullOrZero(cPrice.getMinHisPfPrice())) {
                            wareVo.setMinHisPfPrice(StrUtil.ConvertUnitBigToSmall(wareVo.getHsNum(), cPrice.getMaxHisPfPrice().doubleValue()));
                        }
                    }
                    if (!StrUtil.isNumberNullOrZero(cPrice.getMinHisPfPrice())) {
                        wareVo.setMinHisPfPrice(cPrice.getMinHisPfPrice());
                        if (StrUtil.isNumberNullOrZero(cPrice.getMaxHisPfPrice())) {
                            wareVo.setMaxHisPfPrice(StrUtil.ConvertUnitSmallToBig(wareVo.getHsNum(), cPrice.getMinHisPfPrice().doubleValue()));
                        }
                    }
//						System.out.println(wareVo.getWareId()+":"+wareVo.getWareDj()+":"+wareVo.getSunitPrice()+":"
//								+wareVo.getLsPrice()+":"+wareVo.getMinLsPrice()+":"+wareVo.getCxPrice()+":"+wareVo.getMinCxPrice()+":"
//								+wareVo.getFxPrice()+":"+wareVo.getMinFxPrice());
                    break;
                }
            }
        }
    }

    public void loadCustomerPrice(SysWare sysWare, SysLoginInfo info, String customerId, String... o) {
        try {

            sysWare.setPfPriceType(0);
            sysWare.setLsPriceType(0);
            sysWare.setFxPriceType(0);
            sysWare.setCxPriceType(0);
            sysWare.setMinPfPriceType(0);
            sysWare.setMinLsPriceType(0);
            sysWare.setMinFxPriceType(0);
            sysWare.setMinCxPriceType(0);
            if (!StrUtil.isNumberNullOrZero(sysWare.getWareDj())) {
                BigDecimal saleAmt = new BigDecimal(sysWare.getWareDj());
                if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                    sysWare.setWareDj(Double.valueOf(saleAmt.toString()));
                    if (StrUtil.isNumberNullOrZero(sysWare.getSunitPrice())) {
                        sysWare.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), saleAmt.doubleValue())).setScale(3, BigDecimal.ROUND_HALF_DOWN));
                    }
                }

            }
            if (!StrUtil.isNumberNullOrZero(sysWare.getSunitPrice())) {
                sysWare.setSunitPrice(sysWare.getSunitPrice());
                if (StrUtil.isNumberNullOrZero(sysWare.getWareDj())) {
                    sysWare.setWareDj(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), sysWare.getSunitPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(sysWare.getLsPrice())) {
                sysWare.setLsPrice(sysWare.getLsPrice());
                if (StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
                    sysWare.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), sysWare.getLsPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
                sysWare.setMinLsPrice(sysWare.getMinLsPrice());
                if (StrUtil.isNumberNullOrZero(sysWare.getLsPrice())) {
                    sysWare.setLsPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), sysWare.getMinLsPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(sysWare.getCxPrice())) {
                sysWare.setCxPrice(sysWare.getCxPrice());
                if (StrUtil.isNumberNullOrZero(sysWare.getMinCxPrice())) {
                    sysWare.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), sysWare.getCxPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(sysWare.getMinCxPrice())) {
                sysWare.setMinCxPrice(sysWare.getMinCxPrice());
                if (StrUtil.isNumberNullOrZero(sysWare.getCxPrice())) {
                    sysWare.setCxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), sysWare.getMinCxPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(sysWare.getFxPrice())) {
                sysWare.setFxPrice(sysWare.getFxPrice());
                if (StrUtil.isNumberNullOrZero(sysWare.getMinFxPrice())) {
                    sysWare.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), sysWare.getFxPrice().doubleValue()));
                }
            }

            if (!StrUtil.isNumberNullOrZero(sysWare.getMinFxPrice())) {
                sysWare.setMinFxPrice(sysWare.getMinFxPrice());
                if (StrUtil.isNumberNullOrZero(sysWare.getFxPrice())) {
                    sysWare.setFxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), sysWare.getMinFxPrice().doubleValue()));
                }
            }


            sysWare.setTempWareDj(sysWare.getLsPrice());
            //sysWare.setTempSunitPrice(new BigDecimal(0));
            if (!StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
                sysWare.setTempSunitPrice(new BigDecimal(sysWare.getMinLsPrice()));
            }

            if (StrUtil.isNumberNullOrZero(sysWare.getWareDj())) {
                if (!StrUtil.isNumberNullOrZero(sysWare.getLsPrice())) {
                    sysWare.setWareDj(sysWare.getLsPrice());
                    if (StrUtil.isNumberNullOrZero(sysWare.getSunitFront())) {
                        sysWare.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), sysWare.getWareDj())));
                    }
                }
                if (!StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())) {
                    sysWare.setSunitPrice(new BigDecimal(sysWare.getMinLsPrice()));
                    if (StrUtil.isNumberNullOrZero(sysWare.getWareDj())) {
                        sysWare.setWareDj(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), sysWare.getSunitFront().doubleValue()));
                    }
                }
            }

            String waretypePath = this.waretypeDao.queryWarePath(sysWare.getWaretype(), info.getDatasource());
            SysCustomer sysCustomer = this.customerDao.queryCustomerById(info.getDatasource(), Integer.valueOf(customerId));
            if (sysCustomer != null && (!StrUtil.isNull(sysCustomer.getQdtpNm()) || !StrUtil.isNull(sysCustomer.getQdtypeId()))) {
                SysQdtype typep = new SysQdtype();
                typep.setQdtpNm(sysCustomer.getQdtpNm());
                Integer typeId = null;
                if (!StrUtil.isNull(sysCustomer.getQdtypeId())) {
                    typeId = sysCustomer.getQdtypeId();
                    typep = this.qdtypeDao.queryQdtypeById(typeId, info.getDatasource());
                } else {
                    if (sysCustomer.getQdtpNm() != "null") {
                        List<SysQdtype> alist = qdtypeDao.queryList(typep, info.getDatasource());
                        if (alist != null && alist.size() > 0) {
                            typeId = alist.get(0).getId();
                            typep = alist.get(0);
                        }
                    }
                }
                List<SysQdTypePrice> typeList = new ArrayList<SysQdTypePrice>();
                if (!StrUtil.isNull(typeId)) {
                    SysQdTypePrice typePrice = new SysQdTypePrice();
                    typePrice.setRelaId(typeId);
                    typePrice.setWareId(sysWare.getWareId());
                    typeList = qdTypePriceDao.queryList(typePrice, info.getDatasource(), "");
                }


                //=========设置客户类型中的销售折扣率===========
                if (typep != null && !StrUtil.isNumberNullOrZero(typep.getRate())) {
                    setSysWarePrice(typep.getRate(), sysWare);
                    sysWare.setPfPriceType(1);
                    sysWare.setMinPfPriceType(1);
                }
                //=========设置客户类型中的销售折扣率===========

                List<SysQdTypeRate> typeRateList = new ArrayList<SysQdTypeRate>();
                if (!StrUtil.isNull(typeId)) {
                    SysQdTypeRate typeRate = new SysQdTypeRate();
                    typeRate.setRelaId(typeId);
                    //折扣率
                    typeRateList = qdTypeRateDao.queryList(typeRate, info.getDatasource(), "");
                }
                if (typeRateList != null && typeRateList.size() > 0) {//折扣率
                    BigDecimal rate = new BigDecimal(0);
                    for (int j = 0; j < typeRateList.size(); j++) {
                        SysQdTypeRate typeRate1 = typeRateList.get(j);
                        String wareTypeId = "-" + typeRate1.getWaretypeId() + "-";
                        if (waretypePath.contains(wareTypeId)) {
                            rate = typeRate1.getRate();
                        }
                    }
                    if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
                        setSysWarePrice(rate, sysWare);
                        sysWare.setPfPriceType(1);
                        sysWare.setMinPfPriceType(1);
                    }
                }

                if (typeList != null) {
                    for (int j = 0; j < typeList.size(); j++) {
                        SysQdTypePrice type = typeList.get(j);
                        BigDecimal rate = type.getRate();
                        if (!StrUtil.isNull(sysWare.getWareId()) && !StrUtil.isNull(type.getWareId())) {
                            if (sysWare.getWareId().equals(type.getWareId())) {
                                if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
                                    setSysWarePrice(rate, sysWare);
                                    sysWare.setPfPriceType(1);
                                    sysWare.setMinPfPriceType(1);
                                }
                                if (!StrUtil.isNumberNullOrZero(type.getPrice()) && StrUtil.isNumeric(type.getPrice())) {
                                    BigDecimal saleAmt = new BigDecimal(type.getPrice());
                                    if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                                        sysWare.setWareDj(Double.valueOf(saleAmt.toString()));
                                        sysWare.setPfPriceType(1);
                                        if (StrUtil.isNumberNullOrZero(type.getSunitPrice())) {
                                            sysWare.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), saleAmt.doubleValue())));
                                            sysWare.setMinPfPriceType(1);
                                        }
                                    }

                                }
                                if (!StrUtil.isNumberNullOrZero(type.getSunitPrice())) {
                                    sysWare.setSunitPrice(new BigDecimal(type.getSunitPrice()));
                                    sysWare.setMinPfPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getPrice())) {
                                        sysWare.setWareDj(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), type.getSunitPrice().doubleValue()));
                                        sysWare.setPfPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getLsPrice())) {
                                    sysWare.setLsPrice(type.getLsPrice());
                                    sysWare.setLsPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getMinLsPrice())) {
                                        sysWare.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), type.getLsPrice().doubleValue()));
                                        sysWare.setMinLsPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getMinLsPrice())) {
                                    sysWare.setMinLsPrice(type.getMinLsPrice());
                                    sysWare.setMinLsPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getLsPrice())) {
                                        sysWare.setLsPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), type.getMinLsPrice().doubleValue()));
                                        sysWare.setLsPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getCxPrice())) {
                                    sysWare.setCxPrice(type.getCxPrice());
                                    sysWare.setCxPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getMinCxPrice())) {
                                        sysWare.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), type.getCxPrice().doubleValue()));
                                        sysWare.setMinCxPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getMinCxPrice())) {
                                    sysWare.setMinCxPrice(type.getMinCxPrice());
                                    sysWare.setMinCxPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getCxPrice())) {
                                        sysWare.setCxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), type.getMinCxPrice().doubleValue()));
                                        sysWare.setCxPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getFxPrice())) {
                                    sysWare.setFxPrice(type.getFxPrice());
                                    sysWare.setFxPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getMinFxPrice())) {
                                        sysWare.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), type.getFxPrice().doubleValue()));
                                        sysWare.setMinFxPriceType(1);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(type.getMinFxPrice())) {
                                    sysWare.setMinFxPrice(type.getMinFxPrice());
                                    sysWare.setMinFxPriceType(1);
                                    if (StrUtil.isNumberNullOrZero(type.getFxPrice())) {
                                        sysWare.setFxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), type.getMinFxPrice().doubleValue()));
                                        sysWare.setFxPriceType(1);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (sysCustomer != null && (!StrUtil.isNull(sysCustomer.getKhdjNm()) || !StrUtil.isNull(sysCustomer.getKhlevelId()))) {
                Integer levelId = null;
                SysKhlevel levelp = new SysKhlevel();
                if (!StrUtil.isNull(sysCustomer.getKhlevelId())) {
                    levelId = sysCustomer.getKhlevelId();
                    levelp = this.khlevelDao.querykhlevelById(sysCustomer.getKhlevelId(), info.getDatasource());
                } else {
                    if (sysCustomer.getKhdjNm() != "null") {
                        levelp.setKhdjNm(sysCustomer.getKhdjNm());
                        List<SysKhlevel> alist = khlevelDao.queryList(levelp, info.getDatasource());
                        if (alist != null && alist.size() > 0) {
                            levelId = alist.get(0).getId();
                        }
                    }
                }
                List<SysCustomerLevelPrice> levelList = new ArrayList<SysCustomerLevelPrice>();
                if (!StrUtil.isNull(levelId)) {
                    SysCustomerLevelPrice levelPrice = new SysCustomerLevelPrice();
                    levelPrice.setLevelId(levelId);
                    levelPrice.setWareId(sysWare.getWareId());
                    levelList = customerLevelPriceDao.queryList(levelPrice, info.getDatasource(), "");
                }
                List<SysCustomerLevelRate> levelRateList = new ArrayList<SysCustomerLevelRate>();
                if (!StrUtil.isNull(levelId)) {
                    SysCustomerLevelRate levelRate = new SysCustomerLevelRate();
                    levelRate.setRelaId(levelId);
                    levelRateList = customerLevelRateDao.queryList(levelRate, info.getDatasource(), "");
                }

                if (levelRateList != null & levelRateList.size() > 0) {
                    BigDecimal rate = new BigDecimal(0);
                    for (int j = 0; j < levelRateList.size(); j++) {
                        SysCustomerLevelRate levelRate1 = levelRateList.get(j);
                        String wareTypeId = "-" + levelRate1.getWaretypeId() + "-";
                        if (waretypePath.contains(wareTypeId)) {
                            rate = levelRate1.getRate();
                        }
                    }
                    if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
                        setSysWarePrice(rate, sysWare);
                        sysWare.setPfPriceType(2);
                        sysWare.setMinPfPriceType(2);
                    }
                }


                if (levelList != null) {
                    for (int j = 0; j < levelList.size(); j++) {
                        SysCustomerLevelPrice level = levelList.get(j);
                        if (!StrUtil.isNull(sysWare.getWareId()) && !StrUtil.isNull(level.getWareId())) {
                            if (sysWare.getWareId().equals(level.getWareId())) {
                                if (!StrUtil.isNumberNullOrZero(level.getPrice()) && StrUtil.isNumeric(level.getPrice())) {
                                    BigDecimal saleAmt = new BigDecimal(level.getPrice());
                                    if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                                        sysWare.setWareDj(Double.valueOf(saleAmt.toString()));
                                        sysWare.setPfPriceType(2);
                                        if (StrUtil.isNumberNullOrZero(level.getSunitPrice())) {
                                            sysWare.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), saleAmt.doubleValue())));
                                            sysWare.setMinPfPriceType(2);
                                        }
                                    }
                                }
                                if (!StrUtil.isNumberNullOrZero(level.getSunitPrice())) {
                                    sysWare.setSunitPrice(new BigDecimal(level.getSunitPrice()));
                                    sysWare.setMinPfPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getPrice())) {
                                        sysWare.setWareDj(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), level.getSunitPrice().doubleValue()));
                                        sysWare.setPfPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getLsPrice())) {
                                    sysWare.setLsPrice(level.getLsPrice());
                                    sysWare.setLsPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getMinLsPrice())) {
                                        sysWare.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), level.getLsPrice().doubleValue()));
                                        sysWare.setMinLsPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getMinLsPrice())) {
                                    sysWare.setMinLsPrice(level.getMinLsPrice());
                                    sysWare.setMinLsPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getLsPrice())) {
                                        sysWare.setLsPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), level.getMinLsPrice().doubleValue()));
                                        sysWare.setLsPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getCxPrice())) {
                                    sysWare.setCxPrice(level.getCxPrice());
                                    sysWare.setCxPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getMinCxPrice())) {
                                        sysWare.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), level.getCxPrice().doubleValue()));
                                        sysWare.setMinCxPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getMinCxPrice())) {
                                    sysWare.setMinCxPrice(level.getMinCxPrice());
                                    sysWare.setMinCxPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getCxPrice())) {
                                        sysWare.setCxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), level.getMinCxPrice().doubleValue()));
                                        sysWare.setCxPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getFxPrice())) {
                                    sysWare.setFxPrice(level.getFxPrice());
                                    if (StrUtil.isNumberNullOrZero(level.getMinFxPrice())) {
                                        sysWare.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), level.getFxPrice().doubleValue()));
                                        sysWare.setFxPriceType(2);
                                    }
                                }

                                if (!StrUtil.isNumberNullOrZero(level.getMinFxPrice())) {
                                    sysWare.setMinFxPrice(level.getMinFxPrice());
                                    sysWare.setMinFxPriceType(2);
                                    if (StrUtil.isNumberNullOrZero(level.getFxPrice())) {
                                        sysWare.setFxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), level.getMinFxPrice().doubleValue()));
                                        sysWare.setFxPriceType(2);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            SysCustomerPrice sysCustomerPrice = new SysCustomerPrice();
            sysCustomerPrice.setCustomerId(Integer.valueOf(customerId));
            sysCustomerPrice.setWareId(sysWare.getWareId());
            List<SysCustomerPrice> cpList = this.customerDao.listSysCustomerPrice(info.getDatasource(), sysCustomerPrice);
            if (cpList != null) {
                for (int j = 0; j < cpList.size(); j++) {
                    SysCustomerPrice cPrice = cpList.get(j);
                    if (!StrUtil.isNull(sysWare.getWareId()) && !StrUtil.isNull(cPrice.getWareId())) {
                        if (sysWare.getWareId().equals(cPrice.getWareId())) {
                            if (!StrUtil.isNumberNullOrZero(cPrice.getSaleAmt())) {
                                BigDecimal saleAmt = cPrice.getSaleAmt();
                                sysWare.setPfPriceType(3);
                                if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                                    sysWare.setWareDj(Double.valueOf(saleAmt.toString()));
                                    if (StrUtil.isNumberNullOrZero(cPrice.getSunitPrice())) {
                                        sysWare.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), saleAmt.doubleValue())));
                                        sysWare.setMinPfPriceType(3);
                                    }
                                }
                            }
                            if (!StrUtil.isNumberNullOrZero(cPrice.getSunitPrice())) {
                                sysWare.setSunitPrice(new BigDecimal(cPrice.getSunitPrice()));
                                sysWare.setMinPfPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getSaleAmt())) {
                                    sysWare.setWareDj(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), cPrice.getSunitPrice().doubleValue()));
                                    sysWare.setPfPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getLsPrice())) {
                                sysWare.setLsPrice(cPrice.getLsPrice());
                                sysWare.setLsPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinLsPrice())) {
                                    sysWare.setMinLsPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), cPrice.getLsPrice().doubleValue()));
                                    sysWare.setMinLsPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinLsPrice())) {
                                sysWare.setMinLsPrice(cPrice.getMinLsPrice());
                                sysWare.setMinLsPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getLsPrice())) {
                                    sysWare.setLsPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), cPrice.getMinLsPrice().doubleValue()));
                                    sysWare.setLsPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getCxPrice())) {
                                sysWare.setCxPrice(cPrice.getCxPrice());
                                sysWare.setCxPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinCxPrice())) {
                                    sysWare.setMinCxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), cPrice.getCxPrice().doubleValue()));
                                    sysWare.setMinCxPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinCxPrice())) {
                                sysWare.setMinCxPrice(cPrice.getMinCxPrice());
                                sysWare.setMinCxPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getCxPrice())) {
                                    sysWare.setCxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), cPrice.getMinCxPrice().doubleValue()));
                                    sysWare.setCxPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getFxPrice())) {
                                sysWare.setFxPrice(cPrice.getFxPrice());
                                sysWare.setFxPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinFxPrice())) {
                                    sysWare.setMinFxPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), cPrice.getFxPrice().doubleValue()));
                                    sysWare.setMinFxPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinFxPrice())) {
                                sysWare.setMinFxPrice(cPrice.getMinFxPrice());
                                sysWare.setMinFxPriceType(3);
                                if (StrUtil.isNumberNullOrZero(cPrice.getFxPrice())) {
                                    sysWare.setFxPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), cPrice.getMinFxPrice().doubleValue()));
                                    sysWare.setFxPriceType(3);
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getMaxHisGyPrice())) {
                                sysWare.setMaxHisGyPrice(cPrice.getMaxHisGyPrice());
                                cPrice.setMaxHisPfPrice(cPrice.getMaxHisGyPrice());
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinHisGyPrice())) {
                                    sysWare.setMinHisGyPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), cPrice.getMaxHisGyPrice().doubleValue()));
                                }
                            }
                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinHisGyPrice())) {
                                sysWare.setMinHisGyPrice(cPrice.getMinHisGyPrice());
                                cPrice.setMinHisPfPrice(cPrice.getMinHisGyPrice());
                                if (StrUtil.isNumberNullOrZero(cPrice.getMaxHisGyPrice())) {
                                    sysWare.setMaxHisGyPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), cPrice.getMinHisGyPrice().doubleValue()));
                                }
                            }

                            if (!StrUtil.isNumberNullOrZero(cPrice.getMaxHisPfPrice())) {
                                sysWare.setMaxHisPfPrice(cPrice.getMaxHisPfPrice());
                                if (StrUtil.isNumberNullOrZero(cPrice.getMinHisPfPrice())) {
                                    sysWare.setMinHisPfPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), cPrice.getMaxHisPfPrice().doubleValue()));
                                }
                            }
                            if (!StrUtil.isNumberNullOrZero(cPrice.getMinHisPfPrice())) {
                                sysWare.setMinHisPfPrice(cPrice.getMinHisPfPrice());
                                if (StrUtil.isNumberNullOrZero(cPrice.getMaxHisPfPrice())) {
                                    sysWare.setMaxHisPfPrice(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), cPrice.getMinHisPfPrice().doubleValue()));
                                }
                            }
                        }
                    }
                }
            }


            if (!StrUtil.isNull(o)) {
                if (o.length > 0 && "1".equals(o[0])) {
                    /*是否开启了自动设置历史价格*/
                    SysConfig config = this.configService.querySysConfigByCode("CONFIG_SHOP_SYC_JXC_HIS_PRICE", info.getDatasource());
                    //假如开启了历史价，则把对应的执行价置为历史价
                    if (config != null && "1".equals(config.getStatus())) {
                        if (!StrUtil.isNumberNullOrZero(sysWare.getMaxHisPfPrice())) {
                            sysWare.setWareDj(sysWare.getMaxHisPfPrice());
                        }
                        if (!StrUtil.isNumberNullOrZero(sysWare.getMinHisPfPrice())) {
                            sysWare.setSunitPrice(new BigDecimal(sysWare.getMinHisPfPrice()));
                        }
                    }
                }
            }

            SysConfig config = this.configService.querySysConfigByCode("CONFIG_NOUSE_NEW_HIS_PRICE", info.getDatasource());
            if (config != null && "1".equals(config.getStatus())) {
            } else {
                Map<String, Object> wareHisMap = this.customerDao.queryCustomerHisWarePrice(info.getDatasource(), Integer.valueOf(customerId), sysWare.getWareId());
                if (wareHisMap != null && wareHisMap.size() > 0) {
                    String beUnit = wareHisMap.get("be_unit") + "";
                    BigDecimal price = new BigDecimal("0.0");
                    BigDecimal minPrice = new BigDecimal("0.0");
                    Double hsNum = 1d;
                    if (!StrUtil.isNull(sysWare.getHsNum())) {
                        hsNum = sysWare.getHsNum();
                    }
                    if ("S".equals(beUnit)) {
                        if (!StrUtil.isNull(wareHisMap.get("price"))) {
                            price = new BigDecimal(wareHisMap.get("price") + "");
                            minPrice = new BigDecimal(wareHisMap.get("price") + "");
                        }
                        price = price.multiply(new BigDecimal(hsNum));
                    } else {
                        if (!StrUtil.isNull(wareHisMap.get("price"))) {
                            price = new BigDecimal(wareHisMap.get("price") + "");
                            minPrice = price.divide(new BigDecimal(hsNum), 5, BigDecimal.ROUND_HALF_DOWN);
                        }

                    }
                    sysWare.setMaxHisPfPrice(price.doubleValue());
                    sysWare.setMinHisPfPrice(minPrice.doubleValue());
                }
            }

            Map<Integer, Map<Integer, BigDecimal>> awpMap = this.customerDao.queryAdjustWarePrice(info.getDatasource(), Integer.valueOf(customerId), null);
            if (awpMap != null) {
                Integer wareId = sysWare.getWareId();
                if (awpMap.containsKey(wareId)) {
                    Map<Integer, BigDecimal> oMap = awpMap.get(wareId);
                    if (oMap.containsKey(1)) {
                        sysWare.setWareDj(oMap.get(1).doubleValue());
                        sysWare.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), sysWare.getWareDj().doubleValue())));
                        if (!StrUtil.isNumberNullOrZero(sysWare.getMaxHisPfPrice())) {
                            //sysWare.setMaxHisPfPrice(oMap.get(1).doubleValue());
                        }
                        if (!StrUtil.isNumberNullOrZero(sysWare.getMinHisPfPrice())) {
                            // sysWare.setMinHisPfPrice(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(),sysWare.getWareDj().doubleValue()));
                        }
                        sysWare.setPfPriceType(4);
                        sysWare.setMinPfPriceType(4);
                    } else {
                        BigDecimal disPrice = oMap.get(2);
                        if (!StrUtil.isNumberNullOrZero(disPrice)) {
                            sysWare.setWareDj(sysWare.getWareDj() + disPrice.doubleValue());
                            Double minDisPrice = StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), disPrice.doubleValue());
                            sysWare.setSunitPrice(sysWare.getSunitPrice().add(new BigDecimal(minDisPrice)));
                            if (!StrUtil.isNumberNullOrZero(sysWare.getMaxHisPfPrice())) {
                                //sysWare.setMaxHisPfPrice(sysWare.getMaxHisPfPrice()+disPrice.doubleValue());
                            }
                            if (!StrUtil.isNumberNullOrZero(sysWare.getMinHisPfPrice())) {
                                //sysWare.setMinHisPfPrice(sysWare.getMinHisPfPrice()+minDisPrice);
                            }
                            sysWare.setPfPriceType(4);
                            sysWare.setMinPfPriceType(4);
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();

        }
    }


    /**
     * 按折扣率设置商品价格
     *
     * @param rate
     * @param sysWare
     */
    private void setSysWarePrice(BigDecimal rate, SysWare sysWare) {
        if (!StrUtil.isNull(rate) && rate.doubleValue() > 0) {
//            sysWare.setWareDj((sysWare.getTempWareDj() * rate.doubleValue()) / 100);
//            sysWare.setSunitPrice((sysWare.getTempSunitPrice().multiply(rate)).divide(new BigDecimal(100)));
            if (!StrUtil.isNumberNullOrZero(sysWare.getTempWareDj())) {
                BigDecimal saleAmt = new BigDecimal((sysWare.getTempWareDj() * rate.doubleValue()) / 100).setScale(3, BigDecimal.ROUND_HALF_DOWN);
                ;

                if (!StrUtil.isNumberNullOrZero(saleAmt)) {
                    sysWare.setWareDj(Double.valueOf(saleAmt.toString()));
                    if (StrUtil.isNumberNullOrZero(sysWare.getTempSunitPrice())) {
                        sysWare.setSunitPrice(new BigDecimal(StrUtil.ConvertUnitBigToSmall(sysWare.getHsNum(), saleAmt.doubleValue())));
                    }
                }
            }
            if (!StrUtil.isNumberNullOrZero(sysWare.getTempSunitPrice())) {
                BigDecimal saleAmt = sysWare.getTempSunitPrice().multiply(rate).divide(new BigDecimal(100)).setScale(3, BigDecimal.ROUND_HALF_DOWN);
                sysWare.setSunitPrice(saleAmt);
                if (StrUtil.isNumberNullOrZero(sysWare.getTempWareDj())) {
                    sysWare.setWareDj(StrUtil.ConvertUnitSmallToBig(sysWare.getHsNum(), saleAmt.doubleValue()));
                }
            }
        }
    }


    public List<BaseCustomer> queryAllBase(String database) {
        return this.customerDao.queryAllBase(database);
    }

    public Page queryNoneChainStoreCustomer(SysCustomer sysCustomer, int page, int rows, String database) {
        try {
            return this.customerDao.queryNoneChainStoreCustomer(sysCustomer, page, rows, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page queryChainStoreCustomer(SysCustomer sysCustomer, int shopId, int page, int rows, String database) {
        try {
            return this.customerDao.queryChainStoreCustomer(sysCustomer, shopId, page, rows, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int batchUAddChainStoreCustomer(String ids, Integer id, String database) {
        try {
            return this.customerDao.batchUAddChainStoreCustomer(ids, id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }

    public int batchRemoveChainStoreCustomer(String ids, String database) {
        try {
            return this.customerDao.batchRemoveChainStoreCustomer(ids, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }

    public SysCustomer querySysCustomerByRzMobile(String rzMobile, String database) {
        return this.customerDao.querySysCustomerByRzMobile(rzMobile, database);
    }


    /**
     * 客户导入
     *
     * @param list
     * @param info
     * @param taskId
     * @param requestParamMap
     */
    @Async
    @DataSourceAnnotation(companyId = "#info.fdCompanyId")
    public void addSysCustomerlsImport(List<ImportSysCustomerVo> list, SysLoginInfo info, String taskId, Map<String, String[]> requestParamMap) {
        ImportResults importResults = new ImportResults();
        long st = System.currentTimeMillis();
        try {
            //allocator.alloc(info.getDatasource(), info.getFdCompanyId());
            String replaceSysCustomer = CommonUtil.getMapOnlyValue(requestParamMap, "replaceSysCustomer");
            ProgressUtil progressUtil = new ProgressUtil(0, 99, list.size());
            Set<String> successImportVoSet = new HashSet<>();
            RegionExecutor regionExecutor = new RegionExecutor(info.getDatasource(), sysRegionService);

            int i = 0;
            for (ImportSysCustomerVo vo : list) {
                try {
                    i++;
                    if (vo == null) continue;
                    ValidationBeanUtil.ValidResult validResult = ValidationBeanUtil.validateBean(vo);
                    if (validResult.hasErrors()) {
                        importResults.setErrorMsg("第" + i + "行" + validResult.getErrors());
                        continue;
                    }
                    asyncProcessHandler.updateProgress(taskId, progressUtil.getCurrentRaised((i)), vo.getKhNm() + "正在处理");

                    SysMember member = null;
                    if (!StrUtil.isNull(vo.getMemberNm())) {
                        member = this.memberService.querySysDepartByNm(vo.getMemberNm(), info.getDatasource());
                        if (null == member) {
                            importResults.setErrorMsg("第" + i + "行,业务员“" + vo.getMemberNm() + "”不存在");
                            continue;
                        }
                    }
                    //如果客户存在时,覆盖所有不为空的字段
                    SysCustomer customer = querySysCustomerByName(info.getDatasource(), vo.getKhNm());
                    if (customer != null) {
                        if (StrUtil.isNull(replaceSysCustomer) || !Boolean.valueOf(replaceSysCustomer)) {
                            importResults.setOperationScript("<input class='dataVaildata' name='replaceSysCustomer' type='checkbox'>覆盖重名客户信息");
                            importResults.setErrorMsg("第" + i + "行" + vo.getKhNm() + "已存在");
                            importResults.addExistsNum();
                            continue;
                        }
                        if (StringUtils.isNotEmpty(vo.getTel()))
                            customer.setTel(vo.getTel());
                        if (StringUtils.isNotEmpty(vo.getMobile()))
                            customer.setMobile(vo.getMobile());
                        if (StringUtils.isNotEmpty(vo.getLinkman()))
                            customer.setLinkman(vo.getLinkman());
                        if (StringUtils.isNotEmpty(vo.getAddress()))
                            customer.setAddress(vo.getAddress());
                        if (StringUtils.isNotEmpty(vo.getLongitude()))
                            customer.setLongitude(vo.getLongitude());
                        if (StringUtils.isNotEmpty(vo.getLatitude()))
                            customer.setLatitude(vo.getLatitude());
                        //业务员
                        if (member != null) {
                            customer.setMemId(member.getMemberId());
                        /*customer.setOrgEmpId(member.getMemberId());
                        customer.setOrgEmpNm(member.getMemberNm());*/
                            customer.setBranchId(member.getBranchId());
                        }
                        if (StrUtil.isNull(customer.getLatitude())) {
                            customer.setLatitude("0");
                        }
                        if (StrUtil.isNull(customer.getLongitude())) {
                            customer.setLongitude("0");
                        }
                        if (StrUtil.isNull(customer.getKhCode())) {
                            customer.setKhCode("" + "x" + "" + customer.getId());
                        }
                        if (StringUtils.isNotEmpty(vo.getRegionStr()))
                            customer.setRegionId(regionExecutor.getRegiionId(vo.getRegionStr()));

                        addressLatLngService.handleCustomer(customer); //如果地址不为空并经纬度不为空时去百度获取经纬度
                        updateCustomer(customer, info.getDatasource(), "", info);
                    } else {
                        Integer memberId = null;
                        Integer branchId = null;
                        String memberNm = null;
                        if (member != null) {
                            memberId = member.getMemberId();
                            branchId = member.getBranchId();
                            memberNm = member.getMemberNm();
                        }
                        SysCustomer sysCustomer = mapper.map(vo, SysCustomer.class);
                        sysCustomer.setMemId(memberId);
                        sysCustomer.setBranchId(branchId);
                        sysCustomer.setOrgEmpNm(memberNm);
                        sysCustomer.setOrgEmpId(memberId);
                        sysCustomer.setPy(ChineseCharToEnUtil.getFirstSpell(vo.getKhNm()));
                        sysCustomer.setId(null);
                        sysCustomer.setLongitude(vo.getLongitude());
                        sysCustomer.setLatitude(vo.getLatitude());
                        sysCustomer.setRegionId(regionExecutor.getRegiionId(vo.getRegionStr()));
                        addressLatLngService.handleCustomer(sysCustomer); //如果地址不为空并经纬度不为空时去百度获取经纬度
                        addCustomer(sysCustomer, info.getDatasource());
                    }
                    importResults.addSuccessNum();
                    successImportVoSet.add(vo.getId() + "");
                } catch (Exception ex) {
                    importResults.setErrorMsg(vo.getKhNm() + "导入出现错误" + ex.getMessage());
                }
            }
            //修改数据为已导入成功标记
            if (Collections3.isNotEmpty(successImportVoSet)) {
                sysInportTempService.updateItemImportSuccess(String.join(",", successImportVoSet), info.getDatasource());
            }
        } finally {
            importResults.setSuccessMsg(st);
            asyncProcessHandler.doneTask(taskId, JsonUtil.toJson(importResults));
        }
    }

    /**
     * @param database
     * @param customerId 100
     * @param wareIds    1001,1002
     * @return 1001 商品ID
     * :{
     * 1:2表示提价，1：表示最新销售价
     * 2 提价2元
     * }
     */
    public Map<Integer, Map<Integer, BigDecimal>> queryAdjustWarePrice(String database, Integer customerId, String wareIds) throws Exception {
        return this.customerDao.queryAdjustWarePrice(database, customerId, wareIds);
    }

    public void deleteCustomerPriceByIds(String database, String customerIds) {
        this.customerDao.deleteCustomerPriceByIds(database, customerIds);
    }

    /**
     * 认证商城手机
     */
    public int updateRzShopMobile(String newMobile, Integer id, SysLoginInfo info) {
        SysCustomer customer = queryCustomerById(info.getDatasource(), id);
        int i = customerDao.updateRzShopMobile(newMobile, id, info.getDatasource());
        if (i > 0) {
            memberPublisher.customerRzMobileChange(customer.getRzMobile(), newMobile, id, customer.getKhNm(), info);
        }
        return i;
    }
    /**
     * 查找没有地址的客户
     */
    public List<SysCustomer> queryCustomerListByHasLatLngNoAddress(String database){
        return this.customerDao.queryCustomerListByHasLatLngNoAddress(database);
    }
    /**
     * 查找没有经纬度的客户
     */
    public List<SysCustomer> queryCustomerListByHasAddressNoLatLng(String database){
        return this.customerDao.queryCustomerListByHasAddressNoLatLng(database);
    }
}
