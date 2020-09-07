package com.qweib.cloud.repository.ws;


import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscPhotoWall;
import com.qweib.cloud.core.domain.BscPhotoWallPraise;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class BscPhotoWallPraiseDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * @return
     * @说明：根据照片墙id查照片墙赞
     * @创建者： 作者：llp  创建时间：2014-5-6
     */
    public List<BscPhotoWallPraise> queryPhotoWallPicList(Integer wallId, String datasource) {
        StringBuffer sql = new StringBuffer("select * from " + datasource + ".bsc_photo_wall_praise where 1=1 ");
        if (!StrUtil.isNull(wallId)) {
            sql.append(" and wall_id=" + wallId + " ");
        }
        sql.append(" order by click_time desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), BscPhotoWallPraise.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：根据用户id判断是否已赞
     * @创建者： 作者：llp  创建时间：2014-5-8
     */
    public long queryPhotoPraiseCount(Integer memberId, Integer wallId, String datasource) {
        StringBuffer sql = new StringBuffer("select count(1) from " + datasource + ".bsc_photo_wall_praise where member_id=" + memberId + " and wall_id=" + wallId + " ");
        try {
            return this.daoTemplate.queryForObject(sql.toString(), Long.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：添加赞
     * @创建者： 作者：llp  创建时间：2014-5-8
     */
    public int addPhotoPraise(BscPhotoWallPraise sbscPhotoWallPraise, String datasource) {
        try {
            return this.daoTemplate.addByObject("" + datasource + ".bsc_photo_wall_praise", sbscPhotoWallPraise);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：取消赞
     * @创建者： 作者：llp  创建时间：2014-5-8
     */
    public int deletePhotoPraise(Integer memberId, Integer wallId, String datasource) {
        StringBuffer sql = new StringBuffer(" delete from " + datasource + ".bsc_photo_wall_praise where 1=1");
        try {
            if (memberId != null) {
                sql.append(" and member_id=" + memberId + "");
            }
            if (wallId != null) {
                sql.append(" and wall_id=" + wallId + "");
            }
            if (memberId == null && wallId == null) {
                sql.append(" and 1 <> 1");
            }
            return this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：查询点赞
     * @创建者： 作者：yjp  创建时间：2014-5-30
     */
    public List<BscPhotoWallPraise> findPhotoPraise(Integer memberId, String datasource) {
        StringBuffer sql = new StringBuffer("SELECT bp.wall_id,bp.member_id FROM " + datasource + ".bsc_photo_wall bw inner join " + datasource + ".bsc_photo_wall_praise bp on bw.wall_id = bp.wall_id where bw.member_id = ?");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), BscPhotoWallPraise.class, memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：查询点赞
     * @创建者： 作者：yjp  创建时间：2014-5-30
     */
    public Page findPhotoPraisePage(Integer memberId, Integer pageNo, Integer row, String datasource) {
        StringBuffer sql = new StringBuffer("SELECT bp.wall_id,bp.member_id FROM " + datasource + ".bsc_photo_wall bw inner join " + datasource + ".bsc_photo_wall_praise bp on bw.wall_id = bp.wall_id where bp.member_id = ").append(memberId);
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, row, BscPhotoWallPraise.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @说明：分页查询点赞
     * @创建者： 作者：yjp  创建时间：2014-6-23
     */
    public Page findPhotoByPrasie(Integer memberId, Integer pageNo, Integer row, String datasource) {
        StringBuffer sql = new StringBuffer("SELECT  b.*,p.member_id as memberPId,p.click_time FROM " + datasource + ".bsc_photo_wall b inner join " + datasource + ".bsc_photo_wall_praise p on b.wall_id = p.wall_id where b.member_id = ").append(memberId);
        try {
            sql.append(" order by p.click_time  desc ");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, row, BscPhotoWall.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
