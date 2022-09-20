// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_const_constructors, must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/views/brand_page.dart';
import 'package:jutta_ghar/views/review_page.dart';

class OrderPage extends StatefulWidget {
  final image,
      description,
      price,
      discount,
      name,
      productID,
      type,
      offer,
      category,
      brand;

  const OrderPage(
      {Key? key,
      this.brand,
      this.name,
      this.image,
      @required this.price,
      this.discount,
      this.description,
      this.productID,
      this.type,
      this.offer,
      this.category})
      : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var screenValue = 1;
  var total;
  var locationMessage = '';
  var Address;

  @override
  void initState() {
    total = int.parse(widget.price);
    getAddressFromLatLong();
    super.initState();
  }

  containerShadow() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(0),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(232, 204, 204, 204),
          offset: Offset(2, 2),
          blurRadius: 3.5,
        ),
      ],
    );
  }

  increment() {
    setState(() {
      if (screenValue >= 20) {
        screenValue;
      } else {
        screenValue++;
        total = total + int.parse(widget.price);
      }
    });
  }

  decrement() {
    if (screenValue > 1) {
      setState(() {
        if (screenValue <= 1) {
          screenValue;
        } else {
          --screenValue;
          total = total - int.parse(widget.price);
        }
      });
    }
  }

  // Current location
  Future getAddressFromLatLong() async {
    await Geolocator.requestPermission();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      locationMessage = "$Address";
    });
    return locationMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: InteractiveViewer(
                            child: AlertDialog(
                              titlePadding: const EdgeInsets.all(0),
                              title: CachedNetworkImage(
                                imageUrl: widget.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
                      height: MediaQuery.of(context).size.height / 2.6,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        padding:
                            const EdgeInsets.only(left: 15, top: 14, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(232, 204, 204, 204),
                              offset: Offset(2, 2),
                              blurRadius: 3.5,
                            ),
                          ],
                        ),
                        //----Body---
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    widget.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.5,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => Get.to(() => ReviewPage(
                                        productId: widget.productID,
                                      )),
                                  child: Row(
                                    children: const [
                                      Text(
                                        "See Reviews",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.teal),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 15,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                widget.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Rs. ",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 73, 73, 73),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text: widget.price,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 51, 51, 51),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              indent: 5,
                              endIndent: 5,
                              thickness: 0.8,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('brand')
                                  .where("brand_name", isEqualTo: widget.brand)
                                  .snapshots(),
                              builder: (BuildContext context, snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        kToolbarHeight,
                                    child: Center(
                                      child: Text(
                                        "Loading...",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  );
                                } else {
                                  List<QueryDocumentSnapshot<Object?>>
                                      firestoreBrand = snapshot.data!.docs;
                                  return GestureDetector(
                                    onTap: () => Get.to(() => BrandPage(
                                      id: firestoreBrand[0]['brand_id'],
                                      website: firestoreBrand[0]['website'],
                                          image: firestoreBrand[0]["image"],
                                          logo: firestoreBrand[0]["logo"],
                                          brandName: widget.brand,
                                        )),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Icon(
                                                Icons.home_outlined,
                                                color: Color.fromARGB(
                                                    255, 83, 83, 83),
                                              ),
                                            ),
                                            Text(
                                              widget.brand.toUpperCase(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  height: 1.5,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 83, 83, 83)),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.all(3),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),

                      //-----Location
                      Container(
                        decoration: containerShadow(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                top: 10,
                                right: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "DELIVER TO",
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.edit,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Edit Location",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 15, bottom: 25, left: 20, right: 20),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: const Border(
                                    top: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 211, 210, 210)),
                                    left: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 211, 210, 210)),
                                    right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 211, 210, 210)),
                                    bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 211, 210, 210)),
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        "Current location",
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                255, 114, 114, 114),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: locationMessage == ''
                                        ? Center(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 100,
                                                    top: 8,
                                                    bottom: 4),
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                        : Text(
                                            locationMessage.toString(),
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      //----Receipt section----
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        decoration: containerShadow(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "RECEIPT",
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Divider(
                              indent: 5,
                              endIndent: 5,
                              thickness: 1.5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Quantity",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                //-----Increament & decrement-----
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        decrement();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.black87,
                                        minimumSize: const Size(6, 6),
                                      ),
                                      child: const Text(
                                        "-",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "$screenValue",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.black87,
                                        minimumSize: const Size(6, 6),
                                      ),
                                      onPressed: () {
                                        increment();
                                      },
                                      child: const Text(
                                        "+",
                                        style: TextStyle(
                                          fontSize: 18.2,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Sub-Total: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "Rs. " + total.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            widget.discount.isEmpty
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      const Text(
                                        "Discount:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(widget.discount.toString() + "%"),
                                    ],
                                  ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Deliver charge:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "100",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Divider(
                              indent: 20,
                              endIndent: 20,
                              thickness: 0.8,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Total:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                const Spacer(),
                                widget.discount.isEmpty == true
                                    ? Text("Rs. " + (total + 100).toString())
                                    : Text(
                                        "Rs. ${(total) - ((total) * (double.parse(widget.discount) / 100)) + 100}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  )
                ],
              ),
            ),

            //-----Back Button-----
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 22,
                    )),
              ),
            ),
            //-----Add To cart & buy Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(top: 10, bottom: 12, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 45),
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        addToCart(context);
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 18,
                            ),
                          ),
                          Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 45),
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        buyNow();
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.play_arrow,
                              size: 18,
                            ),
                          ),
                          Text(
                            'Buy Now',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Add to Cart
  Future addToCart(context) async {
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
          .collection("cart")
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
      documentReferencer.set(data).then((value) => Navigator.pop(context)).then(
          (value) => Get.snackbar("Added", "Item Added to Cart",
              backgroundColor: const Color.fromARGB(115, 105, 240, 175)));
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.redAccent);
    }
  }

  //Order
  buyNow(){
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
          .collection("order_requests")
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
        'order_date' : DateTime.now().toString(),
        'quantity': screenValue,
      };
      documentReferencer.set(data).then((value) => Navigator.pop(context)).then(
          (value) => Get.snackbar("Order Placed", "Your order has successfully been placed",
              backgroundColor: const Color.fromARGB(115, 105, 240, 175)));
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.redAccent);
    }
  }
}
