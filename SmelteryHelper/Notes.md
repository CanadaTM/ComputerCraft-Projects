# Notes that I need to keep about this project for future refference

## Brainstorming

- [ ] More cleverly determine the size of the bars created by `fill_gui_tanks()`
  - round the fluid value (which should be a value representing the percentage that that fluid takes up from the total capacity) to the nearest step of the character height of the tank.

I don't want this to allow for overfilling of the gui so I think the prefference should be to round down.
