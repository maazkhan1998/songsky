import 'package:flutter/material.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/screens/Home.dart';
import 'package:new_clean/screens/Upload.dart';
import 'package:new_clean/screens/mrkt.dart';
import 'package:new_clean/utils/SizeConfig.dart';
import 'package:new_clean/widgets/drawer_item.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:new_clean/provider/authentication_service.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> tabs = [
    Home(),
    Upload(),
  ];

  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData=Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: PersistentTabView(
        context,
        screens: tabs,
        items: [
          PersistentBottomNavBarItem(
            icon: Icon(
              Icons.home,
            ),title: 'Home',
            activeColorPrimary: Colors.black
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.cloud_upload,),
            title: 'Upload',
            activeColorPrimary: Colors.black,
          )
        ],
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
    ),
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
    );
  }
}
