import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jsninja/admin/user_details.dart';
import 'package:jsninja/admin/user_list.dart';
import 'package:jsninja/app_bar.dart';
import 'package:jsninja/drawer.dart';
import 'package:jsninja/common.dart';

//Accessed by clicking workaround button on login page for time being
class AdminViewWidget extends ConsumerWidget {
  const AdminViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: MyAppBar.getBar(context, ref),
      drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? TheDrawer.buildDrawer(context)
          : null,
      body: Container(
          margin: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: UserList()),
              Expanded(child: UserDetails(ref.watch(activeUser)))
            ],
          )),
    );
  }
}
