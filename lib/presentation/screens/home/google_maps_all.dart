import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gdsc/model/polyline_response.dart';
import 'package:localization/localization.dart';

@RoutePage()
class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {

  late GoogleMapController  googleMapController;
  String apiKey = "YOUR_APIKEY"; // API KEY

  static const CameraPosition initialPosition = CameraPosition(target: LatLng(25.0173405, 121.5397518), zoom: 14.6);

  // Set initial posistion
  LatLng origin = LatLng(25.0173405, 121.5397518); // initial start point
  LatLng destination = LatLng(25.1184723, 121.4726081); // initial end point

  // Hospital Info
  List HospitalPlace = [];

  String totalDistance = "";
  String totalTime = "";
  String travelMethod = "";
  String placeID ="";

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
        body: Stack(
            children: [
              GoogleMap(
                polylines: polylinePoints,
                initialCameraPosition: initialPosition,
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
              // Show path, total distance, total time
              if_direction?
              Positioned(
                  top: 55,
                  left: 15,
                  child: Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$travelMethod\n'),
                          Text('$totalDistance ($totalTime)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen)),
                        ],
                      ))) : Container(),

              // flipcard
              if_pointInfo ?
              Positioned(
                  bottom: 50,
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
                            // Address
                            Container(
                              padding: EdgeInsets.all(7.0),
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 170.0,
                                    child: Text(
                                        placeInfo['formatted_address'] ?? 'none given',
                                        style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Phone
                            Container(
                              padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('tel'.i18n(), style: const TextStyle(fontSize: 12.0),),
                                  Container(
                                    width: 105.0,
                                    child: Text(
                                        placeInfo['formatted_phone_number'] ?? 'none given',
                                        style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Operation status
                            Container(
                              padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('status'.i18n(), style: const TextStyle(fontSize: 12.0)),
                                  SizedBox(
                                    width: 105.0,
                                    child: Text(
                                        placeInfo['business_status'] ?? 'none given',
                                        style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)
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
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () { setState(() { is_review = true; is_photo = false;});},
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                    padding: EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11.0),
                                        color: is_review ? Colors.lightGreen : Colors.white),
                                    child: Text(
                                      'reviews'.i18n(),
                                      style: TextStyle(
                                        color: is_review ? Colors.white : Colors.black87,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector( // 顯示圖片
                                  onTap: () { setState(() { is_review = false; is_photo = true;});},
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                    padding: EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11.0),
                                        color: is_photo ? Colors.lightGreen : Colors.white),
                                    child: Text(
                                      'photos'.i18n(),
                                      style: TextStyle(
                                          color: is_photo ? Colors.white : Colors.black87,
                                          fontSize: 12.0
                                      ),
                                    ),
                                  ),
                                )],
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
            // NearbyHospital button
            Positioned(
              top: 70,
              right: 5,
              child: Container( // TODO: 相機縮放
                alignment: Alignment.topLeft,
                // margin: const EdgeInsets.all(10),
                child: FloatingActionButton.extended(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightGreen,
                  elevation: 0,
                  onPressed: () async{
                    if(!showHospital){
                      final Uint8List markerIcon = await getBytesFromAsset('assets/mapicons/health-medical.png', 40); // 要在ymal add assets 加 - assets/mapicons/ 才能讀到
                      _setAllMarler(markerIcon);
                    }
                    else{
                      markers.clear();
                    }
                    showHospital = !showHospital;
                    setState(() {});
                  },
                  icon: const Icon(Icons. local_hospital),
                  label: Text('nearby-hospital'.i18n()),
                ),),),

            // Current Location
            Positioned(
              bottom: 220, //10
              right: 5,
              child: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen,
                elevation: 0,
                onPressed: () async { // jump to current location
                  Position position = await _determinePosition();
                  origin = LatLng(position.latitude, position.longitude);
                  googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14))
                  );
                  // markers.clear();
                  markers.add(
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        infoWindow: InfoWindow(title: 'you-are-here'.i18n()),
                        position: LatLng(position.latitude, position.longitude),
                      ));
                  if_pointInfo = false;
                  setState(() {});
                },
                child: const Icon(Icons. location_history),
              ),
            ),

            // Walking
            Positioned(
              bottom: 60, // 70
              right: 5,
              child: FloatingActionButton(// 按下按鈕後就畫線
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen,
                elevation: 0,
                onPressed: () {
                  if_direction = !if_direction;
                  travelMethod = 'walking'.i18n();
                  if_pointInfo = false;
                  drawPolyline(destination);
                  setState(() {});
                },
                child: const Icon(Icons.directions_walk),
              ),
            ),

            // Driving
            Positioned( // 開車按鈕
              bottom: 140, //130
              right: 5,
              child: FloatingActionButton(// 按下按鈕後就畫線
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen,
                elevation: 0,
                onPressed: () {
                  if_direction = !if_direction;
                  travelMethod = 'driving'.i18n();
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
    final locale = Localizations.localeOf(context);
    final language = locale.languageCode == 'en' ? 'en-US' : 'zh-TW';
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$searchPlaceID&key=$apiKey&language=$language';
    var response = await http.get(Uri.parse(url));
    print(url);
    placeinfoResponse = jsonDecode(response.body);
    var results = placeinfoResponse['result'] as Map<String, dynamic>;
    return results;
  }


  void drawPolyline(LatLng destination) async {
    polylinePoints.clear();
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

      var results = {
        'bounds_ne': json['routes'][0]['bounds']['northeast'],
        'bounds_sw': json['routes'][0]['bounds']['southwest'],
        'start_location': json['routes'][0]['legs'][0]['start_location'],
        'end_location': json['routes'][0]['legs'][0]['end_location'],
        'polyline': json['routes'][0]['overview_polyline']['points'],
      };
      print(results);
      RoutingCam(json['routes'][0]['bounds']['northeast'], json['routes'][0]['bounds']['southwest']);
      setState(() {

      });
    }
  }

  RoutingCam(Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
          southwest: LatLng(boundsSw['lat'] - 0.005, boundsSw['lng'] - 0.005), // lng: ++ east, lat: ++ north
          northeast: LatLng(boundsNe['lat'] + 0.005, boundsNe['lng'] + 0.005)),
      25,
    ));
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
  _setAllMarler(Uint8List markerIcon) {
    _setMarker("普仁健康診所", "宜蘭市民權路一段 6 號", LatLng(24.7522914, 121.7562708), "ChIJB19SidzkZzQRJyD4X50GiZs", markerIcon);
    _setMarker("得安診所", "宜蘭市中山路三段 152 號 5F", LatLng(24.7591086, 121.753092), "ChIJJ-UuM6OpQjQRPkE7XqLcnDU", markerIcon);
    _setMarker("青田診所", "宜蘭市舊城西路 79 號 2F", LatLng(24.7592844, 121.7498539), "ChIJF74eHd3kZzQRffTtvVSKXH4", markerIcon);
    _setMarker("國立陽明大學附設醫院", "宜蘭市新民路 152 號", LatLng(24.7577958, 121.7541648), "ChIJOfzrydrkZzQR18NQc3VDpvo", markerIcon);
    _setMarker("羅東聖母醫院", "宜蘭縣羅東鎮中正南路 160 號", LatLng(24.6718382, 121.7715737), "ChIJIyozbHvmZzQRCT5yv_1ylkc", markerIcon);
    _setMarker("羅東博愛醫院", "宜蘭縣羅東鎮南昌路 83 號", LatLng(24.6995065, 121.7640573), "ChIJ623xD3vmZzQRyi3yxxqy0Z0", markerIcon);
    _setMarker("陳文貴診所", "宜蘭縣羅東鎮興東路 118 號", LatLng(24.6803357, 121.7693184), "ChIJ_UPNa3_mZzQR0v5klVGxC9c", markerIcon);
    _setMarker("吳得中診所", "宜蘭縣羅東鎮興東路 118 號 3 樓", LatLng(24.6803357, 121.7693184), "ChIJP0LNa3_mZzQR-jdjhu-fZmI", markerIcon);
    _setMarker("蘇澳榮民醫院", "宜蘭縣蘇澳鎮濱海路一段 301 號", LatLng(24.594229, 121.8533264), "ChIJidzMPlHoZzQRl7Q4UiPV394", markerIcon);
    _setMarker("元翔診所", "基隆市仁愛區忠二路 55 號 3 樓", LatLng(25.130576, 121.7389609), "ChIJhR03URROXTQRzvkCjQrciOQ", markerIcon);
    _setMarker("佳基內科診所", "基隆市仁愛區劉銘傳路 1-7 號 8 樓", LatLng(25.127829, 121.751017), "ChIJXVjoqjlOXTQRmsIveJLvPto", markerIcon);
    _setMarker("高士振診所", "基隆市仁愛區南榮路 16-1 號", LatLng(25.1258919, 121.7425367), "ChIJKe0pUEtPXTQRg8tC0TXJ0Zc", markerIcon);
    _setMarker("安基診所", "基隆市仁愛區愛五路 34 號 5 樓", LatLng(25.1287915, 121.7458828), "ChIJG7cw4z5OXTQRz_HrglEMRz8", markerIcon);
    _setMarker("衛生福利部基隆醫院", "基隆市信義區信二路 268 號", LatLng(25.1306117, 121.7484561), "ChIJp16DtDhOXTQR1Iwx6HBuoGw", markerIcon);
    _setMarker("三總附設基隆服務處", "基隆市中正區正榮街 100 號", LatLng(25.1440995, 121.7645575), "ChIJRzrk4z1OXTQRFbjHp_edhrg", markerIcon);
    _setMarker("基隆長庚紀念醫院", "基隆市安樂區麥金路 222 號", LatLng(25.1211061, 121.7223372), "ChIJ26eVRdtNXTQRFL9wwDP0l0s", markerIcon);
    _setMarker("台灣礦工醫院", "基隆市八堵區源遠路 29 號", LatLng(25.1078781, 121.733227), "ChIJ-ZTrhORRXTQRU6ZM9MuWycA", markerIcon);
    _setMarker("台大醫院", "台北市中正區中山南路 7 號", LatLng(25.0409785, 121.5191987), "ChIJlblYxnOpQjQR_7C_sDPc4P0", markerIcon);
    _setMarker("市立聯合醫院和平院區", "台北市中正區中華路二段 33 號", LatLng(25.0354322, 121.5070252), "ChIJrZ0_kaapQjQRR4lFD2M6Lq0", markerIcon);
    _setMarker("紹毅內兒科診所", "台北市中正區八德路一段 52 號", LatLng(25.0438062, 121.5311148), "ChIJ4xzSWHupQjQREEnV7JRSVmU", markerIcon);
    _setMarker("遠東聯合診所", "台北市中正區永綏街 8 號 4F", LatLng(25.042991, 121.511026), "ChIJL_E-nwupQjQRB6prqDM_ZkY", markerIcon);
    _setMarker("郵政醫院", "台北市中正區福州街 14 號", LatLng(25.0285943, 121.5188268), "ChIJTQdAmZmpQjQRzlKUGVPMr-8", markerIcon);
    _setMarker("三軍總醫院汀洲院區", "台北市中正區汀州路三段 41 號", LatLng(25.0192301, 121.5269937), "ChIJG6xlXYypQjQRhiVyAxmW34w", markerIcon);
    _setMarker("匯安診所", "台北市中正區和平西路一段 20 號 5 樓", LatLng(25.02664, 121.520863), "ChIJxx4fDpqpQjQREa0lMK6VES8", markerIcon);
    _setMarker("市立聯合醫院中興院區", "台北市大同區鄭州路 145 號", LatLng(25.0509696, 121.5093209), "ChIJKfilEBKpQjQRiqgmYP6pC2g", markerIcon);
    _setMarker("和泰內科診所", "台北市大同區南京西路 406 號 8 樓", LatLng(25.0530917, 121.5098327), "ChIJDyYXuBOpQjQR7B0OjR1H0Oc", markerIcon);
    _setMarker("台北馬偕醫院", "台北市中山區中山北路二段 92 號", LatLng(25.0588457, 121.5223977), "ChIJPZ12X0KpQjQRFQwmqOSdlRY", markerIcon);
    _setMarker("福全醫院", "台北市中山區民權東路二段 48 號", LatLng(25.0623089, 121.5305279), "ChIJ3wbn3FupQjQR0uOd1JpwFbw", markerIcon);
    _setMarker("宏林診所", "台北市中山區民生西路 6 號", LatLng(25.0577417, 121.5223787), "ChIJzVFKeUKpQjQROVX8ypOC-IY", markerIcon);
    _setMarker("仁佑診所", "台北市中山區民權西路 79 號 2 樓", LatLng(25.063087, 121.5194387), "ChIJN1ZOqR0CaDQRPIrF5y6iiaM", markerIcon);
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
    _setMarker("市立聯合醫院陽明院區", "台北市士林區雨聲街 105 號", LatLng(25.1050815, 121.5319457), "ChIJC5p2fJyuQjQRtS1OLXC18F4", markerIcon);
    _setMarker("怡德診所", "台北市士林區文林路 342 號 6 樓", LatLng(25.0933395, 121.5254024), "ChIJ3bPhtaSuQjQRG9olYoidsaI", markerIcon);
    _setMarker("台北榮民總醫院", "台北市北投區石牌路二段 201 號", LatLng(25.1222532, 121.5222656), "ChIJq6q6AoquQjQRk27N2_Y8tWE", markerIcon);
    _setMarker("承新診所", "台北市北投區北投路二段 11 號 1F", LatLng(25.1305339, 121.498764), "ChIJAzYw6lauQjQRgc-xRDIrU1k", markerIcon);
    _setMarker("弘德診所", "台北市北投區雙全街 66 號 2F", LatLng(25.137552, 121.5007746), "ChIJjfxqKk6uQjQR7T8fdiGkzbs", markerIcon);
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
    _setMarker("連江縣立醫院", "連江縣南竿鄉復興村 217 號", LatLng(26.1645594, 119.9581538), "ChIJRVHWbPNwQTQR5NtPdRKXh3I", markerIcon);
    _setMarker("亞東紀念醫院", "新北市板橋區南雅南路 2 段 21 號", LatLng(24.997236, 121.4532954), "ChIJ5bAJNAKoQjQRN3x3QFsGrdI", markerIcon);
    _setMarker("中英醫院", "新北市板橋區文化路一段 196 號 5 樓", LatLng(25.0199064, 121.4662881), "ChIJocpDrheoQjQRPzsC8Qx09Go", markerIcon);
    _setMarker("台大醫院附設金山院區", "新北市金山區五湖村南勢 51 號", LatLng(25.22001, 121.625556), "ChIJlblYxnOpQjQR_7C_sDPc4P0", markerIcon);
    _setMarker("陳尚志診所洗腎中心", "新北市板橋區文化路二段 330 號", LatLng(25.0301468, 121.4727873), "ChIJzy56PUGoQjQRWnBoHNbalgY", markerIcon);
    _setMarker("禾安診所", "新北市板橋區四川路一段 269 號 1.2 樓", LatLng(25.0020877, 121.4595686), "ChIJawOIyaUCaDQRe93OaCRDoWo", markerIcon);
    _setMarker("憲安診所", "新北市板橋區忠孝路 19 號 7 樓", LatLng(25.002047, 121.4603319), "ChIJN_m0NqQCaDQRFBXiAeaNIGs", markerIcon);
    _setMarker("新北市聯合醫院板橋院區", "新北市板橋區英士路 198 號", LatLng(25.0235652, 121.4576614), "ChIJgUcP3RGoQjQR1TIu7Jh2bG4", markerIcon);
    _setMarker("板新醫院", "新北市板橋區中正路 189 號", LatLng(25.0168376, 121.4564086), "ChIJ6WEr1wSoQjQRx0j46nOQq98", markerIcon);
    _setMarker("蕭中正醫院", "新北市板橋區南雅南路一段 15-1 號", LatLng(25.0068789, 121.4564446), "ChIJAwuBe6gCaDQRhbOnvmlp5xU", markerIcon);
    _setMarker("昕隆診所", "新北市板橋區民生路一段 3 號 5 樓", LatLng(25.0119398, 121.4760124), "ChIJ6_atTCSoQjQRuj3r-2d-bLU", markerIcon);
    _setMarker("仁謙診所", "新北市板橋區忠孝路 102 號", LatLng(25.0019793, 121.4621216), "ChIJJYuie-U8aTQRQSi9iuwEeGk", markerIcon);
    _setMarker("國泰綜合醫院汐止分院", "新北市汐止區建成路 59 巷 2 號", LatLng(25.0729852, 121.6609281), "ChIJHTl17hFTXTQR8EpPSAQBdv0", markerIcon);
    _setMarker("東暉診所", "新北市汐止區新興路 3 號 8 樓", LatLng(25.06513, 121.656453), "ChIJUx8phGtTXTQR-IHGvkRTfAo", markerIcon);
    _setMarker("紹善聯合診所", "新北市深坑區北深路三段 101 號 2F", LatLng(25.0017117, 121.6056933), "ChIJBe7mC8KqQjQR3hQlrQDPtJk", markerIcon);
    _setMarker("耕莘醫院", "新北市新店區中正路 362 號", LatLng(24.976293, 121.5357523), "ChIJi3VnwB0CaDQRM-ufXn_vj8M", markerIcon);
    _setMarker("國城診所", "新北市新店區北新路二段 200 號 2F", LatLng(24.9766947, 121.5431341), "ChIJbwlEyfABaDQRtLd09hWMy8g", markerIcon);
    _setMarker("同仁醫院", "新北市新店區民權路 89 號 6 樓", LatLng(24.9826334, 121.5377321), "ChIJRfPoZORM8DURdS7av4gvKUk", markerIcon);
    _setMarker("新店慈濟醫院", "新北市新店區建國路 289 號", LatLng(24.9861221, 121.5355355), "ChIJ8zlZ562faDQRNvz07Lg4BFk", markerIcon);
    _setMarker("戴良恭診所", "新北市永和區中正路 237 號", LatLng(24.999574, 121.5173093), "ChIJO0neLuGpQjQRitUIb36eCow", markerIcon);
    _setMarker("永和耕莘醫院", "新北市永和區中興街 80 號", LatLng(25.0118154, 121.5178975), "ChIJDx9WxuupQjQRbx22IOIRsFg", markerIcon);
    _setMarker("永和振興醫院", "新北市永和區信義路 18 號", LatLng(25.0123126, 121.5141438), "ChIJM9FHBuqpQjQR9B85PmeE3Dw", markerIcon);
    _setMarker("衛生福利部雙和醫院", "新北市中和區中正路 291 號 2 樓", LatLng(24.9926989, 121.4935259), "ChIJ2YVTrn0CaDQR5OCvFfGu6wc", markerIcon);
    _setMarker("欣禾診所", "新北市中和區景平路 416 號", LatLng(24.9933825, 121.5079282), "ChIJiRn0mHYCaDQRhL1GDmD3Sms", markerIcon);
    _setMarker("怡和醫院", "新北市中和區連城路 49 號 3 樓", LatLng(25.0018899, 121.4985247), "ChIJ0UnnZdapQjQRy4Q2Li99obY", markerIcon);
    _setMarker("承安聯合診所", "新北市中和區永貞路 288 號", LatLng(25.0042269, 121.512968), "ChIJqVJodN2pQjQRL_0JJUfQIZ0", markerIcon);
    _setMarker("中祥醫院", "新北市中和區中山路二段 140 號 2 樓", LatLng(25.003255, 121.5020897), "ChIJ1ZylWtepQjQRIySvp2jN83M", markerIcon);
    _setMarker("佑城診所", "新北市中和區景平路 696 號 5 樓", LatLng(25.0019066, 121.4969909), "ChIJZf-VBWmiFDQRYQymmPHPE4A", markerIcon);
    _setMarker("元福診所", "新北市土城區明德路二段 62 號 4F", LatLng(24.9831786, 121.4484579), "ChIJUcR_9cwCaDQRp7rYQ5ebKHA", markerIcon);
    _setMarker("元佳診所", "新北市土城區中央路二段 253.255 號 3 樓", LatLng(24.9760538, 121.4420215), "ChIJQYCtHSodaDQRHh3DMpBq3bQ", markerIcon);
    _setMarker("廣泉診所", "新北市土城區清水路 114 號 6 樓", LatLng(24.9814039, 121.4580636), "ChIJG7i-7sUCaDQRajdKR-AuhtU", markerIcon);
    _setMarker("恩樺醫院", "新北市土城區中央路一段 7 號 11F", LatLng(24.9911889, 121.4488224), "ChIJ8aCFmLUCaDQRbNzKOlcx7Sg", markerIcon);
    _setMarker("恩主公醫院", "新北市三峽區復興路 399 號", LatLng(24.9383661, 121.3630686), "ChIJbeboVPobaDQR-OQe5xVO0t0", markerIcon);
    _setMarker("樹林仁愛醫院", "新北市樹林區文化街 9 號 9F", LatLng(24.9871737, 121.4200433), "ChIJATifnxcdaDQRNMzzPSuMv3Y", markerIcon);
    _setMarker("幸安診所", "新北市鶯歌區仁愛路 1 號 5F", LatLng(24.9568583, 121.35365), "ChIJ4QXnV4MbbjQREiGn5_YKyLc", markerIcon);
    _setMarker("新北市聯合醫院三重院區", "新北市三重區中山路 2 號", LatLng(25.0614534, 121.4867114), "ChIJHbpW3OGoQjQRl5fALyskKvc", markerIcon);
    _setMarker("宏仁醫院", "新北市三重區三和路二段 188 號", LatLng(25.0689165, 121.4986338), "ChIJ8VzM8F42aTQR0FcshUm2LMk", markerIcon);
    _setMarker("德澤診所", "新北市三重區仁愛街 717 號", LatLng(25.0807404, 121.4825948), "ChIJZV-HqNGoQjQR-B_RynmnEAE", markerIcon);
    _setMarker("仁暉診所", "新北市三重區重新路一段 50 號 2 樓", LatLng(25.0637081, 121.5028082), "ChIJc9vRND2pQjQRx9L4NL9j0KY", markerIcon);
    _setMarker("江生診所", "新北市三重區重新路二段 1 號 5 樓", LatLng(25.063051, 121.499599), "ChIJ0-XDfiKpQjQRLiaIglfnN-k", markerIcon);
    _setMarker("輝德診所", "新北市三重區重新路二段 23 號 11 樓", LatLng(25.0624097, 121.4979906), "ChIJLRHapBipQjQRI_dVaJypdcA", markerIcon);
    _setMarker("佑民綜合醫院", "新北市三重區重新路二段 2 號 9 樓之 2", LatLng(25.0628005, 121.4998815), "ChIJO3N9kkUwaTQRlkwWbfZ5uGQ", markerIcon);
    _setMarker("衛生福利部台北醫院", "新北市新莊區思源路 127 號", LatLng(25.0429446, 121.4594267), "ChIJbfjyAWWoQjQRHzdFoJW2Qow", markerIcon);
    _setMarker("新莊新仁醫院", "新北市新莊區中正路 391 號 5 樓", LatLng(25.006949, 121.4176796), "ChIJaRvbit-nQjQRLGm1Qoz9-IM", markerIcon);
    _setMarker("新仁醫院", "新北市新莊區中正路 395 號 6 樓", LatLng(25.0344689, 121.4454927), "ChIJjU4udJU2aDQRyY011igowQE", markerIcon);
    _setMarker("新泰綜合醫院", "新北市新莊區新泰路 157 號 6 樓", LatLng(25.0368921, 121.4477894), "ChIJ_____3SoQjQRh3qTt5vwNyA", markerIcon);
    _setMarker("祥佑診所", "新北市新莊區中安街 7 號 3F", LatLng(25.0456575, 121.4529654), "ChIJE45uVacQaTQRKiOaYI-DYGA", markerIcon);
    _setMarker("新庚聯合診所", "新北市新莊區民安西路 370 號", LatLng(25.0108137, 121.427693), "ChIJt749e1kdaDQRDhvun6vIwJE", markerIcon);
    _setMarker("志豪診所", "新北市新莊區中港路 279 號", LatLng(25.0435796, 121.4533187), "ChIJJ7uHRHqoQjQRp-xtOo96Pi0", markerIcon);
    _setMarker("安新診所", "新北市新莊區中正路 145-22 號", LatLng(25.0374997, 121.4586242), "ChIJz4ZTu38UaTQR1NM0oAjmFc0", markerIcon);
    _setMarker("宏明診所", "新北市泰山區明志路 1 段 108 號 3 樓", LatLng(25.0286564, 121.4197624), "ChIJn8z2wjGmQjQRrj8ZaR0Y81U", markerIcon);
    _setMarker("仁美診所", "新北市蘆洲區中正路 371 號 1 樓", LatLng(25.0905221, 121.4646117), "ChIJu9-N-yEWaTQR2ki0d2qrrOg", markerIcon);
    _setMarker("集賢內科診所", "新北市蘆州區集賢路 356 號", LatLng(25.0839, 121.480706), "ChIJ6xxtENKoQjQRdPAl1cKkEBo", markerIcon);
    _setMarker("新莊安庚內科診所", "新北市新莊區中港路 306 號 3F", LatLng(25.0451327, 121.4527145), "ChIJ-_Y2yHuoQjQR0j3LiWTXpI0", markerIcon);
    _setMarker("馬偕醫院淡水分院", "新北市淡水區民生路 45 號", LatLng(25.1384555, 121.4612848), "ChIJ0br3XJyvQjQRKdntX72s3O4", markerIcon);
    _setMarker("衛生福利部桃園醫院", "桃園市中山路 1492 號", LatLng(24.9777031, 121.2691911), "ChIJzSPIpFAfaDQRiuG0MhLibIE", markerIcon);
    _setMarker("敏盛綜合醫院", "桃園市經國路 168 號", LatLng(25.0163919, 121.3063525), "ChIJYYmwDLMfaDQRr9K1RQtA47M", markerIcon);
    _setMarker("桃新醫院", "桃園市復興路 98 號", LatLng(24.991149, 121.3156783), "ChIJ75imloEfaDQROkiZicTMZgU", markerIcon);
    _setMarker("聖保祿醫院", "桃園市建新街 123 號 6 樓", LatLng(24.9823214, 121.3122536), "ChIJZ84zBeEeaDQRty_O0NfBrVg", markerIcon);
    _setMarker("桃園榮民醫院", "桃園市成功路三段 100 號", LatLng(25.0043796, 121.325243), "ChIJNTMsC1weaDQRwvOOn6abKd8", markerIcon);
    _setMarker("德仁醫院", "桃園市桃鶯路 245 號", LatLng(24.984073, 121.3186219), "ChIJuRzN6-UeaDQRNgFg3oa6sd0", markerIcon);
    _setMarker("鑫庚內科診所", "桃園市大興西路二段 76 巷 7號", LatLng(25.012182, 121.2982165), "ChIJdaylma8faDQREwij8Jc_dyI", markerIcon);
    _setMarker("桃庚聯合診所", "桃園市中山路 595 號", LatLng(24.9908699, 121.2948302), "ChIJT1Wo8BAfaDQRLPCIl-BGulg", markerIcon);
    _setMarker("惠民診所", "桃園市三民路三段 282 號 6 樓", LatLng(24.9908026, 121.306458), "ChIJN6INMR0faDQRwqvuW4gnMP8", markerIcon);
    _setMarker("安慧診所", "桃園市春日路 108 號", LatLng(24.9945273, 121.3166422), "ChIJ8cdmefkeaDQRv1V4MmUgP0k", markerIcon);
    _setMarker("林口長庚醫院", "桃園縣龜山鄉復興路 5 號", LatLng(24.9907752, 121.3183715), "ChIJvSDj7_cdaDQRT4ZlaUaEyCk", markerIcon);
    _setMarker("長庚紀念醫院桃園分院", "桃園縣龜山鄉舊路村頂湖路123 號", LatLng(24.994155, 121.335762), "ChIJs21AiKwfaDQRHfjto-5qm_U", markerIcon);
    _setMarker("安庚內科診所", "桃園縣龜山鄉南祥路 50 號", LatLng(25.046355, 121.2976938), "ChIJzYss49cfaDQRsK-Zikr6LqY", markerIcon);
    _setMarker("衛生福利部樂生療養院", "桃園縣龜山鄉萬壽路一段 50 巷2 號 2 樓", LatLng(25.020677, 121.4085401), "ChIJpQ0LsIenQjQRmTIpI1t9xck", markerIcon);
    _setMarker("新國民綜合醫院", "桃園縣中壢市復興路 152 號", LatLng(24.9542044, 121.2233987), "ChIJ66MFdUkiaDQR5J8n7krjjFY", markerIcon);
    _setMarker("懷寧內科診所", "桃園縣中壢市中美路 39 號 8 樓", LatLng(24.9581959, 121.2266368), "ChIJucCdHLgjaDQRNaK868SH6lw", markerIcon);
    _setMarker("中壢祐民醫院", "桃園縣中壢市民族路二段 180 號", LatLng(24.9573932, 121.2036991), "ChIJTd5fkrkjaDQR_MCrxDfPzpM", markerIcon);
    _setMarker("天晟醫院", "桃園縣中壢市延平路 155 號", LatLng(24.9626431, 121.2290242), "ChIJAeUHXSMiaDQRvXO-wm-B7MU", markerIcon);
    _setMarker("榮元診所", "桃園縣中壢市榮民路 128 號 7F", LatLng(24.9676417, 121.2605173), "ChIJnd-i1_4haDQRNmFe7SjSgYs", markerIcon);
    _setMarker("中慎診所", "桃園縣中壢市中山東路二段 525 號之 7", LatLng(24.9468482, 121.2461279), "ChIJ06u6GmwiaDQRfZ5HePCl3F4", markerIcon);
    _setMarker("宏元診所", "桃園縣中壢市慈惠一街 136 號", LatLng(24.9613091, 121.2251293), "ChIJwV7Ycek1aTQRBsx_b128h8Q", markerIcon);
    _setMarker("中庚診所", "桃園縣中壢市福德路 15 號", LatLng(24.9735216, 121.2588988), "ChIJD-PTNFAhaDQRhAroCaO0tL8", markerIcon);
    _setMarker("敏盛醫院龍潭分院", "桃園縣龍潭鄉中豐路 168 號", LatLng(24.8751574, 121.2137879), "ChIJC21Tzd88aDQRX6tOei8_aDU", markerIcon);
    _setMarker("陽明醫院", "桃園縣平鎮市延平路二段 56 號", LatLng(24.950095, 121.2124714), "ChIJz-vFfpyuQjQR8c3uRpQ02Q8", markerIcon);
    _setMarker("壢新醫院", "桃園縣平鎮市廣泰路 77 號", LatLng(24.9466922, 121.2053006), "ChIJO5Yj96UjaDQRKBwZGL4TUV8", markerIcon);
    _setMarker("國軍桃園總醫院", "桃園縣龍潭鄉九龍村中興路 168 號", LatLng(24.8769676, 121.2348227), "ChIJVVVVVUU8aDQR2tn-Z6RevN8", markerIcon);
    _setMarker("天成醫院", "桃園縣楊梅鎮中山北路一段 356 號", LatLng(24.9089106, 121.1572076), "ChIJ_eeStbIkaDQRUTeJSHv7mmo", markerIcon);
    _setMarker("家誼診所", "桃園縣楊梅鎮中興路 99 號", LatLng(24.9174029, 121.1849757), "ChIJNzRmb0QjaDQRMwrLeZDqh3Y", markerIcon);
    _setMarker("衛生福利部桃園新屋分院", "桃園縣新屋鄉新福二路 6 號", LatLng(24.9697382, 121.1070934), "ChIJRXQa6qMlaDQRumxT46C4li4", markerIcon);
    _setMarker("德禾診所", "桃園縣八德市介壽路三段 137 號 2F", LatLng(24.9317311, 121.2836504), "ChIJyxGbvdEYaDQRqU2CxnJc1Tk", markerIcon);
    _setMarker("安馨大溪診所", "桃園縣大溪鎮慈康路155巷15弄25號", LatLng(24.8696996, 121.2888458), "ChIJY-2MpY0XaDQRdNRMuTpDZvs", markerIcon);
    _setMarker("怡仁綜合醫院", "桃園縣楊梅鎮新北路 321 巷 30 號 2 樓", LatLng(24.9242108, 121.1366715), "ChIJlTDVX7EkaDQRG9JcgPkZlHE", markerIcon);
    _setMarker("台大醫院附設新竹分院", "新竹市經國路 442 巷 25 號", LatLng(24.8138287, 120.9674798), "ChIJEUtLGts1aDQRDDvTtbzcCdQ", markerIcon);
    _setMarker("南門綜合醫院", "新竹市林森路 20 號", LatLng(24.8021381, 120.969653), "ChIJw2r7D-o1aDQRP7N6j9sNlCc", markerIcon);
    _setMarker("馬偕醫院新竹分院", "新竹市光復路二段 690 號", LatLng(24.8000704, 120.9907507), "ChIJOSUDA3U2aDQRWR-JpeSQEf8", markerIcon);
    _setMarker("國泰綜合醫院新竹分院", "新竹市中華路二段 678 號", LatLng(24.798276, 120.9652857), "ChIJf1DUq-w1aDQR-FCrMv15TrA", markerIcon);
    _setMarker("祥仁內科診所", "新竹市中華路三段 9 號", LatLng(24.7969422, 120.9634195), "ChIJt7r-PJM1aDQRBSZD3jroxS4", markerIcon);
    _setMarker("安慎診所", "新竹市中央路 128 號", LatLng(24.8069698, 120.9709025), "ChIJBfhE5MM1aDQROiIp3f-6qOw", markerIcon);
    _setMarker("亞太診所", "新竹市光華街 57 號", LatLng(24.8158577, 120.9721722), "ChIJq4kc5M41aDQRwzpfLH8NStw", markerIcon);
    _setMarker("宜暘診所", "新竹市經國路一段 343-1 號 1F", LatLng(24.814439, 120.981008), "ChIJU0QHPNE1aDQRTBIw1wxoaLA", markerIcon);
    _setMarker("成民內科診所", "新竹市東區科學園路 5 號 2 樓", LatLng(24.7866125, 121.0101293), "ChIJOQXaIxY2aDQRX_9l27rqk3A", markerIcon);
    _setMarker("竹北安慎診所", "新竹縣竹北市光明六路 275 號", LatLng(24.8292098, 121.0058307), "ChIJBfhE5MM1aDQROiIp3f-6qOw", markerIcon);
    _setMarker("大安醫院", "新竹縣竹北市博愛街 318 巷 6 號", LatLng(24.8347547, 121.0081372), "ChIJxfxfD5U2aDQR6Nf8G644_kc", markerIcon);
    _setMarker("東元綜合醫院", "新竹縣竹北市縣政二路 69 號", LatLng(24.82365, 121.013754), "ChIJkTD0bvI2aDQREcpYDEa1qDE", markerIcon);
    _setMarker("湖口仁慈醫院", "新竹縣湖口鄉忠孝路 29 號", LatLng(24.9004859, 121.0455461), "ChIJZbYSnVowaDQRjFjLsWN5RdI", markerIcon);
    _setMarker("竹東榮民醫院", "新竹縣竹東鎮中豐路一段 81 號", LatLng(24.7228579, 121.0993257), "ChIJQV1SG8dHaDQRPN3QHIVojaA", markerIcon);
    _setMarker("台大醫院竹東分院", "新竹縣竹東鎮至善路 52 號", LatLng(24.7189239, 121.093259), "ChIJh2C1RXlIaDQRt9ANOhPVSCs", markerIcon);
    _setMarker("竹東安慎診所", "新竹縣竹東鎮長安路 113 號", LatLng(24.7357188, 121.0915217), "ChIJJ26YmuhHaDQRAktXX7l3BBE", markerIcon);
    _setMarker("衛生福利部苗栗醫院", "苗栗市為公路 747 號", LatLng(24.5755097, 120.8410317), "ChIJF_ryeGesaTQRrK712QFthpg", markerIcon);
    _setMarker("大千醫院", "苗栗市新光街 6 號", LatLng(24.5515642, 120.8156014), "ChIJRf8Up_qraTQRt5TXBaoTZbo", markerIcon);
    _setMarker("台糖診所", "苗栗市中正路 1293 號", LatLng(24.5432114, 120.8169136), "ChIJ52R8x-iraTQRR45uopUVqS4", markerIcon);
    _setMarker("宏福診所", "苗栗市為公路 440 號", LatLng(24.5721429, 120.8332761), "ChIJn2007WwFbjQReVHsdt0yA0U", markerIcon);
    _setMarker("新生醫院", "苗栗市新東街 117 號", LatLng(24.5515909, 120.8206579), "ChIJQzuYH5U1aDQRLl3pgQ6SDNY", markerIcon);
    _setMarker("慈祐醫院", "苗栗縣竹南鎮民治街 17 號 6 樓", LatLng(24.684762, 120.878875), "ChIJIyVrqySzaTQRNzmQseHAD5M", markerIcon);
    _setMarker("宏仁診所", "苗栗縣竹南鎮自由街 110 號", LatLng(24.68808, 120.875209), "ChIJZZ5YsR6zaTQR3dNROD6Vt5E", markerIcon);
    _setMarker("重光醫院", "苗栗縣頭份鎮中華路 1039 號 7F", LatLng(24.6865818, 120.9081464), "ChIJlYAtzMdMaDQR309WPPqUUlQ", markerIcon);
    _setMarker("為恭紀念醫院", "苗栗縣頭份鎮仁愛路 128 號", LatLng(24.6877038, 120.9079056), "ChIJa9jc6cdMaDQRcSARVUneg34", markerIcon);
    _setMarker("通霄光田醫院", "苗栗縣通霄鎮中山路 88 號", LatLng(24.4889662, 120.67846), "ChIJm9ed7zkIaTQRTVlo25kjFwo", markerIcon);
    _setMarker("苑裡李綜合醫院", "苗栗縣苑裡鎮和平路 168 號", LatLng(24.4418676, 120.6527499), "ChIJN_xLYTsJaTQRIUVihK9DM8I", markerIcon);
    _setMarker("佳苗診所", "苗栗縣公館鄉安東街 8 號", LatLng(24.502948, 120.8288525), "ChIJhWLgxkeqaTQRod4W1nD92Qo", markerIcon);
    _setMarker("澄清綜合醫院", "台中市中區平等街 139 號", LatLng(24.1428546, 120.6817452), "ChIJvTFkwGw9aTQRsgCBymg7uWs", markerIcon);
    _setMarker("兆揚內科診所", "台中市東區十甲路 426 號", LatLng(24.1443268, 120.7085225), "ChIJ8UU0rk09aTQRvTzAHCG6lHQ", markerIcon);
    _setMarker("台新醫院", "台中市東區振興路 439-3 號", LatLng(24.1303583, 120.7055685), "ChIJ96KsWjE9aTQRo--HDItyPiQ", markerIcon);
    _setMarker("中山醫學大學附設醫院", "台中市南區建國北路一段 110 號", LatLng(24.1218202, 120.6517258), "ChIJNeTzvU48aTQRK0WxcCy1SqQ", markerIcon);
    _setMarker("中興醫院", "台中市南區復興路二段 11 號", LatLng(24.1180933, 120.6585828), "ChIJKfilEBKpQjQRiqgmYP6pC2g", markerIcon);
    _setMarker("衛生福利部台中醫院", "台中市西區三民路一段 199 號", LatLng(24.1406262, 120.6762712), "ChIJ19yOgg09aTQR8QRdu5A-Q6k", markerIcon);
    _setMarker("中國醫藥大學台中東區分院", "台中市東區自由路三段 296 號", LatLng(24.1425786, 120.694811), "ChIJmZM4NUE9aTQR6UQZEt7-czE", markerIcon);
    _setMarker("中山醫學大學附設醫院中港分院", "台中市西區中港路一段 23 號", LatLng(24.1630225, 120.6492975), "ChIJNeTzvU48aTQRK0WxcCy1SqQ", markerIcon);
    _setMarker("佑全診所", "台中市西區五權路 2-43 號", LatLng(24.1412406, 120.667341), "ChIJdcgGHgs9aTQRfje3f4a938k", markerIcon);
    _setMarker("漢陽內科診所", "台中市西區建國路 63 號", LatLng(24.1357221, 120.6814484), "ChIJezN7vhI9aTQRZta9HAU7Qwc", markerIcon);
    _setMarker("世紀聯合門診崇安診所", "台中市西區健行路 1056 號 2F", LatLng(24.1561306, 120.6627211), "ChIJAWlF0Zw9aTQRWo5a4aIPDeY", markerIcon);
    _setMarker("佳福診所", "台中市西區民權路 300 號 1F", LatLng(24.147142, 120.6699953), "ChIJK9zNXnQ9aTQR57JliW8a8WA", markerIcon);
    _setMarker("中國醫藥大學附設醫院", "台中市北區育德路 2 號", LatLng(24.1571781, 120.6804958), "ChIJbQzAfWQ9aTQREgwMfduRhrQ", markerIcon);
    _setMarker("台安醫院雙十分院", "台中市北區雙十路二段 29 號", LatLng(24.15271, 120.6886184), "ChIJPUQRj2c9aTQRy7IyQJDwbvc", markerIcon);
    _setMarker("國軍台中總醫院中清院區", "台中市北區中忠明路 500 號", LatLng(24.1621611, 120.6722145), "ChIJW4W20309aTQRw_0v4fAAE1w", markerIcon);
    _setMarker("順天綜合醫院", "台中市北區三民路三段 333 號", LatLng(24.1577258, 120.6894636), "ChIJy1IjIV49aTQRu1wIAFwKvzI", markerIcon);
    _setMarker("太原診所", "台中市北區太原路一段 532 號", LatLng(24.1648931, 120.673485), "ChIJj4Cj3VQ9aTQRd7B0nm5s3zM", markerIcon);
    _setMarker("文冠內科診所", "台中市北區學士路 255 號 5 樓", LatLng(24.1618921, 120.6806852), "ChIJOfccXmI9aTQRf3v6U2_bd8I", markerIcon);
    _setMarker("聯安醫院", "台中市北屯區東山路一段 37 號", LatLng(24.170599, 120.6993404), "ChIJie5e7O8XaTQRTu9UpHOxDxE", markerIcon);
    _setMarker("中清診所", "台中市北屯區中清路 99-72 號", LatLng(24.1801714, 120.6668239), "ChIJtxZT2swXaTQRYAhEalqvUII", markerIcon);
    _setMarker("榮曜診所", "台中市北屯區青島路四段 46 號", LatLng(24.1679188, 120.6867896), "ChIJMzDzxd0XaTQRapGjaM_zwlY", markerIcon);
    _setMarker("京冠診所", "台中市北屯區崇德路二段 252 號 1F", LatLng(24.1749323, 120.6859182), "ChIJ07DRHMMXaTQR5k1Lj7hDW90", markerIcon);
    _setMarker("台中榮民總醫院", "台中市西屯區中港路三段 160 號", LatLng(24.167898, 120.641076), "ChIJzYhy9PQ9aTQRlISGc2YyE18", markerIcon);
    _setMarker("豐安醫院", "台中市豐原區中正路 115 號", LatLng(24.2516279, 120.7206138), "ChIJ_y0bng8aaTQRyq5kKD3WDcs", markerIcon);
    _setMarker("三豐診所", "台中市豐原區中正路 543 號 5 樓", LatLng(24.249978, 120.709821), "ChIJ9-L9rakQaTQRtKhdYIh7q7c", markerIcon);
    _setMarker("健安內科診所", "台中市后里區甲后路 333 號 3 樓", LatLng(24.3088213, 120.7242065), "ChIJewxXV7saaTQRSekEo5jj84w", markerIcon);
    _setMarker("東勢區農民醫院", "台中市東勢區豐勢路 297 號 8F", LatLng(24.2534386, 120.8291464), "ChIJPc_zeV4caTQRYjcokoXDhD4", markerIcon);
    _setMarker("東勢協和醫院", "台中市東勢區豐勢路 318 號 7 樓", LatLng(24.2530973, 120.8299791), "ChIJD4tJ_UEcaTQRRdyJGCMwG4E", markerIcon);
    _setMarker("東勢蔡外科診所", "台中市東勢區豐勢路 510 號", LatLng(24.258122, 120.8280328), "ChIJ41pC8l8caTQR3FopMPFrlyw", markerIcon);
    _setMarker("慈濟醫院台中分院", "台中市潭子區豐興路一段 66 號", LatLng(24.1941709, 120.7203818), "ChIJ0RTdVCwYaTQRd9b__wqbGdk", markerIcon);
    _setMarker("加安診所", "台中市潭子區雅潭路一段 157 號", LatLng(24.2160142, 120.701153), "ChIJw7MGYn7icTQR2R-sSe-vYkQ", markerIcon);
    _setMarker("清泉醫院", "台中市大雅區雅潭路 178 號", LatLng(24.2167922, 120.6778537), "ChIJz2IXeQIXaTQRcZ6uIRhBcYc", markerIcon);
    _setMarker("雅林診所", "台中市大雅區神林南路 633 號", LatLng(24.2189273, 120.6514127), "ChIJGZc-IfEWaTQRvsTXA6_ugYw", markerIcon);
    _setMarker("晉安診所", "台中市神岡區中山路 906 號", LatLng(24.2505637, 120.6772332), "ChIJLXdJ80BOXTQRXK7MIXwhm2o", markerIcon);
    _setMarker("合安診所", "台中市大肚區沙田路二段 780 號 5F", LatLng(24.1542458, 120.5445597), "ChIJYUFG5SQ8aTQR4or4mkeDhnk", markerIcon);
    _setMarker("童綜合醫院沙鹿院區", "台中市沙鹿區成功西街 8 號", LatLng(24.2429048, 120.560813), "ChIJxZFSYeUUaTQRusnE4O9V0Wg", markerIcon);
    _setMarker("光田綜合醫院", "台中市沙鹿區沙田路 117 號", LatLng(24.2354452, 120.5588474), "ChIJXeZ2UuIUaTQR3VD0i7nsCkU", markerIcon);
    _setMarker("育恩診所", "台中市龍井區遊園南路 339-341 號", LatLng(24.1783628, 120.5827713), "ChIJJyqrIS8-aTQRzzaYQ1fRyA0", markerIcon);
    _setMarker("童綜合醫院梧棲院區", "台中市梧棲區中棲路一段 699 號", LatLng(24.2380969, 120.5681253), "ChIJxZFSYeUUaTQRusnE4O9V0Wg", markerIcon);
    _setMarker("安新診所", "台中市清水區中山路 170 號 3 樓", LatLng(24.2703615, 120.5761403), "ChIJz4ZTu38UaTQR1NM0oAjmFc0", markerIcon);
    _setMarker("高美內科診所", "台中市清水區中山路 94 號 5 樓", LatLng(24.2668384, 120.5747573), "ChIJWaG94n0UaTQR2A6i12uf598", markerIcon);
    _setMarker("李綜合醫院大甲分院", "台中市大甲區八德街 2 號", LatLng(24.3507368, 120.6182367), "ChIJE0dWsv8NaTQRbgAI3d-Upwk", markerIcon);
    _setMarker("光田綜合醫院大甲分院", "台中市大甲區經國路 321 號", LatLng(24.3466462, 120.6164936), "ChIJH7ND8AASaTQRSqXmdVnbZY8", markerIcon);
    _setMarker("蔡精龍診所", "台中市大甲區新政路 254 號", LatLng(24.3511965, 120.6192336), "ChIJ4RfTL_4NaTQRDko7bjyW5h4", markerIcon);
    _setMarker("仁禾診所", "台中市大甲區中山路一段 861 號", LatLng(24.3427493, 120.6233506), "ChIJBYMB0IWpQjQRw3V--DCLN6I", markerIcon);
    _setMarker("秀傳醫療社團法人秀傳紀念醫院", "彰化市中山路一段 542 號", LatLng(24.0649956, 120.5375523), "ChIJY9x6aH04aTQRrYGutiW5M3g", markerIcon);
    _setMarker("信生醫院", "彰化市三民路 312 號", LatLng(24.0858048, 120.5450489), "ChIJuc7gBpY4aTQRtVYGZFKqqIs", markerIcon);
    _setMarker("漢銘醫院", "彰化市中山路一段 366 號 8 樓", LatLng(24.0612656, 120.5356889), "ChIJ8-chiXs4aTQREApjsBrIg3M", markerIcon);
    _setMarker("惠聖診所", "彰化市中正路一段 432 號", LatLng(24.0827029, 120.542625), "ChIJy48C3pY4aTQRgGoUfuRGGAs", markerIcon);
    _setMarker("冠華醫院", "彰化市中正路一段 437 號", LatLng(24.0823919, 120.5428186), "ChIJ53Sh3pY4aTQRToYfztNZp5I", markerIcon);
    _setMarker("仁美診所", "彰化市彰美路一段 186 號 9F", LatLng(24.0888213, 120.5380181), "ChIJu9-N-yEWaTQR2ki0d2qrrOg", markerIcon);
    _setMarker("秀農診所", "彰化縣秀水鄉中山路 328 號", LatLng(24.0350631, 120.5015052), "ChIJ7-3-795HaTQRdaC6ZEII16o", markerIcon);
    _setMarker("彰化基督教醫院鹿基分院", "彰化縣鹿港鎮中正路 480 號", LatLng(24.0604617, 120.4382386), "ChIJbS6SmAlGaTQRZ5ERcPLfdFs", markerIcon);
    _setMarker("財團法人彰濱秀傳紀念醫院", "彰化縣鹿港鎮鹿工路 6 號", LatLng(24.0781759, 120.4110511), "ChIJY9x6aH04aTQRrYGutiW5M3g", markerIcon);
    _setMarker("道周醫院", "彰化縣和美鎮和光路 180 號", LatLng(24.1106408, 120.4919002), "ChIJkSk9uC9HaTQRr6-_0wKLlcQ", markerIcon);
    _setMarker("建霖內科診所", "彰化縣和美鎮彰美路五段 256 號", LatLng(24.109937, 120.5005005), "ChIJ46nMwjZHaTQRBOa3qBMkv_U", markerIcon);
    _setMarker("員林何醫院", "彰化縣員林鎮民族街 33 號 7F", LatLng(23.957127, 120.570565), "ChIJnfj30V42aTQRUe9SU0rZUTw", markerIcon);
    _setMarker("員生醫院", "彰化縣員林鎮莒光路 359 號 2 樓", LatLng(23.959309, 120.566371), "ChIJVZLHvOs3aTQRsVQo0pkfLyY", markerIcon);
    _setMarker("員美診所", "彰化縣員林鎮員東路二段 410 號 5F", LatLng(23.9579964, 120.5791857), "ChIJL1_AlfA2aTQRsBQK00UP53E", markerIcon);
    _setMarker("健新內科診所", "彰化縣員林鎮新生路 366 號", LatLng(23.9641993, 120.5687565), "ChIJh6F78Vk2aTQRf3Uz2JxfaaQ", markerIcon);
    _setMarker("員榮醫院", "彰化縣員林鎮中正路 201 號 3F", LatLng(24.0517963, 120.5161352), "ChIJaZ8yqWY3aTQRrW4kDxTimS0", markerIcon);
    _setMarker("慈元診所", "彰化縣員林鎮林森路 250 號", LatLng(23.9590925, 120.5775961), "ChIJESbEGvc2aTQRw98PpTjupPs", markerIcon);
    _setMarker("衛生福利部彰化醫院", "彰化縣埔心鄉舊館村中正路二段 80 號", LatLng(23.950668, 120.527186), "ChIJ44JcreJJaTQRxTgtKCZ-dRA", markerIcon);
    _setMarker("佳安內科診所", "彰化縣溪湖鎮彰水路四段 57 號 5 樓", LatLng(23.9671463, 120.4797074), "ChIJWa5XMHhJaTQR__ta3U0Tskw", markerIcon);
    _setMarker("俊安內科診所", "彰化縣溪湖鎮彰水路三段 170 號", LatLng(23.957092, 120.4803741), "ChIJHdwHwHhJaTQRAVTW3GGkLhg", markerIcon);
    _setMarker("里仁診所", "彰化縣田中鎮公館路 283 號 2 樓", LatLng(23.8537704, 120.5850515), "ChIJ7SHNoLYJaTQRf8HpPcGrF4Y", markerIcon);
    _setMarker("田安診所", "彰化縣田中鎮福安路 250 號", LatLng(23.8629621, 120.5886334), "ChIJSWQnf2dTXTQR8vp-soiW_wQ", markerIcon);
    _setMarker("彰化基督教二林分院", "彰化縣二林鎮大成路 558 號", LatLng(23.8693892, 120.3117298), "ChIJQ6sDsktNaTQRPzmNj2rblII", markerIcon);
    _setMarker("瑞林診所", "彰化縣二林鎮大成路一段 302 號", LatLng(23.897581, 120.3686006), "ChIJTQ18tDdNaTQRV8QbXvHk9L4", markerIcon);
    _setMarker("卓醫院", "彰化縣北斗鎮中山路一段 311 號 3 樓", LatLng(23.8720822, 120.5154615), "ChIJG087RrtKaTQRWwBT4WKCZaU", markerIcon);
    _setMarker("台大醫院雲林分院虎尾院區", "雲林縣虎尾鎮興中里興中 360 號", LatLng(23.7215609, 120.4367769), "ChIJJ3_usc-wbjQRZYXV_DZg_OI", markerIcon);
    _setMarker("福安醫院", "雲林縣斗南鎮文昌路 110 號", LatLng(23.678938, 120.4819121), "ChIJZ2AxMjO4bjQRxw_8KlO8Tm8", markerIcon);
    _setMarker("若瑟醫院", "雲林縣虎尾鎮新生路 74 號", LatLng(23.7080161, 120.4373426), "ChIJl9dZe1O3bjQRHXj46D8wL5s", markerIcon);
    _setMarker("虎尾鎮農會附設診所", "雲林縣虎尾鎮新興里光復路 185 號", LatLng(23.7093378, 120.4446297), "ChIJcztOVFC3bjQRcUhC_tfwhBU", markerIcon);
    _setMarker("腎安診所", "雲林縣虎尾鎮光復路 360 號", LatLng(23.7103737, 120.4366424), "ChIJB2hTJFO3bjQR8qYKVk-rdPw", markerIcon);
    _setMarker("慈濟醫院斗六門診部", "雲林縣斗六市雲林路二段 248 號", LatLng(23.7024718, 120.5298311), "ChIJR99Muh_IbjQR2Y6EZ1bmuxc", markerIcon);
    _setMarker("台大醫院雲林分院", "雲林縣斗六市雲林路二段 579 號", LatLng(23.6973474, 120.5258909), "ChIJS6aPXaW3bjQRVuL4otsxjFc", markerIcon);
    _setMarker("成大醫院斗六分院", "雲林縣斗六市莊敬路 345 號", LatLng(23.7031007, 120.5454921), "ChIJFWWPfj7IbjQRc1nfw3hdQ4Y", markerIcon);
    _setMarker("洪揚醫院血液透析中心", "雲林縣斗六市文化路 138 號 7F", LatLng(23.7108325, 120.5488173), "ChIJEzm9iDfIbjQR2JAaipKschE", markerIcon);
    _setMarker("明德聯合診所", "雲林縣斗六市明德北路一段 663 號", LatLng(23.718119, 120.543987), "ChIJs9PG6zPIbjQRlL6l6VgfPlY", markerIcon);
    _setMarker("宏德診所", "雲林縣斗六市慶生路 9 號", LatLng(23.7124318, 120.5400838), "ChIJ337PbPGuQjQRvJnY6lW9zTQ", markerIcon);
    _setMarker("彰化基督教醫院雲林分院", "雲林縣西螺鎮新豐里新社 321-90 號", LatLng(23.789182, 120.448883), "ChIJ5-iOHqy2bjQRDKl0awSV5cM", markerIcon);
    _setMarker("上安診所", "雲林縣西螺鎮延平路 353 號 3 樓", LatLng(23.8003737, 120.4546302), "ChIJO6toSwvQDRQRBM6wbTIP85Y", markerIcon);
    _setMarker("中國醫藥大學北港附設醫院", "雲林縣北港鎮新德路 123 號", LatLng(23.590144, 120.307229), "ChIJGQ_Ja_CibjQR-sSWlHUoeeE", markerIcon);
    _setMarker("全生醫院洗腎中心", "雲林縣北港鎮中正路 100 號 6F", LatLng(23.5699399, 120.3015426), "ChIJ8-D0PoaibjQRWzYSn1PPt2s", markerIcon);
    _setMarker("惠腎診所", "雲林縣北港鎮義民路 186 號 2 樓", LatLng(23.5717051, 120.304158), "ChIJBRa4-GGibjQRFAVhveIm0kg", markerIcon);
    _setMarker("衛生福利部嘉義醫院", "嘉義市北港路 312 號", LatLng(23.4814532, 120.4294616), "ChIJzX8NlISWbjQRcbSW0iqrWB4", markerIcon);
    _setMarker("嘉義基督教醫院", "嘉義市忠孝路 539 號", LatLng(23.4996476, 120.4490458), "ChIJy-U8VcSVbjQRvDxmzRg3_jA", markerIcon);
    _setMarker("安馨嘉義內科診所", "嘉義市友愛路 239 號", LatLng(23.4839553, 120.4335687), "ChIJkUe0h4GWbjQRTvmUpA9ROL8", markerIcon);
    _setMarker("宏醫診所", "嘉義市民族路 309 號", LatLng(23.4761757, 120.4528975), "ChIJ7Y4TzTCUbjQRh4MdmuXVaE8", markerIcon);
    _setMarker("民族聯合診所", "嘉義市民族路 701 號", LatLng(23.4752031, 120.4428144), "ChIJe_0D6yWUbjQRuDtBMEDkpnw", markerIcon);
    _setMarker("蘇育諒聯合診所", "嘉義市民族路 732 號", LatLng(23.475487, 120.4425178), "ChIJycVL6SWUbjQRe33dVjqoA_0", markerIcon);
    _setMarker("嘉義榮民醫院", "嘉義市西區世賢路二段 600 號", LatLng(23.4680643, 120.4229796), "ChIJ_-3V3byWbjQRv7Icl_1GnF8", markerIcon);
    _setMarker("祥太醫院", "嘉義市西區延平街 490 號", LatLng(23.476029, 120.440489), "ChIJ7Se3FiaUbjQRc8k42N798CQ", markerIcon);
    _setMarker("聖馬爾定醫院", "嘉義市東區大雅路二段 565 號", LatLng(23.477034, 120.468146), "ChIJaVBmiE6UbjQRyp2zXMK_2GQ", markerIcon);
    _setMarker("嘉義陽明醫院", "嘉義市東區吳鳳北路 252 號", LatLng(23.4804759, 120.4535129), "ChIJR0KECTSUbjQRs-5DUVXsbaQ", markerIcon);
    _setMarker("華濟醫院", "嘉義縣太保市北港路二段 601 巷 66 號", LatLng(23.5012339, 120.3650562), "ChIJAU22LXWXbjQR3mTkZnwtG6o", markerIcon);
    _setMarker("衛生福利部朴子醫院", "嘉義縣朴子市永和里 42-50 號", LatLng(23.4558532, 120.225308), "ChIJa78_TAucbjQRYLftZp_MPJY", markerIcon);
    _setMarker("尚群診所", "嘉義縣朴子市海通路 98-8 號", LatLng(23.4639302, 120.2404346), "ChIJ-1ScMx4faDQRaF2-xPrkYks", markerIcon);
    _setMarker("安聯診所", "嘉義縣民雄鄉建國路一段 211 號", LatLng(23.5583994, 120.4334788), "ChIJczM8HRWObjQRaAbvjikG_yo", markerIcon);
    _setMarker("慈濟綜合醫院大林分院", "嘉義縣大林鎮平林里民生路 2 號", LatLng(23.5974413, 120.4559145), "ChIJ_cs-7gECaDQRNGIcaSByt-g", markerIcon);
    _setMarker("衛生福利部台南醫院", "台南市中區中山路 125 號", LatLng(22.9998999, 120.2268758), "ChIJZ655uIt2bjQRfnwRGhDdz8Y", markerIcon);
    _setMarker("十全診所", "台南市中區永福路二段 3 號", LatLng(22.9902492, 120.2002061), "ChIJO7bvvHx2bjQRLA_UCbss3Gs", markerIcon);
    _setMarker("永和醫院", "台南市中區府前路一段 304 巷 2 號", LatLng(22.9904859, 120.1992254), "ChIJIRqYXnt2bjQRJCvMwG3qtyI", markerIcon);
    _setMarker("康健內兒科診所", "台南市中西區健康路一段 176 號", LatLng(22.9813847, 120.2067745), "ChIJ6bFhXIB2bjQRlJe15bVnXrI", markerIcon);
    _setMarker("光明內科診所", "台南市府前路一段 80 號", LatLng(22.989173, 120.2091563), "ChIJ7T3EI4Z2bjQRrohDN6RWUCw", markerIcon);
    _setMarker("台灣基督教長老教會 新樓醫療財團法人台南新樓醫院", "台南市東區東門路一段 57 號", LatLng(22.9891387, 120.2133326), "ChIJD6hdfI92bjQRh9WrN_iSO-E", markerIcon);
    _setMarker("台南市立醫院", "台南市東區崇德路 670 號", LatLng(22.9687059, 120.2268128), "ChIJpRgOFiJ0bjQRF-0pzQuPVjQ", markerIcon);
    _setMarker("立福內科診所", "台南市東區東門路三段 73 號", LatLng(22.9797809, 120.2315144), "ChIJDZdFKaB2bjQREFQjh8_8hNE", markerIcon);
    _setMarker("石內科診所", "台南市東區東寧路 269 號 3F", LatLng(22.990429, 120.227375), "ChIJk3CYxWyUbjQRMqNBxjpwdDY", markerIcon);
    _setMarker("高茂診所", "台南市東區裕農路 360 號", LatLng(22.9870264, 120.229974), "ChIJc8CkEb12bjQRJQ6KtpxNGZY", markerIcon);
    _setMarker("迦南內科診所", "台南市南區金華路一段 32 號", LatLng(22.9622161, 120.1894962), "ChIJZ05WaMd1bjQR7Pp7lV5pbrA", markerIcon);
    _setMarker("謝智超達恩診所", "台南市西門路二段 375 號 3 樓", LatLng(22.9983056, 120.2001865), "ChIJO-2QOWF2bjQR_tzaz0A99_w", markerIcon);
    _setMarker("國立成功大學醫學院附設醫院", "台南市北區勝利路 138 號", LatLng(23.0021058, 120.219057), "ChIJO9iPQ-x2bjQRDjD6qaQFCd4", markerIcon);
    _setMarker("郭綜合醫院", "台南市西區民生路二段 18 號", LatLng(22.9948175, 120.1987023), "ChIJFbT8emR2bjQRvFVNyBVOp-M", markerIcon);
    _setMarker("林建任內科診所", "台南市北區北安路一段 291 號", LatLng(23.0197868, 120.2060565), "ChIJ7UY_nP92bjQRp2CFfrcTAbs", markerIcon);
    _setMarker("美侖診所", "台南市北區健康路二段 237 號", LatLng(22.9813283, 120.1908141), "ChIJ-6pEYNh1bjQRH5cGoqOJx10", markerIcon);
    _setMarker("陳冠文內科診所", "台南市北區小東路 171 號", LatLng(23.0003446, 120.2271265), "ChIJ_a-ibMZ2bjQRW2pj4CUx_KU", markerIcon);
    _setMarker("弘典內科診所", "台南市北區小東路 323 號", LatLng(22.9992058, 120.2308726), "ChIJl2A7psF2bjQRFPL0zm0K71g", markerIcon);
    _setMarker("公園內科診所", "台南市北區公園路 315 號", LatLng(23.0035193, 120.2100592), "ChIJs_S5b_R2bjQRSW74fhnFLH0", markerIcon);
    _setMarker("文賢內科診所", "台南市文賢路 629 號 1.2 樓", LatLng(23.0132873, 120.1936924), "ChIJY9fnslp2bjQRFQ402O-sZWM", markerIcon);
    _setMarker("腎心診所", "台南市北區西門路四段 268 號", LatLng(23.0120798, 120.209252), "ChIJOZfTwPl2bjQR3jH89G3xmCM", markerIcon);
    _setMarker("福民內科診所", "台南市北區勝利路 226 號", LatLng(23.0046979, 120.2189904), "ChIJN-_GZ-52bjQR2_i0Nitt9lQ", markerIcon);
    _setMarker("育堂診所", "台南市安南區同安路 1 號 2.3.4 樓", LatLng(23.0390504, 120.1881379), "ChIJjeoqL7p3bjQRmJL03V9kBls", markerIcon);
    _setMarker("榮銘內科診所", "台南市安南區海佃路一段 120 號", LatLng(23.0229239, 120.1920713), "ChIJMySaDE12bjQR8n1gX5OCsHA", markerIcon);
    _setMarker("財團法人奇美醫院", "台南市永康區中華路 901 號", LatLng(23.0203921, 120.2218028), "ChIJt8MHid52bjQRQBAsnjbOpZg", markerIcon);
    _setMarker("昕安內科診所", "台南市永康區永大路二段 1010-1012 號", LatLng(23.0174945, 120.2629447), "ChIJkULx3dlwbjQRABFm6SwdFLE", markerIcon);
    _setMarker("侯嘉修內科診所", "台南市永康區中山南路 33 號", LatLng(23.0119195, 120.2268342), "ChIJwxaIOOd2bjQRycVu017giCk", markerIcon);
    _setMarker("華康內科診所", "台南市永康區中華路 313 號", LatLng(23.007693, 120.2341341), "ChIJ6_QyY9t2bjQRSmQXBphSFU0", markerIcon);
    _setMarker("顏大翔內科診所", "台南市永康區大灣路 868 號", LatLng(22.9998592, 120.2566729), "ChIJZXEsGTJxbjQRmwZtgTWiQO0", markerIcon);
    _setMarker("懷仁內科診所", "台南市歸仁區中山路一段 530號", LatLng(22.966688, 120.2957539), "ChIJl-13yHhxbjQRiew-2DLjCYY", markerIcon);
    _setMarker("陳相國聯合診所", "台南市新化區中山路 491-1 號", LatLng(23.035639, 120.3030585), "ChIJDdqin3xwbjQRu87TMAkEjsQ", markerIcon);
    _setMarker("崇仁內科診所", "台南市仁德區中山路 515 號", LatLng(22.9712233, 120.2538301), "ChIJ0yyEp1VxbjQRohm7kzqqYbM", markerIcon);
    _setMarker("仁得內科診所", "台南市仁德區正義一街 29 號", LatLng(22.9722755, 120.252641), "ChIJBUlMIFVxbjQRVKjB6gwdRTU", markerIcon);
    _setMarker("滿福診所", "台南市關廟區南雄路二段 500 號", LatLng(22.9676125, 120.3273474), "ChIJ4TDci-5xbjQRvP0rryC5CQI", markerIcon);
    _setMarker("台灣基督教長老教會新樓醫療財團法人麻豆院區", "台南市麻豆區小埤里苓子林 20 號", LatLng(23.1807422, 120.231687), "ChIJ129L2YV-bjQRHgZKlTBl8d4", markerIcon);
    _setMarker("杏和診所", "台南市麻豆區新生北路 26 號", LatLng(23.1855649, 120.2412729), "ChIJMQfzv39-bjQRLpDMv-EYm-Y", markerIcon);
    _setMarker("佳里醫療社團法人佳里醫院", "台南市佳里區興北里 606 號", LatLng(23.1694465, 120.1704766), "ChIJSXoaS0h_bjQRP62HLapokAo", markerIcon);
    _setMarker("以琳內科診所", "台南市佳里區建南街 161 號", LatLng(23.1592369, 120.1767028), "ChIJB6KfZEt_bjQRVhw89cGxs8Q", markerIcon);
    _setMarker("新生醫院", "台南市佳里區新生路 297 號", LatLng(23.1599549, 120.175637), "ChIJQzuYH5U1aDQRLl3pgQ6SDNY", markerIcon);
    _setMarker("佳新診所", "台南市學甲區華宗路 448 號", LatLng(23.2345904, 120.1828322), "ChIJxcJvigoCaDQR3N4ySAT_3zw", markerIcon);
    _setMarker("衛生福利部新營醫院", "台南市新營區信義街 73 號", LatLng(23.3069254, 120.3147321), "ChIJibr4bduFbjQR_WQCsgkRRs8", markerIcon);
    _setMarker("新興醫療社團法人新興醫院", "台南市新營區中興路 10 號", LatLng(23.3037389, 120.3168546), "ChIJjb6kkt6FbjQR7Gi9qcPTv84", markerIcon);
    _setMarker("佑全診所", "台南市新營區復興路 406 號", LatLng(23.3048557, 120.3005676), "ChIJdcgGHgs9aTQRfje3f4a938k", markerIcon);
    _setMarker("懷德內科診所", "台南市新營區健康路 69 號", LatLng(23.312831, 120.3120402), "ChIJw5EDiPM13DURuh7psl6yXgE", markerIcon);
    _setMarker("營新醫院", "台南市新營區隋唐街 228 號", LatLng(23.3084859, 120.2998575), "ChIJ0SZUgNSFbjQRwNeUccOg2MA", markerIcon);
    _setMarker("佑昇醫院", "台南市白河區民安路 1 號 4 樓", LatLng(23.3462569, 120.4112287), "ChIJu4kftD-ObjQRSdcBIN-qhZ8", markerIcon);
    _setMarker("安聯診所", "台南市白河區中路 118 號", LatLng(23.3336369, 120.4588059), "ChIJczM8HRWObjQRaAbvjikG_yo", markerIcon);
    _setMarker("財團法人奇美醫院柳營分院", "台南市柳營區太康村 201 號", LatLng(23.289918, 120.32924), "ChIJK9Dzsw2GbjQRGsOYizXhOSY", markerIcon);
    _setMarker("錫和診所", "台南市鹽水區武廟路 31 號 6F", LatLng(23.3217189, 120.2656592), "ChIJFxlTYxCEbjQRAFNB5aLaTC0", markerIcon);
    _setMarker("蘇炳文內科診所", "台南市善化區大信路 36 號", LatLng(23.1298639, 120.2925761), "ChIJXznbJYF7bjQRkLJ_0hHKl_I", markerIcon);
    _setMarker("沅林內科診所", "台南市善化區大成路 291 號", LatLng(23.1296495, 120.298505), "ChIJEy0amn97bjQRNzjFBkU9tmM", markerIcon);
    _setMarker("新仁內科診所", "台南市新市區中正路 141 號", LatLng(23.0749592, 120.2913137), "ChIJW69741t6bjQRwLEn0wlDe-s", markerIcon);
    _setMarker("惠仁醫院", "高雄市新興區中山一路 67-2 號", LatLng(22.6298908, 120.3015467), "ChIJv32nGYkEbjQRR3RJ7m3afxY", markerIcon);
    _setMarker("李一鳴內科診所", "高雄市新興區復興一路 44 號", LatLng(22.6302224, 120.3082462), "ChIJcSKKBY4EbjQR8YfMBnOxkaY", markerIcon);
    _setMarker("好生診所", "高雄市前金區七賢二路 183 號", LatLng(22.6331017, 120.2959989), "ChIJvccKmdKVbjQRR25i_elCC6o", markerIcon);
    _setMarker("上順診所", "高雄市前金區中一路 225 號 3 樓", LatLng(22.6012795, 120.2919236), "ChIJyT0tBIADbjQRHVm6Y123hbo", markerIcon);
    _setMarker("高雄市立聯合醫院大同院區", "高雄市前金區中華三路 68 號", LatLng(22.6273601, 120.2974029), "ChIJG3R6elFDbjQRNypzVEqiJkg", markerIcon);
    _setMarker("阮綜合醫療社團法人阮綜合醫院", "高雄市苓雅區成功一路 62 號", LatLng(22.6133208, 120.2982196), "ChIJFUTaH4ADbjQRnFuuw3f3564", markerIcon);
    _setMarker("國軍高雄總醫院", "高雄市苓雅區中正一路 2 號", LatLng(22.6251775, 120.3418165), "ChIJadTHXrQEbjQROllcELI9Zqw", markerIcon);
    _setMarker("財團法人天主教聖功醫院", "高雄市苓雅區建國一路 352 號", LatLng(22.6333516, 120.3239848), "ChIJA9LthMAEbjQRCT-nuAPUQ90", markerIcon);
    _setMarker("高雄市立民生醫院", "高雄市苓雅區凱旋二路 134 號", LatLng(22.626625, 120.3235881), "ChIJt1tbMrwEbjQR9_uORnwXpTI", markerIcon);
    _setMarker("財團法人高雄基督教信義醫院", "高雄市苓雅區華新街 86 號", LatLng(22.614011, 120.2963081), "ChIJnfQUyYEDbjQRWiTXwOvsci8", markerIcon);
    _setMarker("高品診所", "高雄市苓雅區光華一路 109 號", LatLng(22.620769, 120.31663), "ChIJmdSmD4IEbjQRd8Bg4ARLUyY", markerIcon);
    _setMarker("家綾診所", "高雄市苓雅區海邊路 66 號", LatLng(22.6183858, 120.2937871), "ChIJJVLIMX8EbjQReNo9bKaGVMk", markerIcon);
    _setMarker("吳三江內科診所", "高雄市苓雅區憲政路 240 號", LatLng(22.6367074, 120.3215405), "ChIJW6oa0MEEbjQRZ1Zsf80lv98", markerIcon);
    _setMarker("昱泰診所", "高雄市苓雅區興中一路 227 號", LatLng(22.6178686, 120.311371), "ChIJUXlF85wEbjQRS9sXT7Rt62g", markerIcon);
    _setMarker("高雄市立聯合醫院美術館院區", "高雄市鼓山區中華一路 976 號", LatLng(22.6549068, 120.2915368), "ChIJqVkiTlEEbjQRuqjh_6-ogiQ", markerIcon);
    _setMarker("三泰醫院", "高雄市鼓山區九如四路 1030 號", LatLng(22.6556562, 120.2794692), "ChIJq2hPJkkEbjQRSJvEaXT8dyI", markerIcon);
    _setMarker("腎美診所", "高雄市鼓山區中華一路 336 號", LatLng(22.6623533, 120.2921689), "ChIJ_VqtZ6sFbjQRaNvOd-TL6SI", markerIcon);
    _setMarker("高雄市立旗津醫院", "高雄市旗津區廟前路 1-1 號", LatLng(22.6114965, 120.2674085), "ChIJTxTQMbsDbjQRgauwW7F4kfQ", markerIcon);
    _setMarker("博佑診所", "高雄市前區區一心一路 243 號", LatLng(22.6089941, 120.3153829), "ChIJD3VTZ2EDbjQRoNs1G5iQyUA", markerIcon);
    _setMarker("吉泰內科診所", "高雄市前區區保泰路 419 號 2F", LatLng(22.6040522, 120.3358599), "ChIJDQyZz1YDbjQRiU__Gd8OFN8", markerIcon);
    _setMarker("高雄醫學大學附設醫院", "高雄市三民區自由一路 100 號", LatLng(22.649021, 120.3095221), "ChIJIxxC-u8EbjQRnVu1-iQbXds", markerIcon);
    _setMarker("南山醫院", "高雄市三民區建國三路 151 號", LatLng(22.6377336, 120.2985483), "ChIJCz1VsYoEbjQRtI6IB1xsIKU", markerIcon);
    _setMarker("祐生醫院", "高雄市三民區建國三路 60 號", LatLng(22.6379608, 120.2961286), "ChIJP1b5DGAEbjQRTDh-VOrRlEM", markerIcon);
    _setMarker("文雄醫院", "高雄市三民區察哈爾二街 132 號", LatLng(22.6480891, 120.2995044), "ChIJS7nGj_cEbjQReY5AuwXr0Cs", markerIcon);
    _setMarker("德恩診所", "高雄市三民區民族一路 390 號", LatLng(22.6527502, 120.3154558), "ChIJKxpF8WIeaDQRet-1aDL1WAQ", markerIcon);
    _setMarker("茂田診所", "高雄市三民區民誠一路 236 號", LatLng(22.6597791, 120.3260559), "ChIJOVs0CSQFbjQRn7cr-YNhsxg", markerIcon);
    _setMarker("高雄宏明醫院", "高雄市三民區建國三路 415 號", LatLng(22.6362749, 120.2915057), "ChIJx2H00mYEbjQRDDiHk_sTKxs", markerIcon);
    _setMarker("高雄新高鳳醫院", "高雄市三民區莊敬路 288 號", LatLng(22.6497973, 120.3181159), "ChIJxUplkDgbbjQRryWM2fVEYCA", markerIcon);
    _setMarker("右昌聯合醫院", "高雄市楠梓區軍校路 930 號", LatLng(22.713498, 120.2909126), "ChIJTc6IF3oPbjQRBGqiiTX3aw0", markerIcon);
    _setMarker("健仁醫院", "高雄市楠梓區楠陽路 136 號", LatLng(22.7237039, 120.3291328), "ChIJx_iPYsQPbjQRG6DarioZQKk", markerIcon);
    _setMarker("佑強診所", "高雄市楠梓區德民路 908 號", LatLng(22.7212128, 120.2895637), "ChIJlYSmxXMPbjQRspSIoXiG0gs", markerIcon);
    _setMarker("楠華診所", "高雄市楠梓區興楠路 295 號", LatLng(22.729446, 120.332934), "ChIJl3F_OtAPbjQRGdvCzD4oHiU", markerIcon);
    _setMarker("興義診所", "高雄市楠梓區興楠路 342 號", LatLng(22.7293724, 120.3317651), "ChIJh14z2c8PbjQRmvvBfKzuOrc", markerIcon);
    _setMarker("高雄市立小港醫院", "高雄市小港區山明路 482 號", LatLng(22.5674212, 120.3633487), "ChIJw6-hTCIdbjQRhy6GQMXgZwg", markerIcon);
    _setMarker("佳生診所", "高雄市小港區康莊路 136 號", LatLng(22.568269, 120.35353), "ChIJTY_cx9AcbjQR4M0PKrWzkfs", markerIcon);
    _setMarker("明港診所", "高雄市小港區華山路 137 號", LatLng(22.5664272, 120.3674282), "ChIJOWwTb-ccbjQRV34AonSFkJQ", markerIcon);
    _setMarker("高健診所", "高雄市小港區漢民路 702 號 1、2 樓", LatLng(22.567438, 120.361893), "ChIJ1cxwydYcbjQRjZZY6j6rTdY", markerIcon);
    _setMarker("高雄榮民總醫院", "高雄市左營區大中一路 386 號", LatLng(22.6809509, 120.3221722), "ChIJaTsDXEAFbjQRApQiBLzUyHE", markerIcon);
    _setMarker("國軍左營醫院", "高雄市左營區軍校路 553 號", LatLng(22.7012121, 120.290507), "ChIJe79934YFbjQRsiPlNrccUmE", markerIcon);
    _setMarker("田源診所", "高雄市左營區政德路 230 號", LatLng(22.67722, 120.300269), "ChIJV8xXTQoFbjQRguIyp6Y41vU", markerIcon);
    _setMarker("東陽診所", "高雄市左營區華夏路 626 號", LatLng(22.6767304, 120.3012965), "ChIJrZ9dvAsFbjQRN03CQUtBYkI", markerIcon);
    _setMarker("劉內兒科診所", "高雄市仁武區灣內村仁心路 6 號", LatLng(22.681955, 120.355988), "ChIJTzUIg5KrQjQReIk5VGdcTzc", markerIcon);
    _setMarker("尚清診所", "高雄市仁武區中華路 245 號", LatLng(22.7002659, 120.3513313), "ChIJzdTF8QQQbjQR7-d2KZpSAyg", markerIcon);
    _setMarker("國軍岡山醫院", "高雄市岡山區大義二路 1 號", LatLng(22.7894134, 120.2856305), "ChIJ1ZE7N50ObjQRjoToiIfNiRo", markerIcon);
    _setMarker("高雄市立岡山醫院", "高雄市岡山區壽天路 12 號", LatLng(22.7965684, 120.2946286), "ChIJf4Sp-CwMbjQRj7rP3DXH3gk", markerIcon);
    _setMarker("蔣榮福診所", "高雄市岡山區中山南路 452 號", LatLng(22.7903029, 120.2995601), "ChIJg-Bb4tQNbjQRxjyScwulevU", markerIcon);
    _setMarker("岡山內科診所", "高雄市岡山區岡山路 146.148 號", LatLng(22.7928274, 120.2959116), "ChIJ1b1KpSoMbjQRpsYx1HYcqlQ", markerIcon);
    _setMarker("惠川醫院", "高雄市岡山區岡山路 92 號", LatLng(22.7879803, 120.2967518), "ChIJW0KQD4AObjQRDULwOHtxbdo", markerIcon);
    _setMarker("路竹診所", "高雄市路竹區國昌路 136 號", LatLng(22.8547643, 120.256909), "ChIJyQk1XpgMbjQRzIgFrHOLnuM", markerIcon);
    _setMarker("義大醫療財團法人義大醫院", "高雄市燕巢區角宿村義大路 1 號", LatLng(22.7659067, 120.3643555), "ChIJc3Lq-vIRbjQRYQecilWfKOI", markerIcon);
    _setMarker("湖康診所", "高雄市湖內區中正路一段 397 號", LatLng(22.9088222, 120.2177401), "ChIJqVVjoEX7AzQROzM_R2HZTA4", markerIcon);
    _setMarker("高雄市立鳳山醫院", "高雄市鳳山區經武路 42 號", LatLng(22.6285095, 120.363105), "ChIJB7Ub7j4bbjQRNd1G3rOUtQE", markerIcon);
    _setMarker("嘉美診所", "高雄市鳳山區中山路 79 號", LatLng(22.621417, 120.36016), "ChIJdVSYyEYbbjQRd6Uca-CvODQ", markerIcon);
    _setMarker("長新診所", "高雄市鳳山區建國路二段 59-2 號", LatLng(22.6354623, 120.3610545), "ChIJwa97MkEbbjQRyF-xZtsWaZ0", markerIcon);
    _setMarker("新華田內科診所", "高雄市鳳山區曹公路 16-4 號", LatLng(22.6288948, 120.3573055), "ChIJqRM4rjkbbjQROR85cxKWo5Y", markerIcon);
    _setMarker("佳醫診所", "高雄市鳳山區五甲二路 357 號", LatLng(22.5980414, 120.3362626), "ChIJB-A6TZM1aDQR-0m4oKvUIB0", markerIcon);
    _setMarker("惠德醫院", "高雄市鳳山區福祥街 81 號", LatLng(22.5921035, 120.3251207), "ChIJYXtXJ0EDbjQRMIwDnFHEJLo", markerIcon);
    _setMarker("健聖診所", "高雄市大寮區中正路 2 號", LatLng(22.6172155, 120.3853824), "ChIJP4n_X3QbbjQR2OrQbrHxMfI", markerIcon);
    _setMarker("幸安診所", "高雄市大寮區鳳林三路 526 號", LatLng(22.6065099, 120.3954662), "ChIJ4QXnV4MbbjQREiGn5_YKyLc", markerIcon);
    _setMarker("建佑醫院", "高雄市林園區東林西路 360 號", LatLng(22.50382, 120.38668), "ChIJV4ToUobicTQRr7jpBjeyI8M", markerIcon);
    _setMarker("高雄長庚醫院", "高雄市鳥松區大埤路 123 號", LatLng(22.6493809, 120.3527915), "ChIJ02Bai9cabjQRCUg3pkBvTrM", markerIcon);
    _setMarker("廣聖醫院", "高雄市旗山區中華路 618 號", LatLng(22.8849805, 120.4854746), "ChIJIRh1u1NqbjQReATowN94RNc", markerIcon);
    _setMarker("芳民診所", "高雄市旗山區大德里德昌路 16 號", LatLng(22.8832768, 120.4826404), "ChIJC9cwpFRqbjQRxAK0BuRHGuQ", markerIcon);
    _setMarker("溪洲醫院", "高雄市旗山區延平一路 412 號 7F", LatLng(22.8928193, 120.4832034), "ChIJm8SmxkxqbjQR1nynron_EgE", markerIcon);
    _setMarker("永萣診所", "高雄市茄萣區白砂路 251 號", LatLng(22.91333, 120.185055), "ChIJV2jNMSl1bjQRu4h7iVpmk40", markerIcon);
    _setMarker("加昇診所", "高雄市茄萣區仁愛路三段 56 巷 1-5號", LatLng(22.9005571, 120.1847297), "ChIJ8z9_ADV1bjQRZiWSgbvyPVM", markerIcon);
    _setMarker("大武診所", "屏東市大武路 23 號", LatLng(22.6561464, 120.4781903), "ChIJrfBwWtIZbjQRuFeaVRphJ04", markerIcon);
    _setMarker("屏東基督教醫院", "屏東市大連路 60 號", LatLng(22.6831312, 120.5041555), "ChIJy_o4rLgXbjQRxZiVW-VqlG0", markerIcon);
    _setMarker("寶建醫院", "屏東市中山路 123 號", LatLng(22.6814439, 120.4843319), "ChIJ3cCJXp4XbjQR3rUcJfrulf8", markerIcon);
    _setMarker("佳屏診所", "屏東市中正路 207-1 號 1-3 樓", LatLng(22.6809116, 120.49143), "ChIJRX7l09IZbjQR56IZz9AJBn4", markerIcon);
    _setMarker("林修哲內科診所", "屏東市中華路 69 號", LatLng(22.6730357, 120.4900867), "ChIJAQALKYUXbjQRFy1x2RiYPhM", markerIcon);
    _setMarker("國仁醫院", "屏東市民生東路 12-2 號", LatLng(22.6583156, 120.5145497), "ChIJV82oxvcXbjQRlmdomQQU0DU", markerIcon);
    _setMarker("復興醫院", "屏東市民生路 147-3 號", LatLng(22.6685213, 120.4957531), "ChIJ8cJ2tWtS8DURSDTEKe7kZ6o", markerIcon);
    _setMarker("衛生福利部屏東醫院", "屏東市自由路 270 號", LatLng(22.6733243, 120.4955525), "ChIJ5f1VrZEXbjQRiStajhi8Ymo", markerIcon);
    _setMarker("國軍高雄總醫院屏東分院", "屏東市龍華里大湖路 58 巷 22 號", LatLng(22.6333688, 120.4876936), "ChIJ06ZYKkwYbjQRcl4kC4jD5SY", markerIcon);
    _setMarker("龍泉榮民醫院", "屏東縣內埔鄉龍潭村昭勝路安平一巷 1 號", LatLng(22.676762, 120.601633), "ChIJST-M44w8bjQRBcSBk0_Vq74", markerIcon);
    _setMarker("枋寮醫院", "屏東縣枋寮鄉中山路 139 號", LatLng(22.3639316, 120.5963465), "ChIJw9tl1D_ccTQRcpxDggbakaE", markerIcon);
    _setMarker("東港安泰醫院", "屏東縣東港鎮中正路一段 210 號", LatLng(22.4740818, 120.4592153), "ChIJ1b0x2b_hcTQRvAY2wuwy_0E", markerIcon);
    _setMarker("恆春基督教醫院", "屏東縣恆春鎮恆西路 21 號", LatLng(22.0023386, 120.7410562), "ChIJg0WJJs-wcTQRj4cBlmPJnsE", markerIcon);
    _setMarker("南門醫院", "屏東縣恆春鎮南門路 10 號", LatLng(22.0009266, 120.7453672), "ChIJw2r7D-o1aDQRP7N6j9sNlCc", markerIcon);
    _setMarker("屏東縣琉球鄉衛生所", "屏東縣琉球鄉本福村中山路 51 號", LatLng(22.3485316, 120.3784757), "ChIJ4XJSUnvlcTQR4ZN_JYYhT1w", markerIcon);
    _setMarker("衛生福利部屏東醫院恒春分院", "屏東縣恆春鎮恒南路 188 號", LatLng(21.9993068, 120.7452541), "ChIJJbhHUM6wcTQRgq5FoTQKB6Q", markerIcon);
    _setMarker("人晟診所", "屏東縣潮州鎮中山路 179 號", LatLng(22.5497783, 120.5373095), "ChIJfQYBZuYhbjQRzFntRlTlLAo", markerIcon);
    _setMarker("沐民診所", "屏東縣九如鄉九如路二段 189 號", LatLng(22.7338686, 120.488995), "ChIJnSyNQWQWbjQRDAfs9hL9o6Q", markerIcon);
    _setMarker("德埔診所", "屏東縣內埔鄉東寧村平昌街 7 號", LatLng(22.618393, 120.565537), "ChIJwV1cSuQibjQRGBf7-zZ6G3I", markerIcon);
    _setMarker("慈濟綜合醫院", "花蓮市中央路三段 707 號", LatLng(23.9961293, 121.5925887), "ChIJ_cs-7gECaDQRNGIcaSByt-g", markerIcon);
    _setMarker("衛生福利部花蓮醫院", "花蓮市中正路 600 號", LatLng(23.9794291, 121.6111823), "ChIJV-25WMGfaDQR9RP2CLeug_A", markerIcon);
    _setMarker("門諾會醫院", "花蓮市民權路 44 號", LatLng(23.9881894, 121.6267932), "ChIJ7yJA7NWfaDQRB7cGZvJ30Js", markerIcon);
    _setMarker("美崙聯安診所", "花蓮市正義街 8-2 號 3F", LatLng(23.9833255, 121.6063127), "ChIJ_0UKb8efaDQRPTOWlWLKydU", markerIcon);
    _setMarker("懷德診所", "花蓮市復興街 10 號", LatLng(23.9757918, 121.6114044), "ChIJP-mASpkgaDQRNU6JxiOP8QM", markerIcon);
    _setMarker("花蓮玉里榮民醫院", "花蓮縣玉里鎮新興街 91 號", LatLng(23.3392092, 121.3120416), "ChIJ61MbIn9qbzQRZ0728wSyQYQ", markerIcon);
    _setMarker("衛生福利部玉里醫院洗腎室", "花蓮縣玉里鎮中華路 448 號 3F", LatLng(23.3474832, 121.3210036), "ChIJXw5Nk9pBbzQRClQOM_oLbdU", markerIcon);
    _setMarker("國軍花蓮總醫院", "花蓮縣新城鄉嘉里村嘉里路 163 號", LatLng(24.0233237, 121.6066664), "ChIJ5SDtEcifaDQRCk5CVBl2Y9I", markerIcon);
    _setMarker("鳳林榮民醫院", "花蓮縣鳳林鎮中正路一段 2 號", LatLng(23.8363035, 121.5041314), "ChIJayemrAiyaDQRG_mCBLDs3fc", markerIcon);
    _setMarker("衛生福利部台東醫院", "台東市五權街 1 號", LatLng(22.7570265, 121.1507077), "ChIJBYRTiT-5bzQRYXr0iUPTpZ8", markerIcon);
    _setMarker("台東基督教醫院", "台東市開封街 350 號 6 樓", LatLng(22.7638706, 121.1462787), "ChIJ6-46K2q5bzQRY5-hd7IPgGA", markerIcon);
    _setMarker("台東榮民醫院", "台東市更生路 1000 號", LatLng(22.772343, 121.1325704), "ChIJ0bI5CXq5bzQRi0UruMYIoA8", markerIcon);
    _setMarker("馬偕醫院台東分院", "台東市長沙街 303 巷 1 號", LatLng(22.7511439, 121.1408337), "ChIJv68j-RC5bzQR0MxfTapQ3nI", markerIcon);
    _setMarker("陳明正內科診所", "台東市鄭州路 3 號 3 樓", LatLng(22.76178941, 121.144308), "ChIJ5RI9p2u5bzQRl0BwAIaXRGY", markerIcon);
    _setMarker("衛生福利部南投醫院", "南投市復興路 478 號", LatLng(23.9140079, 120.6849431), "ChIJnTR6zI0xaTQRPF_2zhaOIDc", markerIcon);
    _setMarker("衛生福利部南投中興院區", "南投市環山路 57 號", LatLng(23.952306, 120.6947558), "ChIJMyr-UTEwaTQRDSNuMOyYSn4", markerIcon);
    _setMarker("南基醫院", "南投市中興路 870 號", LatLng(23.8989152, 120.6839325), "ChIJpcFMyiMyaTQR3PYFA_dHCIc", markerIcon);
    _setMarker("新協合聯合診所", "南投市三和二路 105 號", LatLng(23.9038029, 120.6868243), "ChIJMZw2XSAyaTQRpeLduYzMAeM", markerIcon);
    _setMarker("水里社區基督聯合診所", "南投縣水里鄉中正路 38 號", LatLng(23.8166046, 120.854717), "ChIJU2g4kPwqaTQRzhvNI-NCnac", markerIcon);
    _setMarker("竹山秀傳醫院", "南投縣竹山鎮集山路二段 75 號", LatLng(23.8000834, 120.7142318), "ChIJnY1tpqfSbjQRJkOCnII-00g", markerIcon);
    _setMarker("安馨竹山內科診所", "南投縣竹山鎮集山路三段 483 號", LatLng(23.7610616, 120.6935331), "ChIJyZ6V7JbNbjQR1ELom8Ruy9A", markerIcon);
    _setMarker("瑞竹診所", "南投縣竹山鎮下坪里枋坪巷 2-9 號", LatLng(23.775418, 120.6665624), "ChIJB3ez2bvNbjQRw1BsYbqxBaY", markerIcon);
    _setMarker("埔里榮民醫院", "南投縣埔里鎮榮光路 1 號", LatLng(23.9786938, 120.9943312), "ChIJS88lf9DbaDQRGFJnVq3JrVQ", markerIcon);
    _setMarker("埔里基督教醫院", "南投縣埔里鎮鐵山路 1 號 2 樓", LatLng(23.9714034, 120.9465406), "ChIJV5pKCqzZaDQRg4OCbw-GGow", markerIcon);
    _setMarker("金生診所", "南投縣埔里鎮西安路一段 88 號", LatLng(23.9657094, 120.966126), "ChIJv9yTy5jZaDQRce5JxZP2I7E", markerIcon);
    _setMarker("佑民綜合醫院", "南投縣草屯鎮太平路一段 200 號", LatLng(23.9606022, 120.6817657), "ChIJO3N9kkUwaTQRlkwWbfZ5uGQ", markerIcon);
    _setMarker("草屯陳診所", "南投縣草屯鎮太平路二段 228 號", LatLng(23.975936, 120.68395), "ChIJMalmBWwwaTQRKzpPljLb6pY", markerIcon);
    _setMarker("中國醫藥大學附設草屯分院", "南投縣草屯鎮平等街 140 號", LatLng(23.9847686, 120.6859401), "ChIJuUq_i24waTQRfnr2V-gy8tc", markerIcon);
    _setMarker("曾漢棋綜合醫院", "曾漢棋綜合醫院", LatLng(23.9785896, 120.6857436), "ChIJMzYOpG0waTQR4Ou51hj4_hg", markerIcon);
    _setMarker("三軍總醫院澎湖分院", "澎湖縣馬公市前寮里 90 號", LatLng(23.5542923, 119.5847087), "ChIJP5_MFrxabDQRPJ4kle89SUs", markerIcon);
    _setMarker("衛生福利部澎湖醫院", "馬公市中正路 10 號", LatLng(23.5643266, 119.5657652), "ChIJpVO224xabDQRFdjWoL1d3N0", markerIcon);


  }


  Future<void> moveCameraSlightly() async {

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng( destination.latitude + 0.0125,  destination.longitude - 0.005),
      zoom: 14.0,
      // bearing: 45.0,
      // tilt: 45.0
    )));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }



  // Flipcard: review and photo
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
                      style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold
                      )
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
                      fontWeight: FontWeight.bold,
                      fontSize: 9.0
                  ),
                  valueLabelRadius: 7,
                  maxValue: 5,
                  starSpacing: 2,
                  maxValueVisibility: false,
                  valueLabelVisibility: true,
                  animationDuration: Duration(milliseconds: 500),
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
              style: const TextStyle(
                fontSize: 11.0,
              ),
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
              style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold
              )),
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
                    'prev-page'.i18n(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            Text(
              '$tempDisplayIndex/' + photoElement.length.toString(),
              style: const TextStyle(
                fontSize: 12.0,
              ),
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
                        ? Colors.lightGreen
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'next-page'.i18n(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
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

