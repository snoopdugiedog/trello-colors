# Trello Colors

We use labels extensively, but those little lines are hard to distinguish.
This project is to put background gradients behind the trello card that denote the labels.

You can modify the script as you wish, especially of note are the first few lines
which are for changing the colors around. The bottom of the file contains some additional css
to be applied across the board.

You can then either add the css to your user styles in chrome, or using stylish in firefox.

## Defaults

I threw in a couple default css files, in case you don't want to go through the trouble of
running the ruby code. The seem to work pretty well, but the dark background could probably
use some work, perhaps a different font or font weight or something.

You can update these files with your own modifications by running `ruby trello-colors.rb all`
