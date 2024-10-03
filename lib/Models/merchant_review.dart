class MerchantReview {
  int? id;
  int? rating;
  String? customerServiceRating;
  String? qualityRating;
  String? friendlyRating;
  String? pricingRating;
  String? recommend;
  String? department;
  String? title;
  String? body;
  int? approved;
  String? reviewrateableType;
  int? reviewrateableId;
  String? authorType;
  int? authorId;
  String? subjectType;
  int? subjectId;
  String? createdAt;
  String? updatedAt;

  MerchantReview(
      {this.id,
      this.rating,
      this.customerServiceRating,
      this.qualityRating,
      this.friendlyRating,
      this.pricingRating,
      this.recommend,
      this.department,
      this.title,
      this.body,
      this.approved,
      this.reviewrateableType,
      this.reviewrateableId,
      this.authorType,
      this.authorId,
      this.subjectType,
      this.subjectId,
      this.createdAt,
      this.updatedAt});

  MerchantReview.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    customerServiceRating = json['customer_service_rating'];
    qualityRating = json['quality_rating'];
    friendlyRating = json['friendly_rating'];
    pricingRating = json['pricing_rating'];
    recommend = json['recommend'];
    department = json['department'];
    title = json['title'];
    body = json['body'];
    approved = json['approved'];
    reviewrateableType = json['reviewrateable_type'];
    reviewrateableId = json['reviewrateable_id'];
    authorType = json['author_type'];
    authorId = json['author_id'];
    subjectType = json['subject_type'];
    subjectId = json['subject_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['customer_service_rating'] = customerServiceRating;
    data['quality_rating'] = qualityRating;
    data['friendly_rating'] = friendlyRating;
    data['pricing_rating'] = pricingRating;
    data['recommend'] = recommend;
    data['department'] = department;
    data['title'] = title;
    data['body'] = body;
    data['approved'] = approved;
    data['reviewrateable_type'] = reviewrateableType;
    data['reviewrateable_id'] = reviewrateableId;
    data['author_type'] = authorType;
    data['author_id'] = authorId;
    data['subject_type'] = subjectType;
    data['subject_id'] = subjectId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
