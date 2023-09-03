//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import device_info_plus
import fc_native_video_thumbnail
import package_info_plus
import path_provider_foundation
import photo_manager
import sqflite
import wakelock_plus

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  FcNativeVideoThumbnailPlugin.register(with: registry.registrar(forPlugin: "FcNativeVideoThumbnailPlugin"))
  FLTPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FLTPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  PhotoManagerPlugin.register(with: registry.registrar(forPlugin: "PhotoManagerPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  WakelockPlusMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockPlusMacosPlugin"))
}
