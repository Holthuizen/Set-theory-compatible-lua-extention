# Lua Set Theory Implementation

Lua doesn't really have a notion of a Set, but like everything in Lua, a basic table can be extended to act like one.

Programming in Lua (first edition) suggest a set implementation as a hasmap [here](https://www.lua.org/pil/11.5.html). 

Obviously for Set Theory you want a more rigorous implementation, so this is my attempt at creating something like that.

## Overview

The implementation is all done via the `SET` table in `main.lua`. It expands the table to handle actual set logic.

### Features
* **Construction:** Create sets from lists or other sets.
* **Cardinality:** Get the size (`#A`).
* **Equality:** Checks if sets are actually equal (`A == B`).
* **Subsets:** Standard subset logic (`A <= B`).
* **Set Algebra:** Union (`+`) and Intersection (`*`).

* ### wip
* a notion of a "Universe" U to allow for set-compliments.

## Usage

To run it and see the tests, just run the main file:

```bash
lua main.lua

