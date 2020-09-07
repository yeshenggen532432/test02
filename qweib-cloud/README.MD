
### 模块说明
```html
├── profiles
|   ├── dev.properties       开发环境配置
|   ├── test.properties      测试环境配置
|   └── prod.properties      生产环境配置
├── cloud-biz                
|   ├── cloud-biz-core     基础模块
|   ├── cloud-biz-erp        ERP模块
|   ├── cloud-biz-attendance 考勤模块
|   ├── cloud-biz-pos        收银模块
|   └── cloud-biz-mall       商城模块
├── cloud-application        系统聚合(集成)
└── cloud-web                系统配置+UI (war)
```

### JDBC配置加密

```bash
java -cp druid-1.0.16.jar com.alibaba.druid.filter.config.ConfigTools you_password
```

输出
```
privateKey:MIIBVgIBADANBgkqhkiG9w0BAQEFAASCAUAwggE8AgEAAkEA6+4avFnQKP+O7bu5YnxWoOZjv3no4aFV558HTPDoXs6EGD0HP7RzzhGPOKmpLQ1BbA5viSht+aDdaxXp6SvtMQIDAQABAkAeQt4fBo4SlCTrDUcMANLDtIlax/I87oqsONOg5M2JS0jNSbZuAXDv7/YEGEtMKuIESBZh7pvVG8FV531/fyOZAiEA+POkE+QwVbUfGyeugR6IGvnt4yeOwkC3bUoATScsN98CIQDynBXC8YngDNwZ62QPX+ONpqCel6g8NO9VKC+ETaS87wIhAKRouxZL38PqfqV/WlZ5ZGd0YS9gA360IK8zbOmHEkO/AiEAsES3iuvzQNYXFL3x9Tm2GzT1fkSx9wx+12BbJcVD7AECIQCD3Tv9S+AgRhQoNcuaSDNluVrL/B/wOmJRLqaOVJLQGg==
publicKey:MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAOvuGrxZ0Cj/ju27uWJ8VqDmY7956OGhVeefB0zw6F7OhBg9Bz+0c84RjzipqS0NQWwOb4kobfmg3WsV6ekr7TECAwEAAQ==
password:PNak4Yui0+2Ft6JSoKBsgNPl+A033rdLhFw+L0np1o+HDRrCo9VkCuiiXviEMYwUgpHZUFxb2FpE0YmSguuRww==
```
`配置数据源，提示Druid数据源需要对数据库密码进行解密。`

```xml
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource"
     init-method="init" destroy-method="close">
     <property name="url" value="jdbc:derby:memory:spring-test;create=true" />
     <property name="username" value="sa" />
     <property name="password" value="${password}" />
     <property name="filters" value="config" />
     <property name="connectionProperties" value="config.decrypt=true;config.decrypt.key=${publickey}" />
</bean>
```
`配置参数，让ConfigFilter解密密码`

有三种方式配置：

> 1. 可以在配置文件my.properties中指定config.decrypt=true 
> 2. 也可以在DruidDataSource的ConnectionProperties中指定config.decrypt=true 
> 3. 也可以在jvm启动参数中指定-Ddruid.config.decrypt=true 

