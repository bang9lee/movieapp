class JsonUtils {
  /// null-safe 하게 double 값을 가져옵니다
  static double safeDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) {
      return defaultValue;
    }
    
    if (value is double) {
      return value;
    }
    
    if (value is int) {
      return value.toDouble();
    }
    
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    
    return defaultValue;
  }
  
  /// null-safe 하게 int 값을 가져옵니다
  static int safeInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) {
      return defaultValue;
    }
    
    if (value is int) {
      return value;
    }
    
    if (value is double) {
      return value.toInt();
    }
    
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    
    return defaultValue;
  }
  
  /// null-safe 하게 List<T> 값을 가져옵니다
  static List<T> safeList<T>(dynamic value, T Function(dynamic) converter, [List<T> defaultValue = const []]) {
    if (value == null) {
      return defaultValue;
    }
    
    if (value is List) {
      try {
        return value.map((item) => converter(item)).toList();
      } catch (e) {
        print('Error parsing list: $e');
        return defaultValue;
      }
    }
    
    return defaultValue;
  }
  
  /// null-safe 하게 String 값을 가져옵니다
  static String safeString(dynamic value, [String defaultValue = '']) {
    if (value == null) {
      return defaultValue;
    }
    
    if (value is String) {
      return value;
    }
    
    return value.toString();
  }
  
  /// null-safe 하게 bool 값을 가져옵니다
  static bool safeBool(dynamic value, [bool defaultValue = false]) {
    if (value == null) {
      return defaultValue;
    }
    
    if (value is bool) {
      return value;
    }
    
    if (value is int) {
      return value != 0;
    }
    
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    
    return defaultValue;
  }
}