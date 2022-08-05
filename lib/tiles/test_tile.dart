// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestTile extends StatefulWidget {
  final image,
      description,
      price,
      discount,
      name,
      productID,
      type,
      offer,
      category,
      whishlistFlag,
      brand;
  final VoidCallback? ontap;
  final VoidCallback? addToWishlist;
  const TestTile(
      {Key? key,
      this.image,
      this.description,
      this.price,
      this.discount,
      this.name,
      this.ontap,
      this.addToWishlist,
      this.productID,
      this.type,
      this.offer,
      this.category,
      this.brand,
      this.whishlistFlag})
      : super(key: key);

  @override
  State<TestTile> createState() => _TestTileState();
}

class _TestTileState extends State<TestTile> {
  //current user
  final user = FirebaseAuth.instance.currentUser;

  //check
  bool _addToWishlist = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.46,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(232, 204, 204, 204),
              offset: Offset(2, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.image,
                  height: MediaQuery.of(context).size.width * 0.48,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _addToWishlist = !_addToWishlist;
                      });
                      _addToWishlist == true
                          ? addToWishlist(context)
                          : deleteFromWishlist();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        // widget.whishlistFlag == "0"

                        _addToWishlist == true
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    widget.discount.isEmpty
                        ? const SizedBox()
                        : Container(
                            height: 20,
                            width: 45,
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    "- " + widget.discount.toString() + "%",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  widget.discount.isEmpty
                      ? Text(
                          "Rs. " + widget.price,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )
                      : Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Rs.",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(
                                    text:
                                        "${(double.parse(widget.price) - (double.parse(widget.price) * (double.parse(widget.discount) / 100)))}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Rs. " + widget.price,
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
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

  //Add to Favourites
  Future addToWishlist(context) async {
    try {
      DocumentReference documentReferencer = FirebaseFirestore.instance
          .collection("wishlist")
          .doc(user!.email)
          .collection("products")
          .doc(widget.productID);
      Map<String, dynamic> data = {
        'productName': widget.name,
        'brand_store': widget.brand,
        'category': widget.category,
        'description': widget.description,
        'discount': widget.discount,
        'price': widget.price,
        'productID': widget.productID,
        'offer': widget.offer,
        'type': widget.type,
        'image': widget.image,
      };
      documentReferencer.set(data).then((value) => Get.snackbar(
          "Added", "Item Added to Wishlist",
          backgroundColor: const Color.fromARGB(160, 105, 240, 175),
          duration: const Duration(seconds: 1)));
    } on FirebaseException catch (e) {
      Get.snackbar("Failed to add", e.toString(),
          backgroundColor: Colors.redAccent);
    }
  }

  //Delete from Favourites
  Future deleteFromWishlist() async {
    FirebaseFirestore.instance
        .collection("wishlist")
        .doc(user!.email)
        .collection("products")
        .doc(widget.productID)
        .delete()
        .then((value) => Get.snackbar(
              "Removed",
              "Item removed from Wishlist",
              duration: const Duration(seconds: 1),
            ));
  }
}
