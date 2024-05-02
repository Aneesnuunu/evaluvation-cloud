import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("galleryaaa").snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No images available."),
            );
          }

          List<DocumentSnapshot> documents =
          snapshot.data!.docs.reversed.toList();
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: documents.length + selectedImages.length,
            itemBuilder: (context, index) {
              if (index < selectedImages.length) {
                return buildImage(selectedImages[index], index);
              } else {
                var doc = documents[index - selectedImages.length];
                var imageUrl = doc["imageUrl"];
                return buildImage(
                    NetworkImage(imageUrl), index - selectedImages.length);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final List<XFile>? images = await ImagePicker().pickMultiImage();

          if (images != null) {
            for (var image in images) {
              File imageFile = File(image.path);
              selectedImages.add(imageFile);
              uploadImageToFirebase(imageFile);
            }
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildImage(dynamic image, int index) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteConfirmationDialog(index);
      },
      child: Image(
        image: image is File ? FileImage(image) : image,
        fit: BoxFit.cover,
      ),
    );
  }

  void uploadImageToFirebase(File imageFile) async {
    try {
      var storageInstance = FirebaseStorage.instance;
      var ref = await storageInstance
          .ref()
          .child("galleryaaa/${DateTime.now().millisecondsSinceEpoch}")
          .putFile(imageFile);
      var imageUrl = await ref.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("galleryaaa").add({
        "imageUrl": imageUrl,
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Image"),
          content: const Text("Are you sure you want to delete this image?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedImages.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
