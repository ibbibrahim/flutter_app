import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home_container_screen/controller/bottom_controller.dart';
import '../utils/image_constant.dart'; // your icons

import '../screens/dashboard_screen/dashboard_screen.dart';
import '../screens/attendance_screen_copy.dart';
import '../screens/basic_information_screen.dart'; // profile

// Enum for clarity
enum BottomBarEnum { Home, Calendar, Profile }

class BottomMenuModel {
  final String icon;
  final String activeIcon;
  final String title;
  final BottomBarEnum type;
  final Widget widget;

  const BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.type,
    required this.widget,
  });
}

// ---------- BOTTOM BAR WIDGET ----------
class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({Key? key, this.onChanged}) : super(key: key);

  final BottomBarController ctrl = Get.find();
  final Function(BottomMenuModel)? onChanged;

  // ▶️  Tabs you want to show
  final List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.home,
      activeIcon: ImageConstant.homeFill,
      title: 'Home',
      type: BottomBarEnum.Home,
      widget: DashboardScreen(),
    ),
    BottomMenuModel(
      icon: ImageConstant.calander,
      activeIcon: ImageConstant.clanderFill,
      title: 'Calendar',
      type: BottomBarEnum.Calendar,
      widget: AttendanceScreen(), // supply args later
    ),
    BottomMenuModel(
      icon: ImageConstant.profile,
      activeIcon: ImageConstant.profileFill,
      title: 'Profile',
      type: BottomBarEnum.Profile,
      widget: BasicInformationScreen(
        studentData: const {}, // supply real data later
        studentFullName: '',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: ctrl.selectedIndex.value,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: bottomMenuList
            .map(
              (m) => BottomNavigationBarItem(
                icon: _iconWithText(m.icon, m.title, false),
                activeIcon: _iconWithText(m.activeIcon, m.title, true),
                label: '',
              ),
            )
            .toList(),
        onTap: (i) {
          ctrl.selectedIndex.value = i;
          onChanged?.call(bottomMenuList[i]);
          ctrl.onChange(bottomMenuList[i].widget);
        },
      ),
    );
  }

  Widget _iconWithText(String asset, String txt, bool active) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(asset,
              height: 24, width: 24, color: active ? null : Colors.grey),
          const SizedBox(height: 4),
          Text(
            txt,
            style: TextStyle(
              fontSize: 12,
              color: active ? Colors.black : Colors.grey[600],
            ),
          ),
        ],
      );
}
