package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysBrand;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBrandDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysBrandService {
	@Resource
	private SysBrandDao BrandDao;
	

	public Page queryBrandPage(SysBrand brand,String database,Integer page,Integer limit){
		try {
			return this.BrandDao.queryBrandPage(brand, database, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public List<SysBrand> queryList(SysBrand brand,String database){
		try {
			return this.BrandDao.queryList(brand, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public int addBrand(SysBrand brand,String database){
		try {
			return this.BrandDao.addBrand(brand, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public int updateBrand(SysBrand brand,String database){
		try {
			return this.BrandDao.updateBrand(brand, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public SysBrand queryBrandById(Integer Id,String database){
		try {
			return this.BrandDao.queryBrandById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public int deleteBrandById(Integer Id,String database){
		try {
			return this.BrandDao.deleteBrandById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
		
	}
}
