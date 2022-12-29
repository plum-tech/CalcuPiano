# Sheet Music

To be simplified, the text below, *Ode to Joy*, is an example of a human-readable sheet music that's easy to handwrite.

```
33455432 1123322 33455432 1123211
```

## Format

A complex sheet music could contain many components, including `inline attributes` and so on.

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
