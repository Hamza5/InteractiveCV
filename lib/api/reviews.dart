abstract class ReviewData {
  final String author;
  final String title;
  final String text;
  final List<double> ratings;
  final Uri? link;

  ReviewData({
    required this.author, required this.title, required this.text,
    required this.ratings, this.link,
  });

  double get averageRating => ratings.fold(0.0, (previousValue, element) => previousValue + element) / ratings.length;

  bool get isRTL => text.contains(RegExp(r'[\u0590-\u05FF\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\u1EE00-\u1EEFF]'));

}

abstract class ReviewsData {
  List<ReviewData> reviews;
  List<double> ratings;

  ReviewsData({
    required this.reviews,
    required this.ratings,
  });

  double get averageRating => ratings.fold(0.0, (previousValue, element) => previousValue + element) / ratings.length;

  int get authorCount => reviews.map((review) => review.author).toSet().length;
}

abstract class ReviewsService {
  Future<ReviewsData> getReviews();
}