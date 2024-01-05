import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vortex_gaming_emporium/pages/gamestation.dart';
import 'package:vortex_gaming_emporium/pages/privateroomscreen.dart';
import 'package:vortex_gaming_emporium/pages/select_time.dart';
import 'commanzonscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Select_time_gameroom extends StatefulWidget {
  const Select_time_gameroom({Key? key}) : super(key: key);

  @override
  State<Select_time_gameroom> createState() => _Select_time_gameroomState();
}

class _Select_time_gameroomState extends State<Select_time_gameroom> {

  final timeslot = [
    '9:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 1:00 PM',
    '1:00 PM - 2:00 PM',
    '2:00 PM - 3:00 PM',
    '3:00 PM - 4:00 PM',
    '4:00 PM - 5:00 PM',
    '5:00 PM - 6:00 PM',
    '6:00 PM - 7:00 PM',
  ];

  List<int> selectedIndices = [];
  List<String> selectedtime = [];
  bool validTime = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Select Time Slot:",
                style: GoogleFonts.bebasNeue(
                  fontSize: 30,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: timeslot.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedIndices.contains(index);
                    _isBlank(timeslot[index]);
                    return validTime
                        ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIndices.remove(index);
                          } else {
                            selectedIndices.add(index);
                          }
                        });
                        selectedtime = selectedIndices.map((i) => timeslot[i]).toList();
                        print("Selected Time: $selectedtime");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurple : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          timeslot[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: (){
                        CherryToast(
                          icon: Icons.report_problem_outlined,
                          themeColor: Colors.red,
                          title: Text(''),
                          displayTitle: false,
                          description: Text('Please select valid time slot',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          toastPosition: Position.bottom,
                          animationDuration: Duration(milliseconds: 1000),
                          autoDismiss: true,
                        ).show(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          timeslot[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){
                    if(selectedIndices.isEmpty){
                      CherryToast(
                        icon: Icons.report_problem_outlined,
                        themeColor: Colors.red,
                        title: Text(''),
                        displayTitle: false,
                        description: Text('Select time slot',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        toastPosition: Position.bottom,
                        animationDuration: Duration(milliseconds: 1000),
                        autoDismiss: true,
                      ).show(context);
                    }
                    else
                    {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => GameRoomScreen(timeSlot: selectedtime)));
                    }

                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool _isBlank(String slot) {
    print("Is Blank Called");

    TimeOfDay currentTime = TimeOfDay.fromDateTime(DateTime.now());
    TimeOfDay earliestSelectedTime = _parse(slot.split(' - ')[0]);

    print("Current Time: $currentTime");
    print("Selected Time: $earliestSelectedTime");

    // Compare the selected time with the current time
    if (earliestSelectedTime.hour > currentTime.hour ||
        (earliestSelectedTime.hour == currentTime.hour && earliestSelectedTime.minute > currentTime.minute)) {
      validTime = true;
      return true; // The selected time is valid
    } else {
      validTime = false;
      return false; // The selected time is not valid
    }

  }

  TimeOfDay _parse(String time) {
    List<String> timeComponents = time.split(' ')[0].split(':');
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);
    String amPm = time.split(' ')[1];

    bool isPM = amPm == 'PM';

    print("Original Hours: $hours, Original Minutes: $minutes, isPM: $isPM");

    if (isPM && hours != 12) {
      hours += 12;
    }
    if (!isPM && hours == 12) {
      hours = 0; // 12:00 AM is equivalent to 0:00
    }

    print("Final Hours: $hours, Final Minutes: $minutes");

    return TimeOfDay(hour: hours, minute: minutes);
  }

}
