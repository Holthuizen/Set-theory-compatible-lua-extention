# Lua Set Theory Implementation

Lua does not have a built-in notion of a **Set** data type. While standard tables can be adapted to behave like sets (as demonstrated in [Programming in Lua, Chapter 11.5](https://www.lua.org/pil/11.5.html)), that approach is essentially just a basic hash table wrapper.

For applications involving **Set Theory**, a more rigorous implementation is required. This project attempts to bridge that gap by creating a robust `SET` class that strictly adheres to mathematical set logic.

## Overview

The entire implementation is contained within the `SET` table in `main.lua`. It expands upon basic table functionality to support standard set operations and operators.

### Features
* **Construction:** Create sets from lists or other sets.
* **Cardinality:** Calculate the size of a set (`#A`).
* **Equality:** Check if two sets are mathematically equal (`A == B`).
* **Subsets:** Proper subset logic (`A <= B`).
* **Set Algebra:**
    * Union (`A + B`)
    * Intersection (`A * B`)

## Usage

To run the implementation and view the test results, simply run the main file:

```bash
lua main.lua
