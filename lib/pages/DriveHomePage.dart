import 'dart:io';
import 'dart:async';
import 'package:apptestewillians/services/background_service.dart';
import 'package:flutter/material.dart';
// import '../controller/RoutePageDrive.dart';
import 'package:apptestewillians/pages/DriveComVehicle.dart';
import "package:apptestewillians/pages/login.page.dart";
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

import '../services/data_keeped.dart';

String tokenGlobal = "";


class DriveHomePage extends StatefulWidget {
  const DriveHomePage({super.key, required this.cpfcnpj});
  final String cpfcnpj;
  @override
  State<DriveHomePage> createState() => _DriveHomePageState(cpfcnpj: cpfcnpj);
}

class _DriveHomePageState extends State<DriveHomePage> {
  _DriveHomePageState({required this.cpfcnpj});
  final String cpfcnpj;

  bool _isAlwaysShown = true;
  bool _showTrackOnHover = false;
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late Timer _timer;
  late Geolocator _geolocator;
  late Position newPosition; // Initialize with default value
  late DateTime now = DateTime.now();

  DataKeeped dataKeeped = DataKeeped();

  @override
  void initState() {
    super.initState();
    // _geolocator = Geolocator();
    // newPosition = Position(
    //   latitude: 0,
    //   longitude: 0,
    //   timestamp: DateTime.now(), // Provide the timestamp here
    //   altitude: 0,
    //   accuracy: 0,
    //   heading: 0,
    //   speed: 0,
    //   speedAccuracy: 0,
    // );
    // _timer = Timer.periodic(Duration(minutes: 5), _sendPosition);
    // now = DateTime.now();
  }

  // void _sendPosition(Timer timer) async {
  //   try {
  //     Position _newPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high, // Adjust as needed
  //       forceAndroidLocationManager: false, // Adjust as needed
  //       timeLimit: Duration(seconds: 10), // Adjust the time limit as needed
  //     );

  //     String tokenValue = await dataKeeped.getToken('token');

  //     fetchPosicion(
  //         '${newPosition.latitude}', '${newPosition.longitude}', tokenValue);
  //     // Rest of your code...
  //   } catch (e) {
  //     if (e is TimeoutException) {
  //       print('Timeout: Unable to obtain location within the time limit.');
  //     } else if (e is PermissionDeniedException) {
  //       print('Permission denied: The user denied access to location.');
  //     } else if (e is LocationServiceDisabledException) {
  //       print(
  //           'Location service disabled: User allowed access but location services are disabled.');
  //     } else {
  //       print('Error obtaining position: $e');
  //     }
  //   }
  // }

  /*@override
  void initState() {
    super.initState();

    
  }

  Future<void> checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    setState(() {
      _permissionStatus = status;
    });

    if (status.isGranted) {
      setState(() {
        requestLocation();
      });
    }
  }*/

  //final List rota = [DriveComVehicle(), LoginPage()];

  File? _storedImage;
  _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    XFile imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              width: mediaQuery * 0.7,
              child: Text("Motorista"),
            ),
            SizedBox(width: 10),
            // IconButton(
            //   icon: Icon(
            //     Icons.pin_drop,
            //     color: Colors.white,
            //     size: 40,
            //   ),
            //   onPressed: () => {Enviar()},
            //   color: Color.fromARGB(255, 0, 146, 220),
            // ),
            IconButton(
              icon: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () => _takePicture(),
              color: Color.fromARGB(255, 0, 146, 220),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 70,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    width: 70,
                    height: 70,
                    child: IconButton(
                        icon: Icon(
                          Icons.local_shipping,
                          size: 50,
                        ),
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DriveComVehicle(),
                                      maintainState: true))
                            },
                        color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("N° SM - MLK12023"),
                        Text("Nome do Motorista",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.route,
                      size: 40,
                    ),
                    onPressed: () => {
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MapsRouteDrive(
                                    cpf: "09358076755",
                                  )))*/
                    },
                    color: Color.fromARGB(255, 0, 146, 220),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(),
        Container(
          width: 180,
          height: 100,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Text(
                  "Nenhuma Nota fiscal!!",
                  selectionColor: Colors.red,
                ),
        ),
        SizedBox(
          width: 10,
        ),
        /*Text(
          '${now}',
        ),
        Text(
          'Latitude: ${newPosition.latitude}',
        ),
        Text(
          'Longitude: ${newPosition.longitude}',
        ),*/
        Text(
          'ID:${cpfcnpj}',
        ),
      ])),
      bottomNavigationBar: bmnav.BottomNav(
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DriveComVehicle(),
                      maintainState: true));
          } else {
            BackGroound.stop();
            dataKeeped.saveToken('token', "");
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          }
        },
        labelStyle: bmnav.LabelStyle(visible: true),
        iconStyle:
            bmnav.IconStyle(color: Colors.black, onSelectColor: Colors.red),
        elevation: 10,
        items: [
          bmnav.BottomNavItem(Icons.home, label: "Comandos"),
          bmnav.BottomNavItem(Icons.exit_to_app, label: "Sair"),
        ],
      ),
    );
  }
}

void Enviar() async {
  DataKeeped dataKeeped = DataKeeped();
  try {
    Position newPosition = Position(
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(), // Provide the timestamp here
      altitude: 0,
      accuracy: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );
    newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // Adjust as needed
      forceAndroidLocationManager: false, // Adjust as needed
      timeLimit: Duration(seconds: 10), // Adjust the time limit as needed
    );

    // String tokenValue = await dataKeeped.getToken('token');

  } catch (e) {
    if (e is TimeoutException) {
      print('Timeout: Unable to obtain location within the time limit.');
    } else if (e is PermissionDeniedException) {
      print('Permission denied: The user denied access to location.');
    } else if (e is LocationServiceDisabledException) {
      print(
          'Location service disabled: User allowed access but location services are disabled.');
    } else {
      print('Error obtaining position: $e');
    }
  }
}
