import 'package:archive_your_bill/widgets/image_selector.dart';
import 'package:get_it/get_it.dart';
import './services/cloud_storage_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => ImageSelector());
}
