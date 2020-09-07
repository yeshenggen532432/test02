SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `approval_transfer_order_config`;

CREATE TABLE `approval_transfer_order_config` (
                                                `id` varchar(36) NOT NULL,
                                                `no` varchar(50) NOT NULL,
                                                `approval_type` varchar(10) NOT NULL,
                                                `transfer_order_type` varchar(10) NOT NULL,
                                                `status` varchar(10) NOT NULL DEFAULT '0',
                                                `system_approval` smallint(6) NOT NULL DEFAULT '0',
                                                `approval_id` varchar(100) NOT NULL,
                                                `account_subject_type` varchar(10) NOT NULL,
                                                `account_subject_item` varchar(20) NOT NULL,
                                                `payment_account` varchar(36) DEFAULT NULL,
                                                `created_by` int(11) NOT NULL,
                                                `created_time` datetime NOT NULL,
                                                `updated_by` int(11) NOT NULL,
                                                `updated_time` datetime NOT NULL,
                                                PRIMARY KEY (`id`),
                                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_audit`;

CREATE TABLE `bsc_audit` (
                           `audit_no` varchar(100) NOT NULL,
                           `member_id` int(11) DEFAULT NULL,
                           `tp` varchar(255) NOT NULL,
                           `add_time` varchar(100) DEFAULT NULL,
                           `stime` varchar(100) DEFAULT NULL,
                           `etime` varchar(100) DEFAULT NULL,
                           `audit_data` varchar(255) DEFAULT NULL,
                           `dsc` text,
                           `is_over` varchar(10) NOT NULL DEFAULT '2' COMMENT '否是结束（1-1 完成  1-2 拒绝 1-3 撤销 2 未完成 ）',
                           `audit_tp` varchar(10) NOT NULL COMMENT '1 请假 2 报销 3 出差 4 物品领用5 通用审批',
                           `check_nm` varchar(100) DEFAULT NULL,
                           `title` varchar(100) DEFAULT NULL COMMENT '标题',
                           `zdy_nm` varchar(50) DEFAULT NULL,
                           `zdy_id` varchar(36) DEFAULT NULL,
                           `amount` decimal(15, 3) DEFAULT NULL,
                           `file_nms` varchar(200) DEFAULT NULL COMMENT '文件',
                           PRIMARY KEY (`audit_no`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_audit_pic`;

CREATE TABLE `bsc_audit_pic` (
                               `pic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
                               `audit_no` varchar(100) NOT NULL,
                               `pic_mini` varchar(200) NOT NULL COMMENT '图片小图',
                               `pic` varchar(200) NOT NULL COMMENT '图片',
                               PRIMARY KEY (`pic_id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_audit_zdy`;

CREATE TABLE `bsc_audit_zdy` (
                               `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自定义id',
                               `member_id` int(11) NOT NULL COMMENT '用户id',
                               `zdy_nm` varchar(50) NOT NULL COMMENT '自定义名称',
                               `tp` varchar(20) DEFAULT NULL COMMENT '类型',
                               `mem_ids` varchar(100) DEFAULT NULL,
                               `is_sy` varchar(2) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_bill_config`;

CREATE TABLE `bsc_bill_config` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `title` varchar(50) DEFAULT NULL COMMENT '配置名称',
                                 `namespace` varchar(50) NOT NULL COMMENT '所属模块',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_bill_config_item`;

CREATE TABLE `bsc_bill_config_item` (
                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                      `config_id` int(11) NOT NULL COMMENT '配置ID',
                                      `field` varchar(50) DEFAULT NULL COMMENT '字段KEY',
                                      `width` int(11) DEFAULT NULL COMMENT '宽度',
                                      `type` int(11) DEFAULT NULL COMMENT '配置类型',
                                      `hidden` tinyint(4) DEFAULT NULL COMMENT '是否隐藏禁用',
                                      `reserved` tinyint(4) DEFAULT NULL COMMENT '是否系统保留',
                                      `sort` int(11) DEFAULT NULL COMMENT '排序',
                                      `title` varchar(100) DEFAULT NULL COMMENT '选项名称',
                                      PRIMARY KEY (`id`),
                                      tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_bill_snapshot`;

CREATE TABLE `bsc_bill_snapshot` (
                                   `id` varchar(32) NOT NULL,
                                   `title` varchar(100) DEFAULT NULL,
                                   `user_id` int(11) NOT NULL,
                                   `bill_type` varchar(20) NOT NULL,
                                   `bill_id` int(11) DEFAULT NULL,
                                   `data` text,
                                   `create_time` bigint(20) DEFAULT NULL,
                                   `update_time` bigint(20) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_check`;

CREATE TABLE `bsc_check` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `audit_no` varchar(100) NOT NULL,
                           `member_id` int(11) NOT NULL,
                           `check_time` varchar(100) DEFAULT NULL,
                           `dsc` varchar(255) DEFAULT NULL,
                           `check_tp` varchar(10) DEFAULT NULL COMMENT '1发起申请 2 同意 3 拒绝 4 转发 5 撤销',
                           `is_check` varchar(10) NOT NULL DEFAULT '0' COMMENT '0 未走到该流程 1 走到该流程 2 完成流程',
                           `check_num` varchar(10) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_check_rule`;

CREATE TABLE `bsc_check_rule` (
                                `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '考勤规则id',
                                `member_id` int(11) NOT NULL COMMENT '用户id',
                                `kqgj_nm` varchar(50) NOT NULL COMMENT '规则名称',
                                `tp` varchar(20) NOT NULL COMMENT '类型(固定班制；外勤制)',
                                `check_weeks` varchar(50) DEFAULT NULL COMMENT '考勤时间（周）',
                                `check_times` varchar(200) DEFAULT NULL COMMENT '考勤时间（时间段）',
                                `address` varchar(100) DEFAULT NULL COMMENT '考勤地址',
                                `longitude` varchar(50) DEFAULT NULL COMMENT '经度',
                                `latitude` varchar(50) DEFAULT NULL COMMENT '纬度',
                                `yx_meter` int(8) DEFAULT NULL COMMENT '有效范围几米',
                                `zzsb_time` int(2) DEFAULT NULL COMMENT '最早上班签到时间几个小时',
                                `zwxb_time` int(2) DEFAULT NULL COMMENT '最晚下班签退时间几个小时',
                                `sxbtx_time` int(3) DEFAULT NULL COMMENT '上下班弹性时间几分钟',
                                `is_qd` int(2) DEFAULT '2' COMMENT '在考勤范围以外允许签到/签退（1允许；2不允许）',
                                `sy_mids1` varchar(255) DEFAULT NULL COMMENT '适用人员id组（1,2,3）',
                                `sy_mids2` varchar(255) DEFAULT NULL COMMENT '适用人员id组（-1-2-3-）',
                                `gl_mids1` varchar(255) DEFAULT NULL COMMENT '管理人员id组（1,2,3）',
                                `gl_mids2` varchar(255) DEFAULT NULL COMMENT '管理人员id组（-1-2-3-）',
                                `ck_mids1` varchar(255) DEFAULT NULL COMMENT '查看人员id组（1,2,3）',
                                `ck_mids2` varchar(255) DEFAULT NULL COMMENT '查看人员id组（-1-2-3-）',
                                `fb_time` varchar(20) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_collect`;

CREATE TABLE `bsc_collect` (
                             `collect_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id
            ',
                             `member_id` int(11) DEFAULT NULL,
                             `collec_time` varchar(20) DEFAULT NULL,
                             `collect_tp` char(255) DEFAULT NULL COMMENT '收藏类型 1 文字 2 图片 3 主题',
                             `content` varchar(255) DEFAULT NULL COMMENT '收藏内容',
                             `belong_id` int(11) DEFAULT NULL COMMENT '对应id(暂时只有主题id)',
                             PRIMARY KEY (`collect_id`),
                             KEY `member_idc_cons` (`member_id`),
                             CONSTRAINT `member_idc_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_dept_msg`;

CREATE TABLE `bsc_dept_msg` (
                              `msg_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
                              `dept_id` int(11) NOT NULL COMMENT '所属部门',
                              `member_id` int(11) NOT NULL COMMENT '发表人',
                              `addtime` varchar(20) NOT NULL COMMENT '发表时间',
                              `msg_tp` char(1) NOT NULL COMMENT '发表类型1.文字2.图片3.语音',
                              `msg` text NOT NULL COMMENT '发表内容',
                              `voice_time` int(20) DEFAULT NULL,
                              `longitude` double DEFAULT NULL,
                              `latitude` double DEFAULT NULL,
                              PRIMARY KEY (`msg_id`),
                              KEY `member_idd_cons` (`member_id`),
                              KEY `dept_ida_cons` (`dept_id`),
                              CONSTRAINT `dept_ida_cons` FOREIGN KEY (`dept_id`) REFERENCES `sys_depart` (`branch_id`) ON DELETE CASCADE,
                              CONSTRAINT `member_idd_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_empgroup`;

CREATE TABLE `bsc_empgroup` (
                              `group_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '圈id',
                              `group_nm` varchar(50) NOT NULL COMMENT '圈名称',
                              `group_desc` varchar(500) DEFAULT NULL COMMENT '圈介绍',
                              `member_id` int(11) NOT NULL COMMENT '圈群组',
                              `group_head` varchar(100) DEFAULT NULL COMMENT '圈头像',
                              `group_bg` varchar(100) DEFAULT NULL COMMENT '圈背景图',
                              `creatime` varchar(20) NOT NULL COMMENT '创建时间',
                              `group_num` int(11) NOT NULL DEFAULT '1' COMMENT '圈成员数',
                              `third_group_id` varchar(14) DEFAULT NULL COMMENT '关联第三方群id',
                              `lead_shield` char(255) NOT NULL DEFAULT '2' COMMENT '领导屏蔽 1 屏蔽 2 不屏蔽',
                              `datasource` varchar(50) DEFAULT NULL COMMENT '对应数据表',
                              `is_open` char(255) DEFAULT '2' COMMENT '是否公开圈 1 是2 不是',
                              PRIMARY KEY (`group_id`),
                              KEY `member_ide_cons` (`member_id`),
                              CONSTRAINT `member_ide_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_empgroup_member`;

CREATE TABLE `bsc_empgroup_member` (
                                     `group_id` int(11) NOT NULL COMMENT '圈id',
                                     `member_id` int(11) NOT NULL COMMENT '成员id',
                                     `role` char(1) NOT NULL COMMENT '成员角色 1.群主2.管理员3.普通成员 4 领导',
                                     `addtime` varchar(20) NOT NULL COMMENT '加入时间',
                                     `lastime` varchar(20) DEFAULT NULL COMMENT '最后聊天时间',
                                     `remind_flag` char(255) NOT NULL DEFAULT '2' COMMENT '1 不提醒'' 2 自动提醒',
                                     `top_flag` char(255) NOT NULL DEFAULT '1' COMMENT '1 不置顶,2 置顶',
                                     `top_time` varchar(20) DEFAULT NULL COMMENT '置顶时间',
                                     PRIMARY KEY (`group_id`, `member_id`),
                                     KEY `member_idem_cons` (`member_id`),
                                     CONSTRAINT `group_idem_cons` FOREIGN KEY (`group_id`) REFERENCES `bsc_empgroup` (`group_id`) ON DELETE CASCADE,
                                     CONSTRAINT `member_idem_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                     tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_empgroup_msg`;

CREATE TABLE `bsc_empgroup_msg` (
                                  `msg_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                  `group_id` int(11) NOT NULL COMMENT '所属圈',
                                  `member_id` int(11) NOT NULL COMMENT '发表人',
                                  `addtime` varchar(20) NOT NULL COMMENT '发表时间',
                                  `msg_tp` char(1) NOT NULL COMMENT '发表类型1.文字2.图片3.语音',
                                  `msg` text COMMENT '发表内容',
                                  `voice_time` int(255) DEFAULT NULL,
                                  `longitude` double DEFAULT NULL,
                                  `latitude` double DEFAULT NULL,
                                  PRIMARY KEY (`msg_id`),
                                  KEY `member_ides_cons` (`member_id`),
                                  KEY `group_ides_cons` (`group_id`),
                                  CONSTRAINT `group_ides_cons` FOREIGN KEY (`group_id`) REFERENCES `bsc_empgroup` (`group_id`) ON DELETE CASCADE,
                                  CONSTRAINT `member_idemg_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_knowledge`;

CREATE TABLE `bsc_knowledge` (
                               `knowledge_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '话题id',
                               `topic_id` int(11) DEFAULT NULL COMMENT '帖子id',
                               `topic_title` varchar(255) NOT NULL COMMENT '标题',
                               `member_id` int(11) DEFAULT NULL COMMENT '发表人',
                               `topi_content` varchar(500) DEFAULT NULL COMMENT '发表内容',
                               `topic_time` varchar(20) NOT NULL COMMENT '发表时间',
                               `topic_num` int(11) DEFAULT NULL COMMENT '评论数:默认0',
                               `sort_id` int(11) NOT NULL,
                               `tp` char(255) NOT NULL COMMENT '类型 1 圈帖子 2 url 3 文件',
                               `operate_id` int(11) DEFAULT NULL COMMENT '操作人id',
                               PRIMARY KEY (`knowledge_id`),
                               KEY `group_idk_cons` (`topic_id`),
                               KEY `member_idk_cons` (`member_id`),
                               KEY `sort_idk_cons` (`sort_id`),
                               CONSTRAINT `member_idk_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                               CONSTRAINT `sort_idk_cons` FOREIGN KEY (`sort_id`) REFERENCES `bsc_sort` (`sort_id`) ON DELETE CASCADE,
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_knowledge_comment`;

CREATE TABLE `bsc_knowledge_comment` (
                                       `comment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评论id',
                                       `Knowledge_id` int(11) NOT NULL COMMENT '所属话题',
                                       `member_id` int(11) NOT NULL COMMENT '评论人',
                                       `comment_time` varchar(20) NOT NULL COMMENT '评论时间',
                                       `content` varchar(300) NOT NULL COMMENT '评论内容',
                                       `belong_id` int(11) NOT NULL DEFAULT '0' COMMENT '回复的对象id 0 为评论 其他为回复的对应评论id',
                                       `rc_id` int(11) DEFAULT NULL COMMENT '被回复人id',
                                       `rc_nm` varchar(20) DEFAULT NULL COMMENT '被回复人用户名',
                                       PRIMARY KEY (`comment_id`),
                                       KEY `knowledge_idkc_cons` (`Knowledge_id`),
                                       KEY `member_idkc_cons` (`member_id`),
                                       CONSTRAINT `knowledge_idkc_cons` FOREIGN KEY (`Knowledge_id`) REFERENCES `bsc_knowledge` (`knowledge_id`) ON DELETE CASCADE,
                                       CONSTRAINT `member_idkc_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                       tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_knowledge_pic`;

CREATE TABLE `bsc_knowledge_pic` (
                                   `pic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
                                   `knowledge_id` int(11) NOT NULL COMMENT '所属知识点',
                                   `pic_mini` varchar(255) NOT NULL COMMENT '图片小图',
                                   `pic` varchar(255) NOT NULL COMMENT '图片',
                                   PRIMARY KEY (`pic_id`),
                                   KEY `knowledge_idkp_cons` (`knowledge_id`),
                                   CONSTRAINT `knowledge_idkp_cons` FOREIGN KEY (`knowledge_id`) REFERENCES `bsc_knowledge` (`knowledge_id`) ON DELETE CASCADE,
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_knowledge_praise`;

CREATE TABLE `bsc_knowledge_praise` (
                                      `knowledge_id` int(11) NOT NULL COMMENT '知识点id',
                                      `member_id` int(11) NOT NULL COMMENT '赞的人',
                                      PRIMARY KEY (`knowledge_id`, `member_id`),
                                      KEY `member_idkpr_cons` (`member_id`),
                                      CONSTRAINT `knowledge_idkpr_cons` FOREIGN KEY (`knowledge_id`) REFERENCES `bsc_knowledge` (`knowledge_id`) ON DELETE CASCADE,
                                      CONSTRAINT `member_idkpr_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                      tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_orderls`;

CREATE TABLE `bsc_orderls` (
                             `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '旅行社订单id',
                             `order_no` varchar(20) NOT NULL COMMENT '订单号',
                             `cid` int(11) NOT NULL COMMENT '客户id',
                             `mid` int(11) NOT NULL COMMENT '用户id',
                             `oddate` varchar(20) NOT NULL COMMENT '日期',
                             `order_zt` varchar(10) NOT NULL DEFAULT '未审核' COMMENT '订单状态（审核，未审核)',
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_orderls_bb`;

CREATE TABLE `bsc_orderls_bb` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `order_id` int(11) NOT NULL,
                                `order_no` varchar(20) NOT NULL COMMENT '订单号',
                                `cid` int(11) NOT NULL,
                                `mid` int(11) NOT NULL,
                                `odate` varchar(20) NOT NULL,
                                `aw_jg` double(8, 2) DEFAULT '0.00' COMMENT '其他啤酒',
                                `bw_jg` double(8, 2) DEFAULT '0.00' COMMENT '小商品',
                                `cw_jg` double(8, 2) DEFAULT '0.00' COMMENT '化妆品',
                                `dw_jg` double(8, 2) DEFAULT '0.00' COMMENT '衣服燕窝',
                                `ew_jg` double(8, 2) DEFAULT '0.00' COMMENT '酵素',
                                `fw_jg` double(8, 2) DEFAULT '0.00' COMMENT '乳液',
                                `all_jg` double(8, 2) DEFAULT '0.00' COMMENT '计合金额',
                                `zh_jg` double(8, 2) DEFAULT '0.00' COMMENT '总回',
                                `ls_jg` double(8, 2) DEFAULT '0.00' COMMENT '旅社',
                                `dy_jg` double(8, 2) DEFAULT '0.00' COMMENT '导游',
                                `sj_jg` double(8, 2) DEFAULT '0.00' COMMENT '司机',
                                `qp_jg` double(8, 2) DEFAULT '0.00' COMMENT '全陪',
                                `is_js` varchar(10) DEFAULT '未结算' COMMENT '结算状态（结算，未结算）',
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_orderls_detail`;

CREATE TABLE `bsc_orderls_detail` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '详情id',
                                    `order_id` int(11) NOT NULL COMMENT '订单id',
                                    `ware_id` int(11) NOT NULL COMMENT '商品id',
                                    `zh` double(5, 2) DEFAULT '0.00' COMMENT '总回',
                                    `ls` double(5, 2) DEFAULT '0.00' COMMENT '旅社',
                                    `dy` double(5, 2) DEFAULT '0.00' COMMENT '导游',
                                    `sj` double(5, 2) DEFAULT '0.00' COMMENT '司机',
                                    `qp` double(5, 2) DEFAULT '0.00' COMMENT '全陪',
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_photo_wall`;

CREATE TABLE `bsc_photo_wall` (
                                `wall_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增id',
                                `member_id` int(11) NOT NULL COMMENT '发表人',
                                `publish_time` varchar(20) NOT NULL COMMENT '发表时间',
                                `publish_content` varchar(1000) DEFAULT NULL COMMENT '发表内容',
                                `praise_num` int(11) NOT NULL COMMENT '赞的条数默认0',
                                `comment_num` int(11) NOT NULL COMMENT '评论数:默认0',
                                `is_top` char(1) NOT NULL COMMENT '是否置顶:1.是0.否',
                                `top_time` varchar(20) DEFAULT NULL,
                                `wall_score` int(11) DEFAULT '0' COMMENT '照片墙分数：点赞1分 评论2分，排除本身',
                                PRIMARY KEY (`wall_id`),
                                KEY `FK_Reference_24` (`member_id`),
                                CONSTRAINT `member_idpw_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_photo_wall_comment`;

CREATE TABLE `bsc_photo_wall_comment` (
                                        `comment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评论id',
                                        `wall_id` int(11) NOT NULL COMMENT '所属照片墙',
                                        `member_id` int(11) NOT NULL COMMENT '评论人',
                                        `addtime` varchar(20) NOT NULL COMMENT '评论时间',
                                        `comment` varchar(300) NOT NULL COMMENT '评论内容',
                                        `isrc` int(11) NOT NULL COMMENT '是否为回复:0:评论1:回复',
                                        `recomment` int(11) NOT NULL COMMENT '回复人ID如果该条信息类型为回复该值为回复人的ID，如果为评论改条为0',
                                        PRIMARY KEY (`comment_id`),
                                        KEY `FK_Reference_26` (`wall_id`),
                                        KEY `FK_Reference_27` (`member_id`),
                                        CONSTRAINT `member_id13_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_member` (`member_id`) ON DELETE CASCADE,
                                        CONSTRAINT `wall_id1_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE,
                                        CONSTRAINT `wall_idwc_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE,
                                        tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_photo_wall_pic`;

CREATE TABLE `bsc_photo_wall_pic` (
                                    `pic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                    `wall_id` int(11) NOT NULL,
                                    `pic_mini` varchar(255) DEFAULT NULL COMMENT '图片小图',
                                    `pic` varchar(255) NOT NULL COMMENT '图片',
                                    PRIMARY KEY (`pic_id`),
                                    KEY `FK_Reference_25` (`wall_id`),
                                    CONSTRAINT `wall_id_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE,
                                    CONSTRAINT `wall_idwp_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE,
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_photo_wall_praise`;

CREATE TABLE `bsc_photo_wall_praise` (
                                       `wall_id` int(11) NOT NULL COMMENT '所属照片墙',
                                       `member_id` int(11) NOT NULL COMMENT '赞的人',
                                       `click_time` varchar(255) DEFAULT '' COMMENT '点赞时间',
                                       PRIMARY KEY (`wall_id`, `member_id`),
                                       KEY `FK_Reference_29` (`member_id`),
                                       CONSTRAINT `member_id14_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_member` (`member_id`) ON DELETE CASCADE,
                                       CONSTRAINT `member_idwpr_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                       CONSTRAINT `wall_id2_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE,
                                       CONSTRAINT `wall_idwpr_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE,
                                       tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_plan`;

CREATE TABLE `bsc_plan` (
                          `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '计划id',
                          `mid` int(11) NOT NULL COMMENT '业务员id',
                          `cid` int(11) NOT NULL COMMENT '客户id',
                          `branch_id` int(11) DEFAULT NULL COMMENT '部门id',
                          `pdate` varchar(20) NOT NULL COMMENT '计划日期',
                          `is_wc` int(2) NOT NULL DEFAULT '2' COMMENT '是否完成（1是；2否）',
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_planxl`;

CREATE TABLE `bsc_planxl` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '线路id',
                            `mid` int(11) NOT NULL COMMENT '用户id',
                            `xl_nm` varchar(50) NOT NULL COMMENT '线路名称',
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_planxl_detail`;

CREATE TABLE `bsc_planxl_detail` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '线路详情id',
                                   `xl_id` int(11) NOT NULL COMMENT '线路id',
                                   `cid` int(11) NOT NULL COMMENT '客户id',
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_plan_new`;

CREATE TABLE `bsc_plan_new` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `mid` int(11) DEFAULT NULL COMMENT '业务员id',
                              `xlid` int(11) DEFAULT NULL COMMENT '线路id',
                              `branch_id` int(11) DEFAULT NULL COMMENT '部门id',
                              `pdate` varchar(20) DEFAULT NULL COMMENT '计划日期',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_plan_sub`;

CREATE TABLE `bsc_plan_sub` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `pid` int(11) DEFAULT NULL COMMENT '计划id',
                              `cid` int(11) DEFAULT NULL COMMENT '客户id',
                              `is_wc` int(11) DEFAULT NULL COMMENT '是否完成',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_query_solution`;

CREATE TABLE `bsc_query_solution` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `title` varchar(255) DEFAULT NULL COMMENT '标题',
                                    `namespace` varchar(50) NOT NULL COMMENT '是否直接显示在查询框',
                                    `share` tinyint(4) DEFAULT NULL COMMENT '是否共享',
                                    `creator_id` int(11) DEFAULT NULL COMMENT '创建者ID',
                                    `create_time` datetime DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_query_solution_item`;

CREATE TABLE `bsc_query_solution_item` (
                                         `id` int(11) NOT NULL AUTO_INCREMENT,
                                         `solution_id` int(11) NOT NULL COMMENT '所属查询方案',
                                         `field` varchar(50) DEFAULT NULL COMMENT '字段名',
                                         `op` int(11) DEFAULT NULL COMMENT '操作符',
                                         `value` varchar(100) DEFAULT NULL COMMENT '查询值',
                                         PRIMARY KEY (`id`),
                                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_sort`;

CREATE TABLE `bsc_sort` (
                          `sort_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评论id',
                          `group_id` int(11) NOT NULL COMMENT '员工圈id',
                          `sort_nm` varchar(50) NOT NULL COMMENT '类型名称',
                          `member_id` int(11) DEFAULT NULL,
                          `create_time` varchar(20) DEFAULT NULL,
                          PRIMARY KEY (`sort_id`),
                          KEY `member_ids_cons` (`member_id`),
                          KEY `group_ids_cons` (`group_id`),
                          CONSTRAINT `member_ids_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_topic`;

CREATE TABLE `bsc_topic` (
                           `topic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '话题id',
                           `tp_type` int(11) DEFAULT NULL COMMENT '0 员工圈话题 1 真心话话题 2 外部来源(发帖)',
                           `tp_id` int(11) DEFAULT NULL COMMENT 'tp为0，对应员工圈id    tp为1，对应真心话id',
                           `topic_title` varchar(255) NOT NULL COMMENT '标题',
                           `member_id` int(11) NOT NULL COMMENT '发表人',
                           `topi_content` varchar(500) DEFAULT NULL COMMENT '发表内容',
                           `topic_time` varchar(20) NOT NULL COMMENT '发表时间',
                           `topic_num` int(11) NOT NULL DEFAULT '0' COMMENT '评论数:默认0',
                           `praise_num` int(11) NOT NULL DEFAULT '0' COMMENT '赞数',
                           `is_top` char(1) NOT NULL DEFAULT '0' COMMENT '是否置顶:1.是0.否',
                           `is_anonymity` char(255) DEFAULT NULL COMMENT '是否匿名 0 否 1 是',
                           `url` varchar(255) DEFAULT NULL COMMENT '外部来源url',
                           PRIMARY KEY (`topic_id`),
                           KEY `member_idtopic_cons` (`member_id`),
                           KEY `group_idtc_cons` (`tp_id`),
                           CONSTRAINT `group_idtc_cons` FOREIGN KEY (`tp_id`) REFERENCES `bsc_empgroup` (`group_id`) ON DELETE CASCADE,
                           CONSTRAINT `member_idte_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_topic_comment`;

CREATE TABLE `bsc_topic_comment` (
                                   `comment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评论id',
                                   `topic_id` int(11) NOT NULL COMMENT '所属话题',
                                   `member_id` int(11) NOT NULL COMMENT '评论人',
                                   `comment_time` varchar(20) NOT NULL COMMENT '评论时间',
                                   `content` varchar(300) NOT NULL COMMENT '评论内容',
                                   `belong_id` int(11) NOT NULL DEFAULT '0' COMMENT '回复的对象id 0 为评论 其他为回复的对应评论id',
                                   `rc_id` int(11) DEFAULT NULL COMMENT '被回复人id',
                                   `rc_nm` varchar(20) DEFAULT NULL COMMENT '被回复人用户名',
                                   PRIMARY KEY (`comment_id`),
                                   KEY `member_idtc_cons` (`member_id`),
                                   KEY `topic_idtc_cons` (`topic_id`),
                                   CONSTRAINT `member_idtce_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                   CONSTRAINT `topic_idtc_cons` FOREIGN KEY (`topic_id`) REFERENCES `bsc_topic` (`topic_id`) ON DELETE CASCADE,
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_topic_pic`;

CREATE TABLE `bsc_topic_pic` (
                               `pic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
                               `topic_id` int(11) DEFAULT NULL COMMENT '所属话题',
                               `pic_mini` varchar(255) NOT NULL COMMENT '图片小图',
                               `pic` varchar(255) NOT NULL COMMENT '图片',
                               PRIMARY KEY (`pic_id`),
                               KEY `topic_idtp_cons` (`topic_id`),
                               CONSTRAINT `topic_idtp_cons` FOREIGN KEY (`topic_id`) REFERENCES `bsc_topic` (`topic_id`) ON DELETE CASCADE,
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_topic_praise`;

CREATE TABLE `bsc_topic_praise` (
                                  `topic_id` int(11) NOT NULL COMMENT '所属照片墙',
                                  `member_id` int(11) NOT NULL COMMENT '赞的人',
                                  PRIMARY KEY (`topic_id`, `member_id`),
                                  KEY `member_idtpr_cons` (`member_id`),
                                  CONSTRAINT `member_idtcp_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                  CONSTRAINT `topic_idtpr_cons` FOREIGN KEY (`topic_id`) REFERENCES `bsc_topic` (`topic_id`) ON DELETE CASCADE,
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_true`;

CREATE TABLE `bsc_true` (
                          `true_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
                          `member_id` int(11) NOT NULL COMMENT '发表人id',
                          `true_time` varchar(50) NOT NULL COMMENT '发表时间',
                          `title` varchar(50) NOT NULL COMMENT '标题',
                          `content` varchar(255) NOT NULL COMMENT '内容',
                          `true_count` int(11) DEFAULT NULL COMMENT '跟帖人数',
                          PRIMARY KEY (`true_id`),
                          KEY `member_idtr_cons` (`member_id`),
                          CONSTRAINT `member_idtr_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `bsc_true_msg`;

CREATE TABLE `bsc_true_msg` (
                              `msg_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
                              `true_id` int(11) DEFAULT NULL COMMENT '所属真心话',
                              `member_id` int(11) NOT NULL COMMENT '发表人',
                              `addtime` varchar(20) NOT NULL COMMENT '发表时间',
                              `msg_tp` char(1) NOT NULL COMMENT '发表类型1.文字2.图片3.语音',
                              `msg` text NOT NULL COMMENT '发表内容',
                              `voice_time` int(11) DEFAULT NULL,
                              `longitude` double DEFAULT NULL,
                              `latitude` double DEFAULT NULL,
                              PRIMARY KEY (`msg_id`),
                              KEY `true_id_cons` (`true_id`),
                              CONSTRAINT `true_id_cons` FOREIGN KEY (`true_id`) REFERENCES `bsc_true` (`true_id`) ON DELETE CASCADE,
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `company_info`;

CREATE TABLE `company_info` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `name` varchar(50) DEFAULT NULL,
                              `industry_id` varchar(50) DEFAULT NULL,
                              `brand` varchar(50) DEFAULT NULL COMMENT '经营品牌',
                              `leader` varchar(50) DEFAULT NULL COMMENT '负责人',
                              `telephone` varchar(50) DEFAULT NULL,
                              `email` varchar(50) DEFAULT NULL,
                              `staff_number` int(11) DEFAULT NULL COMMENT '员工人数',
                              `staff_count` int(11) DEFAULT NULL COMMENT '总共业务人数',
                              `business_number` varchar(50) DEFAULT NULL COMMENT '营业执业号',
                              `logo` varchar(255) DEFAULT NULL COMMENT '营业执业图片',
                              `category_id` varchar(50) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_account`;

CREATE TABLE `fin_account` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bank_name` varchar(50) DEFAULT NULL,
                             `acc_no` varchar(50) DEFAULT NULL,
                             `acc_amt` decimal(10, 2) DEFAULT NULL,
                             `acc_type` int(11) DEFAULT NULL COMMENT '0 现金 1微信 2支付宝 3银行',
                             `status` int(11) DEFAULT NULL,
                             `remarks` varchar(100) DEFAULT NULL,
                             `acc_name` varchar(100) DEFAULT NULL,
                             `is_post` varchar(10) DEFAULT NULL,
                             `is_pay` varchar(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_acc_io`;

CREATE TABLE `fin_acc_io` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `acc_time` datetime DEFAULT NULL COMMENT '时间',
                            `io_type` int(11) DEFAULT NULL COMMENT '0 支出 1收入',
                            `out_type` varchar(50) DEFAULT NULL COMMENT '类型',
                            `bill_id` int(11) DEFAULT NULL COMMENT '关联的单据id',
                            `obj_type` int(11) DEFAULT NULL COMMENT '0往来单位 1个人',
                            `obj_id` int(11) DEFAULT NULL,
                            `source_type` int(11) DEFAULT NULL,
                            `source_id` int(11) DEFAULT NULL,
                            `acc_type` int(11) DEFAULT NULL COMMENT '账号类型',
                            `acc_id` int(11) DEFAULT NULL COMMENT '账号ID',
                            `acc_unit` varchar(100) DEFAULT NULL,
                            `remarks` varchar(100) DEFAULT NULL,
                            `io_amt` decimal(10, 2) DEFAULT NULL COMMENT '变化金额',
                            `in_amt` decimal(10, 2) DEFAULT NULL COMMENT '收入金额',
                            `out_amt` decimal(10, 2) DEFAULT NULL COMMENT '支出金额',
                            `operator` varchar(50) DEFAULT NULL COMMENT '操作员',
                            `status` int(11) DEFAULT NULL COMMENT '状态',
                            `bill_no` varchar(50) DEFAULT NULL COMMENT '单号',
                            `obj_name` varchar(100) DEFAULT NULL,
                            `left_amt` decimal(10, 2) DEFAULT NULL,
                            `remarks1` varchar(600) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_cost`;

CREATE TABLE `fin_cost` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `bill_no` varchar(50) DEFAULT NULL,
                          `cost_time` datetime DEFAULT NULL,
                          `emp_id` int(11) DEFAULT NULL,
                          `dep_id` int(11) DEFAULT NULL,
                          `total_amt` decimal(10, 2) DEFAULT NULL,
                          `cost_term` int(11) DEFAULT NULL COMMENT '费用分摊期数',
                          `status` int(11) DEFAULT NULL,
                          `submit_user` varchar(50) DEFAULT NULL,
                          `submit_time` datetime DEFAULT NULL,
                          `operator` varchar(50) DEFAULT NULL,
                          `cost_type` int(11) DEFAULT NULL,
                          `remarks` varchar(500) DEFAULT NULL,
                          `pro_type` int(11) DEFAULT NULL,
                          `pro_name` varchar(50) DEFAULT NULL,
                          `new_time` datetime DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_costitem`;

CREATE TABLE `fin_costitem` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `item_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `type_id` int(11) DEFAULT NULL,
                              `remarks` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                              `mark` int(2) DEFAULT NULL,
                              `system_id` varchar(36) CHARACTER SET utf8 DEFAULT NULL,
                              `no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `sale_mark` int(2) DEFAULT NULL,
                              `system_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `status` int(11) DEFAULT '1',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_costsub`;

CREATE TABLE `fin_costsub` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `mast_id` int(11) DEFAULT NULL,
                             `cost_id` varchar(50) DEFAULT NULL,
                             `amt` decimal(10, 2) DEFAULT NULL,
                             `remarks` varchar(400) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_costtype`;

CREATE TABLE `fin_costtype` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `type_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `system_id` varchar(36) CHARACTER SET utf8 DEFAULT NULL,
                              `no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `system_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `status` int(11) DEFAULT '1',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_cost_term`;

CREATE TABLE `fin_cost_term` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `dep_id` int(11) DEFAULT NULL,
                               `emp_id` int(11) DEFAULT NULL,
                               `cost_type` int(11) DEFAULT NULL,
                               `term_amt` decimal(10, 2) DEFAULT NULL,
                               `yymm` varchar(20) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_equity`;

CREATE TABLE `fin_equity` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `bill_no` varchar(50) DEFAULT NULL,
                            `bill_time` datetime DEFAULT NULL,
                            `pro_id` int(11) DEFAULT NULL,
                            `pro_type` int(11) DEFAULT NULL,
                            `pro_name` varchar(50) DEFAULT NULL,
                            `total_amt` decimal(13, 2) DEFAULT NULL,
                            `acc_id` int(11) DEFAULT NULL,
                            `status` int(11) DEFAULT NULL,
                            `submit_user` varchar(50) DEFAULT NULL,
                            `submit_time` datetime DEFAULT NULL,
                            `operator` varchar(50) DEFAULT NULL,
                            `remarks` varchar(600) DEFAULT NULL,
                            `new_time` datetime DEFAULT NULL,
                            `pay_amt` decimal(13, 2) DEFAULT NULL,
                            `free_amt` decimal(13, 2) DEFAULT '0.00',
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_equity_item`;

CREATE TABLE `fin_equity_item` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `item_name` varchar(50) DEFAULT NULL,
                                 `type_id` int(11) DEFAULT NULL,
                                 `remarks` varchar(50) DEFAULT NULL,
                                 `system_id` varchar(36) DEFAULT NULL,
                                 `no` varchar(50) DEFAULT NULL,
                                 `system_name` varchar(50) DEFAULT NULL,
                                 `status` int(11) DEFAULT '1',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_equity_sub`;

CREATE TABLE `fin_equity_sub` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `mast_id` int(11) DEFAULT NULL,
                                `item_id` int(11) DEFAULT NULL,
                                `amt` decimal(13, 2) DEFAULT NULL,
                                `remarks` varchar(255) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_equity_type`;

CREATE TABLE `fin_equity_type` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `type_name` varchar(50) DEFAULT NULL,
                                 `system_id` varchar(36) DEFAULT NULL,
                                 `no` varchar(50) DEFAULT NULL,
                                 `system_name` varchar(50) DEFAULT NULL,
                                 `status` int(11) DEFAULT '1',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_in`;

CREATE TABLE `fin_in` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `bill_no` varchar(50) DEFAULT NULL,
                        `bill_time` datetime DEFAULT NULL,
                        `pro_id` int(11) DEFAULT NULL,
                        `pro_type` int(11) DEFAULT NULL,
                        `pro_name` varchar(50) DEFAULT NULL,
                        `total_amt` decimal(10, 2) DEFAULT NULL,
                        `acc_id` int(11) DEFAULT NULL,
                        `status` int(11) DEFAULT NULL,
                        `submit_user` varchar(50) DEFAULT NULL,
                        `submit_time` datetime DEFAULT NULL,
                        `operator` varchar(50) DEFAULT NULL,
                        `remarks` varchar(600) DEFAULT NULL,
                        `new_time` datetime DEFAULT NULL,
                        `pay_amt` decimal(10, 2) DEFAULT NULL,
                        `free_amt` decimal(10, 2) DEFAULT '0.00',
                        PRIMARY KEY (`id`),
                        tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_income`;

CREATE TABLE `fin_income` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `cst_id` int(11) DEFAULT NULL,
                            `pro_type` int(11) DEFAULT NULL,
                            `acc_id` int(11) DEFAULT NULL,
                            `rec_amt` decimal(10, 2) DEFAULT NULL,
                            `item_name` varchar(100) DEFAULT NULL,
                            `remarks` varchar(100) DEFAULT NULL,
                            `operator` varchar(50) DEFAULT NULL,
                            `status` int(11) DEFAULT NULL,
                            `kh_nm` varchar(100) DEFAULT NULL,
                            `submit_user` varchar(50) DEFAULT NULL,
                            `submit_time` datetime DEFAULT NULL,
                            `rec_time` datetime DEFAULT NULL,
                            `new_time` datetime DEFAULT NULL,
                            `bill_no` varchar(50) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_income_item`;

CREATE TABLE `fin_income_item` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `item_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                 `type_id` int(11) DEFAULT NULL,
                                 `remarks` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                 `mark` int(2) DEFAULT NULL,
                                 `system_id` varchar(36) CHARACTER SET utf8 DEFAULT NULL,
                                 `no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                 `system_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                 `status` int(11) DEFAULT '1',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_income_sub`;

CREATE TABLE `fin_income_sub` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `mast_id` int(11) DEFAULT NULL,
                                `item_id` int(11) DEFAULT NULL,
                                `amt` decimal(10, 2) DEFAULT NULL,
                                `remarks` varchar(400) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_income_type`;

CREATE TABLE `fin_income_type` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `type_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                 `system_id` varchar(36) CHARACTER SET utf8 DEFAULT NULL,
                                 `no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                 `system_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                 `status` int(11) DEFAULT '1',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_incost_item`;

CREATE TABLE `fin_incost_item` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `item_name` varchar(50) DEFAULT NULL,
                                 `type_id` int(11) DEFAULT NULL,
                                 `remarks` varchar(50) DEFAULT NULL,
                                 `system_id` varchar(36) DEFAULT NULL,
                                 `no` varchar(50) DEFAULT NULL,
                                 `system_name` varchar(50) DEFAULT NULL,
                                 `status` int(11) DEFAULT '1',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_incost_type`;

CREATE TABLE `fin_incost_type` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `type_name` varchar(50) DEFAULT NULL,
                                 `system_id` varchar(36) DEFAULT NULL,
                                 `no` varchar(50) DEFAULT NULL,
                                 `system_name` varchar(50) DEFAULT NULL,
                                 `status` int(11) DEFAULT '1',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_init_money`;

CREATE TABLE `fin_init_money` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `bill_no` varchar(50) DEFAULT NULL,
                                `bill_time` datetime DEFAULT NULL,
                                `amt` decimal(10, 2) DEFAULT NULL,
                                `status` int(11) DEFAULT NULL,
                                `submit_user` varchar(50) DEFAULT NULL,
                                `submit_time` datetime DEFAULT NULL,
                                `operator` varchar(50) DEFAULT NULL,
                                `remarks` varchar(600) DEFAULT NULL,
                                `new_time` datetime DEFAULT NULL,
                                `io_mark` int(2) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_init_money_sub`;

CREATE TABLE `fin_init_money_sub` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `bill_no` varchar(50) DEFAULT NULL,
                                    `bill_time` datetime DEFAULT NULL,
                                    `amt` decimal(10, 2) DEFAULT NULL,
                                    `operator` varchar(50) DEFAULT NULL,
                                    `io_mark` int(2) DEFAULT NULL,
                                    `acc_id` int(11) DEFAULT NULL,
                                    `mast_id` int(11) DEFAULT NULL,
                                    `new_time` datetime DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_init_qtjr_main`;

CREATE TABLE `fin_init_qtjr_main` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `bill_time` datetime DEFAULT NULL,
                                    `amt` decimal(10, 2) DEFAULT NULL,
                                    `status` int(11) DEFAULT NULL,
                                    `submit_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `submit_time` datetime DEFAULT NULL,
                                    `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `remarks` varchar(600) CHARACTER SET utf8 DEFAULT NULL,
                                    `new_time` datetime DEFAULT NULL,
                                    `io_mark` int(11) DEFAULT NULL,
                                    `cancel_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `cancel_time` datetime DEFAULT NULL,
                                    `pay_amt` decimal(10, 2) DEFAULT NULL,
                                    `pro_id` int(11) DEFAULT NULL,
                                    `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `pro_type` int(11) DEFAULT NULL,
                                    `biz_type` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                                    `free_amt` decimal(10, 2) DEFAULT NULL,
                                    `item_id` int(11) DEFAULT NULL,
                                    `remark` varchar(500) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_init_qtwl_main`;

CREATE TABLE `fin_init_qtwl_main` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `bill_time` datetime DEFAULT NULL,
                                    `amt` decimal(10, 2) DEFAULT NULL,
                                    `status` int(11) DEFAULT NULL,
                                    `submit_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `submit_time` datetime DEFAULT NULL,
                                    `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `remarks` varchar(600) CHARACTER SET utf8 DEFAULT NULL,
                                    `new_time` datetime DEFAULT NULL,
                                    `io_mark` int(11) DEFAULT NULL,
                                    `cancel_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `cancel_time` datetime DEFAULT NULL,
                                    `pay_amt` decimal(10, 2) DEFAULT NULL,
                                    `pro_id` int(11) DEFAULT NULL,
                                    `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `pro_type` int(11) DEFAULT NULL,
                                    `biz_type` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                                    `free_amt` decimal(10, 2) DEFAULT NULL,
                                    `item_id` int(11) DEFAULT NULL,
                                    `remark` varchar(500) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_init_wlyw_main`;

CREATE TABLE `fin_init_wlyw_main` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `bill_time` datetime DEFAULT NULL,
                                    `amt` decimal(10, 2) DEFAULT NULL,
                                    `status` int(11) DEFAULT NULL,
                                    `submit_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `submit_time` datetime DEFAULT NULL,
                                    `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `remarks` varchar(600) CHARACTER SET utf8 DEFAULT NULL,
                                    `new_time` datetime DEFAULT NULL,
                                    `io_mark` int(2) DEFAULT NULL,
                                    `cancel_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `cancel_time` datetime DEFAULT NULL,
                                    `pay_amt` decimal(10, 2) DEFAULT NULL,
                                    `pro_id` int(11) DEFAULT NULL,
                                    `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `pro_type` int(2) DEFAULT NULL,
                                    `biz_type` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                                    `free_amt` decimal(10, 2) DEFAULT NULL,
                                    `remark` varchar(500) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_insub`;

CREATE TABLE `fin_insub` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `mast_id` int(11) DEFAULT NULL,
                           `item_id` int(11) DEFAULT NULL,
                           `amt` decimal(10, 2) DEFAULT NULL,
                           `remarks` varchar(255) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_in_return`;

CREATE TABLE `fin_in_return` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `sum_amt` decimal(10, 2) DEFAULT NULL,
                               `remarks` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                               `bill_time` datetime DEFAULT NULL,
                               `source_bill_id` int(11) DEFAULT NULL,
                               `status` int(11) DEFAULT NULL,
                               `bill_type` int(11) DEFAULT NULL,
                               `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                               `cost_Id` int(11) DEFAULT NULL,
                               `pro_id` int(11) DEFAULT NULL,
                               `pro_type` int(11) DEFAULT NULL,
                               `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                               `source_bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                               `operator` varchar(50) DEFAULT NULL,
                               `operator_id` int(11) DEFAULT NULL,
                               `acc_id` int(11) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_in_return_sub`;

CREATE TABLE `fin_in_return_sub` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `mast_id` int(11) DEFAULT NULL,
                                   `item_id` int(11) DEFAULT NULL,
                                   `amt` decimal(10, 2) DEFAULT NULL,
                                   `remarks` varchar(400) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_io_item`;

CREATE TABLE `fin_io_item` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `item_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `type_id` int(11) DEFAULT NULL,
                             `remarks` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                             `system_id` varchar(36) CHARACTER SET utf8 DEFAULT NULL,
                             `no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `system_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `status` int(11) DEFAULT '1',
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_io_type`;

CREATE TABLE `fin_io_type` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `type_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `system_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `system_id` varchar(36) DEFAULT NULL,
                             `status` int(11) DEFAULT '1',
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_out`;

CREATE TABLE `fin_out` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `bill_no` varchar(50) DEFAULT NULL,
                         `bill_time` datetime DEFAULT NULL,
                         `pro_id` int(11) DEFAULT NULL,
                         `pro_type` int(11) DEFAULT NULL,
                         `pro_name` varchar(50) DEFAULT NULL,
                         `total_amt` decimal(10, 2) DEFAULT NULL,
                         `acc_id` int(11) DEFAULT NULL,
                         `status` int(11) DEFAULT NULL,
                         `submit_user` varchar(50) DEFAULT NULL,
                         `submit_time` datetime DEFAULT NULL,
                         `operator` varchar(50) DEFAULT NULL,
                         `remarks` varchar(500) DEFAULT NULL,
                         `new_time` datetime DEFAULT NULL,
                         `pay_amt` decimal(10, 2) DEFAULT NULL,
                         `free_amt` decimal(10, 2) DEFAULT '0.00',
                         PRIMARY KEY (`id`),
                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_outsub`;

CREATE TABLE `fin_outsub` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `mast_id` int(11) DEFAULT NULL,
                            `item_id` int(11) DEFAULT NULL,
                            `amt` decimal(10, 2) DEFAULT NULL,
                            `remarks` varchar(500) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_out_return`;

CREATE TABLE `fin_out_return` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `sum_amt` decimal(10, 2) DEFAULT NULL,
                                `remarks` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                                `bill_time` datetime DEFAULT NULL,
                                `source_bill_id` int(11) DEFAULT NULL,
                                `status` int(11) DEFAULT NULL,
                                `bill_type` int(11) DEFAULT NULL,
                                `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `cost_Id` int(11) DEFAULT NULL,
                                `pro_id` int(11) DEFAULT NULL,
                                `pro_type` int(11) DEFAULT NULL,
                                `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `source_bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `operator` varchar(50) DEFAULT NULL,
                                `operator_id` int(11) DEFAULT NULL,
                                `acc_id` int(11) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_out_return_sub`;

CREATE TABLE `fin_out_return_sub` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `mast_id` int(11) DEFAULT NULL,
                                    `item_id` int(11) DEFAULT NULL,
                                    `amt` decimal(10, 2) DEFAULT NULL,
                                    `remarks` varchar(400) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_pay`;

CREATE TABLE `fin_pay` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `bill_no` varchar(50) DEFAULT NULL,
                         `pay_time` datetime DEFAULT NULL,
                         `dep_id` int(11) DEFAULT NULL,
                         `pro_type` int(11) DEFAULT NULL,
                         `emp_id` int(11) DEFAULT NULL,
                         `pro_name` varchar(50) DEFAULT NULL,
                         `cost_bill_id` int(11) DEFAULT NULL,
                         `pay_amt` decimal(10, 2) DEFAULT NULL,
                         `operator` varchar(50) DEFAULT NULL,
                         `submit_user` varchar(50) DEFAULT NULL,
                         `submit_time` datetime DEFAULT NULL,
                         `status` int(11) DEFAULT NULL,
                         `acc_id` int(11) DEFAULT NULL,
                         `remarks` varchar(400) DEFAULT NULL,
                         `new_time` datetime DEFAULT NULL,
                         `cost_term` int(11) DEFAULT NULL,
                         PRIMARY KEY (`id`),
                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_paysub`;

CREATE TABLE `fin_paysub` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `mast_id` int(11) DEFAULT NULL,
                            `cost_id` int(11) DEFAULT NULL,
                            `amt` decimal(10, 2) DEFAULT NULL,
                            `remarks` varchar(400) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_pre_in`;

CREATE TABLE `fin_pre_in` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `bill_time` datetime DEFAULT NULL,
                            `pro_id` int(11) DEFAULT NULL,
                            `pro_type` int(11) DEFAULT NULL,
                            `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `total_amt` decimal(10, 2) DEFAULT NULL,
                            `acc_id` int(11) DEFAULT NULL,
                            `status` int(11) DEFAULT NULL,
                            `submit_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `submit_time` datetime DEFAULT NULL,
                            `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `remarks` varchar(600) CHARACTER SET utf8 DEFAULT NULL,
                            `new_time` datetime DEFAULT NULL,
                            `pay_amt` decimal(10, 2) DEFAULT NULL,
                            `free_amt` decimal(10, 2) DEFAULT '0.00',
                            `back_amt` decimal(10, 2) DEFAULT '0.00',
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_pre_insub`;

CREATE TABLE `fin_pre_insub` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `mast_id` int(11) DEFAULT NULL,
                               `item_id` int(11) DEFAULT NULL,
                               `amt` decimal(10, 2) DEFAULT NULL,
                               `remarks` varchar(600) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_pre_in_return`;

CREATE TABLE `fin_pre_in_return` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `sum_amt` decimal(10, 2) DEFAULT NULL,
                                   `remarks` varchar(100) DEFAULT NULL,
                                   `bill_time` datetime DEFAULT NULL,
                                   `source_bill_id` int(11) DEFAULT NULL,
                                   `status` int(11) DEFAULT NULL,
                                   `bill_type` int(11) DEFAULT NULL,
                                   `bill_no` varchar(50) DEFAULT NULL,
                                   `cost_id` int(11) DEFAULT NULL,
                                   `pro_id` int(11) DEFAULT NULL,
                                   `pro_type` int(11) DEFAULT NULL,
                                   `pro_name` varchar(50) DEFAULT NULL,
                                   `source_bill_no` varchar(50) DEFAULT NULL,
                                   `acc_id` int(11) DEFAULT NULL,
                                   `operator_id` int(11) DEFAULT NULL,
                                   `operator` varchar(50) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_pre_in_return_sub`;

CREATE TABLE `fin_pre_in_return_sub` (
                                       `id` int(11) NOT NULL AUTO_INCREMENT,
                                       `mast_id` int(11) DEFAULT NULL,
                                       `item_id` int(11) DEFAULT NULL,
                                       `amt` decimal(10, 2) DEFAULT NULL,
                                       `remarks` varchar(400) DEFAULT NULL,
                                       PRIMARY KEY (`id`),
                                       tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_pre_out`;

CREATE TABLE `fin_pre_out` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `bill_time` datetime DEFAULT NULL,
                             `pro_id` int(11) DEFAULT NULL,
                             `pro_type` int(11) DEFAULT NULL,
                             `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `total_amt` decimal(10, 2) DEFAULT NULL,
                             `acc_id` int(11) DEFAULT NULL,
                             `status` int(11) DEFAULT NULL,
                             `submit_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `submit_time` datetime DEFAULT NULL,
                             `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `remarks` varchar(600) CHARACTER SET utf8 DEFAULT NULL,
                             `new_time` datetime DEFAULT NULL,
                             `pay_amt` decimal(10, 2) DEFAULT NULL,
                             `free_amt` decimal(10, 2) DEFAULT '0.00',
                             `back_amt` decimal(10, 2) DEFAULT '0.00',
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_pre_outsub`;

CREATE TABLE `fin_pre_outsub` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `mast_id` int(11) DEFAULT NULL,
                                `item_id` int(11) DEFAULT NULL,
                                `amt` decimal(10, 2) DEFAULT NULL,
                                `remarks` varchar(600) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_pre_out_return`;

CREATE TABLE `fin_pre_out_return` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `sum_amt` decimal(10, 2) DEFAULT NULL,
                                    `remarks` varchar(100) DEFAULT NULL,
                                    `bill_time` datetime DEFAULT NULL,
                                    `source_bill_id` int(11) DEFAULT NULL,
                                    `status` int(11) DEFAULT NULL,
                                    `bill_type` int(11) DEFAULT NULL,
                                    `bill_no` varchar(50) DEFAULT NULL,
                                    `cost_id` int(11) DEFAULT NULL,
                                    `pro_id` int(11) DEFAULT NULL,
                                    `pro_type` int(11) DEFAULT NULL,
                                    `pro_name` varchar(50) DEFAULT NULL,
                                    `source_bill_no` varchar(50) DEFAULT NULL,
                                    `acc_id` int(11) DEFAULT NULL,
                                    `operator_id` int(11) DEFAULT NULL,
                                    `operator` varchar(50) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_pre_out_return_sub`;

CREATE TABLE `fin_pre_out_return_sub` (
                                        `id` int(11) NOT NULL AUTO_INCREMENT,
                                        `mast_id` int(11) DEFAULT NULL,
                                        `item_id` int(11) DEFAULT NULL,
                                        `amt` decimal(10, 2) DEFAULT NULL,
                                        `remarks` varchar(400) DEFAULT NULL,
                                        PRIMARY KEY (`id`),
                                        tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_trans`;

CREATE TABLE `fin_trans` (
                           `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '转出账号类型',
                           `sacc_type` int(11) DEFAULT NULL,
                           `sacc_id` int(11) DEFAULT NULL,
                           `tacc_type` int(11) DEFAULT NULL,
                           `tacc_id` int(11) DEFAULT NULL,
                           `trans_amt` decimal(10, 2) DEFAULT NULL,
                           `status` int(11) DEFAULT NULL,
                           `trans_time` datetime DEFAULT NULL,
                           `bill_no` varchar(50) DEFAULT NULL,
                           `operator` varchar(50) DEFAULT NULL,
                           `submit_user` varchar(50) DEFAULT NULL,
                           `submit_time` datetime DEFAULT NULL,
                           `new_time` datetime DEFAULT NULL,
                           `remarks` varchar(100) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `fin_unit`;

CREATE TABLE `fin_unit` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `pro_no` varchar(50) DEFAULT NULL,
                          `pro_name` varchar(50) DEFAULT NULL,
                          `address` varchar(100) DEFAULT NULL,
                          `tel` varchar(50) DEFAULT NULL,
                          `mobile` varchar(50) DEFAULT NULL,
                          `contact` varchar(50) DEFAULT NULL,
                          `remarks` varchar(100) DEFAULT NULL,
                          `left_amt` decimal(10, 2) DEFAULT NULL,
                          `status` int(11) DEFAULT NULL,
                          `fbtime` datetime DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_ban`;

CREATE TABLE `kq_ban` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `member_id` int(11) DEFAULT NULL,
                        `ban_nm` varchar(50) DEFAULT NULL,
                        `start_time` varchar(50) DEFAULT NULL,
                        `end_time` varchar(50) DEFAULT NULL,
                        `days` decimal(10, 2) DEFAULT NULL,
                        `hours` decimal(10, 2) DEFAULT NULL,
                        `remarks` varchar(100) DEFAULT NULL,
                        `ban_date` datetime DEFAULT NULL,
                        `operator` varchar(50) DEFAULT NULL,
                        `status` int(11) DEFAULT NULL,
                        `bc_id` int(11) DEFAULT NULL,
                        PRIMARY KEY (`id`),
                        tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_ban_detail`;

CREATE TABLE `kq_ban_detail` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `member_id` int(11) DEFAULT NULL,
                               `mast_id` int(11) DEFAULT NULL,
                               `kq_date` varchar(50) DEFAULT NULL,
                               `hours` decimal(10, 2) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_bc`;

CREATE TABLE `kq_bc` (
                       `id` int(11) NOT NULL AUTO_INCREMENT,
                       `bc_name` varchar(50) DEFAULT NULL COMMENT '班次名称',
                       `bc_code` varchar(50) DEFAULT NULL COMMENT '编号',
                       `late_minute` int(11) DEFAULT NULL COMMENT '吃到多少分钟算迟到',
                       `early_minute` int(11) DEFAULT NULL COMMENT '早退多少分钟算早退',
                       `before_minute` int(11) DEFAULT NULL COMMENT '上班前多少分钟内刷卡有效',
                       `after_minute` int(11) DEFAULT NULL COMMENT '下班后多少分钟内刷卡有效',
                       `bc_type` int(11) DEFAULT NULL COMMENT '班次类型0固定班制 1外勤制',
                       `latitude` varchar(50) DEFAULT NULL,
                       `longitude` varchar(50) DEFAULT NULL,
                       `area_long` int(11) DEFAULT NULL COMMENT '有效范围',
                       `out_of` int(11) DEFAULT NULL COMMENT '在考勤范围以外是否可以签到或退 0不行 1可以',
                       `cross_day` int(11) DEFAULT NULL COMMENT '是否跨天0不跨天 1跨天',
                       `status` int(11) DEFAULT NULL,
                       `remarks` varchar(100) DEFAULT NULL,
                       `address` varchar(255) DEFAULT NULL,
                       PRIMARY KEY (`id`),
                       tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_bc_times`;

CREATE TABLE `kq_bc_times` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `start_time` varchar(20) DEFAULT NULL,
                             `end_time` varchar(20) DEFAULT NULL,
                             `bc_id` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_chg_bc`;

CREATE TABLE `kq_chg_bc` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `chg_date` varchar(50) DEFAULT NULL,
                           `from_date` varchar(50) DEFAULT NULL,
                           `to_date` varchar(50) DEFAULT NULL,
                           `member_id` int(11) DEFAULT NULL,
                           `bc_id1` int(11) DEFAULT NULL,
                           `bc_id2` int(11) DEFAULT NULL,
                           `remarks` varchar(200) DEFAULT NULL,
                           `operator` varchar(255) DEFAULT NULL,
                           `status` int(11) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_detail`;

CREATE TABLE `kq_detail` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `member_id` int(11) DEFAULT NULL,
                           `kq_date` varchar(20) DEFAULT NULL,
                           `kq_status` varchar(50) DEFAULT NULL,
                           `bc_id` int(11) DEFAULT NULL,
                           `bc_name` varchar(50) DEFAULT NULL,
                           `tfrom1` varchar(100) DEFAULT NULL,
                           `dto1` varchar(100) DEFAULT NULL,
                           `tfrom2` varchar(100) DEFAULT NULL,
                           `dto2` varchar(100) DEFAULT NULL,
                           `remarks` varchar(100) DEFAULT NULL,
                           `minute1` int(11) DEFAULT NULL,
                           `minute2` int(11) DEFAULT NULL,
                           `dis1` int(11) DEFAULT NULL,
                           `dis2` int(11) DEFAULT NULL,
                           `dis11` int(11) DEFAULT NULL,
                           `dis22` int(11) DEFAULT NULL,
                           `cd_minute` int(11) DEFAULT NULL,
                           `zt_minute` int(11) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_emp_rule`;

CREATE TABLE `kq_emp_rule` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `member_id` int(11) DEFAULT NULL,
                             `rule_id` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_holiday`;

CREATE TABLE `kq_holiday` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `day_name` varchar(50) DEFAULT NULL,
                            `start_date` varchar(20) DEFAULT NULL,
                            `end_date` varchar(20) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_jia`;

CREATE TABLE `kq_jia` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `member_id` int(11) DEFAULT NULL,
                        `jia_nm` varchar(50) DEFAULT NULL,
                        `start_time` varchar(50) DEFAULT NULL,
                        `end_time` varchar(50) DEFAULT NULL,
                        `days` decimal(10, 2) DEFAULT NULL,
                        `hours` decimal(10, 2) DEFAULT NULL,
                        `remarks` varchar(100) DEFAULT NULL,
                        `status` int(11) DEFAULT NULL,
                        `jia_date` datetime DEFAULT NULL,
                        `operator` varchar(50) DEFAULT NULL,
                        PRIMARY KEY (`id`),
                        tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_jia_detail`;

CREATE TABLE `kq_jia_detail` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `member_id` int(11) DEFAULT NULL,
                               `mast_id` int(11) DEFAULT NULL,
                               `kq_date` varchar(50) DEFAULT NULL,
                               `hours` decimal(10, 2) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_pb`;

CREATE TABLE `kq_pb` (
                       `id` int(11) NOT NULL AUTO_INCREMENT,
                       `member_id` int(11) DEFAULT NULL,
                       `bc_id` int(11) DEFAULT NULL,
                       `bc_date` varchar(20) DEFAULT NULL,
                       PRIMARY KEY (`id`),
                       tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_remarks`;

CREATE TABLE `kq_remarks` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `kq_date` varchar(50) DEFAULT NULL,
                            `remarks` varchar(100) DEFAULT NULL,
                            `member_id` int(11) DEFAULT NULL,
                            `status` int(11) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_rule`;

CREATE TABLE `kq_rule` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `rule_name` varchar(50) DEFAULT NULL,
                         `rule_unit` int(11) DEFAULT NULL,
                         `days` int(11) DEFAULT NULL,
                         `remarks` varchar(100) DEFAULT NULL,
                         `status` int(11) DEFAULT NULL,
                         PRIMARY KEY (`id`),
                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `kq_rule_detail`;

CREATE TABLE `kq_rule_detail` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `rule_id` int(11) DEFAULT NULL,
                                `seq_no` int(11) DEFAULT NULL,
                                `bc_id` int(11) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_acc_set`;

CREATE TABLE `pos_acc_set` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `shop_no` varchar(20) DEFAULT NULL,
                             `cash_acc_id` int(11) DEFAULT NULL,
                             `bank_acc_id` int(11) DEFAULT NULL,
                             `member_acc_id` int(11) DEFAULT NULL,
                             `wx_acc_id` int(11) DEFAULT NULL,
                             `zfb_acc_id` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_auth_code`;

CREATE TABLE `pos_auth_code` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `card_id` int(11) DEFAULT NULL,
                               `auth_code` varchar(50) DEFAULT NULL,
                               `use_time` varchar(20) DEFAULT NULL,
                               `make_time` varchar(20) DEFAULT NULL,
                               `status` int(11) DEFAULT NULL,
                               `amt` decimal(10, 2) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_cardinit`;

CREATE TABLE `pos_cardinit` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `bill_no` varchar(50) DEFAULT NULL,
                              `bill_time` datetime DEFAULT NULL,
                              `sum_cash` decimal(10, 0) DEFAULT NULL,
                              `sum_free` decimal(10, 0) DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              `operator` varchar(50) DEFAULT NULL,
                              `cancel_user` varchar(50) DEFAULT NULL,
                              `cancel_time` datetime DEFAULT NULL,
                              `remarks` varchar(200) DEFAULT NULL,
                              `submit_user` varchar(50) DEFAULT NULL,
                              `submit_time` datetime DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_cardinit_sub`;

CREATE TABLE `pos_cardinit_sub` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `mast_id` int(11) DEFAULT NULL,
                                  `mem_id` int(11) DEFAULT NULL,
                                  `input_cash` decimal(10, 2) DEFAULT NULL,
                                  `free_cost` decimal(10, 2) DEFAULT NULL,
                                  `remarks` varchar(100) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_card_rate`;

CREATE TABLE `pos_card_rate` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `card_type` int(11) DEFAULT NULL,
                               `shop_no` varchar(10) DEFAULT NULL,
                               `rate_type` int(11) DEFAULT NULL,
                               `ware_type` int(11) DEFAULT NULL,
                               `ware_id` int(11) DEFAULT NULL,
                               `rate` float DEFAULT NULL,
                               `dis_price` decimal(10, 2) DEFAULT NULL,
                               `start_time` datetime DEFAULT NULL,
                               `end_time` datetime DEFAULT NULL,
                               `status` int(11) DEFAULT NULL,
                               `created_on` datetime DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_card_type`;

CREATE TABLE `pos_card_type` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `type_name` varchar(50) DEFAULT NULL,
                               `discount` int(11) DEFAULT NULL,
                               `cost` decimal(10, 2) DEFAULT NULL,
                               `days` int(11) DEFAULT NULL,
                               `unit` int(11) DEFAULT NULL,
                               `input_cash` decimal(10, 2) DEFAULT NULL,
                               `free_cost` decimal(10, 2) DEFAULT NULL,
                               `shop_input` int(11) DEFAULT NULL,
                               `shop_cost` int(11) DEFAULT NULL,
                               `amt_rate` float DEFAULT NULL,
                               `status` int(11) DEFAULT NULL,
                               `jici_amt` decimal(10, 2) DEFAULT NULL,
                               `price` decimal(10, 2) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_function`;

CREATE TABLE `pos_function` (
                              `id` int(11) NOT NULL,
                              `module_id` int(11) DEFAULT NULL,
                              `func_name` varchar(50) DEFAULT NULL,
                              `isrun` int(11) DEFAULT '1',
                              `isinsert` int(11) DEFAULT '0',
                              `isedit` int(11) DEFAULT '0',
                              `isdelete` int(11) DEFAULT '0',
                              `type_name` varchar(50) DEFAULT NULL,
                              `func_url` varchar(100) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_group`;

CREATE TABLE `pos_group` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `group_name` varchar(50) DEFAULT NULL,
                           `is_supper` int(11) DEFAULT NULL,
                           `remarks` varchar(200) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_group_right`;

CREATE TABLE `pos_group_right` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `group_id` int(11) DEFAULT NULL,
                                 `func_id` int(11) DEFAULT NULL,
                                 `isrun` int(11) DEFAULT NULL,
                                 `isinsert` int(11) DEFAULT NULL,
                                 `isedit` int(11) DEFAULT NULL,
                                 `isdelete` int(11) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_membertype_price`;

CREATE TABLE `pos_membertype_price` (
                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                      `member_type` int(11) DEFAULT NULL,
                                      `ware_id` int(11) DEFAULT NULL,
                                      `pos_price1` decimal(10, 2) DEFAULT NULL,
                                      `pos_price2` decimal(10, 2) DEFAULT NULL,
                                      `shop_no` varchar(20) DEFAULT NULL,
                                      PRIMARY KEY (`id`),
                                      tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_member_ticket`;

CREATE TABLE `pos_member_ticket` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `ticket_barcode` varchar(50) DEFAULT NULL,
                                   `ticket_name` varchar(50) DEFAULT NULL,
                                   `amt` decimal(10, 2) DEFAULT NULL,
                                   `mem_id` int(11) DEFAULT NULL,
                                   `status` int(11) DEFAULT '0' COMMENT '0 未使用 1已使用 ',
                                   `end_date` varchar(20) DEFAULT NULL,
                                   `use_date` varchar(20) DEFAULT NULL,
                                   `ware_type` int(11) DEFAULT NULL,
                                   `ticket_type` int(11) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_module`;

CREATE TABLE `pos_module` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `module_name` varchar(50) DEFAULT NULL,
                            `pos_type` int(11) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_msgformat`;

CREATE TABLE `pos_msgformat` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `msg` varchar(200) DEFAULT NULL,
                               `msg_type` varchar(50) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_params`;

CREATE TABLE `pos_params` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `param_name` varchar(100) DEFAULT NULL,
                            `param_value` varchar(100) DEFAULT NULL,
                            `shop_no` varchar(50) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_sale`;

CREATE TABLE `pos_sale` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `doc_no` varchar(50) DEFAULT NULL,
                          `hand_no` varchar(50) DEFAULT NULL,
                          `cst_name` varchar(50) DEFAULT NULL,
                          `bill_date` varchar(50) DEFAULT NULL,
                          `total_amt` decimal(10, 2) DEFAULT NULL,
                          `is_pay` int(11) DEFAULT NULL,
                          `card_no` varchar(50) DEFAULT NULL,
                          `card_id` int(11) DEFAULT NULL,
                          `cash_pay` decimal(10, 2) DEFAULT NULL,
                          `ticket_pay` decimal(10, 2) DEFAULT NULL,
                          `bank_pay` decimal(10, 2) DEFAULT NULL,
                          `card_pay` decimal(10, 2) DEFAULT NULL,
                          `free_amt` decimal(10, 2) DEFAULT NULL,
                          `operator` varchar(50) DEFAULT NULL,
                          `pos` int(11) DEFAULT NULL,
                          `shop_no` varchar(50) DEFAULT NULL,
                          `doc_type` int(11) DEFAULT NULL,
                          `emp_id` int(50) DEFAULT NULL,
                          `tel` varchar(50) DEFAULT NULL,
                          `card_type` int(11) DEFAULT NULL,
                          `amt_rate` float DEFAULT NULL COMMENT '金额系数',
                          `new_shop_no` varchar(10) DEFAULT NULL,
                          `wx_pay` decimal(50, 2) DEFAULT NULL,
                          `zfb_pay` decimal(10, 2) DEFAULT NULL,
                          `add_value` int(11) DEFAULT NULL COMMENT '增加积分',
                          `new_time` datetime DEFAULT NULL,
                          `discount` decimal(10, 2) DEFAULT NULL COMMENT '整单折扣',
                          `tail_amt` decimal(10, 0) DEFAULT NULL COMMENT '抹零',
                          `pay_amt` decimal(10, 0) DEFAULT NULL COMMENT '需要支付的金额',
                          `status` int(11) DEFAULT NULL,
                          `left_amt` decimal(10, 2) DEFAULT NULL,
                          `need_pay` decimal(10, 2) DEFAULT NULL,
                          `out_trade_no` varchar(50) DEFAULT NULL,
                          `stk_id` int(11) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_sale_cancel`;

CREATE TABLE `pos_sale_cancel` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `cancel_date` varchar(50) DEFAULT NULL,
                                 `operator` varchar(50) DEFAULT NULL,
                                 `permit` varchar(50) DEFAULT NULL,
                                 `bill_id` int(11) DEFAULT NULL,
                                 `remarks` varchar(200) DEFAULT NULL,
                                 `doc_no` varchar(50) DEFAULT NULL,
                                 `shop_no` varchar(50) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_sale_sub`;

CREATE TABLE `pos_sale_sub` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `mast_id` int(11) DEFAULT NULL,
                              `seq_no` int(11) DEFAULT NULL,
                              `ware_id` int(11) DEFAULT NULL,
                              `ware_nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `waretype` int(11) DEFAULT NULL,
                              `price` decimal(10, 2) DEFAULT NULL,
                              `qty` decimal(10, 2) DEFAULT NULL,
                              `rate` float DEFAULT NULL,
                              `dis_price` decimal(10, 2) DEFAULT NULL,
                              `dis_amt` decimal(10, 2) DEFAULT NULL,
                              `is_free` int(11) DEFAULT NULL,
                              `cost` decimal(10, 2) DEFAULT NULL,
                              `pay_amt` decimal(10, 2) DEFAULT NULL,
                              `shop_no` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                              `card_id` int(11) DEFAULT NULL,
                              `permit` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `cash` decimal(10, 2) DEFAULT NULL,
                              `ticket` decimal(10, 2) DEFAULT NULL,
                              `card` decimal(10, 2) DEFAULT NULL,
                              `jici_qty` int(11) DEFAULT NULL,
                              `jici_rest` int(11) DEFAULT NULL,
                              `bank` decimal(10, 2) DEFAULT NULL,
                              `wx` decimal(10, 0) DEFAULT NULL,
                              `zfb` decimal(10, 2) DEFAULT NULL,
                              `sub_memo` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                              `sale_rate` float DEFAULT NULL,
                              `card_rate` float DEFAULT NULL,
                              `card_price` decimal(10, 2) DEFAULT NULL,
                              `spec_price` decimal(10, 2) DEFAULT NULL,
                              `is_good` int(11) DEFAULT NULL,
                              `jici_price` decimal(10, 2) DEFAULT NULL,
                              `other_rate` float DEFAULT NULL,
                              `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `be_unit` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `stk_price` decimal(10, 2) DEFAULT NULL,
                              `stk_amt` decimal(10, 2) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_shopinfo`;

CREATE TABLE `pos_shopinfo` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `shop_no` varchar(10) DEFAULT NULL,
                              `shop_name` varchar(50) DEFAULT NULL,
                              `contact` varchar(50) DEFAULT NULL,
                              `tel` varchar(50) DEFAULT NULL,
                              `address` varchar(50) DEFAULT NULL,
                              `created_on` datetime DEFAULT NULL,
                              `can_input` int(11) DEFAULT NULL,
                              `can_cost` int(11) DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              `stk_id` int(11) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_shop_emp`;

CREATE TABLE `pos_shop_emp` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `member_id` int(11) DEFAULT NULL,
                              `shop_id` int(11) DEFAULT NULL,
                              `group_id` int(11) DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_shop_rate`;

CREATE TABLE `pos_shop_rate` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `shop_no` varchar(10) DEFAULT NULL,
                               `rate_type` int(11) DEFAULT NULL,
                               `ware_type` int(11) DEFAULT NULL,
                               `ware_id` int(11) DEFAULT NULL,
                               `rate` float DEFAULT NULL,
                               `dis_price` decimal(10, 2) DEFAULT NULL,
                               `start_time` datetime DEFAULT NULL,
                               `end_time` datetime DEFAULT NULL,
                               `created_on` datetime DEFAULT NULL,
                               `status` int(11) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_shop_ware`;

CREATE TABLE `pos_shop_ware` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `shop_no` varchar(20) DEFAULT NULL,
                               `ware_id` int(11) DEFAULT NULL,
                               `default_unit` int(11) DEFAULT '0' COMMENT '0 小单位 1大单位',
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_shop_waretype`;

CREATE TABLE `pos_shop_waretype` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `shop_no` varchar(20) DEFAULT NULL,
                                   `waretype_id` int(11) DEFAULT NULL,
                                   `chk_state` int(11) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_sms_set`;

CREATE TABLE `pos_sms_set` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `msg_head` varchar(50) DEFAULT NULL,
                             `cost_send` int(11) DEFAULT NULL,
                             `input_send` int(11) DEFAULT NULL,
                             `shop_no` varchar(50) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_ticket_cost`;

CREATE TABLE `pos_ticket_cost` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `mast_id` int(11) DEFAULT NULL,
                                 `ticket_barcode` varchar(50) DEFAULT NULL,
                                 `amt` decimal(10, 2) DEFAULT NULL,
                                 `doc_no` varchar(50) DEFAULT NULL,
                                 `ticket_name` varchar(50) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_ticket_issue`;

CREATE TABLE `pos_ticket_issue` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `issue_date` datetime DEFAULT NULL,
                                  `operator` varchar(50) DEFAULT NULL,
                                  `ticket_qty` int(11) DEFAULT NULL,
                                  `ticket_amt` decimal(10, 2) DEFAULT NULL,
                                  `shop_no` varchar(20) DEFAULT NULL,
                                  `ware_type` int(11) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_ticket_type`;

CREATE TABLE `pos_ticket_type` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `ticket_name` varchar(50) DEFAULT NULL,
                                 `ticket_no` varchar(50) DEFAULT NULL,
                                 `seq_len` int(11) DEFAULT NULL,
                                 `amt` decimal(10, 2) DEFAULT NULL,
                                 `status` int(11) DEFAULT NULL,
                                 `remarks` varchar(100) DEFAULT NULL,
                                 `ware_type` int(11) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_update_detail`;

CREATE TABLE `pos_update_detail` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `obj_id` int(11) DEFAULT NULL,
                                   `update_time` datetime DEFAULT NULL,
                                   `update_type` varchar(50) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_update_log`;

CREATE TABLE `pos_update_log` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `update_type` varchar(50) DEFAULT NULL,
                                `update_time` varchar(50) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_user_log`;

CREATE TABLE `pos_user_log` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `start_time` varchar(20) DEFAULT NULL,
                              `end_time` varchar(20) DEFAULT NULL,
                              `shop_no` varchar(20) DEFAULT NULL,
                              `member_id` int(11) DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              `hang_qty` int(11) DEFAULT NULL,
                              `hang_amt` decimal(10, 2) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_wxset`;

CREATE TABLE `pos_wxset` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `appid` varchar(100) DEFAULT NULL,
                           `sub_appid` varchar(100) DEFAULT NULL,
                           `mch_id` varchar(100) DEFAULT NULL,
                           `wxkey` varchar(100) DEFAULT NULL,
                           `device_info` varchar(100) DEFAULT NULL,
                           `sub_mch_id` varchar(100) DEFAULT NULL,
                           `shop_no` varchar(50) DEFAULT NULL,
                           `status` int(11) DEFAULT NULL,
                           `appsecret` varchar(100) DEFAULT NULL,
                           `back_url` varchar(100) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `pos_zfbset`;

CREATE TABLE `pos_zfbset` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `pid` varchar(100) DEFAULT NULL,
                            `appid` varchar(100) DEFAULT NULL,
                            `private_key` varchar(3000) DEFAULT NULL,
                            `public_key` varchar(2000) DEFAULT NULL,
                            `alipay_public_key` varchar(2000) DEFAULT NULL,
                            `shop_no` varchar(50) DEFAULT NULL,
                            `status` int(11) DEFAULT NULL,
                            `app_auth_token` varchar(100) DEFAULT NULL,
                            `expires_in` int(11) DEFAULT NULL,
                            `app_refresh_token` varchar(100) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `product_temp`;

CREATE TABLE `product_temp` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `category_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '所属分类',
                              `product_code` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '商品编码',
                              `product_name` varchar(100) CHARACTER SET utf8 NOT NULL COMMENT '商品名称',
                              `big_unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '大单位名称',
                              `big_unit_spec` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '大单位规格',
                              `big_unit_scale` decimal(6, 2) DEFAULT NULL COMMENT '大单位换算基数',
                              `big_bar_code` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '大单位条码',
                              `big_purchase_price` decimal(10, 2) DEFAULT NULL COMMENT '大单位采购价格',
                              `big_sale_price` decimal(10, 2) DEFAULT NULL COMMENT '大单位销售单价',
                              `small_unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '小单位名称',
                              `small_unit_spec` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '小单位规格',
                              `small_unit_scale` decimal(6, 2) DEFAULT NULL COMMENT '小单位换算基数',
                              `small_bar_code` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '小单位条码',
                              `small_sale_price` decimal(10, 2) DEFAULT NULL COMMENT '小单位销售价',
                              `expiration_date` varchar(30) CHARACTER SET utf8 DEFAULT NULL COMMENT '保质期',
                              `provider_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '生产厂家',
                              `updated_by` int(11) NOT NULL COMMENT '更新人',
                              `updated_time` datetime DEFAULT NULL COMMENT '更新时间',
                              `record_id` int(11) NOT NULL COMMENT '导入记录 id',
                              `remark` varchar(50) DEFAULT NULL COMMENT '产品备注',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `product_temp_record`;

CREATE TABLE `product_temp_record` (
                                     `id` int(11) NOT NULL AUTO_INCREMENT,
                                     `record_title` varchar(60) NOT NULL COMMENT '记录标题',
                                     `created_by` int(11) NOT NULL COMMENT '创建人',
                                     `created_time` datetime NOT NULL COMMENT '创建时间',
                                     PRIMARY KEY (`id`),
                                     tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_banner_pic`;

CREATE TABLE `shop_banner_pic` (
                                 `id` int(10) NOT NULL AUTO_INCREMENT,
                                 `type` int(10) DEFAULT NULL,
                                 `banner_id` int(10) DEFAULT NULL COMMENT '1:首页banner',
                                 `pic` varchar(255) DEFAULT NULL,
                                 `pic_mini` varchar(255) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_cart`;

CREATE TABLE `shop_cart` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `shop_mem_id` int(11) DEFAULT NULL COMMENT '会员id',
                           `mem_id` int(11) DEFAULT NULL COMMENT '平台id',
                           `ware_id` int(11) DEFAULT NULL COMMENT '商品id',
                           `ware_num` double DEFAULT NULL COMMENT '商品数量',
                           `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                           `be_unit` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                           `cart_type` int(11) DEFAULT '0' COMMENT '购物车类型:0加入购物车,1立即下单',
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_city_ware`;

CREATE TABLE `shop_city_ware` (
                                `ware_id` int(11) NOT NULL COMMENT '商品id',
                                PRIMARY KEY (`ware_id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_config_set`;

CREATE TABLE `shop_config_set` (
                                 `id` int(10) NOT NULL AUTO_INCREMENT,
                                 `name` varchar(50) DEFAULT NULL,
                                 `banner_id` int(50) DEFAULT NULL COMMENT '广告图',
                                 `model1` varchar(50) DEFAULT '1' COMMENT '首页子模板1:对应是分组商品',
                                 `model2` varchar(50) DEFAULT '2' COMMENT '首页子模板2:对应是分组商品',
                                 `model3` varchar(50) DEFAULT '3' COMMENT '首页子模板3:对应是分组商品',
                                 `template` varchar(10) DEFAULT NULL COMMENT '主模板',
                                 `logo` varchar(255) DEFAULT NULL COMMENT 'logo图',
                                 `waretype` varchar(100) DEFAULT NULL COMMENT '商品一级分类：''1,2,3''',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_group_style`;

CREATE TABLE `shop_group_style` (
                                  `group_style_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '样式id',
                                  `group_style_name` varchar(50) NOT NULL COMMENT '样式名称',
                                  `group_style_img` varchar(255) DEFAULT NULL COMMENT '样式图片',
                                  `group_style_remark` varchar(500) DEFAULT NULL COMMENT '样式说明',
                                  `group_style_html` varchar(500) DEFAULT NULL COMMENT '样式html',
                                  PRIMARY KEY (`group_style_id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_group_ware`;

CREATE TABLE `shop_group_ware` (
                                 `group_id` int(11) NOT NULL COMMENT '分组id',
                                 `ware_id` int(11) NOT NULL COMMENT '商品id',
                                 `sort` int(11) DEFAULT NULL COMMENT '排序越大越前',
                                 PRIMARY KEY (`group_id`, `ware_id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_main_model`;

CREATE TABLE `shop_main_model` (
                                 `id` int(10) NOT NULL AUTO_INCREMENT,
                                 `model_id` varchar(10) DEFAULT NULL COMMENT '首页子模块',
                                 `group_id` varchar(10) DEFAULT NULL COMMENT '分组id',
                                 `ware_ids` varchar(50) DEFAULT NULL COMMENT '商品ids',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_member`;

CREATE TABLE `shop_member` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `open_id` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
                             `card_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `mem_id` int(11) NOT NULL,
                             `card_type` int(11) DEFAULT NULL,
                             `input_cash` decimal(10, 2) DEFAULT '0.00',
                             `free_cost` decimal(10, 2) DEFAULT '0.00',
                             `ic_card` int(11) DEFAULT NULL,
                             `shop_no` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                             `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `mobile` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `address` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
                             `sex` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                             `pwd` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                             `weixin` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `qq` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `email` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `pic` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
                             `reg_date` datetime DEFAULT NULL,
                             `active_date` datetime DEFAULT NULL,
                             `status` int(10) DEFAULT NULL,
                             `id_card` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
                             `mem_card` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                             `m_type` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                             `customer_id` int(11) DEFAULT NULL,
                             `customer_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                             `company_id` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                             `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
                             `nickname` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `country` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `province` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `city` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `card_date` varchar(50) CHARACTER SET utf8 DEFAULT '无限期',
                             `card_cost` decimal(10, 2) DEFAULT NULL,
                             `last_time` datetime DEFAULT NULL,
                             `created_on` datetime DEFAULT NULL,
                             `birthday` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `ope_count` int(11) DEFAULT '0',
                             `sum_value` int(11) DEFAULT '0',
                             `sum_cost` decimal(10, 2) DEFAULT '0.00',
                             `sum_input` decimal(10, 2) DEFAULT '0.00',
                             `psw` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `sp_mem_grade_id` int(16) DEFAULT NULL,
                             `is_xxzf` int(2) DEFAULT NULL,
                             `source` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                             `hy_source` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                             `kh_close` int(11) DEFAULT NULL,
                             `is_jxc` int(11) DEFAULT NULL,
                             `bill_no` varchar(50) DEFAULT NULL,
                             `update_date` datetime DEFAULT NULL COMMENT '修改时间',
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_member_address`;

CREATE TABLE `shop_member_address` (
                                     `id` int(11) NOT NULL AUTO_INCREMENT,
                                     `hy_id` int(11) NOT NULL COMMENT '公司会员id',
                                     `mem_id` int(11) NOT NULL COMMENT '平台会员id',
                                     `linkman` varchar(50) NOT NULL COMMENT '联系人',
                                     `mobile` varchar(50) NOT NULL COMMENT '手机号',
                                     `address` varchar(200) NOT NULL COMMENT '地址',
                                     `latitude` varchar(50) DEFAULT NULL,
                                     `longitude` varchar(50) DEFAULT NULL,
                                     `is_default` varchar(20) DEFAULT '0' COMMENT '是否默认（0：否；1：是）',
                                     `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                     `update_time` datetime DEFAULT NULL COMMENT '修改时间',
                                     `province_id` int(11) DEFAULT '0' COMMENT '省级id',
                                     `area_id` int(11) NOT NULL DEFAULT '0' COMMENT '地区id',
                                     `city_id` int(11) DEFAULT NULL COMMENT '市级id',
                                     `area_info` varchar(200) NOT NULL COMMENT '地区内容',
                                     PRIMARY KEY (`id`),
                                     tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_member_grade`;

CREATE TABLE `shop_member_grade` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `coding` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '编码',
                                   `grade_name` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '等级名称',
                                   `grade_no` int(11) DEFAULT NULL COMMENT '级别',
                                   `status` varchar(10) CHARACTER SET utf8 DEFAULT NULL COMMENT '0-不启用 ; 1-启用(默认)',
                                   `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                   `update_time` datetime DEFAULT NULL COMMENT '修改时间',
                                   `is_xxzf` int(2) DEFAULT NULL,
                                   `is_jxc` int(11) DEFAULT NULL,
                                   `pos_id` int(11) DEFAULT NULL COMMENT '门店等级ID',
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_member_grade_price`;

CREATE TABLE `shop_member_grade_price` (
                                         `id` int(11) NOT NULL AUTO_INCREMENT,
                                         `grade_id` int(11) DEFAULT NULL,
                                         `ware_id` int(11) DEFAULT NULL,
                                         `price` varchar(255) DEFAULT NULL,
                                         `status` varchar(255) DEFAULT NULL,
                                         `shop_ware_price` decimal(10, 2) DEFAULT NULL,
                                         `shop_ware_ls_price` decimal(10, 2) DEFAULT NULL,
                                         `shop_ware_cx_price` decimal(10, 2) DEFAULT NULL,
                                         `shop_ware_small_price` decimal(10, 2) DEFAULT NULL,
                                         `shop_ware_small_ls_price` decimal(10, 2) DEFAULT NULL,
                                         `shop_ware_small_cx_price` decimal(10, 2) DEFAULT NULL,
                                         PRIMARY KEY (`id`),
                                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_member_history`;

CREATE TABLE `shop_member_history` (
                                     `id` int(11) NOT NULL AUTO_INCREMENT,
                                     `ware_id` int(11) NOT NULL COMMENT '商品id',
                                     `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
                                     `update_time` bigint(20) DEFAULT NULL COMMENT '修改时间,默认为创建时间',
                                     `hy_id` int(11) DEFAULT NULL COMMENT '企业会员id',
                                     `mem_id` int(11) DEFAULT NULL COMMENT '平台会员id',
                                     `count` int(11) DEFAULT '1' COMMENT '访问次数',
                                     PRIMARY KEY (`id`),
                                     tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_member_io`;

CREATE TABLE `shop_member_io` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `card_id` int(11) DEFAULT NULL COMMENT '卡ID',
                                `card_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '卡号',
                                `input_cash` decimal(10, 2) DEFAULT NULL COMMENT '充值金额',
                                `free_cost` decimal(10, 2) DEFAULT NULL COMMENT '赠送金额',
                                `doc_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '单号',
                                `io_time` datetime DEFAULT NULL COMMENT '操作时间',
                                `io_flag` int(11) DEFAULT NULL COMMENT '操作类型0 发卡 1充值 2消费 3挂失 4补卡 5退卡',
                                `left_amt` decimal(10, 2) DEFAULT NULL COMMENT '余额',
                                `new_shop_no` varchar(10) CHARACTER SET utf8 DEFAULT NULL COMMENT '发卡店',
                                `shop_no` varchar(10) CHARACTER SET utf8 DEFAULT NULL COMMENT '操作门店',
                                `card_pay` decimal(10, 2) DEFAULT NULL COMMENT '卡支付',
                                `cash_pay` decimal(10, 2) DEFAULT NULL COMMENT '现金支付',
                                `bank_pay` decimal(10, 2) DEFAULT NULL COMMENT '银行卡支付',
                                `wx_pay` decimal(10, 2) DEFAULT NULL COMMENT '微信支付',
                                `zfb_pay` double(10, 2) DEFAULT NULL COMMENT '支付宝支付',
                                `status` int(11) DEFAULT NULL COMMENT '状态1正常 -1作废',
                                `created_on` datetime DEFAULT NULL COMMENT '创建时间',
                                `card_type` int(11) DEFAULT NULL,
                                `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `io_value` int(11) DEFAULT NULL,
                                `emp_id` int(11) DEFAULT NULL COMMENT '操作员ID',
                                `bill_no` varchar(50) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_member_price`;

CREATE TABLE `shop_member_price` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `shop_member_id` int(11) DEFAULT NULL COMMENT '会员id',
                                   `ware_id` int(11) DEFAULT NULL COMMENT '商品id',
                                   `shop_ware_price` decimal(10, 2) DEFAULT NULL COMMENT '商品大单位批发价',
                                   `shop_ware_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '商品大单位零售价',
                                   `shop_ware_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '商品大单位促销价',
                                   `shop_ware_small_price` decimal(10, 2) DEFAULT NULL COMMENT '商品小单位批发价',
                                   `shop_ware_small_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '商品小单位零售价',
                                   `shop_ware_small_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '商品小单位促销价',
                                   PRIMARY KEY (`id`),
                                   KEY `id` (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_member_type`;

CREATE TABLE `shop_member_type` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `type_name` varchar(50) DEFAULT NULL COMMENT '类型名称',
                                  `prefix` varchar(10) DEFAULT NULL COMMENT '卡号前缀',
                                  `day_long` int(11) DEFAULT NULL COMMENT '有效期',
                                  `date_unit` int(11) DEFAULT NULL COMMENT '有效期单位',
                                  `cost` decimal(10, 2) DEFAULT NULL COMMENT '工本费',
                                  `input_cash` decimal(10, 2) DEFAULT NULL COMMENT '充值金额',
                                  `free_cost` decimal(10, 2) DEFAULT NULL COMMENT '赠送金额',
                                  `new_card` int(11) DEFAULT NULL COMMENT '店号可发卡否',
                                  `modify_amt` int(11) DEFAULT NULL COMMENT '可修改金额否',
                                  `hanged` int(11) DEFAULT NULL COMMENT '可挂失否',
                                  `shop_share` int(11) DEFAULT NULL COMMENT '是否可通用',
                                  `date_type` int(11) DEFAULT NULL COMMENT '有效期类型',
                                  `ic_type` int(11) DEFAULT NULL COMMENT '卡介质',
                                  `created_on` datetime DEFAULT NULL,
                                  `status` int(11) DEFAULT NULL,
                                  `discount` decimal(10, 2) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_order_log`;

CREATE TABLE `shop_order_log` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `order_id` int(11) DEFAULT NULL,
                                `log_time` datetime DEFAULT NULL,
                                `remarks` varchar(100) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_params`;

CREATE TABLE `shop_params` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `param_name` varchar(50) DEFAULT NULL,
                             `param_value` varchar(100) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_pay_log`;

CREATE TABLE `shop_pay_log` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `order_id` int(11) DEFAULT NULL,
                              `paytype` varchar(50) DEFAULT NULL,
                              `member_id` int(11) DEFAULT NULL,
                              `pay_time` datetime DEFAULT NULL,
                              `pay_amt` decimal(10, 2) DEFAULT NULL,
                              `status` int(11) DEFAULT '0' COMMENT '0表示未入账 1已入账 2作废',
                              `bill_type` int(11) DEFAULT NULL COMMENT '0 订单 1充值',
                              `order_no` varchar(50) DEFAULT NULL,
                              `tel` varchar(50) DEFAULT NULL,
                              `recharge_id` int(11) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_recharge_amount`;

CREATE TABLE `shop_recharge_amount` (
                                      `id` int(10) NOT NULL AUTO_INCREMENT,
                                      `cz_amount` double DEFAULT NULL COMMENT '充值金额',
                                      `zs_amount` double DEFAULT NULL COMMENT '赠送金额',
                                      `status` int(10) DEFAULT '1' COMMENT '0:不启用，1：启用',
                                      PRIMARY KEY (`id`),
                                      tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_reward`;

CREATE TABLE `shop_reward` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `title` varchar(50) NOT NULL COMMENT '活动名称',
                             `start_time` bigint(20) NOT NULL COMMENT '开始时间',
                             `end_time` bigint(20) NOT NULL COMMENT '结束时间',
                             `goods_type` int(11) DEFAULT '0' COMMENT '商品限制类型 0全部商品,1指定商品分类,2指定商品类型,4指定商品 , 10指定规格',
                             `member_type` int(11) DEFAULT '0' COMMENT '会员类型:0全部会员,1指定角色,2指定类型,3指定会员',
                             `coupon_limit_num` int(11) DEFAULT '0' COMMENT '限制数量:0无限',
                             `coupon_time_type` int(11) DEFAULT '0' COMMENT '时间类型:0使用开始结束时间,1券当日起几天可用,2领券次日起几天可用',
                             `coupon_time_day` int(11) DEFAULT '0' COMMENT '天数',
                             `reward_type` int(11) DEFAULT '0' COMMENT '0阶梯优惠1,循环优惠',
                             `activity_type` int(11) DEFAULT '1' COMMENT '类型,0满n件减/送,1满n元减/送',
                             `description` varchar(500) DEFAULT NULL COMMENT '说明',
                             `create_time` bigint(20) DEFAULT NULL,
                             `update_time` bigint(20) DEFAULT NULL,
                             `state` int(11) NOT NULL DEFAULT '0' COMMENT '状态:0保存,1启用,3中止',
                             `overlap` int(11) DEFAULT '0' COMMENT '是否可以重叠0否1是',
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_reward_item`;

CREATE TABLE `shop_reward_item` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `reward_id` int(11) NOT NULL COMMENT '所属活动',
                                  `reward_mode` int(11) DEFAULT '0' COMMENT '订单优惠类型 0无优惠 1减现金 2打折(1-99)',
                                  `level` int(11) DEFAULT NULL COMMENT '阶梯序号',
                                  `meet_amount` decimal(10, 2) NOT NULL COMMENT '满订单金额或数量',
                                  `cash` decimal(10, 2) DEFAULT NULL COMMENT '减现金',
                                  `discount` int(11) DEFAULT NULL COMMENT '折扣',
                                  `postage` tinyint(4) DEFAULT NULL COMMENT '是否包邮0否1是',
                                  `send_score` tinyint(4) DEFAULT NULL COMMENT '是否赠送积分',
                                  `score` int(11) DEFAULT NULL COMMENT '赠送积分',
                                  `send_present` tinyint(4) DEFAULT NULL COMMENT '是否赠送赠品',
                                  `present_ids` text COMMENT '赠品id',
                                  `send_coupon` tinyint(4) DEFAULT NULL COMMENT '是否赠送优惠券',
                                  `coupon_ids` text COMMENT '优惠券id',
                                  `region_ids` text COMMENT '区域id',
                                  `region_names` text COMMENT '区域名称',
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_reward_membership`;

CREATE TABLE `shop_reward_membership` (
                                        `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '会员资格id',
                                        `reward_id` int(11) NOT NULL COMMENT '活动id',
                                        `membership_id` int(11) DEFAULT NULL COMMENT '会员级别id或会员类型id,或会员id',
                                        `member_type` int(11) DEFAULT '0' COMMENT '会员类型:0全部会员,1指定类型,2指定角色,3指定会员',
                                        PRIMARY KEY (`id`),
                                        tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_reward_object`;

CREATE TABLE `shop_reward_object` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `reward_id` int(11) NOT NULL COMMENT '活动id',
                                    `object_id` int(11) DEFAULT NULL COMMENT '对象id,分类id或商品id',
                                    `object_type` int(11) DEFAULT '0' COMMENT '商品限制类型 0全部商品,1指定商品分类,3指定商品',
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_reward_order`;

CREATE TABLE `shop_reward_order` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '优惠资源id',
                                   `order_id` int(11) DEFAULT NULL COMMENT '订单id',
                                   `order_detail_id` int(11) DEFAULT NULL COMMENT '订单明细id',
                                   `reward_id` int(11) DEFAULT NULL COMMENT '活动id',
                                   `reward_item_id` int(11) DEFAULT NULL COMMENT '活动规则id',
                                   `reward_text` varchar(300) DEFAULT NULL COMMENT '活动内容',
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_setting`;

CREATE TABLE `shop_setting` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `name` varchar(255) DEFAULT NULL COMMENT '名称',
                              `context` text COMMENT '内容json',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_transport`;

CREATE TABLE `shop_transport` (
                                `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '运费模板id',
                                `title` varchar(30) NOT NULL COMMENT '运费模板名称',
                                `is_del` int(11) DEFAULT '0' COMMENT '是否删除0:未删除,1:已删除',
                                `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
                                `update_time` bigint(20) DEFAULT NULL COMMENT '修改时间',
                                `is_default` tinyint(4) DEFAULT '0' COMMENT '0否1是',
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_transport_extend`;

CREATE TABLE `shop_transport_extend` (
                                       `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '运费模板扩展id',
                                       `area_id` text COMMENT '市级地区id组成的串，以，隔开，两端也有，',
                                       `area_name` text COMMENT '地区name组成的串，以，隔开',
                                       `snum` int(11) DEFAULT '1' COMMENT '首件数量',
                                       `sprice` decimal(10, 2) DEFAULT '0.00' COMMENT '首件运费',
                                       `xnum` int(11) DEFAULT '1' COMMENT '续件数量',
                                       `xprice` decimal(10, 2) DEFAULT '0.00' COMMENT '续件运费',
                                       `is_default` tinyint(4) DEFAULT '0' COMMENT '是否默认运费0否1是',
                                       `transport_id` int(11) NOT NULL COMMENT '运费模板id',
                                       PRIMARY KEY (`id`),
                                       tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_type_ware_transport`;

CREATE TABLE `shop_type_ware_transport` (
                                          `id` int(11) NOT NULL AUTO_INCREMENT,
                                          `belong_id` int(11) NOT NULL COMMENT '所属对象id',
                                          `type` int(11) DEFAULT '0' COMMENT '类型0商品，1分类',
                                          `transport_id` int(11) DEFAULT NULL COMMENT '运费模版id(flag=1时不能为空)',
                                          `flag` int(11) DEFAULT '0' COMMENT '类型0本地，1运费模版',
                                          PRIMARY KEY (`id`),
                                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_ware_favorite`;

CREATE TABLE `shop_ware_favorite` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `hy_id` int(11) NOT NULL COMMENT '企业会员ID',
                                    `mem_id` int(11) DEFAULT NULL COMMENT '平台会员ID',
                                    `ware_id` int(11) NOT NULL COMMENT '商品id',
                                    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_ware_group`;

CREATE TABLE `shop_ware_group` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `name` varchar(50) DEFAULT NULL,
                                 `path` varchar(100) DEFAULT NULL,
                                 `pic` varchar(100) DEFAULT NULL,
                                 `status` varchar(10) DEFAULT NULL,
                                 `remark` varchar(200) DEFAULT NULL,
                                 `sort` int(11) DEFAULT NULL COMMENT '排序越大越前',
                                 `group_style_id` int(11) DEFAULT '1' COMMENT '首页模块ID',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_ware_stock`;

CREATE TABLE `shop_ware_stock` (
                                 `ware_id` int(11) NOT NULL COMMENT '商品ID',
                                 `update_date` datetime DEFAULT NULL COMMENT '最后一次修改时间',
                                 `max_storage` double(10, 2) DEFAULT NULL COMMENT '大单位库存数量',
                                 `max_open` int(11) DEFAULT '1' COMMENT '大单位是否开启库存功能0否1是',
                                 `min_storage` double(10, 2) DEFAULT NULL COMMENT '小单位库存数量',
                                 `min_open` int(11) DEFAULT '1' COMMENT '小单位是否开启库存功能0否1是',
                                 `storage_type` int(11) DEFAULT '1' COMMENT '库存类型0进销存控制,1商城独自控制',
                                 PRIMARY KEY (`ware_id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `shop_ware_transport`;

CREATE TABLE `shop_ware_transport` (
                                     `id` int(11) NOT NULL AUTO_INCREMENT,
                                     `ware_id` int(11) NOT NULL COMMENT '所属对象商品id',
                                     `transport_id` int(11) NOT NULL COMMENT '具体的运费模版0包邮,否则为同城或城际的运费模版id',
                                     PRIMARY KEY (`id`),
                                     tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_car_rec_mast`;

CREATE TABLE `stk_car_rec_mast` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `sum_amt` decimal(10, 2) DEFAULT NULL,
                                  `remarks` varchar(100) DEFAULT NULL,
                                  `create_id` int(11) DEFAULT NULL,
                                  `rec_time` datetime DEFAULT NULL,
                                  `status` int(11) DEFAULT NULL,
                                  `bill_type` int(11) DEFAULT NULL,
                                  `bill_no` varchar(50) DEFAULT NULL,
                                  `pro_id` int(11) DEFAULT NULL,
                                  `pro_type` int(11) DEFAULT NULL,
                                  `pro_name` varchar(50) DEFAULT NULL,
                                  `emp_id` int(11) DEFAULT NULL,
                                  `staff` varchar(50) DEFAULT NULL,
                                  `stk_id` int(11) DEFAULT NULL,
                                  `stk_nm` varchar(50) DEFAULT NULL,
                                  `order_id` int(11) DEFAULT NULL,
                                  `order_no` varchar(50) DEFAULT NULL,
                                  `order_time` datetime DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_check`;

CREATE TABLE `stk_check` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                           `check_time` datetime DEFAULT NULL,
                           `stk_id` int(11) DEFAULT NULL,
                           `staff` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                           `new_time` datetime DEFAULT NULL,
                           `remarks` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                           `total_amt` decimal(10, 2) DEFAULT NULL,
                           `status` int(11) DEFAULT NULL,
                           `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                           `submit_user` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
                           `submit_time` datetime DEFAULT NULL,
                           `cancel_time` datetime DEFAULT NULL,
                           `cancel_user` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
                           `type` int(11) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_checksub`;

CREATE TABLE `stk_checksub` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `mast_id` int(11) DEFAULT NULL,
                              `ware_id` int(11) DEFAULT NULL,
                              `qty` decimal(16, 10) DEFAULT NULL,
                              `price` decimal(13, 5) DEFAULT NULL,
                              `amt` decimal(13, 2) DEFAULT NULL,
                              `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `dis_qty` decimal(16, 10) DEFAULT NULL,
                              `stk_qty` decimal(16, 10) DEFAULT NULL,
                              `min_qty` decimal(16, 10) DEFAULT NULL,
                              `min_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                              `produce_date` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `sunit_price` decimal(13, 5) DEFAULT NULL,
                              `price_flag` int(11) DEFAULT NULL,
                              `max_qty_flag` int(11) DEFAULT NULL,
                              `min_qty_flag` int(11) DEFAULT NULL,
                              `max_amt` decimal(13, 2) DEFAULT NULL,
                              `min_amt` decimal(13, 2) DEFAULT NULL,
                              `zm_price` decimal(13, 2) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_collar_item`;

CREATE TABLE `stk_collar_item` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `mast_id` int(11) DEFAULT NULL,
                                 `ware_id` int(11) DEFAULT NULL,
                                 `qty` decimal(10, 2) DEFAULT NULL,
                                 `price` decimal(10, 2) DEFAULT NULL,
                                 `amt` decimal(10, 2) DEFAULT NULL,
                                 `unit_name` varchar(50) DEFAULT NULL,
                                 `in_qty` decimal(10, 2) DEFAULT NULL,
                                 `in_amt` decimal(10, 2) DEFAULT NULL,
                                 `be_unit` varchar(20) DEFAULT NULL,
                                 `product_date` varchar(50) DEFAULT NULL,
                                 `source_main_id` int(11) DEFAULT NULL,
                                 `source_main_no` varchar(50) DEFAULT NULL,
                                 `source_item_id` int(11) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_come`;

CREATE TABLE `stk_come` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `bill_no` varchar(50) DEFAULT NULL,
                          `pro_id` int(11) DEFAULT NULL,
                          `mid` int(11) DEFAULT NULL,
                          `come_time` datetime DEFAULT NULL,
                          `stk_id` int(11) DEFAULT NULL,
                          `in_type` varchar(50) DEFAULT NULL,
                          `remarks` varchar(100) DEFAULT NULL,
                          `submit_user` varchar(50) DEFAULT NULL,
                          `submit_time` datetime DEFAULT NULL,
                          `cancel_user` varchar(50) DEFAULT NULL,
                          `cancel_time` datetime DEFAULT NULL,
                          `operator` varchar(20) DEFAULT NULL,
                          `status` int(11) DEFAULT NULL,
                          `pro_name` varchar(50) DEFAULT NULL,
                          `pro_type` int(11) DEFAULT NULL,
                          `new_time` datetime DEFAULT NULL,
                          `in_id` int(11) DEFAULT NULL,
                          `voucher_no` varchar(50) DEFAULT NULL,
                          `veh_id` int(11) DEFAULT NULL,
                          `driver_id` int(11) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_comesub`;

CREATE TABLE `stk_comesub` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `mast_id` int(11) DEFAULT NULL,
                             `ware_id` int(11) DEFAULT NULL,
                             `qty` decimal(13, 5) DEFAULT NULL,
                             `price` decimal(13, 5) DEFAULT NULL,
                             `amt` decimal(13, 5) DEFAULT NULL,
                             `unit_name` varchar(50) DEFAULT NULL,
                             `in_qty` decimal(13, 5) DEFAULT NULL,
                             `in_amt` decimal(13, 5) DEFAULT NULL,
                             `be_unit` varchar(20) DEFAULT NULL,
                             `product_date` varchar(50) DEFAULT NULL,
                             `in_type_code` varchar(50) DEFAULT NULL,
                             `in_type_name` varchar(50) DEFAULT NULL,
                             `sub_id` int(11) DEFAULT NULL,
                             `rebate_Price` decimal(10, 5) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_customer_ware_group`;

CREATE TABLE `stk_customer_ware_group` (
                                         `id` int(11) NOT NULL AUTO_INCREMENT,
                                         `name` varchar(50) DEFAULT NULL,
                                         `asn` varchar(100) DEFAULT NULL,
                                         `status` varchar(10) DEFAULT NULL,
                                         `customer_id` int(11) DEFAULT NULL,
                                         PRIMARY KEY (`id`),
                                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_customer_ware_items`;

CREATE TABLE `stk_customer_ware_items` (
                                         `id` int(11) NOT NULL AUTO_INCREMENT,
                                         `group_id` int(11) DEFAULT NULL,
                                         `ware_id` int(11) DEFAULT NULL,
                                         `customer_id` int(11) DEFAULT NULL,
                                         `status` varchar(10) DEFAULT NULL,
                                         PRIMARY KEY (`id`),
                                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_delivery`;

CREATE TABLE `stk_delivery` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `order_id` int(11) DEFAULT NULL,
                              `bill_no` varchar(50) DEFAULT NULL,
                              `cst_id` int(11) DEFAULT NULL,
                              `shr` varchar(50) DEFAULT NULL,
                              `tel` varchar(50) DEFAULT NULL,
                              `address` varchar(100) DEFAULT NULL,
                              `mid` int(11) DEFAULT NULL,
                              `out_time` datetime DEFAULT NULL,
                              `pszd` varchar(50) DEFAULT NULL,
                              `remarks` varchar(500) DEFAULT NULL,
                              `out_type` varchar(50) DEFAULT NULL,
                              `stk_id` int(11) DEFAULT NULL,
                              `submit_user` varchar(50) DEFAULT NULL,
                              `submit_time` datetime DEFAULT NULL,
                              `cancel_user` varchar(50) DEFAULT NULL,
                              `cancel_time` datetime DEFAULT NULL,
                              `total_amt` decimal(11, 2) DEFAULT NULL,
                              `rec_amt` decimal(11, 2) DEFAULT NULL,
                              `discount` decimal(11, 2) DEFAULT NULL,
                              `dis_amt` decimal(11, 2) DEFAULT NULL,
                              `operator` varchar(50) DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              `free_amt` decimal(11, 2) DEFAULT NULL,
                              `kh_nm` varchar(50) DEFAULT NULL,
                              `pro_type` int(11) DEFAULT NULL,
                              `dis_amt1` decimal(11, 2) DEFAULT NULL,
                              `staff` varchar(50) DEFAULT NULL,
                              `staff_tel` varchar(50) DEFAULT NULL,
                              `new_time` datetime DEFAULT NULL,
                              `ep_customer_id` varchar(50) DEFAULT NULL,
                              `ep_customer_name` varchar(50) DEFAULT NULL,
                              `emp_id` int(11) DEFAULT NULL,
                              `create_time` datetime DEFAULT NULL,
                              `send_time` datetime DEFAULT NULL,
                              `veh_id` int(11) DEFAULT NULL,
                              `driver_id` int(11) DEFAULT NULL,
                              `reaudit_desc` varchar(500) DEFAULT NULL,
                              `sale_type` varchar(10) DEFAULT '001',
                              `out_id` int(11) DEFAULT NULL,
                              `out_no` varchar(30) DEFAULT NULL,
                              `ps_state` int(2) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              KEY `order_id` (`order_id`),
                              KEY `index_name` (`bill_no`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_deliverysub`;

CREATE TABLE `stk_deliverysub` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `mast_id` int(11) DEFAULT NULL,
                                 `ware_id` int(11) DEFAULT NULL,
                                 `qty` decimal(13, 5) DEFAULT NULL,
                                 `price` decimal(13, 5) DEFAULT NULL,
                                 `amt` decimal(11, 2) DEFAULT NULL,
                                 `unit_name` varchar(50) DEFAULT NULL,
                                 `xs_tp` varchar(50) DEFAULT NULL,
                                 `out_qty` decimal(13, 5) DEFAULT NULL,
                                 `out_amt` decimal(11, 2) DEFAULT NULL,
                                 `product_date` varchar(50) DEFAULT NULL,
                                 `active_date` varchar(50) DEFAULT NULL,
                                 `remarks` varchar(50) DEFAULT NULL,
                                 `be_unit` varchar(20) DEFAULT NULL,
                                 `ssw_id` varchar(50) DEFAULT NULL,
                                 `rebate_Price` decimal(10, 5) DEFAULT NULL,
                                 `help_qty` decimal(13, 5) DEFAULT NULL,
                                 `help_unit` varchar(10) DEFAULT NULL,
                                 `out_id` int(11) DEFAULT NULL,
                                 `status` int(2) DEFAULT NULL,
                                 `out_sub_id` int(11) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 KEY `mast_id` (`mast_id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_dict`;

CREATE TABLE `stk_dict` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `type_name` varchar(255) DEFAULT NULL,
                          `io_type` int(11) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_driver`;

CREATE TABLE `stk_driver` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `driver_name` varchar(50) DEFAULT NULL,
                            `tel` varchar(50) DEFAULT NULL,
                            `status` int(11) DEFAULT NULL,
                            `member_id` int(11) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_emp_ware`;

CREATE TABLE `stk_emp_ware` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `user_id` int(11) DEFAULT NULL,
                              `ware_id` int(11) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_extras_carry_over`;

CREATE TABLE `stk_extras_carry_over` (
                                       `id` int(11) NOT NULL AUTO_INCREMENT,
                                       `bill_no` varchar(50) DEFAULT NULL,
                                       `bill_date` datetime DEFAULT NULL,
                                       `pro_id` int(11) DEFAULT NULL,
                                       `fee_amt` decimal(10, 2) DEFAULT NULL,
                                       `status` int(11) DEFAULT NULL,
                                       `submit_user` varchar(50) DEFAULT NULL,
                                       `submit_time` datetime DEFAULT NULL,
                                       `create_id` varchar(50) DEFAULT NULL,
                                       `remarks` varchar(500) DEFAULT NULL,
                                       `pro_type` int(11) DEFAULT NULL,
                                       `pro_name` varchar(50) DEFAULT NULL,
                                       `new_time` datetime DEFAULT NULL,
                                       `dis_Amt` decimal(10, 0) DEFAULT NULL,
                                       `source_Bill_Id` int(11) DEFAULT NULL,
                                       `source_Bill_No` varchar(50) DEFAULT NULL,
                                       `in_date` datetime DEFAULT NULL,
                                       `in_type` varchar(10) DEFAULT NULL,
                                       PRIMARY KEY (`id`),
                                       tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_extras_carry_over_sub`;

CREATE TABLE `stk_extras_carry_over_sub` (
                                           `id` int(11) NOT NULL AUTO_INCREMENT,
                                           `mast_id` int(11) DEFAULT NULL,
                                           `ware_id` int(11) DEFAULT NULL,
                                           `qty` decimal(13, 5) DEFAULT NULL,
                                           `price` decimal(13, 5) DEFAULT NULL,
                                           `amt` decimal(11, 2) DEFAULT NULL,
                                           `unit_name` varchar(50) DEFAULT NULL,
                                           `be_unit` varchar(20) DEFAULT NULL,
                                           `rebate_Price` decimal(10, 5) DEFAULT NULL,
                                           `remarks` varchar(200) DEFAULT NULL,
                                           `fee_amt` decimal(11, 2) DEFAULT NULL,
                                           `cost_price` decimal(16, 10) DEFAULT NULL,
                                           `source_bill_id` int(11) DEFAULT NULL,
                                           `source_bill_no` varchar(50) DEFAULT NULL,
                                           `sub_id` int(11) DEFAULT NULL,
                                           `status` int(11) DEFAULT NULL,
                                           `total_amt` decimal(13, 5) DEFAULT NULL,
                                           PRIMARY KEY (`id`),
                                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_extras_fee`;

CREATE TABLE `stk_extras_fee` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `bill_no` varchar(50) DEFAULT NULL,
                                `bill_date` datetime DEFAULT NULL,
                                `pro_id` int(11) DEFAULT NULL,
                                `total_amt` decimal(10, 2) DEFAULT NULL,
                                `status` int(11) DEFAULT NULL,
                                `submit_user` varchar(50) DEFAULT NULL,
                                `submit_time` datetime DEFAULT NULL,
                                `create_id` varchar(50) DEFAULT NULL,
                                `remarks` varchar(500) DEFAULT NULL,
                                `pro_type` int(11) DEFAULT NULL,
                                `pro_name` varchar(50) DEFAULT NULL,
                                `new_time` datetime DEFAULT NULL,
                                `pay_amt` decimal(13, 2) DEFAULT '0.00',
                                `free_amt` decimal(13, 2) DEFAULT '0.00',
                                `biz_type` varchar(10) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_extras_fee_sub`;

CREATE TABLE `stk_extras_fee_sub` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `mast_id` int(11) DEFAULT NULL,
                                    `cost_id` varchar(50) DEFAULT NULL,
                                    `amt` decimal(10, 2) DEFAULT NULL,
                                    `remarks` varchar(400) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_in`;

CREATE TABLE `stk_in` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                        `pro_id` int(11) DEFAULT NULL,
                        `mid` int(11) DEFAULT NULL,
                        `in_time` datetime DEFAULT NULL,
                        `stk_id` int(11) DEFAULT NULL,
                        `in_type` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                        `remarks` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                        `submit_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                        `submit_time` datetime DEFAULT NULL,
                        `cancel_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                        `cancel_time` datetime DEFAULT NULL,
                        `total_amt` decimal(11, 2) DEFAULT NULL,
                        `pay_amt` decimal(11, 2) DEFAULT NULL,
                        `discount` decimal(11, 2) DEFAULT NULL,
                        `dis_amt` decimal(11, 2) DEFAULT NULL,
                        `operator` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                        `status` int(11) DEFAULT NULL,
                        `free_amt` decimal(11, 2) DEFAULT NULL,
                        `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                        `pro_type` int(11) DEFAULT NULL,
                        `dis_amt1` decimal(11, 2) DEFAULT NULL,
                        `new_time` datetime DEFAULT NULL,
                        `order_id` int(11) DEFAULT NULL,
                        `order_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                        `emp_id` int(11) DEFAULT NULL,
                        `emp_nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                        `veh_id` int(11) DEFAULT NULL,
                        `driver_id` int(11) DEFAULT NULL,
                        `reaudit_desc` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
                        `sure_time` datetime DEFAULT NULL,
                        `open_zfjz` int(11) DEFAULT '0',
                        PRIMARY KEY (`id`),
                        tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_insub`;

CREATE TABLE `stk_insub` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `mast_id` int(11) DEFAULT NULL,
                           `ware_id` int(11) DEFAULT NULL,
                           `qty` decimal(13, 5) DEFAULT NULL,
                           `price` decimal(13, 5) DEFAULT NULL,
                           `amt` decimal(11, 2) DEFAULT NULL,
                           `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                           `in_qty` decimal(13, 5) DEFAULT NULL,
                           `in_amt` decimal(11, 2) DEFAULT NULL,
                           `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                           `product_date` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                           `in_type_code` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                           `in_type_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                           `rebate_Price` decimal(10, 5) DEFAULT NULL,
                           `pickup_sub_Ids` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
                           `remarks` varchar(200) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_insub_version`;

CREATE TABLE `stk_insub_version` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `mast_id` int(11) DEFAULT NULL,
                                   `ware_id` int(11) DEFAULT NULL,
                                   `qty` decimal(13, 5) DEFAULT NULL,
                                   `price` decimal(13, 5) DEFAULT NULL,
                                   `amt` decimal(11, 2) DEFAULT NULL,
                                   `unit_name` varchar(50) DEFAULT NULL,
                                   `in_qty` decimal(13, 5) DEFAULT NULL,
                                   `in_amt` decimal(11, 2) DEFAULT NULL,
                                   `be_unit` varchar(20) DEFAULT NULL,
                                   `product_date` varchar(50) DEFAULT NULL,
                                   `in_type_code` varchar(50) DEFAULT NULL,
                                   `in_type_name` varchar(50) DEFAULT NULL,
                                   `rebate_price` decimal(10, 5) DEFAULT NULL,
                                   `pickup_sub_ids` varchar(500) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_in_version`;

CREATE TABLE `stk_in_version` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `bill_no` varchar(50) DEFAULT NULL,
                                `pro_id` int(11) DEFAULT NULL,
                                `mid` int(11) DEFAULT NULL,
                                `in_time` datetime DEFAULT NULL,
                                `stk_id` int(11) DEFAULT NULL,
                                `in_type` varchar(50) DEFAULT NULL,
                                `remarks` varchar(100) DEFAULT NULL,
                                `submit_user` varchar(50) DEFAULT NULL,
                                `submit_time` datetime DEFAULT NULL,
                                `cancel_user` varchar(50) DEFAULT NULL,
                                `cancel_time` datetime DEFAULT NULL,
                                `total_amt` decimal(11, 2) DEFAULT NULL,
                                `pay_amt` decimal(11, 2) DEFAULT NULL,
                                `discount` decimal(11, 2) DEFAULT NULL,
                                `dis_amt` decimal(11, 2) DEFAULT NULL,
                                `operator` varchar(20) DEFAULT NULL,
                                `status` int(11) DEFAULT NULL,
                                `free_amt` decimal(11, 2) DEFAULT NULL,
                                `pro_name` varchar(50) DEFAULT NULL,
                                `pro_type` int(11) DEFAULT NULL,
                                `dis_amt1` decimal(11, 2) DEFAULT NULL,
                                `new_time` datetime DEFAULT NULL,
                                `order_id` int(11) DEFAULT NULL,
                                `order_no` varchar(50) DEFAULT NULL,
                                `emp_id` int(11) DEFAULT NULL,
                                `emp_nm` varchar(50) DEFAULT NULL,
                                `veh_id` int(11) DEFAULT NULL,
                                `driver_id` int(11) DEFAULT NULL,
                                `reaudit_desc` varchar(500) DEFAULT NULL,
                                `sure_time` datetime DEFAULT NULL,
                                `rela_id` int(11) DEFAULT NULL,
                                `rela_time` varchar(30) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_llhk_come`;

CREATE TABLE `stk_llhk_come` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `bill_no` varchar(50) DEFAULT NULL,
                               `pro_id` int(11) DEFAULT NULL,
                               `mid` int(11) DEFAULT NULL,
                               `come_time` datetime DEFAULT NULL,
                               `stk_id` int(11) DEFAULT NULL,
                               `in_type` varchar(50) DEFAULT NULL,
                               `remarks` varchar(100) DEFAULT NULL,
                               `submit_user` varchar(50) DEFAULT NULL,
                               `submit_time` datetime DEFAULT NULL,
                               `cancel_user` varchar(50) DEFAULT NULL,
                               `cancel_time` datetime DEFAULT NULL,
                               `operator` varchar(20) DEFAULT NULL,
                               `status` int(11) DEFAULT NULL,
                               `pro_name` varchar(50) DEFAULT NULL,
                               `pro_type` int(11) DEFAULT NULL,
                               `new_time` datetime DEFAULT NULL,
                               `in_id` int(11) DEFAULT NULL,
                               `voucher_no` varchar(50) DEFAULT NULL,
                               `veh_id` int(11) DEFAULT NULL,
                               `driver_id` int(11) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_llhk_comesub`;

CREATE TABLE `stk_llhk_comesub` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `mast_id` int(11) DEFAULT NULL,
                                  `ware_id` int(11) DEFAULT NULL,
                                  `qty` decimal(13, 5) DEFAULT NULL,
                                  `price` decimal(13, 5) DEFAULT NULL,
                                  `amt` decimal(11, 2) DEFAULT NULL,
                                  `unit_name` varchar(50) DEFAULT NULL,
                                  `in_qty` decimal(13, 5) DEFAULT NULL,
                                  `in_amt` decimal(11, 2) DEFAULT NULL,
                                  `be_unit` varchar(20) DEFAULT NULL,
                                  `product_date` varchar(50) DEFAULT NULL,
                                  `in_type_code` varchar(50) DEFAULT NULL,
                                  `in_type_name` varchar(50) DEFAULT NULL,
                                  `sub_id` int(11) DEFAULT NULL,
                                  `rebate_Price` decimal(10, 5) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_llhk_in`;

CREATE TABLE `stk_llhk_in` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bill_no` varchar(50) DEFAULT NULL,
                             `pro_id` int(11) DEFAULT NULL,
                             `mid` int(11) DEFAULT NULL,
                             `in_time` datetime DEFAULT NULL,
                             `stk_id` int(11) DEFAULT NULL,
                             `in_type` varchar(50) DEFAULT NULL,
                             `remarks` varchar(100) DEFAULT NULL,
                             `submit_user` varchar(50) DEFAULT NULL,
                             `submit_time` datetime DEFAULT NULL,
                             `cancel_user` varchar(50) DEFAULT NULL,
                             `cancel_time` datetime DEFAULT NULL,
                             `total_amt` decimal(11, 2) DEFAULT NULL,
                             `pay_amt` decimal(11, 2) DEFAULT NULL,
                             `discount` decimal(11, 2) DEFAULT NULL,
                             `dis_amt` decimal(11, 2) DEFAULT NULL,
                             `operator` varchar(20) DEFAULT NULL,
                             `status` int(11) DEFAULT NULL,
                             `free_amt` decimal(11, 2) DEFAULT NULL,
                             `pro_name` varchar(50) DEFAULT NULL,
                             `pro_type` int(11) DEFAULT NULL,
                             `dis_amt1` decimal(11, 2) DEFAULT NULL,
                             `new_time` datetime DEFAULT NULL,
                             `order_id` int(11) DEFAULT NULL,
                             `order_no` varchar(50) DEFAULT NULL,
                             `emp_id` int(11) DEFAULT NULL,
                             `emp_nm` varchar(50) DEFAULT NULL,
                             `veh_id` int(11) DEFAULT NULL,
                             `driver_id` int(11) DEFAULT NULL,
                             `reaudit_desc` varchar(500) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `index_name` (`bill_no`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_llhk_insub`;

CREATE TABLE `stk_llhk_insub` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `mast_id` int(11) DEFAULT NULL,
                                `ware_id` int(11) DEFAULT NULL,
                                `qty` decimal(13, 5) DEFAULT NULL,
                                `price` decimal(13, 5) DEFAULT NULL,
                                `amt` decimal(11, 2) DEFAULT NULL,
                                `unit_name` varchar(50) DEFAULT NULL,
                                `in_qty` decimal(13, 5) DEFAULT NULL,
                                `in_amt` decimal(11, 2) DEFAULT NULL,
                                `be_unit` varchar(20) DEFAULT NULL,
                                `product_date` varchar(50) DEFAULT NULL,
                                `in_type_code` varchar(50) DEFAULT NULL,
                                `in_type_name` varchar(50) DEFAULT NULL,
                                `rebate_Price` decimal(10, 5) DEFAULT NULL,
                                `pickup_sub_Ids` varchar(500) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_month_proc`;

CREATE TABLE `stk_month_proc` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `yymm` varchar(10) DEFAULT NULL,
                                `proc_date` datetime DEFAULT NULL,
                                `operator` varchar(50) DEFAULT NULL,
                                `status` int(11) DEFAULT NULL,
                                `start_date` varchar(20) DEFAULT NULL,
                                `end_date` varchar(20) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_month_set`;

CREATE TABLE `stk_month_set` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `yymm` varchar(20) DEFAULT NULL,
                               `start_date` varchar(20) DEFAULT NULL,
                               `end_date` varchar(20) DEFAULT NULL,
                               `year` int(11) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_move`;

CREATE TABLE `stk_move` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `pro_id` int(11) DEFAULT NULL,
                          `mid` int(11) DEFAULT NULL,
                          `in_time` datetime DEFAULT NULL,
                          `stk_id` int(11) DEFAULT NULL,
                          `stk_in_id` int(11) DEFAULT NULL,
                          `biz_type` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `remarks` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                          `submit_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `submit_time` datetime DEFAULT NULL,
                          `cancel_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `cancel_time` datetime DEFAULT NULL,
                          `total_amt` decimal(10, 2) DEFAULT NULL,
                          `discount` decimal(10, 2) DEFAULT NULL,
                          `dis_amt` decimal(10, 2) DEFAULT NULL,
                          `operator` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                          `status` int(11) DEFAULT NULL,
                          `free_amt` decimal(10, 2) DEFAULT NULL,
                          `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `pro_type` int(11) DEFAULT NULL,
                          `dis_amt1` decimal(10, 0) DEFAULT NULL,
                          `new_time` datetime DEFAULT NULL,
                          `bill_type` int(11) DEFAULT '0',
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_movesub`;

CREATE TABLE `stk_movesub` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `mast_id` int(11) DEFAULT NULL,
                             `ware_id` int(11) DEFAULT NULL,
                             `qty` decimal(16, 10) DEFAULT NULL,
                             `price` decimal(13, 5) DEFAULT NULL,
                             `amt` decimal(10, 2) DEFAULT NULL,
                             `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `in_qty` decimal(16, 10) DEFAULT NULL,
                             `in_amt` decimal(10, 2) DEFAULT NULL,
                             `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_move_io`;

CREATE TABLE `stk_move_io` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bill_no` varchar(50) DEFAULT NULL,
                             `pro_id` int(11) DEFAULT NULL,
                             `move_time` datetime DEFAULT NULL,
                             `stk_id` int(11) DEFAULT NULL,
                             `biz_type` varchar(50) DEFAULT NULL,
                             `remarks` varchar(100) DEFAULT NULL,
                             `submit_user` varchar(50) DEFAULT NULL,
                             `submit_time` datetime DEFAULT NULL,
                             `cancel_user` varchar(50) DEFAULT NULL,
                             `cancel_time` datetime DEFAULT NULL,
                             `operator` varchar(20) DEFAULT NULL,
                             `status` int(11) DEFAULT NULL,
                             `pro_name` varchar(50) DEFAULT NULL,
                             `pro_type` int(11) DEFAULT NULL,
                             `new_time` datetime DEFAULT NULL,
                             `move_id` int(11) DEFAULT NULL,
                             `io_mark` int(11) DEFAULT NULL,
                             `voucher_no` varchar(50) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_move_io_sub`;

CREATE TABLE `stk_move_io_sub` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `mast_id` int(11) DEFAULT NULL,
                                 `ware_id` int(11) DEFAULT NULL,
                                 `qty` decimal(16, 10) DEFAULT NULL,
                                 `price` decimal(13, 5) DEFAULT NULL,
                                 `amt` decimal(10, 2) DEFAULT NULL,
                                 `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                 `be_qty` decimal(16, 10) DEFAULT NULL,
                                 `be_amt` decimal(10, 2) DEFAULT NULL,
                                 `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                                 `io_mark` int(11) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_out`;

CREATE TABLE `stk_out` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `order_id` int(11) DEFAULT NULL,
                         `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `cst_id` int(11) DEFAULT NULL,
                         `shr` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `tel` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `address` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                         `mid` int(11) DEFAULT NULL,
                         `out_time` datetime DEFAULT NULL,
                         `pszd` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `remarks` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
                         `out_type` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `stk_id` int(11) DEFAULT NULL,
                         `submit_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `submit_time` datetime DEFAULT NULL,
                         `cancel_user` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `cancel_time` datetime DEFAULT NULL,
                         `total_amt` decimal(11, 2) DEFAULT NULL,
                         `rec_amt` decimal(11, 2) DEFAULT NULL,
                         `discount` decimal(11, 2) DEFAULT NULL,
                         `dis_amt` decimal(11, 2) DEFAULT NULL,
                         `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `status` int(11) DEFAULT NULL,
                         `free_amt` decimal(11, 2) DEFAULT NULL,
                         `kh_nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `pro_type` int(11) DEFAULT NULL,
                         `dis_amt1` decimal(11, 2) DEFAULT NULL,
                         `staff` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `staff_tel` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `new_time` datetime DEFAULT NULL,
                         `ep_customer_id` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `ep_customer_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `emp_id` int(11) DEFAULT NULL,
                         `create_time` datetime DEFAULT NULL,
                         `send_time` datetime DEFAULT NULL,
                         `veh_id` int(11) DEFAULT NULL,
                         `driver_id` int(11) DEFAULT NULL,
                         `reaudit_desc` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
                         `sale_type` varchar(10) CHARACTER SET utf8 DEFAULT '001',
                         `price_flag` int(11) DEFAULT NULL,
                         `transport_name` varchar(50) DEFAULT NULL,
                         `transport_code` varchar(50) DEFAULT NULL,
                         `order_lb` varchar(10) DEFAULT NULL,
                         PRIMARY KEY (`id`),
                         KEY `stk_out_index_01` (`out_time`),
                         KEY `stk_out_index_02` (`bill_no`),
                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_outsub`;

CREATE TABLE `stk_outsub` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `mast_id` int(11) DEFAULT NULL,
                            `ware_id` int(11) DEFAULT NULL,
                            `qty` decimal(13, 5) DEFAULT NULL,
                            `price` decimal(13, 5) DEFAULT NULL,
                            `amt` decimal(11, 2) DEFAULT NULL,
                            `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `xs_tp` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `out_qty` decimal(13, 5) DEFAULT NULL,
                            `out_amt` decimal(11, 2) DEFAULT NULL,
                            `product_date` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `active_date` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `remarks` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
                            `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                            `ssw_id` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `rebate_Price` decimal(10, 5) DEFAULT NULL,
                            `help_qty` decimal(13, 5) DEFAULT NULL,
                            `help_unit` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                            `check_ware` int(11) DEFAULT '0',
                            `price_flag` int(11) DEFAULT NULL,
                            `org_price` decimal(13, 5) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            KEY `stk_outsub_index_02` (`ware_id`),
                            KEY `stk_outsub_index_01` (`mast_id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_outsub_version`;

CREATE TABLE `stk_outsub_version` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `mast_id` int(11) DEFAULT NULL,
                                    `ware_id` int(11) DEFAULT NULL,
                                    `qty` decimal(13, 5) DEFAULT NULL,
                                    `price` decimal(13, 5) DEFAULT NULL,
                                    `amt` decimal(11, 2) DEFAULT NULL,
                                    `unit_name` varchar(50) DEFAULT NULL,
                                    `xs_tp` varchar(50) DEFAULT NULL,
                                    `out_qty` decimal(13, 5) DEFAULT NULL,
                                    `out_amt` decimal(11, 2) DEFAULT NULL,
                                    `product_date` varchar(50) DEFAULT NULL,
                                    `active_date` varchar(50) DEFAULT NULL,
                                    `remarks` varchar(50) DEFAULT NULL,
                                    `be_unit` varchar(20) DEFAULT NULL,
                                    `ssw_id` varchar(50) DEFAULT NULL,
                                    `rebate_price` decimal(10, 5) DEFAULT NULL,
                                    `help_qty` decimal(13, 5) DEFAULT NULL,
                                    `help_unit` varchar(10) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_out_version`;

CREATE TABLE `stk_out_version` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `order_id` int(11) DEFAULT NULL,
                                 `bill_no` varchar(50) DEFAULT NULL,
                                 `cst_id` int(11) DEFAULT NULL,
                                 `shr` varchar(50) DEFAULT NULL,
                                 `tel` varchar(50) DEFAULT NULL,
                                 `address` varchar(100) DEFAULT NULL,
                                 `mid` int(11) DEFAULT NULL,
                                 `out_time` datetime DEFAULT NULL,
                                 `pszd` varchar(50) DEFAULT NULL,
                                 `remarks` varchar(500) DEFAULT NULL,
                                 `out_type` varchar(50) DEFAULT NULL,
                                 `stk_id` int(11) DEFAULT NULL,
                                 `submit_user` varchar(50) DEFAULT NULL,
                                 `submit_time` datetime DEFAULT NULL,
                                 `cancel_user` varchar(50) DEFAULT NULL,
                                 `cancel_time` datetime DEFAULT NULL,
                                 `total_amt` decimal(11, 2) DEFAULT NULL,
                                 `rec_amt` decimal(11, 2) DEFAULT NULL,
                                 `discount` decimal(11, 2) DEFAULT NULL,
                                 `dis_amt` decimal(11, 2) DEFAULT NULL,
                                 `operator` varchar(50) DEFAULT NULL,
                                 `status` int(11) DEFAULT NULL,
                                 `free_amt` decimal(11, 2) DEFAULT NULL,
                                 `kh_nm` varchar(50) DEFAULT NULL,
                                 `pro_type` int(11) DEFAULT NULL,
                                 `dis_amt1` decimal(11, 2) DEFAULT NULL,
                                 `staff` varchar(50) DEFAULT NULL,
                                 `staff_tel` varchar(50) DEFAULT NULL,
                                 `new_time` datetime DEFAULT NULL,
                                 `ep_customer_id` varchar(50) DEFAULT NULL,
                                 `ep_customer_name` varchar(50) DEFAULT NULL,
                                 `emp_id` int(11) DEFAULT NULL,
                                 `create_time` datetime DEFAULT NULL,
                                 `send_time` datetime DEFAULT NULL,
                                 `veh_id` int(11) DEFAULT NULL,
                                 `driver_id` int(11) DEFAULT NULL,
                                 `reaudit_desc` varchar(500) DEFAULT NULL,
                                 `sale_type` varchar(10) DEFAULT '001',
                                 `rela_id` int(11) DEFAULT NULL,
                                 `rela_time` varchar(30) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_params`;

CREATE TABLE `stk_params` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `param_name` varchar(50) DEFAULT NULL,
                            `param_value` varchar(1000) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_payment`;

CREATE TABLE `stk_payment` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `pay_amt` decimal(10, 2) DEFAULT NULL,
                             `pay_type` varchar(50) DEFAULT NULL,
                             `mast_id` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_pay_mast`;

CREATE TABLE `stk_pay_mast` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `pro_id` int(11) DEFAULT NULL,
                              `sum_amt` decimal(10, 2) DEFAULT NULL,
                              `remarks` varchar(100) DEFAULT NULL,
                              `mid` int(11) DEFAULT NULL,
                              `pay_time` datetime DEFAULT NULL,
                              `bill_id` int(11) DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              `cash` decimal(10, 2) DEFAULT NULL,
                              `bank` decimal(10, 2) DEFAULT NULL,
                              `wx` decimal(10, 2) DEFAULT NULL,
                              `zfb` decimal(10, 2) DEFAULT NULL,
                              `bill_type` int(11) DEFAULT NULL,
                              `bill_no` varchar(50) DEFAULT NULL,
                              `cost_Id` int(11) DEFAULT NULL,
                              `pro_type` int(11) DEFAULT NULL,
                              `pro_name` varchar(50) DEFAULT NULL,
                              `source_bill_no` varchar(50) DEFAULT NULL,
                              `pre_no` varchar(50) DEFAULT NULL,
                              `pre_id` int(11) DEFAULT NULL,
                              `pre_amt` decimal(10, 2) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_pickup`;

CREATE TABLE `stk_pickup` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `bill_no` varchar(50) DEFAULT NULL,
                            `pro_id` int(11) DEFAULT NULL,
                            `mid` int(11) DEFAULT NULL,
                            `in_time` datetime DEFAULT NULL,
                            `stk_id` int(11) DEFAULT NULL,
                            `stk_in_id` int(11) DEFAULT NULL,
                            `biz_type` varchar(50) DEFAULT NULL,
                            `remarks` varchar(100) DEFAULT NULL,
                            `submit_user` varchar(50) DEFAULT NULL,
                            `submit_time` datetime DEFAULT NULL,
                            `cancel_user` varchar(50) DEFAULT NULL,
                            `cancel_time` datetime DEFAULT NULL,
                            `total_amt` decimal(10, 2) DEFAULT NULL,
                            `discount` decimal(10, 2) DEFAULT NULL,
                            `dis_amt` decimal(10, 2) DEFAULT NULL,
                            `operator` varchar(20) DEFAULT NULL,
                            `status` int(11) DEFAULT NULL,
                            `free_amt` decimal(10, 2) DEFAULT NULL,
                            `pro_name` varchar(50) DEFAULT NULL,
                            `pro_type` int(11) DEFAULT NULL,
                            `dis_amt1` decimal(10, 0) DEFAULT NULL,
                            `new_time` datetime DEFAULT NULL,
                            `bill_name` varchar(255) DEFAULT NULL,
                            `io_mark` int(2) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            KEY `stk_pickup` (`bill_no`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_pickup_io`;

CREATE TABLE `stk_pickup_io` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `bill_no` varchar(50) DEFAULT NULL,
                               `pro_id` int(11) DEFAULT NULL,
                               `cz_time` datetime DEFAULT NULL,
                               `stk_id` int(11) DEFAULT NULL,
                               `biz_type` varchar(50) DEFAULT NULL,
                               `remarks` varchar(100) DEFAULT NULL,
                               `submit_user` varchar(50) DEFAULT NULL,
                               `submit_time` datetime DEFAULT NULL,
                               `cancel_user` varchar(50) DEFAULT NULL,
                               `cancel_time` datetime DEFAULT NULL,
                               `operator` varchar(20) DEFAULT NULL,
                               `status` int(11) DEFAULT NULL,
                               `pro_name` varchar(50) DEFAULT NULL,
                               `pro_type` int(11) DEFAULT NULL,
                               `new_time` datetime DEFAULT NULL,
                               `zc_id` int(11) DEFAULT NULL,
                               `io_mark` int(11) DEFAULT NULL,
                               `voucher_no` varchar(50) DEFAULT NULL,
                               `bill_name` varchar(255) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_pickup_io_sub`;

CREATE TABLE `stk_pickup_io_sub` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `mast_id` int(11) DEFAULT NULL,
                                   `ware_id` int(11) DEFAULT NULL,
                                   `qty` decimal(10, 5) DEFAULT NULL,
                                   `price` decimal(10, 5) DEFAULT NULL,
                                   `amt` decimal(10, 2) DEFAULT NULL,
                                   `unit_name` varchar(50) DEFAULT NULL,
                                   `be_qty` decimal(10, 2) DEFAULT NULL,
                                   `be_amt` decimal(10, 2) DEFAULT NULL,
                                   `be_unit` varchar(20) DEFAULT NULL,
                                   `io_mark` int(11) DEFAULT NULL,
                                   `cost_price` decimal(10, 5) DEFAULT NULL,
                                   `out_qty` decimal(10, 5) DEFAULT NULL,
                                   `status` int(2) DEFAULT NULL,
                                   `rtn_qty` decimal(13, 3) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_pickup_sub`;

CREATE TABLE `stk_pickup_sub` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `mast_id` int(11) DEFAULT NULL,
                                `ware_id` int(11) DEFAULT NULL,
                                `qty` decimal(10, 2) DEFAULT NULL,
                                `price` decimal(10, 2) DEFAULT NULL,
                                `amt` decimal(10, 2) DEFAULT NULL,
                                `unit_name` varchar(50) DEFAULT NULL,
                                `in_qty` decimal(10, 2) DEFAULT NULL,
                                `in_amt` decimal(10, 2) DEFAULT NULL,
                                `be_unit` varchar(20) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_plan`;

CREATE TABLE `stk_plan` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `plan_time` datetime DEFAULT NULL,
                          `operator` varchar(50) DEFAULT NULL,
                          `remarks` varchar(100) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_plansub`;

CREATE TABLE `stk_plansub` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `mast_id` int(11) DEFAULT NULL,
                             `ware_id` int(11) DEFAULT NULL,
                             `price` decimal(10, 2) DEFAULT NULL,
                             `in_price` decimal(10, 2) DEFAULT NULL,
                             `discount` decimal(10, 2) DEFAULT NULL,
                             `start_time` varchar(50) DEFAULT NULL,
                             `end_time` varchar(50) DEFAULT NULL,
                             `dis_amt` decimal(10, 2) DEFAULT NULL,
                             `discount2` decimal(10, 2) DEFAULT NULL,
                             `discount3` decimal(10, 2) DEFAULT NULL,
                             `discount4` decimal(10, 2) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_print_config`;

CREATE TABLE `stk_print_config` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `fd_field_key` varchar(50) DEFAULT NULL,
                                  `fd_field_name` varchar(50) DEFAULT NULL,
                                  `fd_model` varchar(100) DEFAULT NULL,
                                  `fd_status` int(11) DEFAULT NULL,
                                  `fd_tpl_id` varchar(50) DEFAULT NULL,
                                  `order_cd` int(11) DEFAULT NULL,
                                  `fd_width` int(11) DEFAULT NULL,
                                  `fd_fontsize` int(11) DEFAULT NULL COMMENT '字体大小',
                                  `fd_height` int(11) DEFAULT NULL COMMENT '字体大小',
                                  `fd_decimals` int(11) DEFAULT '0' COMMENT '小数位',
                                  `fd_align` int(4) DEFAULT '0' COMMENT '对其方式: 0/null: center; 1: left 2:right',
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_print_set`;

CREATE TABLE `stk_print_set` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `title` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                               `bill_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                               `tel` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                               `print_memo` text CHARACTER SET utf8,
                               `other1` text CHARACTER SET utf8,
                               `other2` text CHARACTER SET utf8,
                               `alipay_qrcode` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '支付宝收款码',
                               `wxpay_qrcode` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '微信收款码',
                               `display_alipay` tinyint(4) DEFAULT '0' COMMENT '是否显示支付宝收款码 0不显示 1显示',
                               `display_wxpay` tinyint(4) UNSIGNED DEFAULT '0' COMMENT '是否显示微信收款码 0不显示1显示',
                               `master_height` int(11) DEFAULT NULL COMMENT '表头高度',
                               `slave_height` int(11) DEFAULT NULL COMMENT '从表高度',
                               `display_border` tinyint(4) DEFAULT '0' COMMENT '是否显示主表边框 0不显示 1显示',
                               `master_fontsize` int(11) DEFAULT NULL COMMENT '主表字体大小',
                               `qrcode_width` int(11) DEFAULT NULL COMMENT '收款码宽度',
                               `qrcode_height` int(11) DEFAULT NULL COMMENT '收款码高度',
                               `repeat_title` tinyint(4) DEFAULT '1' COMMENT '是否重复抬头',
                               `repeat_footer` tinyint(4) DEFAULT '1' COMMENT '是否重复页脚',
                               `page_height` int(11) DEFAULT '470' COMMENT '纸张高度',
                               `display_salesman` tinyint(4) DEFAULT '1' COMMENT '是否显示业务员信息',
                               `display_customer_dept` tinyint(4) DEFAULT '0' COMMENT '显示客户欠款 0不显示 1显示',
                               `display_unit_count` tinyint(4) DEFAULT '0' COMMENT '是否显示大小单位统计',
                               `page_width` int(11) DEFAULT '652' COMMENT '纸张宽度',
                               `print_type` int(11) DEFAULT '0' COMMENT '打印类型 0:html 1:pdf',
                               `display_delivery_type` smallint(6) DEFAULT '1' COMMENT '是否显示配送方式',
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_print_template`;

CREATE TABLE `stk_print_template` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `fd_name` varchar(50) DEFAULT NULL,
                                    `fd_sub_name` varchar(50) DEFAULT NULL,
                                    `fd_model` varchar(100) DEFAULT NULL,
                                    `fd_type` varchar(10) DEFAULT NULL,
                                    `fd_status` int(2) DEFAULT NULL,
                                    `order_cd` int(11) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_produce`;

CREATE TABLE `stk_produce` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bill_no` varchar(50) DEFAULT NULL,
                             `pro_id` int(11) DEFAULT NULL,
                             `mid` int(11) DEFAULT NULL,
                             `in_time` datetime DEFAULT NULL,
                             `stk_id` int(11) DEFAULT NULL,
                             `stk_in_id` int(11) DEFAULT NULL,
                             `biz_type` varchar(50) DEFAULT NULL,
                             `remarks` varchar(100) DEFAULT NULL,
                             `submit_user` varchar(50) DEFAULT NULL,
                             `submit_time` datetime DEFAULT NULL,
                             `cancel_user` varchar(50) DEFAULT NULL,
                             `cancel_time` datetime DEFAULT NULL,
                             `total_amt` decimal(13, 2) DEFAULT NULL,
                             `discount` decimal(13, 2) DEFAULT NULL,
                             `dis_amt` decimal(13, 2) DEFAULT NULL,
                             `operator` varchar(20) DEFAULT NULL,
                             `status` int(11) DEFAULT NULL,
                             `free_amt` decimal(13, 2) DEFAULT NULL,
                             `pro_name` varchar(50) DEFAULT NULL,
                             `pro_type` int(11) DEFAULT NULL,
                             `dis_amt1` decimal(13, 2) DEFAULT NULL,
                             `new_time` datetime DEFAULT NULL,
                             `bill_name` varchar(255) DEFAULT NULL,
                             `refer_cost_amt` decimal(10, 2) DEFAULT NULL,
                             `cost_amt` decimal(13, 2) DEFAULT NULL,
                             `io_mark` int(2) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `stk_check` (`bill_no`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_produce_cost`;

CREATE TABLE `stk_produce_cost` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `mast_id` int(11) DEFAULT NULL,
                                  `amt` decimal(10, 2) DEFAULT NULL,
                                  `cost_Id` int(11) DEFAULT NULL,
                                  `voucher_no` varchar(40) DEFAULT NULL,
                                  `status` int(2) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_produce_io`;

CREATE TABLE `stk_produce_io` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `bill_no` varchar(50) DEFAULT NULL,
                                `pro_id` int(11) DEFAULT NULL,
                                `cz_time` datetime DEFAULT NULL,
                                `stk_id` int(11) DEFAULT NULL,
                                `biz_type` varchar(50) DEFAULT NULL,
                                `remarks` varchar(100) DEFAULT NULL,
                                `submit_user` varchar(50) DEFAULT NULL,
                                `submit_time` datetime DEFAULT NULL,
                                `cancel_user` varchar(50) DEFAULT NULL,
                                `cancel_time` datetime DEFAULT NULL,
                                `operator` varchar(20) DEFAULT NULL,
                                `status` int(11) DEFAULT NULL,
                                `pro_name` varchar(50) DEFAULT NULL,
                                `pro_type` int(11) DEFAULT NULL,
                                `new_time` datetime DEFAULT NULL,
                                `zc_id` int(11) DEFAULT NULL,
                                `io_mark` int(11) DEFAULT NULL,
                                `voucher_no` varchar(50) DEFAULT NULL,
                                `bill_name` varchar(255) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_produce_io_sub`;

CREATE TABLE `stk_produce_io_sub` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `mast_id` int(11) DEFAULT NULL,
                                    `ware_id` int(11) DEFAULT NULL,
                                    `qty` decimal(13, 5) DEFAULT NULL,
                                    `price` decimal(13, 5) DEFAULT NULL,
                                    `amt` decimal(11, 2) DEFAULT NULL,
                                    `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `be_qty` decimal(10, 2) DEFAULT NULL,
                                    `be_amt` decimal(11, 2) DEFAULT NULL,
                                    `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                                    `io_mark` int(11) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_produce_item`;

CREATE TABLE `stk_produce_item` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `mast_id` int(11) DEFAULT NULL,
                                  `ware_id` int(11) DEFAULT NULL,
                                  `qty` decimal(13, 5) DEFAULT NULL,
                                  `price` decimal(13, 5) DEFAULT NULL,
                                  `amt` decimal(11, 2) DEFAULT NULL,
                                  `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                  `in_qty` decimal(13, 5) DEFAULT NULL,
                                  `in_amt` decimal(13, 5) DEFAULT NULL,
                                  `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                                  `rela_ware_id` decimal(10, 0) DEFAULT NULL,
                                  `rela_ware_nm` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
                                  `plan_qty` decimal(13, 5) DEFAULT NULL,
                                  `pickup_sub_Ids` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
                                  `status` int(11) DEFAULT NULL,
                                  `jy_qty` decimal(13, 5) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_produce_sub`;

CREATE TABLE `stk_produce_sub` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `mast_id` int(11) DEFAULT NULL,
                                 `ware_id` int(11) DEFAULT NULL,
                                 `qty` decimal(13, 5) DEFAULT NULL,
                                 `price` decimal(13, 5) DEFAULT NULL,
                                 `amt` decimal(10, 2) DEFAULT NULL,
                                 `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                 `in_qty` decimal(13, 5) DEFAULT NULL,
                                 `in_amt` decimal(11, 2) DEFAULT NULL,
                                 `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                                 `product_date` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                                 `product_amt` decimal(11, 2) DEFAULT NULL,
                                 `org_price` decimal(10, 5) DEFAULT NULL,
                                 `org_amt` decimal(11, 2) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_produce_ware_tpl`;

CREATE TABLE `stk_produce_ware_tpl` (
                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                      `ware_id` int(11) DEFAULT NULL,
                                      `qty` decimal(13, 5) DEFAULT NULL,
                                      `ware_nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                      `rela_ware_id` int(11) DEFAULT NULL,
                                      `rela_ware_nm` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
                                      `status` int(2) DEFAULT NULL,
                                      `readers_ids` varchar(300) CHARACTER SET utf8 DEFAULT NULL,
                                      `readers_nms` varchar(400) CHARACTER SET utf8 DEFAULT NULL,
                                      `modify_id` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
                                      `modify_nm` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
                                      `be_unit` varchar(10) DEFAULT 'B',
                                      `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                      `rela_be_unit` varchar(10) DEFAULT 'B',
                                      `rela_unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                      PRIMARY KEY (`id`),
                                      tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_provider`;

CREATE TABLE `stk_provider` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `pro_no` varchar(50) DEFAULT NULL,
                              `pro_name` varchar(50) DEFAULT NULL,
                              `address` varchar(100) DEFAULT NULL,
                              `tel` varchar(50) DEFAULT NULL,
                              `mobile` varchar(50) DEFAULT NULL,
                              `contact` varchar(50) DEFAULT NULL,
                              `remarks` varchar(100) DEFAULT NULL,
                              `left_amt` decimal(10, 2) DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              `fbtime` varchar(20) DEFAULT NULL,
                              `usc_code` varchar(50) DEFAULT NULL,
                              `py` varchar(50) DEFAULT NULL COMMENT '拼音',
                              `pro_type_id` int(11) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_provider_type`;

CREATE TABLE `stk_provider_type` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `name` varchar(50) NOT NULL COMMENT '名称',
                                   `remark` varchar(50) DEFAULT NULL COMMENT '注备',
                                   `status` int(11) DEFAULT '1' COMMENT '是否生效（1是；0否）',
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_rebate_in`;

CREATE TABLE `stk_rebate_in` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `bill_no` varchar(50) DEFAULT NULL,
                               `pro_id` int(11) DEFAULT NULL,
                               `mid` int(11) DEFAULT NULL,
                               `in_time` datetime DEFAULT NULL,
                               `stk_id` int(11) DEFAULT NULL,
                               `in_type` varchar(50) DEFAULT NULL,
                               `remarks` varchar(100) DEFAULT NULL,
                               `submit_user` varchar(50) DEFAULT NULL,
                               `submit_time` datetime DEFAULT NULL,
                               `cancel_user` varchar(50) DEFAULT NULL,
                               `cancel_time` datetime DEFAULT NULL,
                               `total_amt` decimal(10, 2) DEFAULT NULL,
                               `pay_amt` decimal(10, 2) DEFAULT NULL,
                               `discount` decimal(10, 2) DEFAULT NULL,
                               `dis_amt` decimal(10, 2) DEFAULT NULL,
                               `operator` varchar(20) DEFAULT NULL,
                               `status` int(11) DEFAULT NULL,
                               `free_amt` decimal(10, 2) DEFAULT NULL,
                               `pro_name` varchar(50) DEFAULT NULL,
                               `pro_type` int(11) DEFAULT NULL,
                               `dis_amt1` decimal(10, 0) DEFAULT NULL,
                               `new_time` datetime DEFAULT NULL,
                               `order_id` int(11) DEFAULT NULL,
                               `order_no` varchar(50) DEFAULT NULL,
                               `emp_id` int(11) DEFAULT NULL,
                               `emp_nm` varchar(50) DEFAULT NULL,
                               `veh_id` int(11) DEFAULT NULL,
                               `driver_id` int(11) DEFAULT NULL,
                               `relate_Id` int(11) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_rebate_insub`;

CREATE TABLE `stk_rebate_insub` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `mast_id` int(11) DEFAULT NULL,
                                  `ware_id` int(11) DEFAULT NULL,
                                  `qty` decimal(10, 2) DEFAULT NULL,
                                  `price` decimal(10, 2) DEFAULT NULL,
                                  `amt` decimal(10, 2) DEFAULT NULL,
                                  `unit_name` varchar(50) DEFAULT NULL,
                                  `in_qty` decimal(10, 2) DEFAULT NULL,
                                  `in_amt` decimal(10, 2) DEFAULT NULL,
                                  `be_unit` varchar(20) DEFAULT NULL,
                                  `product_date` varchar(50) DEFAULT NULL,
                                  `in_type_code` varchar(50) DEFAULT NULL,
                                  `in_type_name` varchar(50) DEFAULT NULL,
                                  `rebate_Price` decimal(10, 5) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_rebate_out`;

CREATE TABLE `stk_rebate_out` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `order_id` int(11) DEFAULT NULL,
                                `bill_no` varchar(50) DEFAULT NULL,
                                `cst_id` int(11) DEFAULT NULL,
                                `shr` varchar(50) DEFAULT NULL,
                                `tel` varchar(50) DEFAULT NULL,
                                `address` varchar(100) DEFAULT NULL,
                                `mid` int(11) DEFAULT NULL,
                                `out_time` datetime DEFAULT NULL,
                                `pszd` varchar(50) DEFAULT NULL,
                                `remarks` varchar(500) DEFAULT NULL,
                                `out_type` varchar(50) DEFAULT NULL,
                                `stk_id` int(11) DEFAULT NULL,
                                `submit_user` varchar(50) DEFAULT NULL,
                                `submit_time` datetime DEFAULT NULL,
                                `cancel_user` varchar(50) DEFAULT NULL,
                                `cancel_time` datetime DEFAULT NULL,
                                `total_amt` decimal(10, 2) DEFAULT NULL,
                                `rec_amt` decimal(10, 2) DEFAULT NULL,
                                `discount` int(11) DEFAULT NULL,
                                `dis_amt` decimal(10, 2) DEFAULT NULL,
                                `operator` varchar(50) DEFAULT NULL,
                                `status` int(11) DEFAULT NULL,
                                `free_amt` decimal(10, 2) DEFAULT NULL,
                                `kh_nm` varchar(50) DEFAULT NULL,
                                `pro_type` int(11) DEFAULT NULL,
                                `dis_amt1` decimal(10, 2) DEFAULT NULL,
                                `staff` varchar(50) DEFAULT NULL,
                                `staff_tel` varchar(50) DEFAULT NULL,
                                `new_time` datetime DEFAULT NULL,
                                `ep_customer_id` varchar(50) DEFAULT NULL,
                                `ep_customer_name` varchar(50) DEFAULT NULL,
                                `emp_id` int(11) DEFAULT NULL,
                                `create_time` datetime DEFAULT NULL,
                                `send_time` datetime DEFAULT NULL,
                                `veh_id` int(11) DEFAULT NULL,
                                `driver_id` int(11) DEFAULT NULL,
                                `relate_id` int(11) DEFAULT NULL,
                                `sale_type` varchar(10) DEFAULT '001',
                                PRIMARY KEY (`id`),
                                KEY `order_id` (`order_id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_rebate_outsub`;

CREATE TABLE `stk_rebate_outsub` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `mast_id` int(11) DEFAULT NULL,
                                   `ware_id` int(11) DEFAULT NULL,
                                   `qty` decimal(10, 2) DEFAULT NULL,
                                   `price` decimal(10, 2) DEFAULT NULL,
                                   `amt` decimal(10, 2) DEFAULT NULL,
                                   `unit_name` varchar(50) DEFAULT NULL,
                                   `xs_tp` varchar(50) DEFAULT NULL,
                                   `out_qty` decimal(10, 2) DEFAULT NULL,
                                   `out_amt` decimal(10, 2) DEFAULT NULL,
                                   `product_date` varchar(50) DEFAULT NULL,
                                   `active_date` varchar(50) DEFAULT NULL,
                                   `remarks` varchar(200) DEFAULT NULL,
                                   `be_unit` varchar(20) DEFAULT NULL,
                                   `ssw_id` varchar(50) DEFAULT NULL,
                                   `rebate_Price` decimal(10, 5) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   KEY `mast_id` (`mast_id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_rec_mast`;

CREATE TABLE `stk_rec_mast` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `cst_id` int(11) DEFAULT NULL,
                              `sum_amt` decimal(10, 2) DEFAULT NULL,
                              `remarks` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                              `mid` int(11) DEFAULT NULL,
                              `rec_time` datetime DEFAULT NULL,
                              `bill_id` int(11) DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              `cash` decimal(10, 2) DEFAULT NULL,
                              `bank` decimal(10, 2) DEFAULT NULL,
                              `wx` decimal(10, 2) DEFAULT NULL,
                              `zfb` decimal(10, 2) DEFAULT NULL,
                              `bill_type` int(11) DEFAULT NULL,
                              `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `pre_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `pre_id` int(11) DEFAULT NULL,
                              `pre_amt` decimal(10, 2) DEFAULT NULL,
                              `cost_Id` int(11) DEFAULT NULL,
                              `pro_id` int(11) DEFAULT NULL,
                              `pro_type` int(11) DEFAULT NULL,
                              `pro_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `source_bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `acc_Id` int(11) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              KEY `source_bill_no_index` (`source_bill_no`),
                              KEY `bill_id_index` (`bill_id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_rec_sub`;

CREATE TABLE `stk_rec_sub` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `cst_id` int(11) DEFAULT NULL,
                             `sum_amt` decimal(10, 2) DEFAULT NULL,
                             `remarks` varchar(100) DEFAULT NULL,
                             `mid` int(11) DEFAULT NULL,
                             `rec_time` datetime DEFAULT NULL,
                             `bill_id` int(11) DEFAULT NULL,
                             `status` int(11) DEFAULT NULL,
                             `cash` decimal(10, 2) DEFAULT NULL,
                             `bank` decimal(10, 2) DEFAULT NULL,
                             `wx` decimal(10, 2) DEFAULT NULL,
                             `zfb` decimal(10, 2) DEFAULT NULL,
                             `bill_type` int(11) DEFAULT NULL,
                             `bill_no` varchar(50) DEFAULT NULL,
                             `pre_no` varchar(50) DEFAULT NULL,
                             `pre_id` int(11) DEFAULT NULL,
                             `pre_amt` decimal(10, 2) DEFAULT NULL,
                             `cost_Id` int(11) DEFAULT NULL,
                             `pro_id` int(11) DEFAULT NULL,
                             `pro_type` int(11) DEFAULT NULL,
                             `pro_name` varchar(50) DEFAULT NULL,
                             `source_bill_no` varchar(50) DEFAULT NULL,
                             `acc_Id` int(11) DEFAULT NULL,
                             `mast_id` int(11) DEFAULT NULL,
                             `out_type` varchar(50) DEFAULT NULL,
                             `out_time` datetime DEFAULT NULL,
                             `emp_Id` int(11) DEFAULT NULL,
                             `staff` varchar(50) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_right`;

CREATE TABLE `stk_right` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `role_id` int(11) DEFAULT NULL,
                           `menu_id` int(11) DEFAULT NULL,
                           `price_flag` int(11) DEFAULT NULL,
                           `amt_flag` int(11) DEFAULT NULL,
                           `qty_flag` int(11) DEFAULT NULL,
                           `audit_flag` int(11) DEFAULT NULL,
                           `print_flag` int(11) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_rpt_org_main`;

CREATE TABLE `stk_rpt_org_main` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
                                  `rpt_title` varchar(100) DEFAULT NULL COMMENT '标题',
                                  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                  `rpt_date` datetime NOT NULL COMMENT '报表日期',
                                  `oper_Id` int(11) NOT NULL,
                                  `oper_name` varchar(10) NOT NULL COMMENT '操作员',
                                  `rpt_type` varchar(20) NOT NULL COMMENT '报表类型',
                                  `blod_byte` mediumblob,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_rpt_org_sub`;

CREATE TABLE `stk_rpt_org_sub` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
                                 `ware_id` int(11) DEFAULT NULL,
                                 `ware_nm` varchar(100) DEFAULT NULL COMMENT '名称',
                                 `main_id` int(11) DEFAULT NULL,
                                 `unit_name` varchar(20) DEFAULT NULL COMMENT '单位',
                                 `bill_name` varchar(10) DEFAULT NULL COMMENT '销售类型',
                                 `out_qty` double(10, 2) DEFAULT '0.00' COMMENT '单价',
                                 `unit_amt` double(10, 2) DEFAULT '0.00' COMMENT '单位费用',
                                 `customer_Id` int(11) DEFAULT NULL,
                                 `customer_name` varchar(100) DEFAULT NULL COMMENT '客户名称',
                                 `sum_amt` double(10, 2) DEFAULT '0.00' COMMENT '总费用',
                                 `driver_id` int(1) DEFAULT NULL,
                                 `driver_name` varchar(50) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_send`;

CREATE TABLE `stk_send` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `out_id` int(11) DEFAULT NULL COMMENT '发货单id',
                          `send_time` datetime DEFAULT NULL,
                          `driver_id` int(11) DEFAULT NULL,
                          `veh_id` int(11) DEFAULT NULL,
                          `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `status` int(11) DEFAULT NULL,
                          `remarks` varchar(300) CHARACTER SET utf8 DEFAULT NULL,
                          `stk_id` int(11) DEFAULT NULL,
                          `bill_type` int(11) DEFAULT NULL,
                          `ep_customer_id` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `ep_customer_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `voucher_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `delivery_id` int(11) DEFAULT NULL,
                          `delivery_no` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
                          `kh_Nm` varchar(50) DEFAULT NULL,
                          `cst_Id` int(11) DEFAULT NULL,
                          `pro_Type` int(11) DEFAULT NULL,
                          `emp_Id` int(11) DEFAULT NULL,
                          `staff` varchar(50) DEFAULT NULL,
                          `out_type` varchar(20) DEFAULT NULL,
                          `out_time` datetime DEFAULT NULL,
                          `transport_name` varchar(50) DEFAULT NULL,
                          `transport_code` varchar(50) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_sendsub`;

CREATE TABLE `stk_sendsub` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `mast_id` int(11) DEFAULT NULL,
                             `ware_id` int(11) DEFAULT NULL,
                             `qty` decimal(13, 5) DEFAULT NULL,
                             `price` decimal(13, 5) DEFAULT NULL,
                             `amt` decimal(11, 2) DEFAULT NULL,
                             `unit_name` varchar(50) DEFAULT NULL,
                             `xs_tp` varchar(50) DEFAULT NULL,
                             `out_qty` decimal(13, 5) DEFAULT NULL,
                             `out_amt` decimal(11, 2) DEFAULT NULL,
                             `product_date` varchar(50) DEFAULT NULL,
                             `active_date` varchar(50) DEFAULT NULL,
                             `remarks` varchar(200) DEFAULT NULL,
                             `be_unit` varchar(20) DEFAULT NULL,
                             `sub_id` int(11) DEFAULT NULL,
                             `rebate_Price` decimal(10, 5) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `stk_sendsub_index_01` (`mast_id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_stock_config`;

CREATE TABLE `stk_stock_config` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `max_start` double(6, 4) DEFAULT NULL,
                                  `max_end` double(6, 4) DEFAULT NULL,
                                  `min_start` double(6, 4) DEFAULT NULL,
                                  `min_end` double(6, 4) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_storage`;

CREATE TABLE `stk_storage` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `stk_no` varchar(50) DEFAULT NULL,
                             `stk_name` varchar(50) DEFAULT NULL,
                             `address` varchar(100) DEFAULT NULL,
                             `stk_manager` varchar(50) DEFAULT NULL,
                             `tel` varchar(50) DEFAULT NULL,
                             `status` int(11) DEFAULT NULL,
                             `remarks` varchar(100) DEFAULT NULL,
                             `fbtime` varchar(20) DEFAULT NULL,
                             `sale_car` int(2) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_storage_io`;

CREATE TABLE `stk_storage_io` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `stk_id` int(11) DEFAULT NULL,
                                `ware_id` int(11) DEFAULT NULL,
                                `bill_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `bill_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `in_qty` decimal(16, 10) DEFAULT NULL,
                                `out_qty` decimal(16, 10) DEFAULT NULL,
                                `io_price` decimal(13, 5) DEFAULT NULL,
                                `operator` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `left_qty` decimal(11, 5) DEFAULT NULL,
                                `io_time` datetime DEFAULT NULL,
                                `bill_id` int(11) DEFAULT NULL,
                                `bat_id` int(11) DEFAULT NULL,
                                `in_price` decimal(13, 5) DEFAULT NULL,
                                `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `sub_id` int(11) DEFAULT NULL,
                                `status` int(11) DEFAULT NULL,
                                `stk_unit` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                                `io_bill_id` int(11) DEFAULT NULL,
                                `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                                `product_date` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `rebate_Price` decimal(10, 5) DEFAULT NULL,
                                `pro_type` int(11) DEFAULT NULL,
                                `bill_time` datetime DEFAULT NULL,
                                `in_amt` decimal(10, 2) DEFAULT NULL,
                                `out_amt` decimal(10, 2) DEFAULT NULL,
                                `stk_unit_Id` int(11) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                KEY `stk_storage_io_index_05` (`bill_id`),
                                KEY `stk_storage_io_index_04` (`io_time`),
                                KEY `stk_storage_io_index_01` (`ware_id`),
                                KEY `stk_storage_io_index_06` (`bill_no`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_storage_ware`;

CREATE TABLE `stk_storage_ware` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `stk_id` int(11) DEFAULT NULL,
                                  `ware_id` int(11) DEFAULT NULL,
                                  `unit_name` varchar(50) DEFAULT NULL,
                                  `in_price` decimal(13, 5) DEFAULT NULL,
                                  `qty` decimal(16, 10) DEFAULT NULL,
                                  `in_time` datetime DEFAULT NULL,
                                  `bill_id` int(11) DEFAULT NULL,
                                  `be_unit` varchar(20) DEFAULT NULL,
                                  `product_date` varchar(50) DEFAULT NULL,
                                  `amt` decimal(11, 2) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  KEY `stk_storage_ware_index_01` (`ware_id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_summary`;

CREATE TABLE `stk_summary` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `ware_id` int(11) DEFAULT NULL,
                             `init_qty` decimal(10, 2) DEFAULT NULL,
                             `init_amt` decimal(10, 2) DEFAULT NULL,
                             `init_in_qty` decimal(10, 2) DEFAULT NULL,
                             `init_in_amt` decimal(10, 2) DEFAULT NULL,
                             `sum_in_qty` decimal(10, 2) DEFAULT NULL,
                             `sum_in_amt` decimal(10, 2) DEFAULT NULL,
                             `start_date` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                             `close_date` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                             `stk_id` int(11) DEFAULT NULL,
                             `in_amt` decimal(10, 2) DEFAULT NULL,
                             `out_amt` decimal(10, 2) DEFAULT NULL,
                             `unit_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `in_qty1` decimal(10, 2) DEFAULT NULL,
                             `out_qty1` decimal(10, 2) DEFAULT NULL,
                             `in_amt1` decimal(10, 2) DEFAULT NULL,
                             `out_amt1` decimal(10, 2) DEFAULT NULL,
                             `check_in_qty` decimal(10, 2) DEFAULT NULL,
                             `check_in_amt` decimal(10, 2) DEFAULT NULL,
                             `rtn_qty` decimal(10, 2) DEFAULT NULL,
                             `rtn_amt` decimal(10, 2) DEFAULT NULL,
                             `trans_in_qty` decimal(10, 2) DEFAULT NULL,
                             `trans_in_amt` decimal(10, 2) DEFAULT NULL,
                             `zz_in_qty` decimal(10, 2) DEFAULT NULL,
                             `zz_in_amt` decimal(10, 2) DEFAULT NULL,
                             `cx_in_qty` decimal(10, 2) DEFAULT NULL,
                             `cx_in_amt` decimal(10, 2) DEFAULT NULL,
                             `sc_qty` decimal(10, 2) DEFAULT NULL,
                             `sc_amt` decimal(10, 2) DEFAULT NULL,
                             `other_type_in_qty` decimal(10, 2) DEFAULT NULL,
                             `other_type_in_amt` decimal(10, 2) DEFAULT NULL,
                             `out_qty11` decimal(10, 2) DEFAULT NULL,
                             `out_amt11` decimal(10, 2) DEFAULT NULL,
                             `out_qty12` decimal(10, 2) DEFAULT NULL,
                             `out_amt12` decimal(10, 2) DEFAULT NULL,
                             `out_qty13` decimal(10, 2) DEFAULT NULL,
                             `out_amt13` decimal(10, 2) DEFAULT NULL,
                             `out_qty14` decimal(10, 2) DEFAULT NULL,
                             `out_amt14` decimal(10, 2) DEFAULT NULL,
                             `out_qty15` decimal(10, 2) DEFAULT NULL,
                             `out_amt15` decimal(10, 2) DEFAULT NULL,
                             `shop_sale_qty` decimal(10, 2) DEFAULT NULL,
                             `shop_sale_amt` decimal(10, 2) DEFAULT NULL,
                             `other_out_qty` decimal(10, 2) DEFAULT NULL,
                             `other_out_amt` decimal(10, 2) DEFAULT NULL,
                             `pur_rtn_qty` decimal(10, 2) DEFAULT NULL,
                             `pur_rtn_amt` decimal(10, 2) DEFAULT NULL,
                             `trans_out_qty` decimal(10, 2) DEFAULT NULL,
                             `trans_out_amt` decimal(10, 2) DEFAULT NULL,
                             `zz_out_qty` decimal(10, 2) DEFAULT NULL,
                             `zz_out_amt` decimal(10, 2) DEFAULT NULL,
                             `cx_out_qty` decimal(10, 2) DEFAULT NULL,
                             `cx_out_amt` decimal(10, 2) DEFAULT NULL,
                             `use_qty` decimal(10, 2) DEFAULT NULL,
                             `use_amt` decimal(10, 2) DEFAULT NULL,
                             `hk_qty` decimal(10, 2) DEFAULT NULL,
                             `hk_amt` decimal(10, 2) DEFAULT NULL,
                             `loss_qty` decimal(10, 2) DEFAULT NULL,
                             `loss_amt` decimal(10, 2) DEFAULT NULL,
                             `lend_qty` decimal(10, 2) DEFAULT NULL,
                             `lend_amt` decimal(10, 2) DEFAULT NULL,
                             `sum_out_qty` decimal(10, 2) DEFAULT NULL,
                             `sum_out_amt` decimal(10, 2) DEFAULT NULL,
                             `len_out_qty` decimal(10, 2) DEFAULT NULL,
                             `len_out_amt` decimal(10, 2) DEFAULT NULL,
                             `other_type_out_qty` decimal(10, 2) DEFAULT NULL,
                             `other_type_out_amt` decimal(10, 2) DEFAULT NULL,
                             `check_out_qty` decimal(10, 2) DEFAULT NULL,
                             `check_out_amt` decimal(10, 2) DEFAULT NULL,
                             `yymm` varchar(10) DEFAULT NULL,
                             `avg_price` decimal(10, 2) DEFAULT NULL,
                             `avg_price1` decimal(10, 2) DEFAULT NULL,
                             `end_qty` decimal(10, 2) DEFAULT NULL,
                             `end_amt` decimal(10, 2) DEFAULT NULL,
                             `in_qty` decimal(10, 2) DEFAULT NULL,
                             `out_qty` decimal(10, 2) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_vehicle`;

CREATE TABLE `stk_vehicle` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `veh_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `veh_type` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `status` int(11) DEFAULT NULL,
                             `driver_id` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_ware`;

CREATE TABLE `stk_ware` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `ware_id` int(11) DEFAULT NULL,
                          `in_price` decimal(10, 2) DEFAULT NULL,
                          `py` varchar(50) DEFAULT NULL,
                          `status` int(11) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_ware_choose`;

CREATE TABLE `stk_ware_choose` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `ware_id` int(11) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_zzcx`;

CREATE TABLE `stk_zzcx` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `bill_no` varchar(50) DEFAULT NULL,
                          `pro_id` int(11) DEFAULT NULL,
                          `mid` int(11) DEFAULT NULL,
                          `in_time` datetime DEFAULT NULL,
                          `stk_id` int(11) DEFAULT NULL,
                          `stk_in_id` int(11) DEFAULT NULL,
                          `biz_type` varchar(50) DEFAULT NULL,
                          `remarks` varchar(100) DEFAULT NULL,
                          `submit_user` varchar(50) DEFAULT NULL,
                          `submit_time` datetime DEFAULT NULL,
                          `cancel_user` varchar(50) DEFAULT NULL,
                          `cancel_time` datetime DEFAULT NULL,
                          `total_amt` decimal(10, 2) DEFAULT NULL,
                          `discount` decimal(10, 2) DEFAULT NULL,
                          `dis_amt` decimal(10, 2) DEFAULT NULL,
                          `operator` varchar(20) DEFAULT NULL,
                          `status` int(11) DEFAULT NULL,
                          `free_amt` decimal(10, 2) DEFAULT NULL,
                          `pro_name` varchar(50) DEFAULT NULL,
                          `pro_type` int(11) DEFAULT NULL,
                          `dis_amt1` decimal(10, 0) DEFAULT NULL,
                          `new_time` datetime DEFAULT NULL,
                          `bill_name` varchar(255) DEFAULT NULL,
                          `io_mark` int(2) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          KEY `stk_pickup` (`bill_no`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_zzcx_io`;

CREATE TABLE `stk_zzcx_io` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bill_no` varchar(50) DEFAULT NULL,
                             `pro_id` int(11) DEFAULT NULL,
                             `cz_time` datetime DEFAULT NULL,
                             `stk_id` int(11) DEFAULT NULL,
                             `biz_type` varchar(50) DEFAULT NULL,
                             `remarks` varchar(100) DEFAULT NULL,
                             `submit_user` varchar(50) DEFAULT NULL,
                             `submit_time` datetime DEFAULT NULL,
                             `cancel_user` varchar(50) DEFAULT NULL,
                             `cancel_time` datetime DEFAULT NULL,
                             `operator` varchar(20) DEFAULT NULL,
                             `status` int(11) DEFAULT NULL,
                             `pro_name` varchar(50) DEFAULT NULL,
                             `pro_type` int(11) DEFAULT NULL,
                             `new_time` datetime DEFAULT NULL,
                             `zc_id` int(11) DEFAULT NULL,
                             `io_mark` int(11) DEFAULT NULL,
                             `voucher_no` varchar(50) DEFAULT NULL,
                             `bill_name` varchar(255) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_zzcx_io_sub`;

CREATE TABLE `stk_zzcx_io_sub` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `mast_id` int(11) DEFAULT NULL,
                                 `ware_id` int(11) DEFAULT NULL,
                                 `qty` decimal(10, 2) DEFAULT NULL,
                                 `price` decimal(10, 2) DEFAULT NULL,
                                 `amt` decimal(10, 2) DEFAULT NULL,
                                 `unit_name` varchar(50) DEFAULT NULL,
                                 `be_qty` decimal(10, 2) DEFAULT NULL,
                                 `be_amt` decimal(10, 2) DEFAULT NULL,
                                 `be_unit` varchar(20) DEFAULT NULL,
                                 `io_mark` int(11) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_zzcx_item`;

CREATE TABLE `stk_zzcx_item` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `mast_id` int(11) DEFAULT NULL,
                               `ware_id` int(11) DEFAULT NULL,
                               `qty` decimal(10, 2) DEFAULT NULL,
                               `price` decimal(10, 2) DEFAULT NULL,
                               `amt` decimal(10, 2) DEFAULT NULL,
                               `unit_name` varchar(50) DEFAULT NULL,
                               `in_qty` decimal(10, 2) DEFAULT NULL,
                               `in_amt` decimal(10, 2) DEFAULT NULL,
                               `be_unit` varchar(20) DEFAULT NULL,
                               `rela_ware_id` decimal(10, 0) DEFAULT NULL,
                               `rela_ware_nm` varchar(255) DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_zzcx_sub`;

CREATE TABLE `stk_zzcx_sub` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `mast_id` int(11) DEFAULT NULL,
                              `ware_id` int(11) DEFAULT NULL,
                              `qty` decimal(10, 2) DEFAULT NULL,
                              `price` decimal(10, 2) DEFAULT NULL,
                              `amt` decimal(10, 2) DEFAULT NULL,
                              `unit_name` varchar(50) DEFAULT NULL,
                              `in_qty` decimal(10, 2) DEFAULT NULL,
                              `in_amt` decimal(10, 2) DEFAULT NULL,
                              `be_unit` varchar(20) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `stk_zzcx_ware_tpl`;

CREATE TABLE `stk_zzcx_ware_tpl` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `ware_id` int(11) DEFAULT NULL,
                                   `qty` decimal(10, 2) DEFAULT NULL,
                                   `ware_nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                   `rela_ware_id` int(11) DEFAULT NULL,
                                   `be_unit` varchar(10) DEFAULT NULL,
                                   `unit_name` varchar(50) DEFAULT NULL,
                                   `rela_be_unit` varchar(10) DEFAULT NULL,
                                   `rela_unit_name` varchar(50) DEFAULT NULL,
                                   `bill_id` int(11) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_address_upload`;

CREATE TABLE `sys_address_upload` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `mem_id` int(11) NOT NULL COMMENT '员工id',
                                    `upload` int(11) DEFAULT '0' COMMENT '上传方式：0不上传，1上传',
                                    `mem_upload` int(11) DEFAULT NULL,
                                    `min` int(11) DEFAULT '1' COMMENT '上传间隔默认1分钟',
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_auto_customer_price`;

CREATE TABLE `sys_auto_customer_price` (
                                         `id` int(11) NOT NULL AUTO_INCREMENT,
                                         `auto_id` int(11) DEFAULT NULL,
                                         `ware_id` int(11) DEFAULT NULL,
                                         `customer_id` int(11) DEFAULT NULL,
                                         `price` varchar(255) DEFAULT NULL,
                                         `status` varchar(255) DEFAULT NULL,
                                         PRIMARY KEY (`id`),
                                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_auto_field`;

CREATE TABLE `sys_auto_field` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `fd_model` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                                `status` varchar(10) DEFAULT '1',
                                `fd_way` varchar(10) DEFAULT '00',
                                `fd_code` varchar(20) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_auto_price`;

CREATE TABLE `sys_auto_price` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `auto_id` int(11) DEFAULT NULL,
                                `ware_id` int(11) DEFAULT NULL,
                                `price` varchar(255) DEFAULT NULL,
                                `status` varchar(255) DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bfcljccj`;

CREATE TABLE `sys_bfcljccj` (
                              `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '陈列检查采集id',
                              `mid` int(11) NOT NULL COMMENT '务业员id',
                              `cid` int(11) NOT NULL COMMENT '客户id',
                              `mdid` int(11) NOT NULL COMMENT ' 模板id',
                              `hjpms` varchar(20) DEFAULT NULL COMMENT '货架排面数',
                              `djpms` varchar(20) DEFAULT NULL COMMENT '端架排面数',
                              `sytwl` varchar(20) DEFAULT NULL COMMENT '收银台围栏',
                              `bds` varchar(20) DEFAULT NULL COMMENT '冰点数',
                              `remo` varchar(300) DEFAULT NULL COMMENT '摘要',
                              `cjdate` varchar(20) NOT NULL COMMENT '日期',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bfcomment`;

CREATE TABLE `sys_bfcomment` (
                               `comment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评论id',
                               `bf_id` int(11) NOT NULL COMMENT '所属话题',
                               `member_id` int(11) NOT NULL COMMENT '评论人',
                               `comment_time` varchar(20) NOT NULL COMMENT '评论时间',
                               `content` varchar(300) NOT NULL COMMENT '评论内容',
                               `belong_id` int(11) NOT NULL DEFAULT '0' COMMENT '回复的对象id 0 为评论 其他为回复的对应评论id',
                               `rc_id` int(11) DEFAULT NULL COMMENT '被回复人id',
                               `rc_nm` varchar(20) DEFAULT NULL COMMENT '被回复人用户名',
                               `voice_time` int(5) DEFAULT NULL COMMENT '语音时长',
                               PRIMARY KEY (`comment_id`),
                               KEY `bf_id` (`bf_id`),
                               KEY `member_id` (`member_id`),
                               KEY `belong_id` (`belong_id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bfgzxc`;

CREATE TABLE `sys_bfgzxc` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '道谢并告知下次拜访日期id',
                            `mid` int(11) NOT NULL COMMENT '业务员id',
                            `cid` int(11) NOT NULL COMMENT '客户id',
                            `bcbfzj` varchar(300) DEFAULT NULL COMMENT '本次拜访总结',
                            `dbsx` varchar(300) DEFAULT NULL COMMENT '代办事项',
                            `dqdate` varchar(20) NOT NULL COMMENT '当前日期',
                            `xcdate` varchar(20) DEFAULT NULL COMMENT '下次拜访日期',
                            `ddtime` varchar(20) NOT NULL COMMENT '当前时间',
                            `longitude` varchar(50) DEFAULT NULL COMMENT '经度',
                            `latitude` varchar(50) DEFAULT NULL COMMENT '纬度',
                            `address` varchar(100) DEFAULT NULL COMMENT '地址',
                            `voice_url` varchar(255) DEFAULT NULL COMMENT '语音地址',
                            `voice_time` int(5) DEFAULT NULL COMMENT '语音时长',
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bforder`;

CREATE TABLE `sys_bforder` (
                             `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单id',
                             `mid` int(11) NOT NULL COMMENT '业务员id',
                             `cid` int(11) NOT NULL COMMENT '客户id',
                             `order_no` varchar(20) CHARACTER SET utf8 NOT NULL COMMENT '订单号',
                             `shr` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '收货人',
                             `tel` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '电话',
                             `address` varchar(500) CHARACTER SET utf8 DEFAULT NULL COMMENT '地址',
                             `remo` varchar(300) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注',
                             `zje` double(10, 2) DEFAULT NULL COMMENT '商品总价(商品单价*数量)',
                             `zdzk` double(10, 2) DEFAULT NULL COMMENT '整单折扣',
                             `cjje` double(10, 2) DEFAULT NULL COMMENT '商品净收入总额(商品总价(原价)-促销金额-优惠金额)不含运费和低用卷',
                             `oddate` varchar(20) CHARACTER SET utf8 NOT NULL COMMENT '日期',
                             `order_tp` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '订单类型',
                             `sh_time` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '送货时间',
                             `order_lb` varchar(10) CHARACTER SET utf8 DEFAULT '拜访单' COMMENT '订单类别（拜访单，电话单

）',
                             `odtime` varchar(10) CHARACTER SET utf8 DEFAULT NULL COMMENT '时间',
                             `order_zt` varchar(10) CHARACTER SET utf8 DEFAULT '未审核' COMMENT '订单状态（审核，未审核）

',
                             `pszd` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '配送指定（公司直送，转二批配送）',
                             `stk_id` int(11) DEFAULT NULL,
                             `shop_member_id` int(11) DEFAULT NULL,
                             `shop_member_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                             `pro_type` int(11) DEFAULT NULL,
                             `status` int(11) DEFAULT NULL COMMENT '订单状态',
                             `is_pay` int(11) DEFAULT NULL,
                             `is_send` int(11) DEFAULT NULL,
                             `is_finish` int(11) DEFAULT NULL,
                             `pay_type` int(11) DEFAULT NULL COMMENT '0.未支付类型；1.线下支付；2.余额支付；3.微信支付；4.支付宝支付',
                             `pay_time` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                             `finish_time` datetime DEFAULT NULL COMMENT '确认完成时间',
                             `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
                             `transport_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '运输公司名称',
                             `transport_code` varchar(10) CHARACTER SET utf8 DEFAULT NULL COMMENT '运输编号',
                             `cancel_remo` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '取消说明',
                             `freight` decimal(10, 2) DEFAULT NULL COMMENT '运费',
                             `promotion_cost` decimal(10, 2) DEFAULT '0.00' COMMENT '订单总促销金额',
                             `coupon_cost` decimal(10, 2) DEFAULT '0.00' COMMENT '订单总优惠金额',
                             `order_amount` decimal(10, 2) DEFAULT '0.00' COMMENT '订单实付(最终支付金额)=商品净收入总额+运费',
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bforder_detail`;

CREATE TABLE `sys_bforder_detail` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单详情id',
                                    `order_id` int(11) NOT NULL COMMENT '订单id',
                                    `ware_id` int(11) NOT NULL COMMENT '商品id',
                                    `ware_num` double(10, 2) DEFAULT NULL,
                                    `ware_dj` double(10, 2) NOT NULL COMMENT '最终单价(如果存在促销或优惠卷时会扣减)',
                                    `ware_zj` double(10, 2) NOT NULL COMMENT '总价(最终单价*数量)',
                                    `xs_tp` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '销售类型',
                                    `ware_dw` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '单位',
                                    `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                                    `remark` varchar(500) DEFAULT NULL COMMENT '说明',
                                    `detail_ware_nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '商品名称',
                                    `detail_ware_gg` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '商品规格',
                                    `detail_shop_ware_alias` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '商城商品别名',
                                    `detail_ware_desc` text CHARACTER SET utf8 COMMENT '商品描述',
                                    `ware_dj_original` decimal(13, 5) DEFAULT NULL COMMENT '商品原价',
                                    `detail_promotion_cost` decimal(11, 2) DEFAULT NULL COMMENT '促销总金额',
                                    `detail_coupon_cost` decimal(11, 2) DEFAULT NULL COMMENT '优惠卷总金额',
                                    PRIMARY KEY (`id`),
                                    KEY `sys_bforder_detail_index_01` (`order_id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bforder_msg`;

CREATE TABLE `sys_bforder_msg` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '信息id',
                                 `order_no` varchar(20) NOT NULL COMMENT '订单号',
                                 `mid` int(11) NOT NULL COMMENT '业务员id',
                                 `cid` int(11) NOT NULL COMMENT '客户id',
                                 `msgtime` varchar(20) NOT NULL COMMENT '时间',
                                 `is_read` int(2) DEFAULT '2' COMMENT '是否已读（1是；2否）',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bforder_pic`;

CREATE TABLE `sys_bforder_pic` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
                                 `type` int(11) DEFAULT NULL COMMENT '1主图',
                                 `pic_mini` varchar(255) NOT NULL COMMENT '小图',
                                 `pic` varchar(255) NOT NULL COMMENT '大图',
                                 `ware_id` int(11) DEFAULT NULL COMMENT '商品id',
                                 `order_id` int(11) DEFAULT NULL COMMENT '订单id',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bfqdpz`;

CREATE TABLE `sys_bfqdpz` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '拜访签到拍照id',
                            `mid` int(11) NOT NULL COMMENT '业务员id',
                            `cid` int(11) NOT NULL COMMENT '客户id',
                            `longitude` varchar(50) DEFAULT NULL COMMENT '经度',
                            `latitude` varchar(50) DEFAULT NULL COMMENT '纬度',
                            `address` varchar(100) DEFAULT NULL COMMENT '地址',
                            `hbzt` varchar(50) DEFAULT NULL COMMENT '及时更换外观破损，肮脏的海报招贴',
                            `ggyy` varchar(50) DEFAULT NULL COMMENT '拆除过时的附有旧广告用语的宣传品',
                            `is_xy` varchar(2) DEFAULT NULL COMMENT '是否显眼（1有，2无）',
                            `remo` varchar(300) DEFAULT NULL COMMENT '摘要',
                            `qddate` varchar(20) DEFAULT NULL COMMENT '签到日期',
                            `qdtime` varchar(20) DEFAULT NULL COMMENT '签到时间',
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bfsdhjc`;

CREATE TABLE `sys_bfsdhjc` (
                             `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '生动化检查id',
                             `mid` int(11) NOT NULL COMMENT '业务员id',
                             `cid` int(11) NOT NULL COMMENT '客户id',
                             `pophb` varchar(50) DEFAULT NULL COMMENT 'POP海报',
                             `cq` varchar(50) DEFAULT NULL COMMENT '串旗',
                             `wq` varchar(50) DEFAULT NULL COMMENT '围裙',
                             `remo1` varchar(300) DEFAULT NULL COMMENT '生动化摘要',
                             `is_xy` varchar(2) DEFAULT NULL COMMENT '是否显眼（1有；2无）',
                             `remo2` varchar(300) DEFAULT NULL COMMENT '堆头摘要',
                             `sddate` varchar(20) NOT NULL COMMENT '日期',
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bfxg_pic`;

CREATE TABLE `sys_bfxg_pic` (
                              `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
                              `ss_id` int(11) NOT NULL COMMENT '所属板块id',
                              `xx_id` int(11) DEFAULT NULL COMMENT '详细id',
                              `type` int(2) NOT NULL COMMENT '1拜访签到拍照；2生动化；3堆头；4陈列检查采集；5道谢并告知下次拜访日期',
                              `pic_mini` varchar(255) NOT NULL COMMENT '小图',
                              `pic` varchar(255) NOT NULL COMMENT '大图',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_bfxsxj`;

CREATE TABLE `sys_bfxsxj` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '销售小结id',
                            `mid` int(11) NOT NULL COMMENT '业务员id',
                            `cid` int(11) NOT NULL COMMENT '客户id',
                            `wid` int(11) NOT NULL COMMENT '商品id',
                            `dh_num` int(10) DEFAULT NULL COMMENT '到货量',
                            `sx_num` int(10) DEFAULT NULL COMMENT '实销量',
                            `kc_num` int(10) DEFAULT NULL COMMENT '库存量',
                            `dd_num` int(10) DEFAULT NULL COMMENT '订单数',
                            `xstp` varchar(20) DEFAULT NULL COMMENT '售销类型',
                            `remo` varchar(100) DEFAULT NULL COMMENT '备注',
                            `xjdate` varchar(20) NOT NULL COMMENT '日期',
                            `xxd` int(5) DEFAULT '0' COMMENT '新鲜度',
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_brand`;

CREATE TABLE `sys_brand` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `name` varchar(50) NOT NULL COMMENT '名称',
                           `remark` varchar(50) DEFAULT NULL COMMENT '注备',
                           `status` int(2) DEFAULT '1' COMMENT '是否生效（1是；0否）',
                           `plat_id` varchar(50) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_chain_store`;

CREATE TABLE `sys_chain_store` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `store_name` varchar(50) DEFAULT NULL,
                                 `remark` varchar(50) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_chat_msg`;

CREATE TABLE `sys_chat_msg` (
                              `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
                              `member_id` int(11) DEFAULT NULL COMMENT '发送人id',
                              `receive_id` int(11) NOT NULL COMMENT '接收人id',
                              `addtime` varchar(20) NOT NULL COMMENT '发表时间',
                              `msg_tp` char(1) DEFAULT NULL COMMENT '发表类型1.文字2.图片3.语音',
                              `msg` text COMMENT '发表内容',
                              `voice_time` int(200) DEFAULT NULL,
                              `longitude` double DEFAULT NULL,
                              `latitude` double DEFAULT NULL,
                              `tp` varchar(10) NOT NULL,
                              `belong_id` int(11) DEFAULT NULL COMMENT '对应id（如添加圈主题对应圈id）',
                              `belong_nm` varchar(100) DEFAULT NULL COMMENT '对应名字（如圈聊天对应圈名称）',
                              `belong_msg` varchar(255) DEFAULT NULL COMMENT '对应更多信息（如圈聊天存放圈头像）',
                              `msg_id` int(11) DEFAULT NULL COMMENT '对应其他完整表的msgid',
                              PRIMARY KEY (`id`),
                              KEY `member_idcm_cons` (`member_id`),
                              KEY `member_idcma_cons` (`receive_id`),
                              CONSTRAINT `member_idcm_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_checkin`;

CREATE TABLE `sys_checkin` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `psn_id` int(11) NOT NULL COMMENT '人员ID',
                             `check_time` varchar(50) NOT NULL COMMENT '签到时间',
                             `job_content` varchar(500) NOT NULL COMMENT '工作内容',
                             `location` varchar(255) NOT NULL COMMENT '位置',
                             `remark` varchar(100) DEFAULT NULL COMMENT '位置备注',
                             `tp` varchar(10) DEFAULT NULL COMMENT '1 考勤 2 外出反馈',
                             `longitude` double DEFAULT NULL,
                             `latitude` double DEFAULT NULL,
                             `cdzt` varchar(20) DEFAULT NULL COMMENT '迟到/早退',
                             `sb_type` int(11) DEFAULT NULL COMMENT '上报方式 1:永不上报；2：始终上报',
                             PRIMARY KEY (`id`),
                             KEY `member_idck_cons` (`psn_id`),
                             CONSTRAINT `member_idck_cons` FOREIGN KEY (`psn_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_checkin_pic`;

CREATE TABLE `sys_checkin_pic` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `checkin_id` int(11) DEFAULT NULL COMMENT '签到id',
                                 `pic` varchar(255) DEFAULT NULL COMMENT '图片',
                                 `pic_mini` varchar(255) DEFAULT NULL COMMENT '小图片',
                                 PRIMARY KEY (`id`),
                                 KEY `member_idckp_cons` (`checkin_id`),
                                 CONSTRAINT `member_idckp_cons` FOREIGN KEY (`checkin_id`) REFERENCES `sys_checkin` (`id`) ON DELETE CASCADE,
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_cljccj_md`;

CREATE TABLE `sys_cljccj_md` (
                               `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '陈列检查采集模板id',
                               `md_nm` varchar(20) NOT NULL COMMENT '名称',
                               `is_hjpms` int(2) NOT NULL DEFAULT '1' COMMENT '货架排面数（1显示；2不显示）',
                               `is_djpms` int(2) NOT NULL DEFAULT '1' COMMENT '端架排面数（1显示；2不显示）',
                               `is_sytwl` int(2) NOT NULL DEFAULT '1' COMMENT '收银台围栏（1显示；2不显示）',
                               `is_bds` int(2) NOT NULL DEFAULT '1' COMMENT '冰点数（1显示；2不显示）',
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_company_join`;

CREATE TABLE `sys_company_join` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `member_id` int(11) NOT NULL COMMENT '申请人id',
                                  `member_mobile` varchar(50) DEFAULT NULL COMMENT '申请人手机号',
                                  `member_name` varchar(50) DEFAULT NULL,
                                  `create_time` varchar(50) DEFAULT NULL COMMENT '申请时间',
                                  `status` int(11) DEFAULT NULL COMMENT '申请状态',
                                  `user_id` int(11) DEFAULT NULL COMMENT '操作人id',
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_config`;

CREATE TABLE `sys_config` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `code` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                            `fd_model` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                            `status` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                            `system_id` varchar(36) DEFAULT NULL COMMENT '平台对应 id',
                            `system_group_code` varchar(50) DEFAULT NULL COMMENT '平台对应 group code',
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer`;

CREATE TABLE `sys_customer` (
                              `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '客户id',
                              `kh_code` varchar(10) CHARACTER SET utf8 DEFAULT NULL COMMENT '编码',
                              `kh_nm` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                              `kh_tp` int(2) DEFAULT NULL COMMENT '客户种类（1经销商；2客户）',
                              `erp_code` varchar(10) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ERP编码',
                              `qdtp_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '渠道类型',
                              `sctp_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '市场类型',
                              `khdj_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '客户等级',
                              `bfpc_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '拜访频次',
                              `xsjd_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '销售阶段',
                              `ghtp_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '供货类型',
                              `bffl_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '拜访分类',
                              `zhfs_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '合作方式',
                              `kh_pid` int(11) DEFAULT NULL COMMENT '供货经销商',
                              `linkman` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '联系人',
                              `tel` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                              `mobile` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                              `mobile_cx` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '手机支持彩信',
                              `qq` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT 'QQ',
                              `wx_code` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '微信',
                              `is_yx` varchar(2) CHARACTER SET utf8 DEFAULT '1' COMMENT '是否有效(1有效；其他无效)',
                              `open_date` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '开户日期',
                              `close_date` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                              `is_open` varchar(2) CHARACTER SET utf8 DEFAULT '1' COMMENT '是否开户(1是；其他否)',
                              `sh_zt` varchar(10) CHARACTER SET utf8 DEFAULT '待审核' COMMENT '审核状态(待审核；审核通过；审核不通过)',
                              `sh_mid` int(11) DEFAULT NULL COMMENT '审核人id',
                              `sh_time` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '审核时间',
                              `province` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '省',
                              `city` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '市',
                              `area` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '区县',
                              `address` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '地址',
                              `longitude` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '经度',
                              `latitude` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '纬度',
                              `remo` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注',
                              `mem_id` int(11) DEFAULT NULL COMMENT '业务员id',
                              `branch_id` int(11) DEFAULT NULL COMMENT '部门id',
                              `jxsfl_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '经销商分类',
                              `jxsjb_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '经销商级别',
                              `jxszt_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '经销商状态',
                              `wl_id` int(11) DEFAULT NULL COMMENT '物流公司id',
                              `fman` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '负责人/法人',
                              `ftel` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '负责人电话',
                              `jyfw` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '经营范围',
                              `fgqy` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '覆盖区域',
                              `nxse` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '年销售额',
                              `ckmj` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '仓库面积',
                              `dlqtpl` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT '代理其他品类',
                              `dlqtpp` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT '代理其他品牌',
                              `create_time` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '创建时间',
                              `hzfs_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '合作方式',
                              `scbf_date` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '上次拜访日期',
                              `is_db` int(2) DEFAULT '2' COMMENT '是否倒闭（1是；2否）',
                              `py` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `is_ep` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                              `usc_code` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `ep_Customer_Id` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `ep_Customer_Name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `region_id` int(11) DEFAULT NULL,
                              `org_emp_id` int(11) DEFAULT NULL,
                              `org_emp_nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `industry_Id` int(11) DEFAULT NULL,
                              `industry_nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `law_address` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `often_address` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `send_address2` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                              `rz_mobile` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
                              `rz_state` int(10) DEFAULT NULL,
                              `qdtype_id` int(11) DEFAULT NULL,
                              `khlevel_id` int(11) DEFAULT NULL,
                              `shop_id` int(11) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_fee`;

CREATE TABLE `sys_customer_fee` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `kh_id` int(11) DEFAULT NULL,
                                  `fee` decimal(10, 2) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_hzfs`;

CREATE TABLE `sys_customer_hzfs` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `hzfs_nm` varchar(50) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_import_main`;

CREATE TABLE `sys_customer_import_main` (
                                          `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
                                          `title` varchar(100) DEFAULT NULL COMMENT '标题',
                                          `import_time` datetime NOT NULL COMMENT '报表日期',
                                          `oper_id` int(11) NOT NULL,
                                          `oper_name` varchar(20) NOT NULL COMMENT '操作员',
                                          PRIMARY KEY (`id`),
                                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_import_sub`;

CREATE TABLE `sys_customer_import_sub` (
                                         `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '客户id',
                                         `kh_code` varchar(10) DEFAULT NULL COMMENT '编码',
                                         `kh_nm` varchar(100) DEFAULT NULL,
                                         `kh_tp` int(11) DEFAULT NULL COMMENT '客户种类（1经销商；2客户）',
                                         `erp_code` varchar(10) DEFAULT NULL COMMENT 'erp编码',
                                         `qdtp_nm` varchar(20) DEFAULT NULL COMMENT '渠道类型',
                                         `sctp_nm` varchar(20) DEFAULT NULL COMMENT '市场类型',
                                         `khdj_nm` varchar(20) DEFAULT NULL COMMENT '客户等级',
                                         `bfpc_nm` varchar(20) DEFAULT NULL COMMENT '拜访频次',
                                         `xsjd_nm` varchar(20) DEFAULT NULL COMMENT '销售阶段',
                                         `ghtp_nm` varchar(20) DEFAULT NULL COMMENT '供货类型',
                                         `bffl_nm` varchar(20) DEFAULT NULL COMMENT '拜访分类',
                                         `zhfs_nm` varchar(20) DEFAULT NULL COMMENT '合作方式',
                                         `kh_pid` int(11) DEFAULT NULL COMMENT '供货经销商',
                                         `linkman` varchar(20) DEFAULT NULL COMMENT '联系人',
                                         `tel` varchar(100) DEFAULT NULL,
                                         `mobile` varchar(100) DEFAULT NULL,
                                         `mobile_cx` varchar(20) DEFAULT NULL COMMENT '手机支持彩信',
                                         `qq` varchar(20) DEFAULT NULL COMMENT 'qq',
                                         `wx_code` varchar(20) DEFAULT NULL COMMENT '微信',
                                         `is_yx` varchar(2) DEFAULT '1' COMMENT '是否有效(1有效；其他无效)',
                                         `open_date` varchar(20) DEFAULT NULL COMMENT '开户日期',
                                         `close_date` varchar(20) DEFAULT NULL,
                                         `is_open` varchar(2) DEFAULT '1' COMMENT '是否开户(1是；其他否)',
                                         `sh_zt` varchar(10) DEFAULT '待审核' COMMENT '审核状态(待审核；审核通过；审核不通过)',
                                         `sh_mid` int(11) DEFAULT NULL COMMENT '审核人id',
                                         `sh_time` varchar(20) DEFAULT NULL COMMENT '审核时间',
                                         `province` varchar(20) DEFAULT NULL COMMENT '省',
                                         `city` varchar(20) DEFAULT NULL COMMENT '市',
                                         `area` varchar(20) DEFAULT NULL COMMENT '区县',
                                         `address` varchar(100) DEFAULT NULL COMMENT '地址',
                                         `longitude` varchar(50) DEFAULT NULL COMMENT '经度',
                                         `latitude` varchar(50) DEFAULT NULL COMMENT '纬度',
                                         `remo` varchar(100) DEFAULT NULL COMMENT '备注',
                                         `mem_id` int(11) DEFAULT NULL COMMENT '业务员id',
                                         `branch_id` int(11) DEFAULT NULL COMMENT '部门id',
                                         `jxsfl_nm` varchar(20) DEFAULT NULL COMMENT '经销商分类',
                                         `jxsjb_nm` varchar(20) DEFAULT NULL COMMENT '经销商级别',
                                         `jxszt_nm` varchar(20) DEFAULT NULL COMMENT '经销商状态',
                                         `wl_id` int(11) DEFAULT NULL COMMENT '物流公司id',
                                         `fman` varchar(20) DEFAULT NULL COMMENT '负责人/法人',
                                         `ftel` varchar(20) DEFAULT NULL COMMENT '负责人电话',
                                         `jyfw` varchar(20) DEFAULT NULL COMMENT '经营范围',
                                         `fgqy` varchar(20) DEFAULT NULL COMMENT '覆盖区域',
                                         `nxse` varchar(20) DEFAULT NULL COMMENT '年销售额',
                                         `ckmj` varchar(20) DEFAULT NULL COMMENT '仓库面积',
                                         `dlqtpl` varchar(200) DEFAULT NULL COMMENT '代理其他品类',
                                         `dlqtpp` varchar(200) DEFAULT NULL COMMENT '代理其他品牌',
                                         `create_time` varchar(20) DEFAULT NULL COMMENT '创建时间',
                                         `hzfs_nm` varchar(20) DEFAULT NULL COMMENT '合作方式',
                                         `scbf_date` varchar(20) DEFAULT NULL COMMENT '上次拜访日期',
                                         `is_db` int(11) DEFAULT '2' COMMENT '是否倒闭（1是；2否）',
                                         `py` varchar(50) DEFAULT NULL,
                                         `is_ep` varchar(20) DEFAULT NULL,
                                         `usc_code` varchar(50) DEFAULT NULL,
                                         `ep_customer_id` varchar(50) DEFAULT NULL,
                                         `ep_customer_name` varchar(50) DEFAULT NULL,
                                         `region_id` int(11) DEFAULT NULL,
                                         `org_emp_id` int(11) DEFAULT NULL,
                                         `org_emp_nm` varchar(50) DEFAULT NULL,
                                         `industry_id` int(11) DEFAULT NULL,
                                         `industry_nm` varchar(50) DEFAULT NULL,
                                         `law_address` varchar(50) DEFAULT NULL,
                                         `often_address` varchar(50) DEFAULT NULL,
                                         `send_address2` varchar(50) DEFAULT NULL,
                                         `rz_mobile` varchar(30) DEFAULT NULL,
                                         `rz_state` int(11) DEFAULT NULL,
                                         `cst_id` int(11) DEFAULT NULL,
                                         `mast_id` int(11) DEFAULT NULL,
                                         PRIMARY KEY (`id`),
                                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_level_price`;

CREATE TABLE `sys_customer_level_price` (
                                          `id` int(11) NOT NULL AUTO_INCREMENT,
                                          `level_id` int(11) DEFAULT NULL,
                                          `ware_id` int(11) DEFAULT NULL,
                                          `price` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
                                          `status` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
                                          `ls_price` decimal(10, 2) DEFAULT NULL,
                                          `fx_price` decimal(10, 2) DEFAULT NULL,
                                          `cx_price` decimal(10, 2) DEFAULT NULL,
                                          `sunit_price` decimal(10, 2) DEFAULT NULL,
                                          `min_ls_price` decimal(10, 2) DEFAULT NULL,
                                          `min_fx_price` decimal(10, 2) DEFAULT NULL,
                                          `min_cx_price` decimal(10, 2) DEFAULT NULL,
                                          `rate` decimal(11, 2) DEFAULT NULL,
                                          PRIMARY KEY (`id`),
                                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_level_rate`;

CREATE TABLE `sys_customer_level_rate` (
                                         `id` int(11) NOT NULL AUTO_INCREMENT,
                                         `rela_id` int(11) DEFAULT NULL,
                                         `waretype_id` int(11) DEFAULT NULL,
                                         `rate` decimal(11, 2) DEFAULT NULL,
                                         `status` int(11) DEFAULT NULL,
                                         PRIMARY KEY (`id`),
                                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_level_tc_factor`;

CREATE TABLE `sys_customer_level_tc_factor` (
                                              `id` int(11) NOT NULL AUTO_INCREMENT,
                                              `level_id` int(11) DEFAULT NULL,
                                              `ware_id` int(11) DEFAULT NULL,
                                              `status` varchar(10) DEFAULT NULL,
                                              `sale_qty_tc` decimal(10, 2) DEFAULT NULL,
                                              `sale_pro_tc` decimal(10, 2) DEFAULT NULL,
                                              `sale_gro_tc` decimal(10, 2) DEFAULT NULL,
                                              `sunit_price` decimal(10, 2) DEFAULT NULL,
                                              `sale_qty_tc_rate` decimal(10, 2) DEFAULT NULL,
                                              `sale_pro_tc_rate` decimal(10, 2) DEFAULT NULL,
                                              `sale_gro_tc_rate` decimal(10, 2) DEFAULT NULL,
                                              PRIMARY KEY (`id`),
                                              KEY `cus_level_tc_factor_rela_id` (`level_id`),
                                              KEY `cus_level_tc_factor_ware_id` (`ware_id`),
                                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_level_tc_rate`;

CREATE TABLE `sys_customer_level_tc_rate` (
                                            `id` int(11) NOT NULL AUTO_INCREMENT,
                                            `rela_id` int(11) DEFAULT NULL,
                                            `waretype_id` int(11) DEFAULT NULL,
                                            `sale_qty_tc_rate` decimal(11, 2) DEFAULT NULL,
                                            `status` int(11) DEFAULT NULL,
                                            `sale_pro_tc_rate` decimal(11, 2) DEFAULT NULL,
                                            `sale_gro_tc_rate` varchar(11) DEFAULT NULL,
                                            `sale_qty_tc` decimal(11, 2) DEFAULT NULL,
                                            `sale_pro_tc` decimal(11, 2) DEFAULT NULL,
                                            `sale_gro_tc` decimal(11, 2) DEFAULT NULL,
                                            PRIMARY KEY (`id`),
                                            KEY `cus_level_tc_rate_rela_id` (`rela_id`),
                                            KEY `cus_level_tc_rate_waretypeId` (`waretype_id`),
                                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_pic`;

CREATE TABLE `sys_customer_pic` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
                                  `pic_mini` varchar(255) NOT NULL COMMENT '小图',
                                  `pic` varchar(255) NOT NULL COMMENT '大图',
                                  `customer_id` int(11) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_price`;

CREATE TABLE `sys_customer_price` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
                                    `ware_id` int(11) NOT NULL COMMENT '商品ID',
                                    `customer_id` int(11) NOT NULL COMMENT '客户ID',
                                    `sale_amt` double(8, 2) NOT NULL DEFAULT '0.00' COMMENT '销售价格',
                                    `ls_price` decimal(10, 2) DEFAULT NULL,
                                    `fx_price` decimal(10, 2) DEFAULT NULL,
                                    `cx_price` decimal(10, 2) DEFAULT NULL,
                                    `sunit_price` decimal(10, 2) DEFAULT NULL,
                                    `min_ls_price` decimal(10, 2) DEFAULT NULL,
                                    `min_fx_price` decimal(10, 2) DEFAULT NULL,
                                    `min_cx_price` decimal(10, 2) DEFAULT NULL,
                                    `max_his_pf_price` decimal(10, 2) DEFAULT NULL,
                                    `max_his_pf_prices` varchar(200) DEFAULT NULL,
                                    `min_his_pf_price` decimal(10, 2) DEFAULT NULL,
                                    `min_his_pf_prices` varchar(100) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    KEY `sys_customer_price_index_02` (`customer_id`),
                                    KEY `sys_customer_price_index_01` (`ware_id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_sale_price`;

CREATE TABLE `sys_customer_sale_price` (
                                         `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
                                         `ware_id` int(11) NOT NULL COMMENT '商品ID',
                                         `customer_id` int(11) NOT NULL COMMENT '客户ID',
                                         `tc_amt` double(8, 2) NOT NULL DEFAULT '0.00' COMMENT '提成价格',
                                         PRIMARY KEY (`id`),
                                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_tmp`;

CREATE TABLE `sys_customer_tmp` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `kh_nm` varchar(100) DEFAULT NULL COMMENT '客户名称',
                                  `linkman` varchar(20) DEFAULT NULL COMMENT '联系人',
                                  `tel` varchar(100) DEFAULT NULL COMMENT '电话',
                                  `mobile` varchar(100) DEFAULT NULL COMMENT '手机',
                                  `address` varchar(255) DEFAULT NULL COMMENT '地址',
                                  `longitude` varchar(50) DEFAULT '0' COMMENT '经度',
                                  `latitude` varchar(50) DEFAULT '0' COMMENT '纬度',
                                  `mem_id` int(11) DEFAULT NULL COMMENT '业务员id',
                                  `branch_id` int(11) DEFAULT NULL COMMENT '部门id',
                                  `create_time` varchar(20) DEFAULT NULL,
                                  `py` varchar(50) DEFAULT NULL COMMENT '拼音',
                                  `is_db` varchar(11) DEFAULT NULL COMMENT '是否倒闭0否，1是',
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_customer_ware_price`;

CREATE TABLE `sys_customer_ware_price` (
                                         `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
                                         `ware_id` int(11) NOT NULL COMMENT '商品ID',
                                         `customer_id` int(11) NOT NULL COMMENT '客户ID',
                                         `tran_amt` double(8, 2) NOT NULL DEFAULT '0.00' COMMENT '运输价格',
                                         PRIMARY KEY (`id`),
                                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_depart`;

CREATE TABLE `sys_depart` (
                            `branch_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分组ID',
                            `branch_name` varchar(50) NOT NULL COMMENT '分组名称',
                            `parent_id` int(11) DEFAULT NULL COMMENT '父结点ID',
                            `branch_memo` varchar(100) DEFAULT NULL COMMENT '备注',
                            `branch_leaf` char(2) DEFAULT NULL COMMENT '末级分类',
                            `branch_path` varchar(50) DEFAULT NULL COMMENT '路径',
                            `sw_sb` varchar(10) DEFAULT '08:00' COMMENT '上午上班时间',
                            `sw_xb` varchar(10) DEFAULT '12:00' COMMENT '上午下班时间',
                            `xw_sb` varchar(10) DEFAULT '14:00' COMMENT '下午上班时间',
                            `xw_xb` varchar(10) DEFAULT '19:00' COMMENT '下午下班时间',
                            PRIMARY KEY (`branch_id`, `branch_name`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_deptmempower`;

CREATE TABLE `sys_deptmempower` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `dept_id` int(11) NOT NULL COMMENT '部门id',
                                  `member_id` int(11) NOT NULL COMMENT '成员id',
                                  `tp` varchar(2) NOT NULL DEFAULT '1' COMMENT '类型（1可见 2 不可见）',
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4' COMMENT '设置成员的部门权限(可见不可见)';

DROP TABLE IF EXISTS `sys_fixed_customer_price`;

CREATE TABLE `sys_fixed_customer_price` (
                                          `id` int(11) NOT NULL AUTO_INCREMENT,
                                          `fixed_id` int(11) DEFAULT NULL,
                                          `customer_id` int(11) DEFAULT NULL,
                                          `price` decimal(10, 2) DEFAULT NULL,
                                          `status` varchar(10) DEFAULT NULL,
                                          PRIMARY KEY (`id`),
                                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_fixed_field`;

CREATE TABLE `sys_fixed_field` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `name` varchar(50) DEFAULT NULL,
                                 `fd_model` varchar(100) DEFAULT NULL,
                                 `status` varchar(10) DEFAULT '1',
                                 `fd_way` varchar(2) DEFAULT '00',
                                 `fd_code` varchar(20) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_import_temp`;

CREATE TABLE `sys_import_temp` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `title_json` text NOT NULL COMMENT '标题JSON',
                                 `title` varchar(255) DEFAULT NULL COMMENT '标题',
                                 `save_date` datetime DEFAULT NULL COMMENT '保存时间',
                                 `update_date` datetime DEFAULT NULL COMMENT '修改时间',
                                 `type` int(11) NOT NULL DEFAULT '1' COMMENT '类型',
                                 `oper_id` int(11) NOT NULL COMMENT '操作人ID',
                                 `oper_name` varchar(20) NOT NULL COMMENT '操作员',
                                 `input_down` int(11) DEFAULT '0' COMMENT '导入0或导出数据1',
                                 `status` int(11) DEFAULT '0' COMMENT '导入状态0待导入,1导入成功',
                                 `success_date` datetime DEFAULT NULL COMMENT '成功导入时间',
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_import_temp_item`;

CREATE TABLE `sys_import_temp_item` (
                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                      `import_id` int(11) DEFAULT NULL COMMENT '导入临时表ID',
                                      `context_json` text COMMENT '内容JSON',
                                      `import_status` int(11) DEFAULT '0' COMMENT '导入状态:0未成功,1成功',
                                      `import_success_date` datetime DEFAULT NULL COMMENT '成功导入时间',
                                      PRIMARY KEY (`id`),
                                      tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_jxsfl`;

CREATE TABLE `sys_jxsfl` (
                           `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '经销商分类id',
                           `coding` varchar(10) DEFAULT NULL COMMENT '编号',
                           `fl_nm` varchar(50) NOT NULL COMMENT '名称',
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_jxsjb`;

CREATE TABLE `sys_jxsjb` (
                           `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '经销商级别id',
                           `coding` varchar(10) DEFAULT NULL COMMENT '编号',
                           `jb_nm` varchar(50) NOT NULL COMMENT '名称',
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_jxszt`;

CREATE TABLE `sys_jxszt` (
                           `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '经销商状态id',
                           `coding` varchar(10) DEFAULT NULL COMMENT '编号',
                           `zt_nm` varchar(50) NOT NULL COMMENT '名称',
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_khfbsz`;

CREATE TABLE `sys_khfbsz` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
                            `snums` int(5) NOT NULL COMMENT '开始分钟',
                            `enums` int(5) NOT NULL COMMENT '结束分钟',
                            `ysz` varchar(10) NOT NULL COMMENT '颜色值',
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_khlevel`;

CREATE TABLE `sys_khlevel` (
                             `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '客户等级id',
                             `qd_id` int(11) NOT NULL COMMENT '渠道id',
                             `coding` varchar(10) DEFAULT NULL COMMENT '编码',
                             `khdj_nm` varchar(50) NOT NULL COMMENT '名称',
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_mem`;

CREATE TABLE `sys_mem` (
                         `member_id` int(11) NOT NULL,
                         `member_nm` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '姓名',
                         `member_name` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '账号',
                         `email` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '邮箱',
                         `sex` char(1) CHARACTER SET utf8 DEFAULT NULL COMMENT '性别1:男2:女',
                         `member_mobile` varchar(20) CHARACTER SET utf8 NOT NULL COMMENT '手机号码',
                         `member_pwd` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT 'e10adc3949ba59abbe56e057f20f883e' COMMENT '密码',
                         `member_job` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '职业',
                         `member_trade` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '行业',
                         `member_head` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '头像',
                         `member_fans` int(11) DEFAULT '0' COMMENT '圈友数',
                         `member_attentions` int(11) DEFAULT '0' COMMENT '关注数',
                         `member_blacklist` int(11) DEFAULT '0' COMMENT '黑名单数',
                         `member_hometown` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '家乡',
                         `member_graduated` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '毕业院校',
                         `member_company` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '企业',
                         `member_desc` varchar(1000) CHARACTER SET utf8 DEFAULT NULL COMMENT '简介',
                         `member_activate` char(1) CHARACTER SET utf8 DEFAULT '1',
                         `member_activatime` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                         `member_use` char(1) CHARACTER SET utf8 DEFAULT '1' COMMENT '使用状态(1-使用0-禁用)',
                         `member_creator` int(11) DEFAULT NULL COMMENT '创建人',
                         `member_creatime` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '创建时间',
                         `member_logintime` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '最近登录时间',
                         `member_loginnum` int(11) DEFAULT '0' COMMENT '登录次数',
                         `sms_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '短信验证码',
                         `is_admin` char(1) CHARACTER SET utf8 DEFAULT NULL COMMENT '是否超级管理员:1.是0.否',
                         `is_unitmng` char(1) CHARACTER SET utf8 DEFAULT NULL COMMENT '0.普通成员1.单位超级管理员 2.单位管理员 ',
                         `unit_id` int(11) DEFAULT NULL,
                         `first_char` char(2) CHARACTER SET utf8 DEFAULT NULL COMMENT '首字母',
                         `branch_id` int(11) DEFAULT NULL COMMENT '所属分组ID',
                         `score` int(11) DEFAULT NULL COMMENT '积分',
                         `is_lead` char(1) CHARACTER SET utf8 DEFAULT '2' COMMENT '否是领导1，是；2否。',
                         `state` char(1) CHARACTER SET utf8 NOT NULL DEFAULT '2' COMMENT '免打扰状态 1：是 2：否',
                         `msgmodel` char(1) CHARACTER SET utf8 NOT NULL DEFAULT '1',
                         `un_id` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '唯一码',
                         `cid` int(11) DEFAULT '0' COMMENT '客户id',
                         `id_key` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                         `use_dog` int(2) DEFAULT NULL,
                         `is_customer_service` int(11) DEFAULT '0' COMMENT '是否客服,0不是客服，1是客服',
                         `rz_mobile` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
                         `rz_state` int(10) DEFAULT NULL,
                         `update_date` datetime DEFAULT NULL,
                         `is_del` char(1) DEFAULT NULL COMMENT '删除标记 1已删除 ',
                         PRIMARY KEY (`member_id`),
                         UNIQUE `member_mobile` (`member_mobile`),
                         KEY `branch_idm_cons` (`branch_id`),
                         CONSTRAINT `branch_idm_cons` FOREIGN KEY (`branch_id`) REFERENCES `sys_depart` (`branch_id`) ON DELETE CASCADE,
                         tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4' COMMENT '部门成员表';

DROP TABLE IF EXISTS `sys_member_import_main`;

CREATE TABLE `sys_member_import_main` (
                                        `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
                                        `title` varchar(100) DEFAULT NULL COMMENT '标题',
                                        `import_time` datetime NOT NULL COMMENT '报表日期',
                                        `oper_id` int(11) NOT NULL,
                                        `oper_name` varchar(20) DEFAULT NULL COMMENT '操作员',
                                        PRIMARY KEY (`id`),
                                        tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_member_import_sub`;

CREATE TABLE `sys_member_import_sub` (
                                       `member_id` int(11) NOT NULL,
                                       `member_nm` varchar(20) DEFAULT NULL COMMENT '姓名',
                                       `member_name` varchar(20) DEFAULT NULL COMMENT '账号',
                                       `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
                                       `sex` char(1) DEFAULT NULL COMMENT '性别1:男2:女',
                                       `member_mobile` varchar(20) NOT NULL COMMENT '手机号码',
                                       `member_pwd` varchar(50) NOT NULL DEFAULT 'e10adc3949ba59abbe56e057f20f883e' COMMENT '密码',
                                       `member_job` varchar(100) DEFAULT NULL COMMENT '职业',
                                       `member_trade` varchar(100) DEFAULT NULL COMMENT '行业',
                                       `member_head` varchar(255) DEFAULT NULL COMMENT '头像',
                                       `member_fans` int(11) DEFAULT '0' COMMENT '圈友数',
                                       `member_attentions` int(11) DEFAULT '0' COMMENT '关注数',
                                       `member_blacklist` int(11) DEFAULT '0' COMMENT '黑名单数',
                                       `member_hometown` varchar(100) DEFAULT NULL COMMENT '家乡',
                                       `member_graduated` varchar(50) DEFAULT NULL COMMENT '毕业院校',
                                       `member_company` varchar(50) DEFAULT NULL COMMENT '企业',
                                       `member_desc` varchar(1000) DEFAULT NULL COMMENT '简介',
                                       `member_activate` char(1) DEFAULT '1',
                                       `member_activatime` varchar(20) DEFAULT NULL,
                                       `member_use` char(1) DEFAULT '1' COMMENT '使用状态(1-使用0-禁用)',
                                       `member_creator` int(11) DEFAULT NULL COMMENT '创建人',
                                       `member_creatime` varchar(20) DEFAULT NULL COMMENT '创建时间',
                                       `member_logintime` varchar(20) DEFAULT NULL COMMENT '最近登录时间',
                                       `member_loginnum` int(11) DEFAULT '0' COMMENT '登录次数',
                                       `sms_no` varchar(50) DEFAULT NULL COMMENT '短信验证码',
                                       `is_admin` char(1) DEFAULT NULL COMMENT '是否超级管理员:1.是0.否',
                                       `is_unitmng` char(1) DEFAULT NULL COMMENT '0.普通成员1.单位超级管理员 2.单位管理员 ',
                                       `unit_id` int(11) DEFAULT NULL,
                                       `first_char` char(1) DEFAULT NULL COMMENT '首字母',
                                       `branch_id` int(11) DEFAULT NULL COMMENT '所属分组id',
                                       `score` int(11) DEFAULT NULL COMMENT '积分',
                                       `is_lead` char(1) DEFAULT '2' COMMENT '否是领导1，是；2否。',
                                       `state` char(1) NOT NULL DEFAULT '2' COMMENT '免打扰状态 1：是 2：否',
                                       `msgmodel` char(1) NOT NULL DEFAULT '1',
                                       `un_id` varchar(50) DEFAULT NULL COMMENT '唯一码',
                                       `cid` int(11) DEFAULT '0' COMMENT '客户id',
                                       `id_key` varchar(50) DEFAULT NULL,
                                       `use_dog` int(11) DEFAULT NULL,
                                       `is_customer_service` int(11) DEFAULT '0' COMMENT '是否客服,0不是客服，1是客服',
                                       `rz_mobile` varchar(30) DEFAULT NULL,
                                       `rz_state` int(11) DEFAULT NULL,
                                       `mast_id` int(11) DEFAULT NULL,
                                       PRIMARY KEY (`member_id`),
                                       tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_member_msg_subscribe`;

CREATE TABLE `sys_member_msg_subscribe` (
                                          `id` int(11) NOT NULL AUTO_INCREMENT,
                                          `sys_subject_id` int(11) DEFAULT NULL COMMENT '消息体id，在主数据中',
                                          `member_id` int(11) DEFAULT NULL COMMENT '订阅会员id',
                                          `push_notice` int(11) DEFAULT '0' COMMENT '推送订阅：0否1是',
                                          `mobile_notice` int(11) DEFAULT '0' COMMENT '手机内容订阅：0否1是',
                                          `email_notice` int(11) DEFAULT '0' COMMENT '邮箱内容 订阅：0否1是',
                                          `wx_notice` int(11) DEFAULT '0' COMMENT '微信通知内容订阅：0否1是',
                                          PRIMARY KEY (`id`),
                                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_menu_apply`;

CREATE TABLE `sys_menu_apply` (
                                `id` int(11) NOT NULL COMMENT '自增id',
                                `apply_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '应用/菜单名称',
                                `apply_code` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '应用/菜单编码',
                                `apply_icon` varchar(255) DEFAULT NULL COMMENT '应用图标/菜单样式',
                                `apply_desc` text CHARACTER SET utf8 COMMENT '应用描述',
                                `apply_ifwap` char(1) CHARACTER SET utf8 DEFAULT NULL COMMENT '应用类型 0结尾-原生 1结尾-wap',
                                `apply_url` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT 'URL访问地址/菜单连接地址',
                                `apply_no` int(3) DEFAULT NULL COMMENT '排序/菜单排序',
                                `p_id` int(11) DEFAULT NULL COMMENT '父级应用',
                                `menu_tp` varchar(2) CHARACTER SET utf8 DEFAULT NULL COMMENT '菜单类型(必填)  0--功能菜单  1-功能按钮（最后一级）',
                                `menu_leaf` varchar(2) CHARACTER SET utf8 DEFAULT NULL COMMENT '是否明细菜单  0--否  1--是',
                                `create_by` int(11) DEFAULT NULL COMMENT '创建者',
                                `create_date` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '创建时间',
                                `is_use` char(1) CHARACTER SET utf8 DEFAULT NULL COMMENT '是否启用 0否 1 是',
                                `tp` varchar(5) NOT NULL COMMENT '类型 1 menu 2 应用',
                                `menu_id` int(11) DEFAULT NULL COMMENT '绑定菜单id',
                                `system_id` varchar(36) DEFAULT NULL COMMENT '关联系统id',
                                `system_no` varchar(50) DEFAULT NULL COMMENT '关联系统编号',
                                PRIMARY KEY (`id`, `tp`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4' COMMENT '菜单/移动端应用表';

DROP TABLE IF EXISTS `sys_oftenuser`;

CREATE TABLE `sys_oftenuser` (
                               `member_id` int(11) NOT NULL COMMENT '用户id',
                               `bind_member_id` int(11) NOT NULL COMMENT '常用联系人',
                               KEY `member_ido_cons` (`member_id`),
                               KEY `member_idob_cons` (`bind_member_id`),
                               CONSTRAINT `member_ido_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                               CONSTRAINT `member_idob_cons` FOREIGN KEY (`bind_member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_print_record`;

CREATE TABLE `sys_print_record` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `fd_source_id` int(11) DEFAULT NULL,
                                  `fd_source_no` varchar(36) DEFAULT NULL,
                                  `create_Id` int(11) DEFAULT NULL,
                                  `create_Name` varchar(36) DEFAULT NULL,
                                  `create_Time` datetime DEFAULT NULL,
                                  `fd_model` varchar(100) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  KEY `sys_print_record_index_01` (`fd_source_id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_qdtype`;

CREATE TABLE `sys_qdtype` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '渠道类型id',
                            `coding` varchar(10) CHARACTER SET utf8 NOT NULL COMMENT '编码',
                            `qdtp_nm` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '名称',
                            `remo` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '注备',
                            `is_sx` int(2) DEFAULT '1' COMMENT '是否生效（1是；2否）',
                            `sxa_date` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '生效日期',
                            `sxe_date` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '失效日期',
                            `rate` decimal(10, 2) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_qd_type_price`;

CREATE TABLE `sys_qd_type_price` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `rela_id` int(11) DEFAULT NULL,
                                   `ware_id` int(11) DEFAULT NULL,
                                   `price` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
                                   `status` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
                                   `ls_price` decimal(10, 2) DEFAULT NULL,
                                   `fx_price` decimal(10, 2) DEFAULT NULL,
                                   `cx_price` decimal(10, 2) DEFAULT NULL,
                                   `sunit_price` decimal(10, 2) DEFAULT NULL,
                                   `min_ls_price` decimal(10, 2) DEFAULT NULL,
                                   `min_fx_price` decimal(10, 2) DEFAULT NULL,
                                   `min_cx_price` decimal(10, 2) DEFAULT NULL,
                                   `rate` decimal(11, 2) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_qd_type_rate`;

CREATE TABLE `sys_qd_type_rate` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `rela_id` int(11) DEFAULT NULL,
                                  `waretype_id` int(11) DEFAULT NULL,
                                  `rate` decimal(11, 2) DEFAULT NULL,
                                  `status` int(11) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_qd_type_tc_factor`;

CREATE TABLE `sys_qd_type_tc_factor` (
                                       `id` int(11) NOT NULL AUTO_INCREMENT,
                                       `rela_id` int(11) DEFAULT NULL,
                                       `ware_id` int(11) DEFAULT NULL,
                                       `status` varchar(10) DEFAULT NULL,
                                       `sale_qty_tc` decimal(10, 2) DEFAULT NULL,
                                       `sale_pro_tc` decimal(10, 2) DEFAULT NULL,
                                       `sale_gro_tc` decimal(10, 2) DEFAULT NULL,
                                       `sunit_price` decimal(10, 2) DEFAULT NULL,
                                       `sale_qty_tc_rate` decimal(10, 2) DEFAULT NULL,
                                       `sale_pro_tc_rate` decimal(10, 2) DEFAULT NULL,
                                       `sale_gro_tc_rate` decimal(10, 2) DEFAULT NULL,
                                       PRIMARY KEY (`id`),
                                       KEY `qd_type_tc_factor_rala_id` (`rela_id`),
                                       KEY `qd_type_tc_factor_ware_id` (`ware_id`),
                                       tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_qd_type_tc_rate`;

CREATE TABLE `sys_qd_type_tc_rate` (
                                     `id` int(11) NOT NULL AUTO_INCREMENT,
                                     `rela_id` int(11) DEFAULT NULL,
                                     `waretype_id` int(11) DEFAULT NULL,
                                     `sale_qty_tc_rate` decimal(11, 2) DEFAULT NULL,
                                     `status` int(11) DEFAULT NULL,
                                     `sale_pro_tc_rate` decimal(11, 2) DEFAULT NULL,
                                     `sale_gro_tc_rate` varchar(11) DEFAULT NULL,
                                     `sale_qty_tc` decimal(11, 2) DEFAULT NULL,
                                     `sale_pro_tc` decimal(11, 2) DEFAULT NULL,
                                     `sale_gro_tc` decimal(11, 2) DEFAULT NULL,
                                     PRIMARY KEY (`id`),
                                     KEY `qd_type_tc_rate_rela_id` (`rela_id`),
                                     KEY `qd_type_tc_rate_waretypeid` (`waretype_id`),
                                     tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_questionnaire`;

CREATE TABLE `sys_questionnaire` (
                                   `qid` int(8) NOT NULL AUTO_INCREMENT COMMENT '增自id',
                                   `member_id` int(11) NOT NULL COMMENT '发布人id',
                                   `stime` varchar(20) NOT NULL COMMENT '发表时间',
                                   `title` varchar(50) NOT NULL COMMENT '标题',
                                   `content` varchar(255) NOT NULL COMMENT '内容',
                                   `dsck` int(1) NOT NULL COMMENT '单双选项',
                                   `etime` varchar(20) NOT NULL COMMENT '截止时间',
                                   `branch_id` int(11) DEFAULT NULL COMMENT '所属部门',
                                   PRIMARY KEY (`qid`),
                                   KEY `member_idm_cons` (`member_id`),
                                   CONSTRAINT `member_idm_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_questionnaire_detail`;

CREATE TABLE `sys_questionnaire_detail` (
                                          `id` int(8) NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                          `qid` int(8) NOT NULL COMMENT '问卷id',
                                          `no` varchar(2) NOT NULL COMMENT '排序',
                                          `content` varchar(50) NOT NULL COMMENT '内容',
                                          PRIMARY KEY (`id`),
                                          KEY `q_idqd_cons` (`qid`),
                                          CONSTRAINT `PK_QUESTTIONNAIRE_QID` FOREIGN KEY (`qid`) REFERENCES `sys_questionnaire` (`qid`) ON DELETE CASCADE,
                                          CONSTRAINT `q_idqd_cons` FOREIGN KEY (`qid`) REFERENCES `sys_questionnaire` (`qid`) ON DELETE CASCADE,
                                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_questionnaire_vote`;

CREATE TABLE `sys_questionnaire_vote` (
                                        `id` int(11) NOT NULL AUTO_INCREMENT,
                                        `option_id` int(11) NOT NULL DEFAULT '0' COMMENT '选项ID',
                                        `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '人员ID',
                                        `problem_id` int(11) NOT NULL DEFAULT '0' COMMENT '问卷ID',
                                        `add_time` varchar(100) DEFAULT NULL COMMENT '投票时间',
                                        PRIMARY KEY (`id`),
                                        UNIQUE `unique_vote_mq` (`problem_id`, `option_id`, `member_id`),
                                        KEY `PK_VOTE_MEMBER` (`member_id`),
                                        KEY `PK_OPTION_QUEST` (`option_id`),
                                        KEY `PK_QUEST_PROID` (`problem_id`),
                                        CONSTRAINT `PK_OPTION_QUEST` FOREIGN KEY (`option_id`) REFERENCES `sys_questionnaire_detail` (`id`) ON DELETE CASCADE,
                                        CONSTRAINT `PK_QUEST_PROID` FOREIGN KEY (`problem_id`) REFERENCES `sys_questionnaire` (`qid`) ON DELETE CASCADE,
                                        CONSTRAINT `PK_VOTE_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                                        tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_quick_menu`;

CREATE TABLE `sys_quick_menu` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `menu_id` int(11) DEFAULT NULL,
                                `member_id` int(11) DEFAULT NULL,
                                `custom_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                `create_time` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
                                `sort` int(11) DEFAULT NULL COMMENT '排序',
                                PRIMARY KEY (`id`),
                                tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_region`;

CREATE TABLE `sys_region` (
                            `region_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类id',
                            `region_nm` varchar(20) NOT NULL COMMENT '分类名称',
                            `region_pid` int(11) DEFAULT NULL COMMENT '所属分类',
                            `region_path` varchar(20) DEFAULT NULL COMMENT '分类路径',
                            `region_leaf` char(1) DEFAULT NULL COMMENT '分类末级',
                            PRIMARY KEY (`region_id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_report`;

CREATE TABLE `sys_report` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '报id',
                            `member_id` int(11) NOT NULL COMMENT '用户id',
                            `tp` int(2) DEFAULT '1' COMMENT '报类型(1日报；2周报；3月报)',
                            `gz_nr` varchar(2000) DEFAULT NULL COMMENT '工作内容',
                            `gz_zj` varchar(2000) DEFAULT NULL COMMENT '工作总结',
                            `gz_jh` varchar(2000) DEFAULT NULL COMMENT '工作计划',
                            `gz_bz` varchar(2000) DEFAULT NULL COMMENT '帮助与支持',
                            `remo` varchar(2000) DEFAULT NULL COMMENT '备注',
                            `fb_time` varchar(20) DEFAULT NULL COMMENT '发布时间',
                            `file_nms` varchar(255) DEFAULT NULL COMMENT '附件',
                            `address` varchar(100) DEFAULT NULL COMMENT '地址',
                            PRIMARY KEY (`id`),
                            tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_report_cd`;

CREATE TABLE `sys_report_cd` (
                               `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
                               `gz_nrcd` int(5) NOT NULL COMMENT '工作内容字长度',
                               `gz_zjcd` int(5) NOT NULL COMMENT '工作总结字长度',
                               `gz_jhcd` int(5) NOT NULL COMMENT '工作计划字长度',
                               `gz_bzcd` int(5) NOT NULL COMMENT '帮助与支持字长度',
                               `remocd` int(5) NOT NULL COMMENT '备注字长度',
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_report_file`;

CREATE TABLE `sys_report_file` (
                                 `bid` int(11) NOT NULL COMMENT '报id',
                                 `tp` int(2) DEFAULT NULL COMMENT '文件类型（1图片；2附件）',
                                 `pic_mini` varchar(255) DEFAULT NULL COMMENT '小图',
                                 `pic` varchar(255) DEFAULT NULL COMMENT '大图',
                                 `wj` varchar(255) DEFAULT NULL COMMENT '附件',
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_report_pl`;

CREATE TABLE `sys_report_pl` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `bid` int(11) NOT NULL,
                               `member_id` int(11) NOT NULL,
                               `content` varchar(300) NOT NULL,
                               `pltime` varchar(20) NOT NULL,
                               `voice_time` int(5) DEFAULT NULL COMMENT '语音时长',
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_report_yh`;

CREATE TABLE `sys_report_yh` (
                               `bid` int(11) NOT NULL COMMENT '报id',
                               `fs_mid` int(11) NOT NULL COMMENT '发送用户id',
                               `js_mid` int(11) NOT NULL COMMENT '接收用户id',
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_role`;

CREATE TABLE `sys_role` (
                          `id_key` int(11) NOT NULL AUTO_INCREMENT,
                          `role_nm` varchar(50) DEFAULT NULL,
                          `create_dt` varchar(20) DEFAULT NULL,
                          `create_id` int(11) DEFAULT NULL,
                          `remo` text,
                          `role_cd` varchar(100) DEFAULT NULL COMMENT '角色编号',
                          PRIMARY KEY (`id_key`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4' COMMENT '公司角色表';

DROP TABLE IF EXISTS `sys_role_member`;

CREATE TABLE `sys_role_member` (
                                 `role_id` int(11) DEFAULT NULL,
                                 `member_id` int(11) DEFAULT NULL,
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4' COMMENT '公司角色分配关系表';

DROP TABLE IF EXISTS `sys_role_menu`;

CREATE TABLE `sys_role_menu` (
                               `id_key` int(11) NOT NULL AUTO_INCREMENT,
                               `role_id` int(11) DEFAULT NULL,
                               `menu_id` int(11) DEFAULT NULL,
                               `data_tp` char(1) DEFAULT NULL COMMENT '关联类型 1 全部 2 部门及子部门 3 个人',
                               `tp` varchar(5) DEFAULT NULL COMMENT '类型 1 menu 2 应用',
                               `sgtjz` varchar(20) DEFAULT NULL COMMENT '四个报表限权',
                               `mids` varchar(300) DEFAULT NULL COMMENT '用户id组',
                               PRIMARY KEY (`id_key`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4' COMMENT '公司角色菜单关系表';

DROP TABLE IF EXISTS `sys_salesman`;

CREATE TABLE `sys_salesman` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `salesman_name` varchar(50) DEFAULT NULL,
                              `tel` varchar(50) DEFAULT NULL,
                              `status` int(11) DEFAULT NULL,
                              `member_id` int(11) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_sign_detail`;

CREATE TABLE `sys_sign_detail` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `sign_id` int(11) DEFAULT NULL,
                                 `obj_type` int(11) DEFAULT NULL COMMENT '0 图片 1语音',
                                 `pic_mini` varchar(100) DEFAULT NULL,
                                 `pic` varchar(100) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_sign_in`;

CREATE TABLE `sys_sign_in` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `mid` int(11) DEFAULT NULL,
                             `longitude` varchar(50) DEFAULT NULL,
                             `latitude` varchar(50) DEFAULT NULL,
                             `address` varchar(100) DEFAULT NULL,
                             `sign_time` varchar(20) DEFAULT NULL,
                             `remarks` varchar(300) DEFAULT NULL,
                             `status` int(11) DEFAULT NULL,
                             `voice_time` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_task`;

CREATE TABLE `sys_task` (
                          `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '所属照片墙',
                          `task_title` varchar(255) NOT NULL COMMENT '赞的人',
                          `create_time` varchar(20) DEFAULT NULL,
                          `start_time` varchar(20) DEFAULT NULL,
                          `end_time` varchar(20) DEFAULT NULL,
                          `task_memo` text,
                          `parent_id` int(11) DEFAULT NULL,
                          `create_by` int(11) DEFAULT NULL,
                          `status` int(11) DEFAULT NULL COMMENT '1 未完成 2 完成3 草稿',
                          `remind1` int(11) DEFAULT NULL,
                          `remind2` int(11) DEFAULT NULL,
                          `remind3` int(11) DEFAULT NULL,
                          `remind4` int(11) DEFAULT NULL,
                          `remind_state1` int(11) DEFAULT '0',
                          `remind_state2` int(11) DEFAULT '0',
                          `remind_state3` int(11) DEFAULT '0',
                          `remind_state4` int(11) DEFAULT '0',
                          `act_time` varchar(20) DEFAULT NULL,
                          `percent` int(11) DEFAULT NULL,
                          `task_path` varchar(20) DEFAULT NULL COMMENT '任务关系路径',
                          PRIMARY KEY (`id`, `task_title`),
                          KEY `id` (`id`),
                          KEY `PK_PARPER_ID` (`parent_id`),
                          KEY `create_byt_cons` (`create_by`),
                          CONSTRAINT `PK_PARPER_ID` FOREIGN KEY (`parent_id`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE,
                          CONSTRAINT `create_byt_cons` FOREIGN KEY (`create_by`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_task_attachment`;

CREATE TABLE `sys_task_attachment` (
                                     `id` int(11) NOT NULL AUTO_INCREMENT,
                                     `nid` int(11) DEFAULT NULL COMMENT '所属照片墙',
                                     `attach_name` varchar(255) DEFAULT NULL,
                                     `attacth_path` varchar(255) DEFAULT NULL,
                                     `ref_id` int(11) DEFAULT NULL,
                                     `pid` int(11) DEFAULT NULL,
                                     `add_time` varchar(100) DEFAULT NULL COMMENT '文件上传时间',
                                     `fsize` varchar(255) DEFAULT NULL COMMENT '文件大小',
                                     `tempid` varchar(20) DEFAULT NULL COMMENT '附件上传临时id',
                                     PRIMARY KEY (`id`),
                                     KEY `PK_TASK_TASKATT` (`nid`),
                                     KEY `PK_TASK_FEEDBACK` (`pid`),
                                     CONSTRAINT `PK_TASK_FEEDBACK` FOREIGN KEY (`pid`) REFERENCES `sys_task_feedback` (`id`) ON DELETE CASCADE,
                                     CONSTRAINT `PK_TASK_TASKATT` FOREIGN KEY (`nid`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE,
                                     tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_task_feedback`;

CREATE TABLE `sys_task_feedback` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `nid` int(11) DEFAULT NULL COMMENT '所属照片墙',
                                   `persent` float DEFAULT NULL,
                                   `remarks` text,
                                   `dt_date` varchar(20) DEFAULT NULL,
                                   PRIMARY KEY (`id`),
                                   KEY `PK_FEEDBACK_TASK` (`nid`),
                                   CONSTRAINT `PK_FEEDBACK_TASK` FOREIGN KEY (`nid`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE,
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_task_ing`;

CREATE TABLE `sys_task_ing` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `task_id` int(11) DEFAULT NULL,
                              `task_title` varchar(255) DEFAULT NULL,
                              `create_time` varchar(20) DEFAULT NULL,
                              `start_time` varchar(20) DEFAULT NULL,
                              `end_time` varchar(20) DEFAULT NULL,
                              `parent_id` int(11) DEFAULT NULL,
                              `create_by` int(11) DEFAULT NULL,
                              `time1` varchar(100) DEFAULT NULL,
                              `time2` varchar(100) DEFAULT NULL,
                              `time3` varchar(100) DEFAULT NULL,
                              `time4` varchar(100) DEFAULT NULL,
                              `time5` varchar(100) DEFAULT NULL,
                              `remind1` int(11) DEFAULT NULL,
                              `remind2` int(11) DEFAULT NULL,
                              `remind3` int(11) DEFAULT NULL,
                              `remind4` int(11) DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              KEY `create_byt_consi` (`create_by`),
                              KEY `task_idt_consi` (`task_id`),
                              KEY `parent_idt_consi` (`parent_id`),
                              CONSTRAINT `create_byt_consi` FOREIGN KEY (`create_by`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                              CONSTRAINT `parent_idt_consi` FOREIGN KEY (`parent_id`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE,
                              CONSTRAINT `task_idt_consi` FOREIGN KEY (`task_id`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE,
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_task_msg`;

CREATE TABLE `sys_task_msg` (
                              `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '所属照片墙',
                              `mem_id` int(11) DEFAULT NULL COMMENT '发送人',
                              `psn_id` int(11) NOT NULL COMMENT '接收人',
                              `tp` char(1) NOT NULL COMMENT '类型 :1 催办消息 2 提醒 3 申请加入公司通知 4 申请加入部门',
                              `content` text COMMENT '内容',
                              `remind_time` varchar(20) DEFAULT NULL,
                              `agree` varchar(5) DEFAULT NULL COMMENT '是否同意 -1不同意 1 同意',
                              `nid` int(11) DEFAULT NULL COMMENT '邀请加入公司部门放公司或部门id',
                              `msg` varchar(20) DEFAULT NULL COMMENT '邀请加入圈放role 邀请加入公司放据库数名称',
                              `recieve_mobile` varchar(20) DEFAULT NULL COMMENT '接收人号码（邀请同事用）',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_task_psn`;

CREATE TABLE `sys_task_psn` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `psn_type` int(11) DEFAULT NULL COMMENT '赞的人',
                              `psn_id` int(11) DEFAULT NULL,
                              `nid` int(11) NOT NULL,
                              PRIMARY KEY (`id`),
                              KEY `PK_PSN_MEM_MEMBERID` USING BTREE (`psn_id`),
                              KEY `systask_id` (`nid`),
                              CONSTRAINT `MEMBWER_IDT` FOREIGN KEY (`psn_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
                              CONSTRAINT `systask_id` FOREIGN KEY (`nid`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE,
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_thorder`;

CREATE TABLE `sys_thorder` (
                             `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单id',
                             `mid` int(11) NOT NULL COMMENT '业务员id',
                             `cid` int(11) NOT NULL COMMENT '客户id',
                             `order_no` varchar(20) NOT NULL COMMENT '订单号',
                             `shr` varchar(20) DEFAULT NULL COMMENT '收货人',
                             `tel` varchar(20) DEFAULT NULL COMMENT '电话',
                             `address` varchar(50) DEFAULT NULL COMMENT '地址',
                             `remo` varchar(300) DEFAULT NULL COMMENT '备注',
                             `zje` double(10, 2) DEFAULT NULL COMMENT '总金额',
                             `zdzk` double(10, 2) DEFAULT NULL COMMENT '整单折扣',
                             `cjje` double(10, 2) DEFAULT NULL COMMENT '成交金额',
                             `oddate` varchar(20) NOT NULL COMMENT '日期',
                             `order_tp` varchar(20) DEFAULT NULL COMMENT '订单类型',
                             `sh_time` varchar(20) DEFAULT NULL COMMENT '送货时间',
                             `order_zt` varchar(10) DEFAULT '未审核' COMMENT '订单状态（审核，未审核）

',
                             `order_lb` varchar(10) DEFAULT '拜访单' COMMENT '订单类别（拜访单，电话单

）',
                             `odtime` varchar(10) DEFAULT NULL COMMENT '时间',
                             `pszd` varchar(20) DEFAULT NULL COMMENT '配送指定（公司直送，转二批配送）',
                             PRIMARY KEY (`id`),
                             KEY `mid` (`mid`),
                             KEY `cid` (`cid`),
                             KEY `order_no` (`order_no`),
                             KEY `oddate` (`oddate`),
                             KEY `order_tp` (`order_tp`),
                             tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_thorder_detail`;

CREATE TABLE `sys_thorder_detail` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单详情id',
                                    `order_id` int(11) NOT NULL COMMENT '订单id',
                                    `ware_id` int(11) NOT NULL COMMENT '商品id',
                                    `ware_num` double(10, 2) DEFAULT NULL,
                                    `ware_dj` double(10, 2) NOT NULL COMMENT '单价',
                                    `ware_zj` double(10, 2) NOT NULL COMMENT '总价',
                                    `xs_tp` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '销售类型',
                                    `ware_dw` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '单位',
                                    `be_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                                    `remark` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                                    `product_date` varchar(50) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_ware`;

CREATE TABLE `sys_ware` (
                          `ware_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品id',
                          `waretype` int(11) NOT NULL COMMENT '所属分类',
                          `ware_code` varchar(25) CHARACTER SET utf8 NOT NULL,
                          `ware_nm` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '名称',
                          `ware_gg` varchar(20) DEFAULT NULL COMMENT '规格',
                          `ware_dw` varchar(10) DEFAULT NULL COMMENT '单位',
                          `ware_dj` double(10, 2) NOT NULL DEFAULT '0.00' COMMENT '单价',
                          `fbtime` varchar(20) CHARACTER SET utf8 NOT NULL COMMENT '发布时间',
                          `is_cy` int(2) DEFAULT '2' COMMENT '是否常用（1是；2否）',
                          `tran_amt` double(10, 2) NOT NULL DEFAULT '0.00',
                          `tc_amt` double(10, 2) NOT NULL DEFAULT '0.00',
                          `quality_Days` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `remark` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `be_bar_code` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `pack_bar_code` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `max_unit` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `produce_date` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `provider_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `lower_limit` decimal(10, 2) DEFAULT NULL,
                          `in_price` decimal(10, 2) DEFAULT NULL,
                          `order_cd` int(11) DEFAULT NULL,
                          `hs_num` decimal(13, 7) DEFAULT NULL,
                          `min_unit` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                          `max_unit_code` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                          `min_unit_code` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
                          `status` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
                          `b_Unit` double(6, 2) DEFAULT NULL,
                          `s_Unit` double(6, 2) DEFAULT NULL,
                          `py` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `sunit_price` decimal(10, 2) DEFAULT NULL,
                          `group_ids` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
                          `group_nms` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
                          `put_on` int(2) DEFAULT NULL,
                          `sunit_front` int(2) DEFAULT NULL,
                          `ls_price` decimal(10, 2) DEFAULT NULL,
                          `warn_qty` decimal(10, 2) DEFAULT NULL,
                          `alias_Name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `asn_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
                          `ware_desc` text CHARACTER SET utf8 COMMENT '商品描述',
                          `shop_alarm` decimal(10, 2) DEFAULT NULL COMMENT '门店库存预警',
                          `default_qty` decimal(10, 2) DEFAULT NULL COMMENT '默认补货数量',
                          `init_qty` decimal(10, 2) DEFAULT NULL COMMENT '初始库存数量',
                          `is_use_stk` int(11) DEFAULT NULL COMMENT '是否使用库存',
                          `pos_price1` decimal(10, 2) DEFAULT NULL,
                          `pos_price2` decimal(10, 2) DEFAULT NULL,
                          `shop_ware_alias` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '商城商品别名',
                          `shop_ware_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品大单位价格',
                          `shop_ware_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品大单位零售价格',
                          `shop_ware_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品大单位促销价格',
                          `shop_ware_small_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品小单位价格',
                          `shop_ware_small_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品小单位零售价格',
                          `shop_ware_small_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品小单位促销价格',
                          `brand_id` int(11) DEFAULT NULL COMMENT '品牌Id',
                          `fx_Price` decimal(10, 2) DEFAULT NULL COMMENT '大单位分销价',
                          `cx_Price` decimal(10, 2) DEFAULT NULL COMMENT '大单位促销价',
                          `min_Ware_Gg` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '小单位规格',
                          `min_In_Price` decimal(10, 2) DEFAULT NULL COMMENT '小单位采购价格',
                          `min_Ls_Price` decimal(10, 2) DEFAULT NULL COMMENT '小单位零售价格',
                          `min_Fx_Price` decimal(10, 2) DEFAULT NULL COMMENT '小单位分销价格',
                          `min_Cx_Price` decimal(10, 2) DEFAULT NULL COMMENT '小单位促销价格',
                          `min_Warn_Qty` decimal(10, 2) DEFAULT NULL COMMENT '小单位预警数量',
                          `pos_Ware_Nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '门店商品名',
                          `pos_In_Price` decimal(10, 2) DEFAULT NULL COMMENT '门店大单位采购价',
                          `pos_Cx_Price` decimal(10, 2) DEFAULT NULL COMMENT '门店大单位促销价格',
                          `pos_Min_In_Price` decimal(10, 2) DEFAULT NULL COMMENT '门店大单位采购价',
                          `pos_Min_Pf_Price` decimal(10, 2) DEFAULT NULL COMMENT '门店商品小单位批发价格',
                          `pos_Min_LS_Price` decimal(10, 2) DEFAULT NULL COMMENT '门店商品小单位零售价格',
                          `pos_Min_Cx_Price` decimal(10, 2) DEFAULT NULL COMMENT '门店商品小单位促销价格',
                          `platshop_ware_nm` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '平台商城商品名',
                          `platshop_ware_pf_Price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品大单位批发价',
                          `platshop_ware_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品大单位零售价格',
                          `platshop_ware_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品大单位促销价格',
                          `platshop_ware_min_pf_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品小单位批发价格',
                          `platshop_ware_min_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品小单位零售价格',
                          `platshop_ware_min_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品小单位促销价格',
                          `platshop_ware_type` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '平台商城类别',
                          `pos_pf_price` decimal(10, 2) DEFAULT NULL,
                          `shop_sort` int(11) DEFAULT NULL COMMENT '商品商城排序，越大越前',
                          `multi_spec_id` int(11) DEFAULT NULL,
                          `shop_ware_price_show` int(11) DEFAULT '1' COMMENT '大单位是否显示0否1是',
                          `shop_ware_small_price_show` int(11) DEFAULT '1' COMMENT '小单位是否显示0否1是',
                          `shop_ware_price_default` int(11) DEFAULT '0' COMMENT '价格显示默认0大单位,1小单位',
                          `sale_pro_tc` decimal(10, 2) DEFAULT NULL,
                          `sale_gro_tc` decimal(10, 2) DEFAULT NULL,
                          `has_sync` tinyint(4) DEFAULT '0' COMMENT '是否已同步，给总平台提取数据使用',
                          `pos_id` int(11) DEFAULT NULL,
                          `group_id` int(11) DEFAULT NULL,
                          `attribute` varchar(50) DEFAULT NULL COMMENT '商品属性',
                          `sort` int(11) DEFAULT NULL COMMENT '排序',
                          PRIMARY KEY (`ware_id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_warespec_group`;

CREATE TABLE `sys_warespec_group` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `group_name` varchar(50) DEFAULT NULL,
                                    `remark` varchar(50) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_waretype`;

CREATE TABLE `sys_waretype` (
                              `waretype_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类id',
                              `waretype_nm` varchar(20) NOT NULL COMMENT '分类名称',
                              `waretype_pid` int(11) DEFAULT NULL COMMENT '所属分类',
                              `waretype_path` varchar(20) DEFAULT NULL COMMENT '分类路径',
                              `waretype_leaf` char(1) DEFAULT NULL COMMENT '分类末级',
                              `no_Company` int(2) DEFAULT NULL,
                              `shop_qy` int(2) DEFAULT NULL COMMENT '商城是否启用：0不启动，1启用,2部分选中',
                              `is_type` int(11) DEFAULT '0',
                              PRIMARY KEY (`waretype_id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_waretype_pic`;

CREATE TABLE `sys_waretype_pic` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
                                  `type` int(2) DEFAULT NULL,
                                  `pic_mini` varchar(255) NOT NULL COMMENT '小图',
                                  `pic` varchar(255) NOT NULL COMMENT '大图',
                                  `waretype_id` int(11) DEFAULT NULL COMMENT '商品类型id',
                                  PRIMARY KEY (`id`),
                                  tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_ware_import_main`;

CREATE TABLE `sys_ware_import_main` (
                                      `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
                                      `title` varchar(100) DEFAULT NULL COMMENT '标题',
                                      `import_time` datetime NOT NULL COMMENT '报表日期',
                                      `oper_id` int(11) NOT NULL,
                                      `oper_name` varchar(20) NOT NULL COMMENT '操作员',
                                      PRIMARY KEY (`id`),
                                      tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_ware_import_sub`;

CREATE TABLE `sys_ware_import_sub` (
                                     `id` int(11) NOT NULL AUTO_INCREMENT,
                                     `ware_id` int(11) DEFAULT NULL COMMENT '商品id',
                                     `waretype` int(11) DEFAULT NULL COMMENT '所属分类',
                                     `ware_code` varchar(25) DEFAULT NULL,
                                     `ware_nm` varchar(50) DEFAULT NULL COMMENT '名称',
                                     `ware_gg` varchar(20) DEFAULT NULL COMMENT '规格',
                                     `ware_dw` varchar(10) DEFAULT NULL COMMENT '单位',
                                     `ware_dj` double(10, 2) DEFAULT '0.00' COMMENT '单价',
                                     `fbtime` varchar(20) DEFAULT NULL COMMENT '发布时间',
                                     `is_cy` int(11) DEFAULT '2' COMMENT '是否常用（1是；2否）',
                                     `tran_amt` double(10, 2) DEFAULT '0.00',
                                     `tc_amt` double(10, 2) DEFAULT '0.00',
                                     `quality_days` varchar(50) DEFAULT NULL,
                                     `remark` varchar(50) DEFAULT NULL,
                                     `be_bar_code` varchar(50) DEFAULT NULL,
                                     `pack_bar_code` varchar(50) DEFAULT NULL,
                                     `max_unit` varchar(50) DEFAULT NULL,
                                     `produce_date` varchar(50) DEFAULT NULL,
                                     `provider_name` varchar(50) DEFAULT NULL,
                                     `lower_limit` decimal(10, 2) DEFAULT NULL,
                                     `in_price` decimal(10, 2) DEFAULT NULL,
                                     `order_cd` int(11) DEFAULT NULL,
                                     `hs_num` decimal(10, 7) DEFAULT NULL,
                                     `min_unit` varchar(20) DEFAULT NULL,
                                     `max_unit_code` varchar(20) DEFAULT NULL,
                                     `min_unit_code` varchar(20) DEFAULT NULL,
                                     `status` varchar(10) DEFAULT NULL,
                                     `b_unit` double(6, 2) DEFAULT NULL,
                                     `s_unit` double(6, 2) DEFAULT NULL,
                                     `py` varchar(50) DEFAULT NULL,
                                     `sunit_price` decimal(10, 2) DEFAULT NULL,
                                     `group_ids` varchar(100) DEFAULT NULL,
                                     `group_nms` varchar(200) DEFAULT NULL,
                                     `put_on` int(11) DEFAULT NULL,
                                     `sunit_front` int(11) DEFAULT NULL,
                                     `ls_price` decimal(10, 2) DEFAULT NULL,
                                     `warn_qty` decimal(10, 2) DEFAULT NULL,
                                     `alias_name` varchar(50) DEFAULT NULL,
                                     `asn_no` varchar(50) DEFAULT NULL,
                                     `ware_desc` text COMMENT '商品描述',
                                     `shop_alarm` decimal(10, 2) DEFAULT NULL COMMENT '门店库存预警',
                                     `default_qty` decimal(10, 2) DEFAULT NULL COMMENT '默认补货数量',
                                     `init_qty` decimal(10, 2) DEFAULT NULL COMMENT '初始库存数量',
                                     `is_use_stk` int(11) DEFAULT NULL COMMENT '是否使用库存',
                                     `pos_price1` decimal(10, 2) DEFAULT NULL,
                                     `pos_price2` decimal(10, 2) DEFAULT NULL,
                                     `shop_ware_alias` varchar(255) DEFAULT NULL COMMENT '商城商品别名',
                                     `shop_ware_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品大单位价格',
                                     `shop_ware_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品大单位零售价格',
                                     `shop_ware_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品大单位促销价格',
                                     `shop_ware_small_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品小单位价格',
                                     `shop_ware_small_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品小单位零售价格',
                                     `shop_ware_small_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '商城商品小单位促销价格',
                                     `brand_id` int(11) DEFAULT NULL COMMENT '品牌id',
                                     `fx_price` decimal(10, 2) DEFAULT NULL COMMENT '大单位分销价',
                                     `cx_price` decimal(10, 2) DEFAULT NULL COMMENT '大单位促销价',
                                     `min_ware_gg` varchar(20) DEFAULT NULL COMMENT '小单位规格',
                                     `min_in_price` decimal(10, 2) DEFAULT NULL COMMENT '小单位采购价格',
                                     `min_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '小单位零售价格',
                                     `min_fx_price` decimal(10, 2) DEFAULT NULL COMMENT '小单位分销价格',
                                     `min_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '小单位促销价格',
                                     `min_warn_qty` decimal(10, 2) DEFAULT NULL COMMENT '小单位预警数量',
                                     `pos_ware_nm` varchar(50) DEFAULT NULL COMMENT '门店商品名',
                                     `pos_in_price` decimal(10, 2) DEFAULT NULL COMMENT '门店大单位采购价',
                                     `pos_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '门店大单位促销价格',
                                     `pos_min_in_price` decimal(10, 2) DEFAULT NULL COMMENT '门店大单位采购价',
                                     `pos_min_pf_price` decimal(10, 2) DEFAULT NULL COMMENT '门店商品小单位批发价格',
                                     `pos_min_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '门店商品小单位零售价格',
                                     `pos_min_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '门店商品小单位促销价格',
                                     `platshop_ware_nm` varchar(50) DEFAULT NULL COMMENT '平台商城商品名',
                                     `platshop_ware_pf_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品大单位批发价',
                                     `platshop_ware_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品大单位零售价格',
                                     `platshop_ware_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品大单位促销价格',
                                     `platshop_ware_min_pf_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品小单位批发价格',
                                     `platshop_ware_min_ls_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品小单位零售价格',
                                     `platshop_ware_min_cx_price` decimal(10, 2) DEFAULT NULL COMMENT '平台商城商品小单位促销价格',
                                     `platshop_ware_type` varchar(50) DEFAULT NULL COMMENT '平台商城类别',
                                     `shop_ware_price_source` int(11) DEFAULT NULL,
                                     `mast_id` int(11) DEFAULT NULL,
                                     `customer_level_ware_sale` varchar(500) DEFAULT NULL,
                                     PRIMARY KEY (`id`),
                                     tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_ware_pic`;

CREATE TABLE `sys_ware_pic` (
                              `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
                              `type` int(2) DEFAULT NULL,
                              `pic_mini` varchar(255) NOT NULL COMMENT '小图',
                              `pic` varchar(255) NOT NULL COMMENT '大图',
                              `ware_id` int(11) DEFAULT NULL COMMENT '商品id',
                              PRIMARY KEY (`id`),
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_xtcs`;

CREATE TABLE `sys_xtcs` (
                          `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '系统参数id',
                          `xt_nm` varchar(20) NOT NULL COMMENT '名称',
                          `xt_csz` int(10) NOT NULL COMMENT '数值',
                          PRIMARY KEY (`id`),
                          tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_yfile`;

CREATE TABLE `sys_yfile` (
                           `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文件id',
                           `pid` int(11) DEFAULT '0' COMMENT '上级id',
                           `member_id` int(11) NOT NULL COMMENT '用户id',
                           `file_nm` varchar(200) NOT NULL COMMENT '文件夹/文件名',
                           `tp1` varchar(10) DEFAULT '0' COMMENT '文件类型(如：mp3,mp4)',
                           `tp2` int(2) NOT NULL DEFAULT '1' COMMENT '文件位置类型（1自己；2公司）',
                           `tp3` int(2) NOT NULL COMMENT '1文件夹；2文件',
                           `ftime` varchar(20) NOT NULL COMMENT '时间',
                           `fsize` varchar(20) DEFAULT NULL COMMENT '文件大小',
                           PRIMARY KEY (`id`),
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_yfilepwd`;

CREATE TABLE `sys_yfilepwd` (
                              `member_id` int(11) NOT NULL COMMENT '用户id',
                              `yf_pwd` varchar(20) NOT NULL COMMENT '云盘密码',
                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `sys_zcusr`;

CREATE TABLE `sys_zcusr` (
                           `zusr_id` int(11) NOT NULL COMMENT '主用户id',
                           `cusr_id` int(11) NOT NULL COMMENT '次用户id',
                           tenant_id int(11) NOT NULL
) ENGINE = InnoDB CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `weixin_config`;

CREATE TABLE `weixin_config` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `name` varchar(50) DEFAULT NULL,
                               `token` varchar(100) DEFAULT NULL,
                               `url` varchar(100) DEFAULT NULL,
                               `company_Id` varchar(100) DEFAULT NULL,
                               `app_Id` varchar(100) DEFAULT NULL,
                               `app_Secret` varchar(100) DEFAULT NULL,
                               `access_Token` varchar(512) DEFAULT NULL,
                               `access_Token_Time` datetime DEFAULT NULL,
                               `menu_status` int(11) DEFAULT '0',
                               `subscribe_status` int(11) DEFAULT '0',
                               `subscribe_text` varchar(600) DEFAULT NULL,
                               `subscribe_image_id` int(11) DEFAULT '0',
                               `receive_status` int(11) DEFAULT '0',
                               `receive_text` varchar(600) DEFAULT NULL,
                               `receive_image_id` int(11) DEFAULT '0',
                               PRIMARY KEY (`id`),
                               tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `weixin_customer_service_chat`;

CREATE TABLE `weixin_customer_service_chat` (
                                              `id` int(11) NOT NULL AUTO_INCREMENT,
                                              `open_id` varchar(500) CHARACTER SET utf8 DEFAULT NULL COMMENT '微信用户的openid',
                                              `member_name` varchar(55) DEFAULT NULL COMMENT '微信用户的名称',
                                              `customer_service_id` int(11) DEFAULT NULL COMMENT '客服的驰用T3平台id',
                                              `customer_service_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '客服的驰用T3平台名称',
                                              `chat_begin_time` datetime DEFAULT NULL COMMENT '聊天的开始时间',
                                              `chat_begin_type` int(11) DEFAULT NULL COMMENT '1查看未读消息,2申请聊天客服,3审批转接客服',
                                              `chat_end_time` datetime DEFAULT NULL COMMENT '聊天的结束时间',
                                              `chat_end_type` int(11) DEFAULT NULL COMMENT '1完成回复,2审批聊天客服,3申请转接客服,4退出聊天',
                                              `chat_id` int(11) DEFAULT NULL COMMENT '聊天id',
                                              `chat_state` int(11) DEFAULT '0' COMMENT '客服聊天是否已结束,0未结束,1已结束',
                                              PRIMARY KEY (`id`),
                                              tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `weixin_keyword_reply`;

CREATE TABLE `weixin_keyword_reply` (
                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                      `keyword` varchar(30) DEFAULT NULL,
                                      `keyword_text` varchar(300) DEFAULT NULL,
                                      `keyword_image_id` int(11) DEFAULT '0',
                                      PRIMARY KEY (`id`),
                                      tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `weixin_material_pic`;

CREATE TABLE `weixin_material_pic` (
                                     `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
                                     `pic_mini` varchar(255) NOT NULL COMMENT '小图',
                                     `pic` varchar(255) NOT NULL COMMENT '大图',
                                     `upload_time` varchar(20) NOT NULL COMMENT '上传图片时间',
                                     `media_id` varchar(255) DEFAULT NULL,
                                     `news_image_url` varchar(300) DEFAULT NULL,
                                     PRIMARY KEY (`id`),
                                     tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `weixin_member_msg`;

CREATE TABLE `weixin_member_msg` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `msg_id` varchar(28) DEFAULT NULL,
                                   `from_user_name` varchar(28) DEFAULT NULL,
                                   `to_user_name` varchar(28) DEFAULT NULL,
                                   `content` varchar(500) DEFAULT NULL,
                                   `create_time` varchar(20) DEFAULT NULL,
                                   `msg_time` varchar(20) DEFAULT NULL,
                                   `is_read` int(11) DEFAULT '0' COMMENT '是否已读,0未读,1已读',
                                   `chat_id` int(11) DEFAULT NULL COMMENT '客服聊天id,对应weixin_customer_service_chat表的id',
                                   `customer_service_state` int(11) DEFAULT NULL COMMENT '客服的操作状态:接入聊天1、申请聊天2、转接3、退出4、完成5',
                                   `msg_type` varchar(20) DEFAULT NULL COMMENT 'null或text文本消息，image图片消息',
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `weixin_menu_button`;

CREATE TABLE `weixin_menu_button` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `position` varchar(20) NOT NULL,
                                    `button_no` int(11) NOT NULL,
                                    `name` varchar(20) NOT NULL,
                                    `type` varchar(20) NOT NULL,
                                    `text` varchar(600) DEFAULT NULL,
                                    `url` varchar(2083) DEFAULT NULL,
                                    `media_id` varchar(255) DEFAULT NULL,
                                    `image_url` varchar(2083) DEFAULT NULL,
                                    `news_title` varchar(64) DEFAULT NULL,
                                    `image_id` int(11) DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';

DROP TABLE IF EXISTS `weixin_reply_time`;

CREATE TABLE `weixin_reply_time` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `open_id` varchar(28) DEFAULT NULL,
                                   `reply_Time` datetime DEFAULT NULL COMMENT '自定义回复的时间',
                                   PRIMARY KEY (`id`),
                                   tenant_id int(11) NOT NULL
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARSET = 'utf8mb4';