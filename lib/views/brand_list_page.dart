import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/tiles/brandlist_tile.dart';
import 'package:jutta_ghar/views/brand_page.dart';

class BrandLists extends StatefulWidget {
  const BrandLists({Key? key}) : super(key: key);

  @override
  State<BrandLists> createState() => _BrandListsState();
}

class _BrandListsState extends State<BrandLists> {
  final nameHolder = TextEditingController();
  clearTextInput() {
    nameHolder.clear();
  }

  var name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 25),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 235, 235),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
              controller: nameHolder,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 46, 46, 46),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Color.fromARGB(185, 44, 44, 44),
                    ),
                    onPressed: clearTextInput,
                  ),
                  hintText: 'Search for Brands..',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: (name != "")
                    ? FirebaseFirestore.instance
                        .collection('brand')
                        .where('brand_name', isGreaterThanOrEqualTo: name)
                        .where('brand_name', isLessThan: name + 'z')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("brand")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<QueryDocumentSnapshot<Object?>> firestoreitems =
                        snapshot.data!.docs;
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: firestoreitems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BrandViewTile(
                            image: firestoreitems[index]['image'],
                            brandName: firestoreitems[index]['brand_name'],
                            logo: firestoreitems[index]["logo"],
                            onTap: () {
                              Get.to(() => BrandPage(
                                pageEmail: firestoreitems[index]['email'],
                                id: firestoreitems[index]['brand_id'],
                                logo: firestoreitems[index]['logo'],
                                image: firestoreitems[index]['image'],
                                website: firestoreitems[index]['website'],
                                    brandName: firestoreitems[index]
                                            ['brand_name']
                                        .toString(),
                                  ));
                            },
                          );
                        });
                  }
                  return const SizedBox();
                }),
          ),
        ),
      ),
    );
  }
}
