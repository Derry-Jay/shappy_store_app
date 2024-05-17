class Response {
  final bool success, status;
  final String message;
  Response(this.success, this.status, this.message);
  factory Response.fromMap(Map<String, dynamic> json) {
    return Response(
        json['success'],
        json['status'],
        json['message'] == null
            ? (json['result'] == null ? "" : json['result'])
            : json['message']);
  }
}
