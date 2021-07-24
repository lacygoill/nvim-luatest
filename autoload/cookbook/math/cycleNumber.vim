vim9script

import Popup_notification from 'lg/popup.vim'

def cookbook#math#cycleNumber#main(fwd = true) #{{{1
    var start: number = 11
    var end: number = 15

    var n: number = start
    for _ in range(10)
        echon n
        echon ' '
        # How to make a number `n` cycle through `[a, a+1, ..., a+p]`?{{{
        #                                                ^
        #                                                `n` will always be somewhere in the middle
        #
        # Let's solve the issue for `a = 0`; i.e. let's make `n` cycle from 0 up to `p`.
        #
        # Special Case Solution:
        #
        #     ┌ new value of `n`
        #     │     ┌ old value of `n`
        #     │     │
        #     n2 = (n1 + 1) % (p + 1)
        #           ├────┘  ├───────┘
        #           │       └ but don't go above `p`
        #           │         read this as:  “p+1 is off-limit”
        #           │
        #           └ increment
        #
        # To use this solution, we need to find a link between the problem we've
        # just solved and our original problem.
        # In the latter, what cycles between 0 and `p`?: the distance between `a` and `n`.
        #
        # General Solution:
        #
        #     ┌ old distance between `n` and `a`
        #     │     ┌ new distance
        #     │     │
        #     d2 = (d1 + 1) % (p + 1)
        #
        #     ⇔ d2 = (d1 + 1) % (p + 1)
        #     ⇔ n2 - a = (n1 - a + 1) % (p + 1)
        #
        #            ┌ final formula
        #            ├────────────────────────┐
        #     ⇔ n2 = (n1 - a + 1) % (p + 1) + a
        #             ├────────┘  ├───────┘ ├─┘
        #             │           │         └ we want the distance from 0, not from `a`; so add `a`
        #             │           └ but don't go too far
        #             └ move away (+ 1) from `a` (n1 - a)
        #}}}
        n = (n - start + 1) % (start - end - 1) + start
    endfor

    echon '| '
    n = end
    for _ in range(10)
        echon n
        echon ' '
        # How to make a number cycle through `[a+p, a+p-1, ..., a]`?{{{
        #
        # We want to cycle from `a + p` down to `a`.
        #
        # Let's use the formula `(d + 1) % (p + 1)` to update the *distance* between `n` and `a+p`:
        #
        #               d2 = (d1 + 1) % (p + 1)
        #     ⇔ a + p - n2 = (a + p - n1 + 1) % (p + 1)
        #
        #            ┌ final formula
        #            ├────────────────────────────────┐
        #     ⇔ n2 = a + p - (a + p - n1 + 1) % (p + 1)
        #            ├───┘    ├────────────┘  ├───────┘
        #            │        │               └ but don't go too far
        #            │        │
        #            │        └ move away (+ 1) from `a + p` (a + p - n1)
        #            │
        #            └ we want the distance from 0, not from `a + p`, so add `a + p`
        #}}}
        n = end - (end - n + 1) % (start - end - 1)
    endfor

    var msg: list<string> =<< trim END
        Let's make a number cycle between 2 arbitrary values.
        For example, between %a and %b; then between %b and %a.
    END
    msg->map((_, v: string) => v->substitute('%a', start, 'g'))
    msg->map((_, v: string) => v->substitute('%b', end, 'g'))
    Popup_notification(msg, {time: 5'000})
enddef
