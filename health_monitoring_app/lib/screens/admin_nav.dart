// import 'package:flutter/material.dart';
// import 'package:project_app/screens/AllStudentsPage.dart';
// import 'package:project_app/screens/QuarantinedStudentsPage.dart';
// import '../models/user_model.dart';
// import 'Admin_Homepage.dart';
// import 'ProfiePage.dart';

// class AdminNav extends StatefulWidget {
//   final UserModel user;
//   const AdminNav({super.key, required this.user});

//   @override
//   _AdminNavState createState() => _AdminNavState();
// }

// class _AdminNavState extends State<AdminNav> {
//   int _selectedIndex = 0;

//   final _pages = [
//     const AdminHomepage(),
//     const AllStudentsPage(), // to edit later
//     ProfilePage(
//       user: widget.user,
//     ), // to edit later
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.auto_awesome_mosaic_rounded),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_rounded),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_rounded),
//             label: '',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: (index) => _onItemTapped(index),
//       ),
//     );
//   }
// }
