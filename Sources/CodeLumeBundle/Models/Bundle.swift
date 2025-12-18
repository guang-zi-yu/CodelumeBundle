import Foundation
import AVFoundation

public enum WallpaperType: String, Codable {
    case video = "Video"
    case Scene2D = "Scene2D"
    case Scene3D = "Scene3D"
}

internal struct WallpaperInfo: Codable {
    var name: String?
    var description: String?
    var author: String?
    var email: String?
    var type: WallpaperType?
    var category: String?
    var tags: [String]?
    var createdAt: Date = Date()
    let version: String
    
    init() {
        self.version = VERSION
    }

    public func write(to url: URL) throws {
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(self)
        try data.write(to: url)
    }

    static public func read(from url: URL) throws -> WallpaperInfo {
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        let WallpaperInfo = try decoder.decode(WallpaperInfo.self, from: data)
        return WallpaperInfo
    }
}

internal struct VideoInfo: Codable {
    var width: Int = 0
    var height: Int = 0
    var size: Double = 0.0
    var duration: Int = 0
    var format: String = ""
    var loop: Bool = false

    init(videoURL: URL, isLoop: Bool) {
        self.format = videoURL.pathExtension
        self.loop = isLoop
        
        if !formatCheck() {
            print("Unsupported video format: \(format)")
            return
        }
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: videoURL.path)
            if let fileSize = attributes[.size] as? Int64 {
                let sizeInMB = Double(fileSize) / (1024 * 1024)
                self.size = (sizeInMB * 100).rounded() / 100
            }
        } catch {
            print("Failed to get file size: \(error)")
        }
        
        let asset = AVAsset(url: videoURL)
        
        let tracks = asset.tracks(withMediaType: .video)
        if let videoTrack = tracks.first {
            let dimensions = videoTrack.naturalSize
            self.width = Int(dimensions.width)
            self.height = Int(dimensions.height)
        }
        
        self.duration = Int(CMTimeGetSeconds(asset.duration))
    }

    public func write(to url: URL) throws {
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(self)
        try data.write(to: url)
    }

    static public func read(from url: URL) throws -> VideoInfo {
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        let videoInfo = try decoder.decode(VideoInfo.self, from: data)
        return videoInfo
    }

    private func formatCheck() -> Bool {
        return format == "mp4" || format == "mov"
    }
}

