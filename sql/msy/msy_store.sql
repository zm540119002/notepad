/*
 Navicat Premium Data Transfer

 Source Server         : msy
 Source Server Type    : MySQL
 Source Server Version : 50624
 Source Host           : 120.79.201.125:3306
 Source Schema         : msy_store

 Target Server Type    : MySQL
 Target Server Version : 50624
 File Encoding         : 65001

 Date: 19/11/2019 11:05:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for shop
-- ----------------------------
DROP TABLE IF EXISTS `shop`;
CREATE TABLE `shop`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `logo_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'logo',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态 0：正常 1：删除',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID：user.id',
  `factory_id` smallint(5) NOT NULL DEFAULT 0 COMMENT '厂商 id',
  `store_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '店铺ID：store.id',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  `consignee_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `consignee_mobile_phone` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '收货人手机号码',
  `consignee_province` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '省',
  `consignee_city` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '市',
  `consignee_area` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '市',
  `consignee_address` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `operation_mobile_phone` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '经营手机号码',
  `operation_fix_phone` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '经营固话',
  `operation_province` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '省',
  `operation_city` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '市',
  `operation_area` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '区',
  `operation_address` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '经营详细地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '门店表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of shop
-- ----------------------------
INSERT INTO `shop` VALUES (39, '维观工作室', 'shop/logo_img/2018120316285931230.jpeg', 0, 20, 14, 175, 1543824051, 0, '林黛玉', '18263366522', 5, 10, 0, '烟台北路120号', '18263366522', '020-88112255', 18, 0, 1, '珠江大道商业广场');
INSERT INTO `shop` VALUES (40, '维雅工作室', '', 0, 20, 14, 175, 1543824519, 1543824526, '', '', 0, 0, 0, '', '', '', 0, 0, 0, '');
INSERT INTO `shop` VALUES (41, '美尚工作室', '', 0, 20, 14, 175, 1543824548, 0, '', '', 0, 0, 0, '', '', '', 0, 0, 0, '');

-- ----------------------------
-- Table structure for user_shop
-- ----------------------------
DROP TABLE IF EXISTS `user_shop`;
CREATE TABLE `user_shop`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID：user.id',
  `factory_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '供应商ID：factory.id',
  `store_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '店铺ID：store.id',
  `shop_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '门店ID：shop.id',
  `type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '类型：0：保留 1：拥有者 2:管理员 3：店长 4：员工',
  `post` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '岗位：0 ：保留 其他：见配置文件permission.php',
  `duty` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '职务：0 ：保留 其他：见配置文件permission.php',
  `user_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户在门店中的昵称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户-门店-关联表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user_shop
-- ----------------------------
INSERT INTO `user_shop` VALUES (73, 0, 20, 14, 175, 39, 1, 0, 0, '');
INSERT INTO `user_shop` VALUES (74, 0, 38, 14, 175, 39, 3, 0, 0, '红楼梦');
INSERT INTO `user_shop` VALUES (75, 0, 20, 14, 175, 40, 1, 0, 0, '');
INSERT INTO `user_shop` VALUES (76, 0, 38, 14, 175, 40, 3, 0, 0, '水浒传');
INSERT INTO `user_shop` VALUES (77, 0, 20, 14, 175, 41, 1, 0, 0, '');
INSERT INTO `user_shop` VALUES (78, 0, 39, 14, 175, 41, 3, 0, 0, '西游记');
INSERT INTO `user_shop` VALUES (79, 0, 35, 0, 175, 41, 4, 12, 12, '林黛玉');
INSERT INTO `user_shop` VALUES (80, 0, 36, 0, 175, 40, 4, 13, 13, '贾宝玉');

-- ----------------------------
-- Table structure for user_shop_node
-- ----------------------------
DROP TABLE IF EXISTS `user_shop_node`;
CREATE TABLE `user_shop_node`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '类型：0：保留',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID：user.id',
  `store_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '店铺ID：store.id',
  `shop_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '门店ID：shop.id',
  `node_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '节点ID：permission.authentication.node.id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户-门店-节点-关联表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user_shop_node
-- ----------------------------
INSERT INTO `user_shop_node` VALUES (15, 0, 1, 35, 175, 41, 11);
INSERT INTO `user_shop_node` VALUES (16, 0, 1, 35, 175, 41, 12);
INSERT INTO `user_shop_node` VALUES (18, 0, 1, 36, 175, 40, 11);
INSERT INTO `user_shop_node` VALUES (19, 0, 1, 36, 175, 40, 14);
INSERT INTO `user_shop_node` VALUES (20, 0, 1, 36, 175, 40, 52);
INSERT INTO `user_shop_node` VALUES (21, 0, 1, 36, 175, 40, 72);

SET FOREIGN_KEY_CHECKS = 1;
