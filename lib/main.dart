import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChatApp(),
  ));
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  List usermsg = [];
  TextEditingController user1 = TextEditingController();
  TextEditingController user2 = TextEditingController();

  ScrollController scrollController = ScrollController();

  bool isdelete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // scrollController.animateTo(scrollController.position.maxScrollExtent,
    //   duration: Duration(seconds: 2),
    //   curve: Curves.fastOutSlowIn,);

    ShowData();
  }

  ShowData() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("messages");

    ref.onValue.listen((event) {
      setState(() {
        usermsg.clear();

        event.snapshot.children.forEach((element) {
          usermsg.add(element.value);
        });
        Future.delayed(Duration(milliseconds: 300)).then((value) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 1),
          );
          setState(() {});
        });
      });
    });
  }

  SendMsg(String msg, String user) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("messages").push();

    String formateedDate = DateFormat('h:mm:ss a').format(DateTime.now());

    String? key = ref.key;

    ref.set({
      "key": key,
      "name": user,
      "msg": msg,
      "time": formateedDate,
    });

    setState(() {
      user1.text = "";
    });
  }

  TextStyle mytextstyle = TextStyle(
    fontSize: 18,
    color: Colors.black,
    letterSpacing: 1,
  );

  //
  // List user1msg = [];
  // List user2msg = [];

  @override
  Widget build(BuildContext context) {
    print("all======${usermsg}");
    double heightt = MediaQuery.of(context).size.height;
    double widthh = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text("ChatApp"),
            backgroundColor: Color(0xff013220),
            actions: [
              isdelete
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isdelete = false;
                        });
                      },
                      icon: Icon(Icons.delete))
                  : SizedBox()
            ]),
        backgroundColor: Color(0xffE5E5E5),
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(content: Text("Tap Again To Exit")),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: heightt * 0.70,
                    width: widthh * 0.99,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/DefaultWhatsAppBg.jpg"),
                          fit: BoxFit.cover),
                      // border: Border.all(
                      //   width: 1,
                      // ),
                    ),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 2,
                        );
                      },
                      controller: scrollController,
                      itemCount: usermsg.length,
                      padding: EdgeInsets.only(top: 5, bottom: 20),
                      // reverse: true,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String user = usermsg[index]['name'];
                        return ListTile(
                          onLongPress: () {
                            setState(() {
                              isdelete = true;
                            });

                            DatabaseReference ref =
                                FirebaseDatabase.instance.ref("messages");

                            // ref.child('key').remove();

                            // setState(() {
                            //   usermsg.removeAt(index);
                            // });
                          },
                          contentPadding:
                              EdgeInsets.only(top: 2, left: 5, right: 5),
                          leading: user == "user-1"
                              ? Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                )
                              : SizedBox(width: 5),
                          title: user == "user-1"
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        // image: DecorationImage(
                                        //     image: AssetImage(
                                        //         "images/orange.png"),
                                        //     fit: BoxFit.fill),
                                        color: Color(0xffE4D00A),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15))
                                        // BorderRadius.all(Radius.circular(5)),
                                        ),
                                    child: Text(
                                      "${usermsg[index]['msg']}",
                                      style: mytextstyle,
                                      // style: TextStyle(
                                      //   // backgroundColor: Color(0xffE4D00A),
                                      //   // decorationColor: Color(0xffE4D00A),
                                      //   // background: Paint()
                                      //   //   ..strokeWidth = 20.0
                                      //   //   ..color = Color(0xffE4D00A)
                                      //   //   ..style = PaintingStyle.stroke
                                      //   //   ..strokeJoin = StrokeJoin.round,
                                      //   fontSize: 16,
                                      //   color: Colors.black,
                                      // )),
                                    ),
                                  ))
                              : Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        // image: DecorationImage(
                                        //     image:
                                        //         AssetImage("images/blue.png"),
                                        //     fit: BoxFit.fill),
                                        color: Color(0xff90EE90),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15))),
                                    child: Text(
                                      "${usermsg[index]['msg']}",
                                      textAlign: TextAlign.right,
                                      style: mytextstyle,
                                    ),
                                  ),
                                ),
                          subtitle: user == "user-1"
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "${usermsg[index]['time']}",
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "${usermsg[index]['time']}",
                                    ),
                                  ),
                                ),
                          trailing: user == "user-2"
                              ? Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                )
                              : SizedBox(width: 10),
                        );
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    endIndent: 5,
                    indent: 5,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 320,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "User-1",
                            fillColor: Color(0xff000000),
                            border: OutlineInputBorder(),
                          ),
                          controller: user1,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (user1.text != "") {
                            SendMsg(user1.text, "user-1");
                          }

                          setState(() {
                            user1.text = "";
                          });

                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff013220),
                              borderRadius: BorderRadius.circular(20)),
                          height: 50,
                          width: 50,
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 320,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "User-2",
                            fillColor: Color(0xff000000),
                            border: OutlineInputBorder(),
                          ),
                          controller: user2,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (user2.text != "") {
                            SendMsg(user2.text, "user-2");
                          }

                          setState(() {
                            user2.text = "";
                          });

                          // scrollController.positions.last;

                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );

                          // scrollController.animateTo(
                          //   300,
                          //   curve: Curves.easeOut,
                          //   duration: const Duration(milliseconds: 300),
                          // );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff013220),
                              borderRadius: BorderRadius.circular(20)),
                          height: 50,
                          width: 50,
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
