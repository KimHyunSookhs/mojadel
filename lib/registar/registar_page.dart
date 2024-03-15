import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:mojadel/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class RegistarPage extends StatefulWidget {
  const RegistarPage({super.key});

  @override
  State<RegistarPage> createState() => _RegistarPageState();
}

class _RegistarPageState extends State<RegistarPage> {
   XFile? _image;
   ImagePicker picker = ImagePicker();
   String? _selectedOption='중고거래';
  Future getImage(ImageSource imageSource) async {
    // 갤러리에서 이미지를 선택합니다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if(pickedFile!=null){
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }
   Widget _buildPhotoArea(){
     return _image != null ? Container(width: 140,
       height: 120,
       child: Image.file(File(_image!.path)),) :
     Container(
       width: 10,
       height: 10,
       color: Colors.white38,
     );
   }
   TextEditingController textController = TextEditingController();
   TextEditingController textController2 = TextEditingController();
  String textContet = "";

   late GoogleMapController mapController;
   late Position currentPosition;
   bool mapVisible = false;
   @override
   void initState() {
     super.initState();
     _determinePosition();
   }
   Future<void> _determinePosition() async {
     bool serviceEnabled;
     LocationPermission permission;

     serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       return Future.error('위치 서비스가 비활성화되어 있습니다.');
     }

     permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         return Future.error('위치 권한이 거부되었습니다.');
       }
     }

     if (permission == LocationPermission.deniedForever) {
       return Future.error('위치 권한이 영구적으로 거부되었습니다.');
     }

     currentPosition = await Geolocator.getCurrentPosition();
     setState(() {
       mapVisible = true; // 위치를 성공적으로 가져오면 지도를 표시
     });
   }


   @override
  Widget build(BuildContext context) {

    return GestureDetector(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mintgreen,
        title: Text(
          '제품 등록',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: 'Inter',
                color: Colors.black,
                fontSize: 25,
              ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(6, 20, 0, 0),
                child: Text(
                  '제목',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 5, 8, 20),
               child: TextField(
                 controller: textController,
                onChanged: (value){
                     setState(() =>textContet = textController.text);
                },
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: '제목을 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                 style: Theme.of(context).textTheme.bodyMedium,
                 textAlign: TextAlign.start,
                 minLines: 1,
              ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: ()  {
                         getImage(ImageSource.gallery);},
                      child: Icon(Icons.photo),
                    ),
                    SizedBox(height: 10, width: 10,),
                    _buildPhotoArea(),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(-1, -1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            for (var option in ['중고거래', '운동모임', '배달음식'])
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: option,
                                    groupValue: _selectedOption,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                  ),
                                  Text(option),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                child: TextField(
                  autofocus: false,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    hintText: '가격을 입력해주세요',
                    hintStyle: Theme.of(context).textTheme.labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // style: FlutterFlowTheme.of(context).bodyMedium,
                  // validator:
                  // _model.textController2Validator.asValidator(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 20, 0, 0),
                child: Text(
                  '제품 설명',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: TextField(
                  autofocus: false,
                  obscureText: false,
                  controller: textController2,
                  onChanged: (value){
                    setState(() =>textContet = textController2.text);
                  },
                  decoration: InputDecoration(
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    hintText: '제품의 상세한 설명을 적어주세요.',
                    hintStyle:
                    Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontFamily: 'Readex Pro',
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 6,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 20, 0, 10),
                child: Text(
                  '거래 희망 장소',
                  style: TextStyle(fontWeight: FontWeight.w300,
                  fontSize: 16)
                ),
              ),
              if(mapVisible)
              Container(
              height: 300,
                width: 300,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller){
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(currentPosition.latitude, currentPosition.longitude),
                      zoom:14.0),
                ),
              ),
              SizedBox(height: 10,),
              FloatingActionButton(onPressed: _determinePosition,
              tooltip: '위치지정',
              child: Icon(Icons.location_searching),)
            ],
          ),
        ),
      ),
    ));
  }
}

