// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/homework.dart';
// import '../models/schedule.dart';
// import '../services/database.dart';
// import 'homework_screen.dart';

// class AddUpdateTask extends StatefulWidget {
//   @override
//   State<AddUpdateTask> createState() => _AddUpdateTaskState();
// }

// class _AddUpdateTaskState extends State<AddUpdateTask> {
//   DatabaseHelper0? databaseHelper0;
//   late Future<List<Homework>> dataList;
//   final _fromKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     databaseHelper0 = DatabaseHelper0();
//     loadData();
//   }

//   loadData() async {
//     dataList = databaseHelper0!.getDataList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Schedule _schedule;
//     final titleController = TextEditingController();
//     final descController = TextEditingController();

//     String appTitle;

//     appTitle = "Add task";

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(appTitle),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: EdgeInsets.only(top: 10),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Form(
//                 key: _fromKey,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: TextFormField(
//                         keyboardType: TextInputType.multiline,
//                         controller: titleController,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Enter some text";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: TextFormField(
//                         keyboardType: TextInputType.multiline,
//                         controller: descController,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Notes here";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Material(
//                       borderRadius: BorderRadius.circular(10),
//                       child: InkWell(
//                         onTap: () {
//                           if (_fromKey.currentState!.validate()) {
//                             databaseHelper0!.insertRecord(Homework(
//                                 id: 1,
//                                 lesson: 'null',
//                                 title: titleController.text,
//                                 description: descController.text,
//                                 group: 'null',
//                                 dateTime: DateTime(2023),
//                                 creationDate: DateTime.now()));

//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => HomeworkScreenBeta()),
//                             );
//                             titleController.clear();
//                             descController.clear();
//                           }
//                         },
//                         child: Container(
//                           color: Colors.green,
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.symmetric(horizontal: 20),
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           height: 55,
//                           width: 120,
//                         ),
//                       ),
//                     ),
//                     Material(
//                       borderRadius: BorderRadius.circular(10),
//                       child: InkWell(
//                         onTap: () {
//                           setState(() {
//                             titleController.clear();
//                             descController.clear();
//                           });
//                         },
//                         child: Container(
//                           color: Colors.red,
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.symmetric(horizontal: 20),
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           height: 55,
//                           width: 120,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
