/*
Navicat MySQL Data Transfer

Source Server         : 阿里云
Source Server Version : 50624
Source Host           : 120.79.201.125:3306
Source Database       : common

Target Server Type    : MYSQL
Target Server Version : 50624
File Encoding         : 65001

Date: 2019-07-11 11:23:17
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address` (
  `id` mediumint(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` mediumint(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `consignee` varchar(50) NOT NULL DEFAULT '' COMMENT '收货人',
  `detail_address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `tel_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '座机电话',
  `mobile` varchar(15) NOT NULL DEFAULT '' COMMENT '手机电话',
  `is_default` tinyint(3) NOT NULL DEFAULT '0' COMMENT '1默认收货地址',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `province` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `city` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `area` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '区',
  PRIMARY KEY (`id`),
  KEY `member_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 COMMENT='买家地址信息表';

-- ----------------------------
-- Table structure for brand
-- ----------------------------
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `factory_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '产商id',
  `name` varchar(18) NOT NULL DEFAULT '' COMMENT '商标名称',
  `brand_img` varchar(200) NOT NULL DEFAULT '' COMMENT '商标图片',
  `certificate` varchar(200) NOT NULL DEFAULT '' COMMENT '商标证书',
  `authorization` varchar(200) NOT NULL DEFAULT '' COMMENT '授权书',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态标识位 0：正常 1：删除',
  `category_id_1` char(10) NOT NULL DEFAULT '0' COMMENT '所属商品一级分类',
  `auth_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '审核标识位 0：待审核 1：审核通过 2：审核不通过',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COMMENT='商标表';

-- ----------------------------
-- Table structure for chat_message
-- ----------------------------
DROP TABLE IF EXISTS `chat_message`;
CREATE TABLE `chat_message` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `from_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '发送ID user.id',
  `to_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '接收ID，依据receive_type：1 user.id，2 group.id',
  `read` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否已读：0 ：未读 1：已读',
  `receive_type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '接收对象类型 0：保留 1：个人 2：群组',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '类型 0：保留 1：文字 2：图片 3：文件 4：视频 5：定位',
  `content` varchar(2000) NOT NULL DEFAULT '' COMMENT '内容',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `send_sign` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '发送标志 0：未发送 1：已发送',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=363 DEFAULT CHARSET=utf8 COMMENT='聊天消息表';

-- ----------------------------
-- Table structure for factory
-- ----------------------------
DROP TABLE IF EXISTS `factory`;
CREATE TABLE `factory` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `agent` varchar(25) NOT NULL DEFAULT '' COMMENT '代理人',
  `name` varchar(25) NOT NULL DEFAULT '' COMMENT '产商名称',
  `business_license` varchar(150) NOT NULL DEFAULT '' COMMENT '营业执照:URL',
  `auth_letter` varchar(150) NOT NULL DEFAULT '' COMMENT '授权信:URL',
  `auth_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '认证状态： 0：待审核 1：已审核 2：不通过',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '公司类型 1：供应商 2、店家 ',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='公司入驻表';

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `store_id` smallint(5) NOT NULL DEFAULT '0' COMMENT '店铺Id',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '商品名称',
  `trait` varchar(60) NOT NULL DEFAULT '' COMMENT '商品特点',
  `category_id_1` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '商品分类1',
  `category_id_2` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '商品分类2',
  `category_id_3` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '商品分类3',
  `thumb_img` varchar(100) NOT NULL DEFAULT '' COMMENT '缩略图',
  `main_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '首焦图',
  `goods_video` varchar(255) NOT NULL DEFAULT '' COMMENT '视频',
  `parameters` varchar(1000) NOT NULL DEFAULT '' COMMENT '参数',
  `details_img` varchar(255) NOT NULL DEFAULT '' COMMENT '详情图',
  `tag` varchar(100) NOT NULL DEFAULT '' COMMENT '标签',
  `retail_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '零售价格',
  `sale_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '销售价格',
  `settle_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '结算价格',
  `sale_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '销售类型 0：正常产品 1：场景产品 2：特价 ',
  `shelf_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '商品上下架标识位 1：下架 2：待审核 3 上架',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `rq_code_url` varchar(30) NOT NULL DEFAULT '' COMMENT '商品二维码图片',
  `inventory` int(10) NOT NULL DEFAULT '0' COMMENT '库存',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `line_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '行数 排序',
  `special` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '特价',
  `run_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '经营类型 1：采购店铺 2：零售店铺 3：分成店铺',
  `type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '商品类型：0：产品 1：服务',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COMMENT='商品表';

-- ----------------------------
-- Table structure for goods_category
-- ----------------------------
DROP TABLE IF EXISTS `goods_category`;
CREATE TABLE `goods_category` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(90) NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '级别：0 保留 1 一级 2 二级 3 三级',
  `parent_id_1` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '父级ID1',
  `parent_id_2` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '父级ID2',
  `sort` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `img` varchar(2000) NOT NULL DEFAULT '' COMMENT '图片路径',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COMMENT='商品分类表';

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `sn` varchar(32) NOT NULL DEFAULT '' COMMENT '编号',
  `pay_sn` varchar(33) NOT NULL DEFAULT '' COMMENT '支付单号',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型：0：普通 1：团购',
  `order_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '物流状态：0：临时 1:待付款 2:待收货 3:待评价 4:已完成 5:已取消',
  `after_sale_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '售后服务状态 0：正常 1：待处理 2：已完成',
  `payment_code` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付方式：0 微信 1：支付宝 3：网银',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总金额',
  `coupons_pay` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '代金券支付金额',
  `wallet_pay` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '钱包支付金额',
  `actually_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `remark` varchar(2000) NOT NULL DEFAULT '' COMMENT '备注说明',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `address_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '地址ID:consignee_address.id',
  `coupons_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '代金券ID:coupons.id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '生成时间',
  `payment_time` varchar(14) NOT NULL DEFAULT '0' COMMENT '支付时间',
  `finished_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '完成时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='订单表';

-- ----------------------------
-- Table structure for order_child
-- ----------------------------
DROP TABLE IF EXISTS `order_child`;
CREATE TABLE `order_child` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `father_order_id` int(11) NOT NULL DEFAULT '0' COMMENT '父订单id 关联order表 id',
  `sn` varchar(32) NOT NULL COMMENT '编号',
  `payment_code` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付方式：0 微信 1：支付宝 3：网银',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总金额',
  `actually_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `remark` varchar(2000) NOT NULL DEFAULT '' COMMENT '备注说明',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `coupons_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '代金券ID:coupons.id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '生成时间',
  `payment_time` varchar(14) NOT NULL DEFAULT '0' COMMENT '支付时间',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '店铺id',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `order_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '订单状态：0：临时 1:待付款 2:待收货 3:待评价 4:已完成 5:已取消',
  `after_sale_status` tinyint(1) unsigned NOT NULL COMMENT '售后服务状态 0：正常 1：待处理 2：已完成',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='子订单表';

-- ----------------------------
-- Table structure for order_detail
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '成交价格',
  `num` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '成交数量',
  `goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品id 关联goods表',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `father_order_id` int(10) NOT NULL DEFAULT '0' COMMENT '父订单 关联order表id',
  `child_order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '拆分后子订单ID 关联order_childk表id ',
  `store_id` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='订单详情表';

-- ----------------------------
-- Table structure for passage
-- ----------------------------
DROP TABLE IF EXISTS `passage`;
CREATE TABLE `passage` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tweet_id` int(11) NOT NULL DEFAULT '0' COMMENT '推文id',
  `illustration` varchar(2000) NOT NULL DEFAULT '' COMMENT '推文插图',
  `passage` varchar(2000) NOT NULL DEFAULT '' COMMENT '段落文字',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章段落文字+图片';

-- ----------------------------
-- Table structure for plugin
-- ----------------------------
DROP TABLE IF EXISTS `plugin`;
CREATE TABLE `plugin` (
  `code` varchar(13) DEFAULT NULL COMMENT '插件编码',
  `name` varchar(55) DEFAULT NULL COMMENT '中文名字',
  `version` varchar(255) DEFAULT NULL COMMENT '插件的版本',
  `config` text COMMENT '配置信息',
  `config_value` text COMMENT '配置值信息',
  `desc` varchar(255) DEFAULT NULL COMMENT '插件描述',
  `status` tinyint(1) DEFAULT '0' COMMENT '是否启用',
  `type` varchar(50) DEFAULT NULL COMMENT '插件类型 payment支付 login 登陆 shipping物流',
  `bank_code` text COMMENT '网银配置信息',
  `scene` tinyint(1) DEFAULT '0' COMMENT '使用场景 0PC+手机 1手机 2PC 3APP 4小程序'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='插件表';

-- ----------------------------
-- Table structure for promotion
-- ----------------------------
DROP TABLE IF EXISTS `promotion`;
CREATE TABLE `promotion` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '促销活动名称',
  `first_img` varchar(200) NOT NULL DEFAULT '' COMMENT '促销活动图片',
  `second_img` varchar(200) NOT NULL DEFAULT '' COMMENT '促销活动图片',
  `goods_ids` varchar(200) NOT NULL DEFAULT '' COMMENT '商品ids',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '促销开始时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '促销结束时间',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '产商id',
  `sort` int(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `run_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '经营类型 1：采购店铺 2：零售店铺 3：分成店铺',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='促销活动表';

-- ----------------------------
-- Table structure for record
-- ----------------------------
DROP TABLE IF EXISTS `record`;
CREATE TABLE `record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `factory_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '企业/机构 ID',
  `company_img` varchar(50) NOT NULL DEFAULT '' COMMENT '企业/机构 首图',
  `logo_img` varchar(255) NOT NULL DEFAULT '' COMMENT '企业/机构 标志',
  `short_name` varchar(50) NOT NULL DEFAULT '' COMMENT '企业/机构 简称',
  `ideas` varchar(2000) NOT NULL DEFAULT '' COMMENT '企业/机构 理念',
  `introduction` varchar(1000) NOT NULL DEFAULT '' COMMENT '企业/机构简介',
  `factory_video` varchar(2000) NOT NULL DEFAULT '' COMMENT '企业/机构视频',
  `glory_img` varchar(6500) NOT NULL DEFAULT '' COMMENT '专利荣耀',
  `rb_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '企业研发生产照片',
  `team_activity` varchar(2000) NOT NULL DEFAULT '' COMMENT '机构团队活动照片',
  `store_profile pictures` varchar(2000) NOT NULL DEFAULT '' COMMENT '机构店面活动图片',
  `license` varchar(2000) NOT NULL DEFAULT '' COMMENT '执照',
  `detail_address` varchar(50) NOT NULL DEFAULT '' COMMENT '详细地址',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `province` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `city` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `area` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '区',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COMMENT='档案表';

-- ----------------------------
-- Table structure for store
-- ----------------------------
DROP TABLE IF EXISTS `store`;
CREATE TABLE `store` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `foreign_id` tinyint(4) NOT NULL DEFAULT '0' COMMENT '外键 id : store_type为1 档案id record_id;store_type为1=2 品牌id brand_id',
  `store_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '店铺类型 0：保留 1：企业旗舰店 2：品牌旗舰店',
  `run_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '经营类型 供应商类型 1:美尚采购店铺 2:美尚分成店铺 美尚会店铺 4:在线商城',
  `operational_model` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '和平台合作运营方式 0 :保留 1：联营 2：自营',
  `auth_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '营业状态 -2：未通过-1：关闭 0：待审核 1：建设中 2：经营中',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `factory_id` smallint(5) NOT NULL DEFAULT '0' COMMENT '厂商 id',
  `is_default` tinyint(4) NOT NULL DEFAULT '0' COMMENT '默认厂商 1：默认 0：不默认',
  `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '公司类型 1：供应商 2、采购商 ',
  `consignee_name` varchar(64) NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `consignee_mobile_phone` varchar(15) NOT NULL DEFAULT '' COMMENT '收货人手机号码',
  `province` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `city` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `area` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '区',
  `detail_address` varchar(512) NOT NULL DEFAULT '' COMMENT '详细地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8 COMMENT='店铺表';

-- ----------------------------
-- Table structure for tweet
-- ----------------------------
DROP TABLE IF EXISTS `tweet`;
CREATE TABLE `tweet` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `img` varchar(4000) NOT NULL DEFAULT '' COMMENT '推文标题图',
  `img_description` varchar(2000) NOT NULL DEFAULT '' COMMENT '图片描述或消息类推文消息文本',
  `video` varchar(4000) NOT NULL DEFAULT '' COMMENT '视频',
  `video_description` varchar(2000) NOT NULL DEFAULT '' COMMENT '视频说明',
  `goods_ids` varchar(200) NOT NULL DEFAULT '' COMMENT '商品ids',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '产商id',
  `sort` int(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `run_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '经营类型 1：采购店铺 2：零售店铺 3：分成店铺',
  `release_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '推文类型 1：图片消息 2：视频消息 3：文章',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='推文表';

-- ----------------------------
-- Table structure for unit
-- ----------------------------
DROP TABLE IF EXISTS `unit`;
CREATE TABLE `unit` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `key` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '键',
  `value` varchar(30) NOT NULL DEFAULT '' COMMENT '值',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='单位表';

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '用户名（即账号），可用于登录系统',
  `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `mobile_phone` varchar(15) NOT NULL DEFAULT '' COMMENT '手机号，可用于登录系统',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '用户状态 0：正常； 1：禁用 ；2：删除',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型 0：不可登陆 1：游客，可登陆 2：已实名认证',
  `password` varchar(64) NOT NULL DEFAULT '' COMMENT '密码',
  `role_id` tinyint(4) NOT NULL DEFAULT '0' COMMENT '用户角色id',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `sex` tinyint(4) NOT NULL DEFAULT '0' COMMENT '性别；0：保密，1：男；2：女',
  `salt` char(10) NOT NULL DEFAULT '' COMMENT '盐值',
  `birthday` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '生日',
  `last_login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Table structure for user_factory
-- ----------------------------
DROP TABLE IF EXISTS `user_factory`;
CREATE TABLE `user_factory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '用户状态 0：正常； 1：禁用 ；2：删除',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID：factory.id',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `is_default` tinyint(4) NOT NULL DEFAULT '0' COMMENT '默认厂商 1：默认 0：不默认',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型：0：保留 1：拥有者 2:管理员 3：店长 4：员工',
  `factory_type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '公司类型 1：供应商 2、采购商 ',
  `user_name` varchar(64) NOT NULL DEFAULT '' COMMENT '用户在机构中的昵称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8 COMMENT='用户-公司-关联表';

-- ----------------------------
-- Table structure for user_store
-- ----------------------------
DROP TABLE IF EXISTS `user_store`;
CREATE TABLE `user_store` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '供应商ID：factory.id',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '店铺ID：organize.id',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型：0：保留 1：拥有者 3：店长 4：员工',
  `user_name` varchar(64) NOT NULL DEFAULT '' COMMENT '用户在店铺中的昵称',
  `post` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '岗位：0 ：保留 其他：见配置文件permission.php',
  `duty` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '职务：0 ：保留 其他：见配置文件permission.php',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=242 DEFAULT CHARSET=utf8 COMMENT='用户-店铺-关联表';

-- ----------------------------
-- Table structure for user_store_node
-- ----------------------------
DROP TABLE IF EXISTS `user_store_node`;
CREATE TABLE `user_store_node` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型：0：保留',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '店铺ID：store.id',
  `node_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '节点ID：permission.authentication.node.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='用户-店铺-节点-关联表';
