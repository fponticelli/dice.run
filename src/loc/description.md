# Basic Expressions

Type your dice expression in the gray box at the top of this page.

The simplest expression is [`d`](#/d/d) which means roll one die with 6 faces. You can be more explicit and input [`1d6`](#/d/1d6) or  [`d6`](#/d/d6). Of course you can run multiple dice ([`3d6`](#/d/3d6)) and with different number of sides [`2d10`](#/d/2d10). The popular [`d100`](#/d/d100) (a percent die) can also be expressed as [`d%`](#/d/d%).

# Math Operations

You can use basic mathematical operators [`3d6+4-1d4`](#/d/3d6+4-1d4). All math operations will return integer numbers: [`5d6/2`](#/d/5d6/2)

# Expression Set and Reducing

Many expressions can be provided in a set like [`(2d6,3d8,1d10+2)`](#/d/(2d6,3d8,1d10+2)). By default the result of each expression will be summed together. You can also be explicit [`(2d6,3d8,1d10+2) sum`](#/d/(2d6,3d8,1d10+2)sum) or you can use other reducing function like [`min`](#/d/(2d6,3d8,1d10+2)min), [`max`](#/d/(2d6,3d8,1d10+2)max) or [`average`](#/d/(2d6,3d8,1d10+2)average).

You can use expression set to force the order of arithmetic operations: [`(3d6+2)*2`](#/d/(3d6+2)*2) which is equivalent to [`(3d6,2)*2`](#/d/(3d6,2)*2). Reduced sets can be used as part of more complex mathematical expressions [`(3d6,9) keep 1 * 2`](#/d/(3d6,9)_keep_1_*_2).

# Filtering

It is also possible to peform filtering operations on a set of expressions like *drop* and *keep*. Drop will only keep the values that do not match a condition: [`4d6 drop lowest 1`](#/d/4d6_drop_lowest_1). For *drop* the default matching condition is *lowest* so you can ommit it: [`4d6 drop 1`](#/d/4d6_drop_1). *Keep* will retain by default the top `N` values. [`4d6 keep 3`](#/d/4d6_keep_3) is basically equivalend to the `drop 1` above. You can be explicit and state [`4d6 keep highest 3`](#/d/4d6_keep_highest_3).

# Dice Set

Simpler sets of dice like [`5d6`](#/d/5d6) are expanded into [`(d6,d6,d6,d6,d6)`](#/d/(d6,d6,d6,d6,d6)). On these simple sets it is possible to apply two special functions: *explode* and *reroll*.

A dice set can be composed of dice with different denominations [`(d2,d4,d6,d8,d10)`](#/d/(d2,d4,d6,d8,d10)). On the other hand a dice set can only be composed of nominal dice: [`(d6,2d8)`](#/d/(d6,2d8)) is NOT a dice set! It is still a valid expression set that can be reduced and filtered.

# Explode / Reroll

TODO

  * dice set
  * explode/reroll
  * dice font
  * dice roller
  * dice link template: [``](#/d/)
