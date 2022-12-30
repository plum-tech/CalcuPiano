# Sheet Music

To be simplified, the text below, *Ode to Joy*, is an example of a human-readable sheet music that's easy to handwrite.

```
33455432 1123322 33455432 1123211
```

## Proposal
1. Easy to use. A well-illustrated UI.
2. Powerful. Full control of playing.
3. High compatibility. Support from simple to complex.

## Format

A complex sheet music could contain many components, including `inline attributes` and so on.

### Version

Version is 

### Inline Attributes
Inline attributes are the metadata of a sheet music, including `name`, `author` etc.

They should be inserted at head and starts with two hash signs, `##`.
```
## name: Ode to Joy
## author: Beethoven
33455432 1123322 33455432 1123211
```

### Break
A `space` or a `0` stands for a short break.
So the equivalent of *Ode to Joy* example mentioned before is:
```
334554320112332203345543201123211
```
But, to be more clear, `space` is recommended.

### Binding
*[planned]*

Binding can share some user-independent variables.
A binding starts with `@`.
```
@s1 = soundpack:1
```

### State Notation
*[planned]*

The soundpack, volume, pitch, etc. can be changed when a sheet music is being played.
`State Notation` is a set of how to change those states in an assembly-like way.

It's between two vertical bars, e.g.: `|s@s1|`, `|v85|`.

- `s`: Change soundpack
- `v`: Change volume.


## Implementation

The whole sheet will be converted to a node queue in an interpreter and a cursor.

### Lexer
*[planned]*

*Lexer is used to split tokens for binding and state notation support.*

### Parser

*Currently, only parsing is needed.*


### Playing
An interpreter will be used to play music.