class UploadMediaResult {
  final String className;
  final double confidence;

  UploadMediaResult({required this.className, required this.confidence});

  factory UploadMediaResult.fromJson(Map<String, dynamic> json) {
    return UploadMediaResult(
      className: json['class'],
      confidence: json['confidence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class': className,
      'confidence': confidence,
    };
  }
}
