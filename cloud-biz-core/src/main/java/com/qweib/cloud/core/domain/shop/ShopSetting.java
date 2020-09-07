package com.qweib.cloud.core.domain.shop;

import com.google.common.collect.Maps;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.TableAnnotation;
import lombok.Data;
import lombok.ToString;
import net.sf.json.JSONObject;

import java.io.Serializable;
import java.util.Map;

/**
 * 商城基本设置
 */
@Data
@ToString
public class ShopSetting implements Serializable {

    private static final long serialVersionUID = 1L;

    private String name;//配置名称，唯一
    private String context;//内容json

    public ShopSetting() {

    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Map<String, String> getContextMap() {
        if (this.context != null && !"".equals(this.context))
            return JSONObject.fromObject(this.context);
        return null;
    }


    public ShopSetting(String name, Map<String, String> map) {
        if (map != null && !map.isEmpty())
            this.context = JSONObject.fromObject(map).toString();
        this.name = name;
    }


    public enum NameEnum {
        order_rule("/shop/basic/setting/shopSetting_orderRule"),//订单规则名称
        order_limit("/shop/basic/setting/shopSetting_orderLimit"),//订单限制
        location_transport("/shop/basic/setting/transport/locationSetting"),//同城运费设置
        store_location("/shop/basic/setting/transport/locationSetting"),//店铺所在位置
        _gradeId("/shop/basic/setting/shopSetting_orderLimit"),//等级ID
        distribution_mode("/shop/basic/setting/transport/distributionMode"),//配送方式
        distributor_setting("/shop/distributor/distributorSettingPage"),//三级分销设置
        micro_setting("/shop/basic/setting/microSettingPage");//分销设置
        private String url;

        NameEnum(String url) {
            this.url = url;
        }

        Map<String, String> map = Maps.newHashMap();

        public String getUrl(String name) {
            if (Collections3.isEmpty(map)) {
                System.out.println(1);
                NameEnum[] enums = NameEnum.values();
                for (int i = 0; i < enums.length; i++) {
                    NameEnum nameEnum = enums[i];
                    map.put(nameEnum.name(), nameEnum.url);
                }
            }
            return map.get(name);
        }
    }
}
