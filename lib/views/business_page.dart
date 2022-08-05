import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({Key? key}) : super(key: key);

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("brand")
                .where('email', isEqualTo: user!.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("No data found....");
              } else {
                List<QueryDocumentSnapshot<Object?>> fireStoreItems =
                    snapshot.data!.docs;
                return
                    //  fireStoreItems[0]['image'] != ""
                    //     ? CachedNetworkImage(
                    //         imageUrl: fireStoreItems[0]['image'],
                    //         fit: BoxFit.cover,
                    //       )
                    //     : Image.asset(
                    //         "images/profile.png",
                    //         fit: BoxFit.cover,
                    //       );

                    //Brand Image & logo
                    Stack(
                  children: [
                    fireStoreItems[0]['image'] != ""
                        ? CachedNetworkImage(
                            fadeInDuration: const Duration(milliseconds: 0),
                            fadeOutDuration: const Duration(milliseconds: 0),
                            imageUrl: fireStoreItems[0]['image'],
                            width: MediaQuery.of(context).size.width,
                            height: 182,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "images/profile.png",
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Container(
                                    height: 84,
                                    width: 84,
                                    color: Colors.white,
                                    child: fireStoreItems[0]['image'] != ""
                                        ? CachedNetworkImage(
                                            imageUrl: fireStoreItems[0]
                                                ['image'],
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "images/profile.png",
                                            fit: BoxFit.cover,
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    primary: Colors.black87,
                                  ),
                                  onPressed: () {},
                                  child: const Text("Edit Page"),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {},
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
                );
              }
            },
          ),
        ),
      ),
    );
  }
}



// // ignore_for_file: prefer_typing_uninitialized_variables

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:jutta_ghar/tiles/products_tiles.dart';
// import 'package:jutta_ghar/views/order_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// class BusinessPage extends StatefulWidget {
//   final brandName, image, logo, website;
//   const BusinessPage(
//       {Key? key,
//       this.brandName,
//       required this.image,
//       this.logo,
//       required this.website})
//       : super(key: key);

//   @override
//   State<BusinessPage> createState() => _BusinessPageState();
// }

// class _BusinessPageState extends State<BusinessPage> {
//   final user = FirebaseAuth.instance.currentUser;
//   var searchKey = "";
//   final clearSearchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//         title: Text(
//           widget.brandName.toUpperCase(),
//           style: const TextStyle(
//               color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               //Brand Image & logo
//               Stack(
//                 children: [
//                   CachedNetworkImage(
//                     fadeInDuration: const Duration(milliseconds: 0),
//                     fadeOutDuration: const Duration(milliseconds: 0),
//                     imageUrl: widget.image,
//                     width: MediaQuery.of(context).size.width,
//                     height: 182,
//                     fit: BoxFit.cover,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 182,
//                     decoration: const BoxDecoration(
//                         color: Color.fromARGB(131, 185, 185, 185)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               ClipRRect(
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(10)),
//                                 child: Container(
//                                   height: 84,
//                                   width: 84,
//                                   color: Colors.white,
//                                   child: CachedNetworkImage(
//                                     imageUrl: widget.logo,
//                                     height: 80,
//                                     width: 80,
//                                   ),
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: const [
//                                   Text(
//                                     'asdfg',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   Text(
//                                     'asdfg',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   Text(
//                                     'asdfg',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   onPrimary: Colors.white,
//                                   primary: Colors.black87,
//                                 ),
//                                 onPressed: () {},
//                                 child: const Text("Follow"),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           GestureDetector(
//                             onTap: () =>
//                                 launchUrlString(widget.website.toString()),
//                             child: Row(
//                               children: const [
//                                 Text(
//                                   "Visit our website:",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Icon(
//                                   Icons.link,
//                                   color: Colors.white,
//                                   size: 28,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               //Body
//               Container(
//                 margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
//                 width: double.infinity,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 216, 216, 216),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Center(
//                   child: TextField(
//                     textCapitalization: TextCapitalization.words,
//                     onChanged: ((value) {
//                       setState(() {
//                         searchKey = value;
//                       });
//                     }),
//                     controller: clearSearchController,
//                     textInputAction: TextInputAction.search,
//                     decoration: InputDecoration(
//                         prefixIcon: const Icon(
//                           Icons.search,
//                           color: Color.fromARGB(255, 75, 75, 75),
//                         ),
//                         suffixIcon: GestureDetector(
//                           onTap: () {
//                             clearSearchController.clear();
//                           },
//                           child: const Icon(
//                             Icons.clear,
//                             color: Color.fromARGB(255, 136, 136, 136),
//                           ),
//                         ),
//                         hintText: 'Search Products...',
//                         hintStyle: const TextStyle(
//                           color: Colors.white,
//                         ),
//                         border: InputBorder.none),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 7),
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: (searchKey != "")
//                       ? FirebaseFirestore.instance
//                           .collection('products')
//                           .where("productName",
//                               isGreaterThanOrEqualTo: searchKey)
//                           .where("productName", isLessThan: searchKey + 'z')
//                           .snapshots()
//                       : FirebaseFirestore.instance
//                           .collection("products")
//                           .snapshots(),
//                   builder: (BuildContext context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else {
//                       List<QueryDocumentSnapshot<Object?>> firestoreProducts =
//                           snapshot.data!.docs;
//                       return SizedBox(
//                         width: MediaQuery.of(context).size.width,
//                         child: Wrap(
//                           children: List.generate(
//                             firestoreProducts.length,
//                             (index) => firestoreProducts[index]
//                                         ['brand_store'] ==
//                                     widget.brandName
//                                 ? ProductTile(
//                                     name: firestoreProducts[index]
//                                         ["productName"],
//                                     description: firestoreProducts[index]
//                                         ["description"],
//                                     discount: firestoreProducts[index]
//                                             ["discount"]
//                                         .toString(),
//                                     price: firestoreProducts[index]["price"]
//                                         .toString(),
//                                     image: firestoreProducts[index]["image"],
//                                     ontap: () => Get.to(
//                                       () => OrderPage(
//                                         image: firestoreProducts[index]
//                                             ['image'],
//                                         price: firestoreProducts[index]
//                                             ['price'],
//                                         name: firestoreProducts[index]
//                                             ['productName'],
//                                         brand: firestoreProducts[index]
//                                             ['brand_store'],
//                                         description: firestoreProducts[index]
//                                             ["description"],
//                                         discount: firestoreProducts[index]
//                                                 ['discount']
//                                             .toString(),
//                                         category: firestoreProducts[index]
//                                             ['category'],
//                                         offer: firestoreProducts[index]
//                                             ['offer'],
//                                         productID: firestoreProducts[index]
//                                             ['productID'],
//                                         type: firestoreProducts[index]['type'],
//                                       ),
//                                     ),
//                                   )
//                                 : const SizedBox(),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

