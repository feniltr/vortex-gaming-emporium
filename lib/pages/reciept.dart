import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vortex_gaming_emporium/components/mytext.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:typed_data';
import 'package:vortex_gaming_emporium/pages/homepage.dart';
import 'package:vortex_gaming_emporium/pages/mainpage.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Receipt extends StatefulWidget {
    final email;
    List<String> TimeSlot;
    List<int> Computer;
    int total;
    String zone;


    Receipt({Key? key,
      required this.email,
      required this.TimeSlot,
      required this.Computer,
      required this.total,
      required this.zone}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  ScreenshotController screenshotController = ScreenshotController();
  bool isalert = true;

  double height(double s){
    final double t = (s/MediaQuery.of(this.context).size.height)*MediaQuery.of(this.context).size.height;
    return t;
  }

  double width(double s){
    final double t = (s/MediaQuery.of(this.context).size.width)*MediaQuery.of(this.context).size.width;
    return t;
  }


  _saved(Uint8List image) async {
    print("Saving image to gallery...");
    final result = await ImageGallerySaver.saveImage(image);
    if (result['isSuccess']) {
      print("Image saved successfully: ${result['filePath']}");

    } else {
      print("Failed to save image");
    }
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
        context: context,
        builder: (context){
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
            setState(() {
              isalert = false;
            });
          });
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                    child: capturedImage != null
                        ? Image.memory(capturedImage)
                        : Container()),

              ],
            ),
          );

        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100,left: 10,right: 10,bottom: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black,width: 3),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Vortex Gaming Emporium",style: GoogleFonts.bebasNeue(fontSize: height(40)),)
                                  ],
                                ),

                                Divider(
                                  thickness: 2,
                                  color: Colors.black,
                                  indent: 10,
                                  endIndent: 10,
                                ),

                              //Email
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: ListTile(
                                  visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 0,
                                  leading:
                                  Icon(Icons.email, color: Colors.deepPurpleAccent),
                                  title: Text(
                                    "Email : ${widget.email}",
                                    style: GoogleFonts.openSans(fontSize: 20,color: Colors.grey.shade800
                                    ),
                                  ),
                                ),
                              ),

                              //Zone Name
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: ListTile(
                                  visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 0,
                                  leading:
                                  Icon(Icons.gamepad, color: Colors.deepPurpleAccent),
                                  title: Text(
                                    "Zone : ${widget.zone}",
                                    style: GoogleFonts.openSans(fontSize: 20,color: Colors.grey.shade800
                                    ),
                                  ),
                                ),
                              ),

                              //Date
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: ListTile(
                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 0,
                                  leading: Icon(Icons.date_range, color: Colors.deepPurpleAccent),
                                  title: Text(
                                    "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                                    style: GoogleFonts.openSans(fontSize: 20, color: Colors.grey.shade800),
                                  ),
                                ),
                              ),

                              //Time Slot
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: ListTile(
                                  visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 0,
                                  leading:
                                  Icon(Icons.timer_rounded, color: Colors.deepPurpleAccent),
                                  title: Text(
                                    "Time Slot : ${widget.TimeSlot}",
                                    style: GoogleFonts.openSans(fontSize: 20,color: Colors.grey.shade800
                                    ),
                                  ),
                                ),
                              ),

                              //Computer number
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: ListTile(
                                  visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 0,
                                  leading:
                                  Icon(Icons.computer_rounded, color: Colors.deepPurpleAccent),
                                  title: Text(
                                    widget.zone == "CommanZone" ? "Computers : ${widget.Computer}":
                                    widget.zone == "PrivateZone" ? "Rooms : ${widget.Computer}":
                                    "GameStation : ${widget.Computer}",
                                    style: GoogleFonts.openSans(fontSize: 20,color: Colors.grey.shade800
                                    ),
                                  ),
                                ),
                              ),

                              //Total
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: ListTile(
                                  visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 0,
                                  leading:
                                  Icon(Icons.currency_rupee, color: Colors.deepPurpleAccent),
                                  title: Text(
                                    "Total : ${widget.total}",
                                    style: GoogleFonts.openSans(fontSize: 20,color: Colors.grey.shade800
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          screenshotController
                              .capture(delay: Duration(milliseconds: 100))
                              .then((capturedImage) async {
                            ShowCapturedWidget(context, capturedImage!);
                            _saved(capturedImage);
                          }).catchError((onError) {
                            print("Capture error: $onError");
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),

                      SizedBox(width: 10,),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Home',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),

                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

