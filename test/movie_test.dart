import 'package:flutter_test/flutter_test.dart';
import '../lib/models/movie.dart';


void main() {
test('Movie toMap()', () {
final movie = Movie(
id: '1',
title: 'Test',
duration: 120,
price: 50000,
isShowing: true,
ticketQuantity: 0,
coverImage: 'test_cover.jpg', 
description: 'Test movie description',
);


final map = movie.toMap();
expect(map['title'], 'Test');
expect(map['duration'], 120);
});
}
