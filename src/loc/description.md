# Basic Expressions

Type your dice expression in the gray box at the top of this page.

The simplest expression is [`d`](#/d/d) which means roll one die with 6 faces. You can be more explicit and input [`1d6`](#/d/1d6) or  [`d6`](#/d/d6). Of course you can roll multiple dice ([`3d6`](#/d/3d6)) and with different number of sides [`2d10`](#/d/2d10). The popular [`d100`](#/d/d100) (a percent die) can also be expressed as [`d%`](#/d/d%).

# Math Operations

You can use basic mathematical operators [`3d6+4-1d4`](#/d/3d6+4-1d4). All math operations will return integer numbers: [`5d6/2`](#/d/5d6/2)

For divisions you can use `/`, `÷` or `:`. For multiplications you can use `*`, `×`, `⋅`, or `x`.

# Expression Set and Reducing

Many expressions can be provided in a set like [`(2d6,3d8,1d10+2)`](#/d/(2d6,3d8,1d10+2)). By default the result of each expression will be summed together. You can also be explicit [`(2d6,3d8,1d10+2) sum`](#/d/(2d6,3d8,1d10+2)_sum) or you can use other reducing functions like [`min`](#/d/(2d6,3d8,1d10+2)_min) (or `take least`), [`max`](#/d/(2d6,3d8,1d10+2)_max) (or `take best`), [`median`](#/d/(2d6,3d8,1d10+2)_median) or [`average`](#/d/(2d6,3d8,1d10+2)_average).

You can use an expression set to force the order of arithmetic operations: [`(3d6+2) x 2`](#/d/(3d6+2)_x_2) which is equivalent to [`(3d6,2) x 2`](#/d/(3d6,2)_x_2). Expression sets can be used as part of more complex mathematical expressions [`((3d6,9) keep 1 + 2) * 2`][1].

# Filtering

It is also possible to peform filtering operations on a set of expressions like *drop* and *keep*. Drop will only keep the values that do not match a condition: [`4d6 drop lowest 1`](#/d/4d6_drop_lowest_1). For *drop* the default matching condition is *lowest* so you can omit it: [`4d6 drop 1`](#/d/4d6_drop_1). *Keep* will retain by default the top `N` values. [`4d6 keep 3`](#/d/4d6_keep_3) is basically equivalent to the `drop 1` above. You can be explicit and state [`4d6 keep highest 3`](#/d/4d6_keep_highest_3).

Drop and keep can abbreviated:

* [`4d6d1`](#/d/4d6d1) is equivalent to [`4d6 drop lowest 1`](#/d/4d6_drop_lowest_1)
* [`4d6k3`](#/d/4d6k3) is equivalent to [`4d6 keep highest 3`](#/d/4d6_keep_highest_3)

# Dice Set

Simpler sets of dice like [`5d6`](#/d/5d6) are expanded into [`(d6,d6,d6,d6,d6)`](#/d/(d6,d6,d6,d6,d6)). On these simple sets it is possible to apply two special functions: *explode* and *reroll*.

A dice set can be composed of dice with different denominations [`(d2,d4,d6,d8,d10)`](#/d/(d2,d4,d6,d8,d10)). On the other hand a dice set can only be composed of nominal dice: [`(d6,2d8)`](#/d/(d6,2d8)) is NOT a dice set! It is still a valid expression set that can be reduced and filtered.

# Explode / Reroll

Some games require exploding rolls or rerolls. An exploding dice is rolled again whenever its highest values is obtained. Results of all rolls are then summed together. dice.run supports the following syntax for exploding rolls: [`3d6 explode always on 5 or more`](#/d/3d6_explode_always_on_5_or_more). The short syntax for that is [`3d6e5`](#/d/3d6e5). If you want to limit the number of times the dice can explode, you can use [`once`](#/d/3d6_explode_once_on_5_or_more), [`twice`](#/d/3d6_explode_twice_on_5_or_more), [`thrice`](#/d/3d6_explode_thrice_on_5_or_more) or the syntax `n times` where `n` is any positive integer number (eg: [`3d6 explode 10 times on 5 or more`](#/d/3d6_explode_10_times_on_5_or_more)). `or more` can be replaced with `or less` or omitted entirely to only explode on the exact value indicated in the expression.

Reroll works the same [`3d6 reroll always on 2 or less`](#/d/3d6_reroll_always_on_2_or_less) and the short format is [`3d6r2`](#/d/3d6r2).

  [1]: #/d/((3d6,9)_keep_1_+_2)_*_2
