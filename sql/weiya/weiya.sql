/*
Navicat MySQL Data Transfer

Source Server         : 阿里云-维雅
Source Server Version : 50624
Source Host           : 47.106.79.38:3306
Source Database       : weiya

Target Server Type    : MYSQL
Target Server Version : 50624
File Encoding         : 65001

Date: 2019-07-11 11:25:45
*/

SET FOREIGN_KEY_CHECKS=0;

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
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COMMENT='商标表';

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '购物车id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '买家id',
  `foreign_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `num` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '购买商品数量',
  `create_time` int(20) NOT NULL DEFAULT '0' COMMENT '加入购物车时间',
  `goods_type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '类型：0 保留 1 商品 2项目',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `buy_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '类型：0 保留 1 批量 2 样品',
  `brand_name` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌名',
  `brand_id` int(10) NOT NULL DEFAULT '0' COMMENT '品牌id',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=558 DEFAULT CHARSET=utf8 COMMENT='购物车数据表';

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
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8 COMMENT='收藏表';

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
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '商品名称',
  `headline` varchar(500) NOT NULL DEFAULT '' COMMENT '标题文案',
  `bulk_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '批量价格',
  `sample_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '样品价格',
  `minimum_order_quantity` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '订单起订量',
  `minimum_sample_quantity` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '样品起订量',
  `specification` varchar(1000) NOT NULL DEFAULT '' COMMENT '商品规格',
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
  `shelf_status` tinyint(3) unsigned NOT NULL DEFAULT '2' COMMENT '商品上下架标识位 1：下架 2：待审核 3 上架',
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8 COMMENT='商品表';

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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 COMMENT='商品分类表';

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='资讯';

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='需求留言';

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `sn` varchar(32) NOT NULL COMMENT '编号',
  `pay_sn` varchar(33) NOT NULL DEFAULT '' COMMENT '支付单号',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型：0：普通 1：团购',
  `order_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '物流状态：0：临时 1:待付款 2:待收货 3:待评价 4:已完成 5:已取消 6:售后',
  `after_sale_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '售后服务状态 0：正常 1：待处理 2：已完成',
  `pay_code` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付方式：0：保留 1 微信 2：支付宝 3：网银 4:钱包',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总金额',
  `coupons_pay` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '代金券支付金额',
  `wallet_pay` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '钱包支付金额',
  `actually_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `remark` varchar(2000) NOT NULL DEFAULT '' COMMENT '备注说明',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `coupons_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '代金券ID:coupons.id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '生成时间',
  `payment_time` varchar(14) NOT NULL DEFAULT '' COMMENT '支付时间',
  `finished_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '完成时间',
  `consignee` varchar(50) NOT NULL DEFAULT '' COMMENT '收货人',
  `mobile` varchar(15) NOT NULL DEFAULT '' COMMENT '手机电话',
  `province` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `city` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `area` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '区',
  `detail_address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `brand_name` varchar(255) NOT NULL DEFAULT '' COMMENT '定制的品牌名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=425 DEFAULT CHARSET=utf8 COMMENT='订单表';

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
  `buy_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '购买类型：1：批量 2：样品',
  `store_id` int(10) NOT NULL,
  `brand_name` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌名',
  `brand_id` int(10) NOT NULL DEFAULT '0' COMMENT '品牌id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1323 DEFAULT CHARSET=utf8 COMMENT='订单详情表';

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
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付单方式：0：保留 1 订单 2：充值 3：加盟  ',
  `payment_time` varchar(14) NOT NULL DEFAULT '' COMMENT '支付时间',
  `pay_sn` varchar(33) NOT NULL DEFAULT '' COMMENT '支付单号',
  `pay_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0：临时 1:待付款 2:已付款 ',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sn` (`sn`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COMMENT='支付表';

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '名称',
  `category_id_1` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '一级分类id',
  `category_id_2` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '二级分类id',
  `category_id_3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '三级分类id',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：违规（禁售） 2：删除',
  `shelf_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '上下架：0：保留 1：上架 2：下架',
  `sort` tinyint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `consume_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '耗时时间（分钟）',
  `thumb_img` varchar(600) NOT NULL DEFAULT '' COMMENT '主图',
  `main_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '详情图片',
  `intro` text NOT NULL COMMENT '简介',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '编辑时间',
  `audit` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '审核：0 审核中 1：通过 2：未通过',
  `tag` varchar(1000) NOT NULL DEFAULT '' COMMENT '标签',
  `is_selection` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：不是精选 1：精选',
  `detail_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '详情图',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COMMENT='项目表';

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
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 COMMENT='项目-商品-关联表';

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
) ENGINE=InnoDB AUTO_INCREMENT=805 DEFAULT CHARSET=utf8 COMMENT='商品-推荐商品-关联表';

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
  `intro` text NOT NULL COMMENT '简介',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '编辑时间',
  `audit` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '审核：0 审核中 1：通过 2：未通过',
  `tag` varchar(100) NOT NULL DEFAULT '' COMMENT '标签',
  `is_selection` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：不是精选 1：精选',
  `background_img` varchar(250) NOT NULL DEFAULT '' COMMENT '背景颜色',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8 COMMENT='场景表';

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
) ENGINE=InnoDB AUTO_INCREMENT=1092 DEFAULT CHARSET=utf8 COMMENT='场景-商品-关联表';

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='钱包表';

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
  `recharge_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '充值状态：0 未完成 1 完成',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总金额  充值到wallet数值',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `pay_sn` varchar(50) NOT NULL DEFAULT '' COMMENT '支付订单号',
  `pay_code` varchar(10) NOT NULL DEFAULT '0' COMMENT '''支付方式：1:支付宝 2:weixin 3:银联',
  `payment_time` varchar(20) NOT NULL DEFAULT '' COMMENT '支付时间',
  `actually_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8 COMMENT='钱包-明细表';
