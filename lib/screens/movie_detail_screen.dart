import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart'; // Import service
import 'movie_form_screen.dart'; 

class MovieDetailScreen extends StatelessWidget {
  final String movieId; // Nhận ID
  final service = MovieService(); // Khởi tạo service

MovieDetailScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // *** Thay đổi: Sử dụng StreamBuilder để lắng nghe dữ liệu ***
    return StreamBuilder<Movie>( 
      stream: service.getMovie(movieId), // Gọi hàm lấy stream theo ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Đang tải...')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Lỗi')),
            body: Center(child: Text('Không tìm thấy phim hoặc lỗi tải dữ liệu.')),
          );
        }

        final movie = snapshot.data!;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
            actions: [
              IconButton( // Nút chỉnh sửa
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Truyền đối tượng movie đã được cập nhật
                      builder: (_) => MovieFormScreen(movie: movie), 
                    ),
                  );
                },
              ),
            ],
          ),
          // ... (Phần hiển thị chi tiết sử dụng đối tượng 'movie' được cập nhật)
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movie.coverImage.isNotEmpty)
                  Center(
                    child: Image.network(
                      movie.coverImage,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.movie, size: 300), 
                    ),
                  ),
                const SizedBox(height: 20),
                
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Divider(),

                _buildDetailRow('Thời lượng:', '${movie.duration} phút'),
                _buildDetailRow('Giá vé:', '${movie.price}đ'),
                _buildDetailRow('Đang chiếu:', movie.isShowing ? 'Có' : 'Không'),
                _buildDetailRow('Số lượng vé:', '${movie.ticketQuantity} vé'),

                const SizedBox(height: 15),
                Text(
                  'Mô tả:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                Text(movie.description),
              ],
            ),
          ),
        );
      },
    );
  }

  // Hàm _buildDetailRow vẫn giữ nguyên
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}