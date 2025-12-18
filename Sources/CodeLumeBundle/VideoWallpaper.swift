import Foundation
import AVFoundation
import AppKit

// MARK: - VideoWallpaper
public class VideoWallpaper: Wallpaper {
    var videoInfo: VideoInfo?
    var videoUrl: URL?
    
    override init() {
        super.init()
        self.wallpaperInfo.type = .video
    }
    
    override func create(bundleName name: String, saveDir url: URL) -> Bool {
        if !super.create(bundleName: name, saveDir: url) {
            return false
        }
        
        let videoDir = bundleUrl!.appendingPathComponent(BUNDLE_VIDEO_DIR)
        do {
            try FileManager.default.createDirectory(at: videoDir, withIntermediateDirectories: true)
        } catch {
            print("Create video directory failed: \(error)")
            return false
        }
        
        return true
    }

    override func open(wallpaperUrl: URL) -> Bool {
        if !super.open(wallpaperUrl: wallpaperUrl) {
            return false
        }
        
        let videoPlistURL = wallpaperUrl.appendingPathComponent(BUNDLE_VIDEO_DIR + BUNDLE_VIDEO_PLIST)
        do {
            guard let info = VideoInfo.read(from: videoPlistURL) else {
                print("Read video bundle info plist failed: \(videoPlistURL.path)")
                return false
            }
            
            self.videoInfo = info
            self.videoUrl = wallpaperUrl.appendingPathComponent(BUNDLE_VIDEO_DIR + BUNDLE_WALLPAPER).appendingPathExtension(self.videoInfo!.format)
        } catch {
            print("Read video bundle info plist failed: \(error)")
            return false
        }
        
        return true
    }
    
    override func save() -> Bool {
        if !super.save() {
            return false
        }
        
        guard let videoInfo = videoInfo else {
            print("Video info is nil")
            return false
        }
        
        if !saveVideoPreview() {
            return false
        }
        
        let videoUrl = bundleUrl!.appendingPathComponent(BUNDLE_VIDEO_DIR + BUNDLE_WALLPAPER).appendingPathExtension(self.videoUrl!.pathExtension)
        let videoPlistUrl = bundleUrl!.appendingPathComponent(BUNDLE_VIDEO_DIR + BUNDLE_VIDEO_PLIST)
        do {
            if self.videoUrl != videoUrl {
                try FileManager.default.copyItem(at: self.videoUrl!, to: videoUrl)
            }
            try videoInfo.write(to: videoPlistUrl)
        } catch {
            print("Save video failed: \(error)")
            return false
        }
        
        return true
    }
    
    
    func addVideo(videoUrl: URL, isLoop: Bool = false) -> Bool {
        videoInfo = VideoInfo(videoURL: videoUrl, isLoop: isLoop)
        self.videoUrl = videoUrl
        return true
    }
    
    private func saveVideoPreview() -> Bool {
        let asset = AVAsset(url: videoUrl!)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try imageGenerator.copyCGImage(
                at: CMTime(seconds: 0, preferredTimescale: 60), actualTime: nil)
            let image = NSImage(
                cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
            
            guard let imageData = image.tiffRepresentation,
                  let bitmapImage = NSBitmapImageRep(data: imageData),
                  let jpegData = bitmapImage.representation(using: .jpeg, properties: [:]) else {
                print("Failed to generate jpeg data.")
                return false
            }
            let previewUrl = bundleUrl!.appendingPathComponent(BUNDLE_PREVIEW_DIR + BUNDLE_PREVIEW_JPEG)
            try jpegData.write(to: previewUrl)
            
        } catch {
            print("Failed save video preview: \(error).")
            return false
        }
        return true
    }
}
