import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};
List<LatLng> polylineCoordinates = [];

DatabaseReference ref;
DatabaseReference ref1;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uygulama',
      home: Anasayfa(),
    );
  }
}

//var date1;
//var date2;
class Anasayfa extends StatefulWidget {
  @override
  _AnasState createState() => _AnasState();
}

class _AnasState extends State<Anasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobil Sorgular"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                      child: Text("Tip1"),
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Tip1()),
                          )),
                  ElevatedButton(
                      child: Text("Tip2"),
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Tip2_2()),
                          )),
                  ElevatedButton(
                      child: Text("Tip3"),
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Tip3()),
                          )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tip1 extends StatelessWidget {
  List<dynamic> valuee1 = [];
  List<dynamic> valuee = [];
  List<dynamic> valuee2 = [];
  List<dynamic> valuee3 = [];
  Future Tip1_1() async {
    ref = FirebaseDatabase.instance.reference().child("taxi+_zone_lookup");

    ref1 =
        FirebaseDatabase.instance.reference().child("yellow_tripdata_2020-12");

    (await ref1.orderByChild('passenger_count').limitToLast(5).onValue.first)
        .snapshot
        .value
        .values
        .forEach((v) {
      valuee2.add(v['passenger_count']);
      valuee3.add(v['tpep_dropoff_datetime'] + "\n");

      print("passenger count: " +
          v['passenger_count'] +
          "  " +
          "Gun: " +
          v['tpep_dropoff_datetime']);
    });
    valuee.add(valuee2);
    valuee1.add(valuee3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobil Sorgular"),
      ),
      body: projectWidget(),
    );
  }

  Widget projectWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        return ListView.builder(
          itemCount: valuee.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                 Text( "\n" + "\n"),
                Text(valuee.toString() + "\n" + "\n"),
                Text(valuee1.toString()),
                 Text( "\n" + "\n"),

                ElevatedButton(
                  
                    child: Text("Geri"),
                    onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        )),
                // Widget to display the list of project
              ],
            );
          },
        );
      },
      future: Tip1_1(),
    );
  }
}


var date1;
var date2;

class Tip2_2 extends StatelessWidget {
  TextEditingController t1 = TextEditingController();
TextEditingController t2 = TextEditingController();
    void Deneme()
    {
      date1 = t1.text;
      date2 = t2.text;    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Mobil Sorgular"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
               TextField(
                controller: t1,
              ),
              TextField(
                controller: t2,
              ),

              Row(
                children: [
                
                  ElevatedButton(
                      child: Text("Sonuc"),
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Tip2()),
                    )),
                    ElevatedButton(
                      child: Text("Gönder"),
                      onPressed: Deneme)
                ],
              ),
            ],
          ),
        ),
      ),
    );


  }
  
}
class Tip2 extends StatelessWidget {
  List<dynamic> yolculuk = [];
  List<dynamic> yolculuk1 = [];
  List<dynamic> yolculuk2 = [];
  List<dynamic> valuess = [];
  List<String> do_valuess = [];
  List<String> pul_valuess = [];
  List<String> do_valuess1 = [];
  List<String> pul_valuess1 = [];
  List<String> valuess1 = [];

  List<dynamic> mesafeler = [];

  Future Tip2_1() async {
    ref = FirebaseDatabase.instance.reference().child("taxi+_zone_lookup");

    ref1 =
        FirebaseDatabase.instance.reference().child("yellow_tripdata_2020-12");

    await ref1
        .orderByChild('tpep_dropoff_datetime')
        .once()
        .then((snapshot) async {
      snapshot.value.forEach((values) {
        var deger = values['tpep_dropoff_datetime'].toString();
        if (int.parse(deger.substring(8, 10)) >= int.parse(date1) &&
            int.parse(deger.substring(8, 10)) <= int.parse(date2)) {
          print(values['tpep_dropoff_datetime']);
          valuess1.add(values['trip_distance']);
          do_valuess1.add(values['DOLocationID']);
          pul_valuess1.add(values['PULocationID']);
        }
      });
    });
    for (var i = 0; i < valuess1.length; i++) {
      for (var j = 0; j < valuess1.length - 1; j++) {
        if (double.parse(valuess1[j]) > double.parse(valuess1[j + 1])) {
          var tempc = do_valuess1[j];
          var tempk = pul_valuess1[j];
          var tempv = valuess1[j];

          do_valuess1[j] = do_valuess1[j + 1];
          pul_valuess1[j] = pul_valuess1[j + 1];
          valuess1[j] = valuess1[j + 1];

          do_valuess1[j + 1] = tempc;
          pul_valuess1[j + 1] = tempk;
          valuess1[j + 1] = tempv;
        }
      }
    }

    for (var i = 0; i < 5; i++) {
      do_valuess.add(do_valuess1[i]);
      pul_valuess.add(pul_valuess1[i]);
      valuess.add(valuess1[i]);
    }

    print(do_valuess);
    print(pul_valuess);
    print(valuess);

    for (var i = 0; i < do_valuess.length; i++) {
      await ref.orderByChild('LocationID').once().then((snapshot) async {
        snapshot.value.forEach((values) {
          if (do_valuess[i] == values['LocationID']) {
            yolculuk.add("DO : " + values['Borough'] + "   " + values['Zone']);

            print("DO : " + values['Borough'] + "// " + values['Zone']);
          }
          if (pul_valuess[i] == values['LocationID']) {
            yolculuk.add("PUL: " + values['Borough'] + "   " + values['Zone']);

            print("PUL: " + values['Borough'] + "// " + values['Zone']);
          }
        });
      });
      mesafeler.add(valuess[i]);
    }
    for (var i = 0; i < yolculuk.length; i++) {
      if (yolculuk[i][0] == 'D') {
        yolculuk1.add(yolculuk[i]);
      }
      if (yolculuk[i][0] == 'P') {
        yolculuk2.add(yolculuk[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobil Sorgular"),
      ),
      body: projectWidget1(),
    );
  }

  Widget projectWidget1({Center child}) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        return ListView.builder(
          itemCount: mesafeler.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Text("\n" + "\n" + "\n" + "\n" + "\n"),
                Text(mesafeler.toString() + "\n" + "\n"),
                Text(yolculuk1.toString() + "\n" + "\n"),
                Text(yolculuk2.toString() + "\n" + "\n"),
                Text("\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n"),
                ElevatedButton(
                    child: Text("Geri"),
                    onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        )),
              ],
            );
          },
        );
      },
      future: Tip2_1(),
    );
  }
}
 


List<String> yollar = [];
List<dynamic> Yollar2 = [];
Map<MarkerId, Marker> markers = {};

double _originLatitude;
double _originLongitude;
double _destLatitude;
double _destLongitude;

double _originLatitude1;
double _originLongitude1;
double _destLatitude1;
double _destLongitude1;
 List<dynamic> son = [];
class Tip3 extends StatelessWidget {
  List<dynamic> Yollar_yazdirma = [];
  Future Tip3_1() async {
    ref = FirebaseDatabase.instance.reference().child("taxi+_zone_lookup");

    ref1 =
        FirebaseDatabase.instance.reference().child("yellow_tripdata_2020-12");

    List<dynamic> valuess = [];
   
    List<dynamic> valuess1 = [];
    List<String> do_valuess = [];
    List<String> pul_valuess = [];

    (await ref1.orderByChild('tpep_dropoff_datetime').onValue.first)
        .snapshot
        .value
        .forEach((values) {
      if (int.parse(values['passenger_count']) >= 3) {
        valuess.add(values['trip_distance']);
        valuess1.add(values['passenger_count']);
        do_valuess.add(values['DOLocationID']);
        pul_valuess.add(values['PULocationID']);
      }
    });

    for (var i = 0; i < valuess.length; i++) {
      for (var j = i + 1; j < valuess.length; j++) {
        if (double.parse(valuess[i]) > double.parse(valuess[j])) {
          var tempc = valuess[i];
          var tempk = valuess1[i];
          var temps = do_valuess[i];
          var tempd = pul_valuess[i];

          valuess[i] = valuess[j];
          valuess1[i] = valuess1[j];
          do_valuess[i] = do_valuess[j];
          pul_valuess[i] = pul_valuess[j];

          valuess[j] = tempc;
          valuess1[j] = tempk;
          do_valuess[j] = temps;
          pul_valuess[j] = tempd;
        }
      }
    }

    
    print(valuess[0]);
    son.add(valuess[0]);
    son.add(valuess[valuess.length - 1]);
    print(valuess[valuess.length - 1]);
    print(do_valuess[0] + " " + pul_valuess[0]);
    print(do_valuess[do_valuess.length - 1] +
        " " +
        pul_valuess[pul_valuess.length - 1]);

    (await ref.orderByChild('LocationID').onValue.first)
        .snapshot
        .value
        .forEach((values) {
      if (do_valuess[0] == values['LocationID']) {
        yollar.add(values['Zone']);
       
      }
      if (pul_valuess[0] == values['LocationID']) {
        yollar.add(values['Zone']);
       
      }
      if (do_valuess[valuess.length - 1] == values['LocationID']) {
        yollar.add(values['Zone']);
       
      }
      if (pul_valuess[valuess.length - 1] == values['LocationID']) {
        yollar.add(values['Zone']);
        
      }
    });

    for (var i = 0; i < yollar.length; i++) {
      var addresses = await Geocoder.local.findAddressesFromQuery(yollar[i]);
      var first = addresses.first;
      print("${first.featureName} : ${first.coordinates}");
      Yollar2.add((first.coordinates).toString());
    }

    var latlong;
    var latlong1;
    var latlong2;
    var latlong3;

    String yol = Yollar2[0].toString();
    yol = yol.substring(1, Yollar2[0].length - 1);
    print(yol);

    latlong = yol.split(',');
    _originLatitude = double.parse(latlong[0]);
    _originLongitude = double.parse(latlong[1]);

    String yol1 = Yollar2[1].toString();
    yol1 = yol1.substring(1, Yollar2[1].length - 1);
    print(yol1);

    latlong1 = yol1.split(',');
    _destLatitude = double.parse(latlong1[0]);
    _destLongitude = double.parse(latlong1[1]);

    String yol2 = Yollar2[2].toString();
    yol2 = yol2.substring(1, Yollar2[2].length - 1);
    print(yol2);

    latlong2 = yol2.split(',');
    _originLatitude1 = double.parse(latlong2[0]);
    _originLongitude1 = double.parse(latlong2[1]);

    String yol3 = Yollar2[3].toString();
    yol3 = yol3.substring(1, Yollar2[3].length - 1);
    print(yol3);

    latlong3 = yol3.split(',');
    _destLatitude1 = double.parse(latlong3[0]);
    _destLongitude1 = double.parse(latlong3[1]);
    Yollar_yazdirma.add(yollar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobil Sorgular"),
      ),
      body: projectWidget2(),
    );
  }

  Widget projectWidget2({Center child}) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        return ListView.builder(
          itemCount: Yollar_yazdirma.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Text(Yollar_yazdirma.toString()),
                Text(son.toString()),

                ElevatedButton(
                  child: Text("Geri"),
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      )),
                ),
                ElevatedButton(
                  child: Text("Haritada Göster"),
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Google(),
                      )),
                ),
              ],
            );
          },
        );
      },
      future: Tip3_1(),
    );
  }
}

class Google extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Google> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(_originLatitude, _originLongitude),
    zoom: 9.4746,
  );

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    _addMarker(
      LatLng(_originLatitude, _originLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    _addMarker(
      LatLng(_originLatitude1, _originLongitude1),
      "origin1",
      BitmapDescriptor.defaultMarker,
    );

    _addMarker(
      LatLng(_destLatitude, _destLongitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    _addMarker(
      LatLng(_destLatitude1, _destLongitude1),
      "destination1",
      BitmapDescriptor.defaultMarkerWithHue(70),
    );

    _getPolyline();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Google Maps'),
          
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              polylines: Set<Polyline>.of(polylines.values),
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            ElevatedButton(
                child: Text("Geri"),
                onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    )),
          ],
        ),

      
            

      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _addPolyLine1(List<LatLng> polylineCoordinates1) {
    PolylineId id = PolylineId("poly1");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates1,
      width: 5,
      color: Colors.red,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];
    List<LatLng> polylineCoordinates1 = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "GoogleMapAPIKey",
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    PolylineResult result1 = await polylinePoints.getRouteBetweenCoordinates(
      "GoogleMapAPIKey",
      PointLatLng(_originLatitude1, _originLongitude1),
      PointLatLng(_destLatitude1, _destLongitude1),
      travelMode: TravelMode.driving,
    );

    if (result1.points.isNotEmpty) {
      result1.points.forEach((PointLatLng point) {
        polylineCoordinates1.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result1.errorMessage);
    }

    _addPolyLine(polylineCoordinates);
    _addPolyLine1(polylineCoordinates1);
  }
}     