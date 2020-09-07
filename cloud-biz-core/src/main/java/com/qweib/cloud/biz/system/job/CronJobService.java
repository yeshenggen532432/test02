package com.qweib.cloud.biz.system.job;

import com.qweib.cloud.core.domain.shop.ShopSetting;
import com.qweib.cloud.core.domain.vo.OrderType;
import com.qweib.cloud.repository.shop.CloudShopSettingDao;
import com.qweib.commons.Collections3;
import com.qweib.commons.StringUtils;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * 定时任务服务
 */
@Slf4j
@Service
public class CronJobService {

    @Resource
    private CloudShopSettingDao cloudShopSettingDao;
    @Resource
    private XxlJobService xxlJobService;

    /**
     * 一天秒数
     */
    private static final long DEF_DAY = 24 * 60 * 60;

    /**
     * 自动下班时间（12小时）
     */
    private static final long AUTO_DOWN_TIME = 12 * 60 * 60;

    //订单过期完成
    private static final String orderWaitFinish = "orderWaitFinish";
    private static final String orderJobHandler = "orderJobHandler";

    //订单过期取消
    private static final String orderOverdueCancel = "orderOverdueCancel";
    private static final String orderOverdueCancelJobHandler = "orderOverdueCancelJobHandler";

    //上班超过12小时自动下班
    private static final String workOvertimeAutoDown = "workOvertimeAutoDown";
    private static final String workOvertimeAutoDownJobHandler = "workOvertimeAutoDownJobHandler";

    //拼团订单过期取消
    private static final String tourOverdueCancel = "tourOverdueCancel";
    private static final String tourOverdueCancelJobHandler = "tourOverdueCancelJobHandler";

    //组团订单过期取消
    private static final String headTourOverdueCancel = "headTourOverdueCancel";
    private static final String headTourOverdueCancelJobHandler = "headTourOverdueCancelJobHandler";


    /**
     * 订单待完成（发货后或取消发货调用）
     *
     * @param id       订单ID
     * @param state    状态：0取消，1发货
     * @param database 数据库
     * @return
     */
    public boolean orderWaitFinish(int id, Integer state, String database) {
        if (state == null) throw new RuntimeException("状态不能为空0取消发货，1确认全部发货成功");
        String key = orderWaitFinish + "_" + database + "_" + id;
        if (state == 0) return delOrderWaitFinish(key, orderJobHandler);
        if (id == 0) throw new RuntimeException("订单不能为空");
        if (database == null || "".equals(database)) throw new RuntimeException("数据库不能为空");
        int day = 7;
        ShopSetting shopSetting = cloudShopSettingDao.queryByName(ShopSetting.NameEnum.order_rule.toString(), database);
        if (shopSetting != null) {
            Map<String, String> settingMap = shopSetting.getContextMap();
            if (settingMap != null && !settingMap.isEmpty()) {
                String automatic_delivery = settingMap.get("automatic_delivery");
                if (StringUtils.isNotEmpty(automatic_delivery))
                    day = Integer.valueOf(automatic_delivery);
            }
        }
        Map<String, String> map = new HashMap<>();
        map.put("id", id + "");
        map.put("database", database);
        map.put("type", orderWaitFinish);
        try {
            xxlJobService.addJob(key, DEF_DAY * day, orderJobHandler, JSONObject.fromObject(map).toString());
            return true;
        } catch (Exception e) {
            log.error("增加订单待完成,定时任务时出现错误" + e.getMessage());
        }
        return false;
    }

    /**
     * 删除定时任务
     *
     * @param id
     * @param database
     * @return
     */
    public boolean overdueOrderCancelDel(int id, String database) {
        String key = orderOverdueCancel + "_" + database + "_" + id;
        return delOrderWaitFinish(key, orderOverdueCancelJobHandler);
    }

    /**
     * 获取订单取消时间（秒）
     *
     * @param orderType 订单类型
     * @param database
     * @return
     */
    public long getOrderCancelTime(Integer orderType, String database) {
        Long time = DEF_DAY * 3;
        if (orderType != null && !Objects.equals(orderType, OrderType.general.getCode()))//如果不是普通订单时，默认为30分钟取消
            time = 30 * 60L;//30分钟

        ShopSetting shopSetting = cloudShopSettingDao.queryByName(ShopSetting.NameEnum.order_rule.toString(), database);
        if (shopSetting == null || Collections3.isEmpty(shopSetting.getContextMap())) {
            return time;
        }

        Map<String, String> settingMap = shopSetting.getContextMap();
        if (orderType != null && !Objects.equals(orderType, OrderType.general.getCode())) {
            String promotion_overdue_order_cancel = settingMap.get("promotion_overdue_order_cancel");
            if (StringUtils.isNotEmpty(promotion_overdue_order_cancel) && !"0".equals(promotion_overdue_order_cancel)) {
                time = Integer.valueOf(promotion_overdue_order_cancel) * 60L;
            }
        } else {
            String automatic_delivery = settingMap.get("overdue_order_cancel");
            if (StringUtils.isNotEmpty(automatic_delivery) && !"0".equals(automatic_delivery)) {
                time = Integer.valueOf(automatic_delivery) * DEF_DAY;
            }
        }
        return time;
    }

    /**
     * 下单后多久未支付，取消订单任务
     *
     * @param id        订单ID
     * @param orderType 状态：订单类型
     * @param database  数据库
     * @return
     */
    public boolean overdueOrderCancel(int id, Integer orderType, String database, long time) {
        String key = orderOverdueCancel + "_" + database + "_" + id;
        if (id == 0) throw new RuntimeException("订单不能为空");
        if (database == null || "".equals(database)) throw new RuntimeException("数据库不能为空");
        //Long time = getOrderCancelTime(orderType, database);
        Map<String, String> map = new HashMap<>();
        map.put("id", id + "");
        map.put("database", database);
        try {
            xxlJobService.addJob(key, time, orderOverdueCancelJobHandler, JSONObject.fromObject(map).toString());
            return true;
        } catch (Exception e) {
            log.error("增加订单取消任务时出现错误" + e.getMessage());
        }
        return false;
    }

    /**
     * 删除待完成订单定时任务
     *
     * @param key
     * @param executorHandler
     * @return
     */
    private boolean delOrderWaitFinish(String key, String executorHandler) {
        if (key == null) throw new RuntimeException("标记不能为空");
        try {
            xxlJobService.removeJob(key, executorHandler);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 上班超过12小时自动下班
     */
    public boolean workOvertimeAutoDown(String companyId, int mId, String database) {
        Map<String, String> map = new HashMap<>();
        map.put("mId", "" + mId);
        map.put("companyId", "" + companyId);
        map.put("database", database);
        map.put("type", workOvertimeAutoDown);
        try {
            //先取消任务（因为可以多次上班）
//            delWorkOvertimeAutoDown(companyId, mId);
            //备注：自动下班时间现在是固定12小时；后期可以由后台配置
            xxlJobService.addJob(workOvertimeAutoDown + "_" + companyId + "_" + mId, AUTO_DOWN_TIME, workOvertimeAutoDownJobHandler, JSONObject.fromObject(map).toString());
            return true;
        } catch (Exception e) {
            log.error("增加自动下班任务时出现错误" + e.getMessage());
        }
        return false;
    }

    /**
     * 删除自动下班任务
     */
    public boolean delWorkOvertimeAutoDown(String companyId, int mId) {
        try {
            delOrderWaitFinish(workOvertimeAutoDown + "_" + companyId + "_" + mId, workOvertimeAutoDownJobHandler);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    /**
     * 拼团过期结束
     *
     * @param id
     * @param endTime
     * @param database
     */
    public boolean overdueTourCancel(Integer id, Date endTime, String database) {
        String key = tourOverdueCancel + "_" + database + "_" + id;
        if (id == 0) throw new RuntimeException("订单不能为空");
        if (database == null || "".equals(database)) throw new RuntimeException("数据库不能为空");
        //Long time = getOrderCancelTime(orderType, database);
        Map<String, String> map = new HashMap<>();
        map.put("id", id + "");
        map.put("database", database);
        try {
            Long time = (endTime.getTime() - System.currentTimeMillis()) / 1000 + 1;
            xxlJobService.addJob(key, time, tourOverdueCancelJobHandler, JSONObject.fromObject(map).toString());
            return true;
        } catch (Exception e) {
            log.error("增加订单取消任务时出现错误" + e.getMessage());
        }
        return false;
    }

    public boolean overdueTourCancelDel(Integer id, String database) {
        String key = tourOverdueCancel + "_" + database + "_" + id;
        xxlJobService.removeJob(key, tourOverdueCancelJobHandler);
        return true;
    }

    /**
     * 拼团过期结束
     *
     * @param id
     * @param endTime
     * @param database
     */
    public boolean overdueHeadTourCancel(Integer id, Date endTime, String database) {
        String key = headTourOverdueCancel + "_" + database + "_" + id;
        if (id == 0) throw new RuntimeException("订单不能为空");
        if (database == null || "".equals(database)) throw new RuntimeException("数据库不能为空");
        //Long time = getOrderCancelTime(orderType, database);
        Map<String, String> map = new HashMap<>();
        map.put("id", id + "");
        map.put("database", database);
        try {
            Long time = (endTime.getTime() - System.currentTimeMillis()) / 1000 + 1;
            xxlJobService.addJob(key, time, headTourOverdueCancelJobHandler, JSONObject.fromObject(map).toString());
            return true;
        } catch (Exception e) {
            log.error("增加订单取消任务时出现错误" + e.getMessage());
        }
        return false;
    }

    public boolean overdueHeadTourCancelDel(Integer id, String database) {
        String key = headTourOverdueCancel + "_" + database + "_" + id;
        xxlJobService.removeJob(key, headTourOverdueCancelJobHandler);
        return true;
    }
}
