import Testing
import Foundation
@testable import CodelumeBundle

struct CodelumeBundleTests {
    
    @Test func testWallpaper() async throws {
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let testDirectory = desktopURL.appendingPathComponent("codelume")
        try FileManager.default.createDirectory(at: testDirectory, withIntermediateDirectories: true)
        
        let name = "wallpaper"
        let wallpaper = Wallpaper()
        
        var result = wallpaper.create(bundleName: name, saveDir: testDirectory)
        #expect(result == true)
        
        result = wallpaper.save()
        #expect(result == true)
    }
    
    @Test func testVideoWallpaper() async throws {
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let testDirectory = desktopURL.appendingPathComponent("codelume")
        try FileManager.default.createDirectory(at: testDirectory, withIntermediateDirectories: true)
        
        let name = "video_wallpaper"
        let wallpaper = VideoWallpaper()
        
        var result = wallpaper.create(bundleName: name, saveDir: testDirectory)
        #expect(result == true)
        
        let videoURL = URL(fileURLWithPath: "/Users/guangziyu/data/CodelumeBundle/Resource/wallpaper.mp4")
        _ = wallpaper.addVideo(videoUrl: videoURL)
        
        result = wallpaper.save()
        #expect(result == true)
    }
}
