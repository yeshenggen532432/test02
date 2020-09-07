package com.qweib.cloud.biz.system.service.ws;


import com.google.common.collect.Lists;
import com.qweib.cloud.core.domain.SysFeedback;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.feedback.FeedbackDTO;
import com.qweib.cloud.service.member.domain.feedback.FeedbackPicDTO;
import com.qweib.cloud.service.member.retrofit.FeedbackRetrofitApi;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.commons.mapper.BeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SysFeedbackService {

//    @Autowired
//    private FeedbackRetrofitApi feedbackApi;

    /**
     * 保存意见反馈和图片
     *
     * @param pic
     * @param feedback
     * @创建：作者:YYP 创建时间：2015-6-19
     */
    public void addFeedbackAndpic(List<String> pic, List<String> picMini,
                                  SysFeedback feedback) {
        FeedbackDTO dto = BeanMapper.map(feedback, FeedbackDTO.class);
        if (Collections3.isNotEmpty(pic) && Collections3.isNotEmpty(picMini) && pic.size() == picMini.size()) {
            List<FeedbackPicDTO> pics = Lists.newArrayList();
            for (int i = 0; i < pic.size(); i++) {
                FeedbackPicDTO picDto = new FeedbackPicDTO();
                picDto.setPic(pic.get(i));
                picDto.setPicMini(picMini.get(i));
                pics.add(picDto);
            }
            dto.setPics(pics);
        }
        //HttpResponseUtils.convertResponse(feedbackApi.add(dto));
    }

    /**
     * 获取任务反馈信息
     *
     * @param pageNo
     * @param pageSize
     * @param feedType
     * @param scontent
     * @return
     * @创建：作者:YYP 创建时间：2015-6-23
     */
    public Page queryFeedBackByPage(Integer pageNo, int pageSize, String feedType,
                                    String scontent) {
        try {

           //com.qweibframework.commons.page.Page<FeedbackDTO> page = HttpResponseUtils.convertResponse(feedbackApi.query(pageNo - 1, pageSize, feedType, scontent));

            Page p = new Page();
//            p.setTotal((int) page.getTotalCount());
//            p.setRows(page.getData());
//            p.setCurPage(pageNo);
//            p.setPageSize(pageSize);
//            p.setTotalPage(p.getTotalPage());
            return p;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

}
