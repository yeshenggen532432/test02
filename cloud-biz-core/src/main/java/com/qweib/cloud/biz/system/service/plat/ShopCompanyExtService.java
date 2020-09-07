package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.biz.system.utils.JiaMiCodeUtil;
import com.qweib.cloud.core.domain.ShopMemberCompany;
import com.qweib.cloud.core.domain.SysCompanyShopExt;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.domain.SysMallShopVo;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.ShopCompanyExtDao;
import com.qweib.cloud.repository.plat.ShopMemberCompanyDao;
import com.qweib.cloud.service.member.domain.corporation.shop.CompanyShopExtDTO;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
public class ShopCompanyExtService {
    @Resource
    private ShopCompanyExtDao shopCompanyExtDao;

    @Resource
    private ShopMemberCompanyDao shopMemberCompanyDao;

    @Resource
    private SysCorporationService sysCorporationService;

    /**
     * 商城列表
     *
     * @param corporation
     * @param pageNo
     * @param limit
     * @return
     */
    public Page queryCorporationShopExt(SysCorporation corporation, Integer pageNo, Integer limit) {

        if(corporation.getExcludeMemberId()!= null)
        {
            ShopMemberCompany query = new ShopMemberCompany();
            query.setMemberId(corporation.getExcludeMemberId());
            query.setMemberCompany(corporation.getDeptNm());
            Page p = this.shopMemberCompanyDao.queryShopMemberCompany(query,pageNo,limit);
            List<SysMallShopVo> list = new ArrayList<>();
            List<ShopMemberCompany> shopList = p.getRows();
            for(ShopMemberCompany vo: shopList)
            {
                SysMallShopVo mall = new SysMallShopVo();
                mall.setCompanyId(JiaMiCodeUtil.encode(vo.getCompanyId().toString()));
                mall.setShopLogo(vo.getShopLogo());
                mall.setShopName(vo.getShopName());
                SysCorporation cor = this.sysCorporationService.queryCorporationById(vo.getCompanyId());
                if(cor!= null)
                {
                    mall.setDatasource(cor.getDatasource());
                    mall.setAddress(cor.getDeptAddr());
                }
                list.add(mall);
            }
            p.setRows(list);
            return p;

        }
        else
        {
            Page p = this.shopCompanyExtDao.queryCorporationShopExt1(corporation, pageNo, limit);
            List<SysCompanyShopExt> shopList = p.getRows();
            List<SysMallShopVo> list = new ArrayList<>();
            for(SysCompanyShopExt vo: shopList)
            {
                SysMallShopVo mall = new SysMallShopVo();
                mall.setCompanyId(JiaMiCodeUtil.encode(vo.getCompanyId().toString()));
                mall.setShopLogo(vo.getShopLogo());
                mall.setShopName(vo.getShopName());
                SysCorporation cor = this.sysCorporationService.queryCorporationById(vo.getCompanyId());
                if(cor!= null)
                {
                    mall.setDatasource(cor.getDatasource());
                    mall.setAddress(cor.getDeptAddr());
                }
                list.add(mall);
            }
            p.setRows(list);
            return p;
        }

    }

    public Page queryCorporationShopExt1(SysCorporation corporation, Integer pageNo, Integer limit) {
        try {
            return this.shopCompanyExtDao.queryCorporationShopExt1(corporation, pageNo, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 用户所属企业列表
     *
     * @param memberId
     * @return
     */
    public List<CompanyShopExtDTO> queryMySysCompany(Integer memberId) {
        try {
            return this.shopCompanyExtDao.queryMySysCompany(memberId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 企业对应的商城对象
     *
     * @param companyId
     * @return
     */
    public CompanyShopExtDTO get(Integer companyId) {
        try {
            return this.shopCompanyExtDao.get(companyId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
