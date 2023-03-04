import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import 'package:get/get.dart';
import 'package:presence/app/data/controllers/authController.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../../controllers/page_index_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  // const ProfileView({Key? key}) : super(key: key);

  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            Center(child: CircularProgressIndicator());
          }
          Map<String, dynamic> user = snapshot.data!.data()!;
          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return phone(user, context, authC);
            } else {
              return web(user, context, authC);
            }
          });
        });
  }

  Scaffold web(
      Map<String, dynamic> user, BuildContext context, AuthController authC) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [],
      ),
      drawer: user['role'] == 'admin'
          ? SideBar(
              items: const [
                AdminMenuItem(
                  title: 'Home',
                  route: Routes.HOME,
                  icon: Icons.home,
                ),
                AdminMenuItem(
                  title: 'Profile',
                  route: Routes.PROFILE,
                  icon: Icons.person,
                ),
                AdminMenuItem(
                  title: 'Add Pegawai',
                  route: Routes.ADD_PEGAWAI,
                  icon: Icons.person_add,
                ),
                AdminMenuItem(
                  title: 'Semua Pegawai',
                  route: Routes.ALL_PEGAWAI,
                  icon: Icons.person_3,
                ),
              ],
              selectedRoute: '/',
              onSelected: (item) {
                if (item.route != null) {
                  Navigator.of(context).pushNamed(item.route!);
                }
              },
              header: Container(
                height: 50,
                width: double.infinity,
                color: Color.fromARGB(255, 235, 233, 233),
                child: const Center(
                  child: Text(
                    'Presence Apps',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            )
          : SideBar(
              items: const [
                AdminMenuItem(
                  title: 'Home',
                  route: Routes.HOME,
                  icon: Icons.home,
                ),
                AdminMenuItem(
                  title: 'Profile',
                  route: Routes.PROFILE,
                  icon: Icons.person,
                ),
              ],
              selectedRoute: '/',
              onSelected: (item) {
                if (item.route != null) {
                  Navigator.of(context).pushNamed(item.route!);
                }
              },
              header: Container(
                height: 50,
                width: double.infinity,
                color: Color.fromARGB(255, 235, 233, 233),
                child: const Center(
                  child: Text(
                    'Presence Apps',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 200,
                  height: 200,
                  child: Image.network(
                      "https://ui-avatars.com/api/?name=${user['nama']}",
                      fit: BoxFit.cover),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Text(
            "${user['nama'].toString().toUpperCase()}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(height: 10),
          Text(
            "${user['email']}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 20),
          ListTile(
            onTap: () async {
              await Get.defaultDialog(
                  barrierDismissible: false,
                  title: "Update Profile",
                  middleText:
                      "Untuk update profile silahkan hubungi admin untuk mengubah data diri anda!",
                  actions: [
                    // OutlinedButton(onPressed: () => Get.back(), child: Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Ok")),
                  ]);
            },
            leading: Icon(Icons.person),
            title: Text("Update Profile"),
          ),
          ListTile(
            onTap: () async {
              await authC.resetPassword();
            },
            leading: Icon(Icons.vpn_key),
            title: Text("Update Password"),
          ),
          ListTile(
            onTap: () => {
              Get.defaultDialog(
                  title: "Sign Out",
                  content: const Text("Are sure want to sign out?"),
                  cancel: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: const Text("Cancel")),
                  confirm: ElevatedButton(
                      onPressed: () => authC.logout(),
                      child: const Text("Log Out")))
            },
            // authC.logout()
            leading: Icon(Icons.logout),
            title: Text("Logout"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
           pageC.changePage(1);
          },
          child: Icon(Icons.fingerprint)),
    );
  }

  Scaffold phone(
      Map<String, dynamic> user, BuildContext context, AuthController authC) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
          actions: [],
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Image.network(
                        "https://ui-avatars.com/api/?name=${user['nama']}",
                        fit: BoxFit.cover),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              "${user['nama'].toString().toUpperCase()}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 10),
            Text(
              "${user['email']}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 20),
            ListTile(
              onTap: () async {
                await Get.defaultDialog(
                    barrierDismissible: false,
                    title: "Update Profile",
                    middleText:
                        "Untuk update profile silahkan hubungi admin untuk mengubah data diri anda!",
                    actions: [
                      // OutlinedButton(onPressed: () => Get.back(), child: Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Ok")),
                    ]);
              },
              leading: Icon(Icons.person),
              title: Text("Update Profile"),
            ),
            ListTile(
              onTap: () async {
                await authC.resetPassword();
              },
              leading: Icon(Icons.vpn_key),
              title: Text("Update Password"),
            ),
             if (user["role"] == "admin")
                    ListTile(
                      onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                      leading: Icon(Icons.person_add),
                      title: Text("Add Pegawai"),
                    ),
             if (user["role"] == "admin")
                    ListTile(
                      onTap: () => Get.toNamed(Routes.ALL_PEGAWAI),
                      leading: Icon(Icons.person_4),
                      title: Text("Semua Pegawai"),
                    ),
            ListTile(
              onTap: () => {
                Get.defaultDialog(
                    title: "Sign Out",
                    content: const Text("Are sure want to sign out?"),
                    cancel: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text("Cancel")),
                    confirm: ElevatedButton(
                        onPressed: () => authC.logout(),
                        child: const Text("Log Out")))
              },
              // authC.logout()
              leading: Icon(Icons.logout),
              title: Text("Logout"),
            )
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: 2,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
