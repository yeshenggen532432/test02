package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.repository.ws.BscTopicWebDao;
import com.qweib.cloud.repository.ws.SysChatMsgDao;
import com.qweib.cloud.utils.Page;
import com.qweibframework.commons.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Objects;

@Service
public class BscTopicWebService {

    @Resource
    private BscTopicWebDao bscTopicWebDao;
    @Resource
    private SysMemberWebDao memberWebDao;
    @Resource
    private SysChatMsgDao chatMsgDao;

    /**
     * 添加话题
     *
     * @param topic
     * @param btpList
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-2-2
     */
    public Integer addBscTopic(BscTopic topic, List<BscTopicPic> btpList, Integer tpType, String datasource) {
        try {
            this.bscTopicWebDao.addOrUpdaTp(topic, null, datasource);
            int id = this.bscTopicWebDao.getIdentity();
            if (btpList.size() > 0) {//修改成批处理
                for (int i = 0; i < btpList.size(); i++) {
                    if (0 == tpType) {
                        btpList.get(i).setTopicId(id);
                    } else if (1 == tpType) {
                        btpList.get(i).setTopicId(id);
                    }
                    this.bscTopicWebDao.addPic(btpList.get(i), datasource);
                }
            }
            return id;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param tpId
     * @param database
     * @param pageNo
     * @return
     * @创建：作者:YYP 创建时间：2015-2-3
     * @see 获取主题列表
     */
    public Page queryTopicPage(Integer tpId, Integer pageNo, Integer pageSize, String datasource) {
        try {
            Page topicPage = bscTopicWebDao.queryTopicPage(tpId, pageNo, pageSize, datasource);
            List<BscTopicFactoryDTO> topicList = topicPage.getRows();
            if (null != topicList) {
                for (BscTopicFactoryDTO bscTopicDTO : topicList) {
                    bscTopicDTO.setPicList(bscTopicWebDao.queryTopicPic(bscTopicDTO.getTopicId(), datasource));
                    List<BscTopicComment> commentList = bscTopicWebDao.queryCommentList(bscTopicDTO.getTopicId(), datasource);//获取评论
                    bscTopicDTO.setCommentList(commentList);
                    if (null != commentList) {
                        for (BscTopicComment comment : commentList) {
                            comment.setRcList(bscTopicWebDao.queryRcList(comment.getCommentId(), datasource));//获取回复
                        }
                    }
                    bscTopicDTO.setPraiseList(bscTopicWebDao.queryPraiseList(bscTopicDTO.getTopicId(), datasource));
                }
            }
            return topicPage;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param topicComment
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-5
     * @see 添加主题评论
     */
    public int addTopicComment(BscTopicComment topicComment, String datasource) {
        int info = this.bscTopicWebDao.addTopicComment(topicComment, datasource);
        bscTopicWebDao.updateTopicNum(topicComment.getTopicId(), "+", datasource);
        return info;
    }

    /**
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-5
     * @see 根據主題查詢發部分信息
     */
    public SysMemDTO findMemberByTopic(Integer topicId, String datasource) {
        return this.bscTopicWebDao.findMemberByTopic(topicId, datasource);
    }

    /**
     * @param topicPraise
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-7
     * @see 添加赞
     */
    public void addTopicPraise(BscTopicPraise topicPraise, String datasource) {
        try {
            this.bscTopicWebDao.addTopicPraise(topicPraise, datasource);
            bscTopicWebDao.updatePraiseNum(topicPraise.getTopicId(), "+", datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param memId
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-7
     * @see 查询赞
     */
    public long queryPraise(Integer memId, Integer topicId, String datasource) {
        return bscTopicWebDao.queryPraise(memId, topicId, datasource);
    }

    /**
     * @param memId
     * @param topicId
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-7
     * @see 删除赞
     */
    public void deletePraise(Integer memId, Integer topicId, String datasource) {
        try {
            this.bscTopicWebDao.deletePraise(memId, topicId, datasource);
            bscTopicWebDao.updatePraiseNum(topicId, "-", datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param commentId
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-7
     * @see 删除评论
     */
    public void deleteComment(Integer commentId, Integer topicId, String datasource) {
        try {
            bscTopicWebDao.deleteComment(commentId, datasource);
            bscTopicWebDao.updateTopicNum(topicId, "-", datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public BscTopicComment queryCommentById(Integer commentId, String datasource) {
        return bscTopicWebDao.queryCommentById(commentId, datasource);
    }
    /**
     * 通过会员ID查找对应记录（真心话）
     */
	/*public List<BscTopic> queryBsctopicByMIdfsadf(Integer mid,String database){
		try {
			return this.bscTopicWebDao.queryBsctopicByMId(mid, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}*/

    /**
     * 根据会员ID查询(发表时间、点赞数、评论数、标题、内容、图片)
     */
    public Page page(Integer memberId, Integer pageNo, Integer pageSize) {
        try {
            Page page = new Page();
            SysMemDTO member = memberWebDao.queryMemByMemId(memberId);
            if (Objects.nonNull(member) && StringUtils.isNotBlank(member.getDatasource())) {
                String datasource = member.getDatasource();
                page = this.bscTopicWebDao.page(memberId, pageNo, pageSize, datasource);
                if (null != page.getRows() || page.getRows().size() != 0) {
                    List<BscTopic> list = page.getRows();
                    for (BscTopic p : list) {
                        p.setPicList(bscTopicWebDao.queryTopicPic(p.getTopicId(), datasource));
                    }
                }
            }
            return page;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
    /**
     * 真心话详情分页
     */
	/*public Page pages(Integer trueId,String database,Integer pageNo,Integer pageSize){
		try {
			Page page = this.bscTopicWebDao.pages(trueId, database, pageNo, pageSize);
			List<BscTopic> list = page.getRows();
			for(BscTopic p:list){
				p.setPicList(bscTopicWebDao.queryTopicPic(p.getTopicId(),database));
			}
			return page;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}*/

    /**
     * 查询主题明细
     */
    public BscTopicFactoryDTO queryTopicDetail(Integer topicId, Integer memId, String datasource) {
        try {
            BscTopicFactoryDTO bscTopicDTO = new BscTopicFactoryDTO();
            bscTopicDTO = bscTopicWebDao.queryTopicById(topicId, memId, datasource);
//			BscEmpGroupMember em = bscTopicWebDao.queryEmpMember(topicId,memId,datasource);
			/*if(null!=em){
				BscTopicFactoryDTO.set
			}else{
				
			}*/
            if (null != bscTopicDTO) {
                bscTopicDTO.setPicList(bscTopicWebDao.queryTopicPic(topicId, datasource));
                List<BscTopicComment> commentList = bscTopicWebDao.queryCommentList(topicId, datasource);//获取评论
                bscTopicDTO.setCommentList(commentList);
                if (null != commentList) {
                    for (BscTopicComment comment : commentList) {
                        comment.setRcList(bscTopicWebDao.queryRcList(comment.getCommentId(), datasource));//获取回复
                    }
                }
                bscTopicDTO.setPraiseList(bscTopicWebDao.queryPraiseList(topicId, datasource));
            }
            return bscTopicDTO;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param topicId
     * @return
     * @创建：作者:YYP 创建时间：2015-5-11
     * @see 根据id查询话题信息
     */
    public BscTopic queryTopicById(Integer topicId, String datasource) {
        try {
            return bscTopicWebDao.queryTopicById2(topicId, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param topicId
     * @创建：作者:YYP 创建时间：2015-5-15
     * @see 删除帖子
     */
    public void deleteTopic(Integer topicId, String datasource) {
        try {
            bscTopicWebDao.deleteTopic(topicId, datasource);
            chatMsgDao.deleteMsg("1", topicId, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
