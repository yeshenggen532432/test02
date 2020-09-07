package com.qweib.cloud.biz.system.service.ws;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.domain.SysNotice;
import com.qweib.cloud.repository.SysNoticeDao;
import com.qweib.cloud.repository.plat.SysCorporationDao;
import com.qweib.cloud.service.basedata.domain.config.SysNoticeDTO;
import com.qweib.cloud.service.basedata.domain.config.SysNoticeDetailDTO;
import com.qweib.cloud.service.basedata.domain.config.SysNoticeMySelfQuery;
import com.qweib.cloud.service.basedata.retrofit.SysNoticeRequest;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.http.ResponseUtils;
import org.dozer.Mapper;
import org.joda.time.DateTimeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * 公告业务类
 *
 * @author guojp
 */
@Service
public class SysWebNoticeService {

    @Autowired
    private SysNoticeDao sysNoticeDao;
//    @Autowired
//    private SysNoticeRequest noticeRequest;
    @Autowired
    private Mapper mapper;

    @Autowired
    private SysCorporationDao sysCorporationDao;

    /**
     * 公告分页查询
     */
    public Page page(String companyId, String memberId, Boolean hasAdmin, Integer pageNo, Integer pageSize) {

        SysNotice vo = new SysNotice();
        try {
            String dateStr = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
            vo.setStartTime(dateStr);
        }
        catch (Exception e)
        {

        }
        SysCorporation company = this.sysCorporationDao.queryCorporationById(Integer.parseInt(companyId));
        if(company!= null)
        {
            vo.setDatasource(company.getDatasource());
        }
        if(!hasAdmin)vo.setMemberId(Integer.parseInt(memberId));
        return this.sysNoticeDao.queryNotice(vo,pageNo,pageSize);

//        SysNoticeMySelfQuery query = new SysNoticeMySelfQuery();
//        query.setMySelfCompanyId(companyId);
//        query.setMySelfMemberId(memberId);
//        query.setMySelfIsAdmin(hasAdmin);
//        Page<SysNoticeDTO> page = ResponseUtils.convertResponse(this.noticeRequest.pageMySelf(query, pageNo, pageSize));
//        if (Collections3.isNotEmpty(page.getData())) {
//            List<SysNotice> notices = Lists.newArrayList();
//            for (SysNoticeDTO noticeDTO : page.getData()) {
//                SysNotice notice = mapper.map(noticeDTO, SysNotice.class);
//
//                notices.add(notice);
//            }
//
//            return new Page(notices, page.getTotalCount(), pageNo, pageSize);
//        } else {
//            return new Page(Lists.newArrayListWithCapacity(0), page.getTotalCount(), pageNo, pageSize);
//        }

    }

    /**
     * 通过ID获取公告信息
     */
    public SysNotice queryNoticeById(Integer id, String database) {
//        SysNoticeDetailDTO noticeDetailDTO = ResponseUtils.convertResponseNull(this.noticeRequest.get(id));
//        if (noticeDetailDTO != null) {
//            return mapper.map(noticeDetailDTO, SysNotice.class);
//        } else {
//            return null;
//        }
        return null;
   }

}
