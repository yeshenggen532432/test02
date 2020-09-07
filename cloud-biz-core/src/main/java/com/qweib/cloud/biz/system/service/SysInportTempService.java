package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.biz.common.ImportExcelsellerUtils;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTitleVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTypeBean;
import com.qweib.cloud.core.domain.SysImportTemp;
import com.qweib.cloud.core.domain.SysImportTempItem;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.repository.SysInportTempDao;
import com.qweib.cloud.repository.SysInportTempItemDao;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.JsonUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import com.qweibframework.excel.annotation.ModelProperty;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.poi.hssf.usermodel.*;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.util.*;


/**
 * 导入数据临时表
 */
@Slf4j
@Service
public class SysInportTempService {
    @Resource
    private SysInportTempDao sysInportTempDao;
    @Resource
    private SysInportTempItemDao sysInportTempItemDao;

    public SysImportTemp queryById(Integer id, String database) {
        return sysInportTempDao.queryById(id, database);
    }

    public Page queryPage(SysImportTemp sysImportTemp, Integer page, Integer rows, String database) {
        return sysInportTempDao.queryPage(sysImportTemp, page, rows, database);
    }

    public Page queryItemPage(SysImportTempItem sysImportTempItem, String queryStr, Integer page, Integer rows, String database) {
        return sysInportTempItemDao.queryItemPage(sysImportTempItem, queryStr, page, rows, database);
    }

    public List queryItemList(HttpServletRequest request, String database) throws Exception {
        return queryItemList(request, database, null);
    }

    public List queryItemList(HttpServletRequest request, String database, Map<Integer, SysImportTempItem> itemMap) throws Exception {
        String importId = request.getParameter("importId");
        String ids = request.getParameter("ids");
        String type = request.getParameter("type");
        if (StrUtil.isNull(importId) || StrUtil.isNull(ids) || StrUtil.isNull(type))
            throw new RuntimeException("列表ID不能为空");
        List<SysImportTempItem> list = sysInportTempItemDao.queryItemList(Integer.valueOf(importId), ids, SysImportTemp.StateEnum.state_save.getCode(), database);
        if (list == null || list.isEmpty()) throw new RuntimeException("数据未找到");
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(Integer.valueOf(type));
        List result = new ArrayList();
        for (SysImportTempItem sysImportTempItem : list) {
            if (itemMap != null)
                itemMap.put(sysImportTempItem.getId(), sysImportTempItem);
            Object temp = JsonUtil.readJsonObject(sysImportTempItem.getContextJson(), typeBean.getVo().getClass());
            if (temp == null) {
                Map map = JsonUtil.readJsonObject(sysImportTempItem.getContextJson(), LinkedHashMap.class);
                if (Collections3.isNotEmpty(map)) {
                    Iterator it = map.values().iterator();
                    String str = "";
                    while (it.hasNext()) {
                        str = (String) it.next();
                        if (StringUtils.isNotEmpty(str)) break;
                    }
                    throw new RuntimeException("关键字:(" + str + ")行格式错误");
                }
            }
            PropertyUtils.setProperty(temp, "id", sysImportTempItem.getId());
            result.add(temp);
        }
        if (result == null || result.isEmpty()) throw new RuntimeException("数据解析失败");
        return result;
    }

    /**
     * 批量修改完成
     *
     * @param ids
     * @param database
     */
    public void updateItemImportSuccess(String ids, String database) {
        if (StrUtil.isNull(ids)) return;
        sysInportTempItemDao.batchUpdate(ids, SysImportTemp.StateEnum.state_import_success.getCode(), database);
    }

    public void delete(Integer id, String database) {
        sysInportTempDao.delete(id, database);
    }


    /**
     * 获取上传文件导入临时表
     *
     * @param request
     * @param inputStream
     * @param info
     * @return
     * @throws Exception
     */
    public int addUploadExcel(HttpServletRequest request, InputStream inputStream, Integer type, SysLoginInfo info) throws Exception {
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(type);
        List<?> list = ImportExcelsellerUtils.readExcel(inputStream, typeBean.getVo(), getModelPropertyList(typeBean.getVo()));
        return save(list, type, info, SysImportTemp.InputDownEnum.input.getCode());
    }

    public int save(List<?> list, Integer type, SysLoginInfo info, Integer inputDown) throws Exception {
        if (type == null) throw new RuntimeException("类型错误");
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(type);
        if (typeBean == null || typeBean.getVo() == null) throw new RuntimeException("对象未找到");
        if (Collections3.isEmpty(list)) throw new RuntimeException("数据不能为空");
        List<ImportTitleVo> titleVoList = getModelPropertyList(typeBean.getVo());
        if (Collections3.isEmpty(titleVoList))
            throw new RuntimeException("对象列说明未找到");
        return save(list, titleVoList, info, type, inputDown);
    }


    public int save(List<?> list, List<ImportTitleVo> titleVoList, SysLoginInfo info, Integer type, Integer inputDown) throws Exception {
        if (Collections3.isEmpty(titleVoList)) throw new RuntimeException("标题不能为空");
        if (Collections3.isEmpty(list)) throw new RuntimeException("数据不能为空");
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(type);
        if (typeBean == null || typeBean.getVo() == null) throw new RuntimeException("对象未找到");
        SysImportTemp sysImportTemp = new SysImportTemp();
        sysImportTemp.setTitleJson(JsonUtil.toJson(titleVoList));
        sysImportTemp.setTitle(typeBean.getName());
        sysImportTemp.setType(type);
        sysImportTemp.setOperId(info.getIdKey());
        sysImportTemp.setOperName(info.getUsrNm());
        sysImportTemp.setInputDown(inputDown);
        int id = sysInportTempDao.add(sysImportTemp, info.getDatasource());
        if (id > 0) {
            List<SysImportTempItem> importTempItemList = new ArrayList<>(list.size());
            SysImportTempItem importTempItem = null;
            for (Object item : list) {
                if (beanFieldNull(item)) continue;
                importTempItem = new SysImportTempItem();
                importTempItem.setContextJson(JsonUtil.toJson(item));
                importTempItem.setImportId(id);
                importTempItem.setImportStatus(SysImportTemp.StateEnum.state_save.getCode());
                //sysInportTempItemDao.add(importTempItem, info.getDatasource());
                importTempItemList.add(importTempItem);
            }
            sysInportTempItemDao.batchUpdate(importTempItemList, info.getDatasource());
        } else {
            throw new RuntimeException("主表数据保存错误");
        }
        return id;
    }

    /**
     * 通过注解获取对象
     *
     * @param obj
     * @return
     */
    public List<ImportTitleVo> getModelPropertyList(Object obj) {
        List<ImportTitleVo> importTitleVoList = new ArrayList<>();
        ImportTitleVo vo = null;
        Class<?> clazz = obj.getClass();
        Field[] fields = clazz.getDeclaredFields();
        for (Field field : fields) {
            if (field.isAnnotationPresent(ModelProperty.class)) {
                ModelProperty annotation = field.getAnnotation(ModelProperty.class);
                //fieldMap.put(annotation.name(), field.getName());
                vo = new ImportTitleVo(annotation.label().trim(), field.getName().trim(), field.getType().getSimpleName());
                importTitleVoList.add(vo);
            }
        }
        return importTitleVoList;
    }

    /**
     * 得到属性值
     *
     * @param obj
     */
    public boolean beanFieldNull(Object obj) {
        boolean isNull = true;
        //得到class
        Class cls = obj.getClass();
        //得到所有属性
        Field[] fields = cls.getDeclaredFields();
        for (int i = 0; i < fields.length; i++) {//遍历
            try {
                //得到属性
                Field field = fields[i];
                //打开私有访问
                field.setAccessible(true);
                //获取属性
                String name = field.getName();
                //获取属性值
                Object value = field.get(obj);
                if (!StrUtil.isNull(value)) {
                    isNull = false;
                    break;
                }
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        return isNull;
    }

    /**
     * 修改或新增（改成一条一条数据操作了）
     *
     * @param request
     * @param updateItemList
     * @param type
     * @param state
     * @param info
     * @return
     * @throws Exception
     */
    public Map<String, Integer> updateOrSave(HttpServletRequest request, List<?> updateItemList, Integer type, int state, SysLoginInfo info) throws Exception {
        Map<String, Integer> map = new HashMap<>(1);
        //如果为空时说明是新增数据，否则为修改子项目数据
        //if (updateItemList == null || updateItemList.isEmpty()) throw new RuntimeException("数据不能为空");
        String importId = request.getParameter("importId");
        if (StrUtil.isNull(importId) || "0".equals(importId)) {
            map.put("importId", save(updateItemList, type, info, null));
            return map;
        } else {
            String changeIds = request.getParameter("changeIds");//修改过的ID
            List<String> changeList = null;
            if (!StrUtil.isNull(changeIds))
                changeList = Arrays.asList(changeIds.split(","));
            SysImportTempItem importTempItem = null;
            Set<String> batchIds = new HashSet<>();
            for (Object item : updateItemList) {
                if (beanFieldNull(item)) continue;
                Object id = PropertyUtils.getProperty(item, "id");
                importTempItem = new SysImportTempItem();
                importTempItem.setContextJson(JsonUtil.toJson(item));
                importTempItem.setImportId(Integer.valueOf(importId));
                importTempItem.setImportStatus(state);
                if (Objects.equals(state, SysImportTemp.StateEnum.state_import_success.getCode()))
                    importTempItem.setImportSuccessDate(new Date());
                if (StrUtil.isNull(id) || Integer.valueOf(id + "") < 0) {
                    map.put("id", sysInportTempItemDao.add(importTempItem, info.getDatasource()));
                    return map;
                } else {
                    importTempItem.setId(Integer.valueOf(id + ""));
                    if (changeList != null && changeList.contains(id + ""))//如果有改变内容时一个一个修改，否则批量修改
                        sysInportTempItemDao.update(importTempItem, info.getDatasource());
                    else if (Objects.equals(state, SysImportTemp.StateEnum.state_import_success.getCode())) {
                        batchIds.add(id + "");
                    }
                }
            }
            if (Collections3.isNotEmpty(batchIds))
                sysInportTempItemDao.batchUpdate(String.join(",", batchIds), state, info.getDatasource());
            //删除数据
            String deleteIds = request.getParameter("deleteIds");
            if (!StrUtil.isNull(deleteIds)) {
                sysInportTempItemDao.delete(deleteIds, info.getDatasource());
            }
        }
        return null;
    }

    /**
     * 导出到EXCEL
     *
     * @param response
     * @param typeEnum
     * @param list
     * @throws Exception
     */
    public void downDataToExcel(HttpServletResponse response, SysImportTemp.TypeEnum typeEnum, List<?> list, String excelName) throws Exception {
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(typeEnum.getCode());
        if (typeBean == null || typeBean.getVo() == null) throw new RuntimeException("对象未找到");
        List<ImportTitleVo> titleVoList = getModelPropertyList(typeBean.getVo());
        downDataToExcel(response, titleVoList, list, excelName);
    }

    public void downDataToExcel(HttpServletResponse response, List<ImportTitleVo> titleVoList, List<?> list, String excelName) throws Exception {
        // 创建工作薄
        HSSFWorkbook wb = new HSSFWorkbook();
        // 在工作薄上建一张工作表
        HSSFSheet sheet = wb.createSheet();
        HSSFRow row = sheet.createRow((short) 0);
        sheet.createFreezePane(0, 1);
        HSSFCellStyle cellstyle = wb.createCellStyle();
        cellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER_SELECTION);

        //创建标题
        for (int i = 0; i < titleVoList.size(); i++) {
            cteateCell(wb, row, (short) i, titleVoList.get(i).getTitle(), cellstyle);
        }
        //创建数据表格
        for (int i = 0; i < list.size(); i++) {
            HSSFRow dataRow = sheet.createRow((short) i + 1);
            Object obj = list.get(i);
            for (int m = 0; m < titleVoList.size(); m++) {
                ImportTitleVo titleVo = titleVoList.get(m);
                try {
                    Object value = PropertyUtils.getProperty(obj, titleVo.getField());
                    if (value != null)
                        cteateCell(wb, dataRow, (short) m, value.toString(), cellstyle);
                } catch (Exception e) {
                    log.error("导出字段解析出现错误", e);
                }
            }
        }
        OutputStream os = null;
        try {
            String strName = new String(excelName.getBytes("UTF-8"), "ISO-8859-1");
            //String fname = "wareTemplate" + System.currentTimeMillis();// Excel文件名
            os = response.getOutputStream();// 取得输出流
            response.reset();// 清空输出流
            response.setHeader("Content-disposition", "attachment; filename="
                    + strName + ".xls"); // 设定输出文件头,该方法有两个参数，分别表示应答头的名字和值。
            response.setContentType("application/msexcel");
            wb.write(os);
        } catch (Exception e) {
            log.error("导出商品出现错误", e);
        } finally {
            os.flush();
            os.close();
        }
    }

    @SuppressWarnings("deprecation")
    private void cteateCell(HSSFWorkbook wb, HSSFRow row, short col,
                            String val, HSSFCellStyle cellstyle) {
        HSSFCell cell = row.createCell(col);
        cell.setCellValue(val);
        //  HSSFCellStyle cellstyle = wb.createCellStyle();
        // cellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER_SELECTION);
        cell.setCellStyle(cellstyle);
    }
}
