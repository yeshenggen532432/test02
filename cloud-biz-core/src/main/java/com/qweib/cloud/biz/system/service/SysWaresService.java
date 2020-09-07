package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.domain.SysWarePic;
import com.qweib.cloud.core.domain.product.BaseProduct;
import com.qweib.cloud.core.domain.product.ProductData;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysWareDao;
import com.qweib.cloud.repository.SysWarePicWebDao;
import com.qweib.cloud.utils.ChineseCharToEnUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class SysWaresService {
    @Autowired
    private SysWareDao wareDao;
    @Autowired
    private SysWarePicWebDao wareWebPicDao;

    /**
     * 摘要：
     *
     * @说明：分页查询商品
     * @创建：作者:llp 创建时间：2016-3-22 @修改历史： [序号](llp 2016-3-22)<修改说明>
     */
    public Page queryWare(SysWare ware, int page, int rows, String database) {
        try {
            return this.wareDao.queryWare(ware, page, rows, database);
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

    public List<SysWare> queryList(String ids, String database) {
        try {
            return this.wareDao.queryList(ids, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysWare> queryWareLists(SysWare sysWare, String database) {
        try {
            return this.wareDao.queryWareLists(sysWare, database);
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

    public int updateWareStatus(String database, Integer id, String status) {
        return this.wareDao.updateWareStatus(database, id, status);
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

    public Integer queryWareMaxId(String database) {
        return this.wareDao.queryWareMaxId(database);
    }

    public int updateWare(SysWare ware, String database) {
        try {
            String py = "";
            if (ware != null) {
                py = ware.getPy();
                if (StrUtil.isNull(py)) {
                    py = ChineseCharToEnUtil.getFirstSpell(ware.getWareNm());
                }
                ware.setPy(py);
            }
            return this.wareDao.updateWare(ware, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
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

    public List<SysWare> queryListByIds(String ids, String database){
        return this.wareDao.queryListByIds(ids,database);
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
    }

    public Integer saveImportProduct(String database, ProductData productData) {
        return this.wareDao.saveImportProduct(database, productData);
    }

    public List<BaseProduct> queryAllBase(String database) {
        return this.wareDao.queryAllBase(database);
    }

    public int checkWareIsUse(String database, Integer id) {
        try {
            return this.wareDao.checkWareIsUse(database, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    //========================================以下为商品新的接口=============================================

    /**
     * 查找公司产品（1.状态为启用;）
     *
     * @param ware
     * @param page
     * @param rows
     * @param database
     * @return
     */
    public Page queryCompanyWare(SysWare ware, int page, int rows, String database) {
        return this.wareDao.queryCompanyWare(ware, page, rows, database);
    }

    /**
     * 查找库存类公司产品（1.状态为启用;2.库存商品类别）
     *
     * @param ware
     * @param page
     * @param rows
     * @param database
     * @return
     */
    public Page queryCompanyStockWare(SysWare ware, int page, int rows, String database) {
        ware.setIsType(0);
        return this.wareDao.queryCompanyWare(ware, page, rows, database);
    }

    public List<SysWare> queryCompanyStockWareList(SysWare ware, String database) {
        return this.wareDao.queryCompanyStockWareList(ware, database);
    }

    public int updateImportProduct(String database, Integer id, ProductData productData) {
        return wareDao.updateImportProduct(database, id, productData);
    }

}
