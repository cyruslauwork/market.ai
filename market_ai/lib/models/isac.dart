import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'collections.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  Isar? _isar;

  factory IsarService() {
    return _instance;
  }

  IsarService._internal();

  Future<Isar> getIsarInstance() async {
    List<CollectionSchema<dynamic>> schemas = [
      SpyDataSchema,
      QqqDataSchema,
      UsoDataSchema,
      GldDataSchema,
      SlvDataSchema,
      IwmDataSchema,
      XlkDataSchema,
      AaplDataSchema,
      BaDataSchema,
      BacDataSchema,
      McdDataSchema,
      NvdaDataSchema,
      MsftDataSchema,
      GskDataSchema,
      TslaDataSchema,
      AmznDataSchema,
    ];
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        schemas,
        directory: dir.path,
      );
      // Clear all data in all collections
      // Future<void> clearAllData(Isar isar) async {
      //   await isar.writeTxn(() async {
      //     await isar.spyDatas.clear();
      //     await isar.qqqDatas.clear();
      //     await isar.usoDatas.clear();
      //     await isar.gldDatas.clear();
      //     await isar.slvDatas.clear();
      //     await isar.iwmDatas.clear();
      //     await isar.xlkDatas.clear();
      //     await isar.aaplDatas.clear();
      //     await isar.baDatas.clear();
      //     await isar.bacDatas.clear();
      //     await isar.mcdDatas.clear();
      //     await isar.nvdaDatas.clear();
      //     await isar.msftDatas.clear();
      //     await isar.gskDatas.clear();
      //     await isar.tslaDatas.clear();
      //     await isar.amznDatas.clear();
      //   });
      //   print('clear all Isac data');
      // }

      // await clearAllData(_isar!);
    }
    return _isar!;
  }

  Future<void> clearData(String symbol) async {
    await _isar!.writeTxn(() async {
      switch (symbol) {
        case 'SPY':
          await _isar!.spyDatas.clear();
          break;
        case 'QQQ':
          await _isar!.qqqDatas.clear();
          break;
        case 'USO':
          await _isar!.usoDatas.clear();
          break;
        case 'GLD':
          await _isar!.gldDatas.clear();
          break;
        case 'SLV':
          await _isar!.slvDatas.clear();
          break;
        case 'IWM':
          await _isar!.iwmDatas.clear();
          break;
        case 'XLK':
          await _isar!.xlkDatas.clear();
          break;
        case 'AAPL':
          await _isar!.aaplDatas.clear();
          break;
        case 'BA':
          await _isar!.baDatas.clear();
          break;
        case 'BAC':
          await _isar!.bacDatas.clear();
          break;
        case 'MCD':
          await _isar!.mcdDatas.clear();
          break;
        case 'NVDA':
          await _isar!.nvdaDatas.clear();
          break;
        case 'MSFT':
          await _isar!.msftDatas.clear();
          break;
        case 'GSK':
          await _isar!.gskDatas.clear();
          break;
        case 'TSLA':
          await _isar!.tslaDatas.clear();
          break;
        case 'AMZN':
          await _isar!.amznDatas.clear();
          break;
        default:
          throw Exception('Unknown symbol: $symbol');
      }
    });
  }
}
