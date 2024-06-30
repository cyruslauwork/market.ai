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

  Future<void> clearSpyData() async {
    await _isar!.writeTxn(() async {
      await _isar!.spyDatas.clear();
    });
  }

  Future<void> clearQqqData() async {
    await _isar!.writeTxn(() async {
      await _isar!.qqqDatas.clear();
    });
  }

  Future<void> clearUsoData() async {
    await _isar!.writeTxn(() async {
      await _isar!.usoDatas.clear();
    });
  }

  Future<void> clearGldData() async {
    await _isar!.writeTxn(() async {
      await _isar!.gldDatas.clear();
    });
  }

  Future<void> clearSlvData() async {
    await _isar!.writeTxn(() async {
      await _isar!.slvDatas.clear();
    });
  }

  Future<void> clearIwmData() async {
    await _isar!.writeTxn(() async {
      await _isar!.iwmDatas.clear();
    });
  }

  Future<void> clearXlkData() async {
    await _isar!.writeTxn(() async {
      await _isar!.xlkDatas.clear();
    });
  }

  Future<void> clearAaplData() async {
    await _isar!.writeTxn(() async {
      await _isar!.aaplDatas.clear();
    });
  }

  Future<void> clearBaData() async {
    await _isar!.writeTxn(() async {
      await _isar!.baDatas.clear();
    });
  }

  Future<void> clearBacData() async {
    await _isar!.writeTxn(() async {
      await _isar!.bacDatas.clear();
    });
  }

  Future<void> clearMcdData() async {
    await _isar!.writeTxn(() async {
      await _isar!.mcdDatas.clear();
    });
  }

  Future<void> clearNvdaData() async {
    await _isar!.writeTxn(() async {
      await _isar!.nvdaDatas.clear();
    });
  }

  Future<void> clearMsftData() async {
    await _isar!.writeTxn(() async {
      await _isar!.msftDatas.clear();
    });
  }

  Future<void> clearGskData() async {
    await _isar!.writeTxn(() async {
      await _isar!.gskDatas.clear();
    });
  }

  Future<void> clearTslaData() async {
    await _isar!.writeTxn(() async {
      await _isar!.tslaDatas.clear();
    });
  }

  Future<void> clearAmznData() async {
    await _isar!.writeTxn(() async {
      await _isar!.amznDatas.clear();
    });
  }
}
