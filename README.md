# flutter-firebase-todolist
This is my personal project that intend to use flutter with Firebase, especially Cloud Firestore, so I can practice in using Firebase product while also learning Flutter.

## What is this project about?
A simple todo mobile application, with ability to organize task into group. This project implemented with Firebase Cloud Firestore.

## What is purpose of this project?
Create simple, clean UI and cross-platform mobile application that can help in record and manage tasks, yet make tasks management being easily with ability to organize it into group.

### How to use this source code?
First, clone this project then run this command below inside project's folder to install necessary packages.

```bash
$ flutter pub get
```

Then please follow this link to create Firebase project and link it back to this project.

https://firebase.google.com/docs/flutter/setup

After finished create Firebase project, head to Firestore Database then create Cloud Firestore for use in project, then you need to create two collections, one is for group of tasks, another is for tasks in a group.

Later, then goto lib, create folder name 'constants', inside its create file name 'firebase_firestore_constants.dart' and add those lines below then edit value ***TODO_GROUP_COLLECTION*** and ***TODO_ITEM_COLLECTION*** according to collections name that you created.

```bash
class FirestoreConstants {
  static const TODO_GROUP_COLLECTION = 'YOUR TODO LIST GROUP COLLECTION NAME';
  static const TODO_ITEM_COLLECTION = 'YOUR TODO LIST ITEM COLLECTION NAME';
}
```

Last, run project with this command. You may have to launched emulator or connected device before run this command, otherwise it will launch in web or native build.

```bash
$ flutter run
```