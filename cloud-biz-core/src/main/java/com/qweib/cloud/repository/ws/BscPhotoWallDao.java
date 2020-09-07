package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscPhotoWall;
import com.qweib.cloud.core.domain.BscPhotoWallPic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@Repository
public class BscPhotoWallDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * @return
     * @说明：查最新照片墙
     * @创建者： 作者：llp  创建时间：2014-5-6
     */
    public Page queryPhotoWallList(int pageNum, int rows, String datasource) {
        StringBuffer sql = new StringBuffer("select * from " + datasource + ".bsc_photo_wall where 1=1 order by publish_time desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNum, rows, BscPhotoWall.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：获取照片墙自增id
     * @创建者： 作者：llp  创建时间：2014-5-8
     */
    public int queryAutoId() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @param bscPhotoWall
     * @return
     * @说明：添加照片墙内容
     * @创建：作者:llp 创建时间：2014-5-8
     * @修改历史： [序号](llp 2014 - 5 - 8)<修改说明>
     */
    public void addBscPhotoWall(BscPhotoWall bscPhotoWall, String datasource) {
        try {
            this.daoTemplate.addByObject("" + datasource + ".bsc_photo_wall", bscPhotoWall);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 摘要：
     *
     * @param wallPicdetail
     * @return
     * @说明：添加照片墙图片
     * @创建：作者:llp 创建时间：2014-5-8
     * @修改历史： [序号](llp 2014 - 5 - 8)<修改说明>
     */
    public void addwallPicdetaildetail(final List<BscPhotoWallPic> wallPicdetail, String datasource) {
        String sql = "insert into " + datasource + ".bsc_photo_wall_pic(wall_id,pic_mini,pic) values(?,?,?)";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return wallPicdetail.size();
                }

                public void setValues(PreparedStatement arg0, int arg1) throws SQLException {
                    arg0.setInt(1, wallPicdetail.get(arg1).getWallId());
                    arg0.setString(2, wallPicdetail.get(arg1).getPicMini());
                    arg0.setString(3, wallPicdetail.get(arg1).getPic());
                }

            };
            this.daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param type 1:最近热门照片 2：最新照片 3：历史热门照片
     * @param time 时间
     * @return
     * @说明：查热门照片墙
     * @创建者： 作者：llp  创建时间：2014-5-8
     */
    public Page queryHotPhotoWallList(Integer pageNo, Integer rows, String datasource) {
        StringBuffer sql = new StringBuffer("select w.wall_id,w.publish_content,wp.pic_mini from ").append(datasource).append(".bsc_photo_wall w ");
        sql.append(" left join").append(datasource).append(".bsc_photo_wall_pic wp on w.wall_id=wp.wall_id ");
        sql.append(" order by w.publish_time,w.comment_num,w.praise_num desc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, rows, BscPhotoWall.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：查单个照片墙
     * @创建者： 作者：yjp  创建时间：2014-5-30
     */
    public BscPhotoWall queryBscPhotoWall(Integer wallId, String datasource) {
        StringBuffer sql = new StringBuffer("select * from " + datasource + ".bsc_photo_wall where wall_id = ?");
        try {
            return this.daoTemplate.queryForObj(sql.toString(), BscPhotoWall.class, wallId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param wallId 照片墙ID
     * @param count  数量
     * @param type   1：评论 2：赞
     * @return
     * @说明： 修改照片墙的评论或赞的数量
     */
    public int updatePhtoNum(Integer wallId, Integer count, Integer type, String datasource) {
        StringBuffer sql = new StringBuffer("update " + datasource + ".bsc_photo_wall ");
        try {
            if (type == 1) {
                sql.append(" set comment_num = ? ");
            }
            if (type == 2) {
                sql.append(" set praise_num = ?  ");
            }
            sql.append(" where wall_id = ?  ");
            return this.daoTemplate.update(sql.toString(), count, wallId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * @param memberId 用户ID
     * @return
     * @说明： 查询用户发布的照片---分页---
     */
    public Page findMemberPhoto(Integer memberId, String hotTopic, Integer pageNo, Integer row, String datasource) {
        StringBuffer sql1 = new StringBuffer("select * from " + datasource + ".bsc_photo_wall where member_id=").append(memberId).append(" order by publish_time desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql1.toString(), pageNo, row, BscPhotoWall.class);

        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memberId 用户ID
     * @return
     * @说明： 查询用户发布的照片
     */
    public List<BscPhotoWall> findMemberPhoto(Integer memberId, Integer limitNum, String datasource) {
        StringBuffer sql = new StringBuffer("select * from " + datasource + ".bsc_photo_wall ");
        try {
            sql.append(" where member_id = ").append(memberId);
            sql.append(" and DATE_SUB(CURDATE(), INTERVAL 7 DAY) <= date(publish_time) ");
            sql.append(" order by publish_time desc");
            if (limitNum != null) {
                sql.append(" limit 0,20");
            }
            return this.daoTemplate.queryForLists(sql.toString(), BscPhotoWall.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除话题
     *
     * @param wallId
     * @return
     */
    public int deleteWall(Integer wallId, String datasource) {
        try {
            StringBuffer str = new StringBuffer("delete from " + datasource + ".bsc_photo_wall where wall_id = ").append(wallId);
            return this.daoTemplate.update(str.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param addOrDelete 0:赞减分  1:赞加分  2：评论加分
     * @return
     * @说明：修改照片墙的分数
     * @创建者： 作者：llp  创建时间：2014-5-6
     */
    public int updatePhotoWallScore(Integer wallId, Integer addOrDelete, String datasource) {
        StringBuffer sql = new StringBuffer("update " + datasource + ".bsc_photo_wall set ");
        try {
            if (addOrDelete == 1) {
                sql.append(" wall_score = wall_score + 1 ");
            }
            if (addOrDelete == 0) {
                sql.append(" wall_score = wall_score - 1 ");
            }
            if (addOrDelete == 2) {
                sql.append(" wall_score = wall_score + 2 ");
            }
            if (addOrDelete == -2) {
                sql.append(" wall_score = wall_score-2 ");
            }
            sql.append("where wall_id = ").append(wallId);
            return this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memberId 用户ID
     * @return
     * @说明： 查询用户发布的照--只查询ID--
     */
    public List<Integer> findMemberPhotoBy(Integer memberId, String datasource) {
        StringBuffer sql = new StringBuffer("select wall_id from " + datasource + ".bsc_photo_wall ");
        try {
            sql.append(" where member_id = ").append(memberId);
            sql.append(" order by publish_time desc");
            return this.daoTemplate.queryForLists(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：根据评论id查询照片墙信息
     *
     * @param @param  commentId
     * @param @return
     * @说明：
     * @创建：作者:YYP 创建时间：2014-8-13
     * @修改历史： [序号](YYP 2014 - 8 - 13)<修改说明>
     */
    public BscPhotoWall udpatePhotoComemnt(Integer commentId, String datasource) {
        StringBuilder sql = new StringBuilder("select * from ")
                .append(datasource).append(".bsc_photo_wall where wall_id = (select wall_id from ")
                .append(datasource).append(".bsc_photo_wall_comment where comment_id = ?)");
        try {
            return this.daoTemplate.queryForObj(sql.toString(), BscPhotoWall.class, commentId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：查询最大照片墙id
     *
     * @param @return
     * @说明：
     * @创建：作者:YYP 创建时间：2014-8-26
     * @修改历史： [序号](YYP 2014 - 8 - 26)<修改说明>
     */
    public Integer queryMaxWallId(String datasource) {
        StringBuffer sql = new StringBuffer(" select max(wall_id) from " + datasource + ".bsc_photo_wall");
        try {
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

}
