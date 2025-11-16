enum TimeWindow {
  short(label: '<30 Min', maxMinutes: 30),
  medium(label: '30-60 Min', maxMinutes: 60),
  long(label: '>60 Min', maxMinutes: null);

  const TimeWindow({required this.label, this.maxMinutes});

  final String label;
  final int? maxMinutes;

  bool matches(int? duration) {
    if (duration == null) return false;
    switch (this) {
      case TimeWindow.short:
        return duration < 30;
      case TimeWindow.medium:
        return duration >= 30 && duration <= 60;
      case TimeWindow.long:
        return duration > 60;
    }
  }
}
