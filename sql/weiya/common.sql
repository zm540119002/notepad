/*
 Navicat Premium Data Transfer

 Source Server         : weiya
 Source Server Type    : MySQL
 Source Server Version : 50624
 Source Host           : 47.106.79.38:3306
 Source Schema         : common

 Target Server Type    : MySQL
 Target Server Version : 50624
 File Encoding         : 65001

 Date: 19/11/2019 11:07:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` mediumint(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` mediumint(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `consignee` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '收货人',
  `detail_address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `tel_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '座机电话',
  `mobile` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '手机电话',
  `is_default` tinyint(3) NOT NULL DEFAULT 0 COMMENT '1默认收货地址',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `province` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '省',
  `city` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '市',
  `area_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '地区编码',
  `area` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '区',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `member_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 319 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '买家地址信息表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (167, 55, '呐呐呐', '内蒙', '', '11111111111', 0, 2, '150000', '150100', '', '610102');
INSERT INTO `address` VALUES (168, 55, '呐呐呐', '内蒙', '', '11111111111', 1, 2, '呼和浩特市', '0', '', '新城区');
INSERT INTO `address` VALUES (169, 55, '楠楠', '浠水', '', '15914540659', 0, 2, '420000', '421100', '', '421125');
INSERT INTO `address` VALUES (270, 19, '朱明11', '杭州市西湖区 黄龙万科中心', '', '13679898888', 1, 2, '220000', '220100', '220000', '220102');
INSERT INTO `address` VALUES (271, 19, '刘德华', '杭州市西湖区 黄龙万科中心', '', '13430393576', 0, 2, '230000', '230100', '230000', '230102');
INSERT INTO `address` VALUES (272, 19, '陈真', '杭州市西湖区 黄龙万科中心', '', '13679896666', 0, 2, '340000', '340100', '340000', '340102');
INSERT INTO `address` VALUES (273, 19, '李小龙', '杭州市西湖区 黄龙万科中心', '', '13430395555', 0, 2, '420000', '420100', '420000', '420102');
INSERT INTO `address` VALUES (274, 55, '楠楠', 'aaa', '', '15914540659', 1, 2, '北京市', '', '', '');
INSERT INTO `address` VALUES (275, 55, '新增', '1111', '', '15914540659', 0, 2, '黑龙江省', '哈尔滨市', '', '道里区');
INSERT INTO `address` VALUES (276, 55, '111', '111', '', '15914540659', 0, 2, '150000', '150100', '', '610102');
INSERT INTO `address` VALUES (277, 55, '111111', '15914540659', '', '15914540659', 1, 2, '北京市', '北京市', '', '东城区');
INSERT INTO `address` VALUES (278, 55, '1111', '15914540659', '', '15914540659', 0, 2, '350000', '350100', '', '410204');
INSERT INTO `address` VALUES (279, 55, '1111111', '15914540659', '', '15914540659', 0, 2, '340000', '340100', '', '340102');
INSERT INTO `address` VALUES (280, 55, '11', '111', '', '15914540659', 1, 2, '220000', '220100', '', '220102');
INSERT INTO `address` VALUES (281, 55, '1', '11', '', '15914540659', 1, 2, '140000', '140100', '', '140105');
INSERT INTO `address` VALUES (282, 55, '1', '111', '', '15914540659', 0, 2, '150000', '150100', '', '610102');
INSERT INTO `address` VALUES (283, 55, '1111', 'fff', '', '15914540659', 1, 2, '220000', '220100', '', '220102');
INSERT INTO `address` VALUES (284, 55, '11', 'rr', '', '15914540659', 1, 2, '220000', '220100', '', '220102');
INSERT INTO `address` VALUES (285, 55, '123', '123123123', '', '15816810346', 0, 2, '110000', '110100', '', '110101');
INSERT INTO `address` VALUES (286, 55, '111', '5555', '', '15914540659', 0, 2, '130000', '130100', '', '610116');
INSERT INTO `address` VALUES (287, 55, '33344', 'dddd', '', '12345678909', 1, 2, '河北省', '石家庄市', '', '长安区');
INSERT INTO `address` VALUES (288, 55, '222', '1111', '', '15816810333', 0, 2, '150000', '150100', '', '610102');
INSERT INTO `address` VALUES (289, 55, '1233333', '123123123', '', '12312312311', 1, 2, '220000', '220100', '', '220102');
INSERT INTO `address` VALUES (290, 55, '默认', 'aaaaaaaa', '', '15914540659', 1, 2, '150000', '150100', '', '610102');
INSERT INTO `address` VALUES (291, 55, '默认', '11111111111111', '', '15914506591', 1, 2, '210000', '210100', '', '710439');
INSERT INTO `address` VALUES (292, 55, '111', '1111', '', '15914540659', 0, 2, '150000', '150100', '', '610102');
INSERT INTO `address` VALUES (293, 55, '111', 'ggggg', '', '11111111111', 0, 2, '210000', '210100', '', '710439');
INSERT INTO `address` VALUES (294, 55, '默认', 'aaa', '', '15944444444', 1, 2, '330000', '330100', '', '330102');
INSERT INTO `address` VALUES (295, 55, '1111', '1111', '', '11111111111', 0, 2, '210000', '210100', '', '710439');
INSERT INTO `address` VALUES (296, 55, '222', '1111', '', '11111111111', 0, 2, '310000', '310100', '', '310101');
INSERT INTO `address` VALUES (297, 55, '默认', 'aaaa', '', '11111111111', 0, 2, '320000', '320100', '', '320102');
INSERT INTO `address` VALUES (298, 55, '默认', '11111111111', '', '11111111111', 1, 2, '320000', '320100', '', '320102');
INSERT INTO `address` VALUES (299, 55, '默认', '111111111111', '', '11111111111', 1, 2, '330000', '330100', '', '330102');
INSERT INTO `address` VALUES (300, 55, '11', '1111111', '', '11111111111', 1, 2, '320000', '320100', '', '320102');
INSERT INTO `address` VALUES (301, 55, '新增', '11', '', '15914540659', 0, 2, '230000', '230100', '', '230102');
INSERT INTO `address` VALUES (302, 55, '', '', '', '', 0, 2, '0', '0', '', '0');
INSERT INTO `address` VALUES (303, 55, '33', 'ddd', '', '15914540659', 0, 2, '110000', '110100', '', '110102');
INSERT INTO `address` VALUES (304, 55, '', '', '', '', 0, 2, '0', '0', '', '0');
INSERT INTO `address` VALUES (305, 55, '', '', '', '', 0, 2, '0', '0', '', '0');
INSERT INTO `address` VALUES (306, 55, '新增', '1111', '', '15914540659', 0, 2, '110000', '110100', '', '110101');
INSERT INTO `address` VALUES (307, 55, '1111111', '', '', '22222222', 0, 2, '北京市', '市辖区', '', '东城区');
INSERT INTO `address` VALUES (308, 55, '111', 'tt', '', '22222', 1, 2, '北京市', '市辖区', '', '东城区');
INSERT INTO `address` VALUES (309, 55, '222', '3333', '', '33333', 0, 2, '北京市', '市辖区', '', '东城区');
INSERT INTO `address` VALUES (310, 55, '1', '111', '', '2', 0, 2, '吉林省', '长春市', '', '双阳区');
INSERT INTO `address` VALUES (311, 55, '1', '111', '', '2', 0, 2, '吉林省', '长春市', '', '双阳区');
INSERT INTO `address` VALUES (312, 55, '1', '111', '', '2', 0, 2, '吉林省', '长春市', '', '双阳区');
INSERT INTO `address` VALUES (313, 55, '1', '3', '', '2', 0, 2, '北京市', '市辖区', '', '东城区');
INSERT INTO `address` VALUES (314, 55, '1', '3', '', '2', 0, 2, '北京市', '市辖区', '', '东城区');
INSERT INTO `address` VALUES (315, 55, '1', '3', '', '2', 0, 2, '北京市', '市辖区', '', '东城区');
INSERT INTO `address` VALUES (316, 55, '1', 'tt', '', '2', 0, 0, '北京市', '市辖区', '', '东城区');
INSERT INTO `address` VALUES (317, 55, '2', 'g', '', '2', 1, 0, '北京市', '市辖区', '', '东城区');
INSERT INTO `address` VALUES (318, 55, '姓名', '11111111111111', '', '1111', 0, 0, '北京市', '市辖区', '', '东城区');

-- ----------------------------
-- Table structure for chat_message
-- ----------------------------
DROP TABLE IF EXISTS `chat_message`;
CREATE TABLE `chat_message`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态：0 ：启用 1：禁用 2：删除',
  `from_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送ID user.id',
  `to_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '接收ID，依据receive_type：1 user.id，2 group.id',
  `read` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否已读：0 ：未读 1：已读',
  `receive_type` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '接收对象类型 0：保留 1：个人 2：群组',
  `type` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '类型 0：保留 1：文字 2：图片 3：文件 4：视频 5：定位',
  `content` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `to_accept` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '目的接收标志 0：未接收 1：已接收',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 711 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '聊天消息表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of chat_message
-- ----------------------------
INSERT INTO `chat_message` VALUES (701, 0, 29, 17, 1, 1, 1, 'aaaaaaaaaa', 1550555748, 1);
INSERT INTO `chat_message` VALUES (702, 0, 17, 29, 1, 1, 1, 'bbbbbbbbbbbbbbb', 1550555770, 0);
INSERT INTO `chat_message` VALUES (703, 0, 29, 17, 1, 1, 1, 'ccccccccccccc', 1550555774, 1);
INSERT INTO `chat_message` VALUES (704, 0, 17, 29, 1, 1, 1, 'dddddddddd', 1550555779, 0);
INSERT INTO `chat_message` VALUES (705, 0, 25, 17, 1, 1, 1, '111111111111', 1550555929, 1);
INSERT INTO `chat_message` VALUES (706, 0, 17, 25, 0, 1, 1, '22222222222222', 1550555934, 0);
INSERT INTO `chat_message` VALUES (707, 0, 25, 17, 1, 1, 1, '33333333333333333', 1550555938, 1);
INSERT INTO `chat_message` VALUES (708, 0, 17, 25, 0, 1, 1, '444444444444', 1550555941, 0);
INSERT INTO `chat_message` VALUES (709, 0, 21, 17, 1, 1, 1, '元宵节快乐', 1550558571, 1);
INSERT INTO `chat_message` VALUES (710, 0, 17, 21, 1, 1, 1, '元宵节快乐', 1550558699, 0);

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '类型 0：保留 1：管理员 2：普通',
  `remark` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, '超级管理员', 0, 1, '');
INSERT INTO `role` VALUES (2, '操作员', 0, 2, '');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '没有昵称' COMMENT '用户名（即账号），可用于登录系统',
  `nickname` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `mobile_phone` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '手机号，可用于登录系统',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态 0：正常； 1：禁用 ；2：删除',
  `type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '类型 0：不可登陆 1：游客，可登陆 2：已实名认证',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '密码',
  `role_id` tinyint(4) NOT NULL DEFAULT 0 COMMENT '角色ID：role.id',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '头像',
  `sex` tinyint(4) NOT NULL DEFAULT 0 COMMENT '性别；0：保密，1：男；2：女',
  `salt` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '盐值',
  `birthday` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '生日',
  `last_login_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后登录时间',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '注册时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后更新时间',
  `weiya_openid` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '维雅公众号openid',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (16, '杨观保', '', '18664368698', 0, 1, 'bf04d111f5d05e93028acde2eea5561d', 1, 'user_avatar/2019050514375483855.jpeg', 0, 'RzJxDuUaNk', 0, 1562923416, 1543808109, 0, 'oaObx0eEaPcRhGysHH47cSi3hzws');
INSERT INTO `user` VALUES (17, '张敏', '', '18819362618', 0, 1, '4c27d73b8d1a23c9c63f0863ed666e41', 1, 'user_avatar/2019041511522530173.jpeg', 0, 'iXQeOZMdTL', 0, 1573696825, 1543808634, 0, 'oaObx0QEA10_MX7VVCi0ozZxvKbo');
INSERT INTO `user` VALUES (19, '朱观富', '', '13679898380', 0, 1, 'dc20debad3d5d76b8712245fab8aa884', 1, '', 0, 'wVRnBeYUQd', 0, 1568085610, 1543809573, 1565772891, 'oaObx0aRUynMWA7vtD0BSU5xF9tI');
INSERT INTO `user` VALUES (21, '少年维特', '', '15802011548', 0, 1, 'c327d5a028b7a298c7341126c72e66a7', 1, 'user_avatar/2019021615053430059.jpeg', 0, 'OUguARxrSH', 0, 1551504846, 1543817348, 0, 'oaObx0ZNbxltH2D54QTdtzaBU9vY');
INSERT INTO `user` VALUES (22, '彭于晏', '', '18263366521', 0, 1, '1f3791c06594621cb4d700646853edac', 0, '', 0, 'ifXaQtuwol', 0, 1544421657, 1543817640, 0, '');
INSERT INTO `user` VALUES (23, '彭于晏', '', '18263366522', 0, 1, '', 0, '', 0, '', 0, 0, 1543817674, 0, '');
INSERT INTO `user` VALUES (24, '周星驰', '', '18263366523', 0, 1, '', 0, '', 0, '', 0, 0, 1543817700, 0, '');
INSERT INTO `user` VALUES (25, '梅艳芳', '', '18263366524', 0, 1, '7ca36be1243934eca9456d24cd4c3944', 1, 'user_avatar/2019021615053430059.jpeg', 0, 'pNPYRrAMqf', 0, 1551340258, 1543817873, 0, '');
INSERT INTO `user` VALUES (26, '阿里巴巴', '', '13087799220', 0, 1, '53c7574b0b5649aca0e70f61b990888f', 0, '', 0, 'pDYrksNaIJ', 0, 1543822008, 1543819465, 0, '');
INSERT INTO `user` VALUES (27, '阿里巴', '', '13087799221', 0, 1, '', 0, '', 0, '', 0, 0, 1543819478, 0, '');
INSERT INTO `user` VALUES (28, '樱桃小丸子', '', '13087799222', 0, 1, '', 0, '', 0, '', 0, 0, 1543819968, 0, '');
INSERT INTO `user` VALUES (29, '关羽', '', '18819996658', 0, 1, 'bd38fc5e8adbb3a25c4a508e28ecb15c', 0, '', 0, 'raqdkSPQTv', 0, 1550566293, 1543820055, 0, '');
INSERT INTO `user` VALUES (30, '王小波', '', '18819665568', 0, 1, '', 0, '', 0, '', 0, 0, 1543820183, 0, '');
INSERT INTO `user` VALUES (31, '樱桃小丸子', '', '13087799223', 0, 1, '', 0, '', 0, '', 0, 0, 1543820674, 0, '');
INSERT INTO `user` VALUES (32, '犬夜叉', '', '13087799224', 0, 1, '', 0, '', 0, '', 0, 0, 1543820766, 0, '');
INSERT INTO `user` VALUES (33, '多啦A梦', '', '13087799225', 0, 1, '', 0, '', 0, '', 0, 0, 1543821611, 0, '');
INSERT INTO `user` VALUES (34, '笑傲江湖', '', '13187799220', 0, 1, '', 0, '', 0, '', 0, 0, 1543822670, 0, '');
INSERT INTO `user` VALUES (35, '神雕侠侣', '', '13187799221', 0, 1, '', 0, '', 0, '', 0, 0, 1543822729, 0, '');
INSERT INTO `user` VALUES (36, '倚天屠龙记', '', '13187799222', 0, 1, '', 0, '', 0, '', 0, 0, 1543822773, 0, '');
INSERT INTO `user` VALUES (37, '连城诀', '', '13187799223', 0, 1, '', 0, '', 0, '', 0, 0, 1543822800, 0, '');
INSERT INTO `user` VALUES (38, '西游记', '', '18163366521', 0, 1, '', 0, '', 0, '', 0, 0, 1543823989, 0, '');
INSERT INTO `user` VALUES (39, '水浒传', '', '18163366520', 0, 1, 'ee08a3bc153b9cf268f0e4dbe5ae5c53', 0, '', 0, 'FPnBDovKOe', 0, 1543824692, 1543824519, 0, '');
INSERT INTO `user` VALUES (40, '游客', '', '15482011548', 0, 1, 'c0f5332ee64975e4d1c1431b58175f99', 0, '', 0, 'DFVifkZogK', 0, 1548207307, 1547174822, 0, '');
INSERT INTO `user` VALUES (42, '戴宏彬', '', '13710651399', 0, 1, '7c5985f95fbcb9655a7a20370ba23494', 1, 'user_avatar/2019012615374812668.jpeg', 0, 'UWKdDyIcls', 0, 1551576945, 1547196825, 0, 'oaObx0eAerVnDOkfao44dofKysQc');
INSERT INTO `user` VALUES (43, '游客', '', '18825039569', 0, 1, '701bd9c768ce2f88ff7289fd4fdcdc72', 0, 'user_avatar/2019021615053430059.jpeg', 0, 'RUEFmJNobD', 0, 1548384451, 1548379258, 0, 'oaObx0UFIpgviYULC9-eSZmNQDjI');
INSERT INTO `user` VALUES (44, '游客', '', '13908031599', 0, 1, 'b4caf5567aed47d68186ab65f2fa465e', 0, '', 0, 'HhIWVpreUA', 0, 1552234642, 1552234642, 0, '');
INSERT INTO `user` VALUES (45, '', '', '18037792272', 0, 1, '03a9daeed54decddbe2cf615aec0f2bb', 0, '', 0, 'uUmyJiontb', 0, 1557542210, 1557541457, 0, '');
INSERT INTO `user` VALUES (46, '', '', '18019026682', 0, 1, 'a4fcab9911b01f9c1514a43dc216a3da', 0, '', 0, 'wSDcLrXypT', 0, 0, 1557549481, 0, '');
INSERT INTO `user` VALUES (47, '', '', '18208728653', 0, 1, '5b1142b98174e3d9db35d8e973ccf28a', 0, '', 0, 'dHQoYKnqxI', 0, 0, 1558522719, 0, '');
INSERT INTO `user` VALUES (48, '', '', '13001057089', 0, 1, 'b04ba2ef4b26fb53e7e008ee602e3256', 0, '', 0, 'UotwaDTIWd', 0, 0, 1558524223, 0, '');
INSERT INTO `user` VALUES (53, 'yangguanbaohh', '', '18664368697', 0, 1, 'f031ec2d29f3f478c9fabab9e300b5ea', 0, 'uploads/user_avatar/2019071915185125929.jpeg', 0, 'zurbQdCGwX', 0, 1564986165, 1563247356, 1563518338, '');
INSERT INTO `user` VALUES (54, '', '', '13719453459', 0, 1, 'a2dc7e9cf7f4b1c67e8c8314fa80b306', 0, '', 0, 'JMXSWTjgsC', 0, 1563519364, 1563519250, 1563519364, '');
INSERT INTO `user` VALUES (55, '名字', '', '15914540659', 0, 1, 'f181eca3df69377cfaede9f3919414ea', 0, '', 0, 'zPukxmoMQB', 0, 1574065643, 1563520347, 1563763918, '');
INSERT INTO `user` VALUES (56, '小昭', '', '15138966926', 0, 1, 'a7f658ed67434288293d12c50051b62b', 0, '', 0, 'xOZdchuLmT', 0, 1566199120, 1566198985, 0, '');
INSERT INTO `user` VALUES (57, '没有昵称', '', '15903689666', 0, 1, '203dc000a58cc0f787f71ff853e83345', 0, '', 0, 'DjQSvhbYOr', 0, 1569470376, 1569470376, 0, '');
INSERT INTO `user` VALUES (58, '没有昵称', '', '15899909479', 0, 1, 'd5d84e7f739a559955d760e6e1bad5a2', 0, '', 0, 'OcWrtNhupK', 0, 1573548929, 1573548796, 1573548929, '');

SET FOREIGN_KEY_CHECKS = 1;
