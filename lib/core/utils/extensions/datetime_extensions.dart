

extension DateTimeExtensions on DateTime {
  String toNorwegianFormat() {
    return "${this.day.toString().padLeft(2, '0')}-${this.month.toString().padLeft(2, '0')}-${this.year}";
  }
}
