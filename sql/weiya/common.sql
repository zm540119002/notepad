/*
Navicat MySQL Data Transfer

Source Server         : 阿里云-维雅
Source Server Version : 50624
Source Host           : 47.106.79.38:3306
Source Database       : common

Target Server Type    : MYSQL
Target Server Version : 50624
File Encoding         : 65001

Date: 2019-07-11 11:25:34
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='买家地址信息表';

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
  `to_accept` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '目的接收标志 0：未接收 1：已接收',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=711 DEFAULT CHARSET=utf8 COMMENT='聊天消息表';

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型 0：保留 1：管理员 2：普通',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '用户名（即账号），可用于登录系统',
  `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '昵称',
  `mobile_phone` varchar(15) NOT NULL DEFAULT '' COMMENT '手机号，可用于登录系统',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型 0：不可登陆 1：游客，可登陆 2：已实名认证',
  `password` varchar(64) NOT NULL DEFAULT '' COMMENT '密码',
  `role_id` tinyint(4) NOT NULL DEFAULT '0' COMMENT '角色ID：role.id',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `sex` tinyint(4) NOT NULL DEFAULT '0' COMMENT '性别；0：保密，1：男；2：女',
  `salt` char(10) NOT NULL DEFAULT '' COMMENT '盐值',
  `birthday` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '生日',
  `last_login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后更新时间',
  `weiya_openid` varchar(500) NOT NULL DEFAULT '' COMMENT '维雅公众号openid',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COMMENT='用户表';
