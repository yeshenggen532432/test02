package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.common.CommonUtil;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportResults;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportWareInPriceVo;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.utils.BaseWareTypeExecutor;
import com.qweib.cloud.biz.system.utils.ProgressUtil;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.PosUpdateLogDao;
import com.qweib.cloud.repository.SysWareDao;
import com.qweib.cloud.repository.SysWarePicWebDao;
import com.qweib.cloud.utils.*;
import com.qweibframework.async.handler.AsyncProcessHandler;
import com.qweibframework.commons.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.*;

@Slf4j
@Service
public class SysWareService {
    @Autowired
    private SysWareDao wareDao;

    @Autowired
    private SysWarePicWebDao wareWebPicDao;
    @Resource
    private SysConfigService configService;
    @Resource
    private SysWaretypeService productTypeService;
    @Resource
    private SysInportTempService sysInportTempService;
    @Resource
    private AsyncProcessHandler asyncProcessHandler;

    @Resource
    private PosUpdateLogDao posUpdateLogDao;


    public Page queryWare(SysWare ware, int page, int rows, String database) {
        try {
            return this.wareDao.queryWare(ware, page, rows, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page queryWareSpec(SysWare ware, int page, int rows, String database) {
        try {
            return this.wareDao.queryWareSpec(ware, page, rows, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page wareAttributePage(int page, int rows, String database) {
        try {
            return this.wareDao.wareAttributePage(page, rows, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page page2(SysWare ware, int page, int rows, String database, Integer brandId, Integer type) {
        try {
            return this.wareDao.page2(ware, page, rows, database, brandId, type);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page dialogShopWareTypePage(SysWare ware, int page, int rows, String database, Integer[] waretypeId) {
        try {
            return this.wareDao.dialogShopWareTypePage(ware, page, rows, database, waretypeId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    public int batchUpdateShopWareBrand(String ids, Integer brandId, String database) {
        try {
            return this.wareDao.batchUpdateShopWareBrand(ids, brandId, database);

        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int batchUpdateShopWaretypeId(String ids, Integer typeId, String database) {
        try {
            return this.wareDao.batchUpdateShopWaretypeId(ids, typeId, database);

        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysWare> queryList(SysWare ware, String database) {
        try {
            return this.wareDao.queryList(ware, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateBatchWare(String ids, Integer wareType, String database) {
        try {
            return this.wareDao.updateBatchWare(ids, wareType, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysWare> queryListByIds(String ids, String database) {
        try {
            return this.wareDao.queryList(ids, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateWareStatus(String database, Integer id, String status) {
        return this.wareDao.updateWareStatus(database, id, status);
    }


    public int addWare(SysWare ware, String database) {
        try {
            //py:拼音
            String py = "";
            if (ware != null) {
                py = ware.getPy();
                if (StrUtil.isNull(py)) {
                    py = ChineseCharToEnUtil.getFirstSpell(ware.getWareNm());
                }
            }
            ware.setPy(py);
            int i = this.wareDao.addWare(ware, database);
            this.posUpdateLogDao.saveUpdateDetail(i,database);//标志更新
            this.posUpdateLogDao.addUpdateLog1("商品信息",database);
            //图片
            List<SysWarePic> picList = ware.getWarePicList();
            if (picList != null && picList.size() > 0) {
                for (int k = 0; k < picList.size(); k++) {
                    picList.get(k).setWareId(i);
                    this.wareWebPicDao.addWarePic(picList.get(k), database);
                }
            }
            return i;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysWare queryWareByCode(String wareCode, String database) {
        return this.wareDao.queryWareByCode(wareCode, database);
    }

    public SysWare queryWareByName(String wareNm, String database) {
        return this.wareDao.queryWareByName(wareNm, database);
    }

    /**
     * 摘要：
     *
     * @说明：根据商品id获取商品信息
     * @创建：作者:llp 创建时间：2016-3-22 @修改历史： [序号](llp 2016-3-22)<修改说明>
     */
    public SysWare queryWareById(Integer wareId, String database) {
        try {
            SysWare sysWare = this.wareDao.queryWareById(wareId, database);
            SysWarePic swp = new SysWarePic();
            swp.setWareId(wareId);
            List<SysWarePic> warePicList = wareWebPicDao.queryWarePic(database, swp);
            if (warePicList != null) {
                sysWare.setWarePicList(warePicList);
            }
            return sysWare;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysWareGroup queryAttributeById(Integer id, String database) {
        return this.wareDao.queryAttributeById(id, database);
    }

    public Page queryWarePageByKeyWord(String keyWord, String database, Integer page, Integer limit) {
        Page p  = this.wareDao.queryWarePageByKeyWord(keyWord, database, page, limit);
        return p;
    }

    public Integer queryWareMaxId(String database) {
        return this.wareDao.queryWareMaxId(database);
    }

    /**
     * 摘要：
     *
     * @说明：修改商品
     * @创建：作者:llp 创建时间：2016-3-22 @修改历史： [序号](llp 2016-3-22)<修改说明>
     */
    public int updateWare(SysWare ware, String delPicIds, String database) {
        try {
            String py = "";
            if (ware != null) {
                py = ChineseCharToEnUtil.getFirstSpell(ware.getWareNm());
            }
            ware.setPy(py);
            SysWarePic warePic = new SysWarePic();
            warePic.setWareId(ware.getWareId());
            if (!StrUtil.isNull(delPicIds)) {
                List<SysWarePic> list = this.wareWebPicDao.queryWarePic(database, warePic);
                if (list.size() > 0) {
                    FileUtil fileUtil = new FileUtil();
                    String path = CnlifeConstants.url() + "upload/ware/pic";
                    delPicIds = "," + delPicIds + ",";
                    for (int i = 0; i < list.size(); i++) {
                        String picId = "," + list.get(i).getId() + ",";
                        if (delPicIds.contains(picId)) {
                            String paths = path + list.get(i).getPicMini();
                            String picPath = path + list.get(i).getPic();
                            //删除图片
                            if (fileUtil.ifExist(paths)) {
                                fileUtil.deleteFile(paths);
                                fileUtil.deleteFile(picPath);
                            }
                            this.wareWebPicDao.deleteWarePic(database, list.get(i));
                        }
                    }
                }
            }
            List<SysWarePic> warePicList = ware.getWarePicList();
            if (warePicList != null) {
                if (warePicList.size() > 0) {
                    for (int i = 0; i < warePicList.size(); i++) {
                        warePicList.get(i).setWareId(ware.getWareId());
                        this.wareWebPicDao.addWarePic(warePicList.get(i), database);
                    }
                }
            }
            this.posUpdateLogDao.saveUpdateDetail(ware.getWareId(),database);//标志更新
            this.posUpdateLogDao.addUpdateLog1("商品信息",database);
            return this.wareDao.updateWare(ware, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateWare(SysWare ware, String database) {
        try {
            String py = "";
            if (ware != null) {
                py = ChineseCharToEnUtil.getFirstSpell(ware.getWareNm());
                ware.setPy(py);
            }
            return this.wareDao.updateWare(ware, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateWareAttribute(String attribute, String database, Integer wareId) {
        return this.wareDao.updateWareAttribute(attribute, database, wareId);
    }

    /**
     * 摘要：
     *
     * @说明：删除商品
     * @创建：作者:llp 创建时间：2016-3-22 @修改历史： [序号](llp 2016-3-22)<修改说明>
     */
    public int deleteWare(Integer wareId, String database) {
        try {

            return this.wareDao.deleteWare(wareId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @return @修改历史： [序号](llp 2016-3-22)<修改说明>
     * @说明：判断商品名称唯一
     * @创建：作者:llp 创建时间：2016-3-22
     */
    public int queryWareNmCount(String wareNm, String database) {
        try {
            return this.wareDao.queryWareNmCount(wareNm, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @return @修改历史： [序号](llp 2016-3-22)<修改说明>
     * @说明：判断商品编码唯一
     * @创建：作者:llp 创建时间：2016-3-22
     */
    public int queryWareCodeCount(String wareCode, String database) {
        try {
            return this.wareDao.queryWareCodeCount(wareCode, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Integer queryWareByPackBarcode(String packBarcode, String database) {
        return wareDao.queryWareByPackBarcode(packBarcode, database);
    }

    public Integer queryWareByBeBarcode(String beBarcode, String database) {
        return wareDao.queryWareByBeBarcode(beBarcode, database);
    }

    /**
     * @说明：修改商品是否常用
     * @创建：作者:llp 创建时间：2016-4-19 @修改历史： [序号](llp 2016-4-19)<修改说明>
     */
    public int updateWareIsCy(String database, Integer id, Integer isCy) {
        try {
            return this.wareDao.updateWareIsCy(database, id, isCy);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateWareSpecsunitFront(String database, Integer id, Integer sunitFront) {
        try {
            return this.wareDao.updateWareSpecsunitFront(database, id, sunitFront);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateWareTranAmt(String database, Integer id, Double tranAmt) {
        try {
            return this.wareDao.updateWareTranAmt(database, id, tranAmt);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateWareTcAmt(String database, Integer id, Double tcAmt) {
        try {
            return this.wareDao.updateWareTcAmt(database, id, tcAmt);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：删除所有商品
     * @创建：作者:llp 创建时间：2016-9-5 @修改历史： [序号](llp 2016-9-5)<修改说明>
     */
    public void deleteWareAll(String database) {
        try {
            this.wareDao.deleteWareAll(database);
            this.wareDao.deleteWareTpAll(database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page queryWarePics(SysWare ware, int page, int rows, String database) {
        try {
            Page p = this.wareDao.queryWare(ware, page, rows, database);
            List<SysWare> wares = p.getRows();
            if (wares != null && wares.size() > 0) {
                String ids = "";
                for (int i = 0; i < wares.size(); i++) {
                    SysWare sysWare = wares.get(i);
                    if (ids != "") {
                        ids = ids + ",";
                    }
                    ids = ids + sysWare.getWareId();
                }
                List<SysWarePic> picList = wareWebPicDao.queryWarePicByIds(database, ids);
                if (picList != null && picList.size() > 0) {
                    for (int i = 0; i < wares.size(); i++) {
                        SysWare sysWare = wares.get(i);
                        List<SysWarePic> pics = new ArrayList<SysWarePic>();
                        for (int j = 0; j < picList.size(); j++) {
                            SysWarePic pic = picList.get(j);
                            if (pic.getWareId() == sysWare.getWareId()) {
                                pics.add(pic);
                            }
                        }
                        sysWare.setWarePicList(pics);
                    }
                }
            }
            return p;
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServiceException(e);
        }
    }

    /**
     * 根据商品id查询商品图片
     */
    public List<SysWarePic> queryWarePicById(Integer id, String database) {
        try {
            SysWarePic warePic = new SysWarePic();
            warePic.setId(id);
            return this.wareWebPicDao.queryWarePic(database, warePic);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServiceException(e);
        }
    }


    public void updateSunitFront(List ids, Integer type, String datasource) {
        this.wareDao.updateSunitFront(ids, type, datasource);
    }

    public void updateWareBarcode(String ids, String prefix, Integer len, Integer start, String database) {
        String[] wareIds = ids.split(",");
        int seq = start;
        for (int i = 0; i < wareIds.length; i++) {
            Integer wareId = Integer.parseInt(wareIds[i]);
            SysWare ware = wareDao.queryWareById(wareId, database);
            if (ware != null) {
                if (!StrUtil.isNull(ware.getBeBarCode())) continue;
            }
            String barcode = "";
            while (true) {
                barcode = prefix + String.format("%0" + len.toString() + "d", seq);
                seq++;

                if (!wareDao.checkExistBarcode(barcode, database)) {
                    break;
                }

            }
            this.wareDao.updateWareBarcode(wareId, barcode, database);
        }
        //this.wareDao.updateWareBarcode(wareId,barcode,database);
    }

    public void updateAllWareBarcode( String prefix, Integer len, Integer start, String database) {
        SysWare ware1 = new SysWare();
        Page p = this.wareDao.queryWare(ware1,1,9999,database);
        List<SysWare> list = p.getRows();
        int seq = start;
        for (SysWare ware: list) {

            if (!StrUtil.isNull(ware.getBeBarCode())) continue;

            String barcode = "";
            while (true) {
                barcode = prefix + String.format("%0" + len.toString() + "d", seq);
                seq++;

                if (!wareDao.checkExistBarcode(barcode, database)) {
                    break;
                }

            }
            this.wareDao.updateWareBarcode(ware.getWareId(), barcode, database);
        }
        //this.wareDao.updateWareBarcode(wareId,barcode,database);
    }



    public SysWare queryWareByIdNoPic(Integer wareId, String database) {
        return wareDao.queryWareById(wareId, database);
    }

    /**
     * 更新商品采购价格
     *
     * @param list
     * @param database
     * @return
     */
    public String updateWareInPrice(List<ImportWareInPriceVo> list, String database) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        StringBuffer str = new StringBuffer();
        SysConfig config = this.configService.querySysConfigByCode("CONFIG_WARE_AUTO_CODE", database);
        Integer autoWareCode = 0;
        if (config != null && "1".equals(config.getStatus())) {
            autoWareCode = this.queryWareMaxId(database);
            if (autoWareCode != null) autoWareCode++;
        }
        SysWaretype sysWaretype = productTypeService.getWareTypeByName(BaseWareTypeExecutor.DEFAULT_PRODUCT_TYPE, database);

        Integer typeId = null;
        if (sysWaretype == null) {
            SysWaretype productType = new SysWaretype();
            productType.setWaretypePid(0);
            productType.setWaretypeNm(BaseWareTypeExecutor.DEFAULT_PRODUCT_TYPE);
            typeId = productTypeService.addWaretype(productType, database);
        } else {
            typeId = sysWaretype.getWaretypeId();
        }
        SysWare ware = null;
        Set<String> idsSet = new HashSet<>();
        for (int i = 0; i < list.size(); i++) {
            ImportWareInPriceVo vo = list.get(i);
            if (vo == null) continue;
            if (StrUtil.isNull(vo.getWareNm())) {
                str.append(i + 1 + "行商品名称不能为空<br/>");
                continue;
            }
            SysWare oldWare = queryWareByName(vo.getWareNm(), database);
            if (oldWare != null) {
                //替换所有不为空值的字段
                Field[] fields = vo.getClass().getDeclaredFields();
                for (Field field : fields) {
                    if (!PropertyUtils.isReadable(oldWare, field.getName()))
                        continue;
                    Object obj = PropertyUtils.getProperty(vo, field.getName());
                    if (!StrUtil.isNull(obj)) {
                        PropertyUtils.setProperty(oldWare, field.getName(), obj);
                    }
                }
                oldWare.calLsPrice();
                updateWare(oldWare, "", database);
            } else {
                if (StrUtil.isNull(vo.getWareGg())) {
                    str.append(vo.getWareNm() + "第" + (i + 1) + "行'规格(大)'不能为空<br/>");
                    continue;
                }
                if (StrUtil.isNull(vo.getWareDw())) {
                    str.append(vo.getWareNm() + "第" + (i + 1) + "行'大单位'不能为空<br/>");
                    continue;
                }
                ware = new SysWare();
                BeanCopy.copyBeanProperties(ware, vo);
                if (config != null && "1".equals(config.getStatus())) {
                    ware.setWareCode((autoWareCode++) + "");
                }
                ware.setWaretype(typeId);
                ware.setIsCy(1);//常用
                addWare(ware, database);
            }
            idsSet.add(vo.getId() + "");
            //完成选项
            sysInportTempService.updateItemImportSuccess(String.join(",", idsSet), database);
        }
        return str.toString();
    }

    @Resource
    private SysCompanyRoleService sysCompanyRoleService;
    @Resource
    private SysWaresService sysWaresService;
    public static final String typeSeparator = "/";


    /**
     * 商品导入统一处理
     *
     * @param wareList        导入商品列表
     * @param info            导入会员信息
     * @param importId        导入主键ID
     * @param taskId          进度条异步ID
     * @param start           进度条开始位置
     * @param goal            进度条总共长度
     * @param requestParamMap 参数MAP
     * @return
     */
    public void saveOrUpdateWareByImport(ImportResults importResults, List<SysWare> wareList, SysLoginInfo info, String importId, String taskId, int start, int goal, Map<String, String[]> requestParamMap) {
        if (Collections3.isEmpty(wareList)) {
            importResults.setErrorMsg("导入数据不能为空");
            return;
        }
        String notWareVaildateMaxAttr = CommonUtil.getMapOnlyValue(requestParamMap, "notWareVaildateMaxAttr");//不验证商品大单位
        String replaceWare = CommonUtil.getMapOnlyValue(requestParamMap, "replaceWare");//替换复制商品
        String database = info.getDatasource();
        SysImportTemp sysImportTemp = sysInportTempService.queryById(Integer.valueOf(importId), database);
        //分类工具
        BaseWareTypeExecutor baseWareTypeExecutor = new BaseWareTypeExecutor(database, typeSeparator, productTypeService);
        //判断是否自动生成商品代码
        SysConfig config = this.configService.querySysConfigByCode("CONFIG_WARE_AUTO_CODE", database);
        Integer autoWareCode = null;
        if (config == null || "1".equals(config.getStatus())) {
            autoWareCode = queryWareMaxId(database);
            if (autoWareCode != null) autoWareCode++;
        }
        //商品被使用，是否可以修改商品换算
        List<Map<String, Object>> mapList = sysCompanyRoleService.queryRoleButtonByCodes(database, info.getUsrRoleIds(), "uglcw.sysWare.desc");
        boolean bool = false;
        if (mapList != null && mapList.size() > 0) {
            bool = true;
        }

        //如果是导入数据，大单位默认为1
        boolean defBunitFlag = false;
        //if (Objects.equals(SysImportTemp.TypeEnum.type_ware.getCode(), Integer.valueOf(request.getParameter("type")))) {
        if (sysImportTemp != null && sysImportTemp.getInputDown() != null && sysImportTemp.getInputDown() == 0)
            defBunitFlag = true;
        //}
        Map<String, SysWare> cacheWareMap = null;
        if (wareList.size() > 100) {
            cacheWareMap = new HashMap<>();
            List<SysWare> oldWareList = queryList(null, database);
            for (SysWare sysWare : oldWareList) {
                cacheWareMap.put(sysWare.getWareNm(), sysWare);
            }
        }
        ProgressUtil progressUtil = new ProgressUtil(start, goal, wareList.size());
        int i = 0;
        for (SysWare ware : wareList) {
            i++;
            try {
                if (ware == null) continue;
                String wareName = ware.getWareNm() == null ? "" : ware.getWareNm().toString().trim();
                String waretypeNm = ware.getWaretypeNm() == null ? "" : ware.getWaretypeNm().toString().trim();
                String wareCode = ware.getWareCode() == null ? "" : ware.getWareCode().toString().trim();
                String sUnit = StrUtil.isNull(ware.getsUnit()) ? null : ware.getsUnit().toString().trim();
                asyncProcessHandler.updateProgress(taskId, progressUtil.getCurrentRaised(i), "正在处理商品:" + wareName);
            /*if (StrUtil.isNull(wareName)) {
                msg.append(wareName + "商品名称不能为空!<br/>");
                continue;
            }*/
                //根据名字获取商品是否存在
                SysWare oldWare = null;
                if (Collections3.isNotEmpty(cacheWareMap))
                    oldWare = cacheWareMap.get(wareName);
                else
                    oldWare = queryWareByName(wareName, database);
                Integer wareId = null;
                if (oldWare != null) {
                    if (StrUtil.isNull(replaceWare) || !Boolean.valueOf(replaceWare)) {
                        importResults.addExistsNum();
                        importResults.setErrorMsg(oldWare.getWareNm() + "商品已存在");
                        importResults.setOperationScript("<input class='dataVaildata' name='replaceWare' type='checkbox'>覆盖重名商品信息");
                        continue;
                    }
                    wareId = oldWare.getWareId();
                    //验证条码是否重复
                    String error = checkBarCode(config, ware, database, wareId);
                    if (error != null) {
                        importResults.setErrorMsg(error);
                        continue;
                    }
                    Double oldsUtil = oldWare.getsUnit();
                    if (oldsUtil == null) oldsUtil = 1d;
                    //如果是导入的商品并修改了小单位比例时，大单位设置为1
                    Double oldBUnit = oldWare.getbUnit();
                    if (oldBUnit == null || (defBunitFlag && sUnit != null && oldsUtil.compareTo(Double.valueOf(sUnit)) != 0))
                        oldBUnit = 1d;

                    //商品被使用，是否可以修改商品换算；
                    if (!StrUtil.isNull(sUnit)) {
                        if (!bool && oldsUtil.compareTo(Double.valueOf(sUnit)) != 0) {
                            int count = sysWaresService.checkWareIsUse(database, wareId);
                            if (count == 0) {//如果不可修改，但未使用时可修改
                                oldsUtil = Double.valueOf(sUnit);
                            } else {
                                importResults.setErrorMsg(wareName + "已被使用不可修改比例");
                                continue;
                            }
                        } else {
                            oldsUtil = Double.valueOf(sUnit);
                        }
                    }
                    //替换所有不为空值的字段
                    try {
                        Field[] fields = ware.getClass().getDeclaredFields();
                        for (Field field : fields) {
                            if (!PropertyUtils.isReadable(oldWare, field.getName()))
                                continue;
                            Object obj = PropertyUtils.getProperty(ware, field.getName());
                            if (!StrUtil.isNull(obj))
                                PropertyUtils.setProperty(oldWare, field.getName(), obj);
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    oldWare.setbUnit(oldBUnit);
                    oldWare.setsUnit(oldsUtil);
                    oldWare.setHsNum(oldsUtil / oldBUnit);
                    //如果老数据为空并设置为自动编号时
                    if (autoWareCode != null && StrUtil.isNull(oldWare.getWareCode())) {
                        oldWare.setWareCode((autoWareCode++) + "");
                    }
                    if (!StrUtil.isNull(waretypeNm)) {
                        Integer typeId = baseWareTypeExecutor.getProductType(waretypeNm);
                        oldWare.setWaretype(typeId);
                    }
                    oldWare.setStatus("1");

                    if(!StrUtil.isNumberNullOrZero(oldWare.getLsPrice())||!StrUtil.isNumberNullOrZero(oldWare.getMinLsPrice())){
                        oldWare.setAddRate(null);
                    }else{
                        oldWare.calLsPrice();
                    }
                    updateWare(oldWare, "", database);
                    importResults.addSuccessNum();
                } else {
                    if (StrUtil.isNull(notWareVaildateMaxAttr) || !Boolean.valueOf(notWareVaildateMaxAttr)) {
                        if (StrUtil.isNull(ware.getWareDw()) || StrUtil.isNull(ware.getWareGg())) {
                            importResults.setOperationScript("<input class='dataVaildata' name='notWareVaildateMaxAttr' type='checkbox'>支持单位和规格为空导入");
                        }
                        if (StrUtil.isNull(ware.getWareDw()) && StrUtil.isNull(ware.getWareGg())) {
                            importResults.setErrorMsg(wareName + " 大单位和规格(大)不能为空!");
                            continue;
                        }
                        if (StrUtil.isNull(ware.getWareDw())) {
                            importResults.setErrorMsg(wareName + " 大单位不能为空!");
                            continue;
                        }
                        if (StrUtil.isNull(ware.getWareGg())) {
                            importResults.setErrorMsg(wareName + " 规格(大)不能为空!");
                            continue;
                        }
                    }
                    //验证条码是否重复
                    String error = checkBarCode(config, ware, database, wareId);
                    if (error != null) {
                        importResults.setErrorMsg(error);
                        continue;
                    }
                    Integer typeId = baseWareTypeExecutor.getProductType(waretypeNm);
                    ware.setWaretype(typeId);
                    if (autoWareCode != null && StrUtil.isNull(wareCode)) {
                        ware.setWareCode((autoWareCode++) + "");
                    }
                    ware.setIsCy(1);//常用
                    wareId = addWare(ware, database);
                    importResults.addSuccessNum();//成功标记
                }
                ware.setWareId(wareId);
            /*if (Collections3.isNotEmpty(wareNaIdMap))
                idsSet.add(wareNaIdMap.get(ware.getWareNm()));*/

            } catch (Exception e) {
                log.error("商品导入保存出错", e);
                importResults.setErrorMsg(ware.getWareNm() + "商品导入保存出错" + e.getMessage());
            }
        }
        return;
    }

    /**
     * 验证条码
     *
     * @param config
     * @param ware
     * @param database
     * @param wareId
     * @return
     */
    private String checkBarCode(SysConfig config, SysWare ware, String database, Integer wareId) {
        if (config == null || "0".equals(config.getStatus())) {
            String packBarCode = ware.getPackBarCode();
            if (StringUtils.isNotEmpty(packBarCode)) {
                Integer exists = queryWareByPackBarcode(packBarCode, database);
                if (exists != null && !Objects.equals(wareId, exists)) {
                    return ware.getWareNm() + "”大单位条码已存在!";
                }
            }
            String beBarCode = ware.getBeBarCode();
            if (StringUtils.isNotEmpty(beBarCode)) {
                Integer exists = queryWareByBeBarcode(beBarCode, database);
                if (exists != null && !Objects.equals(wareId, exists)) {
                    return ware.getWareNm() + "”小单位条码已存在!";
                }
            }
        }
        return null;
    }

    public Page queryNoneGroupWare(SysWare sysWare, int page, int rows, String database) {
        try {
            return this.wareDao.queryNoneGroupWare(sysWare, page, rows, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }

    public Page queryWareByGroupId(SysWare sysWare, int groupId, int page, int rows, String database) {
        try {
            return this.wareDao.queryWareByGroupId(sysWare, groupId, page, rows, database);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public int batchUAddWareGroup(String ids, Integer id, String database) {
        try {
            return this.wareDao.batchUAddWareGroup(ids, id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int batchRemoveCustomerType(String ids, String database) {
        try {
            return this.wareDao.batchRemoveCustomerType(ids, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
