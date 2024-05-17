class ImageUpload {
  final bool success, status;
  final String message, imageUrl;
  ImageUpload(this.success, this.status, this.message, this.imageUrl);
  factory ImageUpload.fromMap(Map<String, dynamic> json) {
    return ImageUpload(
        json['success'], json['status'], json['message'], json['location']);
  }
}
