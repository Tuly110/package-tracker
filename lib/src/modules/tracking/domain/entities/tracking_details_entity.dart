import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_details_entity.freezed.dart';
part 'tracking_details_entity.g.dart';

@freezed
class TrackingDetailEntity with _$TrackingDetailEntity {
  const factory TrackingDetailEntity({
    required Map<String, dynamic> rawData,
  }) = _TrackingDetailEntity;

  factory TrackingDetailEntity.fromJson(Map<String, dynamic> json) =>
      TrackingDetailEntity(rawData: json);
      
}

extension TrackingDetailX on TrackingDetailEntity {
  /// Carrier name
  String? get carrierName {
    final providers = rawData['tracking_info']?['track_info']?['tracking']?['providers'] as List?;
    if (providers != null && providers.isNotEmpty) {
      return providers.first['provider']?['name'];
    }
    return null;
  }

  /// Latest status
  String? get latestStatus {
    // Ưu tiên lấy từ tracking_info lồng sâu mà 17TRACK trả về
    return rawData['tracking_info']?['track_info']?['latest_status']?['status'] 
        ?? rawData['status']; // Nếu không có mới lấy từ DB
  }

  String? get trackingNumber {
    return rawData['tracking_info']?['number'] ?? rawData['number'];
  }

  /// Danh sách hành trình (ngược thời gian)
  List<Map<String, dynamic>> get tracks {
    final providers = rawData['tracking_info']?['track_info']?['tracking']?['providers'] as List?;
    if (providers == null || providers.isEmpty) return [];

    final events = (providers.first['events'] as List?) ?? [];
    final mapped = events.map((e) => {
          "time_iso": e['time_iso'],
          "description": e['description'],
        });

    final sorted = mapped.toList()
      ..sort((a, b) => (b['time_iso'] ?? '').compareTo(a['time_iso'] ?? ''));

    return sorted;
  }
}


