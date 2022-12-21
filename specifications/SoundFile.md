# SoundFile
A `SoundFile` object represents an audio file, in file system or assets.

## Format
A `SoundFile` is just an audio file which native MediaPlayer supports.
Note: CalcuPiano used [audioplayers package](https://pub.dev/packages/audioplayers) to play sound.

It could be in `wav`, `mp3` or either supported audio format. 

## Implementation

### Hierarchy

`SoundFileProtocol` is an abstract term on the programing side, different from the real audio file.

`SoundpackProtocol` has three implementations, `BundledSoundFile`, `LocalSoundFile` and `UrlSoundFile`.

#### BundledSoundFile

It represents an audio file in the flutter app assets.

- It has a path related to `assets/` folder.

#### LocalSoundFile

It represents an audio file in the file system.

- It has a path related to the local storage CalcuPiano managed.

Because the files are under control of CalcuPiano,
any external `LocalSoundFile` will be copied.

#### UrlSoundFile

It represents an audio file from a URL.

- It has a URL.

It's only used in CalcuPiano Web.