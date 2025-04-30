import 'package:intl/intl.dart';
import 'package:movieapp/core/constants/api_constants.dart';

class Utils {
  static String getImageUrl(String? path, {ImageSize size = ImageSize.w500}) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/500x750?text=No+Image';
    }
    
    switch (size) {
      case ImageSize.original:
        return '${ApiConstants.originalImageUrl}$path';
      case ImageSize.w500:
        return '${ApiConstants.w500ImageUrl}$path';
      case ImageSize.w300:
        return '${ApiConstants.w300ImageUrl}$path';
    }
  }

  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return '정보 없음';
    }
    
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy년 MM월 dd일').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  static String formatRuntime(int? minutes) {
    if (minutes == null || minutes <= 0) {
      return '정보 없음';
    }
    
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (hours > 0) {
      return '$hours시간 $remainingMinutes분';
    } else {
      return '$remainingMinutes분';
    }
  }

  static String formatMoney(int value) {
    if (value <= 0) {
      return '\$0';
    }
    
    return '\$${NumberFormat('#,###').format(value)}';
  }
}

enum ImageSize {
  original,
  w500,
  w300,
}