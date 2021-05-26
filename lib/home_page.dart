import 'package:flutter/material.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/screens/Home.dart';
import 'package:new_clean/screens/Upload.dart';
import 'package:new_clean/screens/mrkt.dart';
import 'package:new_clean/widgets/drawer_item.dart';
import 'package:provider/provider.dart';
import 'package:new_clean/sign_in_page.dart';
import 'package:new_clean/provider/authentication_service.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentindex = 0;

  List tabs = [
    Home(),
    Upload(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: tabs[currentindex],
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.only(top: 42),
          child: Column(
            children: <Widget>[
              DrawerItem(
                text: "Profile",
                onPressed: () {},
              ),
              DrawerItem(
                text: "Add SkyCoins",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MarketScreen()),
                  );},
              ),
              DrawerItem(
                text: "Sign Out",
                onPressed: () { context.read<AuthenticationService>().signOut();},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentindex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload),
              label: "Upload",
            ),
          ],
          onTap: (index) {
            setState(() {
              currentindex = index;
            });
          }),
    );
  }
}
