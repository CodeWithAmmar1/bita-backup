import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show cos, sin;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testappbita/Views/aqua%20master/mode_sheet/mode_sheet.dart';
import 'package:testappbita/Views/aqua%20master/season_Sheet/seasonsheet.dart';
import 'package:testappbita/Views/aqua%20master/toggleButton/toggle_button.dart';
import 'package:testappbita/Views/zone_master/custom_widget/custom_bottom_Cfm.dart';
import 'package:testappbita/controller/notification_controller/am1_notificatio_controller/am1_notificatio_controller.dart';
import 'package:testappbita/controller/notification_controller/am2_notification_controller/notification_controller.dart';
import 'package:testappbita/controller/notification_controller/csm_notification_controller/notification_controllercsm.dart';
import 'package:testappbita/controller/notification_controller/dm_notification_controller/dm_notification_controller.dart';
import 'package:testappbita/controller/notification_controller/drain_master_notification/drain_master_notification.dart';
import 'package:testappbita/controller/notification_controller/dx_notification_controller/dx_notification_controller.dart';
import 'package:testappbita/controller/notification_controller/dxmini_notification_controller/dxmini_notification_controller.dart';
import 'package:testappbita/controller/notification_controller/rcm_notification_controller/rcm_notification_controller.dart';
import 'package:testappbita/controller/notification_controller/sp_notification_Controller/sp_notification_Controller.dart';
import 'package:testappbita/controller/notification_controller/telecome_notification_controller/telecom_notification_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/services/firebase_service.dart';

class MqttController extends GetxController {
  final NotificationController _notificationController =
      Get.put(NotificationController());
  final NotificationControlleraM1 _notificationControlleraM1 =
      Get.put(NotificationControlleraM1());
  final NotificationControllercsm _notificationControllerCsm =
      Get.put(NotificationControllercsm());
  final DxNotificationController _notificationControllerDx =
      Get.put(DxNotificationController());
  final DxminiNotificationController _notificationControllerDxm =
      Get.put(DxminiNotificationController());
  final TelecomNotificationController _notificationControllerTel =
      Get.put(TelecomNotificationController());
  final DmNotificationController _notificationControllerDm =
      Get.put(DmNotificationController());
  final SpNotificationController _notificationControllerSp1 =
      Get.put(SpNotificationController());
  final RcmNotificationController _notificationControllerRcm =
      Get.put(RcmNotificationController());
  final DrainMasterNotification _notificationControllerDm1 =
      Get.put(DrainMasterNotification());
  var timeAm2 = false.obs;
  final SensorSwitchController noti = Get.put(SensorSwitchController());

  //ZONE MASTER:
  RxString topicSSIDvalue = "".obs;
  RxString result = "".obs;
  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  RxList<String> selectedDays = <String>[].obs;
  RxList<String> selectedHour = <String>[].obs;
  List<String> hours = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
  ];
  RxBool isSeasonLoading = false.obs;
  RxBool isModeLoading = false.obs;
  RxBool isSummer = false.obs;
  RxBool toggleValue = false.obs;
  Rx<DateTime> selectedDateTime = DateTime.now().obs;
  RxBool isOn = false.obs;
  RxDouble currentValue = 50.0.obs;
  RxDouble temperature = 30.0.obs;
  RxString mqttBroker = 'a31qubhv0f0qec-ats.iot.eu-north-1.amazonaws.com'.obs;
  RxString clientId = "".obs;
  RxString flapstate = "--".obs;
  RxInt port = 8883.obs;
  RxString receivedMessage = "".obs;
  RxInt lastDamperValue = 20.obs;
  RxBool isConnected = false.obs;
  RxString message = "".obs;
  RxBool isUserInteracting = false.obs;
  RxString correctPassword = "1234567".obs;
  RxBool isPasswordCorrect = false.obs;
  RxMap<String, double> deviceTemperatures = <String, double>{}.obs;
  RxMap<String, String> deviceSwitchStates = <String, String>{}.obs;

  //CONTROL MASTER:
  var fanPass = true.obs;
  var pumpPass = true.obs;
  var lastCMValue = 0.0.obs;
  var fan = "--".obs;
  var pump = "--".obs;
  var maincontrol = false.obs;
  var pumpcontrol = true.obs;
  var fancontrol = true.obs;
  var receivedData = {}.obs;
  RxInt userSetValue = 0.obs;
  var cmtemperature = "--".obs;
  var fanSwitch = false.obs;
  var pumpSwitch = false.obs;

  //Sp1
  RxInt tempSetPointsp = 0.obs;
  RxBool systemSwitchsp = false.obs;
  var sp1comprsw = 0.obs;
  RxDouble tempsp = 0.0.obs;

  //Drain Master
  var drainPower = false.obs;
  RxInt wtcdelay = 0.obs;
  RxInt level = 0.obs;
  var dmpumpSwitch = false.obs;
  var dmpumpcontrol = true.obs;
  var dmpump = "--".obs;

  // GHS
  var ghspump = "--".obs;
  var ghsPower = false.obs;
  RxDouble tempGhs = 0.0.obs;
  RxDouble humidityGhs = 0.0.obs;
  RxInt humiditySetPointGhs = 0.obs;
  //WTC
  var wtcfanPass = true.obs;
  var wtcpumpPass = true.obs;
  var wtclastCMValue = 0.obs;
  var wtcfan = "--".obs;
  var wtcpump = "--".obs;
  var wtcmaincontrol = false.obs;
  var wtcpumpcontrol = true.obs;
  var wtcfancontrol = true.obs;
  var wtcreceivedData = {}.obs;
  var wtcuserSetValue = 0.obs;
  var wtccmtemperature = "--".obs;
  var wtcfanSwitch = false.obs;
  var wtcpumpSwitch = false.obs;

  //AM_2:
  final psiTobar = true.obs;
  final ftoC = true.obs;
  final Map<String, double> lastNotifiedValue = {};
  final Map<String, String> lastSwitchState = {};
  final Map<String, bool> alreadyNotified = {};
  var amp1 = 18.obs;
  var amp2 = 15.obs;
  var amp3 = 13.obs;
  var temp1 = 0.0.obs;
  var temp2 = 0.0.obs;
  var temp3 = 0.0.obs;
  var temp4 = 0.0.obs;
  var psig1 = 18.25.obs;
  var psig2 = 25.24.obs;
  var psig3 = 30.18.obs;
  var temp1setlow = 18.obs;
  var temp2setlow = 25.obs;
  var temp3setlow = 25.obs;
  var temp4setlow = 81.obs;
  var psig1setlow = 17.obs;
  var psig2setlow = 100.obs;
  var psig3setlow = 70.obs;
  var temp1sethigh = 18.obs;
  var temp2sethigh = 18.obs;
  var temp3sethigh = 26.obs;
  var temp4sethigh = 82.obs;
  var psig1sethigh = 18.obs;
  var psig2sethigh = 90.obs;
  var psig3sethigh = 50.obs;
  var amp1high = 30.obs;
  var amp2high = 40.obs;
  var amp3high = 50.obs;
  var amp1low = 35.obs;
  var amp2low = 25.obs;
  var amp3low = 15.obs;
  var comp1status = 1.obs;
  var isObscured = false.obs;
  var isNotiInteracting = false.obs;
  RxString highpreswam2 = '--'.obs;
  RxString lowpreswam2 = '--'.obs;
  RxString oilpressureswam2 = '--'.obs;

  //Sensor am2
  var selection1Am2 = "".obs;
  var selection2Am2 = "".obs;
  var selection3Am2 = "".obs;
  var selection4Am2 = "".obs;
  var address1Am2 = "".obs;
  var address2Am2 = "".obs;
  var address3Am2 = "".obs;
  var address4Am2 = "".obs;
  var sensorTemp1 = "0.0".obs;
  var sensorTemp2 = "0.0".obs;
  var sensorTemp3 = "0.0".obs;
  var sensorTemp4 = "0.0".obs;
  var offsett1 = "".obs;
  var offsett2 = "".obs;
  var offsett3 = "".obs;
  var offsett4 = "".obs;
//am2 pressure
  RxBool isOilLoading = false.obs;
  RxBool isSucLoading = false.obs;
  RxBool isDisLoading = false.obs;
  RxBool isAmpLoading = false.obs;
  var pressureRange = "0".obs;
  var pressureUnit = false.obs;
  var pressureType = "".obs;
  var pressureRange2 = "0".obs;
  var pressureUnit2 = false.obs;
  var pressureType2 = "".obs;
  var pressureRange3 = "0".obs;
  var pressureUnit3 = false.obs;
  var pressureType3 = "".obs;

  //DX-400
  final dxpsiTobar = true.obs;
  final dxftoC = true.obs;
  final Map<String, double> dxlastNotifiedValue = {};
  final Map<String, String> dxlastSwitchState = {};
  final Map<String, bool> dxalreadyNotified = {};
  RxBool timematch = false.obs;
  var dxamp1 = 18.obs;
  var dxamp2 = 15.obs;
  var dxamp3 = 13.obs;
  var dxtemp1 = 0.0.obs;
  var dxtemp2 = 0.0.obs;
  var dxtemp3 = 0.0.obs;
  var dxtemp4 = 0.0.obs;
  var dxtemp1F = 0.0.obs;
  var dxtemp2F = 0.0.obs;
  var dxtemp3F = 0.0.obs;
  var dxtemp4F = 0.0.obs;
  var dxpsig1 = 18.25.obs;
  var dxpsig2 = 25.24.obs;
  var dxpsig3 = 30.18.obs;
  var dxpsig1F = 18.25.obs;
  var dxpsig2F = 25.24.obs;
  var dxpsig3F = 30.18.obs;
  var dxtemp1setlow = 18.obs;
  var dxtemp2setlow = 25.obs;
  var dxtemp3setlow = 25.obs;
  var dxtemp4setlow = 81.obs;
  var dxpsig1setlow = 17.obs;
  var dxpsig2setlow = 100.obs;
  var dxpsig3setlow = 70.obs;
  var dxtemp1sethigh = 18.obs;
  var dxtemp2sethigh = 18.obs;
  var dxtemp3sethigh = 26.obs;
  var dxtemp4sethigh = 82.obs;
  var dxpsig1sethigh = 18.obs;
  var dxpsig2sethigh = 90.obs;
  var dxpsig3sethigh = 50.obs;
  var dxamp1high = 30.obs;
  var dxamp2high = 40.obs;
  var dxamp3high = 50.obs;
  var dxamp1low = 35.obs;
  var dxcomp1status = 1.obs;
  var dxisObscured = false.obs;
  var dxisNotiInteracting = false.obs;
  RxString dxhighpreswam2 = '--'.obs;
  RxString dxlowpreswam2 = '--'.obs;
  RxString dxoilpressureswam2 = '--'.obs;
  //Sensor DX-400
  var dxaddress1 = "".obs;
  var dxaddress3 = "".obs;
  var dxaddress2 = "".obs;
  var dxaddress4 = "".obs;
  var dxselection1 = "".obs;
  var dxselection2 = "".obs;
  var dxselection3 = "".obs;
  var dxselection4 = "".obs;
  var dxsensorTemp1 = "0.0".obs;
  var dxsensorTemp2 = "0.0".obs;
  var dxsensorTemp3 = "0.0".obs;
  var dxsensorTemp4 = "0.0".obs;
  var dxoffsett1 = "".obs;
  var dxoffsett2 = "".obs;
  var dxoffsett3 = "".obs;
  var dxoffsett4 = "".obs;
//DX-400 pressure
  RxBool dxisOilLoading = false.obs;
  RxBool dxisDisLoading = false.obs;
  RxBool dxisSucLoading = false.obs;
  RxBool dxisAmpLoading = false.obs;
  RxBool dxisInnerLoading = false.obs;
  RxBool dxisHeatLoading = false.obs;
  RxBool dxisCompLoading = false.obs;
  RxBool dxisFbLoading = false.obs;
  RxBool dxiscompfbLoading = false.obs;
  var dxpressureRange = "0".obs;
  var dxpressureUnit = false.obs;
  var dxpressureType = "".obs;
  var dxpressureRange2 = "0".obs;
  var dxpressureUnit2 = false.obs;
  var dxpressureType2 = "".obs;
  var dxpressureRange3 = "0".obs;
  var dxpressureUnit3 = false.obs;
  var dxpressureType3 = "".obs;

  // aqua master
  RxInt boosterSwitch = 0.obs;
  RxInt recirculorSwitch = 0.obs;
  RxInt makeupSwitch = 0.obs;
  RxInt coolerSwitch = 0.obs;
  RxInt comfortSwitch = 0.obs;
  RxInt boilerSwitch = 0.obs;
  RxBool modeAqm = false.obs;
  RxBool tmatch = false.obs;
  RxString comfortAndCoolerTemp = "0".obs;
  RxString boilerTemp = "0".obs;
  var boosterState = "--".obs;
  var makeupState = "--".obs;
  var recirculorState = "--".obs;
  var coolerState = "--".obs;
  var boilerState = "--".obs;
  var comfortState = "--".obs;
  var coolerSp = "0".obs;
  var boilerSp = "0".obs;
  var comfortSp = "0".obs;
  var offset1Aqua = "".obs;
  var offset2Aqua = "".obs;
  var sensorAquaTemp1 = "0.0".obs;
  var sensorAquaTemp2 = "0.0".obs;
  // var selectionAqua1 = "".obs;
  // var selectionAqua2 = "".obs;
  // var addressAqua1 = "".obs;
  // var addressAqua2 = "".obs;

  //RCM
  var rcSucTemp = 0.0.obs;
  var rcSuper = 0.0.obs;
  var rcSucpre = 0.obs;
  var rccompr = 0.obs;
  var rcSucTempSp = 0.obs;
  var rcSucpreSp = 0.obs;
  var rcSuperSp = 0.obs;
  RxBool rcsystemSwitch = false.obs;
  var rcpressureRange = "0".obs;
  var rcpressureUnit = false.obs;
  var rcpressureType = "".obs;

//rcmsetting
  RxDouble rcintegralsp = 0.0.obs;
  RxDouble rcpropostionalsp = 0.0.obs;
  RxDouble rcderivativesp = 0.0.obs;
  RxInt rcminValue = 20.obs;
  RxInt rcmaxValue = 80.obs;
  RxInt rcexvCurrentStep = 0.obs;
  RxInt rcexvMaxStep = 0.obs;
  RxInt rcexvStepDelay = 0.obs;

//csm
  RxInt systemStatusCsm = 0.obs;
  RxDouble tempcsm = 0.0.obs;
  RxInt tempcsmSp = 0.obs;
  RxString humcsm = "0".obs;
  RxString hrscsm = "00:00".obs;
  RxInt csmValue = 0.obs;
  RxBool csmSw = false.obs;
  RxInt csmResetValues = 0.obs;
  RxBool csmResetload = false.obs;
  // alert master 01
  final psiTobar1 = true.obs;
  final ftoC1 = true.obs;
  final Map<String, double> lastNotifiedValueAM1 = {};
  final Map<String, DateTime> lastNotificationTime = {};
  final Map<String, String> lastNotifiedSwitchState = {};
  final Map<String, DateTime> lastSwitchNotificationTime = {};
  RxBool isHigh = false.obs;
  String? prevLowPresw;
  String? prevHighPresw;
  String? prevOilPres;
  RxBool isLoad = false.obs;
  RxString highpresw = 'LOW'.obs;
  RxString lowpresw = 'LOW'.obs;
  RxString oilpressuream1 = 'HIGH'.obs;
  RxBool isDarkMode = false.obs;
  var tempsp1 = 0.obs;
  var tempsp2 = 0.obs;
  var tempsp3 = 0.obs;
  var gastype = (-1).obs;
  var tempsp4 = 0.obs;
  var tempsplow = 0.obs;

  var tempsphigh = 0.obs;
  var pressuresp1 = 0.obs;
  var pressuresp2 = 0.obs;
  var pressuresp3 = 0.obs;
  var dischargelinetemp = 0.0.obs;
  var suctionlinetemp = 0.0.obs;
  var supplylinetemp = 0.0.obs;
  var returnlinetemp = 0.0.obs;
  var dischargelinetempF = 0.0.obs;
  var suctionlinetempF = 0.0.obs;
  var supplylinetempF = 0.0.obs;
  var returnlinetempF = 0.0.obs;
  var dischargepressure = 0.0.obs;
  var suctionpressure = 0.0.obs;
  //am1 /temp_config
  var selection1Am1 = "".obs;
  var selection2Am1 = "".obs;
  var selection3Am1 = "".obs;
  var selection4Am1 = "".obs;
  var address1Am1 = "".obs;
  var address2Am1 = "".obs;
  var address3Am1 = "".obs;
  var address4Am1 = "".obs;
  var sensorAm1Temp1 = "0.0".obs;
  var sensorAm1Temp2 = "0.0".obs;
  var sensorAm1Temp3 = "0.0".obs;
  var sensorAm1Temp4 = "0.0".obs;
  var offsett1Am1 = "".obs;
  var offsett2Am1 = "".obs;
  var offsett3Am1 = "".obs;
  var offsett4Am1 = "".obs;
  var dischargepressureF = 0.0.obs;
  var suctionpressureF = 0.0.obs;
  var comprsw = 0.obs;
  var toggle = false.obs;
  var ip = "".obs;
  TextEditingController passwordController = TextEditingController();
  MqttServerClient? client;
  Timer? lockTimer;
  Map<String, Timer> connectionTimers = {};
  RxMap<String, bool> deviceConnections = <String, bool>{}.obs;
  void updateConnectionStatus(String topic, bool status) {
    deviceConnections[topic] = status;
    deviceConnections.refresh();
  }

  @override
  void onInit() {
    log("MQTT Controller Initialized");
    super.onInit();
    fetchClientId();
    setupMqttClient();
    _connectMqtt();
    loadLastNotifiedValues();
    loadLastNotifiedValuesAm1();
    loadLastNotifiedValuesRcm();
    loadLastNotifiedValuesDx();
    loadLastNotifiedValuesDxm();
    loadLastNotifiedValuesDm();
    loadLastNotifiedValuesCsm();
    loadLastNotifiedValuesTel();
    loadLastNotifiedValuesSp1();
    loadLastNotifiedValuesDm1();
  }

  void fetchClientId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      clientId.value = user.uid;
    }
  }

  void updatetopicSSIDvalue(String value) {
    topicSSIDvalue.value = value;
    update();
  }

  void setupMqttClient() {
    client =
        MqttServerClient.withPort(mqttBroker.value, clientId.value, port.value);
    client?.secure = true;
    client?.keepAlivePeriod = 60;
    client?.setProtocolV311();
    client?.logging(on: false);
    client?.onDisconnected = onDisconnected;
    client?.onConnected = _onConnected;
    client?.onSubscribed = _onSubscribed;
  }

  bool shouldReconnect = true;
  void onDisconnected() {
    log("Disconnected from MQTT broker.");
    isConnected.value = false;

    if (shouldReconnect) {
      log("Reconnecting...");
      Future.delayed(Duration(seconds: 5), _connectMqtt);
    } else {
      log("Reconnection prevented (user logged out)");
    }
  }

  void _onConnected() {
    log('Connected to MQTT broker.');
    isConnected.value = true;
    String topic = '/KRC/#';
    client?.subscribe(topic, MqttQos.atLeastOnce);
    client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? messages) {
      if (messages == null || messages.isEmpty) return;
      isNotiInteracting.value = true;
      final MqttPublishMessage msg = messages[0].payload as MqttPublishMessage;
      final String topic = messages[0].topic;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);
      receivedMessage.value = payload;
      String topiid = topic.split('/').last;
      log("Device detected: $topiid");
      updateConnectionStatus(topiid, true);
      connectionTimers[topiid]?.cancel();
      connectionTimers[topiid] = Timer(Duration(seconds: 15), () {
        log("Device timed out: $topiid");
        updateConnectionStatus(topiid, false);
      });
      if (isUserInteracting.value == false) {
        if (topicSSIDvalue.value.isNotEmpty) {
          if (topic == "/KRC/${topicSSIDvalue.value}") {
            if (topicSSIDvalue.value.startsWith("ZMB-")) {
              //ZMB
              log("ZMB device detected: $topiid");
              _handleMessage(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("CM1-")) {
              //CM1
              log("CM1 device detected: $topiid");
              onMessageReceived(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("WTC-")) {
              //WTC
              log("WTC device detected: $topiid");
              onMessageWTCReceived(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("DM1-")) {
              //DM
              log("DM device detected: $topiid");
              onMessageDMReceived(payload, topic);
              _handleMessageNotificationDm1(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("SM1-")) {
              //DM
              log("DM device detected: $topiid");
              onMessageDMReceived(payload, topic);
              _handleMessageNotificationDm1(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("GHS-")) {
              //GHS
              log("GHS device detected: $topiid");
              onMessageGHSReceived(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("AQM-")) {
              //AQUA
              log("AQM device detected: $topiid");
              aquaReceive(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("CSM-")) {
              //CSM
              log("CSM device detected: $topiid");
              _handleMessageCsm(payload, topic);
              _handleMessageNotificationCsm(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("SP1-")) {
              //SP1
              log("SP1 device detected: $topiid");
              sp1MessageReceived(payload, topic);
              _handleMessageNotificationSp1(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("RCM-")) {
              //RCM
              log("SP1 device detected: $topiid");
              rcmMessageReceived(payload, topic);
              _handleMessageNotificationRcm(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("AM1-A")) {
              //AM1
              log("AM1 device detected: $topiid");
              _handleMessageAm1(payload, topic);
              _handleMessageNotificationAm1(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("AM1-4")) {
              //AM1-444
              log("AM1 device detected: $topiid");
              _handleMessageAm1(payload, topic);
              _handleMessageNotificationAm1(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("AM1-7")) {
              //AM1-7
              log("AM1 device detected: $topiid");
              _handleMessageAm1(payload, topic);
              _handleMessageNotificationAm1(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("AM2-A")) {
              //AM2
              log("AM2 device detected: $topiid");
              _handleMessageAm2(payload, topic);
              _handleMessageNotification(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("AM2-4")) {
              //AM2
              log("AM2 device detected: $topiid");
              _handleMessageAm2(payload, topic);
              _handleMessageNotification(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("DX-")) {
              //DX_400
              log("DX device detected: $topiid");
              _handleMessageDx(payload, topic);
              _handleMessageNotificationDx(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("DXM-")) {
              //DX(Mini)
              log("DX-MINI device detected: $topiid");
              _handleMessageDxMini(payload, topic);
              _handleMessageNotificationDxm(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("RMS-")) {
              //RMS
              log("RMS device detected: $topiid");
              rmsMessageReceived(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("TEL-")) {
              //TEL
              log("TEL device detected: $topiid");
              telMessageReceived(payload, topic);
              _handleHumidityMessageNotification(payload, topic);
            } else if (topicSSIDvalue.value.startsWith("DM-")) {
              //Dx-Master
              log("DX device detected: $topiid");
              _handleMessageDM(payload, topic);
              _handleMessageNotificationDm(payload, topic);
            }
          } else if (topic ==
              "/KRC/${topicSSIDvalue.value}/pressure_configRCM") {
            _handleMessagePressureRCM(payload, topic);
            log("AM2 pressure config detected /sensor_config");
          } //RCM
          else if (topic == "/KRC/${topicSSIDvalue.value}/temperature_config") {
            _handleMessageSensor(payload, topic);
            log("AM2 sensor config detected /temperature_config");
          } else if (topic == "/KRC/${topicSSIDvalue.value}/pressure_config") {
            _handleMessagePressure(payload, topic);
            log("AM2 pressure config detected /sensor_config");
          } //Am2
          else if (topic ==
              "/KRC/${topicSSIDvalue.value}/pressure_config_AM2-444") {
            _handleMessagePressure(payload, topic);
            log("AM2-444 pressure config detected /sensor_config");
          } else if (topic ==
              "/KRC/${topicSSIDvalue.value}/temperature_config_AM2-444") {
            _handleMessageSensorAm2444(payload, topic);
            log("AM2-444 pressure config detected /sensor_config");
          } //Am2-444
          else if (topic ==
              "/KRC/${topicSSIDvalue.value}/temperature_config_AM1") {
            _handleMessageAm1Sensor(payload, topic);
            log("AM1 pressure config detected /sensor_config");
          } else if (topic ==
              "/KRC/${topicSSIDvalue.value}/temperature_config_AM1-444") {
            _handleMessageAm1444Sensor(payload, topic);
            log("AM1 pressure config detected /sensor_config");
          } else if (topic ==
              "/KRC/${topicSSIDvalue.value}/temperature_config_AM1-7") {
            _handleMessageAm1444Sensor(payload, topic);
            log("AM1 pressure config detected /sensor_config");
          } else if (topic ==
              "/KRC/${topicSSIDvalue.value}/temperature_config_AQM") {
            _handleMessageAQMSensor(payload, topic);
            log("AQM pressure config detected /sensor_config");
          } else if (topic ==
              "/KRC/${topicSSIDvalue.value}/temperature_config_DX") {
            //DX
            _dxhandleMessageSensor(payload, topic);
            log("DX sensor config detected /temperature_config");
          } else if (topic ==
              "/KRC/${topicSSIDvalue.value}/temperature_config_DXM") {
            //DXM
            _dxmhandleMessageSensor(payload, topic);
            log("DXM sensor config detected /temperature_config");
          } else if (topic ==
              "/KRC/${topicSSIDvalue.value}/pressure_config_DX") {
            _dxhandleMessagePressure(payload, topic);

            log("DX pressure config detected /sensor_config");
          } // DX
          else if (topic == "/KRC/${topicSSIDvalue.value}/CircuitA") {
            _handleMessageDMCircuitA(payload, topic);
            log("DX pressure config detected /sensor_config");
          } //DM-Master
          else if (topic == "/KRC/${topicSSIDvalue.value}/CircuitB") {
            _handleMessageDMCircuitB(payload, topic);
            log("DX pressure config detected /sensor_config");
          } else if (topic == "/KRC/${topicSSIDvalue.value}/SensorA") {
            _handleMessageDMSensorA(payload, topic);
            log("DX pressure config detected /sensor_config");
          } //DM-Master
          else if (topic == "/KRC/${topicSSIDvalue.value}/SensorB") {
            _handleMessageDMSensorB(payload, topic);
            log("DX pressure config detected /sensor_config");
          } else if (topic == "/KRC/${topicSSIDvalue.value}/Input-Output") {
            _handleMessageIO(payload, topic);
            log("DX pressure config detected /sensor_config");
          } //DM-Master
        } else {
          //for IP & MAC update
          if (topiid.startsWith("ZMB-")) {
            _handleMessageDevice(payload, topic); // zm
          } else if (topiid.startsWith("CM1-")) {
            handleMessageCm2Device(payload, topic); // cm
          } else if (topiid.startsWith("WTC-")) {
            handleMessageWTCDevice(payload, topic); // WTC
          } else if (topiid.startsWith("AM1-A")) {
            handleMessageAm1Device(payload, topic); // am1
          } else if (topiid.startsWith("AM2-A")) {
            _handleMessageAm2Device(payload, topic); // am2
          } else if (topiid.startsWith("GHS-")) {
            _handleMessageAm2Device(payload, topic); // am2
          } else if (topiid.startsWith("DX-")) {
            _handleMessageDxDevice(payload, topic); // DX-400
          } else if (topiid.startsWith("AQM-")) {
            handleMessageAquaDevice(payload, topic); // aqua
          } else if (topiid.startsWith("RMS-")) {
            handleMessageRmsDevice(payload, topic); // DX
          } else if (topiid.startsWith("TEL-")) {
            handleMessageTelDevice(payload, topic); // TEL
          } else if (topiid.startsWith("DM1-")) {
            handleMessageDMDevice(payload, topic); // DM1
          } else if (topiid.startsWith("SP1-")) {
            handleMessageDMDevice(payload, topic); // SP1
          } else if (topiid.startsWith("DXM-")) {
            handleMessageDMDevice(payload, topic); // DX(Mini)
          } else if (topiid.startsWith("DM-")) {
            handleMessageDMDevice(payload, topic); // DX(Master)
          } else if (topiid.startsWith("AM1-4")) {
            handleMessageDMDevice(payload, topic); // Am1-444
          } else if (topiid.startsWith("AM1-7")) {
            handleMessageDMDevice(payload, topic); // Am1-7
          } else if (topiid.startsWith("AM2-4")) {
            handleMessageDMDevice(payload, topic); // Am2-444
          } else if (topiid.startsWith("RCM")) {
            handleMessageDMDevice(payload, topic); //RCM
          } else if (topiid.startsWith("CSM")) {
            handleMessageDMDevice(payload, topic); //CSM
          } else if (topiid.startsWith("RMS")) {
            handleMessageDMDevice(payload, topic); //RMS
          }
        }
      }
    });
  }

  void _onSubscribed(String topic) {
    log('Subscribed to topic: $topic');
  }

  Future<void> _connectMqtt() async {
    if (client == null) {
      log("MQTT Client is not initialized!");
      return;
    }

    try {
      log("Loading certificates...");
      final context = SecurityContext.defaultContext;

      final rootCa = await rootBundle.load('asset/root-CA.crt');
      final deviceCert = await rootBundle.load('asset/Temperature.cert.pem');
      final privateKey = await rootBundle.load('asset/Temperature.private.key');

      context.setClientAuthoritiesBytes(rootCa.buffer.asUint8List());
      context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
      context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

      client!.securityContext = context;
      client!.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientId.value)
          .startClean();

      log("Connecting to MQTT broker...");
      await client!.connect();

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        log('Connected to MQTT broker.');
        isConnected.value = true;
      } else {
        log('Connection failed: ${client!.connectionStatus!.state}');
        client!.disconnect();
      }
    } catch (e) {
      log('MQTT client exception: $e');
      client?.disconnect();
    }
  }

  void updateTemperature(String topic, double temp) {
    deviceTemperatures[topic] = temp;
    deviceTemperatures.refresh();
  }

  void switchtoggle(String topicid, String dampertsw) {
    deviceSwitchStates[topicid] = dampertsw;
    deviceSwitchStates.refresh();
  }

  void _handleMessageDevice(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String dmptemp = jsonMap['dmptemp']?.toString() ?? "0";
      String dampertsw = jsonMap['dampertsw']?.toString() ?? "0";
      String ip = jsonMap['ip_address']?.toString() ?? "";
      String mac = jsonMap['mac_address']?.toString() ?? "";
      String topicid = topics.split('/').last;
      log('Updating SharedPreferences with IP and MAC...');
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
      updateTemperature(topicid, double.parse(dmptemp));
      switchtoggle(topicid, dampertsw);
      log("Updated Switch List: $deviceSwitchStates");
      log("Updated connection List: $deviceConnections");
      log("Updated Temperature List: $deviceTemperatures");
      log("State temp: $dmptemp");
      log("State ip: $ip");
      log("State switch: $dampertsw");
    } catch (e) {
      log("Error parsing message: ZM $e");
    }
  }

//AM2 Notification
  void _handleMessageNotification(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String topicid = topics.split('/').last;
      temp1sethigh.value =
          int.tryParse(jsonMap['value21']?.toString() ?? '') ?? 0;
      temp1setlow.value =
          int.tryParse(jsonMap['value10']?.toString() ?? '') ?? 0;
      temp1.value = double.tryParse(jsonMap['value1']?.toString() ?? '') ?? 0;
      temp2.value = double.tryParse(jsonMap['value2']?.toString() ?? '') ?? 0;
      temp2setlow.value =
          int.tryParse(jsonMap['value11']?.toString() ?? '') ?? 0;
      temp2sethigh.value =
          int.tryParse(jsonMap['value22']?.toString() ?? '') ?? 0;
      temp3.value = double.tryParse(jsonMap['value3']?.toString() ?? '') ?? 0;
      temp3sethigh.value =
          int.tryParse(jsonMap['value23']?.toString() ?? '') ?? 0;
      temp4.value = double.tryParse(jsonMap['value4']?.toString() ?? '') ?? 0;
      temp4setlow.value =
          int.tryParse(jsonMap['value13']?.toString() ?? '') ?? 0;

      psig1.value = double.tryParse(jsonMap['value5']?.toString() ?? '') ?? 0.0;
      psig1sethigh.value =
          int.tryParse(jsonMap['value25']?.toString() ?? '') ?? 0;

      psig2.value = double.tryParse(jsonMap['value6']?.toString() ?? '') ?? 0.0;
      psig2setlow.value =
          int.tryParse(jsonMap['value15']?.toString() ?? '') ?? 0;
      psig3.value = double.tryParse(jsonMap['value7']?.toString() ?? '') ?? 0.0;
      psig3sethigh.value =
          int.tryParse(jsonMap['value27']?.toString() ?? '') ?? 0;

      amp2.value = int.tryParse(jsonMap['value8']?.toString() ?? '') ?? 0;
      amp1low.value = int.tryParse(jsonMap['value17']?.toString() ?? '') ?? 0;

      if (isNotiInteracting == true &&
          (comp1status.value == 1 ||
              comp1status.value == 3 ||
              comp1status.value == 4 ||
              comp1status.value == 5 ||
              comp1status.value == 6 ||
              comp1status.value == 7 ||
              comp1status.value == 8 ||
              comp1status.value == 9 ||
              comp1status.value == 10 ||
              comp1status.value == 11 ||
              comp1status.value == 12 ||
              comp1status.value == 13 ||
              comp1status.value == 14 ||
              comp1status.value == 15)) {
        // Temperature
        checkAndNotify(
          deviceid: topicid,
          status: "High",
          id: "temp1",
          condition: temp1setlow.value <= temp1.value,
          title: 'Return',
          value: temp1.value.toDouble(),
          type: "temperature",
        );

        checkAndNotify(
          deviceid: topicid,
          status: "Low",
          id: "temp3",
          condition: temp3.value <= temp3sethigh.value,
          title: 'Suction',
          value: temp3.value.toDouble(),
          type: "temperature",
        );

        checkAndNotify(
          deviceid: topicid,
          status: "High",
          id: "temp4",
          condition: temp4.value >= temp4setlow.value,
          title: 'Discharge',
          value: temp4.value.toDouble(),
          type: "temperature",
        );

        //Pressure
        if (isSuctionPressureVisible.value == true) {
          checkAndNotify(
            deviceid: topicid,
            status: "Low",
            id: "psig1",
            condition: psig1.value <= psig1sethigh.value,
            title: 'Suction',
            value: psig1.value.toDouble(),
            type: "pressure",
          );
        }
        if (isDischargePressureVisible.value == true) {
          checkAndNotify(
            deviceid: topicid,
            status: "High",
            id: "psig2",
            condition: psig2.value >= psig2setlow.value,
            title: 'Discharge',
            value: psig2.value.toDouble(),
            type: "pressure",
          );
        }
        if (isOilPressureVisible.value == true) {
          checkAndNotify(
            deviceid: topicid,
            status: "Low",
            id: "psig3",
            condition: psig3.value <= psig3sethigh.value,
            title: 'Oil',
            value: psig3.value.toDouble(),
            type: "pressure",
          );
        }
        //Ampere
        if (isAmpVisible.value == true) {
          checkAndNotify(
            deviceid: topicid,
            status: "High",
            id: "amp2",
            condition: amp1low.value <= amp2.value,
            title: 'Phase 1',
            value: amp2.value.toDouble(),
            type: "ampere",
          );
        }
        if (isAmpVisible.value == true) {
          checkAndNotify(
            deviceid: topicid,
            status: "High",
            id: "amp1",
            condition: amp1low.value <= amp1.value,
            title: 'Phase 3',
            value: amp1.value.toDouble(),
            type: "ampere",
          );
        }
        if (isAmpVisible.value == true) {
          checkAndNotify(
            deviceid: topicid,
            status: "High",
            id: "amp3",
            condition: amp1low.value <= amp3.value,
            title: 'Phase 2',
            value: amp3.value.toDouble(),
            type: "ampere",
          );
        }
        // Switch
        if (isSuctionSwitchVisible.value == true) {
          checkAndNotify(
            value: "(System Tripped)",
            deviceid: topicid,
            status: "Low",
            id: "sw_suction",
            condition: lowpreswam2.value == 'LOW',
            title: 'Suction Pressure -',
            type: "switch",
          );
        }
        if (isDischargeSwitchVisible.value == true) {
          checkAndNotify(
            value: "(System Tripped)",
            deviceid: topicid,
            status: "High",
            id: "sw_discharge",
            condition: highpreswam2.value == 'HIGH',
            title: 'Discharge Pressure -',
            type: "switch",
          );
        }
        if (isSwitchBoxVisible.value == true) {
          checkAndNotify(
            value: "(System Tripped)",
            deviceid: topicid,
            status: "Low",
            id: "sw_oil",
            condition: oilpressureswam2.value == "LOW",
            title: 'Oil Pressure -',
            type: "switch",
          );
        }
        checkAndNotify(
          value: "",
          deviceid: topicid,
          status: "",
          id: "compressor",
          condition: comp1status.value == 15,
          title: 'Compressor Fail To Run',
          type: "switch",
        );
      }
    } catch (e) {
      log("Error parsing message: AM2 $e");
    }
  }

  Map<String, Map<String, double>> lastNotifiedValuePerDevice = {};
  void checkAndNotify({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastNotifiedValuePerDevice.containsKey(deviceid)) {
      lastNotifiedValuePerDevice[deviceid] = {};
    }

    final deviceMap = lastNotifiedValuePerDevice[deviceid]!;

    if (condition) {
      if (type == "switch") {
        if (!deviceMap.containsKey(id)) {
          deviceMap[id] = 1;
          _notificationController.showSwitchAlertNotification(
              deviceid, title, status, value);
          saveLastNotifiedValues();
        }
      } else {
        double? parsed = double.tryParse(value.toString());
        if (parsed == null) return;
        double roundedValue = parsed.floorToDouble();
        double? lastValue = deviceMap[id];
        if (lastValue == null || lastValue != roundedValue) {
          deviceMap[id] = roundedValue;

          if (type == "temperature") {
            _notificationController.showTemperatureAlertNotification(
                deviceid, title, parsed, status);
          } else if (type == "pressure") {
            _notificationController.showPressureAlertNotification(
                deviceid, title, parsed, status);
          } else if (type == "ampere") {
            _notificationController.showAmpereAlertNotification(
                deviceid, title, parsed, status);
          }

          saveLastNotifiedValues(); // Save updated state
        }
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValues(); // Save updated state
    }
  }

  void clearLastNotifiedValues(String deviceId) {
    lastNotifiedValuePerDevice.remove(deviceId);
    saveLastNotifiedValues();
  }

  void clearLastNotifiedValuesAm1(String deviceId) {
    lastNotifiedValuePerDeviceAm1.remove(deviceId);
    saveLastNotifiedValuesAm1();
  }

//sp1
  void clearLastNotifiedValuesSp1(String deviceId) {
    lastNotifiedValuePerDeviceSp1.remove(deviceId);
    saveLastNotifiedValuesSp1();
  }

//Csm
  void clearLastNotifiedValuesCsm(String deviceId) {
    lastNotifiedValuePerDeviceCsm.remove(deviceId);
    saveLastNotifiedValuesCsm();
  }

//RCM
  void clearLastNotifiedValuesRcm(String deviceId) {
    lastNotifiedValuePerDeviceRcm.remove(deviceId);
    saveLastNotifiedValuesRcm();
  }

  void clearLastNotifiedValuesDm1(String deviceId) {
    lastNotifiedValuePerDeviceDm1.remove(deviceId);
    saveLastNotifiedValuesDm1();
  }

  void clearLastNotifiedValuesTel(String deviceId) {
    lastHumidityAlertSent.remove(deviceId);
    saveLastNotifiedValuesTel();
  }

  /// ✅ Save to SharedPreferences
  Future<void> saveLastNotifiedValues() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastNotifiedValuePerDevice.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_values', encoded);
  }

  /// ✅ Load from SharedPreferences
  Future<void> loadLastNotifiedValues() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_values');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastNotifiedValuePerDevice = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

  /// ✅ Save to SharedPreferences
  Future<void> saveLastNotifiedValuesCsm() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastNotifiedValuePerDeviceCsm.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_values', encoded);
  }

  /// ✅ Load from SharedPreferences
  Future<void> loadLastNotifiedValuesCsm() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_values');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastNotifiedValuePerDeviceCsm = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

  // ✅ Save to SharedPreferences
  Future<void> saveLastNotifiedValuesAm1() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastNotifiedValuePerDeviceAm1.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_valuesAm1', encoded);
  }

  /// ✅ Load from SharedPreferences
  Future<void> loadLastNotifiedValuesAm1() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_valuesAm1');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastNotifiedValuePerDeviceAm1 = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

  //RCm
  Future<void> saveLastNotifiedValuesRcm() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastNotifiedValuePerDeviceRcm.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_valuesAm1', encoded);
  }

  /// ✅ Load from SharedPreferences
  Future<void> loadLastNotifiedValuesRcm() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_valuesAm1');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastNotifiedValuePerDeviceRcm = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

  /// ✅ save from SharedPreferences Sp1
  Future<void> saveLastNotifiedValuesSp1() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastNotifiedValuePerDeviceSp1.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_valuesSp1', encoded);
  }

  /// ✅ Load from SharedPreferences Sp1
  Future<void> loadLastNotifiedValuesSp1() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_valuesSp1');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastNotifiedValuePerDeviceSp1 = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

  Future<void> saveLastNotifiedValuesDm1() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastNotifiedValuePerDeviceDm1.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_valuesDm1', encoded);
  }

  /// ✅ Load from SharedPreferences Sp1
  Future<void> loadLastNotifiedValuesDm1() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_valuesDm1');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastNotifiedValuePerDeviceDm1 = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

  void _handleMessageNotificationAm1(String message, String topics) async {
    try {
      String topicid = topics.split('/').last;
      Map<String, dynamic> jsonMap = jsonDecode(message);
      tempsp2.value = int.tryParse(jsonMap['tempsp2']?.toString() ?? '') ?? 0;
      tempsp1.value = int.tryParse(jsonMap['tempsp1']?.toString() ?? '') ?? 0;
      tempsphigh.value =
          int.tryParse(jsonMap['tempsphigh']?.toString() ?? '') ?? 0;
      tempsplow.value =
          int.tryParse(jsonMap['tempsplow']?.toString() ?? '') ?? 0;
      pressuresp1.value = int.tryParse(jsonMap["pressuresp1"].toString()) ?? 0;
      pressuresp2.value = int.tryParse(jsonMap["pressuresp2"].toString()) ?? 0;
      suctionlinetemp.value =
          double.tryParse(jsonMap["suctionlinetemp"].toString()) ?? 0.0;
      dischargelinetemp.value =
          double.tryParse(jsonMap["dischargelinetemp"].toString()) ?? 0.0;
      returnlinetemp.value =
          double.tryParse(jsonMap["returnlinetemp"].toString()) ?? 0.0;
      lowpresw.value = jsonMap['lowpresw'] == 'LOW' ? 'LOW' : 'HIGH';
      highpresw.value = jsonMap['highpresw'] == 'LOW' ? 'LOW' : 'HIGH';
      oilpressuream1.value = jsonMap['oilpressure'] == 'LOW' ? 'LOW' : 'HIGH';
      if (isNotiInteracting == true &&
          (comprsw.value == 1 ||
              comprsw.value == 3 ||
              comprsw.value == 4 ||
              comprsw.value == 5 ||
              comprsw.value == 6 ||
              comprsw.value == 7 ||
              comprsw.value == 8 ||
              comprsw.value == 9 ||
              comprsw.value == 12 ||
              comprsw.value == 13 ||
              comprsw.value == 14 ||
              comprsw.value == 15 ||
              comprsw.value == 16 ||
              comprsw.value == 17)) {
        // Temperature
        checkAndNotifyAm1(
          deviceid: topicid,
          status: "High",
          id: "temp1",
          condition: tempsphigh.value <= returnlinetemp.value,
          title: 'Return',
          value: returnlinetemp.value.toDouble(),
          type: "temperature",
        );

        checkAndNotifyAm1(
          deviceid: topicid,
          status: "Low",
          id: "temp3",
          condition: suctionlinetemp.value <= tempsp2.value,
          title: 'Suction',
          value: suctionlinetemp.value.toDouble(),
          type: "temperature",
        );

        checkAndNotifyAm1(
          deviceid: topicid,
          status: "High",
          id: "temp4",
          condition: dischargelinetemp.value >= tempsp1.value,
          title: 'Discharge',
          value: dischargelinetemp.value.toDouble(),
          type: "temperature",
        );

        // Switch
        if (showSuctionPressure.value == true) {
          checkAndNotifyAm1(
            value: "(Tripped)",
            deviceid: topicid,
            status: "Low",
            id: "sw_suction",
            condition: lowpresw.value == 'LOW',
            title: 'Suction Pressure -',
            type: "switch",
          );
        }
        if (showDischargePressure.value == true) {
          checkAndNotifyAm1(
            value: "(Tripped)",
            deviceid: topicid,
            status: "High",
            id: "sw_discharge",
            condition: highpresw.value == 'HIGH',
            title: 'Discharge Pressure -',
            type: "switch",
          );
        }
        if (showOilPressure.value == true) {
          checkAndNotifyAm1(
            value: "(Tripped)",
            deviceid: topicid,
            status: "Low",
            id: "sw_oil",
            condition: oilpressuream1.value == "LOW",
            title: 'Oil Pressure -',
            type: "switch",
          );
        }
        checkAndNotifyAm1(
          value: "",
          deviceid: topicid,
          status: "",
          id: "compressor",
          condition: comprsw.value == 15,
          title: 'Compressor Fail To Run',
          type: "switch",
        );
      }
    } catch (e) {
      log("AM1 notification Error parsing message: $e");
    }
  }

  Map<String, Map<String, double>> lastNotifiedValuePerDeviceAm1 = {};
  void checkAndNotifyAm1({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastNotifiedValuePerDeviceAm1.containsKey(deviceid)) {
      lastNotifiedValuePerDeviceAm1[deviceid] = {};
    }

    final deviceMap = lastNotifiedValuePerDeviceAm1[deviceid]!;

    if (condition) {
      if (type == "switch") {
        if (!deviceMap.containsKey(id)) {
          deviceMap[id] = 1; // dummy value
          _notificationControlleraM1.showSwitchAlertNotification(
              deviceid, title, status, value);
          saveLastNotifiedValuesAm1(); // Save updated state
        }
      } else {
        double? parsed = double.tryParse(value.toString());
        if (parsed == null) return;

        double roundedValue = parsed.floorToDouble();
        double? lastValue = deviceMap[id];

        if (lastValue == null || lastValue != roundedValue) {
          deviceMap[id] = roundedValue;

          if (type == "temperature") {
            _notificationControlleraM1.showTemperatureAlertNotification(
                deviceid, title, parsed, status);
          } else if (type == "pressure") {
            _notificationControlleraM1.showPressureAlertNotification(
                deviceid, title, parsed, status);
          }

          saveLastNotifiedValuesAm1(); // Save updated state
        }
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValuesAm1(); // Save updated state
    }
  }

  //csm
  void _handleMessageCsm(String message, String topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String systemStatus = jsonMap['systemStatus'].toString();
      tempcsm.value = double.tryParse(jsonMap['temperature'].toString()) ?? 0.0;
      tempcsmSp.value = int.tryParse(jsonMap['tempSp'].toString()) ?? 0;
      csmValue.value = int.tryParse(jsonMap['val'].toString()) ?? 0;
      humcsm.value = jsonMap['humidity'].toString();
      hrscsm.value = jsonMap['hrs'].toString();
      int systemSwitch = int.tryParse(jsonMap['sw'].toString()) ?? 0;
      csmResetValues.value =
          int.tryParse(jsonMap['resetValues']?.toString() ?? '') ?? 0;
      csmSw.value = systemSwitch == 1;
      systemStatusCsm.value = int.tryParse(systemStatus) ?? 0;
    } catch (e) {
      log("CSM Error parsing message: $e");
    }
  }

  void updatePowerCsm(bool status) {
    csmSw.value = status;
    buildJsonPayloadCsm();
    update();
  }

  void updateSetpointcsm(double value) {
    tempcsmSp.value = value.toInt();
    buildJsonPayloadCsm();
    update();
  }

  void buildJsonPayloadCsm() {
    Map<String, dynamic> jsonPayload = {
      "resetValues": csmResetValues.value,
      "tempSp": tempcsmSp.value.toString(),
      "sw": csmSw.value ? 1 : 0,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void _handleMessageNotificationCsm(String message, String topics) async {
    try {
      String topicid = topics.split('/').last;
      Map<String, dynamic> jsonMap = jsonDecode(message);
      tempcsm.value = double.tryParse(jsonMap['temperature'].toString()) ?? 0.0;
      tempcsmSp.value = int.tryParse(jsonMap['tempSp'].toString()) ?? 0;
      csmValue.value = int.tryParse(jsonMap['val'].toString()) ?? 0;
      int systemSwitch = int.tryParse(jsonMap['sw'].toString()) ?? 0;
      csmSw.value = systemSwitch == 1;
      if (isNotiInteracting == true && csmSw.value == true) {
        // Temperature
        if (csmValue.value == 0) {
          checkAndNotifyCsm(
            deviceid: topicid,
            id: "temp1",
            condition: tempcsm.value >= 38.0,
            title: 'Turned On',
            value: tempcsm.value.toDouble(),
            type: "temperature",
            status: "",
          );
        }
        if (csmValue.value == 1) {
          checkAndNotifyCsm(
            deviceid: topicid,
            id: "temp1",
            condition: tempcsm.value <= 34.0,
            title: 'Turned Off',
            value: tempcsm.value.toDouble(),
            type: "temperature",
            status: "",
          );
        }
      }
    } catch (e) {
      log("CSM notification Error parsing message: $e");
    }
  }

  Map<String, Map<String, double>> lastNotifiedValuePerDeviceCsm = {};
  void checkAndNotifyCsm({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastNotifiedValuePerDeviceCsm.containsKey(deviceid)) {
      lastNotifiedValuePerDeviceCsm[deviceid] = {};
    }

    final deviceMap = lastNotifiedValuePerDeviceCsm[deviceid]!;

    if (condition) {
      double? parsed = double.tryParse(value.toString());
      if (parsed == null) return;

      double roundedValue = parsed.floorToDouble();
      double? lastValue = deviceMap[id];

      if (lastValue == null || lastValue != roundedValue) {
        deviceMap[id] = roundedValue;

        if (type == "temperature") {
          _notificationControllerCsm.showTemperatureAlertNotification(
              deviceid, title, parsed, status);
        }

        saveLastNotifiedValuesAm1(); // Save updated state
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValuesAm1(); // Save updated state
    }
  }

//Zone master
  void _handleMessage(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String seasonsw = jsonMap['seasonsw'];
      String dmptemp = jsonMap['dmptemp'];
      String dmptempsp = jsonMap['dmptempsp'];
      String dampertsw = jsonMap['dampertsw'];
      String supcfm = jsonMap['supcfm'];
      String ip = jsonMap['ip_address'].toString();
      String mac = jsonMap['mac_address'].toString();
      String timeschen = jsonMap['timeschen'];
      String timesch = jsonMap['timesch'];
      String dampstate = jsonMap['dampstate'];
      isOn.value = dampertsw == "1";
      //handle
      isSummer.value = seasonsw == "1";
      temperature.value = double.parse(dmptemp);
      lastDamperValue.value = int.parse(dmptempsp);
      currentValue.value = double.parse(supcfm);
      flapstate.value = dampstate;
      toggleValue.value = timeschen == "1";

      //
      String topicid = topics.split('/').last;
      log("Updated connection List: $deviceConnections");
      //
      if (timesch.isNotEmpty &&
          timesch.contains('hoursch=') &&
          timesch.contains('daysch=')) {
        List<String> parts = timesch.split('|');
        String hoursPart = parts
            .firstWhere((e) => e.startsWith('hoursch='),
                orElse: () => 'hoursch=')
            .replaceFirst('hoursch=', '');
        String daysPart = parts
            .firstWhere((e) => e.startsWith('daysch='), orElse: () => 'daysch=')
            .replaceFirst('daysch=', '');

        List<String> hourStrings = hoursPart
            .split(',')
            .where((e) => e.trim().isNotEmpty && hours.contains(e))
            .toList();
        List<String> dayIndexes =
            daysPart.split(',').where((e) => e.trim().isNotEmpty).toList();

        selectedHour.assignAll(hourStrings);
        selectedDays.assignAll(dayIndexes.map((i) => days[int.parse(i)]));
      } else {
        selectedHour.clear();
        selectedDays.clear();
      }
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
      log('Updating SharedPreferences with IP and MAC...');
      log("State updated: $jsonMap");
    } catch (e) {
      log("Error parsing message: ZMB $e");
    }
  }

  Map<String, dynamic> _buildJsonPayload() {
    return {
      "comment": "from Application",
      "seasonsw": isSummer.value ? 1 : 0,
      "dmptempsp": lastDamperValue.value,
      "dampertsw": isOn.value,
      "supcfm": "$currentValue",
      "dampstate": isOn.value,
      "timesch": result.value,
      "timeschen": toggleValue.value ? 1 : 0,
    };
  }

  String createjson() {
    final String jsonPayload = jsonEncode(_buildJsonPayload());
    log("JSON Payload: $jsonPayload");
    return jsonPayload;
  }

  void publishMessage(String message) {
    String topic = "/test/$topicSSIDvalue/1";
    if (client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: false,
        );
        log('Message published to $topic: $message');
      } catch (e) {
        log('Failed to publish message: $e');
      }
    }
  }

  void publishMessage1(String message, topicssid) {
    String topic = "/test/$topicssid/1";
    log(topic.toString());
    if (client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: false,
        );
        log('Message published to $topic: $message');
      } catch (e) {
        log('Failed to publish message: $e');
      }
    }
  }

  var pass = true.obs;
  Future<void> showPasswordDialog(BuildContext context, bool permission) async {
    TextEditingController passwordController = TextEditingController();
    await Get.dialog(
      Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
          ),
          child: AlertDialog(
            backgroundColor: ThemeColor().dialogBox,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Enter Password".tr,
              style: const TextStyle(color: Colors.black),
            ),
            content: Obx(
              () => TextField(
                controller: passwordController,
                obscureText: pass.value,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      pass.value = !pass.value;
                    },
                    icon: Icon(
                      pass.value ? Icons.visibility_off : Icons.remove_red_eye,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Enter Password".tr,
                  hintStyle: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  pass.value = true;
                },
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () async {
                  if (passwordController.text == correctPassword.value) {
                    isPasswordCorrect.value = true;
                    startLockTimer();
                    Get.back();
                    await Get.bottomSheet(
                      CustomBottomSheet1(
                        permission: permission,
                      ),
                      backgroundColor: Get.isDarkMode
                          ? const Color(0xFF121212)
                          : ThemeColor().mode1Sec,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                    );

                    ever(isPasswordCorrect, (value) {
                      if (value == false && (Get.isBottomSheetOpen ?? false)) {
                        Get.back();
                      }
                    });
                    cancelLockTimer();
                  } else {
                    Get.snackbar('Error', 'Wrong password',
                        backgroundColor: Colors.red);
                  }
                },
                child:
                    const Text("Submit", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cancelLockTimer() {
    lockTimer?.cancel();
  }

  void startLockTimer() {
    lockTimer?.cancel();
    lockTimer = Timer(Duration(seconds: 10), () {
      isPasswordCorrect.value = false;
      Get.snackbar("cfm_protection".tr, "slider_locked".tr,
          backgroundColor: ThemeColor().snackBarColor);
    });
  }

  void changeDamperValue(double value) {
    lastDamperValue.value = value.toInt();
    lastDamperValue.refresh();
  }

  Future<void> selectSeason(var summer, var permission) async {
    isSeasonLoading.value = true;
    isSummer.value = summer;
    receivedMessage.value = "Season Selected: ${summer ? 'Summer' : 'Winter'}";
    String message = "Season Selected: ${summer ? 'Winter' : 'Summer'}";
    if (permission) {
      message = createjson();
      publishMessage(message);
    } else {
      buildJsonPayloadRms();
    }
    await Future.delayed(Duration(seconds: 4));
    isSeasonLoading.value = false;
  }

  void updateTimeSchedule({required void Function() onUpdated}) {
    String hourString = selectedHour
        .where((hour) => hours.contains(hour))
        .map((hour) => hours.indexOf(hour))
        .where((index) => index >= 0)
        .join(',');

    String dayString = selectedDays
        .map((day) => days.indexOf(day))
        .where((index) => index >= 0)
        .join(',');

    String resultText = "hoursch=$hourString|daysch=$dayString";
    result.value = resultText;
    onUpdated();
  }

  Color get scheduleTickColor {
    bool hasDay = selectedDays.isNotEmpty;
    bool hasHour = selectedHour.isNotEmpty;

    if (hasDay && hasHour) return Color(0xFF24C48E);
    if (hasDay || hasHour) return Colors.orangeAccent;
    return Colors.red;
  }

  Timer? publishTimer;

  RxString selectedView = 'day'.obs;
  void showDayAndHourPicker(BuildContext context, String heading,
      {required void Function() onUpdated}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final media = MediaQuery.of(context);
        final isPortrait = media.orientation == Orientation.portrait;
        final baseSize = isPortrait ? media.size.height : media.size.width;
        final shortestSide = media.size.shortestSide;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: baseSize * 0.65,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            heading.tr,
                            style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Obx(() => Switch(
                              activeColor: Color(0xFF24C48E),
                              inactiveThumbColor: Colors.red,
                              value: toggleValue.value,
                              onChanged: (val) {
                                isUserInteracting.value = true;
                                toggleValue.value = val;
                                publishTimer?.cancel();
                                publishTimer = Timer(Duration(seconds: 1), () {
                                  log("Toggle value changed: $val");
                                  onUpdated();
                                  publishTimer =
                                      Timer(Duration(seconds: 1), () {
                                    log("start");
                                    isUserInteracting.value = false;
                                  });
                                });
                              },
                            )),
                      ],
                    ),
                    Obx(() {
                      if (!toggleValue.value) {
                        return Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.2),
                          child: Center(
                            child: Text(
                              "enable_button_to_set_schedule".tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Divider(),
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(30),
                            fillColor: Color(0xFF24C48E),
                            selectedColor: Colors.white,
                            color: Colors.grey,
                            isSelected: [
                              selectedView.value == 'day',
                              selectedView.value == 'hour'
                            ],
                            onPressed: (index) {
                              selectedView.value = index == 0 ? 'day' : 'hour';
                            },
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  "days".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  "hours".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (selectedView.value == 'day') ...[
                            SizedBox(
                              height: isPortrait
                                  ? baseSize * 0.41
                                  : shortestSide * 0.41,
                              child: ListView.builder(
                                itemCount: days.length,
                                itemBuilder: (context, index) {
                                  return Obx(() {
                                    bool isSelected =
                                        selectedDays.contains(days[index]);
                                    return CheckboxListTile(
                                      checkColor: Colors.white,
                                      fillColor: WidgetStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return Color(0xFF24C48E);
                                        }
                                        return Colors.grey;
                                      }),
                                      title: Text(
                                        days[index],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isSelected
                                              ? Color(0xFF24C48E)
                                              : Colors.grey,
                                        ),
                                      ),
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        if (value == true) {
                                          selectedDays.add(days[index]);
                                        } else {
                                          selectedDays.remove(days[index]);
                                        }
                                        updateTimeSchedule(onUpdated: () {
                                          isUserInteracting.value = true;

                                          publishTimer?.cancel();
                                          publishTimer =
                                              Timer(Duration(seconds: 1), () {
                                            log("select days:");
                                            onUpdated();
                                            publishTimer =
                                                Timer(Duration(seconds: 1), () {
                                              log("start");
                                              isUserInteracting.value = false;
                                            });
                                          });
                                        });
                                      },
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                          if (selectedView.value == 'hour') ...[
                            Container(
                              width: 290,
                              height: 290,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.isDarkMode
                                    ? ThemeColor().mode2Sec
                                    : ThemeColor().mode1Sec,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer Circle
                                  for (int i = 0; i < 12; i++)
                                    _buildHourCircle(
                                      i,
                                      120,
                                      selectedHour,
                                      () => updateTimeSchedule(onUpdated: () {
                                        isUserInteracting.value = true;

                                        publishTimer?.cancel();
                                        publishTimer =
                                            Timer(Duration(seconds: 1), () {
                                          log("select outter date:");
                                          onUpdated();
                                          publishTimer =
                                              Timer(Duration(seconds: 1), () {
                                            log("start");
                                            isUserInteracting.value = false;
                                          });
                                        });
                                      }),
                                    ),

                                  // Inner Circle
                                  for (int i = 12; i < 24; i++)
                                    _buildHourCircle(
                                      i,
                                      80,
                                      selectedHour,
                                      () => updateTimeSchedule(onUpdated: () {
                                        isUserInteracting.value = true;

                                        publishTimer?.cancel();
                                        publishTimer =
                                            Timer(Duration(seconds: 1), () {
                                          log("select inner date:");
                                          onUpdated();
                                          publishTimer =
                                              Timer(Duration(seconds: 1), () {
                                            log("start");
                                            isUserInteracting.value = false;
                                          });
                                        });
                                      }),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ],
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHourCircle(int index, double radius, RxList<String> selectedHour,
      Function updateTimeSchedule) {
    final double angle = ((index * 30) - 90) * (3.1415926535897932 / 180);
    final double dx = radius * cos(angle);
    final double dy = radius * sin(angle);

    String hourText = index.toString();
    bool isSelected = selectedHour.contains(hourText);
    return Positioned(
      left: 150 + dx - 20,
      top: 150 + dy - 20,
      child: GestureDetector(
        onTap: () {
          if (isSelected) {
            selectedHour.remove(hourText);
          } else {
            selectedHour.add(hourText);
          }
          updateTimeSchedule();
        },
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? Color(0xFF24C48E)
                : Get.isDarkMode
                    ? ThemeColor().mode2Sec
                    : Colors.white,
            border: Border.all(
              color: isSelected ? Color(0xFF24C48E) : Colors.grey,
            ),
          ),
          child: Text(
            hourText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : Get.isDarkMode
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

//RCM HandleMessage
  void rcmMessageReceived(String messages, topic) {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String temp1 = data['rcSucTemp'].toString();
      String temp2 = data['rcSuper'].toString();
      String pre1 = data['rcSucpre'].toString();
      String pre1sp = data['rcSucpreSp'].toString();
      String temp1SetPoint = data['rcSucTempSp'].toString();
      String temp2SetPoint = data['rcSuperSp'].toString();
      String min = data['rcmin'].toString();
      String max = data['rcmax'].toString();
      String current = data['rccurrent'].toString();
      String delay = data['rcstepdelay'].toString();
      String step = data['rcmaxStep'].toString();
      String rcprop = data['rcprop'].toString();
      String rcder = data['rcder'].toString();
      String rcint = data['rcint'].toString();
      int systemSwitch = data['rcswitch'] ?? 0;
      rccompr.value = data['rccompr'];
      rcsystemSwitch.value = systemSwitch == 1;
      rcpropostionalsp.value = double.tryParse(rcprop) ?? 0.0;
      rcderivativesp.value = double.tryParse(rcder) ?? 0.0;
      rcintegralsp.value = double.tryParse(rcint) ?? 0.0;
      rcSucTemp.value = double.tryParse(temp1) ?? 0.0;
      rcSuper.value = double.tryParse(temp2) ?? 0.0;
      rcSucpre.value = int.tryParse(pre1) ?? 0;
      rcSucpreSp.value = int.tryParse(pre1sp) ?? 0;
      rcSucTempSp.value = int.tryParse(temp1SetPoint) ?? 0;
      rcSuperSp.value = int.tryParse(temp2SetPoint) ?? 0;
      rcexvMaxStep.value = int.tryParse(step) ?? 0;
      rcexvCurrentStep.value = int.tryParse(current) ?? 0;
      rcmaxValue.value = int.tryParse(max) ?? 0;
      rcminValue.value = int.tryParse(min) ?? 0;
      rcexvStepDelay.value = int.tryParse(delay) ?? 0;
    } catch (e) {
      log("❌ Error processing MQTT message: $e");
    }
  }

  void _handleMessageNotificationRcm(String message, String topics) async {
    try {
      String topicid = topics.split('/').last;
      Map<String, dynamic> data = jsonDecode(message);
      String temp1 = data['rcSucTemp'].toString();
      String pre1 = data['rcSucpre'].toString();
      String pre1sp = data['rcSucpreSp'].toString();
      String temp1SetPoint = data['rcSucTempSp'].toString();
      rcSucTemp.value = double.tryParse(temp1) ?? 0.0;
      rcSucpre.value = int.tryParse(pre1) ?? 0;
      rcSucpreSp.value = int.tryParse(pre1sp) ?? 0;
      rcSucTempSp.value = int.tryParse(temp1SetPoint) ?? 0;
      if (isNotiInteracting == true &&
          (rccompr.value == 0 || rccompr.value == 2 || rccompr.value == 3)) {
        // Temperature
        checkAndNotifyRcm(
          deviceid: topicid,
          status: "Low",
          id: "rcSucTemp",
          condition: rcSucTemp.value <= rcSucTempSp.value,
          title: 'Suction Temperature',
          value: rcSucTemp.value.toDouble(),
          type: "temperature",
        );
        //Pressure
        checkAndNotifyRcm(
          deviceid: topicid,
          status: "Low",
          id: "rcSucpre",
          condition: rcSucpre.value <= rcSucpreSp.value,
          title: 'Suction Pressure',
          value: rcSucpre.value.toDouble(),
          type: "pressure",
        );
      }
    } catch (e) {
      log("RCM notification Error parsing message: $e");
    }
  }

  Map<String, Map<String, double>> lastNotifiedValuePerDeviceRcm = {};
  void checkAndNotifyRcm({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastNotifiedValuePerDeviceRcm.containsKey(deviceid)) {
      lastNotifiedValuePerDeviceRcm[deviceid] = {};
    }

    final deviceMap = lastNotifiedValuePerDeviceRcm[deviceid]!;

    if (condition) {
      double? parsed = double.tryParse(value.toString());
      if (parsed == null) return;
      double roundedValue = parsed.floorToDouble();
      double? lastValue = deviceMap[id];
      log("Temperature check → Device: $deviceid, Sensor: $id, Prev: $lastValue, New: $roundedValue");
      if (lastValue == null || lastValue != roundedValue) {
        deviceMap[id] = roundedValue;
        if (type == "temperature") {
          _notificationControllerRcm.showTemperatureAlertNotification(
              deviceid, title, parsed, status);
        } else if (type == "pressure") {
          _notificationControllerRcm.showPressureAlertNotification(
              deviceid, title, parsed, status);
        }
        saveLastNotifiedValuesRcm();
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValuesRcm();
    }
  }

  void _handleMessagePressureRCM(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String pressuretype = jsonMap['pressure_type']?.toString() ?? "0";
      String pressurerange = jsonMap['pressure_range']?.toString() ?? "0";
      int pressureunit = jsonMap['pressure_unit'] ?? false;
      rcpressureType.value = pressuretype;
      rcpressureRange.value = pressurerange;
      rcpressureUnit.value = pressureunit == 1;
    } catch (e) {
      log("Error parsing message: /pressureselection $e");
    }
  }

  void rcupdatePower(bool status) {
    rcsystemSwitch.value = status;
    buildJsonPayloadRcm();
    update();
  }

  void updateRange(RangeValues values) {
    rcminValue.value = values.start.round();
    rcmaxValue.value = values.end.round();
  }

  void buildJsonPayloadPressureRCM() {
    Map<String, dynamic> jsonPayload = {
      "pressure_type": rcpressureType.value,
      "pressure_range": rcpressureRange.value,
      "pressure_unit": rcpressureUnit.value ? 1 : 0,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString);
  }

  void buildJsonPayloadRcm() {
    Map<String, dynamic> jsonPayload = {
      "rcswitch": rcsystemSwitch.value ? 1 : 0,
      "rcprop": rcpropostionalsp.value.toString(),
      "rcder": rcderivativesp.value.toString(),
      "rcint": rcintegralsp.value.toString(),
      "rcmax": rcmaxValue.value.toString(),
      "rcmin": rcminValue.value.toString(),
      "rcSucpreSp": rcSucpreSp.value.toString(),
      "rcstepdelay": rcexvStepDelay.value.toString(),
      "rcmaxStep": rcexvMaxStep.value.toString(),
      "rcSucTempSp": rcSucTempSp.value.toString(),
      "rcSuperSp": rcSuperSp.value.toString(),
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void suctemSpRCM(double value) {
    rcSucTempSp.value = value.toInt();
    buildJsonPayloadRcm();
    update();
  }

  void supertemSpRCM(double value) {
    rcSuperSp.value = value.toInt();
    buildJsonPayloadRcm();
    update();
  }

  void sucpreSpRCM(double value) {
    rcSucpreSp.value = value.toInt();
    buildJsonPayloadRcm();
    update();
  }

//SP1
  void sp1MessageReceived(String messages, topic) {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String temp = data['temp'].toString();
      String tempSetPoint = data['tempSetPoint'].toString();
      int systemSwitch = data['switch'] ?? 0;
      sp1comprsw.value = data['comprsw'];
      systemSwitchsp.value = systemSwitch == 1;
      tempsp.value = double.tryParse(temp) ?? 0.0;
      tempSetPointsp.value = int.tryParse(tempSetPoint) ?? 0;
    } catch (e) {
      log("❌ Error processing MQTT message: $e");
    }
  }

  void _handleMessageNotificationSp1(String message, String topics) async {
    try {
      Map<String, dynamic> data = jsonDecode(message);
      String topicid = topics.split('/').last;
      String temp = data['temp'].toString();
      int systemSwitch = data['switch'] ?? 0;
      String tempSetPoint = data['tempSetPoint'].toString();
      tempsp.value = double.tryParse(temp) ?? 0.0;
      tempSetPointsp.value = int.tryParse(tempSetPoint) ?? 0;
      systemSwitchsp.value = systemSwitch == 1;
      if (isNotiInteracting == true && systemSwitchsp.value == true) {
        // Temperature Alert
        checkAndNotifySp1(
          value: tempsp.value,
          deviceid: topicid,
          status: "High",
          id: "temp_alert",
          condition: tempsp.value >= tempSetPointsp.value,
          title: 'Temperature Alert',
          type: "temperature",
        );
      }
    } catch (e) {
      log("Error parsing Temperature message: $e");
    }
  }

  Map<String, Map<String, double>> lastNotifiedValuePerDeviceSp1 = {};

  void checkAndNotifySp1({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastNotifiedValuePerDeviceSp1.containsKey(deviceid)) {
      lastNotifiedValuePerDeviceSp1[deviceid] = {};
    }

    final deviceMap = lastNotifiedValuePerDeviceSp1[deviceid]!;

    if (condition) {
      double? parsed = double.tryParse(value.toString());
      if (parsed == null) return;
      double roundedValue = parsed.floorToDouble();
      double? lastValue = deviceMap[id];
      log("Temperature check → Device: $deviceid, Sensor: $id, Prev: $lastValue, New: $roundedValue");
      if (lastValue == null || lastValue != roundedValue) {
        deviceMap[id] = roundedValue;
        if (type == "temperature") {
          _notificationControllerSp1.showTemperatureAlertNotification(
            deviceid,
            title,
            value,
            status,
          );
        }
        saveLastNotifiedValuesSp1();
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValuesSp1();
    }
  }

  void buildJsonPayloadsp() {
    Map<String, dynamic> jsonPayload = {
      "tempSetPoint": tempSetPointsp.value.toString(),
      "switch": systemSwitchsp.value ? 1 : 0,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void updateSetpointsp(double value) {
    tempSetPointsp.value = value.toInt();
    buildJsonPayloadsp();
    update();
  }

  void updatePowerSp(bool status) {
    systemSwitchsp.value = status;
    buildJsonPayloadsp();
    update();
  }

//Dx-master HandleMessage
//Main Page & Navbar
  RxDouble dmSupply = 0.0.obs;
  RxInt dmSetpoint = 0.obs;
  RxDouble dmReturn = 0.0.obs;
  RxInt dmStatusA = 0.obs;
  RxInt dmStatusB = 0.obs;
  RxBool dmStatusShow = false.obs;
  RxInt dmPower = 0.obs;
  RxInt dmResetValues = 0.obs;
  RxInt vfdMinFrequencyA = 0.obs;
  RxInt vfdMaxFrequencyA = 0.obs;
  RxInt vfdDelayA = 0.obs;
  RxInt vfdMinFrequencyB = 0.obs;
  RxInt vfdMaxFrequencyB = 0.obs;
  RxInt vfdDelayB = 0.obs;
  RxInt dmStartA = 0.obs;
  RxDouble dmStepSizeA = 0.0.obs;
  RxInt dmStartB = 0.obs;
  RxDouble dmStepSizeB = 0.0.obs;
  RxInt oilswA = 0.obs;
  RxInt oilpsiA = 0.obs;
  RxInt suctionA = 0.obs;
  RxInt dischargeA = 0.obs;
  RxInt oilswB = 0.obs;
  RxInt oilpsiB = 0.obs;
  RxInt suctionB = 0.obs;
  RxInt dischargeB = 0.obs;
  RxInt starA = 0.obs;
  RxInt deltaA = 0.obs;
  RxInt fan1A = 0.obs;
  RxInt fan3A = 0.obs;
  RxInt starB = 0.obs;
  RxInt deltaB = 0.obs;
  RxInt fan1B = 0.obs;
  RxInt fan3B = 0.obs;
//circuit A
  RxInt exvCurrentStepA = 0.obs;
  RxInt exvMaxStepA = 0.obs;
  RxInt exvStepDelayA = 0.obs;
  RxDouble dmSuctionTempA = 0.0.obs;
  RxInt dmSuctionPressureA = 0.obs;
  //Azam dm

  RxInt dmOilPressureA = 0.obs;
  RxInt dmOilPressureB = 0.obs;

  //setpoints Circuit A&B
  RxInt oilPressurespA = 0.obs;
  RxInt oilPressurespB = 0.obs;

  //Azam dm
  RxDouble dmdischargeTempA = 0.0.obs;
  RxInt dmdischargePressureA = 0.obs;
  RxDouble dmSubCoolingA = 0.0.obs;
  RxDouble dmSprayA = 0.0.obs;
  RxInt dmExvA = 0.obs;
  RxDouble dmShtA = 0.0.obs;
  RxInt dmRunHoursA = 0.obs;

  //9753
  var selection1A = "".obs;
  var selection2A = "".obs;
  var selection3A = "".obs;
  var selection4A = "".obs;
  var address1A = "".obs;
  var address2A = "".obs;
  var address3A = "".obs;
  var address4A = "".obs;
  var sensorTemp1A = "0.0".obs;
  var sensorTemp2A = "0.0".obs;
  var sensorTemp3A = "0.0".obs;
  var sensorTemp4A = "0.0".obs;
  var offsett1A = "".obs;
  var offsett2A = "".obs;
  var offsett3A = "".obs;
  var offsett4A = "".obs;
  RxBool sucPressureUnitA = false.obs;
  RxString sucPressureTypeA = "".obs;
  RxString ampereA = "".obs;
  RxString sucPressureRangeA = "0".obs;
  RxInt suctionOffsetA = 0.obs;
  RxBool disPressureUnitA = false.obs;
  RxString disPressureTypeA = "".obs;
  RxString disPressureRangeA = "0".obs;
  RxInt dischargeOffsetA = 0.obs;

  RxBool oilPressureUnitA = false.obs;
  RxString oilPressureTypeA = "".obs;
  RxString oilPressureRangeA = "0".obs;
  RxInt oilOffsetA = 0.obs;

  //setpoints Circuit A

  RxInt sucPressurespA = 0.obs;
  RxInt amperespA = 0.obs;
  RxInt disPressurespA = 0.obs;
  RxInt sucTempspA = 0.obs;
  RxInt disTempspA = 0.obs;
  RxInt lowSprayTempspA = 0.obs;

  //EXV Settings
  RxInt superHeatspA = 2.obs;
  RxInt selectedEXVModeA = 0.obs;
  RxDouble integralspA = 0.0.obs;
  RxDouble propostionalspA = 0.0.obs;
  RxDouble derivativespA = 0.0.obs;
  RxInt minValueA = 20.obs;
  RxInt maxValueA = 80.obs;
  RxInt gasA = 0.obs;

  //EXV SettingB
  RxString ampereB = "".obs;
  RxInt amperespB = 0.obs;
  RxInt superHeatspB = 2.obs;
  RxDouble integralspB = 0.0.obs;
  RxDouble propostionalspB = 0.0.obs;
  RxDouble derivativespB = 0.0.obs;
  RxInt selectedEXVModeB = 0.obs;
  RxInt minValueB = 20.obs;
  RxInt maxValueB = 80.obs;
  RxInt gasB = 0.obs;
  RxBool sucPressureUnitB = false.obs;
  RxString sucPressureTypeB = "".obs;
  RxString sucPressureRangeB = "0".obs;
  RxInt suctionOffsetB = 0.obs;
  RxBool disPressureUnitB = false.obs;
  RxString disPressureTypeB = "".obs;
  RxString disPressureRangeB = "0".obs;
  RxInt dischargeOffsetB = 0.obs;

  RxBool oilPressureUnitB = false.obs;
  RxString oilPressureTypeB = "".obs;
  RxString oilPressureRangeB = "0".obs;
  RxInt oilOffsetB = 0.obs;
  RxDouble dmSuctionTempB = 0.0.obs;
  RxInt dmSuctionPressureB = 0.obs;
  RxDouble dmdischargeTempB = 0.0.obs;
  RxInt dmdischargePressureB = 0.obs;
  RxInt exvCurrentStepB = 0.obs;
  RxInt exvMaxStepB = 0.obs;
  RxInt exvStepDelayB = 0.obs;
  RxInt sucPressurespB = 0.obs;
  RxInt disPressurespB = 0.obs;
  RxInt sucTempspB = 0.obs;
  RxInt disTempspB = 0.obs;
  RxInt lowSprayTempspB = 0.obs;
  RxDouble dmSubCoolingB = 0.0.obs;
  RxDouble dmSprayB = 0.0.obs;
  RxInt dmExvB = 0.obs;
  RxDouble dmShtB = 0.0.obs;
  RxInt dmRunHoursB = 0.obs;
  RxInt selectedModeA = 0.obs;
  RxInt selectedModeB = 0.obs;
  RxBool circuitAenable = false.obs;
  RxBool circuitALoading = false.obs;
  RxBool tempSelectionSwitch = false.obs;
  RxBool leadlagASwitch = false.obs;
  RxBool leadlagBSwitch = false.obs;
  RxBool fan1and2ASwitch = false.obs;
  RxBool fan3and4ASwitch = false.obs;
  RxBool fan5and6ASwitch = false.obs;
  RxBool fan1and2BSwitch = false.obs;
  RxBool fan3and4BSwitch = false.obs;
  RxBool fan5and6BSwitch = false.obs;
  RxInt fan1and2HighALimit = 80.obs;
  RxInt fan3and4HighALimit = 80.obs;
  RxInt fan5and6HighALimit = 80.obs;
  RxInt fan1and2HighBLimit = 80.obs;
  RxInt fan3and4HighBLimit = 80.obs;
  RxInt fan5and6HighBLimit = 80.obs;
  RxInt fan1and2LowALimit = 60.obs;
  RxInt fan3and4LowALimit = 60.obs;
  RxInt fan5and6LowALimit = 60.obs;
  RxInt fan1and2LowBLimit = 60.obs;
  RxInt fan3and4LowBLimit = 60.obs;
  RxInt fan5and6LowBLimit = 60.obs;
  RxBool circuitBenable = false.obs;
  RxBool circuitBLoading = false.obs;
  var selection1B = "".obs;
  var selection2B = "".obs;
  var selection3B = "".obs;
  var selection4B = "".obs;
  var selection5 = "".obs; //m1
  var selection6 = "".obs; //m2
  var address1B = "".obs;
  var address2B = "".obs;
  var address3B = "".obs;
  var address4B = "".obs;
  var address5 = "".obs; //m1
  var address6 = "".obs; //m2
  var sensorTemp1B = "0.0".obs;
  var sensorTemp2B = "0.0".obs;
  var sensorTemp3B = "0.0".obs;
  var sensorTemp4B = "0.0".obs;
  var sensorTemp5 = "0.0".obs; //m1
  var sensorTemp6 = "0.0".obs; //m2
  var offsett1B = "".obs;
  var offsett2B = "".obs;
  var offsett3B = "".obs;
  var offsett4B = "".obs;
  var offsett5 = "".obs; //m1
  var offsett6 = "".obs; //m2
  final flipController =
      GestureFlipCardController(); // Add this to your MqttController
  void toggleCircuitView() {
    dmStatusShow.value = !dmStatusShow.value;
    flipController.flipcard();
  }

  void updateRangeB(RangeValues values) {
    minValueB.value = values.start.round();
    maxValueB.value = values.end.round();
  }

  void updateRangeA(RangeValues values) {
    minValueA.value = values.start.round();
    maxValueA.value = values.end.round();
  }

  Future<void> enableCircuitA(bool value) async {
    circuitALoading.value = true;
    circuitAenable.value = value;
    buildJsonPayloadCiruitA();
    await Future.delayed(Duration(seconds: 2));
    circuitALoading.value = false;
  }

//gas Selection DX-Master
  void gasstypeDm(String sp, bool permgas) {
    if (permgas) {
      gasA.value = int.tryParse(sp) ?? 0;
      buildJsonPayloadCiruitA();
    } else {
      gasB.value = int.tryParse(sp) ?? 0;
      buildJsonPayloadCiruitB();
    }
  }

  Future<void> enableCircuitB(bool value) async {
    circuitBLoading.value = true;
    circuitBenable.value = value;
    buildJsonPayloadCiruitB();
    await Future.delayed(Duration(seconds: 2));
    circuitBLoading.value = false;
  }

  void updateSetpointMain(double value) {
    dmSetpoint.value = value.toInt();
    update();
  }

  RxBool tempselectionSwLoading = false.obs;
  Future<void> tempSelectSwitch(bool value) async {
    tempselectionSwLoading.value = true;
    tempSelectionSwitch.value = value;
    buildJsonPayloadDXMaster();
    await Future.delayed(Duration(seconds: 2));
    tempselectionSwLoading.value = false;
  }

  RxBool leadLagASwLoading = false.obs;
  Future<void> leadLagA(bool value) async {
    leadLagASwLoading.value = true;
    leadlagASwitch.value = value;
    buildJsonPayloadCiruitA();
    await Future.delayed(Duration(seconds: 2));
    leadLagASwLoading.value = false;
  }

  RxBool leadLagBSwLoading = false.obs;
  Future<void> leadLagB(bool value) async {
    leadLagBSwLoading.value = true;
    leadlagBSwitch.value = value;
    buildJsonPayloadCiruitB();
    await Future.delayed(Duration(seconds: 4));
    leadLagBSwLoading.value = false;
  }

  RxBool fan1and2BSwLoading = false.obs;
  Future<void> fan1and2B(bool value) async {
    fan1and2BSwLoading.value = true;
    fan1and2BSwitch.value = value;
    buildJsonPayloadCiruitB();
    await Future.delayed(Duration(seconds: 4));
    fan1and2BSwLoading.value = false;
  }

  RxBool fan3and4BSwLoading = false.obs;
  Future<void> fan3and4B(bool value) async {
    fan3and4BSwLoading.value = true;
    fan3and4BSwitch.value = value;
    buildJsonPayloadCiruitB();
    await Future.delayed(Duration(seconds: 4));
    fan3and4BSwLoading.value = false;
  }

  RxBool fan5and6BSwLoading = false.obs;
  Future<void> fan5and6B(bool value) async {
    fan5and6BSwLoading.value = true;
    fan5and6BSwitch.value = value;
    buildJsonPayloadCiruitB();
    await Future.delayed(Duration(seconds: 4));
    fan5and6BSwLoading.value = false;
  }

  RxBool fan1and2ASwLoading = false.obs;
  Future<void> fan1and2A(bool value) async {
    fan1and2ASwLoading.value = true;
    fan1and2ASwitch.value = value;
    buildJsonPayloadCiruitA();
    await Future.delayed(Duration(seconds: 4));
    fan1and2ASwLoading.value = false;
  }

  RxBool fan3and4ASwLoading = false.obs;
  Future<void> fan3and4A(bool value) async {
    fan3and4ASwLoading.value = true;
    fan3and4ASwitch.value = value;
    buildJsonPayloadCiruitA();
    await Future.delayed(Duration(seconds: 4));
    fan3and4ASwLoading.value = false;
  }

  RxBool fan5and6ASwLoading = false.obs;
  Future<void> fan5and6A(bool value) async {
    fan5and6ASwLoading.value = true;
    fan5and6ASwitch.value = value;
    buildJsonPayloadCiruitA();
    await Future.delayed(Duration(seconds: 4));
    fan5and6ASwLoading.value = false;
  }

  void updateFanSetpointB(double value) {
    buildJsonPayloadCiruitB();
    update();
  }

  void updateFanSetpointA(double value) {
    buildJsonPayloadCiruitA();
    update();
  }

  RxBool exvPosiSwLoadingA = false.obs;
  RxBool exvPosiSwLoadingB = false.obs;
  RxBool exvPosiSwA = false.obs;
  RxBool exvPosiSwB = false.obs;
  Future<void> exvPosiSwitchA(bool value) async {
    exvPosiSwLoadingA.value = true;
    exvPosiSwA.value = value;
    buildJsonPayloadCiruitA();
    await Future.delayed(Duration(seconds: 2));
    exvPosiSwLoadingA.value = false;
  }

  Future<void> exvPosiSwitchB(bool value) async {
    exvPosiSwLoadingB.value = true;
    exvPosiSwB.value = value;
    buildJsonPayloadCiruitB();
    await Future.delayed(Duration(seconds: 2));
    exvPosiSwLoadingB.value = false;
  }

  //Circuit A
  void _handleMessageDMCircuitA(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      int leadlagA = jsonMap['leadlagA'] ?? 0;
      int enableA = jsonMap['enableA'] ?? 0;
      int fansw12A = jsonMap['fan1EA'] ?? 0;
      int fansw34A = jsonMap['fan3EA'] ?? 0;
      int fansw56A = jsonMap['fan5EA'] ?? 0;
      //EXV setting
      exvCurrentStepA.value =
          int.tryParse(jsonMap['exvCstepA']?.toString() ?? '') ?? 0;
      exvMaxStepA.value =
          int.tryParse(jsonMap['exvMstepA']?.toString() ?? '') ?? 0;
      exvStepDelayA.value =
          int.tryParse(jsonMap['exvStepDA']?.toString() ?? '') ?? 0;
      //Setpoints A
      int oilPrespA = int.tryParse(jsonMap['oilPsiSpA'].toString()) ?? 0;
      int suctionPressureA = int.tryParse(jsonMap['SucPsiSpA'].toString()) ?? 0;
      int ampSpA = int.tryParse(jsonMap['ampSpA'].toString()) ?? 0;
      int dischargePressureA =
          int.tryParse(jsonMap['DisPsiSpA'].toString()) ?? 0;
      int suctionTempA = int.tryParse(jsonMap['SucTempSpA'].toString()) ?? 0;
      int dischargeTempA = int.tryParse(jsonMap['DisTempSpA'].toString()) ?? 0;
      int lowSprayA = int.tryParse(jsonMap['SprayTempSpA'].toString()) ?? 0;
      int superheatA = int.tryParse(jsonMap['superheatspA'].toString()) ?? 0;
      //Exv
      double proportionalA =
          double.tryParse(jsonMap['PidPA'].toString()) ?? 0.0;
      double derivativeA = double.tryParse(jsonMap['PidDA'].toString()) ?? 0.0;
      double integralA = double.tryParse(jsonMap['PidIA'].toString()) ?? 0.0;

      //pressure Sensors
      String ampA = jsonMap['ampA']?.toString() ?? "0";
      String sucpressuretype = jsonMap['sucPreTypeA']?.toString() ?? "0";
      String sucpressurerange = jsonMap['sucPreRangeA']?.toString() ?? "0";
      int sucpressureunit = jsonMap['sucPreUnitA'] ?? 0;
      int sucoffsettA =
          int.tryParse(jsonMap['sucoffsetA']?.toString() ?? "0") ?? 0;
      String dispressuretype = jsonMap['disPreTypeA']?.toString() ?? "0";
      String dispressurerange = jsonMap['disPreRangeA']?.toString() ?? "0";
      int dispressureunit = jsonMap['disPreUnitA'] ?? 0;
      int disOffsetA =
          int.tryParse(jsonMap['disoffsetA']?.toString() ?? "0") ?? 0;
      String oilpressuretype = jsonMap['oilPreTypeA']?.toString() ?? "0";
      String oilpressurerange = jsonMap['oilPreRangeA']?.toString() ?? "0";
      int oilpressureunit = jsonMap['oilPreUnitA'] ?? 0;
      int oiloffsetA =
          int.tryParse(jsonMap['oiloffsetA']?.toString() ?? "0") ?? 0;
      int exvPosiA = jsonMap['modeA'] ?? 0;
      //pressure sensor
      dmOilPressureA.value =
          int.tryParse(jsonMap['oilPsiA']?.toString() ?? '') ?? 0;
      dmSuctionTempA.value = double.tryParse(jsonMap['SucTempA']) ?? 0.0;
      dmSuctionPressureA.value =
          int.tryParse(jsonMap['SucPsiA']?.toString() ?? '') ?? 0;
      dmdischargeTempA.value =
          double.tryParse(jsonMap['DisTempA']?.toString() ?? '') ?? 0.0;
      dmdischargePressureA.value =
          int.tryParse(jsonMap['DisPsiA']?.toString() ?? '') ?? 0;
      dmSubCoolingA.value =
          double.tryParse(jsonMap['subCoolingA']?.toString() ?? '') ?? 0.0;
      dmSprayA.value =
          double.tryParse(jsonMap['sprayA']?.toString() ?? '') ?? 0.0;
      dmExvA.value = int.tryParse(jsonMap['exvA']?.toString() ?? '') ?? 0;
      dmShtA.value = double.tryParse(jsonMap['shtA']?.toString() ?? '') ?? 0.0;
      dmRunHoursA.value =
          int.tryParse(jsonMap['runHoursA']?.toString() ?? '') ?? 0;
      dmStartA.value =
          int.tryParse(jsonMap['startdelayA']?.toString() ?? '') ?? 0;
      dmStepSizeA.value =
          double.tryParse(jsonMap['stepsizeA']?.toString() ?? '') ?? 0.0;
      fan1and2HighALimit.value =
          int.tryParse(jsonMap['fan1HA']?.toString() ?? '') ?? 0;
      fan3and4HighALimit.value =
          int.tryParse(jsonMap['fan3HA']?.toString() ?? '') ?? 0;
      fan5and6HighALimit.value =
          int.tryParse(jsonMap['fan5HA']?.toString() ?? '') ?? 0;
      fan1and2LowALimit.value =
          int.tryParse(jsonMap['fan1LA']?.toString() ?? '') ?? 0;
      fan3and4LowALimit.value =
          int.tryParse(jsonMap['fan3LA']?.toString() ?? '') ?? 0;
      fan5and6LowALimit.value =
          int.tryParse(jsonMap['fan5LA']?.toString() ?? '') ?? 0;
      vfdMinFrequencyA.value =
          int.tryParse(jsonMap['vfdMinFreA']?.toString() ?? '') ?? 0;
      vfdMaxFrequencyA.value =
          int.tryParse(jsonMap['vfdMaxFreA']?.toString() ?? '') ?? 0;
      selectedModeA.value =
          int.tryParse(jsonMap['driveA']?.toString() ?? '') ?? 0;
      vfdDelayA.value =
          int.tryParse(jsonMap['vfdDelayA']?.toString() ?? '') ?? 0;
      selectedEXVModeA.value =
          int.tryParse(jsonMap['ExvselA']?.toString() ?? '') ?? 0;
      minValueA.value = int.tryParse(jsonMap['minA']?.toString() ?? '') ?? 0;
      maxValueA.value = int.tryParse(jsonMap['maxA']?.toString() ?? '') ?? 0;
      gasA.value = int.tryParse(jsonMap['gasA']?.toString() ?? '') ?? 0;

//pressure Sensors
      sucPressureUnitA.value = sucpressureunit == 1;
      sucPressureTypeA.value = sucpressuretype;
      ampereA.value = ampA;
      sucPressureRangeA.value = sucpressurerange;
      disPressureUnitA.value = dispressureunit == 1;
      disPressureTypeA.value = dispressuretype;
      disPressureRangeA.value = dispressurerange;
      dischargeOffsetA.value = disOffsetA;
      oilPressureUnitA.value = oilpressureunit == 1;
      oilPressureTypeA.value = oilpressuretype;
      oilPressureRangeA.value = oilpressurerange;
      oilOffsetA.value = oiloffsetA;
      suctionOffsetA.value = sucoffsettA;
      //Setpoints A
      oilPressurespA.value = oilPrespA;
      amperespA.value = ampSpA;
      sucPressurespA.value = suctionPressureA;
      disPressurespA.value = dischargePressureA;
      sucTempspA.value = suctionTempA;
      disTempspA.value = dischargeTempA;
      lowSprayTempspA.value = lowSprayA;
      superHeatspA.value = superheatA;
      integralspA.value = integralA;
      derivativespA.value = derivativeA;
      propostionalspA.value = proportionalA;
      exvPosiSwA.value = exvPosiA == 1;
      leadlagASwitch.value = leadlagA == 1;
      circuitAenable.value = enableA == 1;
      fan1and2ASwitch.value = fansw12A == 1;
      fan3and4ASwitch.value = fansw34A == 1;
      fan5and6ASwitch.value = fansw56A == 1;
      log("Updated connection List: $deviceConnections");
      log("Received MQTT Data:");
    } catch (e) {
      log("Error parsing JSON: DM $e");
    }
  }

  void _handleMessageDMSensorA(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String temp1 = jsonMap['temp1']?.toString() ?? "0";
      String temp2 = jsonMap['temp2']?.toString() ?? "0";
      String temp3 = jsonMap['temp3']?.toString() ?? "0";
      String temp4 = jsonMap['temp4']?.toString() ?? "0";
      String temp5 = jsonMap['temp5']?.toString() ?? "0";
      String temp6 = jsonMap['temp6']?.toString() ?? "0";
      String offset1 = jsonMap['offset1']?.toString() ?? "0";
      String offset2 = jsonMap['offset2']?.toString() ?? "0";
      String offset3 = jsonMap['offset3']?.toString() ?? "0";
      String offset4 = jsonMap['offset4']?.toString() ?? "0";
      String offset5 = jsonMap['offset5']?.toString() ?? "0";
      String offset6 = jsonMap['offset6']?.toString() ?? "0";
      String aaddress1 = jsonMap['address1']?.toString() ?? "0";
      String aaddress2 = jsonMap['address2']?.toString() ?? "0";
      String aaddress3 = jsonMap['address3']?.toString() ?? "0";
      String aaddress4 = jsonMap['address4']?.toString() ?? "0";
      String aaddress5 = jsonMap['address5']?.toString() ?? "0";
      String aaddress6 = jsonMap['address6']?.toString() ?? "0";
      String address1select = jsonMap[aaddress1]?.toString() ?? "0";
      String address2select = jsonMap[aaddress2]?.toString() ?? "0";
      String address3select = jsonMap[aaddress3]?.toString() ?? "0";
      String address4select = jsonMap[aaddress4]?.toString() ?? "0";
      String address5select = jsonMap[aaddress5]?.toString() ?? "0";
      String address6select = jsonMap[aaddress6]?.toString() ?? "0";
      sensorTemp1A.value = temp1;
      sensorTemp2A.value = temp2;
      sensorTemp3A.value = temp3;
      sensorTemp4A.value = temp4;
      sensorTemp5.value = temp5;
      sensorTemp6.value = temp6;
      offsett1A.value = offset1;
      offsett2A.value = offset2;
      offsett3A.value = offset3;
      offsett4A.value = offset4;
      offsett5.value = offset5;
      offsett6.value = offset6;
      selection1A.value = address1select;
      selection2A.value = address2select;
      selection3A.value = address3select;
      selection4A.value = address4select;
      selection5.value = address5select;
      selection6.value = address6select;
      address1A.value = aaddress1;
      address2A.value = aaddress2;
      address3A.value = aaddress3;
      address4A.value = aaddress4;
      address5.value = aaddress5;
      address6.value = aaddress6;
    } catch (e) {
      log("Error parsing message: ZM $e");
    }
  }

//Circuit B
  void _handleMessageDMCircuitB(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      int leadlagB = jsonMap['leadlagB'] ?? 0;
      int enableB = jsonMap['enableB'] ?? 0;
      int fansw12B = jsonMap['fan1EB'] ?? 0;
      int fansw34B = jsonMap['fan3EB'] ?? 0;
      int fansw56B = jsonMap['fan5EB'] ?? 0;
      //EXV setting
      String ampB = jsonMap['ampB']?.toString() ?? "0";
      exvCurrentStepB.value =
          int.tryParse(jsonMap['exvCstepB']?.toString() ?? '') ?? 0;
      exvMaxStepB.value =
          int.tryParse(jsonMap['exvMstepB']?.toString() ?? '') ?? 0;
      exvStepDelayB.value =
          int.tryParse(jsonMap['exvStepDB']?.toString() ?? '') ?? 0;
      String sucpressuretype = jsonMap['sucPreTypeB']?.toString() ?? "0";
      String sucpressurerange = jsonMap['sucPreRangeB']?.toString() ?? "0";
      int sucpressureunit = jsonMap['sucPreUnitB'] ?? false;
      int sucoffsettB =
          int.tryParse(jsonMap['sucoffsetB']?.toString() ?? "0") ?? 0;
      String dispressuretype = jsonMap['disPreTypeB']?.toString() ?? "0";
      String dispressurerange = jsonMap['disPreRangeB']?.toString() ?? "0";
      int dispressureunit = jsonMap['disPreUnitB'] ?? false;
      int disOffsetB =
          int.tryParse(jsonMap['disoffsetB']?.toString() ?? "0") ?? 0;
      String oilpressuretype = jsonMap['oilPreTypeB']?.toString() ?? "0";
      String oilpressurerange = jsonMap['oilPreRangeB']?.toString() ?? "0";
      int oilpressureunit = jsonMap['oilPreUnitB'] ?? false;
      int oiloffsetB =
          int.tryParse(jsonMap['oiloffsetB']?.toString() ?? "0") ?? 0;
      //Exv
      double proportionalB =
          double.tryParse(jsonMap['PidPB'].toString()) ?? 0.0;
      double derivativeB = double.tryParse(jsonMap['PidDB'].toString()) ?? 0.0;
      double integralB = double.tryParse(jsonMap['PidIB'].toString()) ?? 0.0;
      int exvPosiB = jsonMap['modeB'] ?? 0;
      //setpoints B
      int oilPrespB = int.tryParse(jsonMap['oilPsiSpB'].toString()) ?? 0;
      int ampSpB = int.tryParse(jsonMap['ampSpB'].toString()) ?? 0;
      int suctionPressureB = int.tryParse(jsonMap['SucPsiSpB'].toString()) ?? 0;
      int dischargePressureB =
          int.tryParse(jsonMap['DisPsiSpB'].toString()) ?? 0;
      int suctionTempB = int.tryParse(jsonMap['SucTempSpB'].toString()) ?? 0;
      int dischargeTempB = int.tryParse(jsonMap['DisTempSpB'].toString()) ?? 0;
      int lowSprayB = int.tryParse(jsonMap['SprayTempSpB'].toString()) ?? 0;
      int superheatB = int.tryParse(jsonMap['superheatspB'].toString()) ?? 0;
      dmOilPressureB.value =
          int.tryParse(jsonMap['oilPsiB']?.toString() ?? '') ?? 0;
      dmSuctionTempB.value = double.tryParse(jsonMap['SucTempB']) ?? 0.0;
      dmSuctionPressureB.value =
          int.tryParse(jsonMap['SucPsiB']?.toString() ?? '') ?? 0;
      dmdischargeTempB.value =
          double.tryParse(jsonMap['DisTempB']?.toString() ?? '') ?? 0.0;
      dmdischargePressureB.value =
          int.tryParse(jsonMap['DisPsiB']?.toString() ?? '') ?? 0;
      dmSubCoolingB.value =
          double.tryParse(jsonMap['subCoolingB']?.toString() ?? '') ?? 0.0;
      dmSprayB.value =
          double.tryParse(jsonMap['sprayB']?.toString() ?? '') ?? 0.0;
      dmExvB.value = int.tryParse(jsonMap['exvB']?.toString() ?? '') ?? 0;
      dmShtB.value = double.tryParse(jsonMap['shtB']?.toString() ?? '') ?? 0.0;
      dmRunHoursB.value =
          int.tryParse(jsonMap['runHoursB']?.toString() ?? '') ?? 0;
      dmStartB.value =
          int.tryParse(jsonMap['startdelayB']?.toString() ?? '') ?? 0;
      dmStepSizeB.value =
          double.tryParse(jsonMap['stepsizeB']?.toString() ?? '') ?? 0.0;
      fan1and2HighBLimit.value =
          int.tryParse(jsonMap['fan1HB']?.toString() ?? '') ?? 0;
      fan3and4HighBLimit.value =
          int.tryParse(jsonMap['fan3HB']?.toString() ?? '') ?? 0;
      fan5and6HighBLimit.value =
          int.tryParse(jsonMap['fan5HB']?.toString() ?? '') ?? 0;
      fan1and2LowBLimit.value =
          int.tryParse(jsonMap['fan1LB']?.toString() ?? '') ?? 0;
      fan3and4LowBLimit.value =
          int.tryParse(jsonMap['fan3LB']?.toString() ?? '') ?? 0;
      fan5and6LowBLimit.value =
          int.tryParse(jsonMap['fan5LB']?.toString() ?? '') ?? 0;
      vfdMinFrequencyB.value =
          int.tryParse(jsonMap['vfdMinFreB']?.toString() ?? '') ?? 0;
      vfdMaxFrequencyB.value =
          int.tryParse(jsonMap['vfdMaxFreB']?.toString() ?? '') ?? 0;
      selectedModeB.value =
          int.tryParse(jsonMap['driveB']?.toString() ?? '') ?? 0;
      vfdDelayB.value =
          int.tryParse(jsonMap['vfdDelayB']?.toString() ?? '') ?? 0;
      selectedEXVModeB.value =
          int.tryParse(jsonMap['ExvselB']?.toString() ?? '') ?? 0;
      minValueB.value = int.tryParse(jsonMap['minB']?.toString() ?? '') ?? 0;
      maxValueB.value = int.tryParse(jsonMap['maxB']?.toString() ?? '') ?? 0;
      gasB.value = int.tryParse(jsonMap['gasB']?.toString() ?? '') ?? 0;
      //pressure configuration
      ampereB.value = ampB;
      sucPressureUnitB.value = sucpressureunit == 1;
      sucPressureTypeB.value = sucpressuretype;
      sucPressureRangeB.value = sucpressurerange;
      disPressureUnitB.value = dispressureunit == 1;
      disPressureTypeB.value = dispressuretype;
      disPressureRangeB.value = dispressurerange;
      dischargeOffsetB.value = disOffsetB;
      oilPressureUnitB.value = oilpressureunit == 1;
      oilPressureTypeB.value = oilpressuretype;
      oilPressureRangeB.value = oilpressurerange;
      oilOffsetB.value = oiloffsetB;
      suctionOffsetB.value = sucoffsettB;
      integralspB.value = integralB;
      derivativespB.value = derivativeB;
      propostionalspB.value = proportionalB;
      exvPosiSwB.value = exvPosiB == 1;
      //setpoints B
      oilPressurespB.value = oilPrespB;
      amperespB.value = ampSpB;
      sucPressurespB.value = suctionPressureB;
      disPressurespB.value = dischargePressureB;
      sucTempspB.value = suctionTempB;
      disTempspB.value = dischargeTempB;
      lowSprayTempspB.value = lowSprayB;
      superHeatspB.value = superheatB;
      //pressure configuration
      circuitBenable.value = enableB == 1;
      leadlagBSwitch.value = leadlagB == 1;
      fan1and2BSwitch.value = fansw12B == 1;
      fan3and4BSwitch.value = fansw34B == 1;
      fan5and6BSwitch.value = fansw56B == 1;
      log("Updated connection List: $deviceConnections");
      log("Received MQTT Data:");
    } catch (e) {
      log("Error parsing JSON: DM $e");
    }
  }

  void _handleMessageDMSensorB(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String temp1 = jsonMap['temp1']?.toString() ?? "0";
      String temp2 = jsonMap['temp2']?.toString() ?? "0";
      String temp3 = jsonMap['temp3']?.toString() ?? "0";
      String temp4 = jsonMap['temp4']?.toString() ?? "0";
      String temp5 = jsonMap['temp5']?.toString() ?? "0";
      String temp6 = jsonMap['temp6']?.toString() ?? "0";
      String offset1 = jsonMap['offset1']?.toString() ?? "0";
      String offset2 = jsonMap['offset2']?.toString() ?? "0";
      String offset3 = jsonMap['offset3']?.toString() ?? "0";
      String offset4 = jsonMap['offset4']?.toString() ?? "0";
      String offset5 = jsonMap['offset5']?.toString() ?? "0";
      String offset6 = jsonMap['offset6']?.toString() ?? "0";
      String aaddress1 = jsonMap['address1']?.toString() ?? "0";
      String aaddress2 = jsonMap['address2']?.toString() ?? "0";
      String aaddress3 = jsonMap['address3']?.toString() ?? "0";
      String aaddress4 = jsonMap['address4']?.toString() ?? "0";
      String aaddress5 = jsonMap['address5']?.toString() ?? "0";
      String aaddress6 = jsonMap['address6']?.toString() ?? "0";
      String address1select = jsonMap[aaddress1]?.toString() ?? "0";
      String address2select = jsonMap[aaddress2]?.toString() ?? "0";
      String address3select = jsonMap[aaddress3]?.toString() ?? "0";
      String address4select = jsonMap[aaddress4]?.toString() ?? "0";
      String address5select = jsonMap[aaddress5]?.toString() ?? "0";
      String address6select = jsonMap[aaddress6]?.toString() ?? "0";
      sensorTemp1B.value = temp1;
      sensorTemp2B.value = temp2;
      sensorTemp3B.value = temp3;
      sensorTemp4B.value = temp4;
      sensorTemp5.value = temp5;
      sensorTemp6.value = temp6;
      offsett1B.value = offset1;
      offsett2B.value = offset2;
      offsett3B.value = offset3;
      offsett4B.value = offset4;
      offsett5.value = offset5;
      offsett6.value = offset6;
      selection1B.value = address1select;
      selection2B.value = address2select;
      selection3B.value = address3select;
      selection4B.value = address4select;
      selection5.value = address5select;
      selection6.value = address6select;
      address1B.value = aaddress1;
      address2B.value = aaddress2;
      address3B.value = aaddress3;
      address4B.value = aaddress4;
      address5.value = aaddress5;
      address6.value = aaddress6;
    } catch (e) {
      log("Error parsing message: ZM $e");
    }
  }

//main DX-Master
  void _handleMessageDM(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      int tempSelect = jsonMap['tempSelect'] ?? 0;
      dmStatusA.value = int.tryParse(jsonMap['statusA']?.toString() ?? '') ?? 0;
      dmStatusB.value = int.tryParse(jsonMap['statusB']?.toString() ?? '') ?? 0;
      dmSupply.value =
          double.tryParse(jsonMap['supplyTemp']?.toString() ?? '') ?? 0.0;
      dmSetpoint.value =
          int.tryParse(jsonMap['setPoint']?.toString() ?? '') ?? 0;
      dmReturn.value =
          double.tryParse(jsonMap['return']?.toString() ?? '') ?? 0.0;
      dmPower.value =
          int.tryParse(jsonMap['powerSwitch']?.toString() ?? '') ?? 0;
      dmResetValues.value =
          int.tryParse(jsonMap['resetValues']?.toString() ?? '') ?? 0;
      tempSelectionSwitch.value = tempSelect == 1;
      log("Updated connection List: $deviceConnections");
      log("Received MQTT Data:");
    } catch (e) {
      log("Error parsing JSON: DM $e");
    }
  }

  //dm noti
  void _handleMessageNotificationDm(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String topicid = topics.split('/').last;
      dmSetpoint.value =
          int.tryParse(jsonMap['setPoint']?.toString() ?? '') ?? 0;
      dmReturn.value =
          double.tryParse(jsonMap['return']?.toString() ?? '') ?? 0.0;
      dmStatusA.value = int.tryParse(jsonMap['statusA']?.toString() ?? '') ?? 0;
      dmStatusB.value = int.tryParse(jsonMap['statusB']?.toString() ?? '') ?? 0;
      if (isNotiInteracting == true &&
          (dmStatusA.value == 7 ||
              dmStatusB.value == 7 ||
              dmStatusA.value == 8 ||
              dmStatusB.value == 8 ||
              dmStatusA.value == 9 ||
              dmStatusB.value == 9 ||
              dmStatusA.value == 10 ||
              dmStatusB.value == 10 ||
              dmStatusA.value == 11 ||
              dmStatusB.value == 11 ||
              dmStatusA.value == 12 ||
              dmStatusB.value == 12 ||
              dmStatusA.value == 13 ||
              dmStatusB.value == 13 ||
              (dmReturn.value < dmSetpoint.value))) {
        // Temperature
        checkAndNotifyDm(
          deviceid: topicid,
          status: "High",
          id: "temp1",
          condition: dmReturn.value < dmSetpoint.value,
          title: 'Return',
          value: dmReturn.value.toDouble(),
          type: "temperature",
        );
        //Feedbacks
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "suctA",
          condition: dmStatusA.value == 7,
          title: 'Suc Low Temp(A)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "suctB",
          condition: dmStatusB.value == 7,
          title: 'Suc Low Temp(B)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "distA",
          condition: dmStatusA.value == 8,
          title: 'Dis High Temp(A)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "distB",
          condition: dmStatusB.value == 8,
          title: 'Dis High Temp(B)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "sucPsiA",
          condition: dmStatusA.value == 9,
          title: 'Suc Low Psi(A)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "sucPsiB",
          condition: dmStatusB.value == 9,
          title: 'Suc Low Psi(B)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "disPsiA",
          condition: dmStatusA.value == 10,
          title: 'Dis High Psi(A)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "disPsiB",
          condition: dmStatusB.value == 10,
          title: 'Dis High Psi(B)',
          type: "switch",
        );

        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "compAA",
          condition: dmStatusA.value == 11,
          title: 'Comp High Amp(A)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "compAB",
          condition: dmStatusB.value == 11,
          title: 'Comp High Amp(B)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "shA",
          condition: dmStatusA.value == 12,
          title: 'Spray Low Temp(A)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "shB",
          condition: dmStatusB.value == 12,
          title: 'Spray Low Temp(B)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "oilPsiA",
          condition: dmStatusA.value == 13,
          title: 'Oil Low Psi(A)',
          type: "switch",
        );
        checkAndNotifyDm(
          value: "",
          deviceid: topicid,
          status: "",
          id: "oilPsiB",
          condition: dmStatusB.value == 13,
          title: 'Oil Low Psi(B)',
          type: "switch",
        );
      }
    } catch (e) {
      log("Error parsing message: DX $e");
    }
  }

  Map<String, Map<String, double>> lastNotifiedValuePerDeviceDm = {};
  void checkAndNotifyDm({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastNotifiedValuePerDeviceDm.containsKey(deviceid)) {
      lastNotifiedValuePerDeviceDm[deviceid] = {};
    }

    final deviceMap = lastNotifiedValuePerDeviceDm[deviceid]!;
// log("${dmReturn.value}  ${dmSetpoint.value}______________________");
    if (condition) {
      if (type == "switch") {
        if (!deviceMap.containsKey(id)) {
          deviceMap[id] = 1; // dummy value
          _notificationControllerDm.showSwitchAlertNotification(
              deviceid, title, status, value);
          saveLastNotifiedValuesDx(); // Save updated state
        }
      } else {
        double? parsed = double.tryParse(value.toString());
        if (parsed == null) return;
        double roundedValue = parsed.floorToDouble();
        double? lastValue = deviceMap[id];
        if (lastValue == null || lastValue != roundedValue) {
          deviceMap[id] = roundedValue;
          if (type == "temperature") {
            _notificationControllerDm.showTemperatureAlertNotification(
                deviceid, title, parsed, status);
          }
          saveLastNotifiedValuesDm(); // Save updated state
        }
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValuesDm(); // Save updated state
    }
  }

  void clearLastNotifiedValuesDm(String deviceId) {
    lastNotifiedValuePerDeviceDm.remove(deviceId);
    saveLastNotifiedValuesDm();
  }

//Save DX Notification sharedpreference
  Future<void> saveLastNotifiedValuesDm() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastNotifiedValuePerDeviceDm.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_values', encoded);
  }

//Load DX Notification from sharedpreference
  Future<void> loadLastNotifiedValuesDm() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_values');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastNotifiedValuePerDeviceDm = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

  void _handleMessageIO(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      //Input A
      oilswA.value = int.tryParse(jsonMap['oilswA']?.toString() ?? '') ?? 0;
      oilpsiA.value = int.tryParse(jsonMap['oilpsiA']?.toString() ?? '') ?? 0;
      suctionA.value = int.tryParse(jsonMap['suctionA']?.toString() ?? '') ?? 0;
      dischargeA.value =
          int.tryParse(jsonMap['dischargeA']?.toString() ?? '') ?? 0;
      //Input B
      oilswB.value = int.tryParse(jsonMap['oilswB']?.toString() ?? '') ?? 0;
      oilpsiB.value = int.tryParse(jsonMap['oilpsiB']?.toString() ?? '') ?? 0;
      suctionB.value = int.tryParse(jsonMap['suctionB']?.toString() ?? '') ?? 0;
      dischargeB.value =
          int.tryParse(jsonMap['dischargeB']?.toString() ?? '') ?? 0;
      //output A
      starA.value = int.tryParse(jsonMap['starA']?.toString() ?? '') ?? 0;
      deltaA.value = int.tryParse(jsonMap['deltaA']?.toString() ?? '') ?? 0;
      fan1A.value = int.tryParse(jsonMap['fan1A']?.toString() ?? '') ?? 0;
      fan3A.value = int.tryParse(jsonMap['fan3A']?.toString() ?? '') ?? 0;
      //output B
      starB.value = int.tryParse(jsonMap['starB']?.toString() ?? '') ?? 0;
      deltaB.value = int.tryParse(jsonMap['deltaB']?.toString() ?? '') ?? 0;
      fan1B.value = int.tryParse(jsonMap['fan1B']?.toString() ?? '') ?? 0;
      fan3B.value = int.tryParse(jsonMap['fan3B']?.toString() ?? '') ?? 0;
      log("Received MQTT Data:");
    } catch (e) {
      log("Error parsing JSON: DM $e");
    }
  }

  RxBool dmResetload = false.obs;
  void buildJsonPayloadDXMaster() {
    Map<String, dynamic> jsonPayload = {
      "setPoint": dmSetpoint.value,
      "powerSwitch": dmPower.value,
      "resetValues": dmResetValues.value,
      "tempSelect": tempSelectionSwitch.value ? 1 : 0,
    };
    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void buildJsonPayloadDMA() {
    Map<String, dynamic> jsonPayload = {
      "offset${address1A.value}": offsett1A.value,
      "offset${address2A.value}": offsett2A.value,
      "offset${address3A.value}": offsett3A.value,
      "offset${address4A.value}": offsett4A.value,
      "offset${address5.value}": offsett5.value,
      "offset${address6.value}": offsett6.value,
      address1A.value: selection1A.value,
      address2A.value: selection2A.value,
      address3A.value: selection3A.value,
      address4A.value: selection4A.value,
      address5.value: selection5.value,
      address6.value: selection6.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishdmSensor(jsonString, true);
  }

  void publishdmSensor(String message, bool isCircuit) {
    String topic;
    if (isCircuit) {
      topic = "/test/$topicSSIDvalue/4";
    } else {
      topic = "/test/$topicSSIDvalue/5";
    }
    if (client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: false,
        );
        log('Message published to $topic: $message');
      } catch (e) {
        log('Failed to publish message: $e');
      }
    }
  }

  void buildJsonPayloadCiruitA() {
    Map<String, dynamic> jsonPayload = {
      //gas
      "gasA": gasA.value,
      //EXV Settings
      "exvMstepA": exvMaxStepA.value,
      "ampSpA": amperespA.value,
      "exvStepDA": exvStepDelayA.value,
      "ExvselA": selectedEXVModeA.value,
      "PidIA": integralspA.value,
      "PidDA": derivativespA.value,
      "PidPA": propostionalspA.value,
      "minA": minValueA.value,
      "maxA": maxValueA.value,
      "modeA": exvPosiSwA.value ? 1 : 0,
      "fan1EA": fan1and2ASwitch.value ? 1 : 0,
      "fan3EA": fan3and4ASwitch.value ? 1 : 0,
      "fan5EA": fan5and6ASwitch.value ? 1 : 0,
      //setpoints A
      "oilPsiSpA": oilPressurespA.value,
      "SucPsiSpA": sucPressurespA.value,
      "DisPsiSpA": disPressurespA.value,
      "SucTempSpA": sucTempspA.value,
      "DisTempSpA": disTempspA.value,
      "SprayTempSpA": lowSprayTempspA.value,
      "superheatspA": superHeatspA.value,
      "disPreTypeA": disPressureTypeA.value,
      "disPreRangeA": disPressureRangeA.value,
      "disPreUnitA": disPressureUnitA.value ? 1 : 0,
      "disoffsetA": dischargeOffsetA.value,
      "sucPreTypeA": sucPressureTypeA.value,
      "sucPreRangeA": sucPressureRangeA.value,
      "sucPreUnitA": sucPressureUnitA.value ? 1 : 0,
      "sucoffsetA": suctionOffsetA.value,
      "oilPreTypeA": oilPressureTypeA.value,
      "oilPreRangeA": oilPressureRangeA.value,
      "oilPreUnitA": oilPressureUnitA.value ? 1 : 0,
      "oiloffsetA": oilOffsetA.value,
      "driveA": selectedModeA.value,
      "vfdMinFreA": vfdMinFrequencyA.value,
      "vfdMaxFreA": vfdMaxFrequencyA.value,
      "vfdDelayA": vfdDelayA.value,
      "enableA": circuitAenable.value ? 1 : 0,
      "leadlagA": leadlagASwitch.value ? 1 : 0,
      "startdelayA": dmStartA.value,
      "stepsizeA": dmStepSizeA.value,
      "fan1HA": fan1and2HighALimit.value,
      "fan3HA": fan3and4HighALimit.value,
      "fan5HA": fan5and6HighALimit.value,
      "fan1LA": fan1and2LowALimit.value,
      "fan3LA": fan3and4LowALimit.value,
      "fan5LA": fan5and6LowALimit.value,
    };
    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString); //2
  }

  void buildJsonPayloadDMB() {
    Map<String, dynamic> jsonPayload = {
      "offset${address1B.value}": offsett1B.value,
      "offset${address2B.value}": offsett2B.value,
      "offset${address3B.value}": offsett3B.value,
      "offset${address4B.value}": offsett4B.value,
      // "offset${address5.value}": offsett5.value,
      // "offset${address6.value}": offsett6.value,
      address1B.value: selection1B.value,
      address2B.value: selection2B.value,
      address3B.value: selection3B.value,
      address4B.value: selection4B.value,
      // address5.value: selection5.value,
      // address6.value: selection6.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishdmSensor(jsonString, false);
  }

  void buildJsonPayloadCiruitB() {
    Map<String, dynamic> jsonPayload = {
      //gas
      "gasB": gasB.value,
      //EXV Settings
      "ampSpB": amperespB.value,
      "exvMstepB": exvMaxStepB.value,
      "exvStepDB": exvStepDelayB.value,
      "ExvselB": selectedEXVModeB.value,
      "PidIB": integralspB.value,
      "PidDB": derivativespB.value,
      "PidPB": propostionalspB.value,
      "minB": minValueB.value,
      "maxB": maxValueB.value,
      "modeB": exvPosiSwB.value ? 1 : 0,
      "fan1EB": fan1and2BSwitch.value ? 1 : 0,
      "fan3EB": fan3and4BSwitch.value ? 1 : 0,
      "fan5EB": fan5and6BSwitch.value ? 1 : 0,
      //setpoints B
      "oilPsiSpB": oilPressurespB.value,
      "SucPsiSpB": sucPressurespB.value,
      "DisPsiSpB": disPressurespB.value,
      "SucTempSpB": sucTempspB.value,
      "DisTempSpB": disTempspB.value,
      "SprayTempSpB": lowSprayTempspB.value,
      "superheatspB": superHeatspB.value,
      "disPreTypeB": disPressureTypeB.value,
      "disPreRangeB": disPressureRangeB.value,
      "disPreUnitB": disPressureUnitB.value ? 1 : 0,
      "disoffsetB": dischargeOffsetB.value,
      "sucPreTypeB": sucPressureTypeB.value,
      "sucPreRangeB": sucPressureRangeB.value,
      "sucPreUnitB": sucPressureUnitB.value ? 1 : 0,
      "sucoffsetB": suctionOffsetB.value,

      "oilPreTypeB": oilPressureTypeB.value,
      "oilPreRangeB": oilPressureRangeB.value,
      "oilPreUnitB": oilPressureUnitB.value ? 1 : 0,
      "oiloffsetB": oilOffsetB.value,

      "driveB": selectedModeB.value,
      "vfdMinFreB": vfdMinFrequencyB.value,
      "vfdMaxFreB": vfdMaxFrequencyB.value,
      "vfdDelayB": vfdDelayB.value,
      "enableB": circuitBenable.value ? 1 : 0,
      "leadlagB": leadlagBSwitch.value ? 1 : 0,
      "startdelayB": dmStartB.value,
      "stepsizeB": dmStepSizeB.value,
      "fan1HB": fan1and2HighBLimit.value,
      "fan3HB": fan3and4HighBLimit.value,
      "fan5HB": fan5and6HighBLimit.value,
      "fan1LB": fan1and2LowBLimit.value,
      "fan3LB": fan3and4LowBLimit.value,
      "fan5LB": fan5and6LowBLimit.value,
    };
    String jsonString = jsonEncode(jsonPayload);
    publishMessagepressure(jsonString); //3
  }

//DX(Mini)
//Azam
  RxInt dxPower = 0.obs;

  RxInt dischargespDXM = 0.obs;
  RxInt returnspDXM = 0.obs;
  RxDouble returnDXM = 0.0.obs;
  RxDouble dischargeDXM = 0.0.obs;
  RxDouble supplyDXM = 0.0.obs;
  RxBool r1swDXM = false.obs;
  RxBool r2swDXM = false.obs;
  RxBool r3swDXM = false.obs;
  RxInt r1statusDXM = 0.obs;
  RxInt r2statusDXM = 0.obs;
  RxInt r3statusDXM = 0.obs;
  RxBool modeDXM = false.obs;
  RxBool faultmodeDXM = false.obs;
  var dxmaddress1 = "".obs;
  var dxmaddress3 = "".obs;
  var dxmaddress2 = "".obs;
  var dxmselection1 = "".obs;
  var dxmselection2 = "".obs;
  var dxmselection3 = "".obs;
  var dxmsensorTemp1 = "0.0".obs;
  var dxmsensorTemp2 = "0.0".obs;
  var dxmsensorTemp3 = "0.0".obs;
  var dxmoffsett1 = "".obs;
  var dxmoffsett2 = "".obs;
  var dxmoffsett3 = "".obs;
  var statusDXM = 1.obs;
  //DX-Mini Data
  void _handleMessageDxMini(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      dxPower.value =
          int.tryParse(jsonMap['powerState']?.toString() ?? '') ?? 0;
      dischargespDXM.value =
          int.tryParse(jsonMap['dischargeSp']?.toString() ?? '') ?? 0;
      returnspDXM.value =
          int.tryParse(jsonMap['returnSp']?.toString() ?? '') ?? 0;
      returnDXM.value = double.tryParse('${jsonMap['returnTemp']}') ?? 0.0;
      dischargeDXM.value =
          double.tryParse(jsonMap['dischargeTemp']?.toString() ?? '') ?? 0;
      supplyDXM.value =
          double.tryParse(jsonMap['supplyTemp']?.toString() ?? '') ?? 0;
      r1statusDXM.value =
          int.tryParse(jsonMap['r1Status']?.toString() ?? '') ?? 0;
      r2statusDXM.value =
          int.tryParse(jsonMap['r2Status']?.toString() ?? '') ?? 0;
      r3statusDXM.value =
          int.tryParse(jsonMap['r3Status']?.toString() ?? '') ?? 0;
      r1swDXM.value = jsonMap['r1Sw'].toString() == "1";
      r2swDXM.value = jsonMap['r2Sw'].toString() == "1";
      r3swDXM.value = jsonMap['r3Sw'].toString() == "1";
      faultmodeDXM.value = jsonMap['faultSw'].toString() == "1";
      modeDXM.value = jsonMap['modeSw'].toString() == "1";
      int tmatched = jsonMap['tmatched'] ?? 0;
      timematch.value = tmatched == 1;
      statusDXM.value =
          int.tryParse(jsonMap['systemStatus']?.toString() ?? '') ?? 0;
      String timeschen = jsonMap['timeschen'].toString();
      String timesch = jsonMap['timesch'].toString();

      toggleValue.value = timeschen == "1";
      if (timesch.isNotEmpty &&
          timesch.contains('hoursch=') &&
          timesch.contains('daysch=')) {
        List<String> parts = timesch.split('|');
        String hoursPart = parts
            .firstWhere((e) => e.startsWith('hoursch='),
                orElse: () => 'hoursch=')
            .replaceFirst('hoursch=', '');
        String daysPart = parts
            .firstWhere((e) => e.startsWith('daysch='), orElse: () => 'daysch=')
            .replaceFirst('daysch=', '');

        List<String> hourStrings = hoursPart
            .split(',')
            .where((e) => e.trim().isNotEmpty && hours.contains(e))
            .toList();
        List<String> dayIndexes =
            daysPart.split(',').where((e) => e.trim().isNotEmpty).toList();

        selectedHour.assignAll(hourStrings);
        selectedDays.assignAll(dayIndexes.map((i) => days[int.parse(i)]));
      } else {
        selectedHour.clear();
        selectedDays.clear();
      }
      log("Received MQTT Data:");
    } catch (e) {
      log("Error parsing JSON: AM2 $e");
    }
  }

  void _dxmhandleMessageSensor(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String aaddress1 = jsonMap['address1']?.toString() ?? "0";
      String aaddress2 = jsonMap['address2']?.toString() ?? "0";
      String aaddress3 = jsonMap['address3']?.toString() ?? "";
      String address1select = jsonMap[aaddress1]?.toString() ?? "0";
      String address2select = jsonMap[aaddress2]?.toString() ?? "0";
      String address3select = jsonMap[aaddress3]?.toString() ?? "";
      String temp1 = jsonMap['temp1']?.toString() ?? "0";
      String temp2 = jsonMap['temp2']?.toString() ?? "0";
      String temp3 = jsonMap['temp3']?.toString() ?? "";
      String offset1 = jsonMap['offset1']?.toString() ?? "0";
      String offset2 = jsonMap['offset2']?.toString() ?? "0";
      String offset3 = jsonMap['offset3']?.toString() ?? "";
      dxmsensorTemp1.value = temp1;
      dxmsensorTemp2.value = temp2;
      dxmsensorTemp3.value = temp3;
      dxmselection1.value = address1select;
      dxmselection2.value = address2select;
      dxmselection3.value = address3select;
      dxmaddress1.value = aaddress1;
      dxmaddress2.value = aaddress2;
      dxmaddress3.value = aaddress3;
      dxmoffsett1.value = offset1;
      dxmoffsett2.value = offset2;
      dxmoffsett3.value = offset3;
    } catch (e) {
      log("Error parsing message: ZM $e");
    }
  }

  Future<void> selectModeDXM(var mode) async {
    isUserInteracting.value = true;
    isModeLoading.value = true;
    modeDXM.value = mode;
    publishTimer?.cancel();
    publishTimer = Timer(Duration(seconds: 1), () {
      log("Toggle value changed:");
      buildJsonPayloadDXMini();
      publishTimer = Timer(Duration(seconds: 2), () {
        log("start publish");
        isUserInteracting.value = false;
      });
    });

    await Future.delayed(Duration(seconds: 3));
    isModeLoading.value = false;
  }

  void updatedxmReturnLow(double value) {
    returnspDXM.value = value.toInt();
    buildJsonPayloadDXMini();
    update();
  }

  void updatedxmDischarge(double value) {
    dischargespDXM.value = value.toInt();
    buildJsonPayloadDXMini();
    update();
  }

  Future<void> dxmautoSwitch(bool value) async {
    dxautoSwLoading.value = true;
    faultmodeDXM.value = value;
    buildJsonPayloadDXMini();
    await Future.delayed(Duration(seconds: 2));
    dxautoSwLoading.value = false;
  }

  RxBool dxmR1SwLoading = false.obs;
  Future<void> dxmR1Switch(bool value) async {
    dxmR1SwLoading.value = true;
    r1swDXM.value = value;
    buildJsonPayloadDXMini();
    await Future.delayed(Duration(seconds: 2));
    dxmR1SwLoading.value = false;
  }

  RxBool dxmR2SwLoading = false.obs;
  Future<void> dxmR2Switch(bool value) async {
    dxmR2SwLoading.value = true;
    r2swDXM.value = value;
    buildJsonPayloadDXMini();
    await Future.delayed(Duration(seconds: 2));
    dxmR2SwLoading.value = false;
  }

  RxBool dxmR3SwLoading = false.obs;
  Future<void> dxmR3Switch(bool value) async {
    dxmR3SwLoading.value = true;
    r3swDXM.value = value;
    buildJsonPayloadDXMini();
    await Future.delayed(Duration(seconds: 2));
    dxmR3SwLoading.value = false;
  }

  void buildJsonPayloadDXMini() {
    Map<String, dynamic> jsonPayload = {
      "powerState": dxPower.value,
      "timesch": result.value,
      "timeschen": toggleValue.value ? 1 : 0,
      "modeSw": modeDXM.value ? 1 : 0,
      "faultSw": faultmodeDXM.value ? 1 : 0,
      "returnSp": returnspDXM.value.toString(),
      "dischargeSp": dischargespDXM.value.toString(),
      'r1Sw': r1swDXM.value ? 1 : 0,
      'r2Sw': r2swDXM.value ? 1 : 0,
      'r3Sw': r3swDXM.value ? 1 : 0,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  //temp_config
  void buildJsonPayloadDXMiniSensor() {
    Map<String, dynamic> jsonPayload = {
      "offset${dxmaddress1.value}": dxmoffsett1.value,
      "offset${dxmaddress2.value}": dxmoffsett2.value,
      "offset${dxmaddress3.value}": dxmoffsett3.value,
      dxmaddress1.value: dxmselection1.value,
      dxmaddress2.value: dxmselection2.value,
      dxmaddress3.value: dxmselection3.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString);
  }

// DXMini Notifixcation
  Map<String, Map<String, double>> lastNotifiedValuePerDeviceDxm = {};
  void _handleMessageNotificationDxm(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String topicid = topics.split('/').last;
      returnspDXM.value =
          int.tryParse(jsonMap['returnSp']?.toString() ?? '') ?? 0;
      returnDXM.value = double.tryParse('${jsonMap['returnTemp']}') ?? 0.0;
      if (isNotiInteracting == true && (statusDXM.value == 1)) {
        // Temperature
        checkAndNotifyDxm(
          value: returnDXM.value.toDouble(),
          deviceid: topicid,
          status: "High",
          id: "temp1",
          condition: returnspDXM.value <= returnDXM.value,
          title: 'Return',
          type: "temperature",
        );
      }
    } catch (e) {
      log("Error parsing message: DXM $e");
    }
  }

  void checkAndNotifyDxm({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastNotifiedValuePerDeviceDxm.containsKey(deviceid)) {
      lastNotifiedValuePerDeviceDxm[deviceid] = {};
    }

    final deviceMap = lastNotifiedValuePerDeviceDxm[deviceid]!;

    if (condition) {
      double? parsed = double.tryParse(value.toString());
      if (parsed == null) return;
      double roundedValue = parsed.floorToDouble();
      double? lastValue = deviceMap[id];
      log("Temperature check → Device: $deviceid, Sensor: $id, Prev: $lastValue, New: $roundedValue");
      if (lastValue == null || lastValue != roundedValue) {
        deviceMap[id] = roundedValue;
        if (type == "temperature") {
          _notificationControllerDxm.showTemperatureAlertNotification(
            deviceid,
            title,
            value,
            status,
          );
        }
        saveLastNotifiedValuesDxm();
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValuesDxm(); // Save updated state
    }
  }

  void clearLastNotifiedValuesDxm(String deviceId) {
    lastNotifiedValuePerDeviceDxm.remove(deviceId);
    saveLastNotifiedValuesDxm();
  }

  Future<void> saveLastNotifiedValuesDxm() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastNotifiedValuePerDeviceDxm.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_valuesDXM', encoded);
  }

  Future<void> loadLastNotifiedValuesDxm() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_valuesDXM');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastNotifiedValuePerDeviceDxm = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

//DX-400

  RxBool dxisAmpVisible = false.obs;
  RxBool dxisInnerVisible = false.obs;
  RxBool dxisHeatVisible = false.obs;
  RxBool dxisCompVisible = false.obs;
  RxBool dxisFbVisible = false.obs;
  RxBool dxisCompFbVisible = false.obs;
  RxBool dxisOilPressureVisible = false.obs;
  RxBool dxisDischargePressureVisible = false.obs;
  RxBool dxisSuctionPressureVisible = false.obs;
  RxBool dxisSwitchBoxVisible = false.obs;
  RxBool dxisSuctionSwitchVisible = false.obs;
  RxBool dxisDischargeSwitchVisible = false.obs;
  RxBool dxisAutoSwitch = false.obs;
  RxBool dxisModeSwitch = false.obs;
  RxBool modeDx = false.obs;
  RxInt restartdelay = 0.obs;
  RxInt startdelay = 0.obs;
  RxInt condenserOl = 0.obs;
  RxInt compressorOl = 0.obs;
  RxInt lps = 0.obs;
  RxInt hps = 0.obs;
  RxInt ops = 0.obs;
  RxInt innerFanFeedback = 0.obs;
  RxInt heaterFeedback = 0.obs;
  RxInt compressorFeedback = 0.obs;
  RxInt compressor = 0.obs;
  RxInt condenserFan = 0.obs;
  RxInt innerFan = 0.obs;
  RxInt heater = 0.obs;

  //DX-400 Data
  void _handleMessageDx(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      dxamp1.value = int.tryParse(jsonMap['value0']?.toString() ?? '') ?? 0;
      dxamp2.value = int.tryParse(jsonMap['value8']?.toString() ?? '') ?? 0;
      dxamp3.value = int.tryParse(jsonMap['value9']?.toString() ?? '') ?? 0;
      dxtemp1.value = double.tryParse('${jsonMap['value1']}') ?? 0.0;
      dxtemp2.value = double.tryParse(jsonMap['value2']?.toString() ?? '') ?? 0;
      dxtemp3.value = double.tryParse(jsonMap['value3']?.toString() ?? '') ?? 0;
      dxtemp4.value = double.tryParse(jsonMap['value4']?.toString() ?? '') ?? 0;
      dxtemp1F.value = double.tryParse('${jsonMap['value1F']}') ?? 0.0;
      dxtemp2F.value =
          double.tryParse(jsonMap['value2F']?.toString() ?? '') ?? 0;
      dxtemp3F.value =
          double.tryParse(jsonMap['value3F']?.toString() ?? '') ?? 0;
      dxtemp4F.value =
          double.tryParse(jsonMap['value4F']?.toString() ?? '') ?? 0;
      dxpsig1.value =
          double.tryParse(jsonMap['value5']?.toString() ?? '') ?? 0.0;
      dxpsig2.value =
          double.tryParse(jsonMap['value6']?.toString() ?? '') ?? 0.0;
      dxpsig3.value =
          double.tryParse(jsonMap['value7']?.toString() ?? '') ?? 0.0;
      dxpsig1F.value =
          double.tryParse(jsonMap['value5F']?.toString() ?? '') ?? 0.0;
      dxpsig2F.value =
          double.tryParse(jsonMap['value6F']?.toString() ?? '') ?? 0.0;
      dxpsig3F.value =
          double.tryParse(jsonMap['value7F']?.toString() ?? '') ?? 0.0;
      dxtemp1setlow.value =
          int.tryParse(jsonMap['value10']?.toString() ?? '') ?? 0;
      dxtemp2setlow.value =
          int.tryParse(jsonMap['value11']?.toString() ?? '') ?? 0;
      dxtemp3setlow.value =
          int.tryParse(jsonMap['value12']?.toString() ?? '') ?? 0;
      dxtemp4setlow.value =
          int.tryParse(jsonMap['value13']?.toString() ?? '') ?? 0;
      dxpsig1setlow.value =
          int.tryParse(jsonMap['value14']?.toString() ?? '') ?? 0;
      dxpsig2setlow.value =
          int.tryParse(jsonMap['value15']?.toString() ?? '') ?? 0;
      dxpsig3setlow.value =
          int.tryParse(jsonMap['value16']?.toString() ?? '') ?? 0;
      dxtemp1sethigh.value =
          int.tryParse(jsonMap['value21']?.toString() ?? '') ?? 0;
      dxtemp2sethigh.value =
          int.tryParse(jsonMap['value22']?.toString() ?? '') ?? 0;
      dxtemp3sethigh.value =
          int.tryParse(jsonMap['value23']?.toString() ?? '') ?? 0;
      dxtemp4sethigh.value =
          int.tryParse(jsonMap['value24']?.toString() ?? '') ?? 0;
      dxpsig1sethigh.value =
          int.tryParse(jsonMap['value25']?.toString() ?? '') ?? 0;

      dxpsig2sethigh.value =
          int.tryParse(jsonMap['value26']?.toString() ?? '') ?? 0;
      dxpsig3sethigh.value =
          int.tryParse(jsonMap['value27']?.toString() ?? '') ?? 0;
      dxamp1high.value =
          int.tryParse(jsonMap['value28']?.toString() ?? '') ?? 0;
      dxamp2high.value =
          int.tryParse(jsonMap['value29']?.toString() ?? '') ?? 0;
      dxamp3high.value =
          int.tryParse(jsonMap['value20']?.toString() ?? '') ?? 0;
      dxamp1low.value = int.tryParse(jsonMap['value17']?.toString() ?? '') ?? 0;
      dxcomp1status.value =
          int.tryParse(jsonMap['value30']?.toString() ?? '') ?? 0;

      if (jsonMap.containsKey('value32')) {
        dxhighpreswam2.value = jsonMap['value32'] == 'HIGH' ? 'HIGH' : 'LOW';
      }

      if (jsonMap.containsKey('value31')) {
        dxlowpreswam2.value = jsonMap['value31'] == 'HIGH' ? 'HIGH' : 'LOW';
      }
      if (jsonMap.containsKey('value33')) {
        dxoilpressureswam2.value = jsonMap['value33'] == 'LOW' ? 'LOW' : 'HIGH';
      }

      log("Updated connection List: $deviceConnections");
      log("Received MQTT Data:");
    } catch (e) {
      log("Error parsing JSON: AM2 $e");
    }
  }

//DX-400 Notification
  void _handleMessageNotificationDx(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String topicid = topics.split('/').last;
      dxtemp1sethigh.value =
          int.tryParse(jsonMap['value21']?.toString() ?? '') ?? 0;
      dxtemp1setlow.value =
          int.tryParse(jsonMap['value10']?.toString() ?? '') ?? 0;
      dxtemp1.value = double.tryParse(jsonMap['value1']?.toString() ?? '') ?? 0;
      dxtemp2.value = double.tryParse(jsonMap['value2']?.toString() ?? '') ?? 0;
      dxtemp2setlow.value =
          int.tryParse(jsonMap['value11']?.toString() ?? '') ?? 0;
      dxtemp2sethigh.value =
          int.tryParse(jsonMap['value22']?.toString() ?? '') ?? 0;
      dxtemp3.value = double.tryParse(jsonMap['value3']?.toString() ?? '') ?? 0;
      dxtemp3sethigh.value =
          int.tryParse(jsonMap['value23']?.toString() ?? '') ?? 0;
      dxtemp4.value = double.tryParse(jsonMap['value4']?.toString() ?? '') ?? 0;
      dxtemp4setlow.value =
          int.tryParse(jsonMap['value13']?.toString() ?? '') ?? 0;

      dxpsig1.value =
          double.tryParse(jsonMap['value5']?.toString() ?? '') ?? 0.0;
      dxpsig1sethigh.value =
          int.tryParse(jsonMap['value25']?.toString() ?? '') ?? 0;

      dxpsig2.value =
          double.tryParse(jsonMap['value6']?.toString() ?? '') ?? 0.0;
      dxpsig2setlow.value =
          int.tryParse(jsonMap['value15']?.toString() ?? '') ?? 0;
      dxpsig3.value =
          double.tryParse(jsonMap['value7']?.toString() ?? '') ?? 0.0;
      dxpsig3sethigh.value =
          int.tryParse(jsonMap['value27']?.toString() ?? '') ?? 0;

      dxamp2.value = int.tryParse(jsonMap['value8']?.toString() ?? '') ?? 0;
      dxamp1low.value = int.tryParse(jsonMap['value17']?.toString() ?? '') ?? 0;

      if (isNotiInteracting == true &&
          (dxcomp1status.value == 1 ||
              dxcomp1status.value == 3 ||
              dxcomp1status.value == 4 ||
              dxcomp1status.value == 5 ||
              dxcomp1status.value == 6 ||
              dxcomp1status.value == 7 ||
              dxcomp1status.value == 8 ||
              dxcomp1status.value == 9 ||
              dxcomp1status.value == 10 ||
              dxcomp1status.value == 11 ||
              dxcomp1status.value == 12 ||
              dxcomp1status.value == 13 ||
              dxcomp1status.value == 14 ||
              dxcomp1status.value == 15 ||
              dxcomp1status.value == 16 ||
              dxcomp1status.value == 17 ||
              dxcomp1status.value == 18)) {
        // Temperature
        checkAndNotifyDx(
          deviceid: topicid,
          status: "High",
          id: "temp1",
          // value10<=value1
          condition: dxtemp1setlow.value <= dxtemp1.value,
          title: 'Return',
          value: dxtemp1.value.toDouble(),
          type: "temperature",
        );

        checkAndNotifyDx(
          deviceid: topicid,
          status: "Low",
          id: "temp3",
          // value3<value23
          condition: dxtemp3.value <= dxtemp3sethigh.value,
          title: 'Suction',
          value: dxtemp3.value.toDouble(),
          type: "temperature",
        );

        checkAndNotifyDx(
          deviceid: topicid,
          status: "High",
          id: "temp4",
          // value4>value13
          condition: dxtemp4.value >= dxtemp4setlow.value,
          title: 'Discharge',
          value: dxtemp4.value.toDouble(),
          type: "temperature",
        );

        //Pressure
        if (dxisSuctionPressureVisible.value == true) {
          checkAndNotifyDx(
            deviceid: topicid,
            status: "Low",
            id: "psig1",
            // value5<value25
            condition: dxpsig1.value <= dxpsig1sethigh.value,
            title: 'Suction',
            value: dxpsig1.value.toDouble(),
            type: "pressure",
          );
        }
        if (dxisDischargePressureVisible.value == true) {
          checkAndNotifyDx(
            deviceid: topicid,
            status: "High",
            id: "psig2",
            condition: dxpsig2.value >= dxpsig2setlow.value,
            title: 'Discharge',
            value: dxpsig2.value.toDouble(),
            type: "pressure",
          );
        }
        if (dxisOilPressureVisible.value == true) {
          checkAndNotifyDx(
            deviceid: topicid,
            status: "Low",
            id: "psig3",
            condition: dxpsig3.value <= dxpsig3sethigh.value,
            title: 'Oil',
            value: dxpsig3.value.toDouble(),
            type: "pressure",
          );
        }
        //Ampere
        if (dxisAmpVisible.value == true) {
          checkAndNotifyDx(
            deviceid: topicid,
            status: "High",
            id: "amp2",
            condition: dxamp1low.value <= dxamp2.value,
            title: 'Phase 1',
            value: dxamp2.value.toDouble(),
            type: "ampere",
          );
        }
        if (dxisAmpVisible.value == true) {
          checkAndNotifyDx(
            deviceid: topicid,
            status: "High",
            id: "amp1",
            condition: dxamp1low.value <= dxamp1.value,
            title: 'Phase 3',
            value: dxamp1.value.toDouble(),
            type: "ampere",
          );
        }
        if (dxisAmpVisible.value == true) {
          checkAndNotifyDx(
            deviceid: topicid,
            status: "High",
            id: "amp3",
            condition: dxamp1low.value <= dxamp3.value,
            title: 'Phase 2',
            value: dxamp3.value.toDouble(),
            type: "ampere",
          );
        }
        // Switch
        if (dxisSuctionSwitchVisible.value == true) {
          checkAndNotifyDx(
            value: "(Tripped)",
            deviceid: topicid,
            status: "Low",
            id: "sw_suction",
            condition: dxlowpreswam2.value == 'LOW',
            title: 'Suction Pressure -',
            type: "switch",
          );
        }
        if (dxisDischargeSwitchVisible.value == true) {
          checkAndNotifyDx(
            value: "(Tripped)",
            deviceid: topicid,
            status: "High",
            id: "sw_discharge",
            condition: dxhighpreswam2.value == 'HIGH',
            title: 'Discharge Pressure -',
            type: "switch",
          );
        }
        if (dxisSwitchBoxVisible.value == true) {
          checkAndNotifyDx(
            value: "(Tripped)",
            deviceid: topicid,
            status: "Low",
            id: "sw_oil",
            condition: dxoilpressureswam2.value == "LOW",
            title: 'Oil Pressure -',
            type: "switch",
          );
        }
        //Feedbacks
        checkAndNotifyDx(
          value: "",
          deviceid: topicid,
          status: "",
          id: "compressor",
          condition: dxcomp1status.value == 15,
          title: 'Compressor Fail To Run',
          type: "switch",
        );
        checkAndNotifyDx(
          value: "",
          deviceid: topicid,
          status: "",
          id: "sw_cond",
          condition: dxcomp1status.value == 16,
          title: 'Condenser Overload',
          type: "switch",
        );
        checkAndNotifyDx(
          value: "",
          deviceid: topicid,
          status: "",
          id: "sw_comp",
          condition: dxcomp1status.value == 17,
          title: 'Compressor Overload',
          type: "switch",
        );
        checkAndNotifyDx(
          value: "",
          deviceid: topicid,
          status: "",
          id: "ht_fb",
          condition: dxcomp1status.value == 18,
          title: 'Heater Fail To Run',
          type: "switch",
        );
        checkAndNotifyDx(
          value: "",
          deviceid: topicid,
          status: "",
          id: "in_fb",
          condition: dxcomp1status.value == 18,
          title: 'Inner Fail To Run',
          type: "switch",
        );
      }
    } catch (e) {
      log("Error parsing message: DX $e");
    }
  }

  Map<String, Map<String, double>> lastNotifiedValuePerDeviceDx = {};
  void checkAndNotifyDx({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastNotifiedValuePerDeviceDx.containsKey(deviceid)) {
      lastNotifiedValuePerDeviceDx[deviceid] = {};
    }

    final deviceMap = lastNotifiedValuePerDeviceDx[deviceid]!;

    if (condition) {
      if (type == "switch") {
        if (!deviceMap.containsKey(id)) {
          deviceMap[id] = 1; // dummy value
          _notificationControllerDx.showSwitchAlertNotification(
              deviceid, title, status, value);
          saveLastNotifiedValuesDx(); // Save updated state
        }
      } else {
        double? parsed = double.tryParse(value.toString());
        if (parsed == null) return;

        double roundedValue = parsed.floorToDouble();
        double? lastValue = deviceMap[id];

        if (lastValue == null || lastValue != roundedValue) {
          deviceMap[id] = roundedValue;
          if (type == "temperature") {
            _notificationControllerDx.showTemperatureAlertNotification(
                deviceid, title, parsed, status);
          } else if (type == "pressure") {
            _notificationControllerDx.showPressureAlertNotification(
                deviceid, title, parsed, status);
          } else if (type == "ampere") {
            _notificationControllerDx.showAmpereAlertNotification(
                deviceid, title, parsed, status);
          }
          saveLastNotifiedValuesDx(); // Save updated state
        }
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValuesDx(); // Save updated state
    }
  }

  void clearLastNotifiedValuesDx(String deviceId) {
    lastNotifiedValuePerDeviceDx.remove(deviceId);
    saveLastNotifiedValuesDx();
  }

//Save DX Notification sharedpreference
  Future<void> saveLastNotifiedValuesDx() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastNotifiedValuePerDeviceDx.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_values', encoded);
  }

//Load DX Notification from sharedpreference
  Future<void> loadLastNotifiedValuesDx() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_values');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastNotifiedValuePerDeviceDx = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

  Future<void> loadLastNotifiedValuesTel() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('last_notified_valuesTel');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      lastHumidityAlertSent = decoded.map((deviceId, map) {
        final valueMap = Map<String, double>.from((map as Map).map(
          (key, val) => MapEntry(key.toString(), (val as num).toDouble()),
        ));
        return MapEntry(deviceId, valueMap);
      });
    }
  }

  void _handleMessageDxDevice(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String ip = jsonMap['ip_address']?.toString() ?? "";
      String mac = jsonMap['mac_address']?.toString() ?? "";
      dxtemp3setlow.value =
          int.tryParse(jsonMap['value12']?.toString() ?? '') ?? 0;
      String topicid = topics.split('/').last;
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
      log('Updating SharedPreferences with IP and MAC... $ip');
    } catch (e) {
      log("Error parsing JSON: AM2 $e");
    }
  }

  void buildJsonPayloadDXPressure() {
    Map<String, dynamic> jsonPayload = {
      "pressure_type": dxpressureType.value,
      "pressure_range": dxpressureRange.value,
      "pressure_unit": dxpressureUnit.value,
      "pressure_type2": dxpressureType2.value,
      "pressure_range2": dxpressureRange2.value,
      "pressure_unit2": dxpressureUnit2.value,
      "pressure_type3": dxpressureType3.value,
      "pressure_range3": dxpressureRange3.value,
      "pressure_unit3": dxpressureUnit3.value,
      "ftoC": dxftoC.value ? 1 : 0,
      "psiTobar": dxpsiTobar.value ? 1 : 0,
      "oilpressure": dxisOilPressureVisible.value ? 1 : 0,
      "dispressure": dxisDischargePressureVisible.value ? 1 : 0,
      "sucpressure": dxisSuctionPressureVisible.value ? 1 : 0,
      "oilsw": dxisSwitchBoxVisible.value ? 1 : 0,
      "suctionsw": dxisSuctionSwitchVisible.value ? 1 : 0,
      "dischargesw": dxisDischargeSwitchVisible.value ? 1 : 0,
      "autoSwitch": dxisAutoSwitch.value ? 1 : 0,
      "currentsw": dxisAmpVisible.value ? 1 : 0,
      "overload1": dxisInnerVisible.value ? 1 : 0,
      "overload2": dxisCompVisible.value ? 1 : 0,
      "overload3": dxisHeatVisible.value ? 1 : 0,
      "overload4": dxisFbVisible.value ? 1 : 0,
      "overload5": dxisCompFbVisible.value ? 1 : 0,
      "seasonsw": isSummer.value ? 1 : 0,
      "startDelay": startdelay.value,
      "restartDelay": restartdelay.value,
      "mode": modeDx.value ? 1 : 0,
      "timesch": result.value,
      "timeschen": toggleValue.value ? 1 : 0,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessagepressure(jsonString);
  }

//return DX sp
  void updatedxChillInlp(double value) {
    dxtemp1sethigh.value = value.toInt();
    dxbuildJsonPayload();
    update();
  }

  //return DX alert
  void updatedxChillInhp(double value) {
    dxtemp1setlow.value = value.toInt();
    dxbuildJsonPayload();
    update();
  }

  //suction DX sp
  void updatedxSuctionLow(double value) {
    dxtemp3sethigh.value = value.toInt();
    dxbuildJsonPayload();
    update();
  }

  //suction DX pressure
  void updatedxLowPressurelp(double value) {
    dxpsig1sethigh.value = value.toInt();
    dxbuildJsonPayload();
    update();
  }

  // discharge DX pressure
  void updatedxHighPressurehp(double value) {
    dxpsig2setlow.value = value.toInt();
    dxbuildJsonPayload();
    update();
  }

  //oil DX pressure
  void updatedxOilPressurelp(double value) {
    dxpsig3sethigh.value = value.toInt();
    dxbuildJsonPayload();
    update();
  }

  //Ampere DX sp
  void updatedxPhase1hp(double value) {
    dxamp1low.value = value.toInt();
    dxbuildJsonPayload();
    update();
  }

// discharge DX sp
  void updatedxDischargeHigh(double value) {
    dxtemp4setlow.value = value.toInt();
    dxbuildJsonPayload();
    update();
  }

  void _dxhandleMessageSensor(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String aaddress1 = jsonMap['address1']?.toString() ?? "0";
      String aaddress2 = jsonMap['address2']?.toString() ?? "0";
      String aaddress3 = jsonMap['address3']?.toString() ?? "";
      String aaddress4 = jsonMap['address4']?.toString() ?? "";
      String address1select = jsonMap[aaddress1]?.toString() ?? "0";
      String address2select = jsonMap[aaddress2]?.toString() ?? "0";
      String address3select = jsonMap[aaddress3]?.toString() ?? "";
      String address4select = jsonMap[aaddress4]?.toString() ?? "";
      String temp1 = jsonMap['temp1']?.toString() ?? "0";
      String temp2 = jsonMap['temp2']?.toString() ?? "0";
      String temp3 = jsonMap['temp3']?.toString() ?? "";
      String temp4 = jsonMap['temp4']?.toString() ?? "";
      String offset1 = jsonMap['offset1']?.toString() ?? "0";
      String offset2 = jsonMap['offset2']?.toString() ?? "0";
      String offset3 = jsonMap['offset3']?.toString() ?? "";
      String offset4 = jsonMap['offset4']?.toString() ?? "";
      dxsensorTemp1.value = temp1;
      dxsensorTemp2.value = temp2;
      dxsensorTemp3.value = temp3;
      dxsensorTemp4.value = temp4;
      dxselection1.value = address1select;
      dxselection2.value = address2select;
      dxselection3.value = address3select;
      dxselection4.value = address4select;
      dxaddress1.value = aaddress1;
      dxaddress2.value = aaddress2;
      dxaddress3.value = aaddress3;
      dxaddress4.value = aaddress4;
      dxoffsett1.value = offset1;
      dxoffsett2.value = offset2;
      dxoffsett3.value = offset3;
      dxoffsett4.value = offset4;
    } catch (e) {
      log("Error parsing message: ZM $e");
    }
  }

  void _dxhandleMessagePressure(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String pressuretype = jsonMap['pressure_type']?.toString() ?? "0";
      String pressurerange = jsonMap['pressure_range']?.toString() ?? "0";
      bool pressureunit = jsonMap['pressure_unit'] ?? false;
      String pressuretype2 = jsonMap['pressure_type2']?.toString() ?? "0";
      String pressurerange2 = jsonMap['pressure_range2']?.toString() ?? "0";
      bool pressureunit2 = jsonMap['pressure_unit2'] ?? false;
      String pressuretype3 = jsonMap['pressure_type3']?.toString() ?? "0";
      String pressurerange3 = jsonMap['pressure_range3']?.toString() ?? "0";
      bool pressureunit3 = jsonMap['pressure_unit3'] ?? false;
      int oilpressure = jsonMap['oilpressure'] ?? 0;
      int dispressure = jsonMap['dispressure'] ?? 0;
      int sucpressure = jsonMap['sucpressure'] ?? 0;
      int oilsw = jsonMap['oilsw'] ?? 0;
      int suctionsw = jsonMap['suctionsw'] ?? 0;
      int dischargesw = jsonMap['dischargesw'] ?? 0;
      int autoSwitch = jsonMap['autoSwitch'] ?? 0;
      int currentsw = jsonMap['currentsw'] ?? 0;
      int condenserOutput = jsonMap['condenserOutput'] ?? 0;
      int compressorOutput = jsonMap['compressorOutput'] ?? 0;
      int innerFanOutput = jsonMap['innerFanOutput'] ?? 0;
      int heaterOutput = jsonMap['heaterOutput'] ?? 0;
      int condenserOLinput = jsonMap['condenserOLinput'] ?? 0;
      int compressorOLinput = jsonMap['compressorOLinput'] ?? 0;
      int lpsinput = jsonMap['lpsinput'] ?? 0;
      int hpsinput = jsonMap['hpsinput'] ?? 0;
      int opsinput = jsonMap['opsinput'] ?? 0;
      int innerFanFbinput = jsonMap['innerFanFbinput'] ?? 0;
      int compressorFbinput = jsonMap['compressorFbinput'] ?? 0;
      int heaterFbinput = jsonMap['heaterFbinput'] ?? 0;
      int restartDelay =
          int.tryParse(jsonMap['restartDelay']?.toString() ?? '') ?? 0;
      int startDelay =
          int.tryParse(jsonMap['startDelay']?.toString() ?? '') ?? 0;
      // int selectionmode = jsonMap['selectionmode'] ?? 0;
      int seasonsw = jsonMap['seasonsw'] ?? 0;
      int mode = jsonMap['mode'] ?? 0;
      int innerfansw = jsonMap['overload1'] ?? 0;
      int heatfansw = jsonMap['overload3'] ?? 0;
      int compsw = jsonMap['overload2'] ?? 0;
      int feedbacksw = jsonMap['overload4'] ?? 0;
      int compfb = jsonMap['overload5'] ?? 0;
      String timeschen = jsonMap['timeschen'].toString();
      String timesch = jsonMap['timesch'].toString();
      int tmatched = jsonMap['tmatched'] ?? 0;
      condenserOl.value = condenserOLinput;
      compressorOl.value = compressorOLinput;
      lps.value = lpsinput;
      hps.value = hpsinput;
      ops.value = opsinput;
      innerFanFeedback.value = innerFanFbinput;
      heaterFeedback.value = heaterFbinput;
      compressorFeedback.value = compressorFbinput;
      compressor.value = compressorOutput;
      condenserFan.value = condenserOutput;
      innerFan.value = innerFanOutput;
      heater.value = heaterOutput;
      restartdelay.value = restartDelay;
      startdelay.value = startDelay;
      timematch.value = tmatched == 1;
      dxisOilPressureVisible.value = oilpressure == 1;
      dxisDischargePressureVisible.value = dispressure == 1;
      dxisSuctionPressureVisible.value = sucpressure == 1;
      dxisSwitchBoxVisible.value = oilsw == 1;
      dxisSuctionSwitchVisible.value = suctionsw == 1;
      dxisDischargeSwitchVisible.value = dischargesw == 1;
      dxisAutoSwitch.value = autoSwitch == 1;
      dxisAmpVisible.value = currentsw == 1;
      // dxisModeSwitch.value = selectionmode == 1;
      isSummer.value = seasonsw == 1;
      modeDx.value = mode == 1;
      dxisInnerVisible.value = innerfansw == 1;
      dxisHeatVisible.value = heatfansw == 1;
      dxisCompVisible.value = compsw == 1;
      dxisFbVisible.value = feedbacksw == 1;
      dxisCompFbVisible.value = compfb == 1;
      int psiToBar = int.tryParse(jsonMap['psiTobar'].toString()) ?? 0;
      int fToC = int.tryParse(jsonMap['ftoC'].toString()) ?? 0;
      dxftoC.value = fToC == 1;
      dxpsiTobar.value = psiToBar == 1;
      dxpressureUnit.value = pressureunit;
      dxpressureType.value = pressuretype;
      dxpressureRange.value = pressurerange;
      dxpressureUnit2.value = pressureunit2;
      dxpressureType2.value = pressuretype2;
      dxpressureRange2.value = pressurerange2;
      dxpressureUnit3.value = pressureunit3;
      dxpressureType3.value = pressuretype3;
      dxpressureRange3.value = pressurerange3;
      toggleValue.value = timeschen == "1";
      if (timesch.isNotEmpty &&
          timesch.contains('hoursch=') &&
          timesch.contains('daysch=')) {
        List<String> parts = timesch.split('|');
        String hoursPart = parts
            .firstWhere((e) => e.startsWith('hoursch='),
                orElse: () => 'hoursch=')
            .replaceFirst('hoursch=', '');
        String daysPart = parts
            .firstWhere((e) => e.startsWith('daysch='), orElse: () => 'daysch=')
            .replaceFirst('daysch=', '');

        List<String> hourStrings = hoursPart
            .split(',')
            .where((e) => e.trim().isNotEmpty && hours.contains(e))
            .toList();
        List<String> dayIndexes =
            daysPart.split(',').where((e) => e.trim().isNotEmpty).toList();

        selectedHour.assignAll(hourStrings);
        selectedDays.assignAll(dayIndexes.map((i) => days[int.parse(i)]));
      } else {
        selectedHour.clear();
        selectedDays.clear();
      }
    } catch (e) {
      log("Error parsing message: /pressureselection $e");
    }
  }

  Future<void> dxtoggleOilPressure(bool value) async {
    dxisOilLoading.value = true;
    dxisOilPressureVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxisOilLoading.value = false;
  }

  Future<void> dxtoggleDisPressure(bool value) async {
    dxisDisLoading.value = true;
    dxisDischargePressureVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxisDisLoading.value = false;
  }

  Future<void> dxtoggleSucPressure(bool value) async {
    dxisSucLoading.value = true;
    dxisSuctionPressureVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxisSucLoading.value = false;
  }

  Future<void> dxtoggleAmp(bool value) async {
    dxisAmpLoading.value = true;
    dxisAmpVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxisAmpLoading.value = false;
  }

  Future<void> dxtoggleInner(bool value) async {
    dxisInnerLoading.value = true;
    dxisInnerVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxisInnerLoading.value = false;
  }

  Future<void> dxtoggleHeat(bool value) async {
    dxisHeatLoading.value = true;
    dxisHeatVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxisHeatLoading.value = false;
  }

  Future<void> dxtoggleComp(bool value) async {
    dxisCompLoading.value = true;
    dxisCompVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxisCompLoading.value = false;
  }

  Future<void> dxtoggleFb(bool value) async {
    dxisFbLoading.value = true;
    dxisFbVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxisFbLoading.value = false;
  }

  Future<void> dxtogglecompfb(bool value) async {
    dxiscompfbLoading.value = true;
    dxisCompFbVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxiscompfbLoading.value = false;
  }

  RxBool dxoilSwLoading = false.obs;
  Future<void> dxtoggleSwitchBox(bool value) async {
    dxoilSwLoading.value = true;
    dxisSwitchBoxVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxoilSwLoading.value = false;
  }

  RxBool dxdischargeSwLoading = false.obs;
  Future<void> dxtoggleDischargeSwitch(bool value) async {
    dxdischargeSwLoading.value = true;
    dxisDischargeSwitchVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxdischargeSwLoading.value = false;
  }

  RxBool dxsuctionSwLoading = false.obs;
  Future<void> dxtoggleSuctionSwitch(bool value) async {
    dxsuctionSwLoading.value = true;
    dxisSuctionSwitchVisible.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxsuctionSwLoading.value = false;
  }

  RxBool dxautoSwLoading = false.obs;
  Future<void> dxautoSwitch(bool value) async {
    dxautoSwLoading.value = true;
    dxisAutoSwitch.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxautoSwLoading.value = false;
  }

  RxBool dxmodeSwLoading = false.obs;
  Future<void> dxmodeSwitch(bool value) async {
    dxmodeSwLoading.value = true;
    dxisModeSwitch.value = value;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 2));
    dxmodeSwLoading.value = false;
  }

  Future<void> selectModeDx(var mode) async {
    isUserInteracting.value = true;
    isModeLoading.value = true;
    modeDx.value = mode;
    publishTimer?.cancel();
    publishTimer = Timer(Duration(seconds: 1), () {
      log("Toggle value changed:");
      buildJsonPayloadDXPressure();
      publishTimer = Timer(Duration(seconds: 2), () {
        log("start publish");
        isUserInteracting.value = false;
      });
    });

    await Future.delayed(Duration(seconds: 3));
    isModeLoading.value = false;
  }

  Future<void> selectSeasonDx(var summer) async {
    isSeasonLoading.value = true;
    isSummer.value = summer;
    buildJsonPayloadDXPressure();
    await Future.delayed(Duration(seconds: 4));
    isSeasonLoading.value = false;
  }

  void dxbuildJsonPayloadSensor() {
    Map<String, dynamic> jsonPayload = {
      "offset${dxaddress1.value}": dxoffsett1.value,
      "offset${dxaddress2.value}": dxoffsett2.value,
      "offset${dxaddress3.value}": dxoffsett3.value,
      "offset${dxaddress4.value}": dxoffsett4.value,
      dxaddress1.value: dxselection1.value,
      dxaddress2.value: dxselection2.value,
      dxaddress3.value: dxselection3.value,
      dxaddress4.value: dxselection4.value,
    };
    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString);
  }

  void dxbuildJsonPayload() {
    Map<String, dynamic> jsonPayload = {
      "amp1": dxamp1.value.toString(),
      "amp2": dxamp2.value.toString(),
      "amp3": dxamp3.value.toString(),
      "temp1": dxtemp1.value.toString(),
      "temp2": dxtemp2.value.toString(),
      "temp3": dxtemp3.value.toString(),
      "temp4": dxtemp4.value.toString(),
      "psig1": dxpsig1.value.toString(),
      "psig2": dxpsig2.value.toString(),
      "psig3": dxpsig3.value.toString(),
      "temp1set_LOW": dxtemp1setlow.value.toString(),
      "temp2set_LOW": dxtemp2setlow.value.toString(),
      "temp3set_LOW": dxtemp3setlow.value.toString(),
      "temp4set_LOW": dxtemp4setlow.value.toString(),
      "psig1set_LOW": dxpsig1setlow.value.toString(),
      "psig2set_LOW": dxpsig2setlow.value.toString(),
      "psig3set_LOW": dxpsig3setlow.value.toString(),
      "temp1set_HIGH": dxtemp1sethigh.value.toString(),
      "temp2set_HIGH": dxtemp2sethigh.value.toString(),
      "temp3set_HIGH": dxtemp3sethigh.value.toString(),
      "temp4set_HIGH": dxtemp4sethigh.value.toString(),
      "psig1set_HIGH": dxpsig1sethigh.value.toString(),
      "psig2set_HIGH": dxpsig2sethigh.value.toString(),
      "psig3set_HIGH": dxpsig3sethigh.value.toString(),
      "AMP1_HIGH": dxamp1high.value.toString(),
      "AMP2_HIGH": dxamp2high.value.toString(),
      "AMP3_HIGH": dxamp3high.value.toString(),
      "AMP1_LOW": dxamp1low.value.toString(),
      "comp1status": dxcomp1status.value.toString(),
    };
    log("-----------------comp1status: ${comp1status.value}");

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

//AM_2:
  RxBool isAmpVisible = false.obs;
  RxBool isOilPressureVisible = false.obs;
  RxBool isSuctionPressureVisible = false.obs;
  RxBool isDischargePressureVisible = false.obs;

  RxBool isSwitchBoxVisible = false.obs;
  RxBool isSuctionSwitchVisible = false.obs;
  RxBool isDischargeSwitchVisible = false.obs;
  RxBool isAutoSwitch = false.obs;
  RxBool isModeSwitch = false.obs;
  RxBool isReturnTemp = false.obs;

  RxInt am2restartdelay = 0.obs;

  void _handleMessageAm2(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      amp1.value = int.tryParse(jsonMap['value0']?.toString() ?? '') ?? 0;
      amp2.value = int.tryParse(jsonMap['value8']?.toString() ?? '') ?? 0;
      amp3.value = int.tryParse(jsonMap['value9']?.toString() ?? '') ?? 0;
      temp1.value = double.tryParse('${jsonMap['value1']}') ?? 0.0;
      temp2.value = double.tryParse(jsonMap['value2']?.toString() ?? '') ?? 0;
      temp3.value = double.tryParse(jsonMap['value3']?.toString() ?? '') ?? 0;
      temp4.value = double.tryParse(jsonMap['value4']?.toString() ?? '') ?? 0;
      psig1.value = double.tryParse(jsonMap['value5']?.toString() ?? '') ?? 0.0;
      psig2.value = double.tryParse(jsonMap['value6']?.toString() ?? '') ?? 0.0;
      psig3.value = double.tryParse(jsonMap['value7']?.toString() ?? '') ?? 0.0;
      temp1setlow.value =
          int.tryParse(jsonMap['value10']?.toString() ?? '') ?? 0;
      temp2setlow.value =
          int.tryParse(jsonMap['value11']?.toString() ?? '') ?? 0;
      temp3setlow.value =
          int.tryParse(jsonMap['value12']?.toString() ?? '') ?? 0;
      temp4setlow.value =
          int.tryParse(jsonMap['value13']?.toString() ?? '') ?? 0;
      psig1setlow.value =
          int.tryParse(jsonMap['value14']?.toString() ?? '') ?? 0;
      psig2setlow.value =
          int.tryParse(jsonMap['value15']?.toString() ?? '') ?? 0;
      psig3setlow.value =
          int.tryParse(jsonMap['value16']?.toString() ?? '') ?? 0;
      temp1sethigh.value =
          int.tryParse(jsonMap['value21']?.toString() ?? '') ?? 0;
      temp2sethigh.value =
          int.tryParse(jsonMap['value22']?.toString() ?? '') ?? 0;
      temp3sethigh.value =
          int.tryParse(jsonMap['value23']?.toString() ?? '') ?? 0;
      temp4sethigh.value =
          int.tryParse(jsonMap['value24']?.toString() ?? '') ?? 0;
      psig1sethigh.value =
          int.tryParse(jsonMap['value25']?.toString() ?? '') ?? 0;

      psig2sethigh.value =
          int.tryParse(jsonMap['value26']?.toString() ?? '') ?? 0;
      psig3sethigh.value =
          int.tryParse(jsonMap['value27']?.toString() ?? '') ?? 0;
      amp1high.value = int.tryParse(jsonMap['value28']?.toString() ?? '') ?? 0;
      amp2high.value = int.tryParse(jsonMap['value29']?.toString() ?? '') ?? 0;
      amp3high.value = int.tryParse(jsonMap['value20']?.toString() ?? '') ?? 0;
      amp1low.value = int.tryParse(jsonMap['value17']?.toString() ?? '') ?? 0;
      amp2low.value = int.tryParse(jsonMap['value18']?.toString() ?? '') ?? 0;
      amp3low.value = int.tryParse(jsonMap['value19']?.toString() ?? '') ?? 0;
      comp1status.value =
          int.tryParse(jsonMap['value30']?.toString() ?? '') ?? 0;

      if (jsonMap.containsKey('value32')) {
        highpreswam2.value = jsonMap['value32'] == 'HIGH' ? 'HIGH' : 'LOW';
      }

      if (jsonMap.containsKey('value31')) {
        lowpreswam2.value = jsonMap['value31'] == 'HIGH' ? 'HIGH' : 'LOW';
      }
      if (jsonMap.containsKey('value33')) {
        oilpressureswam2.value = jsonMap['value33'] == 'LOW' ? 'LOW' : 'HIGH';
      }

      log("Updated connection List: $deviceConnections");
      log("Received MQTT Data:");
      log("amp1 = $amp1");
      log("amp2 = $amp2");
      log("amp3 = $amp3");
      log("temp1 = $temp1");
      log("temp2 = $temp2");
      log("temp3 = $temp3");
      log("temp4 = $temp4");
      log("psig1 = $psig1");
      log("psig2 = $psig2");
      log("psig3 = $psig3");
      log("temp1setlow = $temp1setlow");
      log("temp2setlow = $temp2setlow");
      log("temp3setlow = $temp3setlow");
      log("temp4setlow = $temp4setlow");
      log("psig1setlow = $psig1setlow");
      log("psig2setlow = $psig2setlow");
      log("psig3setlow = $psig3setlow");
      log("temp1sethigh = $temp1sethigh");
      log("temp2sethigh = $temp2sethigh");
      log("temp3sethigh = $temp3sethigh");
      log("temp4sethigh = $temp4sethigh");
      log("psig1sethigh = $psig1sethigh");
      log("psig2sethigh = $psig2sethigh");
      log("psig3sethigh = $psig3sethigh");
      log("amp1high = $amp1high");
      log("amp2high = $amp2high");
      log("amp3high = $amp3high");
      log("amp1low = $amp1low");
      log("amp2low = $amp2low");
      log("amp3low = $amp3low");
      log("-----------------comp1status = $comp1status");
    } catch (e) {
      log("Error parsing JSON: AM2 $e");
    }
  }

  void _handleMessageAm2Device(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String ip = jsonMap['ip_address']?.toString() ?? "";
      String mac = jsonMap['mac_address']?.toString() ?? "";
      temp3setlow.value =
          int.tryParse(jsonMap['value12']?.toString() ?? '') ?? 0;
      String topicid = topics.split('/').last;
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
      log('Updating SharedPreferences with IP and MAC... $ip');
    } catch (e) {
      log("Error parsing JSON: AM2 $e");
    }
  }

  void buildJsonPayload() {
    Map<String, dynamic> jsonPayload = {
      "amp1": amp1.value.toString(),
      "amp2": amp2.value.toString(),
      "amp3": amp3.value.toString(),
      "temp1": temp1.value.toString(),
      "temp2": temp2.value.toString(),
      "temp3": temp3.value.toString(),
      "temp4": temp4.value.toString(),
      "psig1": psig1.value.toString(),
      "psig2": psig2.value.toString(),
      "psig3": psig3.value.toString(),
      "temp1set_LOW": temp1setlow.value.toString(),
      "temp2set_LOW": temp2setlow.value.toString(),
      "temp3set_LOW": temp3setlow.value.toString(),
      "temp4set_LOW": temp4setlow.value.toString(),
      "psig1set_LOW": psig1setlow.value.toString(),
      "psig2set_LOW": psig2setlow.value.toString(),
      "psig3set_LOW": psig3setlow.value.toString(),
      "temp1set_HIGH": temp1sethigh.value.toString(),
      "temp2set_HIGH": temp2sethigh.value.toString(),
      "temp3set_HIGH": temp3sethigh.value.toString(),
      "temp4set_HIGH": temp4sethigh.value.toString(),
      "psig1set_HIGH": psig1sethigh.value.toString(),
      "psig2set_HIGH": psig2sethigh.value.toString(),
      "psig3set_HIGH": psig3sethigh.value.toString(),
      "AMP1_HIGH": amp1high.value.toString(),
      "AMP2_HIGH": amp2high.value.toString(),
      "AMP3_HIGH": amp3high.value.toString(),
      "AMP1_LOW": amp1low.value.toString(),
      "AMP2_LOW": amp2low.value.toString(),
      "AMP3_LOW": amp3low.value.toString(),
      "comp1status": comp1status.value.toString(),
    };
    log("comp1status: ${comp1status.value}");

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

//return sp
  void updateChillInlp(double value) {
    temp1sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //return alert
  void updateChillInhp(double value) {
    temp1setlow.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //suction sp
  void updateSuctionLow(double value) {
    temp3sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //suction pressure
  void updateLowPressurelp(double value) {
    psig1sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  // discharge pressure
  void updateHighPressurehp(double value) {
    psig2setlow.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //oil pressure
  void updateOilPressurelp(double value) {
    psig3sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //Ampere sp
  void updatePhase1hp(double value) {
    amp1low.value = value.toInt();
    buildJsonPayload();
    update();
  }

// discharge sp
  void updateDischargeHigh(double value) {
    temp4setlow.value = value.toInt();
    buildJsonPayload();
    update();
  }

//AM2-Sensors Config

  void _handleMessageSensor(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String temp1 = jsonMap['temp1']?.toString() ?? "0";
      String temp2 = jsonMap['temp2']?.toString() ?? "0";
      String temp3 = jsonMap['temp3']?.toString() ?? "0";
      String temp4 = jsonMap['temp4']?.toString() ?? "0";
      String offset1 = jsonMap['offset1']?.toString() ?? "0";
      String offset2 = jsonMap['offset2']?.toString() ?? "0";
      String offset3 = jsonMap['offset3']?.toString() ?? "0";
      String offset4 = jsonMap['offset4']?.toString() ?? "0";
      sensorTemp1.value = temp1;
      sensorTemp2.value = temp2;
      sensorTemp3.value = temp3;
      sensorTemp4.value = temp4;
      offsett1.value = offset1;
      offsett2.value = offset2;
      offsett3.value = offset3;
      offsett4.value = offset4;
    } catch (e) {
      log("Error parsing message: ZM $e");
    }
  }

  void _handleMessageSensorAm2444(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String temp1 = jsonMap['temp1']?.toString() ?? "0";
      String temp2 = jsonMap['temp2']?.toString() ?? "0";
      String temp3 = jsonMap['temp3']?.toString() ?? "0";
      String temp4 = jsonMap['temp4']?.toString() ?? "0";
      String offset1 = jsonMap['offset1']?.toString() ?? "0";
      String offset2 = jsonMap['offset2']?.toString() ?? "0";
      String offset3 = jsonMap['offset3']?.toString() ?? "0";
      String offset4 = jsonMap['offset4']?.toString() ?? "0";
      String aaddress1 = jsonMap['address1']?.toString() ?? "0";
      String aaddress2 = jsonMap['address2']?.toString() ?? "0";
      String aaddress3 = jsonMap['address3']?.toString() ?? "0";
      String aaddress4 = jsonMap['address4']?.toString() ?? "0";
      String address1select = jsonMap[aaddress1]?.toString() ?? "0";
      String address2select = jsonMap[aaddress2]?.toString() ?? "0";
      String address3select = jsonMap[aaddress3]?.toString() ?? "0";
      String address4select = jsonMap[aaddress4]?.toString() ?? "0";
      sensorTemp1.value = temp1;
      sensorTemp2.value = temp2;
      sensorTemp3.value = temp3;
      sensorTemp4.value = temp4;
      offsett1.value = offset1;
      offsett2.value = offset2;
      offsett3.value = offset3;
      offsett4.value = offset4;

      selection1Am2.value = address1select;
      selection2Am2.value = address2select;
      selection3Am2.value = address3select;
      selection4Am2.value = address4select;
      address1Am2.value = aaddress1;
      address2Am2.value = aaddress2;
      address3Am2.value = aaddress3;
      address4Am2.value = aaddress4;
    } catch (e) {
      log("Error parsing message: ZM $e");
    }
  }

  void _handleMessagePressure(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String pressure_type = jsonMap['pressure_type']?.toString() ?? "0";
      String pressure_range = jsonMap['pressure_range']?.toString() ?? "0";
      int pressure_unit = jsonMap['pressure_unit'] ?? false;
      String pressure_type2 = jsonMap['pressure_type2']?.toString() ?? "0";
      String pressure_range2 = jsonMap['pressure_range2']?.toString() ?? "0";
      int pressure_unit2 = jsonMap['pressure_unit2'] ?? false;
      String pressure_type3 = jsonMap['pressure_type3']?.toString() ?? "0";
      String pressure_range3 = jsonMap['pressure_range3']?.toString() ?? "0";
      int pressure_unit3 = jsonMap['pressure_unit3'] ?? false;
      int oilpressure = jsonMap['oilpressure'] ?? 0;
      int dispressure = jsonMap['dispressure'] ?? 0;
      int sucpressure = jsonMap['sucpressure'] ?? 0;
      int oilsw = jsonMap['oilsw'] ?? 0;
      int suctionsw = jsonMap['suctionsw'] ?? 0;
      int dischargesw = jsonMap['dischargesw'] ?? 0;
      int autoSwitch = jsonMap['autoSwitch'] ?? 0;
      int currentsw = jsonMap['currentsw'] ?? 0;
      int mode = jsonMap['mode'] ?? 0;
      int returnTempSelection = jsonMap['returnTempSelection'] ?? 0;
      am2restartdelay.value =
          int.tryParse(jsonMap['restartdelay']?.toString() ?? '') ?? 0;
      isOilPressureVisible.value = oilpressure == 1;
      isDischargePressureVisible.value = dispressure == 1;
      isSuctionPressureVisible.value = sucpressure == 1;
      isSwitchBoxVisible.value = oilsw == 1;
      isSuctionSwitchVisible.value = suctionsw == 1;
      isDischargeSwitchVisible.value = dischargesw == 1;
      isAutoSwitch.value = autoSwitch == 1;
      isAmpVisible.value = currentsw == 1;
      isModeSwitch.value = mode == 1;
      isReturnTemp.value = returnTempSelection == 1;
      int psiToBar = int.tryParse(jsonMap['psiTobar'].toString()) ?? 0;
      int fToC = int.tryParse(jsonMap['ftoC'].toString()) ?? 0;
      ftoC.value = fToC == 1;
      psiTobar.value = psiToBar == 1;
      pressureUnit.value = pressure_unit == 1;
      pressureType.value = pressure_type;
      pressureRange.value = pressure_range;
      pressureUnit2.value = pressure_unit2 == 1;
      pressureType2.value = pressure_type2;
      pressureRange2.value = pressure_range2;
      pressureUnit3.value = pressure_unit3 == 1;
      pressureType3.value = pressure_type3;
      pressureRange3.value = pressure_range3;
      log("Pressure unit: $pressureUnit");
      log("Pressure Range: $pressureRange");
      log("Pressure type: $pressureType");
    } catch (e) {
      log("Error parsing message: /pressureselection $e");
    }
  }

  void buildJsonPayloadSensor() {
    Map<String, dynamic> jsonPayload = {
      "offset1": offsett1.value,
      "offset2": offsett2.value,
      "offset3": offsett3.value,
      "offset4": offsett4.value,
    };
    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString);
  }

  void buildJsonPayloadAm2444Sensor() {
    Map<String, dynamic> jsonPayload = {
      "offset${address1Am2.value}": offsett1.value,
      "offset${address2Am2.value}": offsett2.value,
      "offset${address3Am2.value}": offsett3.value,
      "offset${address4Am2.value}": offsett4.value,
      address1Am2.value: selection1Am2.value,
      address2Am2.value: selection2Am2.value,
      address3Am2.value: selection3Am2.value,
      address4Am2.value: selection4Am2.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString);
  }

  void buildJsonPayloadPressure() {
    Map<String, dynamic> jsonPayload = {
      "pressure_type": pressureType.value,
      "pressure_range": pressureRange.value,
      "pressure_unit": pressureUnit.value ? 1 : 0,
      "pressure_type2": pressureType2.value,
      "pressure_range2": pressureRange2.value,
      "pressure_unit2": pressureUnit2.value ? 1 : 0,
      "pressure_type3": pressureType3.value,
      "pressure_range3": pressureRange3.value,
      "pressure_unit3": pressureUnit3.value ? 1 : 0,
      "ftoC": ftoC.value ? 1 : 0,
      "psiTobar": psiTobar.value ? 1 : 0,
      "oilpressure": isOilPressureVisible.value ? 1 : 0,
      "dispressure": isDischargePressureVisible.value ? 1 : 0,
      "sucpressure": isSuctionPressureVisible.value ? 1 : 0,
      "oilsw": isSwitchBoxVisible.value ? 1 : 0,
      "suctionsw": isSuctionSwitchVisible.value ? 1 : 0,
      "dischargesw": isDischargeSwitchVisible.value ? 1 : 0,
      "autoSwitch": isAutoSwitch.value ? 1 : 0,
      "currentsw": isAmpVisible.value ? 1 : 0,
      "mode": isModeSwitch.value ? 1 : 0,
      "returnTempSelection": isReturnTemp.value ? 1 : 0,
      "restartdelay": am2restartdelay.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessagepressure(jsonString);
  }

  Future<void> toggleOilPressure(bool value) async {
    isOilLoading.value = true;
    isOilPressureVisible.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    isOilLoading.value = false;
  }

  Future<void> toggleDisPressure(bool value) async {
    isDisLoading.value = true;
    isDischargePressureVisible.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    isDisLoading.value = false;
  }

  Future<void> toggleSucPressure(bool value) async {
    isSucLoading.value = true;
    isSuctionPressureVisible.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    isSucLoading.value = false;
  }

  Future<void> toggleAmp(bool value) async {
    isAmpLoading.value = true;
    isAmpVisible.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    isAmpLoading.value = false;
  }

  RxBool oilSwLoading = false.obs;
  Future<void> toggleSwitchBox(bool value) async {
    oilSwLoading.value = true;
    isSwitchBoxVisible.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    oilSwLoading.value = false;
  }

  RxBool dischargeSwLoading = false.obs;
  Future<void> toggleDischargeSwitch(bool value) async {
    dischargeSwLoading.value = true;
    isDischargeSwitchVisible.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    dischargeSwLoading.value = false;
  }

  RxBool suctionSwLoading = false.obs;
  Future<void> toggleSuctionSwitch(bool value) async {
    suctionSwLoading.value = true;
    isSuctionSwitchVisible.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    suctionSwLoading.value = false;
  }

  RxBool autoSwLoading = false.obs;
  Future<void> autoSwitch(bool value) async {
    autoSwLoading.value = true;
    isAutoSwitch.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    autoSwLoading.value = false;
  }

//New
  RxBool autoReturnTempLoading = false.obs;
  Future<void> autoReturnTemp(bool value) async {
    autoReturnTempLoading.value = true;
    isReturnTemp.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    autoReturnTempLoading.value = false;
  }

  RxBool modeSwLoading = false.obs;
  Future<void> modeSwitch(bool value) async {
    modeSwLoading.value = true;
    isModeSwitch.value = value;
    buildJsonPayloadPressure();
    await Future.delayed(Duration(seconds: 2));
    modeSwLoading.value = false;
  }

  void publishMessageSensor(String message) {
    String topic = "/test/$topicSSIDvalue/2";
    if (client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: false,
        );
        log('Message published to $topic: $message');
      } catch (e) {
        log('Failed to publish message: $e');
      }
    }
  }

  void publishMessagepressure(String message) {
    String topic = "/test/$topicSSIDvalue/3";
    if (client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: false,
        );
        log('Message published to $topic: $message');
      } catch (e) {
        log('Failed to publish message: $e');
      }
    }
  }



//RMS
//  RxBool isSummerRms = false.obs;
  RxInt acswitch = 0.obs;
  RxBool damperSw = false.obs;
  RxInt curtainSw = 0.obs;
  RxInt shutterSw = 0.obs;
  RxInt smarttv = 0.obs;
  RxInt voicecontrol = 0.obs;
  RxInt doorlock = 0.obs;
  RxInt motionsensor = 0.obs;
  RxInt roomlight1 = 0.obs;
  RxInt roomlight2 = 0.obs;
  RxInt roomfan = 0.obs;
  RxInt carbonMono = 25.obs;
  RxDouble light1value = 50.0.obs;
  RxDouble light2value = 10.0.obs;
  RxDouble curtainValue = 70.0.obs;
  RxDouble acTemp = 20.0.obs;
  RxDouble shutterValue = 70.0.obs;
  RxDouble roomfanIntensity = 50.0.obs;

//rms handle message
  void rmsMessageReceived(String messages, topic) {
    try {
      Map<String, dynamic> data = jsonDecode(messages);

      // 1. Handle Integers (Direct assignments)
      
    
      //  String seasonsw = data['seasonsw'];

      acswitch.value = data['acSwitch'] ?? 0;
      curtainSw.value = data['curtainsw'] ?? 0;
      shutterSw.value = data['shuttersw'] ?? 0;
      smarttv.value = data['smartTv'] ?? 0;
      roomlight1.value = data['Light1'] ?? 0;
      roomlight2.value = data['Light2'] ?? 0;
      roomfan.value = data['roomFan'] ?? 0;
      damperSw.value = data['dampersw'].toString() == "1";
      isSummer.value = data['season'].toString() == "1";

        // isSummerRms.value = seasonsw == "1";
      temperature.value = double.tryParse(data['dmptemp'].toString()) ?? 0.0;
      lastDamperValue.value = int.tryParse(data['dmptempsp'].toString()) ?? 0;
      currentValue.value = double.tryParse(data['cfm'].toString()) ?? 0.0;
      flapstate.value = data['dampstate']?.toString() ?? "CLOSE";

      light1value.value =
          double.tryParse(data['light1intense'].toString()) ?? 0.0;
      light2value.value =
          double.tryParse(data['light2intense'].toString()) ?? 0.0;
      curtainValue.value =
          double.tryParse(data['curtainintense'].toString()) ?? 0.0;
      shutterValue.value =
          double.tryParse(data['shutterintense'].toString()) ?? 0.0;
      roomfanIntensity.value =
          double.tryParse(data['roomfanintense'].toString()) ?? 0.0;
      acTemp.value = double.tryParse(data['actemp'].toString()) ?? 0.0;
    } catch (e) {
      log("❌ Error processing MQTT message: $e");
    }
  }

  void buildJsonPayloadRms() {
    Map<String, dynamic> jsonPayload = {
      //  "seasonsw": isSummerRms.value ? 1 : 0,
      "acSwitch": acswitch.value,
      "curtainsw": curtainSw.value,
      "shuttersw": shutterSw.value,
      "smartTv": smarttv.value,
      "Light1": roomlight1.value,
      "Light2": roomlight2.value,
      "roomFan": roomfan.value,
      "light1intense": light1value.value,
      "light2intense": light2value.value,
      "curtainintense": curtainValue.value,
      "shutterintense": shutterValue.value,
      "roomfanintense": roomfanIntensity.value,
      "season": isSummer.value ? "1" : "0",
      "dmptempsp": lastDamperValue.value,
      "dampersw": damperSw.value ? "1" : "0",
      "cfm": currentValue.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

//TELECOME:
  RxDouble tempTel = 0.0.obs;
  RxDouble humidityTel = 0.0.obs;
  RxInt tempSetPointTel = 0.obs;
  RxInt humiditySetPointTel = 0.obs;
  RxInt tempAlertTel = 0.obs;
  RxInt unitOneTel = 0.obs;
  RxInt unitTwoTel = 0.obs;
  RxInt tOneTel = 1.obs;
  RxInt tTwoTel = 1.obs;
  RxInt tThreeTel = 1.obs;
  RxInt systemStatusTel = 0.obs;
  RxBool systemSwitchTel = false.obs;

  RxBool systemSwitchTelLoading = false.obs;
  Future<void> switchTel(bool value) async {
    systemSwitchTelLoading.value = true;
    systemSwitchTel.value = value;
    buildJsonPayloadTel();
    await Future.delayed(Duration(seconds: 2));
    systemSwitchTelLoading.value = false;
  }

//T-1
  void tempOneSetpoint(double value) {
    tOneTel.value = value.toInt();
    buildJsonPayloadTel();
    update();
  }

//T-2
  void tempTwoSetpoint(double value) {
    tTwoTel.value = value.toInt();
    buildJsonPayloadTel();
    update();
  }

  //T-3
  void tempThreeSetpoint(double value) {
    tThreeTel.value = value.toInt();
    buildJsonPayloadTel();
    update();
  }

  // Temperature Setpoint
  void tempSetpoint(double value) {
    tempSetPointTel.value = value.toInt();
    buildJsonPayloadTel();
    update();
  }

  //Humidity Setpoint
  void humiditySetpoint(double value) {
    humiditySetPointTel.value = value.toInt();
    buildJsonPayloadTel();
    update();
  }

//temperature Alert
  void tempaAlert(double value) {
    tempAlertTel.value = value.toInt();
    buildJsonPayloadTel();
    update();
  }

  void telMessageReceived(String messages, topic) {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String temp = data['temp'].toString();
      String humidity = data['humidity'].toString();
      String tempSetPoint = data['tempSetPoint'].toString();
      String humiditySetPoint = data['humiditySetPoint'].toString();
      String tempAlert = data['tempAlert']?.toString() ?? '0';
      String tOne = data['tOne'].toString();
      String tTwo = data['tTwo'].toString();
      String tThree = data['tThree'].toString();

      String systemStatus = data['systemStatus'].toString();
      int unitOne = int.tryParse(data['unitOne'].toString()) ?? 0;
      int unitTwo = int.tryParse(data['unitTwo'].toString()) ?? 0;
      int systemSwitch = data['systemSwitch'] ?? 0;
      systemSwitchTel.value = systemSwitch == 1;
      tempTel.value = double.tryParse(temp) ?? 0.0;
      humidityTel.value = double.tryParse(humidity) ?? 0.0;
      tempSetPointTel.value = int.tryParse(tempSetPoint) ?? 0;
      humiditySetPointTel.value = int.tryParse(humiditySetPoint) ?? 0;
      tempAlertTel.value = int.tryParse(tempAlert) ?? 0;
      unitOneTel.value = unitOne;
      unitTwoTel.value = unitTwo;
      tOneTel.value = int.tryParse(tOne) ?? 0;
      tTwoTel.value = int.tryParse(tTwo) ?? 0;
      tThreeTel.value = int.tryParse(tThree) ?? 0;
      systemStatusTel.value = int.tryParse(systemStatus) ?? 0;
    } catch (e) {
      log("❌ Error processing MQTT message: $e");
    }
  }

  //Telecome Notification
  Map<String, Map<String, double>> lastHumidityAlertSent = {};

  void _handleHumidityMessageNotification(String message, String topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String topicid = topics.split('/').last;
      int systemSwitch = jsonMap['systemSwitch'] ?? 0;
      String temp = jsonMap['temp'].toString();
      String tempAlert = jsonMap['tempAlert']?.toString() ?? '0';
      tempTel.value = double.tryParse(temp) ?? 0.0;
      systemSwitchTel.value = systemSwitch == 1;
      tempAlertTel.value = int.tryParse(tempAlert) ?? 0;
      humidityTel.value =
          double.tryParse(jsonMap['humidity']?.toString() ?? '') ?? 0.0;
      humiditySetPointTel.value =
          int.parse(jsonMap['humiditySetPoint']?.toString() ?? '');
      log("systemswitch $systemSwitchTel");
      if (systemSwitchTel.value == true) {
        checkAndNotifyHumidity(
          value: humidityTel.value.toString(),
          deviceid: topicid,
          status: "High",
          id: "humidity_alert",
          condition: humidityTel.value >= humiditySetPointTel.value,
          title: 'Room Humidity',
          type: "humidity",
        );
        checkAndNotifyHumidity(
          value: tempTel.value.toString(),
          deviceid: topicid,
          status: "High",
          id: "temperature_alert",
          condition: tempTel.value >= tempAlertTel.value,
          title: 'Room Temperature',
          type: "temperature",
        );
      }
    } catch (e) {
      log("Error parsing humidity message: $e");
    }
  }

  void checkAndNotifyHumidity({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastHumidityAlertSent.containsKey(deviceid)) {
      lastHumidityAlertSent[deviceid] = {};
    }

    final deviceMap = lastHumidityAlertSent[deviceid]!;

    if (condition) {
      double? parsed = double.tryParse(value.toString());
      if (parsed == null) return;
      double roundedValue = parsed.floorToDouble();
      double? lastValue = deviceMap[id];
      log("Humidity check → Device: $deviceid, Sensor: $id, Prev: $lastValue, New: $roundedValue");
      if (lastValue == null || lastValue != roundedValue) {
        deviceMap[id] = roundedValue;
        if (type == "humidity") {
          _notificationControllerTel.showHumidityAlertNotification(
            deviceid,
            title,
            status,
            parsed,
          );
        } else if (type == "temperature") {
          _notificationControllerTel.showTemperatureAlertNotification(
              deviceid, title, status, parsed);
        }
        saveLastNotifiedValuesTel();
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValuesTel();
    }
  }

  Future<void> saveLastNotifiedValuesTel() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lastHumidityAlertSent.map(
      (deviceId, map) =>
          MapEntry(deviceId, map.map((key, val) => MapEntry(key, val))),
    ));
    await prefs.setString('last_notified_valuesTel', encoded);
  }

  void handleMessageTelDevice(String messages, topic) async {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String ip = data['ip_address']?.toString() ?? "";
      String mac = data['mac_address']?.toString() ?? "";
      String topicid = topic.split('/').last;
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
      receivedData.value = data;
    } catch (e) {
      log("❌ Error processing MQTT message of CM2: $e");
    }
  }

  void buildJsonPayloadTel() {
    Map<String, dynamic> jsonPayload = {
      "tempSetPoint": tempSetPointTel.value.toString(),
      "humiditySetPoint": humiditySetPointTel.value.toString(),
      "tempAlert": tempAlertTel.value.toString(),
      "tOne": tOneTel.value.toString(),
      "tTwo": tTwoTel.value.toString(),
      "tThree": tThreeTel.value.toString(),
      "systemSwitch": systemSwitchTel.value ? 1 : 0,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }
// GREEN HOUSE (GHS)

  void onMessageGHSReceived(String messages, topic) {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String pumpstate = data['pumpstate'].toString();
      String temp = data['temp'].toString();
      String humidity = data['humidity'].toString();
      String humiditySp = data['humiditySp'].toString();
      ghspump.value = pumpstate.toString();
      tempGhs.value = double.tryParse(temp) ?? 0.0;
      humidityGhs.value = double.tryParse(humidity) ?? 0.0;
      humiditySetPointGhs.value = int.tryParse(humiditySp) ?? 0;
      ghsPower.value = data['maincontrol'].toString() == '1';
      log("JSON of GHS: $data ");
    } catch (e) {
      log("❌ Error processing MQTT message: $e");
    }
  }

  void buildJsonPayloadGHS() {
    Map<String, dynamic> jsonPayload = {
      "humiditySp": humiditySetPointGhs.value.toString(),
      "maincontrol": ghsPower.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void updateGhsPower(bool status) {
    ghsPower.value = status;
    buildJsonPayloadGHS();
  }

  void updateSetpointGhs(double value) {
    humiditySetPointGhs.value = value.toInt();
    buildJsonPayloadGHS();
    update();
  }

//DM1

  void handleMessageDMDevice(String messages, topic) async {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String ip = data['ip_address']?.toString() ?? "";
      String mac = data['mac_address']?.toString() ?? "";
      String topicid = topic.split('/').last;
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
      receivedData.value = data;
    } catch (e) {
      log("❌ Error processing MQTT message of CM2: $e");
    }
  }

  void onMessageDMReceived(String messages, topic) {
    try {
      log("water level message: $level");
      Map<String, dynamic> data = jsonDecode(messages);
      String waterlevel = data['waterlevel'].toString();
      String pumpstate = data['pumpstate'].toString();
      dmpump.value = pumpstate.toString();
      dmpumpSwitch.value = data['pumpsw'].toString() == "1";
      dmpumpcontrol.value = data['pumpcontrol'].toString() == '1';
      drainPower.value = data['maincontrol'].toString() == '1';
      wtcdelay.value = int.tryParse(data['systemDelay']?.toString() ?? '') ?? 0;
      level.value = int.parse(waterlevel.toString()).clamp(0, 2);
      log("water level message: $level");
    } catch (e) {
      log("❌ Error processing MQTT message: $e");
    }
  }

  void buildJsonPayloadDM() {
    Map<String, dynamic> jsonPayload = {
      "maincontrol": drainPower.value,
      "pumpcontrol": dmpumpcontrol.value,
      "pumpsw": dmpumpSwitch.value,
      "systemDelay": wtcdelay.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void updateDrainPower(bool status) {
    drainPower.value = status;
    buildJsonPayloadDM();
  }

  void updateDMPumpAutomation(bool status) {
    dmpumpcontrol.value = status;
    buildJsonPayloadDM();
  }

  void toggleDMSwitch(int index) {
    dmpumpSwitch.value = !dmpumpSwitch.value;

    buildJsonPayloadDM();
  }

  //DM1 Notification
  void _handleMessageNotificationDm1(String message, String topics) async {
    try {
      Map<String, dynamic> data = jsonDecode(message);
      String topicid = topics.split('/').last;
      String waterlevel = data['waterlevel'].toString();
      drainPower.value = data['maincontrol'].toString() == '1';
      level.value = int.parse(waterlevel.toString()).clamp(0, 2);

      if (isNotiInteracting == true && drainPower.value == true) {
        // Waterlevel Alert
        checkAndNotifyDm1(
          value: "",
          deviceid: topicid,
          status: "Overflow",
          id: "waterlevel",
          condition: level.value == 2,
          title: 'Water Level -',
          type: "switch",
        );
      }
    } catch (e) {
      log("Error parsing Temperature message: $e");
    }
  }

  Map<String, Map<String, double>> lastNotifiedValuePerDeviceDm1 = {};
  void checkAndNotifyDm1({
    required String deviceid,
    required String id,
    required bool condition,
    required String title,
    var value,
    required String type,
    required String status,
  }) {
    if (!lastNotifiedValuePerDeviceDm1.containsKey(deviceid)) {
      lastNotifiedValuePerDeviceDm1[deviceid] = {};
    }
    final deviceMap = lastNotifiedValuePerDeviceDm1[deviceid]!;
    if (condition) {
      if (type == "switch") {
        if (!deviceMap.containsKey(id)) {
          deviceMap[id] = 0; // dummy value
          _notificationControllerDm1.showSwitchAlertNotification(
              deviceid, title, status, value);
          saveLastNotifiedValuesDm1(); // Save updated state
        }
      }
    } else {
      deviceMap.remove(id);
      saveLastNotifiedValuesDm1();
    }
  }

//WTC
  void handleMessageWTCDevice(String messages, topic) async {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String ip = data['ip_address']?.toString() ?? "";
      String mac = data['mac_address']?.toString() ?? "";
      String topicid = topic.split('/').last;
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
      receivedData.value = data;
    } catch (e) {
      log("❌ Error processing MQTT message of CM2: $e");
    }
  }

  void onMessageWTCReceived(String messages, topic) {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String temp1sp = data['temp1sp'].toString();
      String fanstate = data['fanstate'].toString();
      String pumpstate = data['pumpstate'].toString();
      String temp1 = data['temp1'].toString();
      String waterlevel = data['waterlevel'].toString();
      int tmatched = data['tmatched'] ?? 0;
      String timeschen = data['timeschen'];
      String timesch = data['timesch'];
      wtcfanSwitch.value = data['fansw'].toString() == "1";
      wtcpumpSwitch.value = data['pumpsw'].toString() == "1";
      wtcuserSetValue.value = int.parse(waterlevel.toString()).clamp(0, 2);
      wtcmaincontrol.value = data['maincontrol'].toString() == '1';
      wtcfancontrol.value = data['fancontrol'].toString() == '1';
      wtcpumpcontrol.value = data['pumpcontrol'].toString() == '1';
      toggleValue.value = timeschen == "1";
      tmatch.value = tmatched == 1;
      wtclastCMValue.value = int.parse(temp1sp);
      wtcfan.value = fanstate.toString();
      wtcpump.value = pumpstate.toString();
      wtccmtemperature.value = temp1.toString();
      log("JSON MTC: $data ");
      //
      if (timesch.isNotEmpty &&
          timesch.contains('hoursch=') &&
          timesch.contains('daysch=')) {
        List<String> parts = timesch.split('|');
        String hoursPart = parts
            .firstWhere((e) => e.startsWith('hoursch='),
                orElse: () => 'hoursch=')
            .replaceFirst('hoursch=', '');
        String daysPart = parts
            .firstWhere((e) => e.startsWith('daysch='), orElse: () => 'daysch=')
            .replaceFirst('daysch=', '');

        List<String> hourStrings = hoursPart
            .split(',')
            .where((e) => e.trim().isNotEmpty && hours.contains(e))
            .toList();
        List<String> dayIndexes =
            daysPart.split(',').where((e) => e.trim().isNotEmpty).toList();

        selectedHour.assignAll(hourStrings);
        selectedDays.assignAll(dayIndexes.map((i) => days[int.parse(i)]));
      } else {
        selectedHour.clear();
        selectedDays.clear();
      }
      receivedData.value = data;
      log("✅ Received MQTT Data: $data");
    } catch (e) {
      log("❌ Error processing MQTT message: $e");
    }
  }

  void wtctoggleSwitch(int index) {
    wtcpumpSwitch.value = !wtcpumpSwitch.value;

    update();
    wtcsendUpdatedState();
  }

  void wtctoggleSwitchf(int index) {
    wtcfanSwitch.value = !wtcfanSwitch.value;

    update();
    wtcsendUpdatedState();
  }

  void wtcsendUpdatedState() {
    if (!Get.isRegistered<MqttController>()) return;

    Map<String, dynamic> data = Map<String, dynamic>.from(wtcreceivedData);

    data['fansw'] = wtcfanSwitch.value ? 1 : 0;
    data['pumpsw'] = wtcpumpSwitch.value ? 1 : 0;

    wtcsendData(data);
  }

  void updateTemperaturewtc(double newTemp) {
    wtclastCMValue.value = newTemp.toInt();
    update();
  }

  void wtcupdatePower(bool status) {
    wtcmaincontrol.value = status;
    wtcreceivedData['maincontrol'] = status ? "1" : "0";
    wtcreceivedData.refresh();
    wtcsendData(Map<String, dynamic>.from(wtcreceivedData));
  }

  void wtcupdatePumpAutomation(bool status) {
    wtcpumpcontrol.value = status;
    wtcreceivedData['pumpcontrol'] = status ? "1" : "0";
    wtcreceivedData.refresh();
    wtcsendData(Map<String, dynamic>.from(wtcreceivedData));
  }

  void wtcupdateFanAutomation(bool status) {
    wtcfancontrol.value = status;
    wtcreceivedData['fancontrol'] = status ? "1" : "0";
    wtcreceivedData.refresh();
    wtcsendData(Map<String, dynamic>.from(wtcreceivedData));
  }

  void wtcsendData(Map<String, dynamic> receivedData,
      {int? switchIndex, int? switchState}) {
    Map<String, dynamic> jsonData = {
      "maincontrol": wtcmaincontrol.value,
      "fancontrol": wtcfancontrol.value,
      "pumpcontrol": wtcpumpcontrol.value,
      "temp1sp": wtclastCMValue.value,
      "fansw": wtcfanSwitch.value,
      "pumpsw": wtcpumpSwitch.value,
      "timesch": result.value,
      "timeschen": toggleValue.value ? 1 : 0,
    };

    String jsonString = jsonEncode(jsonData);
    log("📤 Sending MQTT Message: $jsonString");

    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonString);

    if (builder.payload == null || builder.payload!.isEmpty) {
      log("❌ MQTT Payload is empty! Message not sent.");
      return;
    }

    client?.publishMessage("/test/${topicSSIDvalue.value}/1",
        MqttQos.atMostOnce, builder.payload!);
    log("✅ MQTT Message Sent Successfully!");
  }

//CONTROL:

  void onMessageReceived(String messages, topic) {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String temp1sp = data['temp1sp'].toString();
      String fanstate = data['fanstate'].toString();
      String pumpstate = data['pumpstate'].toString();
      fanSwitch.value = data['fansw'].toString() == "1";
      String temp1 = data['temp1'].toString();
      String waterlevel = data['waterlevel'].toString();
      pumpSwitch.value = data['pumpsw'].toString() == "1";
      userSetValue.value = int.parse(waterlevel.toString()).clamp(0, 2);
      maincontrol.value = data['maincontrol'].toString() == '1';
      fancontrol.value = data['fancontrol'].toString() == '1';
      pumpcontrol.value = data['pumpcontrol'].toString() == '1';
      lastCMValue.value = double.parse(temp1sp);
      fan.value = fanstate.toString();
      pump.value = pumpstate.toString();
      cmtemperature.value = temp1.toString();

      log("temp1: $temp1 ");
      log("temp1sp: $temp1sp ");
      log("fanSwitch: $fanSwitch ");
      log("pumpSwitch: $pumpSwitch ");
      log("fanstate: $fanstate ");
      log("pumpstate: $pumpstate ");
      log("waterlevel: $waterlevel ");
      log("maincontrol: $maincontrol ");

      receivedData.value = data;
      log("✅ Received MQTT Data: $data");
    } catch (e) {
      log("❌ Error processing MQTT message: $e");
    }
  }

  void toggleSwitch(int index) {
    pumpSwitch.value = !pumpSwitch.value;

    update();
    sendUpdatedState();
  }

  void toggleSwitchf(int index) {
    fanSwitch.value = !fanSwitch.value;

    update();
    sendUpdatedState();
  }

  void sendUpdatedState() {
    if (!Get.isRegistered<MqttController>()) return;

    Map<String, dynamic> data = Map<String, dynamic>.from(receivedData);

    data['fansw'] = fanSwitch.value ? 1 : 0;
    data['pumpsw'] = pumpSwitch.value ? 1 : 0;

    sendData(data);
  }

  void updatePower(bool status) {
    maincontrol.value = status;
    receivedData['maincontrol'] = status ? "1" : "0";
    receivedData.refresh();
    sendData(Map<String, dynamic>.from(receivedData));
  }

  void updatePumpAutomation(bool status) {
    pumpcontrol.value = status;
    receivedData['pumpcontrol'] = status ? "1" : "0";
    receivedData.refresh();
    sendData(Map<String, dynamic>.from(receivedData));
  }

  void updateFanAutomation(bool status) {
    fancontrol.value = status;
    receivedData['fancontrol'] = status ? "1" : "0";
    receivedData.refresh();
    sendData(Map<String, dynamic>.from(receivedData));
  }

  void sendData(Map<String, dynamic> receivedData,
      {int? switchIndex, int? switchState}) {
    Map<String, dynamic> jsonData = {
      "maincontrol": maincontrol.value,
      "fancontrol": fancontrol.value,
      "pumpcontrol": pumpcontrol.value,
      "temp1sp": lastCMValue.value,
      "fansw": fanSwitch.value,
      "pumpsw": pumpSwitch.value,
    };

    String jsonString = jsonEncode(jsonData);
    log("📤 Sending MQTT Message: $jsonString");

    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonString);

    if (builder.payload == null || builder.payload!.isEmpty) {
      log("❌ MQTT Payload is empty! Message not sent.");
      return;
    }

    client?.publishMessage("/test/${topicSSIDvalue.value}/1",
        MqttQos.atMostOnce, builder.payload!);
    log("✅ MQTT Message Sent Successfully!");
  }

  void handleMessageCm2Device(String messages, topic) async {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String ip = data['ip_address']?.toString() ?? "";
      String mac = data['mac_address']?.toString() ?? "";
      String topicid = topic.split('/').last;
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
      receivedData.value = data;
    } catch (e) {
      log("❌ Error processing MQTT message of CM2: $e");
    }
  }

//RMS ip and mac
  void handleMessageRmsDevice(String messages, topic) async {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      String ip = data['ip_address']?.toString() ?? "";
      String mac = data['mac_address']?.toString() ?? "";
      String topicid = topic.split('/').last;
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
      receivedData.value = data;
    } catch (e) {
      log("❌ Error processing MQTT message of CM2: $e");
    }
  }

//Aqua master
  void aquaReceive(String message, topic) {
    try {
      Map<String, dynamic> data = jsonDecode(message);
      String waterlevel = data['waterlevel'].toString();
      String temp1 = data['temp1'].toString();
      String temp2 = data['temp2'].toString();
      String seasonsw = data['seasonsw'].toString();
      int mode = data['mode'] ?? 0;
      int tmatched = data['tmatched'] ?? 0;
      int boostersw = data['boostersw'] ?? 0;
      int makeupsw = data['makeupsw'] ?? 0;
      int crculatonsw = data['crculatonsw'] ?? 0;
      int boilersw = data['boilersw'] ?? 0;
      int coolersw = data['coolersw'] ?? 0;
      int comfortersw = data['comfortersw'];
      String boilersp = data['boilersp'].toString();
      String coolersp = data['coolersp'].toString();
      String comfortersp = data['comfortersp'].toString();
      String boosterstate = data['boosterstate'].toString();
      String makeupstate = data['makeupstate'].toString();
      String crculatonstate = data['crculatonstate'].toString();
      String coolerstate = data['coolerstate'].toString();
      String boilerstate = data['boilerstate'].toString();
      String comfortstate = data['comforterstate'].toString();
      String timeschen = data['timeschen'].toString();
      String timesch = data['timesch'].toString();
      modeAqm.value = mode == 1;
      tmatch.value = tmatched == 1;
      isSummer.value = seasonsw == "1";
      boilerTemp.value = temp1;
      comfortAndCoolerTemp.value = temp2;
      toggleValue.value = timeschen == "1";
      boosterState.value = boosterstate.toString();
      recirculorState.value = crculatonstate.toString();
      makeupState.value = makeupstate.toString();
      coolerState.value = coolerstate.toString();
      boilerState.value = boilerstate.toString();
      comfortState.value = comfortstate.toString();
      coolerSp.value = coolersp.toString();
      boilerSp.value = boilersp.toString();
      comfortSp.value = comfortersp.toString();
      userSetValue.value = int.parse(waterlevel.toString()).clamp(0, 2);
      boosterSwitch.value = boostersw;
      makeupSwitch.value = makeupsw;
      recirculorSwitch.value = crculatonsw;
      boilerSwitch.value = boilersw;
      coolerSwitch.value = coolersw;
      comfortSwitch.value = comfortersw;

      if (timesch.isNotEmpty &&
          timesch.contains('hoursch=') &&
          timesch.contains('daysch=')) {
        List<String> parts = timesch.split('|');
        String hoursPart = parts
            .firstWhere((e) => e.startsWith('hoursch='),
                orElse: () => 'hoursch=')
            .replaceFirst('hoursch=', '');
        String daysPart = parts
            .firstWhere((e) => e.startsWith('daysch='), orElse: () => 'daysch=')
            .replaceFirst('daysch=', '');

        List<String> hourStrings = hoursPart
            .split(',')
            .where((e) => e.trim().isNotEmpty && hours.contains(e))
            .toList();
        List<String> dayIndexes =
            daysPart.split(',').where((e) => e.trim().isNotEmpty).toList();

        selectedHour.assignAll(hourStrings);
        selectedDays.assignAll(dayIndexes.map((i) => days[int.parse(i)]));
      } else {
        selectedHour.clear();
        selectedDays.clear();
      }
      log("✅ Received MQTT Data: $data");
    } catch (e) {
      log("Error processing MQTT message: $e");
      log("Raw message: $message");
    }
  }

  void changeCooler(double value) {
    coolerSp.value = value.toStringAsFixed(0);
    coolerSp.refresh();
  }

  void changeBoiler(double value) {
    boilerSp.value = value.toStringAsFixed(0);
    boilerSp.refresh();
  }

  void changeComfort(double value) {
    comfortSp.value = value.toStringAsFixed(0);
    comfortSp.refresh();
  }

  void handleMessageAquaDevice(String message, topic) async {
    try {
      Map<String, dynamic> data = jsonDecode(message);
      String ip = data['ip_address']?.toString() ?? "";
      String mac = data['mac_address']?.toString() ?? "";
      String topicid = topic.split('/').last;
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );

      log("handling message of AQUA Device");
    } catch (e) {
      log("❌ Error processing MQTT message of AQUA: $e");
    }
  }

  void showBottomSheetSeason() {
    Get.bottomSheet(
      Seasonsheet(),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void showBottomSheetMode() {
    Get.bottomSheet(
      ModeSheet(),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future<void> selectSeasonAQM(var summer) async {
    isSeasonLoading.value = true;
    isSummer.value = summer;
    buildJsonPayloadAQM();
    await Future.delayed(Duration(seconds: 2));
    isSeasonLoading.value = false;
  }

  Future<void> selectModeAQM(var mode) async {
    isModeLoading.value = true;
    modeAqm.value = mode;
    buildJsonPayloadModeAQM();
    await Future.delayed(Duration(seconds: 4));
    isModeLoading.value = false;
  }

  void bottomSheetboosterButton(String title) {
    Get.bottomSheet(
      ThreeModeToggle(
        mode: boosterSwitch,
        label: 'booster_pump'.tr,
        onChanged: (val) {
          boosterSwitch.value = val;
          buildJsonPayloadAQM();
        },
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void bottomSheetmakeButton(String title) {
    Get.bottomSheet(
      ThreeModeToggle(
        mode: makeupSwitch,
        label: 'makeup_pump'.tr,
        onChanged: (val) {
          makeupSwitch.value = val;
          buildJsonPayloadAQM();
        },
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void bottomSheetreciculorButton(String title) {
    Get.bottomSheet(
      ThreeModeToggle(
        mode: recirculorSwitch,
        label: 'recirculation_pump'.tr,
        onChanged: (val) {
          recirculorSwitch.value = val;
          buildJsonPayloadAQM();
        },
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void buildJsonPayloadAQM() {
    Map<String, dynamic> jsonPayload = {
      "seasonsw": isSummer.value ? 1 : 0,
      "makeupsw": makeupSwitch.value,
      "crculatonsw": recirculorSwitch.value,
      "boostersw": boosterSwitch.value,
      "timesch": result.value,
      "timeschen": toggleValue.value ? 1 : 0,
      "coolersp": coolerSp.value,
      "boilersp": boilerSp.value,
      "comfortersp": comfortSp.value,
      "coolersw": coolerSwitch.value,
      "boilersw": boilerSwitch.value,
      "comfortersw": comfortSwitch.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void buildJsonPayloadModeAQM() {
    Map<String, dynamic> jsonPayload = {
      "mode": modeAqm.value ? 1 : 0,
    };
    String jsonString = jsonEncode(jsonPayload);
    publishMessagepressure(jsonString);
  }

  Map<String, dynamic> lastKnownValues = {
    "seasonsw": 1,
    "coolersp": 25,
    "boilersp": 26,
    "comfortersp": 27,
    "coolersw": 0,
    "boilersw": 0,
    "comfortersw": 0,
    "boostersw": 0,
    "makeupsw": 0,
    "crculatonsw": 0,
  };

  void sendDataAqua(Map<String, dynamic> receivedData,
      {int? switchIndex, int? switchState}) {
    // Create a map to hold the current data, starting with the last known values
    Map<String, dynamic> jsonData = {
      "seasonsw": receivedData["seasonsw"] ?? lastKnownValues["seasonsw"],
      "coolersp": receivedData["coolersp"] ?? lastKnownValues["coolersp"],
      "boilersp": receivedData["boilersp"] ?? lastKnownValues["boilersp"],
      "comfortersp":
          receivedData["comfortersp"] ?? lastKnownValues["comfortersp"],
      "coolersw": receivedData["coolersw"] ?? lastKnownValues["coolersw"],
      "boilersw": receivedData["boilersw"] ?? lastKnownValues["boilersw"],
      "comfortersw":
          receivedData["comfortersw"] ?? lastKnownValues["comfortersw"],
      "boostersw": receivedData["boostersw"] ?? lastKnownValues["boostersw"],
      "makeupsw": receivedData["makeupsw"] ?? lastKnownValues["makeupsw"],
      "crculatonsw":
          receivedData["crculatonsw"] ?? lastKnownValues["crculatonsw"]
    };

    lastKnownValues["seasonsw"] = jsonData["seasonsw"];
    lastKnownValues["coolersp"] = jsonData["coolersp"];
    lastKnownValues["boilersp"] = jsonData["boilersp"];
    lastKnownValues["comfortersp"] = jsonData["comfortersp"];
    lastKnownValues["coolersw"] = jsonData["coolersw"];
    lastKnownValues["boilersw"] = jsonData["boilersw"];
    lastKnownValues["comfortersw"] = jsonData["comfortersw"];
    lastKnownValues["boostersw"] = jsonData["boostersw"];
    lastKnownValues["makeupsw"] = jsonData["makeupsw"];
    lastKnownValues["crculatonsw"] = jsonData["crculatonsw"];

    if (switchIndex != null && switchState != null) {
      jsonData["switches"] ??= [];

      bool switchFound = false;
      for (var switchItem in jsonData["switches"]) {
        if (switchItem["switch_index"] == switchIndex) {
          switchItem["switch_state"] = switchState;
          switchFound = true;
          break;
        }
      }

      if (!switchFound) {
        jsonData["switches"]
            .add({"switch_index": switchIndex, "switch_state": switchState});
      }
    }

    // Convert the data to a JSON string
    String jsonString = jsonEncode(jsonData);
    log("📤 Sending MQTT Message: $jsonString");

    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonString);

    if (builder.payload == null || builder.payload!.isEmpty) {
      log("❌ MQTT Payload is empty! Message not sent.");
      return;
    }

    // Send the MQTT message
    client?.publishMessage(
        "/test/$topicSSIDvalue/1", MqttQos.atMostOnce, builder.payload!);
    log("✅ MQTT Message Sent Successfully!");
  }

  void _handleMessageAQMSensor(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String temp1 = jsonMap['temp1']?.toString() ?? "0";
      String temp2 = jsonMap['temp2']?.toString() ?? "0";
      String offset1 = jsonMap['offset1']?.toString() ?? "0";
      String offset2 = jsonMap['offset2']?.toString() ?? "0";
      sensorAquaTemp1.value = temp1;
      sensorAquaTemp2.value = temp2;
      offset1Aqua.value = offset1;
      offset2Aqua.value = offset2;
    } catch (e) {
      log("Error parsing message: ZM $e");
    }
  }

  void buildJsonPayloadAQMSensor() {
    Map<String, dynamic> jsonPayload = {
      "offset1": offset1Aqua.value,
      "offset2": offset2Aqua.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString);
  }

// alert master 01
  void toggleButton() {
    toggle.value = !toggle.value;
  }

  // RxBool colorStatus = false.obs;
  void _handleMessageAm1(String message, topic) async {
    try {
      Map<String, dynamic> data = jsonDecode(message);
      tempsp2.value = int.tryParse(data['tempsp2']?.toString() ?? '') ?? 0;
      tempsp1.value = int.tryParse(data['tempsp1']?.toString() ?? '') ?? 0;
      tempsphigh.value =
          int.tryParse(data['tempsphigh']?.toString() ?? '') ?? 0;
      tempsplow.value = int.tryParse(data['tempsplow']?.toString() ?? '') ?? 0;
      pressuresp1.value = int.tryParse(data["pressuresp1"].toString()) ?? 0;
      pressuresp2.value = int.tryParse(data["pressuresp2"].toString()) ?? 0;
      gastype.value = int.tryParse(data["gastype"].toString()) ?? 0;
      dischargelinetemp.value =
          double.tryParse(data["dischargelinetemp"].toString()) ?? 0.0;
      suctionlinetemp.value =
          double.tryParse(data["suctionlinetemp"].toString()) ?? 0.0;
      supplylinetemp.value =
          double.tryParse(data["supplylinetemp"].toString()) ?? 0.0;
      returnlinetemp.value =
          double.tryParse(data["returnlinetemp"].toString()) ?? 0.0;
      dischargelinetempF.value =
          double.tryParse(data["dischargelinetempF"].toString()) ?? 0.0;
      suctionlinetempF.value =
          double.tryParse(data["suctionlinetempF"].toString()) ?? 0.0;
      supplylinetempF.value =
          double.tryParse(data["supplylinetempF"].toString()) ?? 0.0;
      returnlinetempF.value =
          double.tryParse(data["returnlinetempF"].toString()) ?? 0.0;
      dischargepressure.value =
          double.tryParse(data["dischargepressure"].toString()) ?? 0.0;
      suctionpressure.value =
          double.tryParse(data["suctionpressure"].toString()) ?? 0.0;
      dischargepressureF.value =
          double.tryParse(data["dischargepressureF"].toString()) ?? 0.0;
      suctionpressureF.value =
          double.tryParse(data["suctionpressureF"].toString()) ?? 0.0;
      comprsw.value = int.tryParse(data["comprsw"].toString()) ?? 0;

      if (data.containsKey('highpresw')) {
        highpresw.value = data['highpresw'] == 'HIGH' ? 'HIGH' : 'LOW';
      }
      if (data.containsKey('lowpresw')) {
        lowpresw.value = data['lowpresw'] == 'LOW' ? 'LOW' : 'HIGH';
      }
      if (data.containsKey('oilpressure')) {
        oilpressuream1.value = data['oilpressure'] == 'LOW' ? 'LOW' : 'HIGH';
      }
      log("tempsp1 = ${tempsp1.value}");
      log("tempsp2 = ${tempsp2.value}");
      log("tempsp3 = ${tempsp3.value}");
      log("tempsplow = ${tempsplow.value}");
      log("tempsphigh = ${tempsphigh.value}");
      log("pressuresp1 = ${pressuresp1.value}");
      log("pressuresp2 = ${pressuresp2.value}");
      log("pressuresp3 = ${pressuresp3.value}");
      log("dischargelinetemp = ${dischargelinetemp.value}");
      log("suctionlinetemp = ${suctionlinetemp.value}");
      log("supplylinetemp = ${supplylinetemp.value}");
      log("returnlinetemp = ${returnlinetemp.value}");
      log("gastype = ${gastype.value}");
      log("dischargepressure = ${dischargepressure.value}");
      log("suctionpressure = ${suctionpressure.value}");
      log("dxstate = ${comprsw.value}");
      log("IP_ADDRESS = ${ip.value}");
    } catch (e) {
      log("Error parsing JSON: AM1 $e");
    }
  }

  void handleMessageAm1Device(String message, topic) async {
    try {
      Map<String, dynamic> data = jsonDecode(message);
      String ip = data['ip_address']?.toString() ?? "";
      String mac = data['mac_address']?.toString() ?? "";
      String topicid = topic.split('/').last;
      await SharedPreferencesService().updateDeviceData(
        deviceId: topicid,
        updatedIp: ip,
        updatedMac: mac,
      );
    } catch (e) {
      log("Error parsing JSON: AM1 $e");
    }
  }

  void buildJsonPayloadAm1() {
    Map<String, dynamic> jsonPayload = {
      "tempsp1": tempsp1.value.toString(),
      "gastype": gastype.value,
      "tempsp2": tempsp2.value.toString(),
      "tempsplow": tempsplow.value.toString(),
      "tempsphigh": tempsphigh.value.toString(),
      "pressuresp1": pressuresp1.value.toString(),
      "pressuresp2": pressuresp2.value.toString(),
      "dischargelinetemp": dischargelinetemp.value.toString(),
      "suctionlinetemp": suctionlinetemp.value.toString(),
      "returnlinetemp": returnlinetemp.value.toString(),
      "dischargepressure": dischargepressure.value.toString(),
      "suctionpressure": suctionpressure.value.toString(),
      "comprsw": comprsw.value.toString(),
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

// sensor AM1
  void _handleMessageAm1Sensor(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String temp1 = jsonMap['temp1']?.toString() ?? "0.0";
      String temp2 = jsonMap['temp2']?.toString() ?? "0.0";
      String temp3 = jsonMap['temp3']?.toString() ?? "0.0";
      String temp4 = jsonMap['temp4']?.toString() ?? "0.0";
      String offset1 = jsonMap['offset1']?.toString() ?? "0";
      String offset2 = jsonMap['offset2']?.toString() ?? "0";
      String offset3 = jsonMap['offset3']?.toString() ?? "0";
      String offset4 = jsonMap['offset4']?.toString() ?? "0";
      int psiToBar = int.tryParse(jsonMap['psiTobar'].toString()) ?? 0;
      int fToC = int.tryParse(jsonMap['ftoC'].toString()) ?? 0;
      int oilsw = jsonMap['oilsw'] ?? 0;
      int sw = jsonMap['switch'] ?? 0;
      int swEn = jsonMap['switchEn'] ?? 0;
      int suctionsw = jsonMap['suctionsw'] ?? 0;
      int dischargesw = jsonMap['dischargesw'] ?? 0;
      int autoSwitch = jsonMap['autoSwitch'] ?? 0;
      int mode = jsonMap['mode'] ?? 0;
      int returnTempSelection = jsonMap['returnTempSelection'] ?? 0;
      am1restartdelay.value =
          int.tryParse(jsonMap['restartdelay']?.toString() ?? '') ?? 0;
      isReturnTempam1.value = returnTempSelection == 1;
      isModeSwitchAm1.value = mode == 1;
      isAutoSwitchAm1.value = autoSwitch == 1;
      showOilPressure.value = oilsw == 1;
      systemSwitchAm1.value = sw == 1;
      powerSwitchen.value = swEn == 1;
      showSuctionPressure.value = suctionsw == 1;
      showDischargePressure.value = dischargesw == 1;
      ftoC1.value = fToC == 1;
      psiTobar1.value = psiToBar == 1;
      sensorAm1Temp1.value = temp1;
      sensorAm1Temp2.value = temp2;
      sensorAm1Temp3.value = temp3;
      sensorAm1Temp4.value = temp4;
      offsett1Am1.value = offset1;
      offsett2Am1.value = offset2;
      offsett3Am1.value = offset3;
      offsett4Am1.value = offset4;
    } catch (e) {
      log("Error parsing message: ZM $e");
    }
  }

// sensor AM1-444
  void _handleMessageAm1444Sensor(String message, topics) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String offset1 = jsonMap['offset1']?.toString() ?? "0";
      String offset2 = jsonMap['offset2']?.toString() ?? "0";
      String offset3 = jsonMap['offset3']?.toString() ?? "0";
      String offset4 = jsonMap['offset4']?.toString() ?? "0";
      String temp1 = jsonMap['temp1']?.toString() ?? "0";
      String temp2 = jsonMap['temp2']?.toString() ?? "0";
      String temp3 = jsonMap['temp3']?.toString() ?? "0";
      String temp4 = jsonMap['temp4']?.toString() ?? "0";
      String aaddress1 = jsonMap['address1']?.toString() ?? "0";
      String aaddress2 = jsonMap['address2']?.toString() ?? "0";
      String aaddress3 = jsonMap['address3']?.toString() ?? "0";
      String aaddress4 = jsonMap['address4']?.toString() ?? "0";
      String address1select = jsonMap[aaddress1]?.toString() ?? "0";
      String address2select = jsonMap[aaddress2]?.toString() ?? "0";
      String address3select = jsonMap[aaddress3]?.toString() ?? "0";
      String address4select = jsonMap[aaddress4]?.toString() ?? "0";
      int psiToBar = int.tryParse(jsonMap['psiTobar'].toString()) ?? 0;
      int fToC = int.tryParse(jsonMap['ftoC'].toString()) ?? 0;
      int oilsw = jsonMap['oilsw'] ?? 0;
      int sw = jsonMap['switch'] ?? 0;
      int swEn = jsonMap['switchEn'] ?? 0;
      int suctionsw = jsonMap['suctionsw'] ?? 0;
      int dischargesw = jsonMap['dischargesw'] ?? 0;
      int autoSwitch = jsonMap['autoSwitch'] ?? 0;
      int mode = jsonMap['mode'] ?? 0;
      int returnTempSelection = jsonMap['returnTempSelection'] ?? 0;
      am1restartdelay.value =
          int.tryParse(jsonMap['restartdelay']?.toString() ?? '') ?? 0;
      isReturnTempam1.value = returnTempSelection == 1;
      isModeSwitchAm1.value = mode == 1;
      isAutoSwitchAm1.value = autoSwitch == 1;
      showOilPressure.value = oilsw == 1;
      systemSwitchAm1.value = sw == 1;
      powerSwitchen.value = swEn == 1;
      showSuctionPressure.value = suctionsw == 1;
      showDischargePressure.value = dischargesw == 1;
      ftoC1.value = fToC == 1;
      psiTobar1.value = psiToBar == 1;
      sensorAm1Temp1.value = temp1;
      sensorAm1Temp2.value = temp2;
      sensorAm1Temp3.value = temp3;
      sensorAm1Temp4.value = temp4;
      selection1Am1.value = address1select;
      selection2Am1.value = address2select;
      selection3Am1.value = address3select;
      selection4Am1.value = address4select;
      address1Am1.value = aaddress1;
      address2Am1.value = aaddress2;
      address3Am1.value = aaddress3;
      address4Am1.value = aaddress4;
      offsett1Am1.value = offset1;
      offsett2Am1.value = offset2;
      offsett3Am1.value = offset3;
      offsett4Am1.value = offset4;
    } catch (e) {
      log("Error parsing message: aM1-444 $e");
    }
  }

  void buildJsonPayloadAm1Sensor() {
    Map<String, dynamic> jsonPayload = {
      "ftoC": ftoC1.value ? 1 : 0,
      "psiTobar": psiTobar1.value ? 1 : 0,
      "oilsw": showOilPressure.value ? 1 : 0,
      "suctionsw": showSuctionPressure.value ? 1 : 0,
      "dischargesw": showDischargePressure.value ? 1 : 0,
      "switch": systemSwitchAm1.value ? 1 : 0,
      "switchEn": powerSwitchen.value ? 1 : 0,
      "autoSwitch": isAutoSwitchAm1.value ? 1 : 0,
      "mode": isModeSwitchAm1.value ? 1 : 0,
      "returnTempSelection": isReturnTempam1.value ? 1 : 0,
      "restartdelay": am1restartdelay.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString);
  }

  void buildJsonPayloadAm1ASensor() {
    Map<String, dynamic> jsonPayload = {
      "offset1": offsett1Am1.value,
      "offset2": offsett2Am1.value,
      "offset3": offsett3Am1.value,
      "offset4": offsett4Am1.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString);
  }

  void buildJsonPayloadAm1444Sensor() {
    Map<String, dynamic> jsonPayload = {
      "offset${address1Am1.value}": offsett1Am1.value,
      "offset${address2Am1.value}": offsett2Am1.value,
      "offset${address3Am1.value}": offsett3Am1.value,
      "offset${address4Am1.value}": offsett4Am1.value,
      address1Am1.value: selection1Am1.value,
      address2Am1.value: selection2Am1.value,
      address3Am1.value: selection3Am1.value,
      address4Am1.value: selection4Am1.value,
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessageSensor(jsonString);
  }

//AM1
  RxBool showOilPressure = false.obs;
  RxBool powerSwitchen = false.obs;
  RxBool showSuctionPressure = false.obs;
  RxBool showDischargePressure = false.obs;
  RxInt am1restartdelay = 0.obs;
  RxBool isAutoSwitchAm1 = false.obs;
  RxBool isReturnTempam1 = false.obs;
  RxBool isModeSwitchAm1 = false.obs;

  RxBool systemSwitchAm1 = false.obs;
  RxBool systemSwitchAm1Loading = false.obs;
  Future<void> switchAm1(bool value) async {
    systemSwitchAm1Loading.value = true;
    systemSwitchAm1.value = value;
    buildJsonPayloadAm1Sensor();
    await Future.delayed(Duration(seconds: 2));
    systemSwitchAm1Loading.value = false;
  }

  RxBool swLoadingAm1 = false.obs;
  Future<void> toggleAm1Switch(bool value) async {
    swLoadingAm1.value = true;
    powerSwitchen.value = value;
    buildJsonPayloadAm1Sensor();
    await Future.delayed(Duration(seconds: 2));
    swLoadingAm1.value = false;
  }

  RxBool oilSwLoadingAm1 = false.obs;
  Future<void> toggleAm1OilPressure(bool value) async {
    oilSwLoadingAm1.value = true;
    showOilPressure.value = value;
    buildJsonPayloadAm1Sensor();
    await Future.delayed(Duration(seconds: 2));
    oilSwLoadingAm1.value = false;
  }

  RxBool suctionSwLoadingAm1 = false.obs;
  Future<void> toggleAm1Suction(bool value) async {
    suctionSwLoadingAm1.value = true;
    showSuctionPressure.value = value;
    buildJsonPayloadAm1Sensor();
    await Future.delayed(Duration(seconds: 2));
    suctionSwLoadingAm1.value = false;
  }

  RxBool dischargeSwLoadingAm1 = false.obs;
  Future<void> toggleAm1Discharge(bool value) async {
    dischargeSwLoadingAm1.value = true;
    showDischargePressure.value = value;
    buildJsonPayloadAm1Sensor();
    await Future.delayed(Duration(seconds: 2));
    dischargeSwLoadingAm1.value = false;
  }

  RxBool autoSwLoadingAm1 = false.obs;
  Future<void> autoSwitchAm1(bool value) async {
    autoSwLoadingAm1.value = true;
    isAutoSwitchAm1.value = value;
    buildJsonPayloadAm1Sensor();
    await Future.delayed(Duration(seconds: 2));
    autoSwLoadingAm1.value = false;
  }

  RxBool am1autoReturnTempLoading = false.obs;
  Future<void> am1autoReturnTemp(bool value) async {
    am1autoReturnTempLoading.value = true;
    isReturnTempam1.value = value;
    buildJsonPayloadAm1Sensor();
    await Future.delayed(Duration(seconds: 2));
    am1autoReturnTempLoading.value = false;
  }

  void am1ReturnAlert(double value) {
    tempsphigh.value = value.toInt();
    buildJsonPayloadAm1();
    update();
  }

  void am1SpAlert(double value) {
    tempsplow.value = value.toInt();
    buildJsonPayloadAm1();
    update();
  }

  void am1SuctionSpAlert(double value) {
    tempsp2.value = value.toInt();
    buildJsonPayloadAm1();
    update();
  }

  void am1DischargeSpAlert(double value) {
    tempsp1.value = value.toInt();
    buildJsonPayloadAm1();
    update();
  }

  void suctionPressure(double value) {
    pressuresp1.value = value.toInt();
    buildJsonPayloadAm1();
    update();
  }

  void dischargePressure(double value) {
    pressuresp2.value = value.toInt();
    buildJsonPayloadAm1();
    update();
  }

  RxBool modeSwLoadingAm1 = false.obs;
  Future<void> modeSwitchAm1(bool value) async {
    modeSwLoadingAm1.value = true;
    isModeSwitchAm1.value = value;
    buildJsonPayloadAm1Sensor();
    await Future.delayed(Duration(seconds: 2));
    modeSwLoadingAm1.value = false;
  }

  void gasestype(String sp) {
    gastype.value = int.tryParse(sp) ?? 0;
    buildJsonPayloadAm1();
  }
}
