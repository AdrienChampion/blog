# Using Techelson With Liquidity

[Techelson] is a Test Execution Engine for [Michelson] smart contracts developed by myself at
[OCamlPro]. With the (upcoming) release of [techelson], here is a relatively simple setup to
combine it with [liquidity] locally, command-line style. Very little knowledge about techelson
is required. This post only assumes some familiarity with liquidity.

Liquidity has a nice feature allowing to [declare extensions to the language]. Turns out they are
powerful enough to generate techelson's special instructions: you can write your tests directly in
liquidity, and have a few lines of `bash` run the tests for you.

First, make sure you have liquidity and techelson in your path. I'll assume they are called
`liquidity` and `techelson`. Let's structure things a bit and have the working directory look like
this:

```
.
├── test.sh
├── contracts
│   └── "contracts go here"
└── tests
    └── "tests go here"
```

The first step is to teach liquidity to generate techelson special instruction and setup a tiny
test script in [Liquidity Extensions](#liquidity-extensions). Then test our setup on a [Basic
Example](#basic-example). After I will show how to write a test for an external, non-trivial
contract in [External Contract Example](#external-contract-example), using more advanced techelson
commands. (The full code for this example is available [below this post](#full-example)). Finally,
there's [The End](#the-end) at the end.

{{#include extensions.md}}

{{#include basic.md}}

{{#include external.md}}

## The End

That's it. I believe this is enough to get some liquidity enthusiasts interested in techelson and
its future integration in the liquidity ecosystem. The process will be much more streamlined soon and will most likely remove the need for defining liquidity extensions.

## Full Example

File `contracts/multi.liq`:

```ocaml
{{#include rsc/contracts/multi.liq}}
```

[Techelson]: https://github.com/OCamlPro/techelson (Techelson's github repository)
[Michelson]: https://tezos.gitlab.io/master/whitedoc/michelson.html (Michelson's documentation)
[liquidity]: http://www.liquidity-lang.org/ (Liquidity's official page)
[OCamlPro]: https://www.ocamlpro.com/ (OCamlPro's official page)
[declare extensions to the language]: http://www.liquidity-lang.org/doc/reference/liquidity.html#extended-primitives (Liquidity's extensions)
[liquidity extensions]: http://www.liquidity-lang.org/doc/reference/liquidity.html#extended-primitives (Liquidity's extensions)
