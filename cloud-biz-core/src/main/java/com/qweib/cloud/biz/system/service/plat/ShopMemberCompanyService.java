package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.ShopMemberCompany;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.plat.ShopMemberCompanyDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class ShopMemberCompanyService {
    @Resource
    private ShopMemberCompanyDao shopMemberCompanyDao;

    public Page queryShopMemberCompany(ShopMemberCompany member, Integer page, Integer limit) {
        return this.shopMemberCompanyDao.queryShopMemberCompany(member, page, limit);

    }

    public int addMemberCompany(ShopMemberCompany bo)
    {
        return this.shopMemberCompanyDao.addShopMemberCompany(bo);
    }

	/*@Deprecated
	public Integer addShopMemberCompany(ShopMemberCompany member){
		try{
			
			return this.shopMemberCompanyDao.addShopMemberCompany(member);
		
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}*/

    public void updateShopMemberCompany(ShopMemberCompany member) {
        try {
            this.shopMemberCompanyDao.updateShopMemberCompany(member);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public ShopMemberCompany queryShopMemberCompanyById(Integer Id) {
        try {
            return this.shopMemberCompanyDao.queryShopMemberCompanyById(Id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<ShopMemberCompany> queryShopMemberCompanyList(ShopMemberCompany member) {
        try {

            return this.shopMemberCompanyDao.queryShopMemberCompanyList(member);

        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

	/*@Deprecated
	public int queryShopMemberCompanyByTel(String tel){
		try {
			return this.shopMemberCompanyDao.queryShopMemberCompanyByTel(tel);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}*/
}
