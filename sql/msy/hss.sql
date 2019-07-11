/*
Navicat MySQL Data Transfer

Source Server         : 阿里云
Source Server Version : 50624
Source Host           : 120.79.201.125:3306
Source Database       : hss

Target Server Type    : MYSQL
Target Server Version : 50624
File Encoding         : 65001

Date: 2019-07-11 11:23:34
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for ad_positions
-- ----------------------------
DROP TABLE IF EXISTS `ad_positions`;
CREATE TABLE `ad_positions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '广告栏名',
  `key` varchar(50) NOT NULL DEFAULT '',
  `type` tinyint(3) NOT NULL DEFAULT '1' COMMENT '广告类型 ',
  `shelf_status` tinyint(4) NOT NULL DEFAULT '3' COMMENT '是否打开广告位:1.关闭 3.打开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='广告类型表';

-- ----------------------------
-- Table structure for brand
-- ----------------------------
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` mediumint(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `name` varchar(18) NOT NULL DEFAULT '' COMMENT '商标名称',
  `type` char(10) NOT NULL DEFAULT '0' COMMENT '商标类别',
  `logo` varchar(200) NOT NULL DEFAULT '' COMMENT '商标图片',
  `certificate` varchar(200) NOT NULL DEFAULT '' COMMENT '商标证书',
  `authorization` varchar(200) NOT NULL DEFAULT '' COMMENT '授权书',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态标识位 0：正常 1：删除',
  `auth_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '审核标识位 0：待审核 1：审核通过 2：审核不通过',
  `is_default` tinyint(3) NOT NULL DEFAULT '0' COMMENT '1：默认',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商标表';

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '购物车id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '买家id',
  `goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `num` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '购买商品数量',
  `create_time` int(20) NOT NULL DEFAULT '0' COMMENT '加入购物车时间',
  `goods_type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '类型：0 保留 1 商品 2项目',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `buy_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '类型：0 保留 1 批量 2 样品',
  `brand_name` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌名',
  `brand_id` int(10) NOT NULL DEFAULT '0' COMMENT '品牌id',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1233 DEFAULT CHARSET=utf8 COMMENT='购物车数据表';

-- ----------------------------
-- Table structure for city_area
-- ----------------------------
DROP TABLE IF EXISTS `city_area`;
CREATE TABLE `city_area` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `city_code` int(11) DEFAULT '0' COMMENT '城市code',
  `province_name` varchar(200) DEFAULT '',
  `city_name` varchar(200) DEFAULT '',
  `province_code` int(11) DEFAULT '0' COMMENT '区域id',
  `level` tinyint(3) DEFAULT '0' COMMENT '城市级别',
  `cpmi_id` tinyint(3) DEFAULT '3' COMMENT '合伙人市场分类id',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `city_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '申请状态：0 ：开放 1：关闭',
  `alone_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '资格款 没有使用统一价',
  `alone_earnest` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '定金 没有使用统一价',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=375 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='国内城市区域表';

-- ----------------------------
-- Table structure for city_partner
-- ----------------------------
DROP TABLE IF EXISTS `city_partner`;
CREATE TABLE `city_partner` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `sn` varchar(32) NOT NULL DEFAULT '' COMMENT '编号',
  `user_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户id',
  `company_name` varchar(25) NOT NULL DEFAULT '' COMMENT '企业名称',
  `applicant` varchar(25) NOT NULL DEFAULT '' COMMENT '申请人',
  `mobile` varchar(15) NOT NULL DEFAULT '' COMMENT '手机电话',
  `province_code` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `city_code` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `city_name` varchar(200) DEFAULT '' COMMENT '市场名称',
  `city_level` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '城市等级',
  `market_name` varchar(25) DEFAULT '' COMMENT '市场名称',
  `earnest` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '定金',
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '资格款',
  `payment_time` varchar(14) NOT NULL DEFAULT '' COMMENT '支付时间',
  `pay_sn` varchar(50) NOT NULL DEFAULT '' COMMENT '支付订单号',
  `pay_code` varchar(10) NOT NULL DEFAULT '0' COMMENT '''支付方式：1 微信 2：支付宝 3：网银 4:线下支付',
  `balance_sn` varchar(32) NOT NULL DEFAULT '' COMMENT '尾款内部订单编号',
  `apply_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '申请状态：0：临时 1:选择城市 2:提交资料 3:待审核（已交定金） 4审核通过  5 交清尾款',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `earnest_sn` varchar(32) NOT NULL DEFAULT '' COMMENT '定金内部订单编号',
  `city_area_id` int(11) DEFAULT NULL COMMENT '城市区域id',
  `is_partner` tinyint(3) DEFAULT '0' COMMENT '1-合伙人，0-否',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='城市合伙人申请表';

-- ----------------------------
-- Table structure for city_partner_market_info
-- ----------------------------
DROP TABLE IF EXISTS `city_partner_market_info`;
CREATE TABLE `city_partner_market_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(10) NOT NULL DEFAULT '0' COMMENT '市场名称',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '资格款',
  `earnest` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '定金',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='城市合伙人市场价格表';

-- ----------------------------
-- Table structure for collection
-- ----------------------------
DROP TABLE IF EXISTS `collection`;
CREATE TABLE `collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'user_id',
  `goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(20) NOT NULL DEFAULT '0' COMMENT '加入时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8 COMMENT='收藏表';

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `score` tinyint(1) unsigned NOT NULL DEFAULT '5' COMMENT '分数',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单号',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单号',
  `title` varchar(200) NOT NULL DEFAULT '此用户没有填写标题' COMMENT '标题',
  `content` varchar(2000) NOT NULL DEFAULT '此用户没有填写评论' COMMENT '内容',
  `img` varchar(2000) NOT NULL DEFAULT '' COMMENT '图片',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='评论表';

-- ----------------------------
-- Table structure for company
-- ----------------------------
DROP TABLE IF EXISTS `company`;
CREATE TABLE `company` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'user_id',
  `company_name` varchar(300) NOT NULL DEFAULT '' COMMENT '机构名',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '个人名称',
  `mobile_phone` varchar(15) NOT NULL DEFAULT '' COMMENT '手机号',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8 COMMENT='会员所属企业信息表';

-- ----------------------------
-- Table structure for express
-- ----------------------------
DROP TABLE IF EXISTS `express`;
CREATE TABLE `express` (
  `id` tinyint(1) unsigned NOT NULL AUTO_INCREMENT COMMENT '索引ID',
  `name` varchar(50) NOT NULL COMMENT '公司名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态1启用 2弃用',
  `code` varchar(50) NOT NULL COMMENT '编号',
  `letter` char(1) NOT NULL COMMENT '首字母',
  `order` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1常用0不常用',
  `url` varchar(100) NOT NULL COMMENT '公司网址',
  `tel` varchar(50) NOT NULL DEFAULT '0' COMMENT '客服电话',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COMMENT='快递公司';

-- ----------------------------
-- Table structure for franchise
-- ----------------------------
DROP TABLE IF EXISTS `franchise`;
CREATE TABLE `franchise` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户id',
  `name` varchar(25) NOT NULL DEFAULT '' COMMENT '加盟店名称',
  `applicant` varchar(25) NOT NULL DEFAULT '' COMMENT '申请人',
  `mobile` varchar(15) NOT NULL DEFAULT '' COMMENT '手机电话',
  `province` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `city` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `area` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '区',
  `detail_address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `franchise_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '加盟费',
  `payment_time` varchar(14) NOT NULL DEFAULT '' COMMENT '支付时间',
  `pay_sn` varchar(50) NOT NULL DEFAULT '' COMMENT '支付订单号',
  `pay_code` varchar(10) NOT NULL DEFAULT '0' COMMENT '''支付方式：1 微信 2：支付宝 3：网银 4:线下支付',
  `sn` varchar(32) NOT NULL DEFAULT '' COMMENT '内部订单编号',
  `apply_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '申请状态：0：预定登记 1:待付款 2:已付款',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8 COMMENT='加盟店申请表';

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '商品名称',
  `headline` varchar(500) NOT NULL DEFAULT '' COMMENT '标题文案',
  `franchise_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '加盟价',
  `sample_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '样品价格',
  `minimum_order_quantity` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '订单起订量',
  `minimum_sample_quantity` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '样品起订量',
  `share_title` varchar(255) NOT NULL DEFAULT '' COMMENT '分享标题',
  `share_desc` varchar(255) NOT NULL DEFAULT '' COMMENT '分享描述',
  `specification` varchar(1000) NOT NULL DEFAULT '' COMMENT '商品规格',
  `purchase_specification_description` varchar(100) NOT NULL DEFAULT '' COMMENT '商品购买规格描述',
  `specification_unit` tinyint(3) NOT NULL DEFAULT '0' COMMENT '商品规格的单位',
  `category_id_1` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '商品分类1',
  `category_id_2` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '商品分类2',
  `category_id_3` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '商品分类3',
  `intro` varchar(2000) NOT NULL DEFAULT '' COMMENT '商品介绍',
  `parameters` varchar(5000) NOT NULL DEFAULT '' COMMENT '参数',
  `thumb_img` varchar(200) NOT NULL DEFAULT '' COMMENT '缩略图',
  `main_img` varchar(2500) NOT NULL DEFAULT '' COMMENT '首焦图',
  `detail_img` varchar(2500) NOT NULL DEFAULT '' COMMENT '详情图',
  `goods_video` varchar(255) NOT NULL DEFAULT '' COMMENT '视频',
  `tag` varchar(100) NOT NULL DEFAULT '' COMMENT '标签',
  `shelf_status` tinyint(3) unsigned NOT NULL DEFAULT '3' COMMENT '商品上下架标识位 1：下架 2：待审核 3 上架',
  `rq_code_url` varchar(300) NOT NULL DEFAULT '' COMMENT '商品二维码图片',
  `inventory` int(10) NOT NULL DEFAULT '0' COMMENT '库存',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `purchase_unit` tinyint(3) NOT NULL DEFAULT '0' COMMENT '采购单位',
  `increase_quantity` smallint(5) NOT NULL DEFAULT '1' COMMENT '起订递增数量',
  `store_id` int(10) NOT NULL DEFAULT '0' COMMENT '店铺Id',
  `is_selection` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：不是精选 1：精选',
  `belong_to` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '归属：0 ：无 1：中心店 2：工作室。  使用二进制存储',
  `goods_code` varchar(300) NOT NULL DEFAULT '' COMMENT '商品货号',
  `retail_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '零售价',
  `factory_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '出厂价',
  `agent_special_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理特价',
  `agent_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理价',
  `franchise_special_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '加盟特价',
  `belong_to_member_buy` tinyint(3) unsigned NOT NULL DEFAULT '6' COMMENT '平台会员身份：1、普通会员, 2、加盟店家 4、城市合伙人 ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=455 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='商品表';

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
  `intro` varchar(2000) NOT NULL DEFAULT '' COMMENT '简介',
  `tag` varchar(100) NOT NULL DEFAULT '' COMMENT '标签',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8 COMMENT='商品分类表';

-- ----------------------------
-- Table structure for information
-- ----------------------------
DROP TABLE IF EXISTS `information`;
CREATE TABLE `information` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `headline` varchar(60) NOT NULL DEFAULT '' COMMENT '标题',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：违规（禁售） 2：删除',
  `auth_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '审核标识位  -1：审核不通过 0:保留 1：待审核 2：审核通过',
  `sort` tinyint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `main_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '主图',
  `content` text NOT NULL COMMENT '内容',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '编辑时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资讯';

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'user_id',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '平台会员身份：1、普通会员, 2、加盟店家 4、城市合伙人 ',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8 COMMENT='用户平台会员身份表';

-- ----------------------------
-- Table structure for needs_message
-- ----------------------------
DROP TABLE IF EXISTS `needs_message`;
CREATE TABLE `needs_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '名字',
  `mobile` varchar(15) NOT NULL DEFAULT '0' COMMENT '手机号码',
  `message` varchar(2000) NOT NULL DEFAULT '' COMMENT '信息',
  `create_time` int(13) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='需求留言';

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `sn` varchar(32) NOT NULL COMMENT '编号',
  `pay_sn` varchar(33) NOT NULL DEFAULT '' COMMENT '支付单号',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型：0、普通 1、团购 2、套餐',
  `order_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '物流状态：0：临时 1:待付款 2:待收货 3:待评价 4:已完成 5:已取消 6:售后',
  `after_sale_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '售后服务状态 0：正常 1：待处理 2：已完成',
  `pay_code` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付方式：0：保留 1 微信 2：支付宝 3：网银 4:钱包',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总金额',
  `coupons_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '代金券支付金额',
  `actually_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '钱包支付金额',
  `remark` varchar(2000) NOT NULL DEFAULT '' COMMENT '备注说明',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `coupons_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '代金券ID:coupons.id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '生成时间',
  `payment_time` int(11) NOT NULL DEFAULT '0' COMMENT '付款时间',
  `finished_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '完成时间',
  `consignee` varchar(50) NOT NULL DEFAULT '' COMMENT '收货人',
  `mobile` varchar(15) NOT NULL DEFAULT '' COMMENT '手机电话',
  `province` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `city` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `area` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '区',
  `detail_address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `express_sn` varchar(200) DEFAULT NULL COMMENT '物流单号',
  `exp_id` tinyint(4) NOT NULL DEFAULT '0' COMMENT '快递公司id',
  `receive_time` int(11) NOT NULL DEFAULT '0' COMMENT '确定收货时间',
  `buy_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '购买类型：1：批量 2：样品',
  `brand_name` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌名',
  `brand_id` int(10) NOT NULL DEFAULT '0' COMMENT '品牌id',
  `complete_address` varchar(255) NOT NULL DEFAULT '' COMMENT '完整地址',
  `type_id` int(10) NOT NULL DEFAULT '0' COMMENT '购买的商品类型对应id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1244 DEFAULT CHARSET=utf8 COMMENT='订单表';

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
  `goods_img` varchar(200) NOT NULL DEFAULT '' COMMENT '商品缩略图',
  `goods_name` varchar(60) NOT NULL DEFAULT '' COMMENT '商品名称',
  `specification` varchar(1000) NOT NULL DEFAULT '' COMMENT '商品规格',
  `buy_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '购买类型：1：批量 2：样品',
  `brand_name` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌名',
  `brand_id` int(10) NOT NULL DEFAULT '0' COMMENT '品牌id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5054 DEFAULT CHARSET=utf8 COMMENT='订单详情表';

-- ----------------------------
-- Table structure for pay
-- ----------------------------
DROP TABLE IF EXISTS `pay`;
CREATE TABLE `pay` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'user_id',
  `sn` varchar(32) NOT NULL COMMENT '内部订单编号',
  `actually_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `pay_code` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付方式：0：保留 1 微信 2：支付宝 3：网银 4:钱包',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付单方式：0：保留 1 订单 2：充值 3：加盟 4城市合伙人定金 5 城市合伙人尾款',
  `payment_time` varchar(14) NOT NULL DEFAULT '' COMMENT '支付时间',
  `pay_sn` varchar(33) NOT NULL DEFAULT '' COMMENT '支付单号',
  `pay_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0：临时 1:待付款 2:已付款 ',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sn` (`sn`)
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8 COMMENT='支付表';

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：违规（禁售） 2：删除',
  `shelf_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '上下架： 1：下架 2：待审核 3 上架',
  `sort` tinyint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `consume_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '耗时时间（分钟）',
  `thumb_img` varchar(600) NOT NULL DEFAULT '' COMMENT '简介图',
  `main_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '主图',
  `intro` text NOT NULL COMMENT '简介',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '编辑时间',
  `audit` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '审核：0 审核中 1：通过 2：未通过',
  `tag` varchar(1000) NOT NULL DEFAULT '' COMMENT '标签',
  `is_selection` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：不是精选 1：精选',
  `detail_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '详情图 介绍',
  `video` varchar(600) NOT NULL DEFAULT '' COMMENT '视频url',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  `background_img` varchar(200) NOT NULL DEFAULT '' COMMENT '背景颜色图',
  `process_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '流程图',
  `description` text NOT NULL COMMENT '描述',
  `remarks` text NOT NULL COMMENT '注意事项',
  `recommend_goods` varchar(300) DEFAULT '' COMMENT '推荐商品: 例 ''1,2,3''',
  `process` text NOT NULL COMMENT '项目流程 json',
  `share_title` varchar(255) NOT NULL DEFAULT '' COMMENT '分享标题',
  `share_desc` varchar(300) NOT NULL DEFAULT '' COMMENT '分享描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目表';

-- ----------------------------
-- Table structure for project_category
-- ----------------------------
DROP TABLE IF EXISTS `project_category`;
CREATE TABLE `project_category` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='项目分类表';

-- ----------------------------
-- Table structure for project_goods
-- ----------------------------
DROP TABLE IF EXISTS `project_goods`;
CREATE TABLE `project_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '项目ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '''状态：0 ：启用 1：禁用 2：删除''',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=258 DEFAULT CHARSET=utf8 COMMENT='项目-商品-关联表';

-- ----------------------------
-- Table structure for project_promotion
-- ----------------------------
DROP TABLE IF EXISTS `project_promotion`;
CREATE TABLE `project_promotion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '项目ID',
  `promotion_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '促销ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '''状态：0 ：启用 1：禁用 2：删除''',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='场景-方案-关联表';

-- ----------------------------
-- Table structure for promotion
-- ----------------------------
DROP TABLE IF EXISTS `promotion`;
CREATE TABLE `promotion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：违规（禁售） 2：删除',
  `shelf_status` tinyint(3) unsigned NOT NULL DEFAULT '3' COMMENT '上下架标识位 1：下架 2：待审核 3 上架',
  `sort` tinyint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `consume_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '耗时时间（分钟）',
  `thumb_img` varchar(200) NOT NULL DEFAULT '' COMMENT '主图',
  `share_title` varchar(255) NOT NULL DEFAULT '' COMMENT '分享标题',
  `share_desc` varchar(300) NOT NULL DEFAULT '' COMMENT '分享描述',
  `main_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '详情图片',
  `intro` text NOT NULL COMMENT '简介详情',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '编辑时间',
  `audit` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '审核：0 审核中 1：通过 2：未通过',
  `tag` varchar(100) NOT NULL DEFAULT '' COMMENT '标签',
  `background_img` varchar(200) NOT NULL DEFAULT '' COMMENT '背景颜色图',
  `logo_img` varchar(200) NOT NULL DEFAULT '' COMMENT '品牌logo',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  `retail_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '套餐价格',
  `remarks` varchar(2000) NOT NULL DEFAULT '' COMMENT '备注: ',
  `factory_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '出厂价',
  `agent_special_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理特价',
  `agent_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理价',
  `franchise_special_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '加盟特价',
  `franchise_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '加盟价|店家采购价',
  `belong_to_member_buy` tinyint(3) unsigned NOT NULL DEFAULT '6' COMMENT '平台会员身份：1、普通会员, 2、加盟店家 4、城市合伙人 ',
  `is_company_info` tinyint(3) DEFAULT '0' COMMENT '是否登记公司信息',
  `upgrade_member_level` tinyint(3) DEFAULT '0' COMMENT ' 购买后可以升级的会员等级',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='促销表';

-- ----------------------------
-- Table structure for promotion_goods
-- ----------------------------
DROP TABLE IF EXISTS `promotion_goods`;
CREATE TABLE `promotion_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `promotion_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '''状态：0 ：启用 1：禁用 2：删除''',
  `goods_num` smallint(1) unsigned NOT NULL DEFAULT '1' COMMENT '商品数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=759 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='促销-商品-关联表';

-- ----------------------------
-- Table structure for recommend_goods
-- ----------------------------
DROP TABLE IF EXISTS `recommend_goods`;
CREATE TABLE `recommend_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `recommend_goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '推荐商品ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '''状态：0 ：启用 1：禁用 2：删除''',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品-推荐商品-关联表';

-- ----------------------------
-- Table structure for scene
-- ----------------------------
DROP TABLE IF EXISTS `scene`;
CREATE TABLE `scene` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：违规（禁售） 2：删除',
  `shelf_status` tinyint(3) unsigned NOT NULL DEFAULT '2' COMMENT '上下架标识位 1：下架 2：待审核 3 上架',
  `sort` tinyint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `consume_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '耗时时间（分钟）',
  `thumb_img` varchar(200) NOT NULL DEFAULT '' COMMENT '主图',
  `main_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '详情图片',
  `intro` varchar(2000) NOT NULL COMMENT '简介详情',
  `share_title` varchar(255) NOT NULL DEFAULT '' COMMENT '分享标题',
  `share_desc` varchar(300) NOT NULL DEFAULT '' COMMENT '分享描述',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '编辑时间',
  `audit` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '审核：0 审核中 1：通过 2：未通过',
  `tag` varchar(100) NOT NULL DEFAULT '' COMMENT '标签',
  `is_selection` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：不是精选 1：精选',
  `background_img` varchar(250) NOT NULL DEFAULT '' COMMENT '背景颜色图',
  `logo_img` varchar(200) NOT NULL DEFAULT '' COMMENT '品牌logo',
  `type` tinyint(3) NOT NULL DEFAULT '1' COMMENT '场景类型：1 场景， 2 分类，3项目',
  `display_type` varchar(60) NOT NULL DEFAULT 'detail' COMMENT '展示类型： detail 场景详情，sort 分类，project 项目',
  `tag_category` tinyint(2) NOT NULL DEFAULT '0' COMMENT '标签类别：1-黑森森，2-门店场景应用，3-门店护理项目，4-新零售应用场景，5-新零售商品分类',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='场景表';

-- ----------------------------
-- Table structure for scene_goods
-- ----------------------------
DROP TABLE IF EXISTS `scene_goods`;
CREATE TABLE `scene_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `scene_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '''状态：0 ：启用 1：禁用 2：删除''',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1487 DEFAULT CHARSET=utf8 COMMENT='场景-商品-关联表';

-- ----------------------------
-- Table structure for scene_goods_category
-- ----------------------------
DROP TABLE IF EXISTS `scene_goods_category`;
CREATE TABLE `scene_goods_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `scene_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `goods_category_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品分类ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '''状态：0 ：启用 1：禁用 2：删除''',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='场景-商品分类-关联表';

-- ----------------------------
-- Table structure for scene_promotion
-- ----------------------------
DROP TABLE IF EXISTS `scene_promotion`;
CREATE TABLE `scene_promotion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `scene_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `promotion_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '促销ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '''状态：0 ：启用 1：禁用 2：删除''',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='场景-方案-关联表';

-- ----------------------------
-- Table structure for shortcut
-- ----------------------------
DROP TABLE IF EXISTS `shortcut`;
CREATE TABLE `shortcut` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ad_position_id` int(11) DEFAULT NULL COMMENT '广告类型id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '广告名称',
  `thumb_img` varchar(200) NOT NULL DEFAULT '' COMMENT '广告图',
  `ad_link` varchar(255) NOT NULL DEFAULT '' COMMENT '广告链接',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `type` tinyint(3) NOT NULL DEFAULT '1' COMMENT '广告类型 ',
  `shelf_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '上下架： 1：下架 2：待审核 3 上架',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用  2：删除',
  `end_time` int(11) DEFAULT '0' COMMENT '广告结束显示时间',
  `start_time` int(11) DEFAULT '0' COMMENT '广告开始显示时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='广告表';

-- ----------------------------
-- Table structure for sign_up
-- ----------------------------
DROP TABLE IF EXISTS `sign_up`;
CREATE TABLE `sign_up` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(25) NOT NULL DEFAULT '' COMMENT '名称',
  `mobile` varchar(15) NOT NULL DEFAULT '' COMMENT '手机电话',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8 COMMENT='参加会议申请表';

-- ----------------------------
-- Table structure for sort
-- ----------------------------
DROP TABLE IF EXISTS `sort`;
CREATE TABLE `sort` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：违规（禁售） 2：删除',
  `shelf_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '上下架： 1：下架 2：待审核 3 上架',
  `sort` tinyint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `consume_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '耗时时间（分钟）',
  `thumb_img` varchar(600) NOT NULL DEFAULT '' COMMENT '简介图',
  `main_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '主图',
  `intro` text NOT NULL COMMENT '简介',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '编辑时间',
  `audit` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '审核：0 审核中 1：通过 2：未通过',
  `tag` varchar(1000) NOT NULL DEFAULT '' COMMENT '标签',
  `is_selection` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：不是精选 1：精选',
  `detail_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '详情图',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  `background_img` varchar(200) NOT NULL DEFAULT '' COMMENT '背景颜色图',
  `process_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '流程图-相关培训',
  `recommend_goods` varchar(300) NOT NULL DEFAULT '' COMMENT '推荐商品: 例 ''1,2,3''',
  `share_title` varchar(255) NOT NULL DEFAULT '' COMMENT '分享标题',
  `share_desc` varchar(300) NOT NULL DEFAULT '' COMMENT '分享描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='项目表';

-- ----------------------------
-- Table structure for sort_goods
-- ----------------------------
DROP TABLE IF EXISTS `sort_goods`;
CREATE TABLE `sort_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `sort_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '品类ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '''状态：0 ：启用 1：禁用 2：删除''',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8 COMMENT='项目-商品-关联表';

-- ----------------------------
-- Table structure for sort_promotion
-- ----------------------------
DROP TABLE IF EXISTS `sort_promotion`;
CREATE TABLE `sort_promotion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `sort_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '品类ID',
  `promotion_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '促销ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '''状态：0 ：启用 1：禁用 2：删除''',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='场景-方案-关联表';

-- ----------------------------
-- Table structure for two_dimensional_code
-- ----------------------------
DROP TABLE IF EXISTS `two_dimensional_code`;
CREATE TABLE `two_dimensional_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '买家id',
  `code_url` varchar(255) DEFAULT '' COMMENT '用户平台分享二维码路径',
  `two_dimensional_code_url` varchar(200) NOT NULL DEFAULT '0' COMMENT '用户平台最终分享图片路径',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(20) NOT NULL DEFAULT '0' COMMENT '加入时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1082 DEFAULT CHARSET=utf8 COMMENT='用户平台二维码';

-- ----------------------------
-- Table structure for user_test
-- ----------------------------
DROP TABLE IF EXISTS `user_test`;
CREATE TABLE `user_test` (
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Table structure for wallet
-- ----------------------------
DROP TABLE IF EXISTS `wallet`;
CREATE TABLE `wallet` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总金额',
  `password` varchar(64) NOT NULL DEFAULT '' COMMENT '密码',
  `salt` char(10) NOT NULL DEFAULT '' COMMENT '盐值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='钱包表';

-- ----------------------------
-- Table structure for wallet_detail
-- ----------------------------
DROP TABLE IF EXISTS `wallet_detail`;
CREATE TABLE `wallet_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `sn` varchar(32) NOT NULL DEFAULT '' COMMENT '编号',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '类型：0：保留 1：充值 2：支付',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `recharge_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '充值状态：0 未完成 1：待处理 -已支付 2：已完成',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总金额',
  `actually_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `pay_sn` varchar(50) NOT NULL DEFAULT '' COMMENT '支付订单号',
  `pay_code` varchar(10) NOT NULL DEFAULT '0' COMMENT '''支付方式：1 微信 2：支付宝 3：网银 4:线下支付',
  `payment_time` varchar(20) NOT NULL DEFAULT '' COMMENT '支付时间',
  `voucher_img` varchar(255) NOT NULL DEFAULT '' COMMENT '汇款凭证',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8 COMMENT='钱包-明细表';

-- ----------------------------
-- Table structure for weixin_share
-- ----------------------------
DROP TABLE IF EXISTS `weixin_share`;
CREATE TABLE `weixin_share` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `link` varchar(255) NOT NULL DEFAULT '' COMMENT '分享链接',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '分享标题',
  `desc` varchar(500) NOT NULL DEFAULT '' COMMENT '分享描述',
  `thumb_img` varchar(200) NOT NULL DEFAULT '' COMMENT '分享图片',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用  2：删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='微信分享管理';

-- ----------------------------
-- Table structure for weixin_user
-- ----------------------------
DROP TABLE IF EXISTS `weixin_user`;
CREATE TABLE `weixin_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '平台user_id',
  `referee` int(11) NOT NULL DEFAULT '0' COMMENT '推荐人',
  `openid` varchar(200) NOT NULL DEFAULT '' COMMENT '微信id',
  `nickname` varchar(200) NOT NULL DEFAULT '' COMMENT '昵称',
  `remark` varchar(20) NOT NULL DEFAULT '' COMMENT '备注',
  `sex` varchar(4) NOT NULL DEFAULT '' COMMENT '性别',
  `country` varchar(10) NOT NULL DEFAULT '' COMMENT '国家',
  `province` varchar(16) NOT NULL DEFAULT '' COMMENT '省份',
  `city` varchar(16) NOT NULL DEFAULT '' COMMENT '城市',
  `headimgurl` varchar(250) NOT NULL DEFAULT '' COMMENT '头像',
  `heartbeat` varchar(15) NOT NULL DEFAULT '' COMMENT '最后心跳',
  `subscribe` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0：没关注 1：关注',
  `subscribe_scene` varchar(100) NOT NULL DEFAULT '' COMMENT '返回用户关注的渠道来源，ADD_SCENE_SEARCH 公众号搜索，ADD_SCENE_ACCOUNT_MIGRATION 公众号迁移，ADD_SCENE_PROFILE_CARD 名片分享，ADD_SCENE_QR_CODE 扫描二维码，ADD_SCENEPROFILE LINK 图文页内名称点击，ADD_SCENE_PROFILE_ITEM 图文页右上角菜单，ADD_SCENE_PAID 支付后关注，ADD_SCENE_OTHERS 其他',
  `subscribe_time` varchar(20) NOT NULL DEFAULT '' COMMENT '关注时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `openid` (`openid`)
) ENGINE=MyISAM AUTO_INCREMENT=161 DEFAULT CHARSET=utf8;
