# Basic Expressions

Type your dice expressions in the box.

The simplest expression is [`d`][1] which means roll one die with 6 faces. You can be more explicit and input [`1d6`](#/d/1d6) or  [`d6`][2]. Of course you can run multiple dice ([`3d6`][3]) and with different number of sides [`2d10`][4]. The popular [`d100`][5] (a percent die) can also be expressed as [`d%`][6].

# Math Operations

You can use basic mathematical operators [`3d6+4-1d4`][7]. All math operations will return integer numbers: [`5d6/2`][8]

# Expression Set and Reducing

Many expressions can be provided in a set like [`(2d6,3d8,1d10+2)`][9]. By default the result of each expression will be summed together. You can also be explicit [`(2d6,3d8,1d10+2) sum`][10] or you can use other reducing function like [`min`][11], [`max`][12], [`average`][13] or [`median`][14].

You can use expression set to force the order of arithmetic operations: [`(3d6+2)*2`][15] which is equivalent to [`(3d6,2)*2`][16]. Reduced sets can be used as part of more complex mathematical expressions [`(3d6,9) keep 1 * 2`][17].

# Filtering

It is also possible to peform filtering operations on a set of expressions like *drop* and *keep*. Drop will only keep the values that do not match a condition: [`4d6 drop lowest 1`][18]. For *drop* the default matching condition is *lowest* so you can ommit it: [`4d6 drop 1`][19]. *Keep* will retain by default the top `N` values. [`4d6 keep 3`][20] is basically equivalend to the `drop 1` above. You can be explicit and state [`4d6 keep highest 3`][21].

# Dice Set

Simpler sets of dice like [`5d6`][22] are expanded into [`(d6,d6,d6,d6,d6)`][23]. On these simple sets it is possible to apply two special functions: *explode* and *reroll*.

A dice set can be composed of dice with different denominations [`(d2,d4,d6,d8,d10)`][24]. On the other hand a dice set can only be composed of nominal dice: [`(d6,2d8)`][25] is NOT a dice set! It is still a valid expression set that can be reduced and filtered.

# Explode / Reroll

TODO

  * dice set
  * explode/reroll
  * dice font
  * dice roller
  * dice link template: [``](#/d/)

  [1]: #/d/d
  [2]: #/d/d6
  [3]: #/d/3d6
  [4]: #/d/2d10
  [5]: #/d/d100
  [6]: #/d/d%
  [7]: #/d/3d6+4-1d4
  [8]: #/d/5d6/2
  [9]: #/d/(2d6,3d8,1d10+2)_
  [10]: #/d/(2d6,3d8,1d10+2)_sum
  [11]: #/d/(2d6,3d8,1d10+2)_min
  [12]: #/d/(2d6,3d8,1d10+2)_max
  [13]: #/d/(2d6,3d8,1d10+2)_average
  [14]: #/d/(2d6,3d8,1d10+2)_median
  [15]: #/d/(3d6+2)*2
  [16]: #/d/(3d6,2)*2
  [17]: #/d/(3d6,9)_keep_1_*_2
  [18]: #/d/4d6_drop_lowest_1
  [19]: #/d/4d6_drop_1
  [20]: #/d/4d6_keep_3
  [21]: #/d/4d6_keep_highest_3
  [22]: #/d/5d6
  [23]: #/d/(d6,d6,d6,d6,d6)_
  [24]: #/d/(d2,d4,d6,d8,d10)_
  [25]: #/d/(d6,2d8)_
