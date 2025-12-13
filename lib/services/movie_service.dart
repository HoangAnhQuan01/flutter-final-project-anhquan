import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';


class MovieService {
  final _ref = FirebaseFirestore.instance.collection('movies');


  Stream<List<Movie>> getMovies() {
    return _ref.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Movie.fromMap(doc.id, doc.data()!))
        .toList());
  }

  // Phương thức mới: Lấy stream của một bộ phim duy nhất
  Stream<Movie> getMovie(String id) {
    return _ref.doc(id).snapshots().map((snapshot) => 
        Movie.fromMap(snapshot.id, snapshot.data()!));
  }


  Future<void> addMovie(Movie movie) async {
    await _ref.add(movie.toMap());
  }


  Future<void> updateMovie(Movie movie) async {
    await _ref.doc(movie.id).update(movie.toMap());
  }


  Future<void> deleteMovie(String id) async {
    await _ref.doc(id).delete();
  }
}