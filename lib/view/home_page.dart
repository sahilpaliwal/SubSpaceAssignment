// ignore_for_file: implementation_imports, prefer_const_literals_to_create_immutables, prefer_const_declarations, avoid_print, unused_local_variable, unnecessary_brace_in_string_interps, prefer_const_constructors, non_constant_identifier_names, unused_element, prefer_is_empty, unnecessary_null_comparison
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:subspace/utils/blogcard.dart';
import 'package:subspace/utils/consts.dart';
import 'package:http/http.dart' as http;
import '../model/blogmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Blog>? bloglist;
  List<Blog> visibleBlogList = [];
  bool isloading = false;
  final ScrollController scrollController = ScrollController();
  TextEditingController? searchTextcontroller;
  List<Blog> SearchResult = [];
  bool showSearchResult = false;
  final focussnode = FocusNode();

  void AddblogstoVisibleList(int currentlistlength) {
    log("inaddblog fun(start)");
    if (isloading) {
      return;
    } else {
      setState(() {
        isloading = true;
      });
      List<Blog> demolist = [];
      for (int i = currentlistlength; i < currentlistlength + 10; i++) {
        demolist.add(bloglist![i]);
      }
      if (visibleBlogList.isNotEmpty) {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            visibleBlogList.addAll(demolist);
            isloading = false;
          });
        });
      } else {
        setState(() {
          visibleBlogList.addAll(demolist);
          isloading = false;
        });
      }
    }
  }

  void printblogs(List<Blog> blogs) {
    for (int i = 0; i < blogs.length; i++) {
      log("Blog ${i} : title: ${blogs[i].title} imageurl: ${blogs[i].imageurl} \n");
    }
  }

  void fetchBlogs() async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final List<dynamic> blogList = jsonData['blogs'];
        final List<Blog> blogs = blogList.map((json) {
          return Blog.fromJson(json);
        }).toList();
        setState(() {
          bloglist = blogs;
        });
        AddblogstoVisibleList(0);
      } else {
        // Request failed
        print('Request failed with status code: ${response.statusCode}');
        print('Response data: ${response.body}');
      }
    } catch (e) {
      // errors
      print('Error: $e');
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      // User has reached near the end of the list
      if (!isloading) {
        AddblogstoVisibleList(visibleBlogList.length);
        log("Current visible list length: ${visibleBlogList.length}");
      }
    }
  }

  getSearchResults(String value) {
    if (value == "") {
      setState(() {
        showSearchResult = false;
        SearchResult = [];
      });
    } else {
      List<Blog> matchingResults = [];
      for (var blog in visibleBlogList) {
        if (blog.title.toLowerCase().contains(value.toLowerCase())) {
          matchingResults.add(blog);
        }
      }
      matchingResults.sort((a, b) {
        String aName = a.title.toLowerCase();
        String bName = b.title.toLowerCase();
        int aIndex = aName.indexOf(value.toLowerCase());
        int bIndex = bName.indexOf(value.toLowerCase());
        if (aIndex == bIndex) {
          return aName.compareTo(bName);
        } else if (aIndex == -1) {
          return 1;
        } else if (bIndex == -1) {
          return -1;
        } else {
          return aIndex - bIndex;
        }
      });
      setState(() {
        showSearchResult = true;
        SearchResult = matchingResults;
      });
    }
  }

  @override
  void initState() {
    bool showSearchResult = false;
    searchTextcontroller = TextEditingController();
    scrollController.addListener(_scrollListener);
    fetchBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          focussnode.unfocus();
        },
        child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.sort_rounded),
              color: black,
              onPressed: () {},
            ),
            backgroundColor: white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "SubSpace",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w900, fontSize: 18, color: black),
            ),
          ),
          body: bloglist != null && visibleBlogList != null
              ? SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onChanged: (value) {
                                    getSearchResults(value);
                                  },
                                  focusNode: focussnode,
                                  scrollPhysics: BouncingScrollPhysics(),
                                  controller: searchTextcontroller,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Search blog topic',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00F1F4F8),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00F1F4F8),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: white,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            15, 15, 0, 15),
                                  ),
                                  style: GoogleFonts.quicksand(
                                      color: black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Icon(Icons.search_rounded)
                            ],
                          ),
                        ),
                      ),
                    ),
                    showSearchResult == false
                        ? ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            // controller: scrollController,
                            itemCount: visibleBlogList.length,
                            itemBuilder: (context, index) {
                              return BlogCard(blog: visibleBlogList[index]);
                            },
                          )
                        : Column(
                            children: [
                              ListView.builder(
                                  itemCount: SearchResult.length,
                                  padding: EdgeInsets.only(bottom: 20),
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return BlogCard(blog: SearchResult[index]);
                                  })
                            ],
                          ),
                    isloading
                        ? Padding(
                            padding: EdgeInsets.all(30),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: black,
                            )),
                          )
                        : SizedBox()
                  ]),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: black,
                )),
        ));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
