// import 'package:flutter/material.dart';
// import '../models/homework.dart';
// import '../models/schedule.dart';
// import '../services/database.dart';
// import 'homework_update.dart';

// class HomeworkScreenBeta extends StatefulWidget {
//   const HomeworkScreenBeta({Key? key});

//   @override
//   State<HomeworkScreenBeta> createState() => _HomeworkScreenBetaState();
// }

// class _HomeworkScreenBetaState extends State<HomeworkScreenBeta> {
//   DatabaseHelper0? _databaseHelper0;
//   late Future<List<Homework>> dataList;

//   @override
//   void initState() {
//     super.initState();
//     _databaseHelper0 = DatabaseHelper0();
//     loadData();
//   }

//   loadData() async {
//     dataList = _databaseHelper0!.getDataList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.black : Colors.white,
//       appBar: AppBar(
//         backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
//         elevation: 0,
//         leading: Icon(
//           Icons.menu,
//           color: isDarkMode ? Colors.white : Colors.black,
//           size: 30,
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: Icon(
//               Icons.help_outline_rounded,
//               size: 30,
//               color: isDarkMode ? Colors.white : Colors.black,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Text(
//               'Tasks',
//               style: TextStyle(
//                 fontSize: 36,
//                 fontWeight: FontWeight.bold,
//                 color: isDarkMode ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: dataList,
//               builder: (context, AsyncSnapshot<List<Homework>> snapshot) {
//                 if (!snapshot.hasData || snapshot.data == null) {
//                   return Center(
//                     child: CircularProgressIndicator(
//                       color: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                   );
//                 } else if (snapshot.data!.isEmpty) {
//                   return Center(
//                     child: Text(
//                       "No tasks found",
//                       style: TextStyle(
//                         color: isDarkMode ? Colors.white : Colors.black,
//                         fontSize: 18,
//                       ),
//                     ),
//                   );
//                 } else {
//                   return ListView.builder(
//                     itemCount: snapshot.data?.length,
//                     itemBuilder: (context, index) {
//                       int ID = snapshot.data![index].id.toInt();
//                       String title = snapshot.data![index].title.toString();
//                       String desc =
//                           snapshot.data![index].description.toString();
//                       DateTime DT = snapshot.data![index].dateTime;

//                       return Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Container(
//                           padding: EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: isDarkMode
//                                 ? Colors.grey[800]
//                                 : Colors.grey[200],
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 title,
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                   color:
//                                       isDarkMode ? Colors.white : Colors.black,
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 desc,
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color:
//                                       isDarkMode ? Colors.white : Colors.black,
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     DT.toString(),
//                                     style: TextStyle(
//                                       color: isDarkMode
//                                           ? Colors.grey[400]
//                                           : Colors.grey[600],
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   AddUpdateTask(),
//                                             ),
//                                           );
//                                         },
//                                         child: Icon(
//                                           Icons.edit,
//                                           color: isDarkMode
//                                               ? Colors.blue
//                                               : Colors.green,
//                                           size: 30,
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             _databaseHelper0!.deleteRecord(ID);
//                                             dataList =
//                                                 _databaseHelper0!.getDataList();
//                                             snapshot.data!
//                                                 .remove(snapshot.data![index]);
//                                           });
//                                         },
//                                         child: Icon(
//                                           Icons.delete,
//                                           color: Colors.red,
//                                           size: 30,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddUpdateTask(),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: isDarkMode ? Colors.blue : Colors.green,
//       ),
//     );
//   }
// }
