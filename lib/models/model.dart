class Day {
  String date;
  int confirmed;
  int deaths;
  int recovered;

  Day({this.date, this.deaths, this.recovered, this.confirmed});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
        date: json["date"],
        confirmed: json["confirmed"],
        deaths: json["deaths"],
        recovered: json["recovered"]);
  }
}
