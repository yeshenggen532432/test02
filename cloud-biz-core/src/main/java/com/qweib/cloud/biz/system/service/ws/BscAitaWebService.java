package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscAita;
import com.qweib.cloud.repository.ws.BscAitaWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BscAitaWebService {
	@Resource
	private BscAitaWebDao bscAitaWebDao;

	public Integer saveAt(List<BscAita> aitaList, String database) {
		int count=0;
		for (int i = 0; i < aitaList.size(); i++) {
			count = bscAitaWebDao.saveAt(aitaList.get(i),database);
		}
		return count;
	}

}
