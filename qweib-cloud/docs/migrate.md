## 2019/1/16

### 类迁移
`SysBforderWebControl.java` -> `cloud-biz-erp`
`SysWareWebControl.java` -> `cloud-biz-erp`

### 文件上传配置调整

`spring-mvc.xml`

```xml
    <mvc:resources mapping="/resource/**" location="/resource/" />
    <mvc:resources mapping="/upload/**" location="file:${upload.dir}/" />
    <mvc:resources mapping="/*.txt" location="file:${upload.dir}/checkWeixin/" />    
```
`profile.properties`
```properties
    upload.dir=E:/web/8081/cnlife/upload
```


## 2019/1/10

`SysWareService` -> `cloud-biz-erp`

`SysWareControl` -> `cloud-biz-erp`

`SysBforderControl` -> `cloud-biz-erp`


<del>bsc_invitation 邀请信息记录</del>

<del>group_goods--</del>

<del>group_goods_detail--</del>

<del>shop_member_company</del>

shop_pay_log--

<del>sys_area</del>

sys_bfpc--

sys_chat_msg-- (平台与企业数据库都有)

<del>sys_corporation_renew</del>

<del>sys_corporationtp</del> 手机端获取公司类型列表

sys_feedback--
sys_feedback_pic--
sys_ghtype--
sys_hzfs--
<del>sys_khlevel(bug)--</del>
sys_logistics--

<del>sys_mem_bind (平台与企业数据库都有)</del>

<del>sys_member_msg (平台与企业数据库都有)</del>

sys_notice--

<del>sys_qdtype (平台与企业数据库都有)</del>

sys_role--
sys_role_member--
sys_role_menu--

sys_sctype (平台与企业数据库都有)
sys_subject_msg
sys_use_log (系统使用日志)
sys_version
sys_xsphase (平台与企业数据库都有)
sys_xstype--
```

