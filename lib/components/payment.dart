import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loading.dart';
import 'paymentdone.dart';
import '../pages/reciept.dart';

class Payment extends StatefulWidget {
  String email;
  List<int> zonid;
  List<String> timslot;
  int total;
  String zone;
  Payment({Key? key,required this.email,required this.zonid,required this.timslot,required this.total,required this.zone}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}


class _PaymentState extends State<Payment> {
  bool check = false;

  void send_data() {
    FirebaseFirestore.instance.collection(widget.zone).add({
      'Email': widget.email,
      'ZoneId': widget.zonid,
      'TimeSlot': widget.timslot,
      'total': widget.total
    });
    print("Sended data");
  }

  @override
  void initState(){
    super.initState();
      print(check);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 30,
              child: CreditCardForm(
                theme: CustomCardTheme(),
                onChanged: (CreditCardResult result) {
                  print(result.cardNumber);
                  print(result.cardHolderName);
                  print(result.expirationMonth);
                  print(result.expirationYear);
                  print(result.cardType);
                  print(result.cvc);
                  String cnum = result.cardNumber;
                  String cholder = result.cardHolderName;
                  String cexpm = result.expirationMonth;
                  String cexpy = result.expirationYear;
                  String cardcvv = result.cvc;

                  setState(() {
                    if(cnum.isNotEmpty && cholder.isNotEmpty && cexpm.isNotEmpty && cexpy.isNotEmpty && cardcvv.isNotEmpty){
                      check = true;

                    }
                  });
                },
              ),
            ),
            SizedBox(height: 20), // Add some spacing between form and button
            MaterialButton(
              onPressed: () async {
                if (check) {

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: PaymentDone(),
                      );
                    },
                  );

                  send_data();
                  await Future.delayed(Duration(seconds: 3)); // Replace with your send_data() function

                  // Close the CircularProgressIndicator dialog
                  Navigator.pop(context);

                  // Navigate to the Receipt screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Receipt(
                        email: widget.email,
                        Computer: widget.zonid,
                        TimeSlot: widget.timslot,
                        total: widget.total,
                        zone: widget.zone,
                      ),
                    ),
                  );

                  // You can place this if it's necessary for your navigation flow
                  // Navigator.pop(context);
                }
              },
              child: Text(
                "Pay",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              color: Colors.deepPurple,
            )




          ],
        ),
      ),
    );
  }
}

class CustomCardTheme implements CreditCardTheme {
  @override
  Color backgroundColor = Colors.white;
  @override
  Color textColor = Colors.black;
  @override
  Color borderColor = Colors.black45;
  @override
  Color labelColor = Colors.black45;
}
