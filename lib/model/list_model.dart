class CallSummary {
  final int total;
  final int pending;
  final int called;
  final int rescheduled;

  CallSummary({
    required this.total,
    required this.pending,
    required this.called,
    required this.rescheduled,
  });

  /// Create summary from raw API List (json list of maps)
  factory CallSummary.fromJsonList(List<dynamic> data) {
  int pending = 0;
  int called = 0;
  int rescheduled = 0;

  for (var item in data) {
    final status = (item['status'] ?? '').toString().toLowerCase();
    print('STATUS: $status'); // 👀 See real value

    if (status == 'pending') {
      pending++;
    } else if (status == 'done') {
      called++;
    } else if (status.contains('schedule')) {  // ⚡ Matches any containing word!
      rescheduled++;
    }
  }

  return CallSummary(
    total: data.length,
    pending: pending,
    called: called,
    rescheduled: rescheduled,
    
  );
}

}
