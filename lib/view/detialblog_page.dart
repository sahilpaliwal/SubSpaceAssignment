// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:subspace/model/blogmodel.dart';
import 'package:subspace/utils/consts.dart';

class DetailBlogPage extends StatefulWidget {
  Blog blog;
  DetailBlogPage({super.key, required this.blog});

  @override
  State<DetailBlogPage> createState() => _DetailBlogPageState();
}

class _DetailBlogPageState extends State<DetailBlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whitebg,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            color: black,
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                widget.blog.isFav
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: widget.blog.isFav ? red : black,
              ),
              onPressed: () {
                setState(() {
                  widget.blog.isFav = !widget.blog.isFav;
                });
              },
            ),
          ],
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "SubSpace",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900, fontSize: 18, color: black),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: gray,
              child: Image.network(
                widget.blog.imageurl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.blog.title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: black),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "10 min Read  ●  12/08/23",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w600, color: gray),
                  ),
                  SizedBox(height: 20,),
                  Text(""),
                ],
              ),
            ),
          ],
        ));
  }
}
