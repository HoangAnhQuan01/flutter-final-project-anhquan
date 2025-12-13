import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../models/movie.dart';

class MovieFormScreen extends StatefulWidget {
  // Thêm đối tượng Movie để hỗ trợ chỉnh sửa (có thể là null nếu đang thêm mới)
  final Movie? movie;

  const MovieFormScreen({super.key, this.movie});

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final titleCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final ticketQuantityCtrl = TextEditingController();
  final coverImageCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  
  final service = MovieService();
  
  // Hàm khởi tạo trạng thái và điền dữ liệu nếu đang chỉnh sửa
  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      titleCtrl.text = widget.movie!.title;
      durationCtrl.text = widget.movie!.duration.toString();
      priceCtrl.text = widget.movie!.price.toString();
      ticketQuantityCtrl.text = widget.movie!.ticketQuantity.toString();
      coverImageCtrl.text = widget.movie!.coverImage;
      descriptionCtrl.text = widget.movie!.description;
    }
  }

  // Giải phóng controller
  @override
  void dispose() {
    titleCtrl.dispose();
    durationCtrl.dispose();
    priceCtrl.dispose();
    ticketQuantityCtrl.dispose();
    coverImageCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  // Hàm xử lý lưu/cập nhật
Future<void> _saveMovie() async {
    final String movieId = widget.movie?.id ?? '';
    final bool isEditing = widget.movie != null;

    final movie = Movie(
      id: movieId,
      title: titleCtrl.text,
      duration: int.parse(durationCtrl.text),
      price: double.parse(priceCtrl.text),
      isShowing: widget.movie?.isShowing ?? true, 
      ticketQuantity: int.parse(ticketQuantityCtrl.text),
      coverImage: coverImageCtrl.text,
      description: descriptionCtrl.text,
    );

    if (isEditing) {
      await service.updateMovie(movie); 
    } else {
      await service.addMovie(movie); 
    }

    // *** Đã sửa: Chỉ pop màn hình hiện tại. MovieDetailScreen sẽ tự động cập nhật. ***
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'Thêm phim' : 'Chỉnh sửa phim'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(children: [
            TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Tên phim')),
            TextField(
              controller: durationCtrl, 
              decoration: InputDecoration(labelText: 'Thời lượng (phút)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceCtrl, 
              decoration: InputDecoration(labelText: 'Giá vé'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: ticketQuantityCtrl, 
              decoration: InputDecoration(labelText: 'Số lượng vé'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: coverImageCtrl, 
              decoration: InputDecoration(labelText: 'URL Ảnh bìa'),
              keyboardType: TextInputType.url,
            ),
            TextField(
              controller: descriptionCtrl, 
              decoration: InputDecoration(labelText: 'Mô tả'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(widget.movie == null ? 'Lưu' : 'Cập nhật'),
              onPressed: _saveMovie, // Gọi hàm lưu/cập nhật
            )
          ]),
        ),
      ),
    );
  }
}