# Soundpack

## Essential

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