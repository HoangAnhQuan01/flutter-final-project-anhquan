import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../services/movie_service.dart';
import '../models/movie.dart';
import 'movie_form_screen.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatelessWidget {
  final service = MovieService();

  MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách phim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MovieFormScreen()),
          );
        },
      ),
      body: StreamBuilder<List<Movie>>(
        stream: service.getMovies(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final movies = snapshot.data!;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, i) {
              final m = movies[i];
              return ListTile(
                onTap: () { // Thêm hành động onTap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(movieId: m.id), // Chuyển sang màn hình chi tiết
                    ),
                  );
                },
                leading: m.coverImage.isNotEmpty
                    ? Image.network(
                        m.coverImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.movie),
                      )
                    : const Icon(Icons.movie),
                title: Text(m.title),
                subtitle: Text('${m.duration} phút - ${m.price}đ'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => service.deleteMovie(m.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}