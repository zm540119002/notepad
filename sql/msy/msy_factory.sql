/*
Navicat MySQL Data Transfer

Source Server         : 阿里云
Source Server Version : 50624
Source Host           : 120.79.201.125:3306
Source Database       : msy_factory

Target Server Type    : MYSQL
Target Server Version : 50624
File Encoding         : 65001

Date: 2019-07-11 11:23:55
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for organize
-- ----------------------------
DROP TABLE IF EXISTS `organize`;
CREATE TABLE `organize` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '名称',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '级别：0：保留 1：一级 ...',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '类型：0：保留',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '供应商ID：factory.id',
  `superior_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级ID：organize.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='行政组织表';

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型 0:管理员 1：普通',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '供应商ID：factory.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Table structure for role_node
-- ----------------------------
DROP TABLE IF EXISTS `role_node`;
CREATE TABLE `role_node` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '角色ID：role.id',
  `node_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '节点ID：node.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-节点-关联表';

-- ----------------------------
-- Table structure for series
-- ----------------------------
DROP TABLE IF EXISTS `series`;
CREATE TABLE `series` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `factory_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '产商id',
  `name` varchar(18) NOT NULL DEFAULT '' COMMENT '系列名称',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态标识位 0：正常 1：删除',
  `sort` int(5) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系列表';

-- ----------------------------
-- Table structure for user_factory_organize
-- ----------------------------
DROP TABLE IF EXISTS `user_factory_organize`;
CREATE TABLE `user_factory_organize` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '供应商ID：factory.id',
  `organize_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '组织ID：organize.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-供应商-组织-关联表';

-- ----------------------------
-- Table structure for user_factory_role
-- ----------------------------
DROP TABLE IF EXISTS `user_factory_role`;
CREATE TABLE `user_factory_role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID：user.id',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '供应商ID：factory.id',
  `role_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '角色ID：role.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-供应商-角色-关联表';
