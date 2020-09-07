package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscAita;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class BscAitaWebDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	public int saveAt(BscAita bscAita, String database) {
		try {
			return this.daoTemplate.addByObject("bsc_aita", bscAita);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
