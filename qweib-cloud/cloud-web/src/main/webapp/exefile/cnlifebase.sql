/*
Navicat MySQL Data Transfer
Source Host     : localhost:3306
Source Database : cnlifebase
Target Host     : localhost:3306
Target Database : cnlifebase
Date: 2017-08-26 21:21:04
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for bsc_audit
-- ----------------------------
DROP TABLE IF EXISTS `bsc_audit`;
CREATE TABLE `bsc_audit` (
  `audit_no` varchar(100) NOT NULL,
  `member_id` int(11) DEFAULT NULL,
  `tp` varchar(255) NOT NULL,
  `add_time` varchar(100) DEFAULT NULL,
  `stime` varchar(100) DEFAULT NULL,
  `etime` varchar(100) DEFAULT NULL,
  `audit_data` varchar(255) DEFAULT NULL,
  `dsc` varchar(255) DEFAULT NULL,
  `is_over` varchar(10) NOT NULL DEFAULT '2' COMMENT '否是结束（1-1 完成  1-2 拒绝 1-3 撤销 2 未完成 ）',
  `audit_tp` varchar(10) NOT NULL COMMENT '1 请假 2 报销 3 出差 4 物品领用5 通用审批',
  `check_nm` varchar(100) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL COMMENT '标题',
  `file_nms` varchar(200) DEFAULT NULL COMMENT '文件',
  zdy_nm varchar(50) DEFAULT NULL,
  zdy_id varchar(50) null,
  amount decimal(15,3) null,
  PRIMARY KEY (`audit_no`),
  KEY `audit_no` (`audit_no`),
  KEY `member_id` (`member_id`),
  KEY `is_over` (`is_over`),
  KEY `tp` (`tp`),
  KEY `audit_tp` (`audit_tp`),
  KEY `add_time` (`add_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_audit
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_audit_pic
-- ----------------------------
DROP TABLE IF EXISTS `bsc_audit_pic`;
CREATE TABLE `bsc_audit_pic` (
  `pic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `audit_no` varchar(100) NOT NULL,
  `pic_mini` varchar(200) NOT NULL COMMENT '图片小图',
  `pic` varchar(200) NOT NULL COMMENT '图片',
  PRIMARY KEY (`pic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_audit_pic
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_audit_zdy
-- ----------------------------
DROP TABLE IF EXISTS `bsc_audit_zdy`;
CREATE TABLE `bsc_audit_zdy` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自定义id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `zdy_nm` varchar(50) NOT NULL COMMENT '自定义名称',
  `tp` varchar(20) DEFAULT NULL COMMENT '类型',
  `mem_ids` varchar(100) DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_audit_zdy
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_check
-- ----------------------------
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
  KEY `audit_no` (`audit_no`),
  KEY `is_check` (`is_check`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_check
-- ----------------------------


-- ----------------------------
-- Table structure for `approval_transfer_order_config`
-- ----------------------------
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
	  PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- ----------------------------
-- Records of `approval_transfer_order_config`
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_check_rule
-- ----------------------------
DROP TABLE IF EXISTS `bsc_check_rule`;
CREATE TABLE `bsc_check_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '考勤规则id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `kqgj_nm` varchar(50) NOT NULL COMMENT '规则名称',
  `tp` varchar(20) NOT NULL COMMENT '类型(固定班制；外勤制)',
  `check_weeks` varchar(50) DEFAULT NULL COMMENT '考勤时间（周）',
  `check_times` varchar(50) DEFAULT NULL COMMENT '考勤时间（时间段）',
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_check_rule
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_collect
-- ----------------------------
DROP TABLE IF EXISTS `bsc_collect`;
CREATE TABLE `bsc_collect` (
  `collect_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id\r\n            ',
  `member_id` int(11) DEFAULT NULL,
  `collec_time` varchar(20) DEFAULT NULL,
  `collect_tp` char(255) DEFAULT NULL COMMENT '收藏类型 1 文字 2 图片 3 主题',
  `content` varchar(255) DEFAULT NULL COMMENT '收藏内容',
  `belong_id` int(11) DEFAULT NULL COMMENT '对应id(暂时只有主题id)',
  PRIMARY KEY (`collect_id`),
  KEY `member_idc_cons` (`member_id`),
  CONSTRAINT `member_idc_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_collect
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_dept_msg
-- ----------------------------
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
  CONSTRAINT `member_idd_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_dept_msg
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_empgroup
-- ----------------------------
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
  CONSTRAINT `member_ide_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_empgroup
-- ----------------------------
INSERT INTO `bsc_empgroup` VALUES ('1', '综合部公开圈', '这里的信息，大家看', '0', null, null, '2015-07-03 10:00:00', '1', null, '2', null, '1');
INSERT INTO `bsc_empgroup` VALUES ('2', '综合部内部圈', '这里的信息，圈友看', '0', null, null, '2015-07-03 10:00:00', '1', null, '2', null, '2');

-- ----------------------------
-- Table structure for bsc_empgroup_member
-- ----------------------------
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
  PRIMARY KEY (`group_id`,`member_id`),
  KEY `member_idem_cons` (`member_id`),
  CONSTRAINT `group_idem_cons` FOREIGN KEY (`group_id`) REFERENCES `bsc_empgroup` (`group_id`) ON DELETE CASCADE,
  CONSTRAINT `member_idem_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_empgroup_member
-- ----------------------------
INSERT INTO `bsc_empgroup_member` VALUES ('1', '0', '1', '2015-07-03 11:11:00', null, '2', '1', null);
INSERT INTO `bsc_empgroup_member` VALUES ('2', '0', '1', '2015-07-03 11:11:00', null, '2', '1', null);

-- ----------------------------
-- Table structure for bsc_empgroup_msg
-- ----------------------------
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
  CONSTRAINT `member_idemg_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_empgroup_msg
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_knowledge
-- ----------------------------
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
  CONSTRAINT `sort_idk_cons` FOREIGN KEY (`sort_id`) REFERENCES `bsc_sort` (`sort_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_knowledge
-- ----------------------------
INSERT INTO `bsc_knowledge` VALUES ('1', '1', '生活，需要一份好工作', '0', 'http://www.psycofe.com/read/readDetail_48545.htm', '2015-07-03 10:33:00', null, '1', '2', null);
INSERT INTO `bsc_knowledge` VALUES ('2', null, '企微宝用户手册', '0', null, '2015-09-02 10:33:00', null, '1', '3', null);
INSERT INTO `bsc_knowledge` VALUES ('3', '3', '传统行业的热门职位与朝阳产业的普通职位怎么选？', '0', 'http://www.psycofe.com/read/readDetail_48641.htm', '2015-07-03 10:35:00', null, '2', '2', null);

-- ----------------------------
-- Table structure for bsc_knowledge_comment
-- ----------------------------
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
  CONSTRAINT `member_idkc_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_knowledge_comment
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_knowledge_pic
-- ----------------------------
DROP TABLE IF EXISTS `bsc_knowledge_pic`;
CREATE TABLE `bsc_knowledge_pic` (
  `pic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
  `knowledge_id` int(11) NOT NULL COMMENT '所属知识点',
  `pic_mini` varchar(255) NOT NULL COMMENT '图片小图',
  `pic` varchar(255) NOT NULL COMMENT '图片',
  PRIMARY KEY (`pic_id`),
  KEY `knowledge_idkp_cons` (`knowledge_id`),
  CONSTRAINT `knowledge_idkp_cons` FOREIGN KEY (`knowledge_id`) REFERENCES `bsc_knowledge` (`knowledge_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_knowledge_pic
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_knowledge_praise
-- ----------------------------
DROP TABLE IF EXISTS `bsc_knowledge_praise`;
CREATE TABLE `bsc_knowledge_praise` (
  `knowledge_id` int(11) NOT NULL COMMENT '知识点id',
  `member_id` int(11) NOT NULL COMMENT '赞的人',
  PRIMARY KEY (`knowledge_id`,`member_id`),
  KEY `member_idkpr_cons` (`member_id`),
  CONSTRAINT `knowledge_idkpr_cons` FOREIGN KEY (`knowledge_id`) REFERENCES `bsc_knowledge` (`knowledge_id`) ON DELETE CASCADE,
  CONSTRAINT `member_idkpr_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_knowledge_praise
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_orderls
-- ----------------------------
DROP TABLE IF EXISTS `bsc_orderls`;
CREATE TABLE `bsc_orderls` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '旅行社订单id',
  `order_no` varchar(20) NOT NULL COMMENT '订单号',
  `cid` int(11) NOT NULL COMMENT '客户id',
  `mid` int(11) NOT NULL COMMENT '用户id',
  `oddate` varchar(20) NOT NULL COMMENT '日期',
  `order_zt` varchar(10) NOT NULL DEFAULT '未审核' COMMENT '订单状态（审核，未审核)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_orderls
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_orderls_bb
-- ----------------------------
DROP TABLE IF EXISTS `bsc_orderls_bb`;
CREATE TABLE `bsc_orderls_bb` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `order_no` varchar(20) NOT NULL COMMENT '订单号',
  `cid` int(11) NOT NULL,
  `mid` int(11) NOT NULL,
  `odate` varchar(20) NOT NULL,
  `aw_jg` double(8,2) DEFAULT '0.00' COMMENT '其他啤酒',
  `bw_jg` double(8,2) DEFAULT '0.00' COMMENT '小商品',
  `cw_jg` double(8,2) DEFAULT '0.00' COMMENT '化妆品',
  `dw_jg` double(8,2) DEFAULT '0.00' COMMENT '衣服燕窝',
  `ew_jg` double(8,2) DEFAULT '0.00' COMMENT '酵素',
  `fw_jg` double(8,2) DEFAULT '0.00' COMMENT '乳液',
  `all_jg` double(8,2) DEFAULT '0.00' COMMENT '计合金额',
  `zh_jg` double(8,2) DEFAULT '0.00' COMMENT '总回',
  `ls_jg` double(8,2) DEFAULT '0.00' COMMENT '旅社',
  `dy_jg` double(8,2) DEFAULT '0.00' COMMENT '导游',
  `sj_jg` double(8,2) DEFAULT '0.00' COMMENT '司机',
  `qp_jg` double(8,2) DEFAULT '0.00' COMMENT '全陪',
  `is_js` varchar(10) DEFAULT '未结算' COMMENT '结算状态（结算，未结算）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_orderls_bb
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_orderls_detail
-- ----------------------------
DROP TABLE IF EXISTS `bsc_orderls_detail`;
CREATE TABLE `bsc_orderls_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '详情id',
  `order_id` int(11) NOT NULL COMMENT '订单id',
  `ware_id` int(11) NOT NULL COMMENT '商品id',
  `zh` double(5,2) DEFAULT '0.00' COMMENT '总回',
  `ls` double(5,2) DEFAULT '0.00' COMMENT '旅社',
  `dy` double(5,2) DEFAULT '0.00' COMMENT '导游',
  `sj` double(5,2) DEFAULT '0.00' COMMENT '司机',
  `qp` double(5,2) DEFAULT '0.00' COMMENT '全陪',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_orderls_detail
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_photo_wall
-- ----------------------------
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
  CONSTRAINT `member_idpw_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_photo_wall
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_photo_wall_comment
-- ----------------------------
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
  CONSTRAINT `wall_idwc_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_photo_wall_comment
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_photo_wall_pic
-- ----------------------------
DROP TABLE IF EXISTS `bsc_photo_wall_pic`;
CREATE TABLE `bsc_photo_wall_pic` (
  `pic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `wall_id` int(11) NOT NULL,
  `pic_mini` varchar(255) DEFAULT NULL COMMENT '图片小图',
  `pic` varchar(255) NOT NULL COMMENT '图片',
  PRIMARY KEY (`pic_id`),
  KEY `FK_Reference_25` (`wall_id`),
  CONSTRAINT `wall_idwp_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE,
  CONSTRAINT `wall_id_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_photo_wall_pic
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_photo_wall_praise
-- ----------------------------
DROP TABLE IF EXISTS `bsc_photo_wall_praise`;
CREATE TABLE `bsc_photo_wall_praise` (
  `wall_id` int(11) NOT NULL COMMENT '所属照片墙',
  `member_id` int(11) NOT NULL COMMENT '赞的人',
  `click_time` varchar(255) DEFAULT '' COMMENT '点赞时间',
  PRIMARY KEY (`wall_id`,`member_id`),
  KEY `FK_Reference_29` (`member_id`),
  CONSTRAINT `member_id14_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_member` (`member_id`) ON DELETE CASCADE,
  CONSTRAINT `member_idwpr_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
  CONSTRAINT `wall_id2_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE,
  CONSTRAINT `wall_idwpr_cons` FOREIGN KEY (`wall_id`) REFERENCES `bsc_photo_wall` (`wall_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_photo_wall_praise
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_plan
-- ----------------------------
DROP TABLE IF EXISTS `bsc_plan`;
CREATE TABLE `bsc_plan` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '计划id',
  `mid` int(11) NOT NULL COMMENT '业务员id',
  `cid` int(11) NOT NULL COMMENT '客户id',
  `branch_id` int(11) DEFAULT NULL COMMENT '部门id',
  `pdate` varchar(20) NOT NULL COMMENT '计划日期',
  `is_wc` int(2) NOT NULL DEFAULT '2' COMMENT '是否完成（1是；2否）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_plan
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_planxl
-- ----------------------------
DROP TABLE IF EXISTS `bsc_planxl`;
CREATE TABLE `bsc_planxl` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '线路id',
  `mid` int(11) NOT NULL COMMENT '用户id',
  `xl_nm` varchar(50) NOT NULL COMMENT '线路名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_planxl
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_planxl_detail
-- ----------------------------
DROP TABLE IF EXISTS `bsc_planxl_detail`;
CREATE TABLE `bsc_planxl_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '线路详情id',
  `xl_id` int(11) NOT NULL COMMENT '线路id',
  `cid` int(11) NOT NULL COMMENT '客户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_planxl_detail
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_sort
-- ----------------------------
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
  CONSTRAINT `member_ids_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_sort
-- ----------------------------
INSERT INTO `bsc_sort` VALUES ('1', '1', '公开知识', '0', null);
INSERT INTO `bsc_sort` VALUES ('2', '2', '内部知识', '0', null);

-- ----------------------------
-- Table structure for bsc_topic
-- ----------------------------
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
  CONSTRAINT `member_idte_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_topic
-- ----------------------------
INSERT INTO `bsc_topic` VALUES ('1', '2', '1', '生活，需要一份好工作', '0', null, '2015-07-03 10:04:00', '0', '0', '0', null, 'http://www.psycofe.com/read/readDetail_48545.htm');
INSERT INTO `bsc_topic` VALUES ('2', '2', '1', '用对待爱情的态度来对待你的工作', '0', null, '2015-07-03 10:06:00', '0', '0', '0', null, 'http://www.psycofe.com/read/readDetail_48149.htm');
INSERT INTO `bsc_topic` VALUES ('3', '2', '2', '传统行业的热门职位与朝阳产业的普通职位怎么选？', '0', null, '2015-07-03 10:09:00', '0', '0', '0', null, 'http://www.psycofe.com/read/readDetail_48641.htm');
INSERT INTO `bsc_topic` VALUES ('4', '2', '2', '积极的领导人能够让员工充满活力', '0', null, '2015-07-03 10:10:00', '0', '0', '0', null, 'http://www.psycofe.com/read/readDetail_48311.htm');

-- ----------------------------
-- Table structure for bsc_topic_comment
-- ----------------------------
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
  CONSTRAINT `topic_idtc_cons` FOREIGN KEY (`topic_id`) REFERENCES `bsc_topic` (`topic_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_topic_comment
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_topic_pic
-- ----------------------------
DROP TABLE IF EXISTS `bsc_topic_pic`;
CREATE TABLE `bsc_topic_pic` (
  `pic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
  `topic_id` int(11) DEFAULT NULL COMMENT '所属话题',
  `pic_mini` varchar(255) NOT NULL COMMENT '图片小图',
  `pic` varchar(255) NOT NULL COMMENT '图片',
  PRIMARY KEY (`pic_id`),
  KEY `topic_idtp_cons` (`topic_id`),
  CONSTRAINT `topic_idtp_cons` FOREIGN KEY (`topic_id`) REFERENCES `bsc_topic` (`topic_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_topic_pic
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_topic_praise
-- ----------------------------
DROP TABLE IF EXISTS `bsc_topic_praise`;
CREATE TABLE `bsc_topic_praise` (
  `topic_id` int(11) NOT NULL COMMENT '所属照片墙',
  `member_id` int(11) NOT NULL COMMENT '赞的人',
  PRIMARY KEY (`topic_id`,`member_id`),
  KEY `member_idtpr_cons` (`member_id`),
  CONSTRAINT `member_idtcp_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
  CONSTRAINT `topic_idtpr_cons` FOREIGN KEY (`topic_id`) REFERENCES `bsc_topic` (`topic_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_topic_praise
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_true
-- ----------------------------
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
  CONSTRAINT `member_idtr_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_true
-- ----------------------------

-- ----------------------------
-- Table structure for bsc_true_msg
-- ----------------------------
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
  CONSTRAINT `true_id_cons` FOREIGN KEY (`true_id`) REFERENCES `bsc_true` (`true_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bsc_true_msg
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bfcljccj
-- ----------------------------
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
  KEY `s1` (`mid`),
  KEY `s2` (`cid`),
  KEY `s3` (`cjdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bfcljccj
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bfcomment
-- ----------------------------
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
  KEY `belong_id` (`belong_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bfcomment
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bfgzxc
-- ----------------------------
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
  KEY `s1` (`mid`),
  KEY `s2` (`cid`),
  KEY `s3` (`dqdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bfgzxc
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bforder
-- ----------------------------
DROP TABLE IF EXISTS `sys_bforder`;
CREATE TABLE `sys_bforder` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `mid` int(11) NOT NULL COMMENT '业务员id',
  `cid` int(11) NOT NULL COMMENT '客户id',
  `order_no` varchar(20) NOT NULL COMMENT '订单号',
  `shr` varchar(20) DEFAULT NULL COMMENT '收货人',
  `tel` varchar(20) DEFAULT NULL COMMENT '电话',
  `address` varchar(50) DEFAULT NULL COMMENT '地址',
  `remo` varchar(300) DEFAULT NULL COMMENT '备注',
  `zje` double(10,2) DEFAULT NULL COMMENT '总金额',
  `zdzk` double(10,2) DEFAULT NULL COMMENT '整单折扣',
  `cjje` double(10,2) DEFAULT NULL COMMENT '成交金额',
  `oddate` varchar(20) NOT NULL COMMENT '日期',
  `order_tp` varchar(20) DEFAULT NULL COMMENT '订单类型',
  `sh_time` varchar(20) DEFAULT NULL COMMENT '送货时间',
  `order_lb` varchar(10) DEFAULT '拜访单' COMMENT '订单类别（拜访单，电话单\r\n\r\n）',
  `odtime` varchar(10) DEFAULT NULL COMMENT '时间',
  `order_zt` varchar(10) DEFAULT '未审核' COMMENT '订单状态（审核，未审核）\r\n\r\n',
  `pszd` varchar(20) DEFAULT NULL COMMENT '配送指定（公司直送，转二批配送）',
  `stk_id` int(11) DEFAULT NULL,
  `shop_member_id` int(11) DEFAULT NULL,
  `shop_member_name` varchar(50),
  status int(11) DEFAULT NULL, 
  pro_type INT(11),
  is_pay INT(11),
  is_send INT(11),
  is_finish INT(11),
  PRIMARY KEY (`id`),
  KEY `mid` (`mid`),
  KEY `cid` (`cid`),
  KEY `order_no` (`order_no`),
  KEY `oddate` (`oddate`),
  KEY `order_tp` (`order_tp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bforder
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bforder_detail
-- ----------------------------
DROP TABLE IF EXISTS `sys_bforder_detail`;
CREATE TABLE `sys_bforder_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单详情id',
  `order_id` int(11) NOT NULL COMMENT '订单id',
  `ware_id` int(11) NOT NULL COMMENT '商品id',
  `ware_num` double(10,2) NOT NULL COMMENT '数量',
  `ware_dj` double(10,2) NOT NULL COMMENT '单价',
  `ware_zj` double(10,2) NOT NULL COMMENT '总价',
  `xs_tp` varchar(20) DEFAULT NULL COMMENT '销售类型',
  `ware_dw` varchar(20) DEFAULT NULL COMMENT '单位',
  `remark` varchar(50) DEFAULT NULL COMMENT 'remark',
  `be_unit` varchar(20),
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `ware_id` (`ware_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bforder_detail
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bforder_msg
-- ----------------------------
DROP TABLE IF EXISTS `sys_bforder_msg`;
CREATE TABLE `sys_bforder_msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '信息id',
  `order_no` varchar(20) NOT NULL COMMENT '订单号',
  `mid` int(11) NOT NULL COMMENT '业务员id',
  `cid` int(11) NOT NULL COMMENT '客户id',
  `msgtime` varchar(20) NOT NULL COMMENT '时间',
  `is_read` int(2) DEFAULT '2' COMMENT '是否已读（1是；2否）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bforder_msg
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bfqdpz
-- ----------------------------
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
  UNIQUE KEY `id` (`id`),
  KEY `s1` (`mid`),
  KEY `s2` (`cid`),
  KEY `s3` (`qddate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bfqdpz
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bfsdhjc
-- ----------------------------
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
  KEY `s1` (`mid`),
  KEY `s2` (`cid`),
  KEY `s3` (`sddate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bfsdhjc
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bfxg_pic
-- ----------------------------
DROP TABLE IF EXISTS `sys_bfxg_pic`;
CREATE TABLE `sys_bfxg_pic` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
  `ss_id` int(11) NOT NULL COMMENT '所属板块id',
  `xx_id` int(11) DEFAULT NULL COMMENT '详细id',
  `type` int(2) NOT NULL COMMENT '1拜访签到拍照；2生动化；3堆头；4陈列检查采集；5道谢并告知下次拜访日期',
  `pic_mini` varchar(255) NOT NULL COMMENT '小图',
  `pic` varchar(255) NOT NULL COMMENT '大图',
  PRIMARY KEY (`id`),
  KEY `s1` (`ss_id`),
  KEY `s2` (`xx_id`),
  KEY `s3` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bfxg_pic
-- ----------------------------
-- ----------------------------
-- Table structure for sys_print_record
-- ----------------------------
   DROP TABLE IF EXISTS `sys_print_record`;
   CREATE TABLE `sys_print_record` (
     `id` int(11) NOT NULL AUTO_INCREMENT,
     `fd_source_id` int(11) DEFAULT NULL,
    `fd_source_no` varchar(36) DEFAULT NULL,
     `create_Id` int(11) DEFAULT NULL,
    `create_Name` varchar(36) DEFAULT NULL,
    `create_Time` datetime  DEFAULT NULL,
    `fd_model` varchar(100) DEFAULT NULL,
     PRIMARY KEY (`id`)
   ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ----------------------------
-- Records of sys_print_record
-- ----------------------------

-- ----------------------------
-- Table structure for sys_bfxsxj
-- ----------------------------
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
  KEY `s1` (`mid`),
  KEY `s2` (`cid`),
  KEY `s3` (`xjdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_bfxsxj
-- ----------------------------

-- ----------------------------
-- Table structure for sys_chat_msg
-- ----------------------------
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
  CONSTRAINT `member_idcm_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_chat_msg
-- ----------------------------

-- ----------------------------
-- Table structure for sys_checkin
-- ----------------------------
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
   sb_type INT(11) COMMENT '上报方式 1:永不上报；2：始终上报',
  PRIMARY KEY (`id`),
  KEY `member_idck_cons` (`psn_id`),
  CONSTRAINT `member_idck_cons` FOREIGN KEY (`psn_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_checkin
-- ----------------------------

-- ----------------------------
-- Table structure for sys_checkin_pic
-- ----------------------------
DROP TABLE IF EXISTS `sys_checkin_pic`;
CREATE TABLE `sys_checkin_pic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `checkin_id` int(11) DEFAULT NULL COMMENT '签到id',
  `pic` varchar(255) DEFAULT NULL COMMENT '图片',
  `pic_mini` varchar(255) DEFAULT NULL COMMENT '小图片',
  PRIMARY KEY (`id`),
  KEY `member_idckp_cons` (`checkin_id`),
  CONSTRAINT `member_idckp_cons` FOREIGN KEY (`checkin_id`) REFERENCES `sys_checkin` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_checkin_pic
-- ----------------------------

-- ----------------------------
-- Table structure for sys_cljccj_md
-- ----------------------------
DROP TABLE IF EXISTS `sys_cljccj_md`;
CREATE TABLE `sys_cljccj_md` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '陈列检查采集模板id',
  `md_nm` varchar(20) NOT NULL COMMENT '名称',
  `is_hjpms` int(2) NOT NULL DEFAULT '1' COMMENT '货架排面数（1显示；2不显示）',
  `is_djpms` int(2) NOT NULL DEFAULT '1' COMMENT '端架排面数（1显示；2不显示）',
  `is_sytwl` int(2) NOT NULL DEFAULT '1' COMMENT '收银台围栏（1显示；2不显示）',
  `is_bds` int(2) NOT NULL DEFAULT '1' COMMENT '冰点数（1显示；2不显示）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_cljccj_md
-- ----------------------------
INSERT INTO `sys_cljccj_md` VALUES ('1', '本品库存', '1', '1', '1', '1');
INSERT INTO `sys_cljccj_md` VALUES ('2', '竞品库存一', '1', '1', '1', '1');
INSERT INTO `sys_cljccj_md` VALUES ('3', '竞品库存二', '1', '2', '2', '2');

-- ----------------------------
-- Table structure for sys_customer
-- ----------------------------
DROP TABLE IF EXISTS `sys_customer`;
CREATE TABLE `sys_customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '客户id',
  `kh_code` varchar(10) DEFAULT NULL COMMENT '编码',
  `kh_nm` varchar(50) NOT NULL COMMENT '名称',
  `kh_tp` int(2) DEFAULT NULL COMMENT '客户种类（1经销商；2客户）',
  `erp_code` varchar(10) DEFAULT NULL COMMENT 'ERP编码',
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
  `tel` varchar(100) DEFAULT NULL COMMENT '电话',
  `mobile` varchar(100) DEFAULT NULL COMMENT '手机',
  `mobile_cx` varchar(20) DEFAULT NULL COMMENT '手机支持彩信',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ',
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
  `is_db` int(2) DEFAULT '2' COMMENT '是否倒闭（1是；2否）',
  `py` varchar(50)  COMMENT '助记码',
   `usc_code` varchar(50),
   `ep_Customer_Id` varchar(50),
   `ep_Customer_Name` varchar(50),
  `is_ep` varchar(20) default '0' COMMENT '是否EP（1是；0或者空 否）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_customer
-- ----------------------------

-- ----------------------------
-- Table structure for sys_depart
-- ----------------------------
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
  PRIMARY KEY (`branch_id`,`branch_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_depart
-- ----------------------------
INSERT INTO `sys_depart` VALUES ('1', '总经办', '0', null, '1', '-1-', '08:00', '12:00', '14:00', '19:00');
INSERT INTO `sys_depart` VALUES ('2', '人事部', '0', null, '1', '-2-', '08:00', '12:00', '14:00', '19:00');
INSERT INTO `sys_depart` VALUES ('3', '销售部', '0', null, '1', '-3-', '08:00', '12:00', '14:00', '19:00');

-- ----------------------------
-- Table structure for sys_deptmempower
-- ----------------------------
DROP TABLE IF EXISTS `sys_deptmempower`;
CREATE TABLE `sys_deptmempower` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dept_id` int(11) NOT NULL COMMENT '部门id',
  `member_id` int(11) NOT NULL COMMENT '成员id',
  `tp` varchar(2) NOT NULL DEFAULT '1' COMMENT '类型（1可见 2 不可见）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='设置成员的部门权限(可见不可见)';

-- ----------------------------
-- Records of sys_deptmempower
-- ----------------------------

-- ----------------------------
-- Table structure for sys_jxsfl
-- ----------------------------
DROP TABLE IF EXISTS `sys_jxsfl`;
CREATE TABLE `sys_jxsfl` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '经销商分类id',
  `coding` varchar(10) DEFAULT NULL COMMENT '编号',
  `fl_nm` varchar(50) NOT NULL COMMENT '名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_jxsfl
-- ----------------------------
INSERT INTO `sys_jxsfl` VALUES ('1', '01', '分类一');
INSERT INTO `sys_jxsfl` VALUES ('2', '02', '分类二');

-- ----------------------------
-- Table structure for sys_jxsjb
-- ----------------------------
DROP TABLE IF EXISTS `sys_jxsjb`;
CREATE TABLE `sys_jxsjb` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '经销商级别id',
  `coding` varchar(10) DEFAULT NULL COMMENT '编号',
  `jb_nm` varchar(50) NOT NULL COMMENT '名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_jxsjb
-- ----------------------------
INSERT INTO `sys_jxsjb` VALUES ('1', '01', '等级一');
INSERT INTO `sys_jxsjb` VALUES ('2', '02', '等级二');

-- ----------------------------
-- Table structure for sys_jxszt
-- ----------------------------
DROP TABLE IF EXISTS `sys_jxszt`;
CREATE TABLE `sys_jxszt` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '经销商状态id',
  `coding` varchar(10) DEFAULT NULL COMMENT '编号',
  `zt_nm` varchar(50) NOT NULL COMMENT '名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_jxszt
-- ----------------------------
INSERT INTO `sys_jxszt` VALUES ('1', '01', '状态一');
INSERT INTO `sys_jxszt` VALUES ('2', '02', '状态二');

-- ----------------------------
-- Table structure for sys_khfbsz
-- ----------------------------
DROP TABLE IF EXISTS `sys_khfbsz`;
CREATE TABLE `sys_khfbsz` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `snums` int(5) NOT NULL COMMENT '开始分钟',
  `enums` int(5) NOT NULL COMMENT '结束分钟',
  `ysz` varchar(10) NOT NULL COMMENT '颜色值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_khfbsz
-- ----------------------------
INSERT INTO `sys_khfbsz` VALUES ('1', '0', '20', '绿色');
INSERT INTO `sys_khfbsz` VALUES ('2', '21', '40', '黑色');
INSERT INTO `sys_khfbsz` VALUES ('3', '41', '120', '红色');

-- ----------------------------
-- Table structure for sys_khlevel
-- ----------------------------
DROP TABLE IF EXISTS `sys_khlevel`;
CREATE TABLE `sys_khlevel` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '客户等级id',
  `qd_id` int(11) NOT NULL COMMENT '渠道id',
  `coding` varchar(10) DEFAULT NULL COMMENT '编码',
  `khdj_nm` varchar(50) NOT NULL COMMENT '名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_khlevel
-- ----------------------------
INSERT INTO `sys_khlevel` VALUES ('1', '3', 'A', 'A');
INSERT INTO `sys_khlevel` VALUES ('2', '3', 'B', 'B');
INSERT INTO `sys_khlevel` VALUES ('3', '3', 'C', 'C');
INSERT INTO `sys_khlevel` VALUES ('4', '3', 'D', 'D');
INSERT INTO `sys_khlevel` VALUES ('5', '1', 'SA', 'SA');
INSERT INTO `sys_khlevel` VALUES ('6', '1', 'SB', 'SB');
INSERT INTO `sys_khlevel` VALUES ('7', '2', 'L', 'L');

-- ----------------------------
-- Table structure for sys_mem
-- ----------------------------
DROP TABLE IF EXISTS `sys_mem`;
CREATE TABLE `sys_mem` (
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
  `first_char` char(2) DEFAULT NULL COMMENT '首字母',
  `branch_id` int(11) DEFAULT NULL COMMENT '所属分组ID',
  `score` int(11) DEFAULT NULL COMMENT '积分',
  `is_lead` char(1) DEFAULT '2' COMMENT '否是领导1，是；2否。',
  `state` char(1) NOT NULL DEFAULT '2' COMMENT '免打扰状态 1：是 2：否',
  `msgmodel` char(1) NOT NULL DEFAULT '1',
  `un_id` varchar(50) DEFAULT NULL COMMENT '唯一码',
  `cid` int(11) DEFAULT '0' COMMENT '客户id',
  `id_key` varchar(50),
  `use_dog` int(2),
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `member_mobile` (`member_mobile`),
  KEY `branch_idm_cons` (`branch_id`),
  CONSTRAINT `branch_idm_cons` FOREIGN KEY (`branch_id`) REFERENCES `sys_depart` (`branch_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='部门成员表';

-- ----------------------------
-- Records of sys_mem
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu_apply
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_apply`;
CREATE TABLE `sys_menu_apply` (
  `id` int(11) NOT NULL COMMENT '自增id',
  `apply_name` varchar(100) DEFAULT NULL COMMENT '应用/菜单名称',
  `apply_code` varchar(100) DEFAULT NULL COMMENT '应用/菜单编码',
  `apply_icon` varchar(100) DEFAULT NULL COMMENT '应用图标/菜单样式',
  `apply_desc` text COMMENT '应用描述',
  `apply_ifwap` char(1) DEFAULT NULL COMMENT '应用类型 0结尾-原生 1结尾-wap',
  `apply_url` varchar(200) DEFAULT NULL COMMENT 'URL访问地址/菜单连接地址',
  `apply_no` int(3) DEFAULT NULL COMMENT '排序/菜单排序',
  `p_id` int(11) DEFAULT NULL COMMENT '父级应用',
  `menu_tp` varchar(2) DEFAULT NULL COMMENT '菜单类型(必填)  0--功能菜单  1-功能按钮（最后一级）',
  `menu_leaf` varchar(2) DEFAULT NULL COMMENT '是否明细菜单  0--否  1--是',
  `create_by` int(11) DEFAULT NULL COMMENT '创建者',
  `create_date` varchar(100) DEFAULT NULL COMMENT '创建时间',
  `is_use` char(1) DEFAULT NULL COMMENT '是否启用 0否 1 是',
  `tp` varchar(5) DEFAULT NULL COMMENT '类型 1 menu 2 应用',
  `menu_id` int(11) DEFAULT NULL COMMENT '绑定菜单id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单/移动端应用表';

-- ----------------------------
-- Records of sys_menu_apply
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oftenuser
-- ----------------------------
DROP TABLE IF EXISTS `sys_oftenuser`;
CREATE TABLE `sys_oftenuser` (
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `bind_member_id` int(11) NOT NULL COMMENT '常用联系人',
  KEY `member_ido_cons` (`member_id`),
  KEY `member_idob_cons` (`bind_member_id`),
  CONSTRAINT `member_idob_cons` FOREIGN KEY (`bind_member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
  CONSTRAINT `member_ido_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_oftenuser
-- ----------------------------

-- ----------------------------
-- Table structure for sys_qdtype
-- ----------------------------
DROP TABLE IF EXISTS `sys_qdtype`;
CREATE TABLE `sys_qdtype` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '渠道类型id',
  `coding` varchar(10) NOT NULL COMMENT '编码',
  `qdtp_nm` varchar(50) NOT NULL COMMENT '名称',
  `remo` varchar(50) DEFAULT NULL COMMENT '注备',
  `is_sx` int(2) DEFAULT '1' COMMENT '是否生效（1是；2否）',
  `sxa_date` varchar(20) DEFAULT NULL COMMENT '生效日期',
  `sxe_date` varchar(20) DEFAULT NULL COMMENT '失效日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_qdtype
-- ----------------------------
INSERT INTO `sys_qdtype` VALUES ('1', 'LS1', '零售', null, '1', '2013-07-15', '2014-07-15');
INSERT INTO `sys_qdtype` VALUES ('2', 'LS2', '连锁', null, '1', '2013-07-15', '2014-07-15');
INSERT INTO `sys_qdtype` VALUES ('3', 'CT', '餐饮', null, '1', '2013-07-15', '2014-07-15');

-- ----------------------------
-- Table structure for sys_questionnaire
-- ----------------------------
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
  CONSTRAINT `member_idm_cons` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_questionnaire
-- ----------------------------

-- ----------------------------
-- Table structure for sys_questionnaire_detail
-- ----------------------------
DROP TABLE IF EXISTS `sys_questionnaire_detail`;
CREATE TABLE `sys_questionnaire_detail` (
  `id` int(8) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `qid` int(8) NOT NULL COMMENT '问卷id',
  `no` varchar(2) NOT NULL COMMENT '排序',
  `content` varchar(50) NOT NULL COMMENT '内容',
  PRIMARY KEY (`id`),
  KEY `q_idqd_cons` (`qid`),
  CONSTRAINT `PK_QUESTTIONNAIRE_QID` FOREIGN KEY (`qid`) REFERENCES `sys_questionnaire` (`qid`) ON DELETE CASCADE,
  CONSTRAINT `q_idqd_cons` FOREIGN KEY (`qid`) REFERENCES `sys_questionnaire` (`qid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_questionnaire_detail
-- ----------------------------

-- ----------------------------
-- Table structure for sys_questionnaire_vote
-- ----------------------------
DROP TABLE IF EXISTS `sys_questionnaire_vote`;
CREATE TABLE `sys_questionnaire_vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `option_id` int(11) NOT NULL DEFAULT '0' COMMENT '选项ID',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '人员ID',
  `problem_id` int(11) NOT NULL DEFAULT '0' COMMENT '问卷ID',
  `add_time` varchar(100) DEFAULT NULL COMMENT '投票时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_vote_mq` (`problem_id`,`option_id`,`member_id`),
  KEY `PK_VOTE_MEMBER` (`member_id`),
  KEY `PK_OPTION_QUEST` (`option_id`),
  KEY `PK_QUEST_PROID` (`problem_id`),
  CONSTRAINT `PK_OPTION_QUEST` FOREIGN KEY (`option_id`) REFERENCES `sys_questionnaire_detail` (`id`) ON DELETE CASCADE,
  CONSTRAINT `PK_QUEST_PROID` FOREIGN KEY (`problem_id`) REFERENCES `sys_questionnaire` (`qid`) ON DELETE CASCADE,
  CONSTRAINT `PK_VOTE_MEMBER` FOREIGN KEY (`member_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_questionnaire_vote
-- ----------------------------

-- ----------------------------
-- Table structure for sys_report
-- ----------------------------
DROP TABLE IF EXISTS `sys_report`;
CREATE TABLE `sys_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '报id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `tp` int(2) DEFAULT '1' COMMENT '报类型(1日报；2周报；3月报)',
  `gz_nr` varchar(255) DEFAULT NULL COMMENT '工作内容',
  `gz_zj` varchar(255) DEFAULT NULL COMMENT '工作总结',
  `gz_jh` varchar(255) DEFAULT NULL COMMENT '工作计划',
  `gz_bz` varchar(255) DEFAULT NULL COMMENT '帮助与支持',
  `remo` varchar(255) DEFAULT NULL COMMENT '备注',
  `fb_time` varchar(20) DEFAULT NULL COMMENT '发布时间',
  `file_nms` varchar(255) DEFAULT NULL COMMENT '附件',
  `address` varchar(100) DEFAULT NULL COMMENT '地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_report
-- ----------------------------

-- ----------------------------
-- Table structure for sys_report_cd
-- ----------------------------
DROP TABLE IF EXISTS `sys_report_cd`;
CREATE TABLE `sys_report_cd` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `gz_nrcd` int(5) NOT NULL COMMENT '工作内容字长度',
  `gz_zjcd` int(5) NOT NULL COMMENT '工作总结字长度',
  `gz_jhcd` int(5) NOT NULL COMMENT '工作计划字长度',
  `gz_bzcd` int(5) NOT NULL COMMENT '帮助与支持字长度',
  `remocd` int(5) NOT NULL COMMENT '备注字长度',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_report_cd
-- ----------------------------
INSERT INTO `sys_report_cd` VALUES ('1', '0', '0', '0', '0', '0');
INSERT INTO `sys_report_cd` VALUES ('2', '0', '0', '0', '0', '0');
INSERT INTO `sys_report_cd` VALUES ('3', '0', '0', '0', '0', '0');

-- ----------------------------
-- Table structure for sys_report_file
-- ----------------------------
DROP TABLE IF EXISTS `sys_report_file`;
CREATE TABLE `sys_report_file` (
  `bid` int(11) NOT NULL COMMENT '报id',
  `tp` int(2) DEFAULT NULL COMMENT '文件类型（1图片；2附件）',
  `pic_mini` varchar(255) DEFAULT NULL COMMENT '小图',
  `pic` varchar(255) DEFAULT NULL COMMENT '大图',
  `wj` varchar(255) DEFAULT NULL COMMENT '附件'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_report_file
-- ----------------------------

-- ----------------------------
-- Table structure for sys_report_pl
-- ----------------------------
DROP TABLE IF EXISTS `sys_report_pl`;
CREATE TABLE `sys_report_pl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bid` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `content` varchar(300) NOT NULL,
  `pltime` varchar(20) NOT NULL,
  `voice_time` int(5) DEFAULT NULL COMMENT '语音时长',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_report_pl
-- ----------------------------

-- ----------------------------
-- Table structure for sys_report_yh
-- ----------------------------
DROP TABLE IF EXISTS `sys_report_yh`;
CREATE TABLE `sys_report_yh` (
  `bid` int(11) NOT NULL COMMENT '报id',
  `fs_mid` int(11) NOT NULL COMMENT '发送用户id',
  `js_mid` int(11) NOT NULL COMMENT '接收用户id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_report_yh
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id_key` int(11) NOT NULL AUTO_INCREMENT,
  `role_nm` varchar(50) DEFAULT NULL,
  `create_dt` varchar(20) DEFAULT NULL,
  `create_id` int(11) DEFAULT NULL,
  `remo` text,
  `role_cd` varchar(100) DEFAULT NULL COMMENT '角色编号',
  PRIMARY KEY (`id_key`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='公司角色表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '公司创建者', '2017-05-17', '196', '', 'gscjz');
INSERT INTO `sys_role` VALUES ('2', '公司管理员', '2017-05-17', '196', '', 'gsgly');
INSERT INTO `sys_role` VALUES ('3', '部门管理员', '2017-05-17', '196', '', 'bmgly');
INSERT INTO `sys_role` VALUES ('4', '普通成员', '2017-05-17', '196', '', 'ptcy');

-- ----------------------------
-- Table structure for sys_role_member
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_member`;
CREATE TABLE `sys_role_member` (
  `role_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公司角色分配关系表';

-- ----------------------------
-- Records of sys_role_member
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `id_key` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `menu_id` int(11) DEFAULT NULL,
  `data_tp` char(1) DEFAULT NULL COMMENT '关联类型 1 全部 2 部门及子部门 3 个人',
  `tp` varchar(5) DEFAULT NULL COMMENT '类型 1 menu 2 应用',
  `sgtjz` varchar(20) DEFAULT NULL COMMENT '四个报表限权',
  `mids` varchar(300) DEFAULT NULL COMMENT '用户id组',
  PRIMARY KEY (`id_key`)
) ENGINE=InnoDB AUTO_INCREMENT=1147 DEFAULT CHARSET=utf8 COMMENT='公司角色菜单关系表';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('856', '2', '1', null, '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('859', '2', '5', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('860', '2', '6', null, '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('861', '2', '7', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('862', '2', '8', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('863', '2', '9', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('864', '2', '10', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('865', '2', '11', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('866', '2', '12', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('867', '2', '13', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('868', '2', '14', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('869', '2', '15', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('870', '2', '16', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('871', '2', '17', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('872', '2', '18', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('873', '2', '19', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('939', '4', '10', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('940', '4', '45', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('941', '4', '47', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('942', '4', '49', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('943', '4', '50', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('944', '4', '54', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('945', '4', '55', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('946', '4', '56', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('947', '4', '57', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('948', '4', '58', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('949', '4', '59', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('950', '4', '60', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('951', '4', '61', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('952', '4', '62', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('953', '4', '63', '3', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('954', '4', '92', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('955', '4', '93', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('956', '4', '94', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('957', '4', '95', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('958', '4', '96', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('959', '4', '97', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('960', '4', '99', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('961', '4', '100', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('962', '4', '101', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('963', '4', '102', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('964', '4', '104', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('981', '4', '97', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('982', '4', '95', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('983', '3', '10', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('984', '3', '31', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('985', '3', '37', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('986', '3', '44', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('987', '3', '45', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('988', '3', '47', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('989', '3', '50', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('990', '3', '54', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('991', '3', '55', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('992', '3', '56', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('993', '3', '57', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('994', '3', '58', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('995', '3', '59', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('996', '3', '60', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('997', '3', '61', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('998', '3', '62', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('999', '3', '63', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1000', '3', '79', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1001', '3', '89', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1002', '3', '92', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1003', '3', '93', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1004', '3', '94', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1005', '3', '95', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1006', '3', '96', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1007', '3', '97', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1008', '3', '99', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1009', '3', '100', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1010', '3', '101', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1011', '3', '102', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1012', '3', '104', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1013', '3', '108', '2', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1030', '3', '97', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1031', '3', '95', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1032', '2', '10', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1033', '2', '29', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1034', '2', '31', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1035', '2', '36', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1036', '2', '4', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1037', '2', '37', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1038', '2', '41', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1039', '2', '44', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1040', '2', '45', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1041', '2', '47', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1042', '2', '48', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1043', '2', '49', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1044', '2', '50', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1045', '2', '51', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1046', '2', '52', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1047', '2', '53', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1048', '2', '54', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1049', '2', '55', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1050', '2', '56', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1051', '2', '57', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1052', '2', '58', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1053', '2', '59', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1054', '2', '60', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1055', '2', '61', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1056', '2', '62', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1057', '2', '63', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1058', '2', '65', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1059', '2', '66', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1060', '2', '67', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1061', '2', '68', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1062', '2', '69', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1063', '2', '72', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1064', '2', '79', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1065', '2', '89', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1066', '2', '90', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1067', '2', '91', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1068', '2', '92', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1069', '2', '93', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1070', '2', '94', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1071', '2', '95', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1072', '2', '96', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1073', '2', '97', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1074', '2', '99', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1075', '2', '100', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1076', '2', '101', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1077', '2', '102', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1078', '2', '103', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1079', '2', '104', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1080', '2', '105', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1081', '2', '108', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1082', '2', '109', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1083', '2', '110', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1084', '2', '111', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1085', '2', '112', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1086', '2', '1', null, '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1105', '3', '97', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1106', '3', '95', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1107', '3', '1', null, '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1108', '3', '5', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1109', '3', '6', null, '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1110', '3', '7', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1111', '3', '8', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1112', '3', '9', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1113', '3', '10', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1114', '3', '11', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1115', '3', '12', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1116', '3', '13', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1117', '3', '14', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1118', '3', '15', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1119', '3', '16', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1120', '3', '17', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1121', '3', '18', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1122', '3', '19', '2', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1123', '3', '4', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1124', '3', '36', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1125', '3', '97', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1126', '3', '95', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1127', '4', '1', null, '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1128', '4', '5', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1129', '4', '6', null, '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1130', '4', '7', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1131', '4', '8', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1132', '4', '9', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1133', '4', '10', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1134', '4', '11', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1135', '4', '12', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1136', '4', '13', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1137', '4', '14', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1138', '4', '15', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1139', '4', '16', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1140', '4', '17', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1141', '4', '18', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1142', '4', '19', '3', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1143', '4', '4', '1', '2', null, null);
INSERT INTO `sys_role_menu` VALUES ('1144', '4', '36', '1', '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1145', '4', '97', null, '1', null, null);
INSERT INTO `sys_role_menu` VALUES ('1146', '4', '95', null, '1', null, null);

-- ----------------------------
-- Table structure for sys_task
-- ----------------------------
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
  PRIMARY KEY (`id`,`task_title`),
  KEY `id` (`id`),
  KEY `PK_PARPER_ID` (`parent_id`),
  KEY `create_byt_cons` (`create_by`),
  CONSTRAINT `create_byt_cons` FOREIGN KEY (`create_by`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
  CONSTRAINT `PK_PARPER_ID` FOREIGN KEY (`parent_id`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_task
-- ----------------------------

-- ----------------------------
-- Table structure for sys_task_attachment
-- ----------------------------
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
  CONSTRAINT `PK_TASK_TASKATT` FOREIGN KEY (`nid`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_task_attachment
-- ----------------------------
INSERT INTO `sys_task_attachment` VALUES ('1', null, '企微宝用户手册.docx', '144117827151509885.docx', '2', null, '2015-09-02 14:48:36', '3.2MB', '1441176116216');

-- ----------------------------
-- Table structure for sys_task_feedback
-- ----------------------------
DROP TABLE IF EXISTS `sys_task_feedback`;
CREATE TABLE `sys_task_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nid` int(11) DEFAULT NULL COMMENT '所属照片墙',
  `persent` float DEFAULT NULL,
  `remarks` text,
  `dt_date` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `PK_FEEDBACK_TASK` (`nid`),
  CONSTRAINT `PK_FEEDBACK_TASK` FOREIGN KEY (`nid`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_task_feedback
-- ----------------------------

-- ----------------------------
-- Table structure for sys_task_ing
-- ----------------------------
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
  CONSTRAINT `task_idt_consi` FOREIGN KEY (`task_id`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_task_ing
-- ----------------------------

-- ----------------------------
-- Table structure for sys_task_msg
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_task_msg
-- ----------------------------

-- ----------------------------
-- Table structure for sys_task_psn
-- ----------------------------
DROP TABLE IF EXISTS `sys_task_psn`;
CREATE TABLE `sys_task_psn` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `psn_type` int(11) DEFAULT NULL COMMENT '赞的人',
  `psn_id` int(11) DEFAULT NULL,
  `nid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `PK_PSN_MEM_MEMBERID` (`psn_id`) USING BTREE,
  KEY `systask_id` (`nid`),
  CONSTRAINT `MEMBWER_IDT` FOREIGN KEY (`psn_id`) REFERENCES `sys_mem` (`member_id`) ON DELETE CASCADE,
  CONSTRAINT `systask_id` FOREIGN KEY (`nid`) REFERENCES `sys_task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_task_psn
-- ----------------------------

-- ----------------------------
-- Table structure for sys_ware
-- ----------------------------
DROP TABLE IF EXISTS `sys_ware`;
CREATE TABLE `sys_ware` (
  `ware_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `waretype` int(11) NOT NULL COMMENT '所属分类',
  `ware_code` varchar(25) NOT NULL,
  `ware_nm` varchar(50) NOT NULL COMMENT '名称',
  `ware_gg` varchar(20) NOT NULL COMMENT '规格',
  `ware_dw` varchar(10) NOT NULL COMMENT '单位',
  `ware_dj` double(10,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
  `fbtime` varchar(20) NOT NULL COMMENT '发布时间',
  `is_cy` int(2) DEFAULT '2' COMMENT '是否常用（1是；2否）',
  `tran_amt` double(10,2) NOT NULL DEFAULT '0.00' COMMENT '单位运输费用',
  `tc_amt` double(10,2) NOT NULL DEFAULT '0.00' COMMENT '单位提成费用',
   `quality_Days` varchar(50) DEFAULT NULL COMMENT '保质期天数',
  `remark` varchar(50) DEFAULT NULL COMMENT '备注',
  `be_bar_code` varchar(50) DEFAULT NULL COMMENT '单品条码',
  `pack_bar_code` varchar(50) DEFAULT NULL COMMENT '包装条码',
  `max_unit` varchar(50) DEFAULT NULL ,
  `produce_date` varchar(50) DEFAULT NULL COMMENT '生产日期',
  `provider_name` varchar(50) DEFAULT NULL COMMENT '供应商',
  `lower_limit` decimal(10,2) DEFAULT NULL COMMENT '最低库存',
  `in_price` decimal(10,2) DEFAULT NULL COMMENT '采购价格',
  `order_cd` int(11) DEFAULT NULL COMMENT '排序码',
  `hs_num` double(10,7) DEFAULT NULL COMMENT '换算数量',
  `min_unit` varchar(20) DEFAULT NULL,
  `max_unit_code` varchar(20) DEFAULT NULL,
  `min_unit_code` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT '1',
  `b_unit` double(6,2),
  `s_unit` double(6,2),
  `py` varchar(50),
  `put_on` varchar(2),
  `group_ids` varchar(100),
  `group_nms` varchar(200),
  `sunit_price` decimal(10,2),
  `ls_price` decimal(10,2),
   `warn_qty` decimal(10,2),
   alias_name varchar(50),
   asn_no varchar(50),
   shop_alarm decimal(10,2) COMMENT '门店库存预警',
   default_qty decimal(10,2) COMMENT '默认补货数量',
   init_qty decimal(10,2) COMMENT '初始库存数量',
   is_use_stk int COMMENT '是否使用库存',
   pos_price1 decimal(10,2) COMMENT '门店零售价1',
   pos_price2 decimal(10,2) COMMENT '门店零售价2',
   sunit_front int(2) default null,
   ware_desc text null COMMENT '商品描述',
  PRIMARY KEY (`ware_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_ware
-- ----------------------------

-- ----------------------------
--  Table structure for `sys_ware_pic`
-- ----------------------------
DROP TABLE IF EXISTS `sys_ware_pic`;
CREATE TABLE `sys_ware_pic` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
  `type` int(2) DEFAULT NULL,
  `pic_mini` varchar(255) NOT NULL COMMENT '小图',
  `pic` varchar(255) NOT NULL COMMENT '大图',
  `ware_id` int(11) DEFAULT NULL COMMENT '商品id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ----------------------------
-- Records of `sys_ware_pic`
-- ----------------------------


-- ----------------------------
-- Table structure for sys_waretype
-- ----------------------------
DROP TABLE IF EXISTS `sys_waretype`;
CREATE TABLE `sys_waretype` (
  `waretype_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `waretype_nm` varchar(20) NOT NULL COMMENT '分类名称',
  `waretype_pid` int(11) DEFAULT NULL COMMENT '所属分类',
  `waretype_path` varchar(20) DEFAULT NULL COMMENT '分类路径',
  `waretype_leaf` char(1) DEFAULT NULL COMMENT '分类末级',
  `no_Company` int(2),
  shop_qy int(2),
  PRIMARY KEY (`waretype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_waretype
-- ----------------------------

-- ----------------------------
-- Table structure for sys_xtcs
-- ----------------------------
DROP TABLE IF EXISTS `sys_xtcs`;
CREATE TABLE `sys_xtcs` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '系统参数id',
  `xt_nm` varchar(20) NOT NULL COMMENT '名称',
  `xt_csz` int(10) NOT NULL COMMENT '数值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_xtcs
-- ----------------------------
INSERT INTO `sys_xtcs` VALUES ('1', '轨迹控制时间', '60');

-- ----------------------------
-- Table structure for sys_yfile
-- ----------------------------
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
  `fsize` varchar(20) NOT NULL COMMENT '文件大小',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_yfile
-- ----------------------------

-- ----------------------------
-- Table structure for sys_yfilepwd
-- ----------------------------
DROP TABLE IF EXISTS `sys_yfilepwd`;
CREATE TABLE `sys_yfilepwd` (
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `yf_pwd` varchar(20) NOT NULL COMMENT '云盘密码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_yfilepwd
-- ----------------------------

-- ----------------------------
-- Table structure for sys_zcusr
-- ----------------------------
DROP TABLE IF EXISTS `sys_zcusr`;
CREATE TABLE `sys_zcusr` (
  `zusr_id` int(11) NOT NULL COMMENT '主用户id',
  `cusr_id` int(11) NOT NULL COMMENT '次用户id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_zcusr
-- ----------------------------

-- ----------------------------
--  Table structure for `sys_config`
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `fd_model` varchar(100) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ----------------------------
-- Records of sys_config
-- ----------------------------

-- ----------------------------
-- Table structure for sys_customer_hzfs
-- ----------------------------
DROP TABLE IF EXISTS `sys_customer_hzfs`;
CREATE TABLE `sys_customer_hzfs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hzfs_nm` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_customer_hzfs
-- ----------------------------

-- ----------------------------
--  Table structure for `fin_acc_io`
-- ----------------------------
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
  `io_amt` decimal(10,2) DEFAULT NULL COMMENT '变化金额',
  `in_amt` decimal(10,2) DEFAULT NULL COMMENT '收入金额',
  `out_amt` decimal(10,2) DEFAULT NULL COMMENT '支出金额',
  `operator` varchar(50) DEFAULT NULL COMMENT '操作员',
  `status` int(11) DEFAULT NULL COMMENT '状态',
  `bill_no` varchar(50) DEFAULT NULL COMMENT '单号',
  `obj_name` varchar(100) DEFAULT NULL,
  `left_amt` decimal(10,2) DEFAULT NULL,
  `remarks1` varchar(600) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1781 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_account`
-- ----------------------------
DROP TABLE IF EXISTS `fin_account`;
CREATE TABLE `fin_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(50) DEFAULT NULL,
  `acc_no` varchar(50) DEFAULT NULL,
  `acc_amt` decimal(10,2) DEFAULT NULL,
  `acc_type` int(11) DEFAULT NULL COMMENT '0 现金 1微信 2支付宝 3银行',
  `status` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `acc_name` varchar(100) DEFAULT NULL,
  `is_post` varchar(10),
   is_pay varchar(11) null,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_cost`
-- ----------------------------
DROP TABLE IF EXISTS `fin_cost`;
CREATE TABLE `fin_cost` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(50) DEFAULT NULL,
  `cost_time` datetime DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `dep_id` int(11) DEFAULT NULL,
  `total_amt` decimal(10,2) DEFAULT NULL,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_cost_term`
-- ----------------------------
DROP TABLE IF EXISTS `fin_cost_term`;
CREATE TABLE `fin_cost_term` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `cost_type` int(11) DEFAULT NULL,
  `term_amt` decimal(10,2) DEFAULT NULL,
  `yymm` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_costitem`
-- ----------------------------
DROP TABLE IF EXISTS `fin_costitem`;
CREATE TABLE `fin_costitem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_name` varchar(50) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
   `mark` varchar(2) DEFAULT NULL,
   system_id varchar(36) DEFAULT NULL,
   no varchar(50) DEFAULT NULL,
   `system_name` varchar(50) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_costsub`
-- ----------------------------
DROP TABLE IF EXISTS `fin_costsub`;
CREATE TABLE `fin_costsub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `cost_id` varchar(50) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_costtype`
-- ----------------------------
DROP TABLE IF EXISTS `fin_costtype`;
CREATE TABLE `fin_costtype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) DEFAULT NULL,
   system_id varchar(36) DEFAULT NULL,
   no varchar(50) DEFAULT NULL,
   `system_name` varchar(50) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_in`
-- ----------------------------
DROP TABLE IF EXISTS `fin_in`;
CREATE TABLE `fin_in` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(50) DEFAULT NULL,
  `bill_time` datetime DEFAULT NULL,
  `pro_id` int(11) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `total_amt` decimal(10,2) DEFAULT NULL,
  `acc_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `submit_user` varchar(50) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `pay_amt` decimal(10,2) DEFAULT NULL,
   free_amt decimal(10,2) default 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_income`
-- ----------------------------
DROP TABLE IF EXISTS `fin_income`;
CREATE TABLE `fin_income` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cst_id` int(11) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `acc_id` int(11) DEFAULT NULL,
  `rec_amt` decimal(10,2) DEFAULT NULL,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_income_item`
-- ----------------------------
DROP TABLE IF EXISTS `fin_income_item`;
CREATE TABLE `fin_income_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_name` varchar(50) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `remarks` varchar(50) DEFAULT NULL,
   system_id varchar(36) DEFAULT NULL,
   no varchar(50) DEFAULT NULL,
  `mark` varchar(2) DEFAULT NULL,
  `system_name` varchar(50) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_income_sub`
-- ----------------------------
DROP TABLE IF EXISTS `fin_income_sub`;
CREATE TABLE `fin_income_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_income_type`
-- ----------------------------
DROP TABLE IF EXISTS `fin_income_type`;
CREATE TABLE `fin_income_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) DEFAULT NULL,
   system_id varchar(36) DEFAULT NULL,
   no varchar(50) DEFAULT NULL,
   `system_name` varchar(50) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_insub`
-- ----------------------------
DROP TABLE IF EXISTS `fin_insub`;
CREATE TABLE `fin_insub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_io_item`
-- ----------------------------
DROP TABLE IF EXISTS `fin_io_item`;
CREATE TABLE `fin_io_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_name` varchar(50) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
   system_id varchar(36) DEFAULT NULL,
   no varchar(50) DEFAULT NULL,
    `system_name` varchar(50) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_io_type`
-- ----------------------------
DROP TABLE IF EXISTS `fin_io_type`;
CREATE TABLE `fin_io_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) DEFAULT NULL,
   system_id varchar(36) DEFAULT NULL,
   no varchar(50) DEFAULT NULL,
   `system_name`  varchar(50) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_out`
-- ----------------------------
DROP TABLE IF EXISTS `fin_out`;
CREATE TABLE `fin_out` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(50) DEFAULT NULL,
  `bill_time` datetime DEFAULT NULL,
  `pro_id` int(11) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `total_amt` decimal(10,2) DEFAULT NULL,
  `acc_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `submit_user` varchar(50) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `pay_amt` decimal(10,2) DEFAULT NULL,
  free_amt decimal(10,2) default 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_outsub`
-- ----------------------------
DROP TABLE IF EXISTS `fin_outsub`;
CREATE TABLE `fin_outsub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_pay`
-- ----------------------------
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
  `pay_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `submit_user` varchar(50) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `acc_id` int(11) DEFAULT NULL,
  `remarks` varchar(400) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `cost_term` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_paysub`
-- ----------------------------
DROP TABLE IF EXISTS `fin_paysub`;
CREATE TABLE `fin_paysub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `cost_id` int(11) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_trans`
-- ----------------------------
DROP TABLE IF EXISTS `fin_trans`;
CREATE TABLE `fin_trans` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '转出账号类型',
  `sacc_type` int(11) DEFAULT NULL,
  `sacc_id` int(11) DEFAULT NULL,
  `tacc_type` int(11) DEFAULT NULL,
  `tacc_id` int(11) DEFAULT NULL,
  `trans_amt` decimal(10,2) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `trans_time` datetime DEFAULT NULL,
  `bill_no` varchar(50) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `submit_user` varchar(50) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_pre_in`
-- ----------------------------
DROP TABLE IF EXISTS `fin_pre_in`;
CREATE TABLE `fin_pre_in` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(50) DEFAULT NULL,
  `bill_time` datetime DEFAULT NULL,
  `pro_id` int(11) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `total_amt` decimal(10,2) DEFAULT NULL,
  `acc_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `submit_user` varchar(50) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `pay_amt` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fin_pre_insub`
-- ----------------------------
DROP TABLE IF EXISTS `fin_pre_insub`;
CREATE TABLE `fin_pre_insub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for fin_pre_out
-- ----------------------------
DROP TABLE IF EXISTS `fin_pre_out`;
CREATE TABLE `fin_pre_out` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(50) DEFAULT NULL,
  `bill_time` datetime DEFAULT NULL,
  `pro_id` int(11) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `total_amt` decimal(10,2) DEFAULT NULL,
  `acc_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `submit_user` varchar(50) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `pay_amt` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of fin_pre_out
-- ----------------------------

-- ----------------------------
-- Table structure for fin_pre_outsub
-- ----------------------------
DROP TABLE IF EXISTS `fin_pre_outsub`;
CREATE TABLE `fin_pre_outsub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of fin_pre_outsub
-- ----------------------------
-- ----------------------------
--  Table structure for `fin_unit`
-- ---------------------------
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
  `left_amt` decimal(10,2) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `fbtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_check`
-- ----------------------------
DROP TABLE IF EXISTS `stk_check`;
CREATE TABLE `stk_check` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(50) DEFAULT NULL,
  `check_time` datetime DEFAULT NULL,
  `stk_id` int(11) DEFAULT NULL,
  `staff` varchar(50) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `total_amt` decimal(10,2) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_checksub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_checksub`;
CREATE TABLE `stk_checksub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `dis_qty` decimal(10,2) DEFAULT NULL,
  `stk_qty` decimal(10,2) DEFAULT NULL,
  `min_qty` decimal(10,2) DEFAULT NULL,
  `min_unit` varchar(20) DEFAULT NULL,
  `produce_date` varchar(20) DEFAULT NULL,
   sunit_price decimal(13,5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=620 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_dict`
-- ----------------------------
DROP TABLE IF EXISTS `stk_dict`;
CREATE TABLE `stk_dict` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(255) DEFAULT NULL,
  `io_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_driver`
-- ----------------------------
DROP TABLE IF EXISTS `stk_driver`;
CREATE TABLE `stk_driver` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `driver_name` varchar(50) DEFAULT NULL,
  `tel` varchar(50) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_emp_ware`
-- ----------------------------
DROP TABLE IF EXISTS `stk_emp_ware`;
CREATE TABLE `stk_emp_ware` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_in`
-- ----------------------------
DROP TABLE IF EXISTS `stk_in`;
CREATE TABLE `stk_in` (
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
  `total_amt` decimal(10,2) DEFAULT NULL,
  `pay_amt` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `dis_amt1` decimal(10,0) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `order_no` varchar(50) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `emp_nm` varchar(50) DEFAULT NULL,
    `veh_id` int(11) DEFAULT NULL,
   `driver_id` int(11) DEFAULT NULL,
   `reaudit_desc` varchar(500) DEFAULT NULL,
   `sure_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_insub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_insub`;
CREATE TABLE `stk_insub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(13,5) DEFAULT NULL,
  `price` decimal(13,5) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(13,5) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `product_date` varchar(50),
  `in_type_code` varchar(50) DEFAULT NULL,
  `in_type_name` varchar(50) DEFAULT NULL,
  `rebate_price` decimal(13,5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1874 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_out`
-- ----------------------------
DROP TABLE IF EXISTS `stk_out`;
CREATE TABLE `stk_out` (
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
  `total_amt` decimal(10,2) DEFAULT NULL,
  `rec_amt` decimal(10,2) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  `kh_nm` varchar(50) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `dis_amt1` decimal(10,2) DEFAULT NULL,
  `staff` varchar(50) DEFAULT NULL,
  `staff_tel` varchar(50) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `send_time` datetime DEFAULT NULL,
  `ep_customer_id` varchar(50) DEFAULT NULL,
  `ep_customer_name` varchar(50) DEFAULT NULL,
   `emp_id` int(11) DEFAULT NULL,
   `veh_id` int(11) DEFAULT NULL,
   `driver_id` int(11) DEFAULT NULL,
  `reaudit_desc` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_outsub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_outsub`;
CREATE TABLE `stk_outsub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(13,5) DEFAULT NULL,
  `price` decimal(13,5) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `xs_tp` varchar(50) DEFAULT NULL,
  `out_qty` decimal(13,5) DEFAULT NULL,
  `out_amt` decimal(10,2) DEFAULT NULL,
  `product_date` varchar(50) DEFAULT NULL,
  `active_date` varchar(50) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `be_unit` varchar(20),
  ssw_id varchar(50),
  `rebate_price` decimal(13,5) DEFAULT NULL,
   help_qty decimal(13,5),
   help_unit varchar(10),
  PRIMARY KEY (`id`),
  KEY `mast_id` (`mast_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_params`
-- ----------------------------
DROP TABLE IF EXISTS `stk_params`;
CREATE TABLE `stk_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `param_name` varchar(50) DEFAULT NULL,
  `param_value` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_pay_mast`
-- ----------------------------
DROP TABLE IF EXISTS `stk_pay_mast`;
CREATE TABLE `stk_pay_mast` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pro_id` int(11) DEFAULT NULL,
  `sum_amt` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `mid` int(11) DEFAULT NULL,
  `pay_time` datetime DEFAULT NULL,
  `bill_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `cash` decimal(10,2) DEFAULT NULL,
  `bank` decimal(10,2) DEFAULT NULL,
  `wx` decimal(10,2) DEFAULT NULL,
  `zfb` decimal(10,2) DEFAULT NULL,
  `bill_type` int(11) DEFAULT NULL,
  `bill_no` varchar(50) DEFAULT NULL,
  `pre_no` varchar(50),
  `pre_id` int(11),
  `pre_amt` decimal(10,2),
   `cost_id` int(11) DEFAULT NULL,
   pro_type int(11)  DEFAULT NULL,
   pro_name varchar(50)  DEFAULT NULL,
   source_bill_no varchar(50)  DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=905 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_payment`
-- ----------------------------
DROP TABLE IF EXISTS `stk_payment`;
CREATE TABLE `stk_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pay_amt` decimal(10,2) DEFAULT NULL,
  `pay_type` varchar(50) DEFAULT NULL,
  `mast_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_plan`
-- ----------------------------
DROP TABLE IF EXISTS `stk_plan`;
CREATE TABLE `stk_plan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_time` datetime DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_plansub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_plansub`;
CREATE TABLE `stk_plansub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `in_price` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `start_time` varchar(50) DEFAULT NULL,
  `end_time` varchar(50) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `discount2` decimal(10,2) DEFAULT NULL,
  `discount3` decimal(10,2) DEFAULT NULL,
  `discount4` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_print_set`
-- ----------------------------
DROP TABLE IF EXISTS `stk_print_set`;
CREATE TABLE `stk_print_set` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `bill_name` varchar(50) DEFAULT NULL,
  `tel` varchar(50) DEFAULT NULL,
  `print_memo` varchar(200) DEFAULT NULL,
  `other1` varchar(200) DEFAULT NULL,
  `other2` varchar(200) DEFAULT NULL,
  `alipay_qrcode`  varchar(255) NULL COMMENT '支付宝收款码',
  `wxpay_qrcode`  varchar(255) NULL COMMENT '微信收款码' ,
  `display_alipay`  int(4) NULL DEFAULT 0 COMMENT '是否显示支付宝收款码0不显示 1显示',
  `display_wxpay`  int(4)  NULL DEFAULT 0 COMMENT '是否显示微信收款码0不显示1显示',
  `master_height`  int(11) NULL COMMENT '表头高度',
 `slave_height`  int(11) NULL COMMENT '从表高度',
 `display_border`  int(4) NULL DEFAULT 0 COMMENT '是否显示主表边框 0不显示 1显示',
  `master_fontsize`  int(11) NULL COMMENT '主表字体大小',
  `qrcode_width` int(11) DEFAULT NULL COMMENT '收款码宽度',
  `qrcode_height` int(11) DEFAULT NULL COMMENT '收款码高度',
  `repeat_title` tinyint(4) DEFAULT '1' COMMENT '是否重复抬头',
  `repeat_footer` tinyint(4) DEFAULT '1' COMMENT '是否重复页脚',
  `page_height` int(11) DEFAULT 470 COMMENT '纸张高度',
  `display_salesman` int(4) DEFAULT 1 COMMENT '是否显示业务员信息',
   `display_customer_dept`  tinyint(4) NULL DEFAULT 0 COMMENT '显示客户欠款 0不显示 1显示',
   `display_unit_count` tinyint(4) DEFAULT 0 COMMENT '是否显示大小单位统计',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_provider`
-- ----------------------------
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
  `left_amt` decimal(10,2) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `fbtime` varchar(20) DEFAULT NULL,
  `usc_code` varchar(50),
  `py` varchar(100),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_rec_mast`
-- ----------------------------
DROP TABLE IF EXISTS `stk_rec_mast`;
CREATE TABLE `stk_rec_mast` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cst_id` int(11) DEFAULT NULL,
  `sum_amt` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `mid` int(11) DEFAULT NULL,
  `rec_time` datetime DEFAULT NULL,
  `bill_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `cash` decimal(10,2) DEFAULT NULL,
  `bank` decimal(10,2) DEFAULT NULL,
  `wx` decimal(10,2) DEFAULT NULL,
  `zfb` decimal(10,2) DEFAULT NULL,
  `bill_type` int(11) DEFAULT NULL,
  `bill_no` varchar(50) DEFAULT NULL,
  `pre_no` varchar(50),
  `pre_id` int(11),
  `pre_amt` decimal(10,2),
   `cost_id` int(11),
   pro_id int(11)  DEFAULT NULL, 
   pro_type int(11)  DEFAULT NULL,
   pro_name varchar(50)  DEFAULT NULL,
   source_bill_no varchar(50)  DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1690 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_right`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=402 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_rpt_org_main`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_rpt_org_sub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_rpt_org_sub`;
CREATE TABLE `stk_rpt_org_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `ware_id` int(11) DEFAULT NULL,
  `ware_nm` varchar(100) DEFAULT NULL COMMENT '名称',
  `main_id` int(11) DEFAULT NULL,
  `unit_name` varchar(20) DEFAULT NULL COMMENT '单位',
  `bill_name` varchar(10) DEFAULT NULL COMMENT '销售类型',
  `out_qty` double(10,2) DEFAULT '0.00' COMMENT '单价',
  `unit_amt` double(10,2) DEFAULT '0.00' COMMENT '单位费用',
  `customer_Id` int(11) DEFAULT NULL,
  `customer_name` varchar(100) DEFAULT NULL COMMENT '客户名称',
  `sum_amt` double(10,2) DEFAULT '0.00' COMMENT '总费用',
  `driver_id` int(1) DEFAULT NULL,
  `driver_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2331 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_send`
-- ----------------------------
DROP TABLE IF EXISTS `stk_send`;
CREATE TABLE `stk_send` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `out_id` int(11) DEFAULT NULL COMMENT '发货单id',
  `send_time` datetime DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `veh_id` int(11) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `ep_customer_id` varchar(50) DEFAULT NULL,
  `ep_customer_name` varchar(50) DEFAULT NULL,
  `voucher_no` varchar(50) DEFAULT NULL,
  `stk_id` int(11) DEFAULT NULL,
  `bill_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `stk_sendsub`;
CREATE TABLE `stk_sendsub`(
  `id` int(11) NOT NULL AUTO_INCREMENT,
   `mast_id` int(11) DEFAULT NULL,
 `ware_id` int(11) DEFAULT NULL,
   `qty` decimal(13,5) DEFAULT NULL,
 `price` decimal(13,5) DEFAULT NULL,
 `amt` decimal(10,2) DEFAULT NULL,
   `unit_name` varchar(50) DEFAULT NULL,
  `xs_tp` varchar(50) DEFAULT NULL,
  `out_qty` decimal(13,5) DEFAULT NULL,
  `out_amt` decimal(10,2) DEFAULT NULL,
  `product_date` varchar(50) DEFAULT NULL,
  `active_date` varchar(50) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
   `rebate_price` decimal(13,5) DEFAULT NULL,
 `be_unit` varchar(20) DEFAULT NULL,
 `sub_id` int(11) DEFAULT NULL,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_storage`
-- ----------------------------
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
  `sale_car` varchar(2),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_storage_io`
-- ----------------------------
DROP TABLE IF EXISTS `stk_storage_io`;
CREATE TABLE `stk_storage_io` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stk_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `bill_no` varchar(50) DEFAULT NULL,
  `bill_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(16,10) DEFAULT NULL,
  `out_qty` decimal(16,10) DEFAULT NULL,
  `io_price` decimal(13,5) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `left_qty` decimal(11,5) DEFAULT NULL,
  `io_time` datetime DEFAULT NULL,
  `bill_id` int(11) DEFAULT NULL,
  `bat_id` int(11) DEFAULT NULL,
  `in_price` decimal(13,5) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `sub_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `stk_unit` varchar(100) DEFAULT NULL,
  `io_bill_id` int(11) DEFAULT NULL,
  `rebate_price` decimal(13,5) DEFAULT NULL,
   pro_type int(11) DEFAULT null,
   bill_time datetime DEFAULT null,
  `be_unit` varchar(20),
`product_date` varchar(50),
  PRIMARY KEY (`id`),
  KEY `bill_id` (`bill_id`),
  KEY `ware_id` (`ware_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_storage_ware`
-- ----------------------------
DROP TABLE IF EXISTS `stk_storage_ware`;
CREATE TABLE `stk_storage_ware` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stk_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_price` decimal(13,5) DEFAULT NULL,
  `qty` decimal(16,10) DEFAULT NULL,
  `in_time` datetime DEFAULT NULL,
  `bill_id` int(11) DEFAULT NULL,
  `be_unit` varchar(10),
  `product_date` varchar(50),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2050 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_summary`
-- ----------------------------
DROP TABLE IF EXISTS `stk_summary`;
CREATE TABLE `stk_summary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ware_id` int(11) DEFAULT NULL,
  `init_qty` decimal(10,2) DEFAULT NULL,
  `init_amt` decimal(10,2) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `out_qty` decimal(10,2) DEFAULT NULL,
  `end_qty` decimal(10,2) DEFAULT NULL,
  `end_amt` decimal(10,2) DEFAULT NULL,
  `start_date` varchar(20) DEFAULT NULL,
  `close_date` varchar(20) DEFAULT NULL,
  `stk_id` int(11) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `out_amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty1` decimal(10,2) DEFAULT NULL,
  `out_qty1` decimal(10,2) DEFAULT NULL,
  `in_amt1` decimal(10,2) DEFAULT NULL,
  `out_amt1` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_vehicle`
-- ----------------------------
DROP TABLE IF EXISTS `stk_vehicle`;
CREATE TABLE `stk_vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `veh_no` varchar(50) DEFAULT NULL,
  `veh_type` varchar(50) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_ware`
-- ----------------------------
DROP TABLE IF EXISTS `stk_ware`;
CREATE TABLE `stk_ware` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ware_id` int(11) DEFAULT NULL,
  `in_price` decimal(10,2) DEFAULT NULL,
  `py` varchar(50) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_ware_choose`
-- ----------------------------
DROP TABLE IF EXISTS `stk_ware_choose`;
CREATE TABLE `stk_ware_choose` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ware_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_move`
-- ----------------------------
DROP TABLE IF EXISTS `stk_move`;
CREATE TABLE `stk_move` (
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
  `total_amt` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `dis_amt1` decimal(10,0) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_movesub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_movesub`;
CREATE TABLE `stk_movesub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_movesub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_movesub`;
CREATE TABLE `stk_movesub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_movesub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_movesub`;
CREATE TABLE `stk_movesub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_move_io`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_move_io_sub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_move_io_sub`;
CREATE TABLE `stk_move_io_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `be_qty` decimal(10,2) DEFAULT NULL,
  `be_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `io_mark` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for stk_collar_item
-- ----------------------------
DROP TABLE IF EXISTS `stk_collar_item`;
CREATE TABLE `stk_collar_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `product_date` varchar(50) DEFAULT NULL,
  `source_main_id` int(11) DEFAULT NULL,
  `source_main_no` varchar(50) DEFAULT NULL,
  `source_item_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of stk_collar_item
-- ----------------------------

-- ----------------------------
-- Table structure for stk_customer_ware_group
-- ----------------------------
DROP TABLE IF EXISTS `stk_customer_ware_group`;
CREATE TABLE `stk_customer_ware_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `asn` varchar(100) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of stk_customer_ware_group
-- ----------------------------

-- ----------------------------
-- Table structure for stk_customer_ware_items
-- ----------------------------
DROP TABLE IF EXISTS `stk_customer_ware_items`;
CREATE TABLE `stk_customer_ware_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of stk_customer_ware_items
-- ----------------------------

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS `stk_llhk_comesub`;
CREATE TABLE `stk_llhk_comesub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(13,5) DEFAULT NULL,
  `price` decimal(13,5) DEFAULT NULL,
  `amt` decimal(11,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(13,5) DEFAULT NULL,
 `in_amt` decimal(11,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `product_date` varchar(50) DEFAULT NULL,
  `in_type_code` varchar(50) DEFAULT NULL,
  `in_type_name` varchar(50) DEFAULT NULL,
  `sub_id` int(11) DEFAULT NULL,
  `rebate_Price` decimal(10,5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
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
  `total_amt` decimal(11,2) DEFAULT NULL,
  `pay_amt` decimal(11,2) DEFAULT NULL,
  `discount` decimal(11,2) DEFAULT NULL,
  `dis_amt` decimal(11,2) DEFAULT NULL,
  `operator` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `free_amt` decimal(11,2) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
 `pro_type` int(11) DEFAULT NULL,
  `dis_amt1` decimal(11,2) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `order_no` varchar(50) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `emp_nm` varchar(50) DEFAULT NULL,
  `veh_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `reaudit_desc` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_name` (`bill_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS `stk_llhk_insub`;
CREATE TABLE `stk_llhk_insub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(13,5) DEFAULT NULL,
  `price` decimal(13,5) DEFAULT NULL,
  `amt` decimal(11,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(13,5) DEFAULT NULL,
  `in_amt` decimal(11,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `product_date` varchar(50) DEFAULT NULL,
  `in_type_code` varchar(50) DEFAULT NULL,
  `in_type_name` varchar(50) DEFAULT NULL,
  `rebate_Price` decimal(10,5) DEFAULT NULL,
  `pickup_sub_Ids` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



-- ----------------------------
-- Table structure for sys_waretype_pic
-- ----------------------------
DROP TABLE IF EXISTS `sys_waretype_pic`;
CREATE TABLE `sys_waretype_pic` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
  `type` int(2) DEFAULT NULL,
  `pic_mini` varchar(255) NOT NULL COMMENT '小图',
  `pic` varchar(255) NOT NULL COMMENT '大图',
  `waretype_id` int(11) DEFAULT NULL COMMENT '商品类型id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_waretype_pic
-- ----------------------------

-- ----------------------------
--  Table structure for `sys_customer_price`
-- ----------------------------
DROP TABLE IF EXISTS `sys_customer_price`;
CREATE TABLE `sys_customer_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `ware_id` int(11) NOT NULL COMMENT '商品ID',
  `customer_id` int(11) NOT NULL COMMENT '客户ID',
  `sale_amt` double(8,2) NOT NULL DEFAULT '0.00' COMMENT '提成价格',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `sys_customer_sale_price`
-- ----------------------------
DROP TABLE IF EXISTS `sys_customer_sale_price`;
CREATE TABLE `sys_customer_sale_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `ware_id` int(11) NOT NULL COMMENT '商品ID',
  `customer_id` int(11) NOT NULL COMMENT '客户ID',
  `tc_amt` double(8,2) NOT NULL DEFAULT '0.00' COMMENT '提成价格',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `sys_customer_ware_price`
-- ----------------------------
DROP TABLE IF EXISTS `sys_customer_ware_price`;
CREATE TABLE `sys_customer_ware_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `ware_id` int(11) NOT NULL COMMENT '商品ID',
  `customer_id` int(11) NOT NULL COMMENT '客户ID',
  `tran_amt` double(8,2) NOT NULL DEFAULT '0.00' COMMENT '运输价格',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `sys_customer_level_price`
-- ----------------------------
DROP TABLE IF EXISTS `sys_customer_level_price`;
CREATE TABLE `sys_customer_level_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `sys_customer_level_price`
-- ----------------------------

-- ----------------------------
--  Table structure for `sys_qd_type_price`
-- ----------------------------
DROP TABLE IF EXISTS `sys_qd_type_price`;
CREATE TABLE `sys_qd_type_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rela_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `sys_qd_type_price`
-- ----------------------------

-- ----------------------------
-- Table structure for sys_address_upload
-- ----------------------------
DROP TABLE IF EXISTS `sys_address_upload`;
CREATE TABLE `sys_address_upload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mem_id` int(11) NOT NULL COMMENT '员工id',
  `upload` int(11) DEFAULT '0' COMMENT '上传方式：0不上传，1上传',
  `min` int(11) DEFAULT '1' COMMENT '上传间隔默认1分钟',
   `mem_upload` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_address_upload
-- ----------------------------

-- ----------------------------
-- Table structure for stk_print_config
-- ----------------------------
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
 `fd_decimals` int(11) DEFAULT 0 COMMENT '小数位',
 `fd_align` INT(4) DEFAULT 0 COMMENT '对其方式: 0/null: center; 1: left 2:right',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of stk_print_config
-- ----------------------------

INSERT INTO `stk_print_config` VALUES ('1', 'wareCode', '产品代码', 'com.cnlife.stk.model.StkOutsub', '1', '1', '1', '15',null,null,null);
INSERT INTO `stk_print_config` VALUES ('2', 'wareNm', '产品名称', 'com.cnlife.stk.model.StkOutsub', '1', '1', '2', '26',null,null,null);
INSERT INTO `stk_print_config` VALUES ('3', 'wareGg', '产品规格', 'com.cnlife.stk.model.StkOutsub', '1', '1', '3', '7',null,null,null);
INSERT INTO `stk_print_config` VALUES ('4', 'xsTp', '销售类型', 'com.cnlife.stk.model.StkOutsub', '0', '1', '4', '7',null,null,null);
INSERT INTO `stk_print_config` VALUES ('5', 'unitName', '单位', 'com.cnlife.stk.model.StkOutsub', '1', '1', '5', '4',null,null,null);
INSERT INTO `stk_print_config` VALUES ('6', 'qty', '数量', 'com.cnlife.stk.model.StkOutsub', '1', '1', '6', '6',null,null,null);
INSERT INTO `stk_print_config` VALUES ('7', 'price', '单价', 'com.cnlife.stk.model.StkOutsub', '1', '1', '7', '7',null,null,null);
INSERT INTO `stk_print_config` VALUES ('8', 'amt', '金额', 'com.cnlife.stk.model.StkOutsub', '1', '1', '8', '8',null,null,null);
INSERT INTO `stk_print_config` VALUES ('9', 'productDate', '生产日期', 'com.cnlife.stk.model.StkOutsub', '0', '1', '9', '10',null,null,null);
INSERT INTO `stk_print_config` VALUES ('10', 'activeDate', '有效期', 'com.cnlife.stk.model.StkOutsub', '0', '1', '10', '5',null,null,null);
INSERT INTO `stk_print_config` VALUES ('11', 'remarks', '备注', 'com.cnlife.stk.model.StkOutsub', '1', '1', '11', '4',null,null,null);
INSERT INTO `stk_print_config` VALUES ('12', 'beBarCode', '单品条码', 'com.cnlife.stk.model.StkOutsub', '1', '1', '11', '15',null,null,null);

-- ----------------------------
--  Table structure for `stk_print_template`
-- ----------------------------
DROP TABLE IF EXISTS `stk_print_template`;
CREATE TABLE `stk_print_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fd_name` varchar(50) DEFAULT NULL,
  `fd_sub_name` varchar(50) DEFAULT NULL,
  `fd_model` varchar(100) DEFAULT NULL,
  `fd_type` varchar(10) DEFAULT NULL,
  `fd_status` int(2) DEFAULT NULL,
  `order_cd` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `sys_thorder`
-- ----------------------------
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
  `zje` double(10,2) DEFAULT NULL COMMENT '总金额',
  `zdzk` double(10,2) DEFAULT NULL COMMENT '整单折扣',
  `cjje` double(10,2) DEFAULT NULL COMMENT '成交金额',
  `oddate` varchar(20) NOT NULL COMMENT '日期',
  `order_tp` varchar(20) DEFAULT NULL COMMENT '订单类型',
  `sh_time` varchar(20) DEFAULT NULL COMMENT '送货时间',
  `order_zt` varchar(10) DEFAULT '未审核' COMMENT '订单状态（审核，未审核）\r\n\r\n',
  `order_lb` varchar(10) DEFAULT '拜访单' COMMENT '订单类别（拜访单，电话单\r\n\r\n）',
  `odtime` varchar(10) DEFAULT NULL COMMENT '时间',
  `pszd` varchar(20) DEFAULT NULL COMMENT '配送指定（公司直送，转二批配送）',
  PRIMARY KEY (`id`),
  KEY `mid` (`mid`),
  KEY `cid` (`cid`),
  KEY `order_no` (`order_no`),
  KEY `oddate` (`oddate`),
  KEY `order_tp` (`order_tp`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `sys_thorder`
-- ----------------------------

-- ----------------------------
--  Table structure for `sys_thorder_detail`
-- ----------------------------
DROP TABLE IF EXISTS `sys_thorder_detail`;
CREATE TABLE `sys_thorder_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单详情id',
  `order_id` int(11) NOT NULL COMMENT '订单id',
  `ware_id` int(11) NOT NULL COMMENT '商品id',
  `ware_num` double(10,2) NOT NULL COMMENT '数量',
  `ware_dj` double(10,2) NOT NULL COMMENT '单价',
  `ware_zj` double(10,2) NOT NULL COMMENT '总价',
  `xs_tp` varchar(20) DEFAULT NULL COMMENT '销售类型',
  `ware_dw` varchar(20) DEFAULT NULL COMMENT '单位',
  `remark` varchar(50) DEFAULT NULL COMMENT 'remark',
  `be_unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `ware_id` (`ware_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `sys_thorder_detail`
-- ----------------------------
-- ----------------------------
--  Table structure for `sys_auto_price`
-- ----------------------------
DROP TABLE IF EXISTS `sys_auto_price`;
CREATE TABLE `sys_auto_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auto_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `sys_auto_price`
-- ----------------------------

-- ----------------------------
--  Table structure for `sys_auto_field`
-- ----------------------------
DROP TABLE IF EXISTS `sys_auto_field`;
CREATE TABLE `sys_auto_field` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `fd_model` varchar(100) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `sys_auto_field`
-- ----------------------------

-- ----------------------------
--  Table structure for `sys_auto_customer_price`
-- ----------------------------
DROP TABLE IF EXISTS `sys_auto_customer_price`;
CREATE TABLE `sys_auto_customer_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auto_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `sys_auto_customer_price`
-- ----------------------------
-- ----------------------------
-- Table structure for stk_come
-- ----------------------------
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
   `veh_id` int(11) DEFAULT NULL,
   `driver_id` int(11) DEFAULT NULL,
  `voucher_no` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- ----------------------------
-- Table structure for stk_come
-- ----------------------------


-- ----------------------------
-- Records of for stk_comesub
-- ----------------------------
DROP TABLE IF EXISTS `stk_comesub`;
CREATE TABLE `stk_comesub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(13,5) DEFAULT NULL,
  `price` decimal(13,5) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(13,5) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `product_date` varchar(50) DEFAULT NULL,
   `in_type_code` varchar(50) DEFAULT NULL,
  `in_type_name` varchar(50) DEFAULT NULL,
   `sub_id` int(11) DEFAULT NULL,
   `rebate_price` decimal(13,5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of stk_comesub
-- ----------------------------

-- ----------------------------
-- Table structure for fin_init_money
-- ----------------------------
DROP TABLE IF EXISTS `fin_init_money`;
CREATE TABLE `fin_init_money` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(50) DEFAULT NULL,
  `bill_time` datetime DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `submit_user` varchar(50) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `io_mark` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of fin_init_money
-- ----------------------------

-- ----------------------------
-- Table structure for fin_init_money_sub
-- ----------------------------
DROP TABLE IF EXISTS `fin_init_money_sub`;
CREATE TABLE `fin_init_money_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(50) DEFAULT NULL,
  `bill_time` datetime DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `io_mark` int(2) DEFAULT NULL,
  `acc_id` int(11) DEFAULT NULL,
  `mast_id` int(11) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of fin_init_money_sub
-- ----------------------------


-- ----------------------------
--  Table structure for `fin_init_wlyw_main`
-- ----------------------------
DROP TABLE IF EXISTS `fin_init_wlyw_main`;
CREATE TABLE `fin_init_wlyw_main` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(50) DEFAULT NULL,
  `bill_time` datetime DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `submit_user` varchar(50) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `remarks` varchar(600) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `io_mark` int(2) DEFAULT NULL,
  `cancel_user` varchar(50) DEFAULT NULL,
  `cancel_time` datetime DEFAULT NULL,
  `pay_amt` decimal(10,2) DEFAULT NULL,
  `pro_id` int(11) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `pro_type` int(2) DEFAULT NULL,
  `biz_type` varchar(10) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for `kq_ban`
-- ----------------------------
DROP TABLE IF EXISTS `kq_ban`;
CREATE TABLE `kq_ban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `ban_nm` varchar(50) DEFAULT NULL,
  `start_time` varchar(50) DEFAULT NULL,
  `end_time` varchar(50) DEFAULT NULL,
  `days` decimal(10,2) DEFAULT NULL,
  `hours` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `ban_date` datetime DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_ban
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_ban_detail`
-- ----------------------------
DROP TABLE IF EXISTS `kq_ban_detail`;
CREATE TABLE `kq_ban_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `mast_id` int(11) DEFAULT NULL,
  `kq_date` varchar(50) DEFAULT NULL,
  `hours` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_ban_detail
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_bc`
-- ----------------------------
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
   `address` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_bc
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_bc_times`
-- ----------------------------
DROP TABLE IF EXISTS `kq_bc_times`;
CREATE TABLE `kq_bc_times` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` varchar(20) DEFAULT NULL,
  `end_time` varchar(20) DEFAULT NULL,
  `bc_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_bc_times
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_detail`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_detail
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_emp_rule`
-- ----------------------------
DROP TABLE IF EXISTS `kq_emp_rule`;
CREATE TABLE `kq_emp_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `rule_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_emp_rule
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_holiday`
-- ----------------------------
DROP TABLE IF EXISTS `kq_holiday`;
CREATE TABLE `kq_holiday` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day_name` varchar(50) DEFAULT NULL,
  `start_date` varchar(20) DEFAULT NULL,
  `end_date` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_holiday
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_jia`
-- ----------------------------
DROP TABLE IF EXISTS `kq_jia`;
CREATE TABLE `kq_jia` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `jia_nm` varchar(50) DEFAULT NULL,
  `start_time` varchar(50) DEFAULT NULL,
  `end_time` varchar(50) DEFAULT NULL,
  `days` decimal(10,2) DEFAULT NULL,
  `hours` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `jia_date` datetime DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_jia
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_jia_detail`
-- ----------------------------
DROP TABLE IF EXISTS `kq_jia_detail`;
CREATE TABLE `kq_jia_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `mast_id` int(11) DEFAULT NULL,
  `kq_date` varchar(50) DEFAULT NULL,
  `hours` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_jia_detail
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_pb`
-- ----------------------------
DROP TABLE IF EXISTS `kq_pb`;
CREATE TABLE `kq_pb` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `bc_id` int(11) DEFAULT NULL,
  `bc_date` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_pb
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_remarks`
-- ----------------------------
DROP TABLE IF EXISTS `kq_remarks`;
CREATE TABLE `kq_remarks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kq_date` varchar(50) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_remarks
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_rule`
-- ----------------------------
DROP TABLE IF EXISTS `kq_rule`;
CREATE TABLE `kq_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(50) DEFAULT NULL,
  `rule_unit` int(11) DEFAULT NULL,
  `days` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_rule
-- ----------------------------

-- ----------------------------
-- Table structure for `kq_rule_detail`
-- ----------------------------
DROP TABLE IF EXISTS `kq_rule_detail`;
CREATE TABLE `kq_rule_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_id` int(11) DEFAULT NULL,
  `seq_no` int(11) DEFAULT NULL,
  `bc_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of kq_rule_detail
-- ----------------------------


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
  `total_amt` decimal(10,2) DEFAULT NULL,
  `pay_amt` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `dis_amt1` decimal(10,0) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `order_no` varchar(50) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `emp_nm` varchar(50) DEFAULT NULL,
  `veh_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `relate_Id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `stk_rebate_insub`;

CREATE TABLE `stk_rebate_insub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `product_date` varchar(50) DEFAULT NULL,
  `in_type_code` varchar(50) DEFAULT NULL,
  `in_type_name` varchar(50) DEFAULT NULL,
  `rebate_Price` decimal(10,5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;


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
  `total_amt` decimal(10,2) DEFAULT NULL,
  `rec_amt` decimal(10,2) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  `kh_nm` varchar(50) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `dis_amt1` decimal(10,2) DEFAULT NULL,
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
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1085 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `stk_rebate_outsub`;

CREATE TABLE `stk_rebate_outsub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `xs_tp` varchar(50) DEFAULT NULL,
  `out_qty` decimal(10,2) DEFAULT NULL,
  `out_amt` decimal(10,2) DEFAULT NULL,
  `product_date` varchar(50) DEFAULT NULL,
  `active_date` varchar(50) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `ssw_id` varchar(50) DEFAULT NULL,
  `rebate_Price` decimal(10,5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mast_id` (`mast_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3329 DEFAULT CHARSET=utf8;


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
  `total_amt` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `dis_amt1` decimal(10,0) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `bill_name` varchar(255) DEFAULT NULL,
  `io_mark` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;


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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `stk_zzcx_io_sub`;

CREATE TABLE `stk_zzcx_io_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `be_qty` decimal(10,2) DEFAULT NULL,
  `be_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `io_mark` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `stk_zzcx_item`;

CREATE TABLE `stk_zzcx_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `rela_ware_id` decimal(10,0) DEFAULT NULL,
  `rela_ware_nm` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `stk_zzcx_sub`;

CREATE TABLE `stk_zzcx_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `stk_zzcx_ware_tpl`;

CREATE TABLE `stk_zzcx_ware_tpl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `ware_nm` varchar(50) DEFAULT NULL,
  `rela_ware_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_produce_cost`
-- ----------------------------
DROP TABLE IF EXISTS `stk_produce_cost`;
CREATE TABLE `stk_produce_cost` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `cost_Id` int(11) DEFAULT NULL,
  `voucher_no` varchar(40) DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
--  Table structure for `stk_produce_io_sub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_produce_io_sub`;
CREATE TABLE `stk_produce_io_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `be_qty` decimal(10,2) DEFAULT NULL,
  `be_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `io_mark` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_produce_io`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_produce_item`
-- ----------------------------
DROP TABLE IF EXISTS `stk_produce_item`;
CREATE TABLE `stk_produce_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `rela_ware_id` decimal(10,0) DEFAULT NULL,
  `rela_ware_nm` varchar(255) DEFAULT NULL,
  `plan_qty` decimal(10,2) DEFAULT NULL,
  `pickup_sub_Ids` varchar(100) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_produce_sub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_produce_sub`;
CREATE TABLE `stk_produce_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `product_date` varchar(20) DEFAULT NULL,
  `product_amt` decimal(10,2) DEFAULT NULL,
  `org_price` decimal(10,5) DEFAULT NULL,
  `org_amt` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_produce_ware_tpl`
-- ----------------------------
DROP TABLE IF EXISTS `stk_produce_ware_tpl`;
CREATE TABLE `stk_produce_ware_tpl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `ware_nm` varchar(50) DEFAULT NULL,
  `rela_ware_id` int(11) DEFAULT NULL,
  `rela_ware_nm` varchar(255) DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- ----------------------------
--  Table structure for `stk_produce`
-- ----------------------------
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
  `total_amt` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `dis_amt1` decimal(10,0) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `bill_name` varchar(255) DEFAULT NULL,
  `io_mark` int(2) DEFAULT NULL,
  `cost_amt` decimal(13,2) DEFAULT NULL,
  `refer_cost_amt` decimal(13,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_pickup_io_sub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_pickup_io_sub`;
CREATE TABLE `stk_pickup_io_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,5) DEFAULT NULL,
  `price` decimal(10,5) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `be_qty` decimal(10,2) DEFAULT NULL,
  `be_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  `io_mark` int(11) DEFAULT NULL,
  `cost_price` decimal(10,5) DEFAULT NULL,
  `out_qty` decimal(10,5) DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  rtn_qty decimal(13,5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- ----------------------------
--  Table structure for `stk_pickup_io`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `stk_pickup_sub`
-- ----------------------------
DROP TABLE IF EXISTS `stk_pickup_sub`;
CREATE TABLE `stk_pickup_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `amt` decimal(10,2) DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `in_qty` decimal(10,2) DEFAULT NULL,
  `in_amt` decimal(10,2) DEFAULT NULL,
  `be_unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- ----------------------------
--  Table structure for `stk_pickup`
-- ----------------------------
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
  `total_amt` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `pro_type` int(11) DEFAULT NULL,
  `dis_amt1` decimal(10,0) DEFAULT NULL,
  `new_time` datetime DEFAULT NULL,
  `bill_name` varchar(255) DEFAULT NULL,
  `io_mark` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `shop_banner_pic`;

CREATE TABLE `shop_banner_pic` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type` int(10) DEFAULT NULL,
  `banner_id` int(10) DEFAULT NULL COMMENT '1:首页banner',
  `pic` varchar(255) DEFAULT NULL,
  `pic_mini` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `shop_cart`;

CREATE TABLE `shop_cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_mem_id` int(11) DEFAULT NULL COMMENT '会员id',
  `mem_id` int(11) DEFAULT NULL COMMENT '平台id',
  `ware_id` int(11) DEFAULT NULL COMMENT '商品id',
  `ware_num` double DEFAULT NULL COMMENT '商品数量',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `shop_main_model`;

CREATE TABLE `shop_main_model` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `model_id` varchar(10) DEFAULT NULL COMMENT '首页子模块',
  `group_id` varchar(10) DEFAULT NULL COMMENT '分组id',
  `ware_ids` varchar(50) DEFAULT NULL COMMENT '商品ids',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `shop_member_grade`;

CREATE TABLE `shop_member_grade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coding` varchar(50) DEFAULT NULL COMMENT '编码',
  `grade_name` varchar(50) NOT NULL COMMENT '等级名称',
  `grade_no` int(11) DEFAULT NULL COMMENT '级别',
  `status` varchar(10) DEFAULT NULL COMMENT '0-不启用 ; 1-启用(默认)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `shop_ware_favorite`;

CREATE TABLE `shop_ware_favorite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hy_id` int(11) NOT NULL COMMENT '企业会员ID',
  `mem_id` int(11) DEFAULT NULL COMMENT '平台会员ID',
  `ware_id` int(11) NOT NULL COMMENT '商品id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `shop_ware_group`;

CREATE TABLE `shop_ware_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `path` varchar(100) DEFAULT NULL,
  `pic` varchar(100) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `remark` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;



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
   subscribe_status int(10) DEFAULT 0,
   subscribe_image_id int(11) DEFAULT 0, 
   subscribe_text varchar(600) DEFAULT NULL,
   receive_status int(10) DEFAULT 0,
   receive_image_id int(10) DEFAULT 0,
   receive_text varchar(600) DEFAULT NULL,
   `menu_status` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `weixin_member_msg`;

CREATE TABLE `weixin_member_msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `msg_id` varchar(28) DEFAULT NULL,
  `from_user_name` varchar(28) DEFAULT NULL,
  `to_user_name` varchar(28) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `create_time` varchar(20) DEFAULT NULL,
  `msg_time` varchar(20) DEFAULT NULL,
  `is_read` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `weixin_keyword_reply`;
CREATE TABLE `weixin_keyword_reply` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `keyword` varchar(30) DEFAULT NULL,
		  `keyword_text` varchar(300) DEFAULT NULL,
	  `keyword_image_id` int(11) DEFAULT '0',
		  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for `pos_card_rate`
-- ----------------------------
DROP TABLE IF EXISTS `pos_card_rate`;
CREATE TABLE `pos_card_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_type` int(11) DEFAULT NULL,
  `shop_no` varchar(10) DEFAULT NULL,
  `rate_type` int(11) DEFAULT NULL,
  `ware_type` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `rate` float DEFAULT NULL,
  `dis_price` decimal(10,2) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_card_rate
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_card_type`
-- ----------------------------
DROP TABLE IF EXISTS `pos_card_type`;
CREATE TABLE `pos_card_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `days` int(11) DEFAULT NULL,
  `unit` int(11) DEFAULT NULL,
  `input_cash` decimal(10,2) DEFAULT NULL,
  `free_cost` decimal(10,2) DEFAULT NULL,
  `shop_input` int(11) DEFAULT NULL,
  `shop_cost` int(11) DEFAULT NULL,
  `amt_rate` float DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `jici_amt` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_card_type
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_function`
-- ----------------------------
DROP TABLE IF EXISTS `pos_function`;
CREATE TABLE `pos_function` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) DEFAULT NULL,
  `func_name` varchar(50) DEFAULT NULL,
  `isrun` int(11) DEFAULT '1',
  `isinsert` int(11) DEFAULT '0',
  `isedit` int(11) DEFAULT '0',
  `isdelete` int(11) DEFAULT '0',
  `type_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3015 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_function
-- ----------------------------
INSERT INTO `pos_function` VALUES ('1001', '1', '收银', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1002', '1', '退货', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1003', '1', '发卡', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1004', '1', '充值', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1005', '1', '挂失', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1006', '1', '解挂', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1007', '1', '短信群发', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1008', '1', '导出会员', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1009', '1', '导入会员', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1010', '1', '补卡', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1011', '1', '删除会员', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1012', '1', '退卡', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1013', '1', '批量查询会员', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1014', '1', '销售撤单', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1015', '1', '充值撤单', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1016', '1', '手动打开钱箱', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('1017', '1', '补货', '1', '0', '0', '0', '前台');
INSERT INTO `pos_function` VALUES ('2001', '2', '促销设置', '1', '0', '0', '0', '营业设置');
INSERT INTO `pos_function` VALUES ('2002', '2', '会员卡设置', '1', '0', '0', '0', '营业设置');
INSERT INTO `pos_function` VALUES ('2003', '2', '卡折扣设置', '1', '0', '0', '0', '营业设置');
INSERT INTO `pos_function` VALUES ('2004', '2', '店铺信息', '1', '0', '0', '0', '其它设置');
INSERT INTO `pos_function` VALUES ('2005', '2', '常规设置', '1', '0', '0', '0', '其它设置');
INSERT INTO `pos_function` VALUES ('2006', '2', '短信设置', '1', '0', '0', '0', '其它设置');
INSERT INTO `pos_function` VALUES ('2007', '2', '读卡器设置', '1', '0', '0', '0', '其它设置');
INSERT INTO `pos_function` VALUES ('2008', '2', '权限设置', '1', '0', '0', '0', '其它设置');
INSERT INTO `pos_function` VALUES ('2009', '2', '操作员设置', '1', '0', '0', '0', '其它设置');
INSERT INTO `pos_function` VALUES ('2010', '2', '第三方支付设置', '1', '0', '0', '0', '其它设置');
INSERT INTO `pos_function` VALUES ('2011', '2', '商品设置', '1', '0', '0', '0', '营业设置');
INSERT INTO `pos_function` VALUES ('3001', '3', '会员档案', '1', '0', '0', '0', '会员报表');
INSERT INTO `pos_function` VALUES ('3002', '3', '发卡记录', '1', '0', '0', '0', '会员报表');
INSERT INTO `pos_function` VALUES ('3003', '3', '充值查询', '1', '0', '0', '0', '会员报表');
INSERT INTO `pos_function` VALUES ('3004', '3', '扣款查询', '1', '0', '0', '0', '会员报表');
INSERT INTO `pos_function` VALUES ('3005', '3', '退卡查询', '1', '0', '0', '0', '会员报表');
INSERT INTO `pos_function` VALUES ('3006', '3', '会员卡汇总', '1', '0', '0', '0', '会员报表');
INSERT INTO `pos_function` VALUES ('3007', '3', '异店卡统计', '1', '0', '0', '0', '会员报表');
INSERT INTO `pos_function` VALUES ('3008', '3', '订单查询', '1', '0', '0', '0', '营业报表');
INSERT INTO `pos_function` VALUES ('3009', '3', '撤单查询', '1', '0', '0', '0', '营业报表');
INSERT INTO `pos_function` VALUES ('3010', '3', '商品排行', '1', '0', '0', '0', '营业报表');
INSERT INTO `pos_function` VALUES ('3011', '3', '营业汇总', '1', '0', '0', '0', '营业报表');
INSERT INTO `pos_function` VALUES ('3012', '3', '营业分析', '1', '0', '0', '0', '营业报表');
INSERT INTO `pos_function` VALUES ('3013', '3', '会员分析', '1', '0', '0', '0', '营业报表');
INSERT INTO `pos_function` VALUES ('3014', '3', '库存查询', '1', '0', '0', '0', '前台');

-- ----------------------------
-- Table structure for `pos_group`
-- ----------------------------
DROP TABLE IF EXISTS `pos_group`;
CREATE TABLE `pos_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(50) DEFAULT NULL,
  `is_supper` int(11) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_group
-- ----------------------------
INSERT INTO `pos_group` VALUES ('1', '老板', '1', '11');

-- ----------------------------
-- Table structure for `pos_group_right`
-- ----------------------------
DROP TABLE IF EXISTS `pos_group_right`;
CREATE TABLE `pos_group_right` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `func_id` int(11) DEFAULT NULL,
  `isrun` int(11) DEFAULT NULL,
  `isinsert` int(11) DEFAULT NULL,
  `isedit` int(11) DEFAULT NULL,
  `isdelete` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_group_right
-- ----------------------------
INSERT INTO `pos_group_right` VALUES ('70', '1', '1001', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('71', '1', '1002', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('72', '1', '1003', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('73', '1', '1004', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('74', '1', '1005', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('75', '1', '1006', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('76', '1', '1007', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('77', '1', '1008', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('78', '1', '1009', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('79', '1', '1010', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('80', '1', '1011', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('81', '1', '1012', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('82', '1', '1013', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('83', '1', '1014', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('84', '1', '1015', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('85', '1', '1016', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('86', '1', '1017', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('87', '1', '2001', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('88', '1', '2002', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('89', '1', '2003', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('90', '1', '2004', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('91', '1', '2005', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('92', '1', '2006', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('93', '1', '2007', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('94', '1', '2008', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('95', '1', '2009', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('96', '1', '2010', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('97', '1', '3001', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('98', '1', '3002', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('99', '1', '3003', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('100', '1', '3004', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('103', '1', '3007', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('104', '1', '3008', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('105', '1', '3009', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('106', '1', '3010', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('107', '1', '3011', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('108', '1', '3012', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('109', '1', '3013', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('110', '1', '3014', '1', '1', '1', '1');
INSERT INTO `pos_group_right` VALUES ('111', '1', '2011', '1', '0', '0', '0');

-- ----------------------------
-- Table structure for `pos_module`
-- ----------------------------
DROP TABLE IF EXISTS `pos_module`;
CREATE TABLE `pos_module` (
  `id` int(11) NOT NULL DEFAULT '0',
  `module_name` varchar(50) DEFAULT NULL,
  `pos_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_module
-- ----------------------------
INSERT INTO `pos_module` VALUES ('1', '前台收银', '0');
INSERT INTO `pos_module` VALUES ('2', '门店设置', '0');
INSERT INTO `pos_module` VALUES ('3', '门店报表', '0');

-- ----------------------------
-- Table structure for `pos_msgformat`
-- ----------------------------
DROP TABLE IF EXISTS `pos_msgformat`;
CREATE TABLE `pos_msgformat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `msg` varchar(200) DEFAULT NULL,
  `msg_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_msgformat
-- ----------------------------
INSERT INTO `pos_msgformat` VALUES ('1', '您的卡号[卡号]在[店名]消费[消费金额]元，卡内余额[剩余金额]元，[当前日期]', '消费提醒');
INSERT INTO `pos_msgformat` VALUES ('2', '您的卡号[卡号]在[店名]充值[充值金额]元，[赠送金额]元，卡内余额[剩余金额]元，[当前日期]', '充值提醒');
INSERT INTO `pos_msgformat` VALUES ('3', '[顾客名称]您好，今天是您的生日，到店消费可享受折扣优惠', '生日提醒');

-- ----------------------------
-- Table structure for `pos_params`
-- ----------------------------
DROP TABLE IF EXISTS `pos_params`;
CREATE TABLE `pos_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `param_name` varchar(100) DEFAULT NULL,
  `param_value` varchar(100) DEFAULT NULL,
  `shop_no` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=989 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_params
-- ----------------------------
INSERT INTO `pos_params` VALUES ('115', '折算方案', '0', '0001');
INSERT INTO `pos_params` VALUES ('116', '负库存', '1', '0001');
INSERT INTO `pos_params` VALUES ('117', '打折方案', '0', '0001');
INSERT INTO `pos_params` VALUES ('118', '券支付', '0', '0001');
INSERT INTO `pos_params` VALUES ('119', '退卡时可退工本费', '1', '0001');
INSERT INTO `pos_params` VALUES ('120', '卡充值需要授权', '1', '0001');
INSERT INTO `pos_params` VALUES ('121', '异店卡消费', '0', '0001');
INSERT INTO `pos_params` VALUES ('122', '异店卡可充值', '0', '0001');
INSERT INTO `pos_params` VALUES ('123', '异店卡可兑换积分', '0', '0001');
INSERT INTO `pos_params` VALUES ('124', '卡支付', '0', '0001');
INSERT INTO `pos_params` VALUES ('125', '充值积分单位', '1', '0001');
INSERT INTO `pos_params` VALUES ('126', '消费积分单位', '1', '0001');
INSERT INTO `pos_params` VALUES ('127', '积分金额类型', '0', '0001');
INSERT INTO `pos_params` VALUES ('128', '积分计算', '0', '0001');
INSERT INTO `pos_params` VALUES ('129', '单据标题', '打印标题', '0001');
INSERT INTO `pos_params` VALUES ('130', '问候语', '', '0001');
INSERT INTO `pos_params` VALUES ('131', '广告1', '', '0001');
INSERT INTO `pos_params` VALUES ('132', '广告2', '', '0001');
INSERT INTO `pos_params` VALUES ('133', '广告3', '', '0001');
INSERT INTO `pos_params` VALUES ('134', '折算方案', '0', '0001');
INSERT INTO `pos_params` VALUES ('135', '负库存', '1', '0001');
INSERT INTO `pos_params` VALUES ('136', '打折方案', '0', '0001');
INSERT INTO `pos_params` VALUES ('137', '券支付', '0', '0001');
INSERT INTO `pos_params` VALUES ('138', '退卡时可退工本费', '1', '0001');
INSERT INTO `pos_params` VALUES ('139', '卡充值需要授权', '1', '0001');
INSERT INTO `pos_params` VALUES ('140', '异店卡消费', '0', '0001');
INSERT INTO `pos_params` VALUES ('141', '异店卡可充值', '0', '0001');
INSERT INTO `pos_params` VALUES ('142', '异店卡可兑换积分', '0', '0001');
INSERT INTO `pos_params` VALUES ('143', '卡支付', '0', '0001');
INSERT INTO `pos_params` VALUES ('144', '充值积分单位', '1', '0001');
INSERT INTO `pos_params` VALUES ('145', '消费积分单位', '1', '0001');
INSERT INTO `pos_params` VALUES ('146', '积分金额类型', '0', '0001');
INSERT INTO `pos_params` VALUES ('147', '积分计算', '0', '0001');
INSERT INTO `pos_params` VALUES ('148', '单据标题', '打印标题', '0001');
INSERT INTO `pos_params` VALUES ('149', '问候语', '', '0001');
INSERT INTO `pos_params` VALUES ('150', '广告1', '', '0001');
INSERT INTO `pos_params` VALUES ('151', '广告2', '', '0001');
INSERT INTO `pos_params` VALUES ('152', '广告3', '', '0001');
INSERT INTO `pos_params` VALUES ('153', '折算方案', '0', '0001');
INSERT INTO `pos_params` VALUES ('154', '负库存', '1', '0001');
INSERT INTO `pos_params` VALUES ('155', '打折方案', '0', '0001');
INSERT INTO `pos_params` VALUES ('156', '券支付', '0', '0001');
INSERT INTO `pos_params` VALUES ('157', '退卡时可退工本费', '1', '0001');
INSERT INTO `pos_params` VALUES ('158', '卡充值需要授权', '1', '0001');
INSERT INTO `pos_params` VALUES ('159', '异店卡消费', '0', '0001');
INSERT INTO `pos_params` VALUES ('160', '异店卡可充值', '0', '0001');
INSERT INTO `pos_params` VALUES ('161', '异店卡可兑换积分', '0', '0001');
INSERT INTO `pos_params` VALUES ('162', '卡支付', '0', '0001');
INSERT INTO `pos_params` VALUES ('163', '充值积分单位', '1', '0001');
INSERT INTO `pos_params` VALUES ('164', '消费积分单位', '1', '0001');
INSERT INTO `pos_params` VALUES ('165', '积分金额类型', '0', '0001');
INSERT INTO `pos_params` VALUES ('166', '积分计算', '0', '0001');
INSERT INTO `pos_params` VALUES ('167', '单据标题', '打印标题', '0001');
INSERT INTO `pos_params` VALUES ('168', '问候语', '', '0001');
INSERT INTO `pos_params` VALUES ('169', '广告1', '', '0001');
INSERT INTO `pos_params` VALUES ('170', '广告2', '', '0001');
INSERT INTO `pos_params` VALUES ('171', '广告3', '', '0001');
INSERT INTO `pos_params` VALUES ('172', '折算方案', '1', '0001');
INSERT INTO `pos_params` VALUES ('173', '负库存', '1', '0001');
INSERT INTO `pos_params` VALUES ('174', '打折方案', '0', '0001');
INSERT INTO `pos_params` VALUES ('175', '券支付', '0', '0001');
INSERT INTO `pos_params` VALUES ('176', '退卡时可退工本费', '1', '0001');
INSERT INTO `pos_params` VALUES ('177', '卡充值需要授权', '1', '0001');
INSERT INTO `pos_params` VALUES ('178', '异店卡消费', '0', '0001');
INSERT INTO `pos_params` VALUES ('179', '异店卡可充值', '0', '0001');
INSERT INTO `pos_params` VALUES ('180', '异店卡可兑换积分', '0', '0001');
INSERT INTO `pos_params` VALUES ('181', '卡支付', '0', '0001');
INSERT INTO `pos_params` VALUES ('182', '充值积分单位', '1', '0001');
INSERT INTO `pos_params` VALUES ('183', '消费积分单位', '1', '0001');
INSERT INTO `pos_params` VALUES ('184', '积分金额类型', '0', '0001');
INSERT INTO `pos_params` VALUES ('185', '积分计算', '0', '0001');
INSERT INTO `pos_params` VALUES ('186', '单据标题', '打印标题', '0001');
INSERT INTO `pos_params` VALUES ('187', '问候语', '', '0001');
INSERT INTO `pos_params` VALUES ('188', '广告1', '', '0001');
INSERT INTO `pos_params` VALUES ('189', '广告2', '', '0001');
INSERT INTO `pos_params` VALUES ('190', '广告3', '', '0001');
INSERT INTO `pos_params` VALUES ('362', '折算方案', '0', '');
INSERT INTO `pos_params` VALUES ('363', '负库存', '0', '');
INSERT INTO `pos_params` VALUES ('364', '打折方案', '0', '');
INSERT INTO `pos_params` VALUES ('365', '券支付', '0', '');
INSERT INTO `pos_params` VALUES ('366', '退卡时可退工本费', '0', '');
INSERT INTO `pos_params` VALUES ('367', '卡充值需要授权', '0', '');
INSERT INTO `pos_params` VALUES ('368', '异店卡消费', '0', '');
INSERT INTO `pos_params` VALUES ('369', '异店卡可充值', '0', '');
INSERT INTO `pos_params` VALUES ('370', '异店卡可兑换积分', '0', '');
INSERT INTO `pos_params` VALUES ('371', '卡支付', '0', '');
INSERT INTO `pos_params` VALUES ('372', '充值积分单位', '0', '');
INSERT INTO `pos_params` VALUES ('373', '消费积分单位', '0', '');
INSERT INTO `pos_params` VALUES ('374', '积分金额类型', '0', '');
INSERT INTO `pos_params` VALUES ('375', '积分计算', '0', '');
INSERT INTO `pos_params` VALUES ('376', '单据标题', '', '');
INSERT INTO `pos_params` VALUES ('377', '问候语', '', '');
INSERT INTO `pos_params` VALUES ('378', '广告1', '', '');
INSERT INTO `pos_params` VALUES ('379', '广告2', '', '');
INSERT INTO `pos_params` VALUES ('380', '广告3', '', '');
INSERT INTO `pos_params` VALUES ('381', '折算方案', '0', '');
INSERT INTO `pos_params` VALUES ('382', '负库存', '0', '');
INSERT INTO `pos_params` VALUES ('383', '打折方案', '0', '');
INSERT INTO `pos_params` VALUES ('384', '券支付', '0', '');
INSERT INTO `pos_params` VALUES ('385', '退卡时可退工本费', '0', '');
INSERT INTO `pos_params` VALUES ('386', '卡充值需要授权', '0', '');
INSERT INTO `pos_params` VALUES ('387', '异店卡消费', '0', '');
INSERT INTO `pos_params` VALUES ('388', '异店卡可充值', '0', '');
INSERT INTO `pos_params` VALUES ('389', '异店卡可兑换积分', '0', '');
INSERT INTO `pos_params` VALUES ('390', '卡支付', '0', '');
INSERT INTO `pos_params` VALUES ('391', '充值积分单位', '0', '');
INSERT INTO `pos_params` VALUES ('392', '消费积分单位', '0', '');
INSERT INTO `pos_params` VALUES ('393', '积分金额类型', '0', '');
INSERT INTO `pos_params` VALUES ('394', '积分计算', '0', '');
INSERT INTO `pos_params` VALUES ('395', '单据标题', '', '');
INSERT INTO `pos_params` VALUES ('396', '问候语', '', '');
INSERT INTO `pos_params` VALUES ('397', '广告1', '', '');
INSERT INTO `pos_params` VALUES ('398', '广告2', '', '');
INSERT INTO `pos_params` VALUES ('399', '广告3', '', '');
INSERT INTO `pos_params` VALUES ('400', '折算方案', '0', '');
INSERT INTO `pos_params` VALUES ('401', '负库存', '0', '');
INSERT INTO `pos_params` VALUES ('402', '打折方案', '0', '');
INSERT INTO `pos_params` VALUES ('403', '券支付', '0', '');
INSERT INTO `pos_params` VALUES ('404', '退卡时可退工本费', '0', '');
INSERT INTO `pos_params` VALUES ('405', '卡充值需要授权', '0', '');
INSERT INTO `pos_params` VALUES ('406', '异店卡消费', '0', '');
INSERT INTO `pos_params` VALUES ('407', '异店卡可充值', '0', '');
INSERT INTO `pos_params` VALUES ('408', '异店卡可兑换积分', '0', '');
INSERT INTO `pos_params` VALUES ('409', '卡支付', '0', '');
INSERT INTO `pos_params` VALUES ('410', '充值积分单位', '0', '');
INSERT INTO `pos_params` VALUES ('411', '消费积分单位', '0', '');
INSERT INTO `pos_params` VALUES ('412', '积分金额类型', '0', '');
INSERT INTO `pos_params` VALUES ('413', '积分计算', '0', '');
INSERT INTO `pos_params` VALUES ('414', '单据标题', '', '');
INSERT INTO `pos_params` VALUES ('415', '问候语', '', '');
INSERT INTO `pos_params` VALUES ('416', '广告1', '', '');
INSERT INTO `pos_params` VALUES ('417', '广告2', '', '');
INSERT INTO `pos_params` VALUES ('418', '广告3', '', '');
INSERT INTO `pos_params` VALUES ('837', '折算方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('838', '负库存', '1', '0002');
INSERT INTO `pos_params` VALUES ('839', '打折方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('840', '券支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('841', '退卡时可退工本费', '0', '0002');
INSERT INTO `pos_params` VALUES ('842', '卡充值需要授权', '0', '0002');
INSERT INTO `pos_params` VALUES ('843', '异店卡消费', '0', '0002');
INSERT INTO `pos_params` VALUES ('844', '异店卡可充值', '0', '0002');
INSERT INTO `pos_params` VALUES ('845', '异店卡可兑换积分', '0', '0002');
INSERT INTO `pos_params` VALUES ('846', '卡支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('847', '充值积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('848', '消费积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('849', '积分金额类型', '0', '0002');
INSERT INTO `pos_params` VALUES ('850', '积分计算', '0', '0002');
INSERT INTO `pos_params` VALUES ('851', '单据标题', '', '0002');
INSERT INTO `pos_params` VALUES ('852', '问候语', '', '0002');
INSERT INTO `pos_params` VALUES ('853', '广告1', '', '0002');
INSERT INTO `pos_params` VALUES ('854', '广告2', '', '0002');
INSERT INTO `pos_params` VALUES ('855', '广告3', '', '0002');
INSERT INTO `pos_params` VALUES ('856', '折算方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('857', '负库存', '1', '0002');
INSERT INTO `pos_params` VALUES ('858', '打折方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('859', '券支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('860', '退卡时可退工本费', '0', '0002');
INSERT INTO `pos_params` VALUES ('861', '卡充值需要授权', '0', '0002');
INSERT INTO `pos_params` VALUES ('862', '异店卡消费', '0', '0002');
INSERT INTO `pos_params` VALUES ('863', '异店卡可充值', '0', '0002');
INSERT INTO `pos_params` VALUES ('864', '异店卡可兑换积分', '0', '0002');
INSERT INTO `pos_params` VALUES ('865', '卡支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('866', '充值积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('867', '消费积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('868', '积分金额类型', '0', '0002');
INSERT INTO `pos_params` VALUES ('869', '积分计算', '0', '0002');
INSERT INTO `pos_params` VALUES ('870', '单据标题', '', '0002');
INSERT INTO `pos_params` VALUES ('871', '问候语', '', '0002');
INSERT INTO `pos_params` VALUES ('872', '广告1', '', '0002');
INSERT INTO `pos_params` VALUES ('873', '广告2', '', '0002');
INSERT INTO `pos_params` VALUES ('874', '广告3', '', '0002');
INSERT INTO `pos_params` VALUES ('875', '折算方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('876', '负库存', '1', '0002');
INSERT INTO `pos_params` VALUES ('877', '打折方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('878', '券支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('879', '退卡时可退工本费', '0', '0002');
INSERT INTO `pos_params` VALUES ('880', '卡充值需要授权', '0', '0002');
INSERT INTO `pos_params` VALUES ('881', '异店卡消费', '0', '0002');
INSERT INTO `pos_params` VALUES ('882', '异店卡可充值', '0', '0002');
INSERT INTO `pos_params` VALUES ('883', '异店卡可兑换积分', '0', '0002');
INSERT INTO `pos_params` VALUES ('884', '卡支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('885', '充值积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('886', '消费积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('887', '积分金额类型', '0', '0002');
INSERT INTO `pos_params` VALUES ('888', '积分计算', '0', '0002');
INSERT INTO `pos_params` VALUES ('889', '单据标题', '', '0002');
INSERT INTO `pos_params` VALUES ('890', '问候语', '', '0002');
INSERT INTO `pos_params` VALUES ('891', '广告1', '', '0002');
INSERT INTO `pos_params` VALUES ('892', '广告2', '', '0002');
INSERT INTO `pos_params` VALUES ('893', '广告3', '', '0002');
INSERT INTO `pos_params` VALUES ('894', '折算方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('895', '负库存', '1', '0002');
INSERT INTO `pos_params` VALUES ('896', '打折方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('897', '券支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('898', '退卡时可退工本费', '0', '0002');
INSERT INTO `pos_params` VALUES ('899', '卡充值需要授权', '0', '0002');
INSERT INTO `pos_params` VALUES ('900', '异店卡消费', '0', '0002');
INSERT INTO `pos_params` VALUES ('901', '异店卡可充值', '0', '0002');
INSERT INTO `pos_params` VALUES ('902', '异店卡可兑换积分', '0', '0002');
INSERT INTO `pos_params` VALUES ('903', '卡支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('904', '充值积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('905', '消费积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('906', '积分金额类型', '0', '0002');
INSERT INTO `pos_params` VALUES ('907', '积分计算', '0', '0002');
INSERT INTO `pos_params` VALUES ('908', '单据标题', '', '0002');
INSERT INTO `pos_params` VALUES ('909', '问候语', '', '0002');
INSERT INTO `pos_params` VALUES ('910', '广告1', '', '0002');
INSERT INTO `pos_params` VALUES ('911', '广告2', '', '0002');
INSERT INTO `pos_params` VALUES ('912', '广告3', '', '0002');
INSERT INTO `pos_params` VALUES ('913', '折算方案', '3', '0002');
INSERT INTO `pos_params` VALUES ('914', '负库存', '1', '0002');
INSERT INTO `pos_params` VALUES ('915', '打折方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('916', '券支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('917', '退卡时可退工本费', '0', '0002');
INSERT INTO `pos_params` VALUES ('918', '卡充值需要授权', '0', '0002');
INSERT INTO `pos_params` VALUES ('919', '异店卡消费', '0', '0002');
INSERT INTO `pos_params` VALUES ('920', '异店卡可充值', '0', '0002');
INSERT INTO `pos_params` VALUES ('921', '异店卡可兑换积分', '0', '0002');
INSERT INTO `pos_params` VALUES ('922', '卡支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('923', '充值积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('924', '消费积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('925', '积分金额类型', '0', '0002');
INSERT INTO `pos_params` VALUES ('926', '积分计算', '0', '0002');
INSERT INTO `pos_params` VALUES ('927', '单据标题', '', '0002');
INSERT INTO `pos_params` VALUES ('928', '问候语', '', '0002');
INSERT INTO `pos_params` VALUES ('929', '广告1', '', '0002');
INSERT INTO `pos_params` VALUES ('930', '广告2', '', '0002');
INSERT INTO `pos_params` VALUES ('931', '广告3', '', '0002');
INSERT INTO `pos_params` VALUES ('932', '折算方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('933', '负库存', '1', '0002');
INSERT INTO `pos_params` VALUES ('934', '打折方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('935', '券支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('936', '退卡时可退工本费', '0', '0002');
INSERT INTO `pos_params` VALUES ('937', '卡充值需要授权', '0', '0002');
INSERT INTO `pos_params` VALUES ('938', '异店卡消费', '0', '0002');
INSERT INTO `pos_params` VALUES ('939', '异店卡可充值', '0', '0002');
INSERT INTO `pos_params` VALUES ('940', '异店卡可兑换积分', '0', '0002');
INSERT INTO `pos_params` VALUES ('941', '卡支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('942', '充值积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('943', '消费积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('944', '积分金额类型', '0', '0002');
INSERT INTO `pos_params` VALUES ('945', '积分计算', '0', '0002');
INSERT INTO `pos_params` VALUES ('946', '单据标题', '', '0002');
INSERT INTO `pos_params` VALUES ('947', '问候语', '', '0002');
INSERT INTO `pos_params` VALUES ('948', '广告1', '', '0002');
INSERT INTO `pos_params` VALUES ('949', '广告2', '', '0002');
INSERT INTO `pos_params` VALUES ('950', '广告3', '', '0002');
INSERT INTO `pos_params` VALUES ('951', '折算方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('952', '负库存', '1', '0002');
INSERT INTO `pos_params` VALUES ('953', '打折方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('954', '券支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('955', '退卡时可退工本费', '0', '0002');
INSERT INTO `pos_params` VALUES ('956', '卡充值需要授权', '0', '0002');
INSERT INTO `pos_params` VALUES ('957', '异店卡消费', '0', '0002');
INSERT INTO `pos_params` VALUES ('958', '异店卡可充值', '0', '0002');
INSERT INTO `pos_params` VALUES ('959', '异店卡可兑换积分', '0', '0002');
INSERT INTO `pos_params` VALUES ('960', '卡支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('961', '充值积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('962', '消费积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('963', '积分金额类型', '0', '0002');
INSERT INTO `pos_params` VALUES ('964', '积分计算', '0', '0002');
INSERT INTO `pos_params` VALUES ('965', '单据标题', '', '0002');
INSERT INTO `pos_params` VALUES ('966', '问候语', '', '0002');
INSERT INTO `pos_params` VALUES ('967', '广告1', '', '0002');
INSERT INTO `pos_params` VALUES ('968', '广告2', '', '0002');
INSERT INTO `pos_params` VALUES ('969', '广告3', '', '0002');
INSERT INTO `pos_params` VALUES ('970', '折算方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('971', '负库存', '1', '0002');
INSERT INTO `pos_params` VALUES ('972', '打折方案', '0', '0002');
INSERT INTO `pos_params` VALUES ('973', '券支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('974', '退卡时可退工本费', '0', '0002');
INSERT INTO `pos_params` VALUES ('975', '卡充值需要授权', '0', '0002');
INSERT INTO `pos_params` VALUES ('976', '异店卡消费', '0', '0002');
INSERT INTO `pos_params` VALUES ('977', '异店卡可充值', '0', '0002');
INSERT INTO `pos_params` VALUES ('978', '异店卡可兑换积分', '0', '0002');
INSERT INTO `pos_params` VALUES ('979', '卡支付', '0', '0002');
INSERT INTO `pos_params` VALUES ('980', '充值积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('981', '消费积分单位', '0', '0002');
INSERT INTO `pos_params` VALUES ('982', '积分金额类型', '0', '0002');
INSERT INTO `pos_params` VALUES ('983', '积分计算', '0', '0002');
INSERT INTO `pos_params` VALUES ('984', '单据标题', '', '0002');
INSERT INTO `pos_params` VALUES ('985', '问候语', '', '0002');
INSERT INTO `pos_params` VALUES ('986', '广告1', '', '0002');
INSERT INTO `pos_params` VALUES ('987', '广告2', '', '0002');
INSERT INTO `pos_params` VALUES ('988', '广告3', '', '0002');

-- ----------------------------
-- Table structure for `pos_sale`
-- ----------------------------
DROP TABLE IF EXISTS `pos_sale`;
CREATE TABLE `pos_sale` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `doc_no` varchar(50) DEFAULT NULL,
  `hand_no` varchar(50) DEFAULT NULL,
  `cst_name` varchar(50) DEFAULT NULL,
  `bill_date` varchar(50) DEFAULT NULL,
  `total_amt` decimal(10,2) DEFAULT NULL,
  `is_pay` int(11) DEFAULT NULL,
  `card_no` varchar(50) DEFAULT NULL,
  `card_id` int(11) DEFAULT NULL,
  `cash_pay` decimal(10,2) DEFAULT NULL,
  `ticket_pay` decimal(10,2) DEFAULT NULL,
  `bank_pay` decimal(10,2) DEFAULT NULL,
  `card_pay` decimal(10,2) DEFAULT NULL,
  `free_amt` decimal(10,2) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  `shop_no` varchar(50) DEFAULT NULL,
  `doc_type` int(11) DEFAULT NULL,
  `emp_id` int(50) DEFAULT NULL,
  `tel` varchar(50) DEFAULT NULL,
  `card_type` int(11) DEFAULT NULL,
  `amt_rate` float DEFAULT NULL COMMENT '金额系数',
  `new_shop_no` varchar(10) DEFAULT NULL,
  `wx_pay` decimal(50,2) DEFAULT NULL,
  `zfb_pay` decimal(10,2) DEFAULT NULL,
  `add_value` int(11) DEFAULT NULL COMMENT '增加积分',
  `new_time` datetime DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL COMMENT '整单折扣',
  `tail_amt` decimal(10,0) DEFAULT NULL COMMENT '抹零',
  `pay_amt` decimal(10,0) DEFAULT NULL COMMENT '需要支付的金额',
  `status` int(11) DEFAULT NULL,
  `left_amt` decimal(10,2) DEFAULT NULL,
  `need_pay` decimal(10,2) DEFAULT NULL,
  `out_trade_no` varchar(50) DEFAULT NULL,
  `stk_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_sale
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_sale_cancel`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_sale_cancel
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_sale_sub`
-- ----------------------------
DROP TABLE IF EXISTS `pos_sale_sub`;
CREATE TABLE `pos_sale_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mast_id` int(11) DEFAULT NULL,
  `seq_no` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `ware_nm` varchar(50) DEFAULT NULL,
  `waretype` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `rate` float DEFAULT NULL,
  `dis_price` decimal(10,2) DEFAULT NULL,
  `dis_amt` decimal(10,2) DEFAULT NULL,
  `is_free` int(11) DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `pay_amt` decimal(10,2) DEFAULT NULL,
  `shop_no` varchar(10) DEFAULT NULL,
  `card_id` int(11) DEFAULT NULL,
  `permit` varchar(50) DEFAULT NULL,
  `cash` decimal(10,2) DEFAULT NULL,
  `ticket` decimal(10,2) DEFAULT NULL,
  `card` decimal(10,2) DEFAULT NULL,
  `jici_qty` int(11) DEFAULT NULL,
  `jici_rest` int(11) DEFAULT NULL,
  `bank` decimal(10,2) DEFAULT NULL,
  `wx` decimal(10,0) DEFAULT NULL,
  `zfb` decimal(10,2) DEFAULT NULL,
  `sub_memo` varchar(100) DEFAULT NULL,
  `sale_rate` float DEFAULT NULL,
  `card_rate` float DEFAULT NULL,
  `card_price` decimal(10,2) DEFAULT NULL,
  `spec_price` decimal(10,2) DEFAULT NULL,
  `is_good` int(11) DEFAULT NULL,
  `jici_price` decimal(10,2) DEFAULT NULL,
  `other_rate` float DEFAULT NULL,
  `unit_name` varchar(50) DEFAULT NULL,
  `be_unit` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_sale_sub
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_shop_emp`
-- ----------------------------
DROP TABLE IF EXISTS `pos_shop_emp`;
CREATE TABLE `pos_shop_emp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_shop_emp
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_shop_rate`
-- ----------------------------
DROP TABLE IF EXISTS `pos_shop_rate`;
CREATE TABLE `pos_shop_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_no` varchar(10) DEFAULT NULL,
  `rate_type` int(11) DEFAULT NULL,
  `ware_type` int(11) DEFAULT NULL,
  `ware_id` int(11) DEFAULT NULL,
  `rate` float DEFAULT NULL,
  `dis_price` decimal(10,2) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_shop_rate
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_shopinfo`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_shopinfo
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_sms_set`
-- ----------------------------
DROP TABLE IF EXISTS `pos_sms_set`;
CREATE TABLE `pos_sms_set` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `msg_head` varchar(50) DEFAULT NULL,
  `cost_send` int(11) DEFAULT NULL,
  `input_send` int(11) DEFAULT NULL,
  `shop_no` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_sms_set
-- ----------------------------
INSERT INTO `pos_sms_set` VALUES ('1', '测试', '1', '1', '0001');

-- ----------------------------
-- Table structure for `pos_update_detail`
-- ----------------------------
DROP TABLE IF EXISTS `pos_update_detail`;
CREATE TABLE `pos_update_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `obj_id` int(11) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `update_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_update_detail
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_update_log`
-- ----------------------------
DROP TABLE IF EXISTS `pos_update_log`;
CREATE TABLE `pos_update_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_type` varchar(50) DEFAULT NULL,
  `update_time` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_update_log
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_wxset`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_wxset
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_zfbset`
-- ----------------------------
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_zfbset
-- ----------------------------

-- ----------------------------
-- Table structure for `pos_user_log`
-- ----------------------------
DROP TABLE IF EXISTS `pos_user_log`;
CREATE TABLE `pos_user_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` varchar(20) DEFAULT NULL,
  `end_time` varchar(20) DEFAULT NULL,
  `shop_no` varchar(20) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `hang_qty` int(11) DEFAULT NULL,
  `hang_amt` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pos_user_log
-- ----------------------------

-- ----------------------------
-- Table structure for `shop_member`
-- ----------------------------
DROP TABLE IF EXISTS `shop_member`;
CREATE TABLE `shop_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `open_id` varchar(500) DEFAULT NULL,
  `card_no` varchar(50) DEFAULT NULL,
  `mem_id` int(11) NOT NULL,
  `card_type` int(11) DEFAULT NULL,
  `input_cash` decimal(10,2) DEFAULT NULL,
  `free_cost` decimal(10,2) DEFAULT NULL,
  `ic_card` int(11) DEFAULT NULL,
  `shop_no` varchar(20) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `pwd` varchar(10) DEFAULT NULL,
  `weixin` varchar(50) DEFAULT NULL,
  `qq` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `pic` varchar(200) DEFAULT NULL,
  `reg_date` datetime DEFAULT NULL,
  `active_date` datetime DEFAULT NULL,
  `status` int(10) DEFAULT NULL,
  `id_card` varchar(30) DEFAULT NULL,
  `mem_card` varchar(100) DEFAULT NULL,
  `m_type` varchar(10) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `company_id` varchar(100) DEFAULT NULL,
  `remark` varchar(200) DEFAULT NULL,
  `nickname` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `province` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `card_date` varchar(50) DEFAULT NULL,
  `card_cost` decimal(10,2) DEFAULT NULL,
  `last_time` datetime DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `birthday` varchar(50) DEFAULT NULL,
  `ope_count` int(11) DEFAULT NULL,
  `sum_value` int(11) DEFAULT NULL,
  `sum_cost` decimal(10,2) DEFAULT NULL,
  `sum_input` decimal(10,2) DEFAULT NULL,
  `psw` varchar(50) DEFAULT NULL,
   `sp_mem_grade_id` INT(100),

  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shop_member
-- ----------------------------

-- ----------------------------
-- Table structure for `shop_member_io`
-- ----------------------------
DROP TABLE IF EXISTS `shop_member_io`;
CREATE TABLE `shop_member_io` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_id` int(11) DEFAULT NULL COMMENT '卡ID',
  `card_no` varchar(50) DEFAULT NULL COMMENT '卡号',
  `input_cash` decimal(10,2) DEFAULT NULL COMMENT '充值金额',
  `free_cost` decimal(10,2) DEFAULT NULL COMMENT '赠送金额',
  `doc_no` varchar(50) DEFAULT NULL COMMENT '单号',
  `io_time` datetime DEFAULT NULL COMMENT '操作时间',
  `io_flag` int(11) DEFAULT NULL COMMENT '操作类型0 发卡 1充值 2消费 3挂失 4补卡 5退卡',
  `left_amt` decimal(10,2) DEFAULT NULL COMMENT '余额',
  `new_shop_no` varchar(10) DEFAULT NULL COMMENT '发卡店',
  `shop_no` varchar(10) DEFAULT NULL COMMENT '操作门店',
  `card_pay` decimal(10,2) DEFAULT NULL COMMENT '卡支付',
  `cash_pay` decimal(10,2) DEFAULT NULL COMMENT '现金支付',
  `bank_pay` decimal(10,2) DEFAULT NULL COMMENT '银行卡支付',
  `wx_pay` decimal(10,2) DEFAULT NULL COMMENT '微信支付',
  `zfb_pay` double(10,2) DEFAULT NULL COMMENT '支付宝支付',
  `status` int(11) DEFAULT NULL COMMENT '状态1正常 -1作废',
  `created_on` datetime DEFAULT NULL COMMENT '创建时间',
  `card_type` int(11) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  emp_id int COMMENT '操作员ID',
  `io_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shop_member_io
-- ----------------------------

-- ----------------------------
-- Table structure for `shop_member_type`
-- ----------------------------
DROP TABLE IF EXISTS `shop_member_type`;
CREATE TABLE `shop_member_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) DEFAULT NULL COMMENT '类型名称',
  `prefix` varchar(10) DEFAULT NULL COMMENT '卡号前缀',
  `day_long` int(11) DEFAULT NULL COMMENT '有效期',
  `date_unit` int(11) DEFAULT NULL COMMENT '有效期单位',
  `cost` decimal(10,2) DEFAULT NULL COMMENT '工本费',
  `input_cash` decimal(10,2) DEFAULT NULL COMMENT '充值金额',
  `free_cost` decimal(10,2) DEFAULT NULL COMMENT '赠送金额',
  `new_card` int(11) DEFAULT NULL COMMENT '店号可发卡否',
  `modify_amt` int(11) DEFAULT NULL COMMENT '可修改金额否',
  `hanged` int(11) DEFAULT NULL COMMENT '可挂失否',
  `shop_share` int(11) DEFAULT NULL COMMENT '是否可通用',
  `date_type` int(11) DEFAULT NULL COMMENT '有效期类型',
  `ic_type` int(11) DEFAULT NULL COMMENT '卡介质',
  `created_on` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shop_member_type
-- ----------------------------

-- ----------------------------
-- Table structure for `shop_order_log`
-- ----------------------------
DROP TABLE IF EXISTS `shop_order_log`;
CREATE TABLE `shop_order_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `log_time` datetime DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shop_order_log
-- ----------------------------

-- ----------------------------
-- Table structure for `shop_params`
-- ----------------------------
DROP TABLE IF EXISTS `shop_params`;
CREATE TABLE `shop_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `param_name` varchar(50) DEFAULT NULL,
  `param_value` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shop_params
-- ----------------------------

-- ----------------------------
-- Table structure for `shop_pay_log`
-- ----------------------------
DROP TABLE IF EXISTS `shop_pay_log`;
CREATE TABLE `shop_pay_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `paytype` varchar(50) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `pay_time` datetime DEFAULT NULL,
  `pay_amt` decimal(10,2) DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '0表示未入账 1已入账 2作废',
  `bill_type` int(11) DEFAULT NULL COMMENT '0 订单 1充值',
  `order_no` varchar(50) DEFAULT NULL,
  `tel` varchar(50) DEFAULT NULL,
  `recharge_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shop_pay_log
-- ----------------------------

-- ----------------------------
--  Table structure for `weixin_material_pic`
-- ----------------------------
DROP TABLE IF EXISTS `weixin_material_pic`;
CREATE TABLE `weixin_material_pic` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片id',
  `pic_mini` varchar(255) NOT NULL COMMENT '小图',
  `pic` varchar(255) NOT NULL COMMENT '大图',
  `upload_time` varchar(20) NOT NULL COMMENT '上传图片时间',
  `media_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `weixin_reply_time`
-- ----------------------------
DROP TABLE IF EXISTS `weixin_reply_time`;
CREATE TABLE `weixin_reply_time` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `open_id` varchar(28) DEFAULT NULL,
  `reply_Time` datetime DEFAULT NULL COMMENT '自定义回复的时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `shop_recharge_amount`
-- ----------------------------
DROP TABLE IF EXISTS `shop_recharge_amount`;
CREATE TABLE `shop_recharge_amount` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `cz_amount` double DEFAULT NULL COMMENT '充值金额',
  `zs_amount` double DEFAULT NULL COMMENT '赠送金额',
  `status` int(10) DEFAULT '1' COMMENT '0:不启用，1：启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;



-- ----------------------------
-- View structure for view_taskzhixing
-- ----------------------------
DROP VIEW IF EXISTS `view_taskzhixing`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `view_taskzhixing` AS select `a`.`id` AS `id`,`b`.`member_id` AS `member_id`,`b`.`member_nm` AS `member_nm`,`b`.`member_company` AS `member_company`,`b`.`unit_id` AS `unit_Id`,`d`.`branch_id` AS `branch_Id`,`d`.`branch_name` AS `branch_name`,date_format(`a`.`end_time`,'%Y%m') AS `end_time`,`a`.`status` AS `status`,(case when ((case when (isnull(`a`.`act_time`) or (`a`.`act_time` = '')) then date_format(now(),'%Y-%m-%d %H:%i') else date_format(`a`.`act_time`,'%Y-%m-%d %H:%i') end) > date_format(`a`.`end_time`,'%Y-%m-%d %H:%i')) then 1 else 0 end) AS `cq_count` from (((`sys_task` `a` join `sys_mem` `b`) join `sys_task_psn` `c`) join `sys_depart` `d`) where ((`a`.`id` = `c`.`nid`) and (`c`.`psn_id` = `b`.`member_id`) and (`d`.`branch_id` = `b`.`branch_id`) and (`c`.`psn_type` = 1) and (date_format(`a`.`end_time`,'%Y-%m-%d %H:%i') <= now())) union all select `a`.`id` AS `id`,`b`.`member_id` AS `member_id`,`b`.`member_nm` AS `member_nm`,`b`.`member_company` AS `member_company`,`b`.`unit_id` AS `unit_Id`,'' AS `branch_Id`,'' AS `branch_name`,date_format(`a`.`end_time`,'%Y%m') AS `end_time`,`a`.`status` AS `status`,(case when ((case when (isnull(`a`.`act_time`) or (`a`.`act_time` = '')) then date_format(now(),'%Y-%m-%d %H:%i') else date_format(`a`.`act_time`,'%Y-%m-%d %H:%i') end) > date_format(`a`.`end_time`,'%Y-%m-%d %H:%i')) then 1 else 0 end) AS `cq_count` from ((`sys_task` `a` join `sys_mem` `b`) join `sys_task_psn` `c`) where ((`a`.`id` = `c`.`nid`) and (`c`.`psn_id` = `b`.`member_id`) and (isnull(`b`.`branch_id`) or (`b`.`branch_id` = '')) and (`c`.`psn_type` = 1) and (date_format(`a`.`end_time`,'%Y-%m-%d %H:%i') <= now()));
