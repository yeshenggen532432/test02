package com.qweib.cloud.biz.sms.service.impl;

import com.qweib.cloud.biz.sms.service.SmsTotalService;
import com.qweib.cloud.core.domain.sms.SmsDeductRecord;
import com.qweib.cloud.core.domain.sms.SmsTotal;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.repository.sms.SmsDeductRecordDao;
import com.qweib.cloud.repository.sms.SmsPayRecordDao;
import com.qweib.cloud.repository.sms.SmsTotalDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Objects;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/4/29 - 15:38
 */
@Service
public class SmsTotalServiceImpl implements SmsTotalService {

    @Autowired
    private SmsTotalDao smsTotalDao;
    @Autowired
    private SmsPayRecordDao smsPayRecordDao;
    @Autowired
    private SmsDeductRecordDao smsDeductRecordDao;


//    @Override
//    public void addTotal(String database, Integer type, Integer total) {
//        SmsTotal smsTotal = smsTotalDao.get(database);
//        if (Objects.nonNull(smsTotal)) {
//            this.smsTotalDao.update(database, smsTotal.getTotal() + total, smsTotal.getVersion());
//        } else {
//            this.smsTotalDao.save(database, total);
//        }
//
//        SmsPayRecord record = new SmsPayRecord();
//        record.setType(type);
//        record.setTotal(total);
//
//        this.smsPayRecordDao.save(database, record);
//    }

    @Override
    public void updateDeductTotal(String database, Integer total) {
        SmsTotal smsTotal = smsTotalDao.get(database);
        if (Objects.isNull(smsTotal)) {
            throw new BizException("短信数量不够扣除");
        }

        int resultTotal = smsTotal.getTotal() - total;
        if (resultTotal < 0) {
            throw new BizException("短信数量不够扣除");
        }

        this.smsTotalDao.update(database, resultTotal, smsTotal.getVersion());

        SmsDeductRecord record = new SmsDeductRecord();
        record.setTotal(total);
        this.smsDeductRecordDao.save(database, record);
    }

    @Override
    public Integer getTotal(String database) {
        SmsTotal smsTotal = smsTotalDao.get(database);
        return Objects.nonNull(smsTotal) ? smsTotal.getTotal() : 0;
    }
}
