package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysWaretype;
import com.qweib.cloud.core.domain.SysWaretypePic;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysWaretypeDao;
import com.qweib.cloud.repository.SysWaretypePicDao;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Objects;

@Service
public class SysWaretypeService {
    @Resource
    private SysWaretypeDao waretypeDao;
    @Resource
    private SysWaretypePicDao waretypePicDao;

    /**
     * 摘要：
     *
     * @说明：查询第一个分类
     */
    public Integer queryOneWaretype(SysWaretype type, String database) {
        try {
            return this.waretypeDao.queryOneWaretype(type, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：根据id获取分类path
     */
    public String queryWarePath(Integer waretype, String database) {
        try {
            return this.waretypeDao.queryWarePath(waretype, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：根据id查询下级分类
     */
    public List<SysWaretype> queryWaretype(SysWaretype type, String database) {
        try {
            return this.waretypeDao.queryWaretype(type, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateWaretypePid(Integer pid, Integer id, Integer isType, String database) {
        SysWaretype parent;
        if (!pid.equals(0)) {
            parent = waretypeDao.queryWaretypeById(pid, database);
        } else {
            parent = new SysWaretype();
            parent.setWaretypeId(0);
            parent.setWaretypePid(0);
        }
        if (pid.equals(id)) {
            throw new BizException("分类迁移不能选择本身");
        }
        //查询原父节点
        SysWaretype type = waretypeDao.queryWaretypeById(id, database);
        if(type.getWaretypeLeaf().equals("0")){
            throw new BizException("不是末级分类不能迁移");
        }
      /*  if (parent.getWaretypePid().equals(type.getWaretypeId())) {
            throw new BizException("分类迁移不能选择当前分类的子类");
        }*/
        if (type.getWaretypePid() != null && !type.getWaretypePid().equals(0)) {
            int siblings = waretypeDao.queryWaretypeInt(type.getWaretypePid(), database); //查看兄弟节点数量
            if (siblings == 1) {
                //若兄弟节点只有一个，即为当前节点本身，需要标记父节点为叶子节点
                waretypeDao.updateWareLeaf(type.getWaretypePid(), "1", database);
            }
        }

        String path = "";
        if (pid != null && !pid.equals(0)) {
            //父节点不为0，获取父节点的path  path-id-
            path = (parent.getWaretypePath() + id + "-");
            parent.setWaretypeLeaf("0");
            waretypeDao.updateWareLeaf(pid, "0", database); //目标节点取消叶子标记
        } else {
            path = "-" + id + "-"; //父节点为0: -id-
        }
        int ret = this.waretypeDao.updateWaretypePid(pid, id, isType, path, database);
        this.waretypeDao.updateIsType(id, isType, path, database);
        return ret;

    }

    public List<SysWaretype> queryList(SysWaretype type, String database) {
        try {
            return this.waretypeDao.queryList(type, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：添加分类
     */
    public int addWaretype(SysWaretype waretype, String database) {
        try {
            this.waretypeDao.addWaretype(waretype, database);
            int autoId = this.waretypeDao.queryAutoId();
            waretype.setWaretypeId(autoId);
            //修改上级leaf为0
            if (null != waretype.getWaretypePid() && waretype.getWaretypePid() > 0) {
                this.waretypeDao.updateWareLeaf(waretype.getWaretypePid(), "0", database);
            }
            //修改path
            String path;
            if (null != waretype.getWaretypePid() && waretype.getWaretypePid() > 0) {
                SysWaretype parent = this.waretypeDao.queryWaretypeById(waretype.getWaretypePid(), database);
                path = parent.getWaretypePath() + autoId + "-";
                if (Objects.equals(parent.getShopQy(), 1)) {//上级如果全选时，增加下级时修改为半选，方便商城上架分类时选择
                    parent.setShopQy(2);
                    this.waretypeDao.updateWaretype(parent,database);
                }
            } else {
                path = "-" + autoId + "-";
            }
            this.waretypeDao.updateWarePath(autoId, path, database);
            //图片
            List<SysWaretypePic> picList = waretype.getWaretypePicList();
            if (picList != null && picList.size() > 0) {
                for (int k = 0; k < picList.size(); k++) {
                    picList.get(k).setWaretypeId(waretype.getWaretypeId());
                    this.waretypePicDao.addWarePic(picList.get(k), database);
                }
            }
            return autoId;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：根据id获取分类
     */
    public SysWaretype queryWaretypeById(Integer waretypeId, String database) {
        try {
            return this.waretypeDao.queryWaretypeById(waretypeId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int queryWaretypeInt(Integer pid, String database) {
        return this.waretypeDao.queryWaretypeInt(pid, database);
    }

    /**
     * @说明：修改分类
     */
    public int updateWaretype(SysWaretype waretype, String delPicIds, String database) {
        try {
            //图片
            List<SysWaretypePic> picList = waretype.getWaretypePicList();
            if (picList != null && picList.size() > 0) {
                for (int k = 0; k < picList.size(); k++) {
                    picList.get(k).setWaretypeId(waretype.getWaretypeId());
                    this.waretypePicDao.addWarePic(picList.get(k), database);
                }
            }
            //根据要删除的ids删除图片
            if (!StrUtil.isNull(delPicIds)) {
                this.waretypePicDao.deletePicByIds(database, delPicIds);
            }
            this.waretypeDao.updateWareType(waretype.getWaretypeId(), waretype.getIsType(), waretype.getNoCompany(), database);
            return this.waretypeDao.updateWaretype(waretype, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：删除分类
     */
    public void deleteWaretype(SysWaretype waretype, String database) {
        try {
            int count = this.waretypeDao.queryWaretypeInt(waretype.getWaretypePid(), database);
            if (count == 1) {
                this.waretypeDao.updateWareLeaf(waretype.getWaretypePid(), "1", database);
            }
            this.waretypeDao.deleteWaretype(waretype.getWaretypeId(), database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：查询商品分类下是否存在商品
     */
    public boolean existWareInType(Integer waretype, String database) {
        try {
            return this.waretypeDao.existWareInType(waretype, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：判断分类名称唯一
     */
    public int queryWaretypeNmCount(String waretypeNm, String database) {
        try {
            return this.waretypeDao.queryWaretypeNmCount(waretypeNm, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysWaretype getWareTypeByName(String waretypeNm, String database) {
        return this.waretypeDao.getWareTypeByName(waretypeNm, database);
    }

    //=======================================================================

    /**
     * 查询公司类商品类别
     *
     * @param type
     * @param database
     * @return
     */
    public List<SysWaretype> queryCompanyWaretypeList(SysWaretype type, String database) {
        try {
            return this.waretypeDao.queryCompanyWaretypeList(type, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询库存类公司类商品类别
     */
    public List<SysWaretype> queryCompanyStockWaretypeList(SysWaretype type, String database) {
        try {
            type.setIsType(0);
            return this.waretypeDao.queryCompanyWaretypeList(type, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


}
