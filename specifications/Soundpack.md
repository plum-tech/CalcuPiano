# Soundpack

Physically, a `Soundpack` consists of audio files, music sheet and metadata.

## Format

A soundpack is a normal zip.

### Structure

#### Fully-functioning

A fully-functioning soundpack must have a `sounds/` directory, including all notes.

It could have a `sheets/` directory that consists of the built-in sheet music of this soundpack.

The `icon.png`, `preview.png` are optional.

The essential file, `soundpack.json`, is the meta data.

It should be:

```
MySoundpack.zip/  # Any name you want
    sounds/
        1.wav  # Fixed name
        2.wav
        3.wav
        4.wav
        5.wav
        6.wav
        7.wav
        8.wav
        9.wav
        div.wav
        eq.wav
        minus.wav
        mul.wav
        plus.wav
    sheets/
        MySheetMusic.txt  # Any name you want
    icon.png  # Optional
    preview.png # Optional
    soundpack.json # Essential
```

- `sounds/` directory and the audio files are indispensable, and the names cannot be wrong.

- `sheets/` directory is optional. Every sheet music will be loaded and marked as `From MySoundpack`
  in the `Sheets` page. Users can also check which soundpack they come from in the `Soundpack` page.

#### Simple

A simple soundpack must have audios of each note.

The `icon.png`, `preview.png` and `soundpack.json` are optional.

It should be:

```
MySoundpack.zip/  # Any name you want
    1.wav  # Fixed name
    2.wav
    3.wav
    4.wav
    5.wav
    6.wav
    7.wav
    8.wav
    9.wav
    div.wav
    eq.wav
    minus.wav
    mul.wav
    plus.wav
    icon.png  # Optional
    preview.png # Optional
    soundpack.json  # Optional
```

### MetaData

`soundpack.json` contains the metadata of a soundpack.

It's worth noting that it's optional in a [Simple Soundpack](#Simple), so the design should take
the *placeholders* into account. Also, the authors may not fully use the metadata, for example,
omit some unnecessary properties, like `url`. Meanwhile, the internationalization support is
considerate. Therefore, the properties should have a default value and should be checked each time
it's read.

To simplify serialization, the metadata can be represented by **only one** json object instead of
cascading objects.

```json
{
  "name": "My Soundpack",
  "description": "My first soundpack of CalcuPiano.",
  "author": "Liplum",
  "url": "https://github.com/liplum/calcupiano",
  "l10n": {
    "en": {
      "name": "My Soundpack",
      "description": "My first soundpack of CalcuPiano."
    },
    "ru": {
      "name": "Мой саундпак",
      "description": "Мой первый саундпак CalcuPiano."
    },
    "zh": {
      "name": "我的声音包",
      "description": "我的第一个 CalcuPiano 音色包。"
    }
  }
}
```

## Implementation

### Hierarchy

`SoundpackProtocol` is an abstract term on the programing side, different from the real soundpack.zip file.

`SoundpackProtocol` has several implementations, such as `BuiltinSoundpack`, `LocalSoundpack`, `UrlSoundpack`.

Related concepts: [`SoundFile`](/specifications/SoundFile.md).

#### BuiltinSoundpack

- It must have an ID to be unambiguous from other soundpacks.
- It can resolve the `SoundFile` of a `Note` to `BundledSoundFile`.
- It has a name and description.
- Unmodifiable.
- Permanent.

Users cannot modify a built-in soundpack, but they can duplicate it to a `LocalSoundpack`.
`BuiltinSoundpack` cannot be deleted.

#### LocalSoundpack

**[Unavailable on CalcuPiano Web]**

- It must have an ID to be unambiguous from other soundpacks.
- It represents a real soundpack.zip file. After being unpacked, it's a folder in the local storage CalcuPiano managed.
- It can resolve the `SoundFile` of a `Note` to either `BundledSoundFile` or `LocalSoundFile`.
- Modifiable.
- Deletable.

Users can import a `LocalSoundpack` from file or export it to a soundpack.zip file.

Users can create an empty `LocalSoundpack` or duplicate one, then edit the metadata for their own one.

#### UrlSoundpack

- It must have an ID to be unambiguous from other soundpacks.
- It represents a soundpack downloaded from a URL.
- It has a MD5 hash code to validate the file and version.
- It can resolve the `SoundFile` of a `Note` to `LocalSoundFile` (or `URLSoundFile` on CalcuPiano Web).
- Unmodifiable.
- Deletable.

Users can duplicate a `UrlSoundpack` to modify it. In this way, the source soundpack will be kept.

### Storage

#### BuiltinSoundpack

There is no need to store, even though they can resolve a `BundledSoundFile`.

#### LocalSoundpack

**[Unavailable on CalcuPiano Web]**

It can resolve a `Note` to either `BundledSoundFile` or `LocalSoundFile`, so the serialization is necessary.

A `LocalSoundpack` object is serialized to json, stored in Hive with its `id`.

The `SoundFile`s, either `BundledSoundFile` or `LocalSoundFile`, it contains will also be serialized together.
Thus, the deserialization will find the right one, then it can resolve a correct audio file, in assets or file system.

Notably, to import a soundpack from URL or local file will unpack those audio files and sheets into file system.
And all files will be `LocalSoundFile`, even the files are originated from CalcuPiano's assets.

#### UrlSoundpack

It can resolve a `Note` to `LocalSoundFile` (or `UrlSoundFile` on CalcuPiano Web).

Users can import a `UrlSoundpack` from a URL.
