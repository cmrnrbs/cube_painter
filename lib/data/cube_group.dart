import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/data/assets.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/persist.dart';
import 'package:cube_painter/data/settings.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

const noWarn = out;

CubeGroupNotifier getCubeGroupNotifier(BuildContext context,
    {bool listen = false}) {
  return Provider.of<CubeGroupNotifier>(context, listen: listen);
}

const sampleCubesExtension = '.sampleCubes.json';
const userCubesExtension = '.userCubes.json';

/// The main store of the entire model.
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
class CubeGroup {
  final List<CubeInfo> _cubeInfos;

  const CubeGroup(this._cubeInfos);

  List<CubeInfo> get cubeInfos => _cubeInfos;

  CubeGroup.fromJson(Map<String, dynamic> json)
      : _cubeInfos = _listFromJson(json).toList();

  @override
  String toString() => '$_cubeInfos';

  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['cubes']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }

  Map<String, dynamic> toJson() => {'cubes': _cubeInfos};
}

/// access to the main store of the entire model
class CubeGroupNotifier extends ChangeNotifier {
  final _cubeGroups = <String, CubeGroup>{};

  late Settings _settings;

  late VoidCallback _onSuccessfulLoad;

  bool get hasCubes => _cubeGroups.isNotEmpty && cubeGroup.cubeInfos.isNotEmpty;

  String get currentFilePath => _settings.currentFilePath;

  void saveCurrentFilePath(String filePath) {
    _settings.currentFilePath = filePath;

    //TODO SAVE SETTINGS toJson
  }

  CubeGroup get cubeGroup => _cubeGroups[currentFilePath]!;

  void setCubeGroup(CubeGroup cubeGroup) {
    _cubeGroups[currentFilePath] = cubeGroup;
  }

  // Map<String,CubeGroup> get cubeGroups => _cubeGroups;
  Iterable<MapEntry> get cubeGroupEntries => _cubeGroups.entries;

  bool get canSave => currentFilePath.endsWith(userCubesExtension);

  void init({
    required VoidCallback onSuccessfulLoad,
  }) async {
    _onSuccessfulLoad = onSuccessfulLoad;

    // TODO load fromJson
    _settings = Settings.fromJson({
      'currentFilePath': '',
      'showCrops': true,
    });

    await _loadAllCubeGroups();

    // TODO load previous run's file,
    _updateAfterLoad();
  }

  void _updateAfterLoad() {
    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    if (_cubeGroups.isNotEmpty) {
      _onSuccessfulLoad();
      // TODO clear undo (make undoer a notifier and notifyListeners for button enabled.
      notifyListeners();
    }
  }

  String get json => jsonEncode(cubeGroup);

  void loadFile({required String filePath}) {
    saveCurrentFilePath(filePath);

    _updateAfterLoad();
  }

  void saveFile() async =>
      await saveString(filePath: currentFilePath, string: json);

  void saveACopyFile() async {
    await setNewFilePath();
    saveFile();
  }

  void addCubeInfo(CubeInfo info) => cubeGroup.cubeInfos.add(info);

  Future<void> setNewFilePath() async {
    final Directory appFolder = await getApplicationDocumentsDirectory();
    final String appFolderPath = '${appFolder.path}${Platform.pathSeparator}';

    final int uniqueId = DateTime.now().millisecondsSinceEpoch;
    saveCurrentFilePath('$appFolderPath$uniqueId$userCubesExtension');
  }

  Future<void> createNewFile() async {
    await setNewFilePath();

    setCubeGroup(CubeGroup(<CubeInfo>[]));
    _updateAfterLoad();
  }

  void clear() => cubeGroup.cubeInfos.clear();

  Future<void> _loadAllCubeGroups() async {
    const assetsFolder = 'samples';

    final Directory appFolder = await getApplicationDocumentsDirectory();

    // TODO do we want to do this every time, or just the first time?
    await Assets.copyAllFromTo(assetsFolder, appFolder.path,
        extensionReplacement: sampleCubesExtension);

    List<String> paths = await getAllAppFilePaths(appFolder);

    // display in reverse chronological order (most recent first)
    // this is because the file name is a number that increases with time.
    paths.sort((a, b) => b.compareTo(a));

    if (currentFilePath.isEmpty) {
      //  Most recently created is now first in list
      saveCurrentFilePath(paths[0]);
    }

    for (final String path in paths) {
      final File file = File(path);

      final map = jsonDecode(await file.readAsString());
      _cubeGroups[path] = CubeGroup.fromJson(await map);
    }
  }

  Future<List<String>> getAllAppFilePaths(Directory appFolder) async {
    final paths = <String>[];

    await for (final FileSystemEntity fileSystemEntity in appFolder.list()) {
      final String path = fileSystemEntity.path;

      if (path.endsWith(userCubesExtension) ||
          path.endsWith(sampleCubesExtension)) {
        paths.add(path);
      }
    }
    return paths;
  }
}
