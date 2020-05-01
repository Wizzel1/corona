import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:path_provider/path_provider.dart';

class CountriesCache {
  DateTime _lastFetchTime;
  bool isExpired;
  List<String> _countries;
  Duration _cacheDuration = Duration(days: 5);
  Map<String, dynamic> _fileContent;

  //Get the path to directory
  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //Return the file at this path
  Future<File> get _getLocalCountriesFile async {
    final path = await _getLocalPath;
    return File('$path/countries.json');
  }

  void writeCountries(List<String> countries) async {
    final file = await _getLocalCountriesFile;
    _lastFetchTime = DateTime.now();
    _fileContent = {'createdAt': _lastFetchTime.toIso8601String(), 'countries': countries};
    // Write the file.
    file.writeAsString(jsonEncode(_fileContent));
  }

  Future<List<String>> readCountries() async {
    try {
      final file = await _getLocalCountriesFile;
      //get contents of file
      _fileContent = jsonDecode(await file.readAsString());
      _lastFetchTime = DateTime.parse(_fileContent['createdAt']);
      isExpired = _lastFetchTime.isBefore(DateTime.now().subtract(_cacheDuration));
      if (isExpired) {
        return null;
      } else {
        List<dynamic> _temp = _fileContent['countries'];
        _countries = _temp.cast<String>();
        return _countries;
      }
    } catch (e) {
      return null;
    }
  }
}
