class Movie {
  final String id;
  final String title;
  final int duration;
  final double price;
  final bool isShowing;
  // Thuộc tính mới
  final int ticketQuantity;
  final String coverImage;
  final String description;

  Movie({
    required this.id,
    required this.title,
    required this.duration,
    required this.price,
    required this.isShowing,
    // Thuộc tính mới
    required this.ticketQuantity,
    required this.coverImage,
    required this.description,
  });

  factory Movie.fromMap(String id, Map<String, dynamic> data) {
    return Movie(
      id: id,
      title: data['title'],
      duration: data['duration'],
      price: (data['price'] as num).toDouble(),
      isShowing: data['isShowing'] ?? false, // Đảm bảo an toàn
      // Ánh xạ thuộc tính mới. Sử dụng giá trị mặc định nếu không có trong Firestore.
      ticketQuantity: data['ticketQuantity'] ?? 0,
      coverImage: data['coverImage'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'duration': duration,
      'price': price,
      'isShowing': isShowing,
      // Thuộc tính mới
      'ticketQuantity': ticketQuantity,
      'coverImage': coverImage,
      'description': description,
    };
  }
}