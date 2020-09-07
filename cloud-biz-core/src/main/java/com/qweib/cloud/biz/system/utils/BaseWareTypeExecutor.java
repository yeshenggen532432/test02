package com.qweib.cloud.biz.system.utils;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.core.domain.SysWaretype;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;

import java.util.List;
import java.util.Map;

/**
 * 分类处理类型
 */
public class BaseWareTypeExecutor {
    public static final String DEFAULT_PRODUCT_TYPE = "未分类";
    private final Map<String, SysWaretype> productTypeCache = Maps.newHashMap();
    private final Map<Integer, String> typeNameCache = Maps.newHashMap();
    protected final String database;
    private final String typeSeparator;
    private final SysWaretypeService productTypeService;

    public BaseWareTypeExecutor(String database, String typeSeparator, SysWaretypeService productTypeService) {
        this.database = database;
        this.typeSeparator = typeSeparator;
        this.productTypeService = productTypeService;
        initialData();
    }

    /**
     * 根据ID获取分类名称，大类/小类
     *
     * @param produceId
     * @return
     */
    public String getProduceNames(Integer produceId) {
        if (produceId == null) return "";
        return typeNameCache.get(produceId);
    }

    /**
     * 获取产品类别 id，不存在就创建新的
     *
     * @param productType 产品类别名称，例：(啤酒/青岛)
     * @return
     */
    public Integer getProductType(String productType) {
        if (StringUtils.isBlank(productType)) {
            productType = DEFAULT_PRODUCT_TYPE;
        }
        SysWaretype sysWaretype = this.productTypeCache.get(productType);
        if (sysWaretype != null && MathUtils.valid(sysWaretype.getWaretypeId())) {
            return sysWaretype.getWaretypeId();
        }
        Integer typeId = 0;
        boolean found = true;
        StringBuilder nameBuilder = new StringBuilder(productType.length());
        final String[] typeNames = productType.split(typeSeparator);
        for (int i = 0; i < typeNames.length; i++) {
            String typeName = typeNames[i];
            if (nameBuilder.length() > 0)
                nameBuilder.append(typeSeparator);
            nameBuilder.append(typeName);
            if (!found) {
                typeId = saveProductType(typeId, typeName, i == typeNames.length-1, nameBuilder.toString());
                continue;
            }
            sysWaretype = this.productTypeCache.get(nameBuilder.toString());
            if (sysWaretype != null && MathUtils.valid(sysWaretype.getWaretypeId()) && !MathUtils.valid(sysWaretype.getWaretypePid())) {//必须是顶级相同,防止人家的下级和自己的顶级相同
                typeId = sysWaretype.getWaretypeId();
                continue;
            } else {
                // 如果查找不到，那以后级别直接保存
                found = false;
                typeId = saveProductType(typeId, typeName, i == typeNames.length-1, nameBuilder.toString());
            }
        }
        //this.productTypeCache.put(productType, typeId);
        return typeId;
    }


    /**
     * 保存产品类别
     *
     * @param parentId 上级 id
     * @param typeName 类别名称
     * @return
     */
    private Integer saveProductType(Integer parentId, String typeName, boolean last, String allTypeName) {
        SysWaretype productType = new SysWaretype();
        productType.setWaretypePid(parentId);
        productType.setWaretypeNm(typeName);
        productType.setWaretypeLeaf(last ? "1" : "0");
        Integer typeId = this.productTypeService.addWaretype(productType, database);
        this.productTypeCache.put(allTypeName, productType);
        this.typeNameCache.put(productType.getWaretypeId(), allTypeName);
        return typeId;
    }


    public void initialData() {
        List<SysWaretype> waretypes = this.productTypeService.queryList(null, database);
        for (SysWaretype productType : waretypes) {
            final Integer parentId = productType.getWaretypePid();
            final Integer typeId = productType.getWaretypeId();
            final String typeName = productType.getWaretypeNm();
            StringBuilder nameBuilder = new StringBuilder(64);
            if (MathUtils.valid(parentId)) {
                String parentName = typeNameCache.get(parentId);
                nameBuilder.append(parentName).append(typeSeparator);
            }
            nameBuilder.append(typeName);
            String allTypeName = nameBuilder.toString();
            typeNameCache.put(typeId, allTypeName);
            productTypeCache.put(allTypeName, productType);
        }
    }
}
