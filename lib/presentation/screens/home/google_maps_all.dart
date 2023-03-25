import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gdsc/model/polyline_response.dart';


class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {

  late GoogleMapController  googleMapController;

  // TODO: initial position 要改成可以直接載入current position
  static const CameraPosition initialPosition = CameraPosition(target: LatLng(25.0173405, 121.5397518), zoom: 14.6);
  LatLng origin = LatLng(25.0173405, 121.5397518); // 起點座標
  LatLng destination = LatLng(25.1184723, 121.4726081); // 終點座標

  // Hospital Info
  List HospitalPlace = [];
  static const LatLng ntuHospital = LatLng(25.041124305644598, 121.51922015767175);
  static const LatLng taipeiCityHospital = LatLng(25.035616895471925, 121.50700374232824);
  static const LatLng shaoYiHospital = LatLng(25.04400060300501, 121.53110407116414);
  String apiKey = "AIzaSyDzZTGh8AbCt4RVmWlo74HbqxxTYU4DRPU"; // API KEY

  String totalDistance = "";
  String totalTime = "";
  String travelMethod = "";
  String placeID ="";


  //  TODO: Polyline的畫線方法
  PolylineResponse polylineResponse = PolylineResponse();
  Set<Polyline> polylinePoints = {};

  Set<Marker> markers = {};
  int markerIdCounter = 1;


  Set<Circle> circles = {};
  var radiusValue = 3000.0;
  var placeInfo;
  var placeinfoResponse;
  var polylineInfo;

  // page view
  String placeImg = '';
  String placeAddr = '';

  // TODO: 1. 按下按鈕顯示方圓幾百公尺的點 (NearbySearch)
  // TODO: 2. 找最近、標所有marker


  // Use these bool var to control whether showing an object or not
  bool if_pointInfo = false;
  bool if_direction = false;
  bool is_review = true;
  bool is_photo = false;
  bool showBlankCard = false;
  bool showHospital = false;
  var photoGalleryIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find the kidney hospital"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            polylines: polylinePoints, // 點也要在Map裡 才會顯示在地圖
            initialCameraPosition: initialPosition, // 當前位置
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller){
              googleMapController = controller;
            },
            onTap: (point){
              if_pointInfo = false;
              if_direction = false;
              polylinePoints.clear();
              setState(() { });
            },
          ),
          // 顯示路徑和時間
          if_direction?
            Positioned(
                top: 10,
                left: 10,
                child: Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("By: " + travelMethod),
                    Text("Total Distance: \n" + totalDistance),
                    Text("Total Time: \n" + totalTime),
                  ],
                ),)) : Container(),

          // flipcard
          if_pointInfo ?
              Positioned(
                  top: 100.0,
                  left: 15.0,
                  child: FlipCard(
                    front: Container(
                      height: 250.0,
                      width: 175.0,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: SingleChildScrollView(
                          child: Column(children: [
                            Container(
                              height: 130.0,
                              width: 175.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0),),
                                  image: DecorationImage(image: NetworkImage(placeImg != "" ?
                                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$apiKey'
                                      :'https://pic.onlinewebfonts.com/svg/img_546302.png' ),
                                      fit: BoxFit.cover)),
                            ),
                            // 地址
                            Container(
                              padding: EdgeInsets.all(7.0), // 上下左右添加空白 7 pixel
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Address: ", style: TextStyle(fontFamily: 'WorkSans', fontSize: 12.0, fontWeight: FontWeight.w500),),
                                  Container(
                                    width: 105.0,
                                    child: Text(
                                      placeInfo['formatted_address'] ?? 'none given',
                                      style: const TextStyle(fontFamily: 'WorkSans', fontSize: 12.0, fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // 電話
                            Container(
                              padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0), // 指定上下左右空白區域
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Contact: ", style: TextStyle(fontFamily: 'WorkSans', fontSize: 12.0, fontWeight: FontWeight.w500),),
                                  Container(
                                    width: 105.0,
                                    child: Text(
                                      placeInfo['formatted_phone_number'] ?? 'none given',
                                      style: const TextStyle(fontFamily: 'WorkSans', fontSize: 12.0, fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // 營業狀態
                            Container(
                              padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0), // 指定上下左右空白區域
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Status: ", style: TextStyle(fontFamily: 'WorkSans', fontSize: 12.0, fontWeight: FontWeight.w500),),
                                  Container(
                                    width: 105.0,
                                    child: Text(
                                      placeInfo['business_status'] ?? 'none given',
                                      style: const TextStyle(fontFamily: 'WorkSans', fontSize: 12.0, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ])
                      ),
                    ),
                    back: Container(
                      height: 300.0,
                      width: 225.0,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(8.0)),
                      child: Column(
                        children: [
                          Padding( // 這邊是選擇要按哪個分頁符號
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () { setState(() { is_review = true; is_photo = false;});},
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 700),
                                    curve: Curves.easeIn,
                                    padding: EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11.0),
                                        color: is_review ? Colors.green.shade300 : Colors.white),
                                    child: Text(
                                      'Reviews',
                                      style: TextStyle(
                                          color: is_review ? Colors.white : Colors.black87,
                                          fontFamily: 'WorkSans',
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                GestureDetector( // 顯示圖片
                                  onTap: () { setState(() { is_review = false; is_photo = true;});},
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 700),
                                    curve: Curves.easeIn,
                                    padding: EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11.0),
                                        color: is_photo ? Colors.green.shade300 : Colors.white),
                                    child: Text(
                                      'Photos',
                                      style: TextStyle(
                                          color: is_photo ? Colors.white : Colors.black87,
                                          fontFamily: 'WorkSans',
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container( // 這邊是下面的內容
                            height: 250.0,
                            child: is_review
                                ? ListView(
                              children: [
                                if (is_review && placeInfo['reviews'] != null)
                                  ...placeInfo['reviews']!.map((e) { return _buildReviewItem(e);}) // TODO: 查這個用法
                              ],
                            )
                                : _buildPhotoGallery( placeInfo['photos'] ?? []),
                          )
                        ],
                      ),
                    ),
                  )
              ): Container(),
        ]
      ),
      floatingActionButton: Stack(
        children: [
          // 顯示nearbyHospital 按鈕
          Positioned(
            top: 110,
            right: 3,
            child: Container( // TODO: 相機縮放
              alignment: Alignment.topLeft,
              // margin: const EdgeInsets.all(10),
              child: FloatingActionButton.extended(
                onPressed: () async{
                  final Uint8List markerIcon = await getBytesFromAsset('assets/mapicons/health-medical.png', 40); // 要在ymal add assets 加 - assets/mapicons/ 才能讀到
                  if(!showHospital){
                    _setMarker("臺大醫院", "台北市中正區中山南路 7 號", ntuHospital, "ChIJlblYxnOpQjQR_7C_sDPc4P0", markerIcon);
                    _setMarker("臺北市立聯合醫院", "台北市中正區中華路二段 33 號", taipeiCityHospital, "ChIJKfilEBKpQjQRiqgmYP6pC2g", markerIcon);
                    _setMarker("紹毅內兒科診所", "台北市中正區八德路一段 52 號", shaoYiHospital, "ChIJ4xzSWHupQjQREEnV7JRSVmU", markerIcon);
                    _setMarker("遠東聯合診所", "台北市中正區永綏街 8 號 4F", LatLng(25.042991, 121.511026), "ChIJL_E-nwupQjQRB6prqDM_ZkY", markerIcon);
                    _setMarker("郵政醫院", "台北市中正區福州街 14 號", LatLng(25.0285943, 121.5188268), "ChIJTQdAmZmpQjQRzlKUGVPMr-8", markerIcon);
                    _setMarker("三軍總醫院汀洲院區", "台北市中正區汀州路三段 41 號", LatLng(25.0192301, 121.5269937), "ChIJG6xlXYypQjQRhiVyAxmW34w", markerIcon);
                    _setMarker("匯安診所", "台北市中正區和平西路一段 20 號 5 樓", LatLng(25.02664, 121.520863), "ChIJxx4fDpqpQjQREa0lMK6VES8", markerIcon);
                    _setMarker("市立聯合醫院中興院區", "台北市大同區鄭州路 145 號", LatLng(25.0509696, 121.5093209), "ChIJKfilEBKpQjQRiqgmYP6pC2g", markerIcon);
                    _setMarker("和泰內科診所", "台北市大同區南京西路 406 號 8 樓", LatLng(25.0530917, 121.5098327), "ChIJDyYXuBOpQjQR7B0OjR1H0Oc", markerIcon);
                    _setMarker("台北馬偕醫院", "台北市中山區中山北路二段 92 號", LatLng(25.0588457, 121.5223977), "ChIJPZ12X0KpQjQRFQwmqOSdlRY", markerIcon);
                    // _setMarker("安禾診所", "台北市中山區民權東路三段 178 號 3 樓", LatLng(25.0614502, 121.5495446), "none", markerIcon);
                    _setMarker("福全醫院", "台北市中山區民權東路二段 48 號", LatLng(25.0623089, 121.5305279), "ChIJ3wbn3FupQjQR0uOd1JpwFbw", markerIcon);
                    _setMarker("宏林診所", "台北市中山區民生西路 6 號", LatLng(25.0577417, 121.5223787), "ChIJzVFKeUKpQjQROVX8ypOC-IY", markerIcon);
                    _setMarker("仁佑診所", "台北市中山區民權西路 79 號 2 樓", LatLng(25.063087, 121.5194387), "ChIJN1ZOqR0CaDQRPIrF5y6iiaM", markerIcon);
                    // _setMarker("怡仁診所", "台北市中山區中山北路一段 82 號 5F", LatLng(25.0491316, 121.5210027), "none", markerIcon);
                    _setMarker("台北長庚醫院", "台北市松山區敦化北路 199 號 9 樓", LatLng(25.0556264, 121.5496349), "ChIJD93yueirQjQR3CiOWCpr8MI", markerIcon);
                    _setMarker("國軍松山總醫院", "台北市松山區健康路 131 號", LatLng(25.0543001, 121.5576271), "ChIJNeA1feurQjQRV2LFgIT4sos", markerIcon);
                    _setMarker("安德診所", "台北市松山區八德路三段 34 號 4 樓", LatLng(25.0480585, 121.5519529), "ChIJq_5QTM0QaTQRmDiKCuXCYX0", markerIcon);
                    _setMarker("台北秀傳醫院", "台北市松山區光復南路 116 巷 1 號", LatLng(25.0430386, 121.5571047), "ChIJ24DQ2MarQjQRFB6uvvhQTi0", markerIcon);
                    _setMarker("博仁綜合醫院", "台北市松山區光復北路 66 號 10 樓", LatLng(25.0499703, 121.5575603), "ChIJ-arfj-qrQjQR4vb1kpRTdoo", markerIcon);
                    _setMarker("台安醫院", "台北市松山區八德路二段 424 號", LatLng(25.0476829, 121.5474831), "ChIJ2_uJxNyrQjQR1GQnxU5cKtU", markerIcon);
                    _setMarker("祐腎內科診所", "台北市松山區南京東路四段 50 號 8 樓", LatLng(25.0514396, 121.5534334), "ChIJ2XGu8umrQjQRjd0_2SQbBpo", markerIcon);
                    _setMarker("國泰醫院", "台北市大安區仁愛路四段 280 號", LatLng(25.0364089, 121.5547546), "ChIJQcMiLMmrQjQRXlAjmNwIQNg", markerIcon);
                    _setMarker("市立聯合醫院仁愛院區", "台北市大安區仁愛路四段 10 號", LatLng(25.037512, 121.545224), "ChIJmYpUC9GrQjQRT9YO_88LhP0", markerIcon);
                    _setMarker("杏心診所", "台北市大安區金山南路段 218 號 5F", LatLng(24.97234, 121.51738), "ChIJbc4wJCMDbjQRWIYVH91pv9g", markerIcon);
                    _setMarker("中山醫院", "台北市大安區仁愛路四段 112 巷 11 號", LatLng(25.036515, 121.5499289), "ChIJMS_FQM6rQjQRXIdDfibNfFI", markerIcon);
                    _setMarker("宏恩綜合醫院", "台北市大安區仁愛路四段 61 號", LatLng(25.0382005, 121.5467397), "ChIJHX9U8dCrQjQRdWTDaMH9KBo", markerIcon);
                    // _setMarker("中心診所", "台北市大安區忠孝東路四段 77 號", LatLng(25.0418516, 121.5474838), "none", markerIcon);
                    // _setMarker("安仁診所", "台北市大安區安和路一段 29 號 6 樓", LatLng(25.0392201, 121.5504626), "none", markerIcon);
                    // _setMarker("羅斯福內科診所", "台北市大安區羅斯福路三段 253 號 2 樓", LatLng(25.0191449, 121.5301829), "none", markerIcon);
                    _setMarker("皇家診所", "台北市大安區羅斯福路三段 227 號 10 樓", LatLng(25.0196379, 121.5296779), "ChIJWeEslI6pQjQR74PJUqWscGE", markerIcon);
                    _setMarker("仁濟醫院", "台北市萬華區廣州街 243 號 10 樓", LatLng(25.0368881, 121.4980399), "ChIJ655uTKmpQjQR4pTdwZ60vto", markerIcon);
                    _setMarker("財團法人同仁院萬華醫院", "台北市萬華區中華路二段 606 巷 6 號", LatLng(25.0240033, 121.5097449), "ChIJEzPqF7ypQjQRyMvZ_MgCG30", markerIcon);
                    _setMarker("西園醫院", "台北市萬華區西園路二段 276 號", LatLng(25.0277261, 121.4944353), "ChIJm-3YnLOpQjQRSSMZD96S9ns", markerIcon);
                    _setMarker("萬澤內科診所", "台北市萬華區萬大路 425-1 號 2-3 樓", LatLng(25.0213541, 121.4987801), "ChIJj3KVPLapQjQR7mBv2cU1I0I", markerIcon);
                    _setMarker("台大醫院北護分院", "台北市萬華區康定路 37 號 3 樓", LatLng(25.0421534, 121.5026284), "ChIJbyLp4AepQjQRVTUd1x0aMMA", markerIcon);
                    _setMarker("吳明修診所", "台北市萬華區中華路二段 40 號 4F", LatLng(25.0328405, 121.5048664), "ChIJhcaOpaWpQjQRfLwgfI282FA", markerIcon);
                    _setMarker("台北醫學大學附設醫院", "台北市信義區吳興街 252 號", LatLng(25.0269556, 121.563012), "ChIJe5BE0bSrQjQRkQDwF-Tv5Lc", markerIcon);
                    _setMarker("三本診所", "台北市信義區松隆路 327 號 5 樓之 3", LatLng(25.0484307, 121.5791034), "ChIJYxZpiZ6rQjQR-ViIJYIwLws", markerIcon);
                    _setMarker("松禾診所", "台北市信義區松山路 130 號 3F", LatLng(25.0477482, 121.5774791), "ChIJV8Pzd-hHaDQR2k1S6LibkFI", markerIcon);
                    _setMarker("佳康內科診所", "台北市信義區基隆路二段 149 號 4 樓", LatLng(25.0262706, 121.5551744), "ChIJlSP4kjSqQjQR8gH9DIys9_U", markerIcon);
                    _setMarker("百齡診所", "台北市士林區重慶北路四段 187 號 2 樓", LatLng(25.0842569, 121.51127), "ChIJMYs_hcmuQjQRGcfrbJLYOys", markerIcon);
                    // _setMarker("福林診所", "台北市士林區中山北路五段 685 號 4 樓", LatLng(25.0970399, 121.5273086), "none", markerIcon);
                    _setMarker("市立聯合醫院陽明院區", "台北市士林區雨聲街 105 號", LatLng(25.1050815, 121.5319457), "ChIJC5p2fJyuQjQRtS1OLXC18F4", markerIcon);
                    _setMarker("怡德診所", "台北市士林區文林路 342 號 6 樓", LatLng(25.0933395, 121.5254024), "ChIJ3bPhtaSuQjQRG9olYoidsaI", markerIcon);
                    _setMarker("台北榮民總醫院", "台北市北投區石牌路二段 201 號", LatLng(25.1222532, 121.5222656), "ChIJq6q6AoquQjQRk27N2_Y8tWE", markerIcon);
                    // _setMarker("關渡醫院", "台北市北投區知行路 225 巷 12 號", LatLng(25.1203578, 121.4661369), "none", markerIcon);
                    _setMarker("承新診所", "台北市北投區北投路二段 11 號 1F", LatLng(25.1305339, 121.498764), "ChIJAzYw6lauQjQRgc-xRDIrU1k", markerIcon);
                    _setMarker("弘德診所", "台北市北投區雙全街 66 號 2F", LatLng(25.137552, 121.5007746), "ChIJjfxqKk6uQjQR7T8fdiGkzbs", markerIcon);
                    // _setMarker("振興醫療財團法人振興醫院", "台北市北投區振興街 45 號", LatLng(25.1173845, 121.5225928), "none", markerIcon);
                    _setMarker("文林診所", "台北市北投區文林北路 228 號", LatLng(25.108479, 121.5140397), "ChIJpw3t7uqpQjQRHUEkxUzwldU", markerIcon);
                    _setMarker("華榮診所", "台北市北投區承德路七段 310 號", LatLng(25.1170005, 121.5048864), "ChIJn0PrgjN1bjQRGPZLvT_Omp0", markerIcon);
                    _setMarker("和信醫院", "台北市北投區立德路 125 號", LatLng(25.1281471, 121.4718564), "ChIJEaUPkAuvQjQRzYtEkQ40d48", markerIcon);
                    _setMarker("三軍總醫院", "台北市內湖區成功路二段 325 號", LatLng(25.0717029, 121.5900721), "ChIJJyQGuYWsQjQRU9Vql-Aj8ZE", markerIcon);
                    _setMarker("東成診所", "台北市內湖區民權東路六段495號2號樓之1", LatLng(25.0732217, 121.6050073), "ChIJnbGSu2WtQjQR1Df5IVK6Oqk", markerIcon);
                    _setMarker("財團法人康寧醫院", "台北市內湖區成功路五段 420 巷 26 號", LatLng(25.0758907, 121.6089476), "ChIJTcST8b6sQjQRRr-tqRxSFFs", markerIcon);
                    _setMarker("洪永祥診所", "台北市內湖區成功路三段 6 巷 1 號", LatLng(25.0753789, 121.5898699), "ChIJt-oYGI-sQjQRKyMBg0IJ_yw", markerIcon);
                    _setMarker("心力合診所", "台北市內湖區民權東路六段 169 號", LatLng(25.0684783, 121.5960151), "ChIJ_UMjxYSsQjQRddOIqG37IQw", markerIcon);
                    _setMarker("中國醫藥大學附設醫院台北分院", "台北市內湖區內湖路二段 360 號", LatLng(25.082146, 121.5907328), "ChIJbXH-z4ysQjQREBNVOYqC468", markerIcon);
                    _setMarker("市立聯合醫院忠孝院區", "台北市南港區同德路 87 號", LatLng(25.0467031, 121.5861864), "ChIJZ4C2N3SrQjQRJnIHuKK6utU", markerIcon);
                    _setMarker("慶如診所", "台北市文山區萬慶街 18 號 2 樓", LatLng(24.9925438, 121.5398119), "ChIJM2xlqgGqQjQR65hJ9hKcaGs", markerIcon);
                    _setMarker("市立萬芳醫院", "台北市文山區興隆路三段 111 號", LatLng(24.999901, 121.55814), "ChIJwbaoahOqQjQR0zgeIPKg22o", markerIcon);
                    _setMarker("景安診所", "台北市文山區羅斯福路六段 136 號 2 樓", LatLng(24.9967497, 121.5407086), "ChIJ41R8xrMQbjQR6UbfwYj0S_E", markerIcon);

                  }
                  else{
                    markers.clear();
                  }
                  showHospital = !showHospital;
                  setState(() {});
                },
                icon: const Icon(Icons. local_hospital),
                label: const Text("Nearby hospital"),
              ),),),
          // 顯示個人位置
          Positioned(
            bottom: 10,
            right: 3,
            child: FloatingActionButton(
              onPressed: () async { // jump to current location
                Position position = await _determinePosition();
                origin = LatLng(position.latitude, position.longitude);
                googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14))
                );
                markers.clear();
                markers.add(
                    Marker(
                      markerId: const MarkerId("currentLocation"),
                      infoWindow: const InfoWindow(title: "I'm here"),
                      position: LatLng(position.latitude, position.longitude),
                    ));
                if_pointInfo = false;
                setState(() {});
              },
              child: const Icon(Icons. location_history),
            ),
          ),
          // // 顯示information
          // Positioned(
          //   bottom: 10,
          //   left: 30,
          //   child: FloatingActionButton(// 按下按鈕顯示目標資料
          //     onPressed: () async{ // 注意這邊要用async 下面取得地址的部分要用await等待請求完成才能繼續後面的部分，否則會造成不同步的問題
          //       photoGalleryIndex = 0; // 照片顯示歸零
          //       if_pointInfo = !if_pointInfo; // 開啟pointInfo
          //       if(if_pointInfo){
          //         placeInfo = await showPlaceInfo(placeID);
          //         placeImg = placeInfo['photos'][0]['photo_reference']; // 取得第一張照片
          //       }
          //       setState(() {});
          //       // drawPolyline(destination);
          //     },
          //     child: const Icon(Icons.info),
          //   ),
          // ),
          // 走路按鈕
          Positioned(
            bottom: 10, // 70
            left: 30,
            child: FloatingActionButton(// 按下按鈕後就畫線
              onPressed: () {
                if_direction = !if_direction;
                travelMethod = "walking";
                if_pointInfo = false;
                drawPolyline(destination);
                setState(() {});
              },
              child: const Icon(Icons.directions_walk),
            ),
          ),
          // 開車按鈕
          Positioned( // 開車按鈕
            bottom: 70, //130
            left: 30,
            child: FloatingActionButton(// 按下按鈕後就畫線
              onPressed: () {
                if_direction = !if_direction;
                travelMethod = "driving";
                if_pointInfo = false;
                drawPolyline(destination);

                setState(() {});
              },
              child: const Icon(Icons.directions_car),
            ),),
        ],
      )

    );

  }



  // for checking the GPS sevice is available or not
  Future<Position> _determinePosition() async {
    bool serviceEnable;
    LocationPermission permission;
    serviceEnable = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnable){
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission(); // request again

      if(permission == LocationPermission.denied){ // the user still deny the permission
        return Future.error("Location permission denied");
      }
    }
    if(permission == LocationPermission.deniedForever){ // if the user deny the permission forever. The user need to go to setting and allow our app manually.
      return Future.error("Location permission are permanently denied");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<Map<String, dynamic>> showPlaceInfo(String searchPlaceID) async { // http request for info
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$searchPlaceID&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    print(url);
    placeinfoResponse = jsonDecode(response.body);
    var results = placeinfoResponse['result'] as Map<String, dynamic>;
    return results;
  }

// TODO 要換畫線方法
  void drawPolyline(LatLng destination) async {
    polylinePoints.clear();
    // 非同步處理(需要http request)
    String url = "https://maps.googleapis.com/maps/api/directions/json?key=" +
        apiKey +
        "&units=metric&origin=" +
        origin.latitude.toString() +
        "," +
        origin.longitude.toString() +
        "&destination=" +
        destination.latitude.toString() +
        "," +
        destination.longitude.toString() +
        "&mode=" + travelMethod.toString();

    var response = await http.post(Uri.parse(url));

    print(url);
    // print(response.body);
    var json = jsonDecode(response.body);

    polylineResponse = PolylineResponse.fromJson(json); // 要 import 'dart:convert';
    print(polylineResponse);
    totalDistance = polylineResponse.routes![0].legs![0].distance!.text!; // 走路的距離
    totalTime = polylineResponse.routes![0].legs![0].duration!.text!; // 走路的時間

    for (int i = 0; i < polylineResponse.routes![0].legs![0].steps!.length; i++) {
      polylinePoints.add(Polyline(
          polylineId: PolylineId(polylineResponse.routes![0].legs![0].steps![i].polyline!.points!),
          points: [
            LatLng(polylineResponse.routes![0].legs![0].steps![i].startLocation!.lat!, polylineResponse.routes![0].legs![0].steps![i].startLocation!.lng!),
            LatLng(polylineResponse.routes![0].legs![0].steps![i].endLocation!.lat!, polylineResponse.routes![0].legs![0].steps![i].endLocation!.lng!),
          ],
          width: 2,

          color: Colors.cyan
      ));

      // var results = polylineInfo['routes'] as Map<String, dynamic>;
      var results = {
        'bounds_ne': json['routes'][0]['bounds']['northeast'],
        'bounds_sw': json['routes'][0]['bounds']['southwest'],
        'start_location': json['routes'][0]['legs'][0]['start_location'],
        'end_location': json['routes'][0]['legs'][0]['end_location'],
        'polyline': json['routes'][0]['overview_polyline']['points'],
        // 'polyline_decoded': PolylinePoints()
        //     .decodePolyline(json['routes'][0]['overview_polyline']['points'])
      };
      print(results);
      RoutingCam(json['routes'][0]['bounds']['northeast'], json['routes'][0]['bounds']['southwest']);
      setState(() {

      });
    }

    // setState(() {});
  }

  RoutingCam(Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'] - 0.005, boundsSw['lng'] - 0.005), // lng: ++ east, lat: ++ north
            northeast: LatLng(boundsNe['lat'] + 0.005, boundsNe['lng'] + 0.005)),
        25,
    ));
    // googleMapController.animateCamera(CameraUpdate.zoomBy(14));
  }



  _setMarker(String name, String info, LatLng point_location, String curr_placeID, Uint8List markerIcon) {
    var counter = markerIdCounter++;
    final Marker marker = Marker(
        markerId: MarkerId('hospitalMarker_$counter'),
        infoWindow: InfoWindow(
            title: name,
            snippet: info,
            onTap: ()async{
              photoGalleryIndex = 0; // 照片顯示歸零
              if_pointInfo = !if_pointInfo; // 開啟pointInfo
              if(if_pointInfo){
                placeInfo = await showPlaceInfo(placeID);
                placeImg = placeInfo['photos'][0]['photo_reference']; // 取得第一張照片
              }
              setState(() {});
            }),
        position: point_location,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          polylinePoints.clear();
          if_pointInfo = false;
          if_direction = false;
          destination = point_location;
          moveCameraSlightly();
          placeID = curr_placeID;
          setState(() { });
        }
      );
    markers.add(marker);
  }


  Future<void> moveCameraSlightly() async {

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng( destination.latitude + 0.0125,  destination.longitude - 0.005),
        zoom: 14.0,
        // bearing: 45.0,
        // tilt: 45.0
    )));
  }
  // 讀檔
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }



  // 顯示review和photo介面
  _buildReviewItem(review) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(review['profile_photo_url']),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: 4.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 160.0,
                  child: Text(
                    review['author_name'],
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 3.0),
                RatingStars(
                  value: review['rating'] * 1.0,
                  starCount: 5,
                  starSize: 7,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 9.0),
                  valueLabelRadius: 7,
                  maxValue: 5,
                  starSpacing: 2,
                  maxValueVisibility: false,
                  valueLabelVisibility: true,
                  animationDuration: Duration(milliseconds: 1000),
                  valueLabelPadding:
                  const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  valueLabelMargin: const EdgeInsets.only(right: 4),
                  starOffColor: const Color(0xffe7e8ea),
                  starColor: Colors.yellow,
                )
              ])
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Text(
              review['text'],
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Divider(color: Colors.grey.shade600, height: 1.0)
      ],
    );
  }

  _buildPhotoGallery(photoElement) {
    if (photoElement == null || photoElement.length == 0) {
      showBlankCard = true;
      return Container(
        child: Center(
          child: Text(
            'No Photos',
            style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 12.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      var placeImg = photoElement[photoGalleryIndex]['photo_reference'];
      var maxWidth = photoElement[photoGalleryIndex]['width'];
      var maxHeight = photoElement[photoGalleryIndex]['height'];
      var tempDisplayIndex = photoGalleryIndex + 1;

      return Column(
        children: [
          SizedBox(height: 10.0),
          Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&maxheight=$maxHeight&photo_reference=$placeImg&key=$apiKey'),
                      fit: BoxFit.cover))),
          SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != 0)
                    photoGalleryIndex = photoGalleryIndex - 1;
                  else
                    photoGalleryIndex = 0;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != 0
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Prev',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Text(
              '$tempDisplayIndex/' + photoElement.length.toString(),
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != photoElement.length - 1)
                    photoGalleryIndex = photoGalleryIndex + 1;
                  else
                    photoGalleryIndex = photoElement.length - 1;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != photoElement.length - 1
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ])
        ],
      );
    }
  }


}

