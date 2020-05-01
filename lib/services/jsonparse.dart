import 'dart:math';

import 'package:coronaapp/models/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cache.dart';

class JsonService {
  final CountriesCache _countriesCache = new CountriesCache();

  Future<List<String>> fetchCountrys() async {
    if (await _countriesCache.readCountries() == null) {
      var url = 'https://pomber.github.io/covid19/timeseries.json';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        data.entries.toList().sort((entry1, entry2) {
          return entry1.key.toLowerCase().compareTo(entry2.key.toLowerCase());
        });
        List<String> keyList = data.keys.toList();
        keyList.add('Worldwide');
        _countriesCache.writeCountries(keyList);
        return keyList;
      }
    } else {
      return _countriesCache.readCountries();
    }
  }

  Future<List<Day>> fetchData(String country) async {
    var url = 'https://pomber.github.io/covid19/timeseries.json';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      if (country == null) {
        return [Day(date: '', deaths: 0, confirmed: 0, recovered: 0)];
      } else if (country == 'Worldwide') {
        Iterable<List<Day>> countryLists = (decoded.entries.map((e) => List.from(decoded[e.key])
            .map((e) => Day(
                date: e['date'],
                confirmed: e['confirmed'],
                deaths: e['deaths'],
                recovered: e['recovered']))
            .toList()));
        var sum = countryLists.first.map((day) {
          return Day(confirmed: 0, recovered: 0, deaths: 0, date: '');
        }).toList();
        var list = countryLists.toList();
        for (int i = 0; i < list.first.length; i++) {
          sum[i].date = list.first[i].date;
          for (int j = 0; j < list.length; j++) {
            sum[i].deaths += list[j][i].deaths;
            sum[i].confirmed += list[j][i].confirmed;
            sum[i].recovered += list[j][i].recovered;
          }
        }
        print(sum.length);
        return sum;
      } else {
        return List.from(decoded[country])
            .map((e) => Day(
                date: e['date'],
                confirmed: e['confirmed'],
                deaths: e['deaths'],
                recovered: e['recovered']))
            .toList();
      }
    }
  }
}
