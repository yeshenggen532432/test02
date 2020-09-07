package com.qweib.cloud.core.domain.job;

import lombok.Data;
import lombok.ToString;

import java.util.Date;


@Data
@ToString
public class SysCronJob {
    private String jobName;//作业名称
    private String jobClass;//作业实现类
    private String cron;//操作时间
    private Integer shardingTotalCount;//分片数量
    private String jobParameter;//参数
    private String shardingItemParameters;//分片参数
    private Date createTime;//创建时间
    private Integer state;//状态0失败，1成功
    private Date updateTime;
}
