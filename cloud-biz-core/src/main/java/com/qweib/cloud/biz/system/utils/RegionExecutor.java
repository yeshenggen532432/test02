package com.qweib.cloud.biz.system.utils;

import com.qweib.cloud.biz.system.service.SysRegionService;
import com.qweib.cloud.core.domain.SysRegion;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zzx
 * @version 1.1 2019/11/26
 * @description:客户归属片区
 */
public class RegionExecutor {

    private final String database;
    private final SysRegionService sysRegionService;
    private final String regionSeparator = "/";
    private Map<String, Integer> regionMap = new HashMap<>();
    private Map<Integer, String> regionIdMap = new HashMap<>();


    public RegionExecutor(String database, SysRegionService sysRegionService) {
        this.database = database;
        this.sysRegionService = sysRegionService;
        init();
    }

    /**
     * @param regionStr 客户归属片区以/分开
     * @return
     */
    public Integer getRegiionId(String regionStr) {
        if (StringUtils.isEmpty(regionSeparator)) return null;
        Integer regionId = regionMap.get(regionStr);
        if (regionId != null) return regionId;
        String[] ss = regionStr.split(regionSeparator);
        StringBuffer name = new StringBuffer();
        StringBuffer parantName = new StringBuffer();
        for (int i = 0; i < ss.length; i++) {
            String str = ss[i];
            if (name.length() > 0)
                name.append(regionSeparator);
            name.append(str);

            regionId = regionMap.get(name.toString());
            if (regionId == null) {//如果为空时新建
                Integer pid = null;
                if (parantName.length() > 0) {
                    pid = regionMap.get(parantName.toString());
                }
                regionId = save(pid, str, i == ss.length - 1);
                String temp = parantName.length() == 0 ? str : name.toString();
                regionMap.put(temp, regionId);
            }
            if (parantName.length() > 0)
                parantName.append(regionSeparator);
            parantName.append(str);
        }
        return regionId;
    }

    public String getRegiionStr(Integer regiionId) {
        return regionIdMap.get(regiionId);
    }

    private Integer save(Integer pid, String str, boolean last) {
        if (pid == null) pid = 0;
        SysRegion region = new SysRegion();
        region.setRegionNm(str);
        region.setRegionPid(pid);
        region.setRegionLeaf(last ? "1" : "0");
        sysRegionService.addregion(region, this.database);
        return region.getRegionId();
    }

    private void init() {
        List<SysRegion> regionList = sysRegionService.queryList(null, database);
        for (SysRegion sysRegion : regionList) {
            String name = sysRegion.getRegionNm();
            final Integer pid = sysRegion.getRegionPid();
            if (MathUtils.valid(pid)) {
                name = regionIdMap.get(pid) + regionSeparator + name;
            }
            regionMap.put(name, sysRegion.getRegionId());
            regionIdMap.put(sysRegion.getRegionId(), name);
        }
    }
}
