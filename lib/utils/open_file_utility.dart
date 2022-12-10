import 'package:open_file/open_file.dart';

abstract class OpenFileUtility {
  static Future<void> open(String path) async {
    try {
      final result = await OpenFile.open(path);

      switch (result.type) {
        case ResultType.fileNotFound:
          throw 'File not found!';
        case ResultType.permissionDenied:
          throw 'You do not have permission to access this file';
        case ResultType.noAppToOpen:
          throw 'There are no app available that can open this file';
        case ResultType.error:
          throw result.message;
        case ResultType.done:
          return;
      }
    } catch (e) {
      throw 'Something went wrong!';
    }
  }
}
