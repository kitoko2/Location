import 'package:flutter/services.dart';
import "package:location/location.dart";
import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "poyLocation",
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  onCameraMove(CameraPosition p) {
    print(p);
  }

  Set<Marker> markers = {};
  Location location = new Location();
  LatLng result = LatLng(0, 0);
  var accepted = false;
  func() async {
    LocationData ld = await location.getLocation();
    if (await location.serviceEnabled()) {
      setState(() {
        accepted = true;
        result = LatLng(ld.latitude as dynamic, ld.longitude as dynamic);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    func();
  }

  MapType m = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "me localiser",
        onPressed: accepted
            ? () {
                setState(() {
                  markers.add(
                    Marker(
                      markerId: MarkerId("1"),
                      position: result,
                    ),
                  );
                });
              }
            : () {
                print("TU N'AS PAS ACCEPTER LA LOCALISATION");
              },
        child: Icon(Icons.location_on_sharp),
      ),
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              mapType: m,
              initialCameraPosition: CameraPosition(
                target: LatLng(1, 230),
              ),
              onCameraMove: onCameraMove,
              markers: markers,
            ),
          ),
          Positioned(
            top: 30,
            left: MediaQuery.of(context).size.width / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      m = MapType.satellite;
                    });
                  },
                  child: Text("satelite"),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      m = MapType.normal;
                    });
                  },
                  child: Text("normal"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
