// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jutta_ghar/tiles/products_tiles.dart';
import 'package:jutta_ghar/views/order_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BrandPage extends StatefulWidget {
  final brandName, image, logo, website, id, createdTime;
  const BrandPage({
    Key? key,
    this.brandName,
    this.image,
    this.logo,
    this.website,
    this.id,
    this.createdTime,
  }) : super(key: key);

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  final user = FirebaseAuth.instance.currentUser;
  var searchKey = "";
  final clearSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.brandName.toUpperCase(),
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Brand Image & logo
              Stack(
                children: [
                  CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 0),
                    fadeOutDuration: const Duration(milliseconds: 0),
                    imageUrl: widget.image,
                    width: MediaQuery.of(context).size.width,
                    height: 182,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 182,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(131, 185, 185, 185)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  height: 84,
                                  width: 84,
                                  color: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.logo,
                                    height: 75,
                                    width: 75,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'asdfg',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'asdfg',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'asdfg',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('following').doc(user!.email).collection('pages').where('page_id', isEqualTo: widget.id.toString()).snapshots(),
                                builder: (context, snapshot) {
                                  // List<QueryDocumentSnapshot<Object?>> firestoreData =snapshot.data!.docs;
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.white,
                                      primary: Colors.black87,
                                    ),
                                    onPressed: (){
                                      follow();
                                    },
                                    child: const Text('Follow'),
                                  );
                                }
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () =>
                                launchUrlString(widget.website.toString()),
                            child: Row(
                              children: const [
                                Text(
                                  "Visit our website:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.link,
                                  color: Colors.white,
                                  size: 28,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //Body
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 216, 216),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    onChanged: ((value) {
                      setState(() {
                        searchKey = value;
                      });
                    }),
                    controller: clearSearchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            clearSearchController.clear();
                          },
                          child: const Icon(
                            Icons.clear,
                            color: Color.fromARGB(255, 136, 136, 136),
                          ),
                        ),
                        hintText: 'Search Products...',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: StreamBuilder<QuerySnapshot>(
                  stream: (searchKey != "")
                      ? FirebaseFirestore.instance
                          .collection('products')
                          .where("productName",
                              isGreaterThanOrEqualTo: searchKey)
                          .where("productName", isLessThan: searchKey + 'z')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("products")
                          .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      List<QueryDocumentSnapshot<Object?>> firestoreProducts =
                          snapshot.data!.docs;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          children: List.generate(
                            firestoreProducts.length,
                            (index) => firestoreProducts[index]
                                        ['brand_store'] ==
                                    widget.brandName
                                ? ProductTile(
                                    name: firestoreProducts[index]
                                        ["productName"],
                                    description: firestoreProducts[index]
                                        ["description"],
                                    discount: firestoreProducts[index]
                                            ["discount"]
                                        .toString(),
                                    price: firestoreProducts[index]["price"]
                                        .toString(),
                                    image: firestoreProducts[index]["image"],
                                    ontap: () => Get.to(
                                      () => OrderPage(
                                        image: firestoreProducts[index]
                                            ['image'],
                                        price: firestoreProducts[index]
                                            ['price'],
                                        name: firestoreProducts[index]
                                            ['productName'],
                                        brand: firestoreProducts[index]
                                            ['brand_store'],
                                        description: firestoreProducts[index]
                                            ["description"],
                                        discount: firestoreProducts[index]
                                                ['discount']
                                            .toString(),
                                        category: firestoreProducts[index]
                                            ['category'],
                                        offer: firestoreProducts[index]
                                            ['offer'],
                                        productID: firestoreProducts[index]
                                            ['productID'],
                                        type: firestoreProducts[index]['type'],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  Future follow() async {
    final user = FirebaseAuth.instance.currentUser;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      DocumentReference documentReferencer = FirebaseFirestore.instance
          .collection("following")
          .doc(user!.email)
          .collection("pages")
          .doc(widget.id);
      Map<String, dynamic> data = {
        'page_name': widget.brandName,
        'page_id': widget.id,
        'page_logo': widget.logo,
        'page_image': widget.image,
        'page_website': widget.website,
      };
      documentReferencer.set(data).then((value) => Navigator.pop(context)).then(
          (value) => Get.snackbar("Following", "Succesfully followed",
              backgroundColor: const Color.fromARGB(115, 105, 240, 175)));
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.redAccent);
    }
  }
  unfollow() {
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("following")
        .doc(user!.email)
        .collection("pages")
        .doc(widget.id)
        .delete()
        .then((value) => Get.snackbar("Unfollowed","You have unfollowed the page",duration: const Duration(seconds: 1),));
  }
}
