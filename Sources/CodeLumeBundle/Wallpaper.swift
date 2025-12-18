import Foundation
import AVFoundation
import AppKit

// MARK: - Wallpaper
public class Wallpaper {
    var bundleName: String?
    var bundleUrl: URL?
    var wallpaperInfo: WallpaperInfo
    
    init() {
        self.wallpaperInfo = WallpaperInfo()
    }
    
    func create(bundleName: String, saveDir: URL) -> Bool {
        self.bundleName = bundleName
        self.bundleUrl = saveDir.appendingPathComponent(bundleName + BUNDLE_EXTENSION)
        do {
            if FileManager.default.fileExists(atPath: bundleUrl!.path) {
                print("Wallpaper bundle already exists: \(self.bundleUrl!.path)")
                return false
            }
            let previewDir = bundleUrl!.appendingPathComponent(BUNDLE_PREVIEW_DIR)
            try FileManager.default.createDirectory(at: previewDir, withIntermediateDirectories: true)
        } catch {
            print("Create wallpaper bundle directory failed: \(error), url: \(self.bundleUrl!.path)")
            return false
        }
        
        return true
    }

    func open(wallpaperUrl: URL) -> Bool {
        let infoPlistURL = wallpaperUrl.appendingPathComponent(BUNDLE_INFO_PLIST)
        do {
            guard let info = WallpaperInfo.read(from: infoPlistURL) else {
                print("Read wallpaper bundle info plist failed: \(infoPlistURL.path)")
                return false
            }
            
            self.wallpaperInfo = info
            self.bundleUrl = wallpaperUrl
            self.bundleName = wallpaperUrl.lastPathComponent.deletingPathExtension
        } catch {
            print("Read wallpaper bundle info plist failed: \(error)")
            return false
        }
        return true
    }
    
    func save() -> Bool {
        guard let url = bundleUrl else {
            print("Wallpaper bundle url is nil")
            return false
        }
        
        let infoPlistURL = url.appendingPathComponent(BUNDLE_INFO_PLIST)
        do {
            try wallpaperInfo.write(to: infoPlistURL)
        } catch {
            print("Write wallpaper bundle info plist failed: \(error)")
            return false
        }
        return true
    }
}
