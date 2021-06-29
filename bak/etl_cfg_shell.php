<?php
/*************************
Data : 201405
description:
数据变换-新数据
History : -
 ***************************/
require_once (dirname ( __FILE__ ) . "/../RptCustom/IncludeRptCustom.php");
require_once ("../pub_lib/func.php");
require_once ("../pub_lib/pub_head.php");
require_once ("./pub_func.php");
require_once ("./pub_util/comm_util.php");
$position = "您当前的位置是：数据变换-SHELL脚本";

$node_id = $_REQUEST ['node_id'];
$old_node_id = $_REQUEST ['node_id'];
if (! is_numeric ( $node_id )) {
    $node_id = "";
}
//print_r($node_id);
$isRead = false; // 只读标志
if (isset ( $_REQUEST ['isRead'] ) && $_REQUEST ['isRead'] == "true") {
    $isRead = true;
}
$sub_service_id = $_REQUEST['sub_service_id'];

$ds_sql = "select ds_id,name from tb_uc_cfg_ds where sub_service_id = " . $sub_service_id;
//print_r($ds_sql);
$ds_arr = execute_type_sql($ds_sql);
$ds_arr = json_encode($ds_arr);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
<html xmlns="http://www.w3.org/1999/xhtml" ng-app="shellConf">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>算法引用</title>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="../app/styles/reset.css">
    <link rel="stylesheet" href="../new_index/css/element-ui.css">
    <link rel="stylesheet" href="../app/styles/reset-elementui.css">
    <!-- 引入js -->
    <script type="text/javascript" src="../new_index/js/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="../new_index/js/vue.js"></script>
    <script type="text/javascript" src="../new_index/js/element-ui.min.js"></script>
    <script type="text/javascript" src="../new_index/js/axios.min.js"></script>
    <script type="text/javascript" src="../new_index/js/qs.min.js"></script>
    <script type="text/javascript" src="../new_index/js/common.js"></script>

    <style type="text/css">
        table {
            width: 100%;
        }
        table input {
            height: 32px;
            border: 1px solid #D9D9D9;
            border-radius: 4px;
            vertical-align: middle;
            font-size: 14px;
            color: rgba(0, 0, 0, 0.65);
        }
    </style>
</head><body class="frame-body">
<div style="margin: 20px;">
    <?php require_once("./audit_config_head.php");?>
</div>
<div id="app" class="frame-card-wrapper">
    <div style="margin: 20px;"></div>

    <el-form  :model="form" :rules="form_rules" ref="form" label-width="120px" style="padding-top: 16px;">
        <div style="margin: 20px;"></div>

        <el-form-item label="任务名称" style="width: 30%" prop="algorithm_task_name">
            <el-input v-model="form.algorithm_task_name" placeholder="请输入任务名称"></el-input>
        </el-form-item>

        <el-form-item label="算法选择" prop="classify">
            <template>
                <el-select v-model="form.classify" placeholder="请选择" @change="classifyChange">
                    <el-option
                        v-for="(item, index) in classifyOptions"
                        :key="index"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </template>
        </el-form-item>

        <el-form-item label="入参数据选择" prop="ds_id">
            <template>
                <el-select v-model="form.ds_id" placeholder="请选择">
                    <el-option
                            v-for="(item, index) in dsArr"
                            :key="index"
                            :label="item.NAME"
                            :value="item.DS_ID">
                    </el-option>
                </el-select>
            </template>
        </el-form-item>

        <el-row>
            <el-col :span="24"><div>入参配置信息：</div></el-col>
        </el-row>

        <div style="margin: 20px;"></div>

        <el-form v-if="form.classify==1" :model="form_param.exponent_smooth_param"  :rules="form_param_rules" ref="form_exponent_smooth_param" key="exponent-smooth" label-position="right" label-width="120px">
            <el-row>
                <el-col :span="11">
                    <el-form-item label="序号" prop="serial_id">
                        <el-input v-model="form_param.exponent_smooth_param.serial_id" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="算法名称" prop="algorithm_name">
                        <el-select v-model="form_param.exponent_smooth_param.algorithm_name" placeholder="请选择">
                            <el-option
                                    v-for="(item, index) in algorithmOptions"
                                    :key="index"
                                    :label="item.label"
                                    :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据周期" prop="data_cycle">
                        <el-input v-model="form_param.exponent_smooth_param.data_cycle" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="平滑系数" prop="smooth_level">
                        <el-input v-model="form_param.exponent_smooth_param.smooth_level" placeholder="填写(0, 1]之间的小数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据值" prop="data_value">
                        <el-input v-model="form_param.exponent_smooth_param.data_value" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="灵敏度" prop="sensitivity">
                        <template>
                            <el-radio-group v-model="form_param.exponent_smooth_param.sensitivity">
                                <el-radio :key="index" :label="item.key" v-for="(item, index) in sensitivity" border>{{item.value}}</el-radio>
                            </el-radio-group>
                        </template>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="自动推荐" prop="is_recommend">
                        <template>
                            <el-radio-group v-model="form_param.exponent_smooth_param.is_recommend">
                                <el-radio :key="index" :label="item.key" v-for="(item, index) in isRecommend" border>{{item.value}}</el-radio>
                            </el-radio-group>
                        </template>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                </el-col>
            </el-row>
        </el-form>

        <el-form v-else-if="form.classify==2" :model="form_param.holt_winter_param" :rules="form_param_rules" ref="form_holt_winter_param" key="holt-winter" label-position="right" label-width="120px">
            <el-row>
                <el-col :span="11">
                    <el-form-item label="序号" prop="serial_id">
                        <el-input v-model="form_param.holt_winter_param.serial_id" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="季节性周期" prop="seasonal_cycle">
                        <el-select v-model="form_param.holt_winter_param.seasonal_cycle" placeholder="请选择">
                            <el-option
                                    v-for="(item, index) in seasonalOptions"
                                    :key="index"
                                    :label="item.label"
                                    :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据周期" prop="data_cycle">
                        <el-input v-model="form_param.holt_winter_param.data_cycle" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="趋势增长方式" prop="trend_increase">
                        <el-select v-model="form_param.holt_winter_param.trend_increase" placeholder="请选择">
                            <el-option
                                    v-for="(item, index) in seasonalGrowOptions"
                                    :key="index"
                                    :label="item.label"
                                    :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据值" prop="data_value">
                        <el-input v-model="form_param.holt_winter_param.data_value" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="季节性增长方式" prop="seasonal_increase">
                        <el-select v-model="form_param.holt_winter_param.seasonal_increase" placeholder="请选择">
                            <el-option
                                    v-for="(item, index) in seasonalGrowOptions"
                                    :key="index"
                                    :label="item.label"
                                    :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="自动推荐" prop="is_recommend">
                        <template>
                            <el-radio-group v-model="form_param.holt_winter_param.is_recommend">
                                <el-radio :key="index" :label="item.key" v-for="(item, index) in isRecommend" border>{{item.value}}</el-radio>
                            </el-radio-group>
                        </template>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="验证集个数" prop="verification_number">
                        <el-input v-model="form_param.holt_winter_param.verification_number" placeholder="整数"style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                </el-col>
                <el-form-item label="灵敏度" prop="sensitivity">
                    <template>
                        <el-radio-group v-model="form_param.holt_winter_param.sensitivity">
                            <el-radio :key="index" :label="item.key" v-for="(item, index) in sensitivity" border>{{item.value}}</el-radio>
                        </el-radio-group>
                    </template>
                </el-form-item>
            </el-row>
        </el-form>

        <el-form v-else-if="form.classify==3" :model="form_param.arima_param" :rules="form_param_rules" ref="form_arima_param" key="arima" label-position="right" label-width="120px">
            <el-row>
                <el-col :span="11">
                    <el-form-item label="序号" prop="serial_id">
                        <el-input v-model="form_param.arima_param.serial_id" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="自回归阶数" prop="autoregressive" >
                        <el-input v-model="form_param.arima_param.autoregressive" placeholder="整数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据周期" prop="data_cycle">
                        <el-input v-model="form_param.arima_param.data_cycle" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="差分次数" prop="difference_count">
                        <el-input v-model="form_param.arima_param.difference_count" placeholder="整数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据值" prop="data_value">
                        <el-input v-model="form_param.arima_param.data_value" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="平移阶数" prop="translation">
                        <el-input v-model="form_param.arima_param.translation" placeholder="整数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="自动推荐" prop="is_recommend">
                        <template>
                            <el-radio-group v-model="form_param.arima_param.is_recommend">
                                <el-radio :key="index" :label="item.key" v-for="(item, index) in isRecommend" border>{{item.value}}</el-radio>
                            </el-radio-group>
                        </template>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="验证集个数" prop="verification_number">
                        <el-input v-model="form_param.arima_param.verification_number" placeholder="整数"style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                </el-col>
                <el-form-item label="灵敏度" prop="sensitivity">
                    <template>
                        <el-radio-group v-model="form_param.arima_param.sensitivity">
                            <el-radio :key="index" :label="item.key" v-for="(item, index) in sensitivity" border>{{item.value}}</el-radio>
                        </el-radio-group>
                    </template>
                </el-form-item>
            </el-row>
        </el-form>

        <el-form v-else-if="form.classify==4" :model="form_param.rnn_param" :rules="form_param_rules" ref="form_rnn_param" key="rnn" label-position="right" label-width="120px">
            <el-row>
                <el-col :span="11">
                    <el-form-item label="序号" prop="serial_id">
                        <el-input v-model="form_param.rnn_param.serial_id" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="时间步" prop="time_step">
                        <el-input v-model="form_param.rnn_param.time_step" placeholder="整数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据周期" prop="data_cycle">
                        <el-input v-model="form_param.rnn_param.data_cycle" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="隐藏层维度" prop="hidden_dimension">
                        <el-input v-model="form_param.rnn_param.hidden_dimension" placeholder="整数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据值" prop="data_value">
                        <el-input v-model="form_param.rnn_param.data_value" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="迭代次数" prop="iteration_count">
                        <el-input v-model="form_param.rnn_param.iteration_count" placeholder="整数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="自动推荐" prop="is_recommend">
                        <template>
                            <el-radio-group v-model="form_param.rnn_param.is_recommend">
                                <el-radio :key="index" :label="item.key" v-for="(item, index) in isRecommend" border>{{item.value}}</el-radio>
                            </el-radio-group>
                        </template>
                    </el-form-item>
                </el-col>
                <el-col :span="11" >
                    <el-form-item label="验证集个数" prop="verification_number">
                        <el-input v-model="form_param.rnn_param.verification_number" placeholder="整数"style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                </el-col>
                <el-form-item label="灵敏度" prop="sensitivity">
                    <template>
                        <el-radio-group v-model="form_param.rnn_param.sensitivity">
                            <el-radio :key="index" :label="item.key" v-for="(item, index) in sensitivity" border>{{item.value}}</el-radio>
                        </el-radio-group>
                    </template>
                </el-form-item>
            </el-row>
        </el-form>

        <el-form v-else-if="form.classify==5" :model="form_param.lstm_param" :rules="form_param_rules" ref="form_lstm_param" key="lstm" label-position="right" label-width="120px">
            <el-row>
                <el-col :span="11">
                    <el-form-item label="序号" prop="serial_id">
                        <el-input v-model="form_param.lstm_param.serial_id" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="时间步" prop="time_step">
                        <el-input v-model="form_param.lstm_param.time_step" placeholder="整数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据周期" prop="data_cycle">
                        <el-input v-model="form_param.lstm_param.data_cycle" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="隐藏层维度" prop="hidden_dimension">
                        <el-input v-model="form_param.lstm_param.hidden_dimension" placeholder="整数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="数据值" prop="data_value">
                        <el-input v-model="form_param.lstm_param.data_value" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="迭代次数" prop="iteration_count">
                        <el-input v-model="form_param.lstm_param.iteration_count" placeholder="整数" style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                    <el-form-item label="自动推荐" prop="is_recommend">
                        <template>
                            <el-radio-group v-model="form_param.lstm_param.is_recommend">
                                <el-radio :key="index" :label="item.key" v-for="(item, index) in isRecommend" border>{{item.value}}</el-radio>
                            </el-radio-group>
                        </template>
                    </el-form-item>
                </el-col>
                <el-col :span="11">
                    <el-form-item label="验证集个数" prop="verification_number">
                        <el-input v-model="form_param.lstm_param.verification_number" placeholder="整数"style="width: 50%"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>

            <el-row>
                <el-col :span="11">
                </el-col>
                <el-form-item label="灵敏度" prop="sensitivity">
                    <template>
                        <el-radio-group v-model="form_param.lstm_param.sensitivity">
                            <el-radio :key="index" :label="item.key" v-for="(item, index) in sensitivity" border>{{item.value}}</el-radio>
                        </el-radio-group>
                    </template>
                </el-form-item>
            </el-row>
        </el-form>

        <el-form-item style="text-align: center;">
            <el-button type="primary" @click="onSubmit('form');">保存</el-button>
            <el-button @click="cancel" style="margin-right: 120px;">取消</el-button>
        </el-form-item>
    </el-form>
</div>
<script type="text/javascript">
    $(document).ready(function (){
        let node_id="<?php echo $_REQUEST['node_id'];?>";
        console.log('node_id:'+node_id);

        let param = {
            loading:true,
            dsArr: <?php echo $ds_arr;?>,
            form_rules:{
                algorithm_task_name: [
                    { required: true, message: '请输入任务名称', trigger: 'blur' },
                ],classify: [
                    { required: true, message: '请选择算法', trigger: 'change' },
                ],ds_id: [
                    { required: true, message: '请选择入参数据', trigger: 'change' },
                ],
            },
            form_param_rules:{
                serial_id: [
                    { required: true, message: '请输入序号', trigger: 'blur' }
                ],
                data_cycle: [
                    { required: true, message: '请输入数据周期', trigger: 'blur' }
                ],
                data_value: [
                    { required: true, message: '请输入数据值', trigger: 'blur' }
                ],
                is_recommend: [
                    { required: true, message: '请选择是否自动推荐', trigger: 'change' }
                ],
                algorithm_name: [
                    { required: true, message: '请选择算法名称', trigger: 'change' }
                ],
                smooth_level: [
                    { required: true, message: '请输入平滑系数', trigger: 'blur' }
                ],
                sensitivity: [
                    { required: true, message: '请选择灵敏度', trigger: 'change' }
                ],
                seasonal_cycle: [
                    { required: true, message: '请选择季节性周期', trigger: 'change' }
                ],
                trend_increase: [
                    { required: true, message: '请选择趋势增长方式', trigger: 'change' }
                ],
                seasonal_increase: [
                    { required: true, message: '请选择季节性增长方式', trigger: 'change' }
                ],
                verification_number: [
                    { required: true, message: '请输入验证集个数', trigger: 'blur' }
                ],
                autoregressive: [
                    { required: true, message: '请输入自回归阶数', trigger: 'blur' }
                ],
                difference_count: [
                    { required: true, message: '请输入差分次数', trigger: 'blur' }
                ],
                translation: [
                    { required: true, message: '请输入平移阶数', trigger: 'blur' }
                ],
                time_step: [
                    { required: true, message: '请输入时间步', trigger: 'blur' }
                ],
                hidden_dimension: [
                    { required: true, message: '请输入隐藏层维度', trigger: 'blur' }
                ],
                iteration_count: [
                    { required: true, message: '请输入迭代次数', trigger: 'blur' }
                ]
            },
            classifyOptions: [
                { value: "1", label: "指数平滑模型" },
                { value: "2", label: "Holt Winter模型" },
                { value: "3", label: "差分自回归移动平均ARIMA模型" },
                { value: "4", label: "循环神经网络RNN模型" },
                { value: "5", label: "长短期记忆神经网络LSTM模型" },
            ],isRecommend: [
                { key: "1", value: "是" },
                { key: "2", value: "否" },
            ],algorithmOptions: [
                { key: "1", value: "一次指数平滑" },
                { key: "2", value: "二次指数平滑" },
                { key: "3", value: "三次指数平滑" }
            ],
            seasonalOptions: [
                { key: "1", value: "季度" },
                { key: "2", value: "周" },
                { key: "3", value: "年" }
            ],
            seasonalGrowOptions: [
                { key: "1", value: "累加式" },
                { key: "2", value: "累乘式" },
                { key: "3", value: "无趋势" }
            ],
            sensitivity: [
                { key: "1", value: "高" },
                { key: "2", value: "中" },
                { key: "3", value: "低" }
            ],
            form:{
                sub_service_id:'<?php echo $sub_service_id;?>',
                algorithm_task_id:'',
                algorithm_task_name:'',
                classify:'4',
                ds_id:'',
            },
            form_param:{
                exponent_smooth_param:{
                    serial_id:'',
                    data_cycle:'',
                    data_value:'',
                    is_recommend:'',
                    algorithm_name:'',
                    smooth_level:'',
                    sensitivity:''
                },
                holt_winter_param:{
                    serial_id:'',
                    data_cycle:'',
                    data_value:'',
                    is_recommend:'',
                    seasonal_cycle:'',
                    trend_increase:'',
                    seasonal_increase:'',
                    verification_number:'',
                    sensitivity:'',
                },
                arima_param:{
                    serial_id:'',
                    data_cycle:'',
                    data_value:'',
                    is_recommend:'',
                    autoregressive:'',
                    difference_count:'',
                    translation:'',
                    verification_number:'',
                    sensitivity:'',
                },
                rnn_param:{
                    serial_id:'',
                    data_cycle:'',
                    data_value:'',
                    is_recommend:'',
                    time_step:'',
                    hidden_dimension:'',
                    iteration_count:'',
                    verification_number:'',
                    sensitivity:'',
                },
                lstm_param:{
                    serial_id:'',
                    data_cycle:'',
                    data_value:'',
                    is_recommend:'',
                    time_step:'',
                    hidden_dimension:'',
                    iteration_count:'',
                    verification_number:'',
                    sensitivity:'',
                }
            }
        };
        new Vue({
            el:'#app',
            data:function(){
                return param;
            },
            methods: {
                message(message,type) {
                    this.$message({
                        message: message || '成功',
                        type: type || 'success',
                        duration: type=='success'?1000:3000,
                        center: true,
                        showClose: true,
                    });
                },classifyChange(cur){
                    const _this = this;
                    _this.form.classify = cur;
                },getData(){
                    const _this = this;
                    console.log(node_id);
                    const url = 'etl_cfg_shell_act.php?act=getData';
                    axios.defaults.timeout = 10000;
                    _this.loading = true;
                    _this.postData = {
                        node_id:node_id,
                    };
                    axios.post(url,Qs.stringify(_this.postData)).
                    then(function (response) {
                        _this.loading = false;
                        response = response.data.data;
                        if (response.algorithmTask != null) {
                            _this.form = response.algorithmTask;
                            if(response.param.exponent_smooth_param){
                                _this.form_param.exponent_smooth_param = response.param.exponent_smooth_param;
                            }
                            if(response.param.holt_winter_param){
                                _this.form_param.holt_winter_param = response.param.holt_winter_param;
                            }
                            if(response.param.arima_param){
                                _this.form_param.arima_param = response.param.arima_param;
                            }
                            if(response.param.rnn_param){
                                _this.form_param.rnn_param = response.param.rnn_param;
                            }
                            if(response.param.lstm_param){
                                _this.form_param.lstm_param = response.param.lstm_param;
                            }
                            console.log(response.param);
                        }
                    }).catch(function (error) {
                        console.log(error);
                        _this.loading = false;
                    });
                },cancel(){
                    if(window.opener!=null){
                        window.close();
                    }else{
                        parent.closeNodeDialog();
                    }
                },onSubmit(formRef) {
                    const _this = this;

                    //参数验证
                    let validPass = true;
                    _this.$refs[formRef].validate((valid) => {
                        if (!valid) {
                            validPass = valid;
                            return false;
                        }
                    });
                    if (_this.form.classify == 1) {
                        formRef =  'form_exponent_smooth_param';
                    } else if(_this.form.classify == 2) {
                        formRef =  'form_holt_winter_param';
                    } else if(_this.form.classify == 3) {
                        formRef =  'form_arima_param';
                    } else if(_this.form.classify == 4) {
                        formRef =  'form_rnn_param';
                    } else if(_this.form.classify == 5) {
                        formRef =  'form_lstm_param';
                    }
                    _this.$refs[formRef].validate((valid) => {
                        if (!valid) {
                            validPass = valid;
                            return false;
                        }
                    });
                    if (!validPass){
                        return false;
                    }

                    _this.form.in_param = {};
                    if (_this.form.classify == 1) {
                        _this.form.in_param.exponent_smooth_param = _this.form_param.exponent_smooth_param;
                    } else if (_this.form.classify == 2) {
                        _this.form.in_param.holt_winter_param = _this.form_param.holt_winter_param;
                    } else if (_this.form.classify == 3) {
                        _this.form.in_param.arima_param = _this.form_param.arima_param;
                    } else if (_this.form.classify == 4) {
                        _this.form.in_param.rnn_param = _this.form_param.rnn_param;
                    } else if (_this.form.classify == 5) {
                        _this.form.in_param.lstm_param = _this.form_param.lstm_param;
                    }
                    const url = 'etl_cfg_shell_act.php?act=save';
                    axios.defaults.timeout = 10000;
                    axios.post(url,Qs.stringify(_this.form)).
                    then(function (response) {
                        response = response.data;

                        if(response.status!=0){
                            _this.message(response.info,'error');
                            return false;
                        }

                        _this.message(response.info);

                        let postData = response.data.postData;
                        if(window.opener!=null){
                            window.opener.setNodeName(node_id,postData.algorithm_task_name,postData.algorithm_task_id);
                            window.close();
                        }else{
                            parent.setNodeName(node_id,postData.algorithm_task_name,postData.algorithm_task_id);
                            parent.closeNodeDialog();
                        }
                    }).catch(function (error) {
                        console.log(error);
                    });
                }
            },created: function(){
                const _this = this;
                _this.getData();
            }
        });
    });
</script>
</body></html>