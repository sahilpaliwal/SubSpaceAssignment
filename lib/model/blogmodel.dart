class Blog {
  String id;
  String title;
  String imageurl;
  bool isFav;
  Blog({required this.id, required this.title, required this.imageurl, required this.isFav});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      imageurl: json['image_url'],
      isFav: false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageurl': imageurl,
      'isFav': isFav
    };
  }
}
