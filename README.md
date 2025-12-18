# Codelume Bundle

Codelume Bundle 是一种基于 Bundle 的资源包，主要用于存储动态壁纸相关的资源文件，不包含可执行文件。这样做的好处是：

- 避免了二进制文件导致的 AppStore 审核问题。
- 方便不同的动态壁纸存储和分发。

资源包基本目录结构如下：

```
├── wallpaper.bundle
    ├── Info.plist
    ├── Preview
       └── Preview.jpg
```

Info.plist 是资源包的元数据文件，包含了动态壁纸的基本信息。包含以下键值对：

- `name`: 壁纸名称；
- `description`: 壁纸描述；
- `author`: 壁纸作者；
- `email`: 壁纸作者邮箱；
- `type`: 壁纸类型，支持 Video、Scene2D、Scene3D；
- `category`: 壁纸分类，例如 `Nature`, `City`, `Abstract` 等；
- `tags`: 壁纸标签，用于搜索和分类；
- `createdAt`: 壁纸创建时间；
- `version`: 壁纸版本。

Preview 目录包含了动态壁纸的预览图片，文件名必须为 `Preview.jpg`，一般选取动态壁纸的第一帧作为预览图片，Codelume会将当前图片设置为系统墙纸，这样可以解决桌面全屏切换时墙纸和 Codelume 壁纸界面的衔接问题。

## Video Wallpaper Bundle

视频类动态壁纸是一种最简单的动态壁纸，它只包含一个视频文件。Codelume 会加载当前视频资源，使用硬件解码器，然后播放。这类视频资源消耗最低，不支持鼠标交互。

视频动态壁纸资源包的目录结构如下：

```
├── wallpaper.bundle
    ├── Info.plist
    ├── Preview
    │   └── Preview.jpg
    └── Video
        ├── Video.plist
        └── Wallpaper.mp4
```

在基础的目录结构上，新增了一个 `Video` 目录，用于存储视频文件和视频信息文件。其中 Video.plist 内容如下：

- `width`: 视频宽度；
- `height`: 视频高度；
- `size`: 视频大小，单位为 MB；
- `duration`: 视频时长，单位为秒；
- `format`: 视频格式，常见的有 `mp4`, `mov` 等；
- `loop`: 是否循环播放，循环播放的视频能无缝衔接，提高用户体验。

## Scene 2D Wallpaper Bundle
 todo
## Scene 3D Wallpaper Bundle
 todo