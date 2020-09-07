package com.qweib.cloud.repository.plat.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysFeedback;
import com.qweib.cloud.core.domain.SysFeedbackFactory;
import com.qweib.cloud.core.domain.SysFeedbackPic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@Repository
public class SysFeedbackDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;
//    @Qualifier("memberRequest")
//    @Autowired
//    private SysMemberRequest memberRequest;

    /**
     * @param feedback
     * @创建：作者:YYP 创建时间：2015-6-19
     * @see //添加任务反馈
     */
    public Integer addFeedback(SysFeedback feedback) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return pdaoTemplate.addByObject("sys_feedback", feedback);
            //return pdaoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param //pic
     * @param //picMini
     * @param //feedId
     * @return
     * @创建：作者:YYP 创建时间：2015-6-23
     * @see //添加反馈图片
     */
	public int[] addFeedbackPic(final String[] pics,final String[] picMinis,final Integer feedId) {
		String sql = "insert into sys_feedback_pic(feed_id,pic,pic_mini) values(?,?,?)";
		try{
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				
				@Override
				public void setValues(PreparedStatement pre, int num) throws SQLException {
					pre.setInt(1,feedId);
					pre.setString(2,pics[num]);
					pre.setString(3,picMinis[num]);
				}
				
				@Override
				public int getBatchSize() {
					return pics.length;
				}
			};
//			pdaoTemplate.addByObject("sys_feedback", feedback);
			System.out.println(sql);
			return pdaoTemplate.batchUpdate(sql,setter);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
    public void addfeedPic(SysFeedbackPic feedPic) {
        pdaoTemplate.addByObject("sys_feedback_pic", feedPic);
    }

    /**
     * 查询意见反馈信息
     *
     * @param pageNo
     * @param pageSize
     * @param feedType
     * @param scontent
     * @return
     * @创建：作者:YYP 创建时间：2015-6-23
     */
    public Page queryFeedBackPage(Integer pageNo, Integer pageSize, String feedType, String scontent) {
        StringBuilder sql = new StringBuilder("SELECT f.feed_id,f.feed_type,f.feed_content,f.member_id,f.feed_time,f.plat from sys_feedback f where 1=1 ");
        if (!StrUtil.isNull(feedType) && !"0".equals(feedType)) {
            sql.append(" and f.feed_type=").append(feedType);
        }
        if (!StrUtil.isNull(scontent) && !"请输入关键词/提交人姓名".equals(scontent)) {
            sql.append(" and (f.feed_content like '%" + scontent + "%' or m.member_nm like '%" + scontent + "%') ");
        }
        sql.append(" order by f.feed_time desc");
        try {
            Page page = pdaoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysFeedbackFactory.class);
//            List<SysFeedbackFactory> rows = page.getRows();
//            if (Collections3.isNotEmpty(rows)) {
//                for (SysFeedbackFactory feedbackFactory : rows) {
//                    if (feedbackFactory.getMemberId() != null) {
//                        SysMemberDTO memberDTO = HttpResponseUtils.convertResponseNull(memberRequest.get(feedbackFactory.getMemberId()));
//                        if (memberDTO != null) {
//                            feedbackFactory.setMemberNm(memberDTO.getName());
//                        }
//                    }
//                }
//            }

            return page;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param feedId
     * @return
     * @创建：作者:YYP 创建时间：2015-6-23
     * @see //查询任务反馈图片
     */
    public List<SysFeedbackPic> queryfeedBackPic(Integer feedId) {
        String sql = "select * from sys_feedback_pic where feed_id=" + feedId;
        try {
            return pdaoTemplate.queryForLists(sql, SysFeedbackPic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
