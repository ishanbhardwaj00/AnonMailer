import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        cursorColor: Color(0xffDC143C),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String recieverMail, mailBody, mailSubject;
  MailJson mailJson= MailJson();
  final _formKey= GlobalKey<FormState>();
  //  fetchData()  async{
  //   var response= await get("http://10.0.2.2:3000/");
  //      if(response.statusCode==200) {
  //        print('Successful rest api');
  //        jsonToString= JsonToString.fromJson(json.decode(response.body));
  //        setState(() {
  //          restText= jsonToString.text;
  //        });
  //      } else {
  //        print("Failed rest"+ response.statusCode.toString());
  //      }
  // }
  postData(MailJson mailJson) async {
    dynamic response = await post("http://10.0.2.2:3000/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    body: jsonEncode({
      "to" : mailJson.TO,
      "subject": mailJson.subject,
      "text": mailJson.body}
    ));
    if(response.statusCode==200) {
      Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black,
            body:
            Center(
              child: Text(
                "Mail sent successfully",
                style: TextStyle(fontSize: 30, color: Color(0xffDC143C), ),
              ),
            ),
          );
        }
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("AnonMail", style: GoogleFonts.lobster(color: Color(0xffDC143C), fontSize: 48), ),
              SizedBox(height: 35),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(width: 250,height: 45,decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ), child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 5.0, vertical: 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          onChanged: (value) {
                            recieverMail=value;
                          },
                          decoration: InputDecoration(
                            hintText: "Send email to",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffDC143C)),
                            ),
                          ),
                        ),
                      ),
                    ),),
                    SizedBox(height: 15,),
                    Container(width: 250,height: 45,decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ), child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 5.0, vertical: 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          onChanged: (value) {
                            mailSubject=value;
                          },
                          decoration: InputDecoration(
                            hintText: "Subject",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffDC143C)),
                            ),
                          ),
                        ),
                      ),
                    ),),
                    SizedBox(height: 15,),
                    Container(width: 250, height: 45, decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ), child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 5.0, vertical: 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          onChanged: (value) {
                            mailBody=value;
                          },
                          decoration: InputDecoration(
                            hintText: "Body",
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffDC143C)),
                            ),
                          ),
                        ),
                      ),
                    ),),
                    SizedBox(height: 15),
                    FlatButton(
                      onPressed: () {
                        if(_formKey.currentState.validate()) {
                          mailJson.TO= recieverMail;
                          mailJson.body= mailBody;
                          mailJson.subject= mailSubject;
                          postData(mailJson);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Color(0xffDC143C),)
                      ),
                      child: Text("SEND", style: TextStyle(color: Color(0xffDC143C), fontSize: 16),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MailJson {
  String TO;
  String subject;
  String body;
  MailJson({this.body, this.subject, this.TO});
  MailJson.toJson(parseTojson) {
    TO= parseTojson['TO'] as String;
    subject= parseTojson['subject'] as String;
    body= parseTojson['body'] as String;
  }

}