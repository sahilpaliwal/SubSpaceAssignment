// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:subspace/model/blogmodel.dart';
import 'package:subspace/utils/consts.dart';
import 'package:subspace/view/detialblog_page.dart';

class BlogCard extends StatefulWidget {
  Blog blog;
  BlogCard({super.key, required this.blog});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: InkWell(
        onTap: () {
          Get.to(() => DetailBlogPage(blog: widget.blog));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: gray, width: 1),
            borderRadius: BorderRadius.circular(15),
            color: white,
          ),
          child: Row(children: [
            SizedBox(
              width: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 140,
                width: 160,
                color: gray,
                child: Image.network(
                  widget.blog.imageurl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, right: 15, left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.blog.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: black),
                  ),
                  Text(
                    "10 min Read  ●  12/08/23",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        fontSize: 10, fontWeight: FontWeight.w600, color: gray),
                  ),
                ],
              ),
            ))
          ]),
        ),
      ),
    );
  }
}
