# golTUI

A Game of Life TUI written in Zig.

## Requirements

- Zig `0.16.0-dev`

## Build & Run

```golTUI/README.md#L1-1
zig build run
```

## Controls

| Key | Action |
|-----|--------|
| `q` | Quit |

## Rules

The classic Conway's Game of Life rules:

1. A live cell with fewer than 2 live neighbours dies
2. A live cell with 2 or 3 live neighbours lives
3. A live cell with more than 3 live neighbours dies
4. A dead cell with exactly 3 live neighbours becomes alive