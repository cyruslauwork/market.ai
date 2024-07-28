import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

void exportCsv(List<List<dynamic>> listList, String fileName) async {
  // Convert List<List<dynamic>> to CSV
  String csvData = const ListToCsvConverter().convert(listList);

  // Get the path to the user's Desktop directory
  Directory desktopDir = await getApplicationDocumentsDirectory();
  String desktopPath = desktopDir.path;

  // Create a folder called 'market.ai.csv' in the Desktop directory
  String folderPath = '$desktopPath/market.ai.csv';
  Directory folderDir = Directory(folderPath);
  if (!folderDir.existsSync()) {
    folderDir.createSync();
  }

  // Create the CSV file
  File file = File('$folderPath/$fileName.csv');
  file.writeAsStringSync(csvData);

  // print('CSV file saved to: ${file.path}');
}
