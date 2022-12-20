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