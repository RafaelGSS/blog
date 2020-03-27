---
title: Vim Tips
date: 2020-01-29 22:14
tags: vim,tips
---

# Vim Tips

This post is a aggregate of tips that I learned on VIM

## The ideal world of VIM

The ideal is **one** keystroke to move and **one** keystroke to execute.

VIM are optimized to repetition with dot `.` keystroke, so much of the commands that we are used to doing in other text editors
is not optimized for repetition.

Example - Deletion a word

- `dw` - needs set the cursor at start of word
- `db` - needs set the cursor at end of word and use `x` to last character
- `daw` - delete the word and the space. **able use dot**

## Dont count if you can repeat

Following the tip above, in some cases repeat the `dot` command is more fast that count

## Combine and Conquer

`g`, `z`, `ctrl-w`, `[]` are __Operators Pending mode__  in most cases the first keystroke merely acts as a prefix for the second
use one of these keytrokes more 2 times acts at current line

## Set caps lock Off

It's serious, just make it at system keyboard settings. :)

## Visual Selection

- `gv` is useful little shortcut. It reselects the range of text that was last selected in Visual Mode.
- `o` in selection mode can be util to free hand selection
- `vit` select the contents inside a tag
- `U` acts in selected content transform it to UPPERCASE

In selection a text and after go to `Ex mode` set something like it at ex command:
`:'<,'>normal .` can be read like: "For each line in the visual selection, execute the Normal mode `.` command."

e.g:
```sh
var foo = 1
var bar = 2
```

`A;` add the semicolon at end of line, so we can run:

- `:'<,'>normal A;` to add semicolon at endline of selected
- `:%normal A;` to add semicolon at endline of entire file

## Usefull tips


- `q:` show the command-line window `:help cmdwin`
- `%`: is a shorthand to current file
- `<ctrl-w> o`: keep only the active window, closing all others
- `dt.`: text object to delete at next `.` char
- `i or a`: text object explanation: with `i` select **inside** the delimiter and `a` select **around** the delimiter
- `"/`: Last search pattern


## Marks

- `"` Position before the last jump within current file
- `'.` Location of last change
- `'^` Location of last insertion
- `'[` Start of last change or yank
- `']` End of last change or yank
- `'<` Start of last visual selection
- `'>` End of last visual selection
- `m{letter}` create a mark
- ``{letter}` use a mark. ``

## Register

**Black hole register = _**

so for delete without copy you can `_d{motion}` to performs a true deletion

**All the yanked text are inserted to unnamed register (default) and "0 register** you can use: `0P` to paste value inside
0 register.

