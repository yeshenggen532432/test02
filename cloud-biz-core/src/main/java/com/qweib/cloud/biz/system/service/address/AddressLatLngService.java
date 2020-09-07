package com.qweib.cloud.biz.system.service.address;

import com.qweib.cloud.core.domain.SysCustomer;
import com.qweib.commons.StringUtils;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import javax.annotation.Resource;
import java.text.DecimalFormat;

/**
 * @author zzx
 * @version 1.1 2020/5/16
 * @description: 地址获取对应的经纬度
 */
@Slf4j
@Service
public class AddressLatLngService {

    @Resource
    private RestTemplate restTemplate;

    private final static String url = "http://api.map.baidu.com/geocoder/v2/?output=json&ak=A6lwDScPTc1VDRsD6GAa0N8X&address=";

    public void handleCustomer(SysCustomer sysCustomer) {
        try {
            if (StringUtils.isNotEmpty(sysCustomer.getAddress()) && StringUtils.isEmpty(sysCustomer.getLatitude()) || StringUtils.isEmpty(sysCustomer.getLongitude())) {//如果地址不为空并经纬度不为空时去百度获取经纬度
                String str = handle(sysCustomer.getAddress());
                if (StringUtils.isNotEmpty(str)) {
                    String[] ss = str.split(",");
                    if (ss.length < 2)
                        return;
                    sysCustomer.setLongitude(ss[0]);
                    sysCustomer.setLatitude(ss[1]);
                }
            }

        } catch (Exception e) {
            log.error("获取客户经纬度出现错误", e);
        }
    }

    public String handle(String address) {
        if (StringUtils.isEmpty(address)) return null;
        ResponseEntity<String> responseEntity = restTemplate.getForEntity(url + address, String.class);
        JSONObject obj = JSONObject.fromObject(responseEntity.getBody());
        if ("0".equals(obj.getString("status"))) {
            double lng = obj.getJSONObject("result").getJSONObject("location").getDouble("lng"); // 经度
            double lat = obj.getJSONObject("result").getJSONObject("location").getDouble("lat"); // 纬度
            DecimalFormat df = new DecimalFormat("#.######");
            return df.format(lng) + "," + df.format(lat);
        }
        return null;
    }


    public static void main(String[] argc) {
        new AddressLatLngService().handle("福建省厦门市思明区二轻大厦");
    }
}
