/*
Navicat MySQL Data Transfer

Source Server         : 阿里云
Source Server Version : 50624
Source Host           : 120.79.201.125:3306
Source Database       : msy_store

Target Server Type    : MYSQL
Target Server Version : 50624
File Encoding         : 65001

Date: 2019-07-11 11:24:05
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for shop
-- ----------------------------
DROP TABLE IF EXISTS `shop`;
CREATE TABLE `shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `logo_img` varchar(255) NOT NULL DEFAULT '' COMMENT 'logo',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常 1：删除',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `factory_id` smallint(5) NOT NULL DEFAULT '0' COMMENT '厂商 id',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '店铺ID：store.id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `consignee_name` varchar(64) NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `consignee_mobile_phone` varchar(15) NOT NULL DEFAULT '' COMMENT '收货人手机号码',
  `consignee_province` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `consignee_city` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `consignee_area` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `consignee_address` varchar(512) NOT NULL DEFAULT '' COMMENT '详细地址',
  `operation_mobile_phone` varchar(15) NOT NULL DEFAULT '' COMMENT '经营手机号码',
  `operation_fix_phone` varchar(15) NOT NULL DEFAULT '' COMMENT '经营固话',
  `operation_province` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `operation_city` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '市',
  `operation_area` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '区',
  `operation_address` varchar(512) NOT NULL DEFAULT '' COMMENT '经营详细地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COMMENT='门店表';

-- ----------------------------
-- Table structure for user_shop
-- ----------------------------
DROP TABLE IF EXISTS `user_shop`;
CREATE TABLE `user_shop` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '供应商ID：factory.id',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '店铺ID：store.id',
  `shop_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '门店ID：shop.id',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型：0：保留 1：拥有者 2:管理员 3：店长 4：员工',
  `post` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '岗位：0 ：保留 其他：见配置文件permission.php',
  `duty` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '职务：0 ：保留 其他：见配置文件permission.php',
  `user_name` varchar(64) NOT NULL DEFAULT '' COMMENT '用户在门店中的昵称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COMMENT='用户-门店-关联表';

-- ----------------------------
-- Table structure for user_shop_node
-- ----------------------------
DROP TABLE IF EXISTS `user_shop_node`;
CREATE TABLE `user_shop_node` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型：0：保留',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '店铺ID：store.id',
  `shop_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '门店ID：shop.id',
  `node_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '节点ID：permission.authentication.node.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='用户-门店-节点-关联表';
