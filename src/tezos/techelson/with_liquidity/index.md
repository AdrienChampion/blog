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
test script in [Liquidity Extensions]. Then test our setup on a [Basic Example]. After I will show
how to write a test for an external, non-trivial contract in [External Contract Example], using
more advanced techelson commands. Finally, there's [The End] at the end.

There is a listing of all the files used in this post in the [File Listing] section. Also, they are
available [here][demo dir].

[Techelson]: https://github.com/OCamlPro/techelson (Techelson's github repository)
[Michelson]: https://tezos.gitlab.io/master/whitedoc/michelson.html (Michelson's documentation)
[liquidity]: http://www.liquidity-lang.org/ (Liquidity's official page)
[OCamlPro]: https://www.ocamlpro.com/ (OCamlPro's official page)
[declare extensions to the language]: http://www.liquidity-lang.org/doc/reference/liquidity.html#extended-primitives (Liquidity's extensions)
[demo dir]: https://github.com/AdrienChampion/AdrienChampion.github.io/tree/master/blog/tezos/techelson/with_liquidity/rsc (All files used in this post)

[Liquidity Extensions]: extensions.md (Liquidity extension section)
[Basic Example]: basic.md (Basic example section)
[External Contract Example]: external.md (External contract example section)
[The End]: end.md (The end section)
[File Listing]: listing.md (File Listing section)
