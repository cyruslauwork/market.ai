import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

exportCsv(List<List<dynamic>> listList, String fileName) async {
  // Convert List<List<dynamic>> to CSV
  String csvData = const ListToCsvConverter().convert(listList);

  // Get the path to the user's Desktop directory
  Directory docDir = await getApplicationDocumentsDirectory();
  String docsPath = docDir.path;

  // Create the CSV file
  File file = File('$docsPath/$fileName.csv');
  file.writeAsStringSync(csvData);

  // print('CSV file saved to: ${file.path}');
}
