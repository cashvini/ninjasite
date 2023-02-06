import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jsninja/app_bar.dart';
import 'package:jsninja/common.dart';
import 'package:jsninja/resume/resume.dart';
import 'package:jsninja/resume/resume_details.dart';
import 'package:jsninja/state/generic_state_notifier.dart';
import 'package:jsninja/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:jsninja/resume/resume_list.dart';

// final resumeIdProvider = StateProvider<String?>((ref) => null);
// final jobTitleProvider = StateProvider<String?>((ref) => null);
//final resumeSNP = StateProvider<Map<String, dynamic>?>((ref) => null);
// final resumeDescriptionProvider = StateProvider<String?>((ref) => null);
final resumeSNP = StateNotifierProvider<
        GenericStateNotifier<Map<String, dynamic>?>, Map<String, dynamic>?>(
    (ref) => GenericStateNotifier<Map<String, dynamic>?>(null));

final firestoreInstance = FirebaseFirestore.instance;

class UserResumePage extends ConsumerWidget {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String resumeID = '';

  TextEditingController addJobTitlechCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final jobTitle = ref.watch(jobTitleProvider).toString();
    // final description = ref.watch(resumeDescriptionProvider).toString();
    // final resume = ref.watch(resumeProvider).toString();
    // resumeID = ref.watch(resumeIdProvider).toString();

    return Scaffold(
      appBar: MyAppBar.getBar(context, ref),
      drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? TheDrawer.buildDrawer(context)
          : null,
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: ResumeList()),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          // ignore: prefer_const_constructors
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                          onPressed: () async {
                            showDialogFunction(context);
                          }),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ResumeDetails(ref.watch(resumeSNP)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          // ignore: prefer_const_constructors
                          child: Icon(
                            Icons.archive,
                            size: 30,
                          ),
                          onPressed: () async {}),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Add resume
  showDialogFunction(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Add job title here'),
            content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: Theme.of(context).textTheme.bodyLarge,
                  controller: addJobTitlechCtrl,
                  onChanged: (v) {},
                )),
            actions: [
              TextButton(
                  child: const Text("Add"),
                  onPressed: () {
                    if (addJobTitlechCtrl.text.isEmpty) return;
                    firestoreInstance
                        .collection("user")
                        .doc(uid)
                        .collection("resume")
                        .add({
                      'jobTitle': addJobTitlechCtrl.text,
                      'timeCreated': FieldValue.serverTimestamp(),
                      'author': uid,
                      'lastupdated': null
                    });
                    addJobTitlechCtrl.clear();
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    addJobTitlechCtrl.clear();
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

//Edit resume
  editResume(String jobTitle, String description, String resume) {
    // Resume resumeObject = Resume(
    //     jobTitle: jobTitleController.text,
    //     description: resumeDescriptionController.text,
    //     resume: resumeController.text,
    //     lastupdated: Timestamp.now());

    // if (jobTitle == resumeObject.jobTitle &&
    //     description == resumeObject.description &&
    //     resume == resumeObject.resume) {
    //   return;
    // } else {
    //   firestoreInstance
    //       .collection("user")
    //       .doc(uid)
    //       .collection('resume')
    //       .doc(resumeIdController.text)
    //       .update(resumeObject.toMap());
    // }
  }
}
