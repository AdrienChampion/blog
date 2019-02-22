## Basic Example

Our test is going to be a contract with a `unit` (empty) storage. Its (only) entry point will take
a parameter of type `unit` and inside that entry point will be our test. Entry points must return a
list of operation and the new value of the storage. It is not relevant for the test: it will just
run and perform tests. Let's have a `nothing` helper which is the pair of the empty list of
operations and `unit`.

So the simplest test `tests/empty.liq` we can write is:

```ocaml
{{#include rsc/tests/empty.liq}}
```

Which we can compile, and run with the `test.sh` script from the previous section.

```
{{#include rsc/output/empty.output}}
```

That was boring. Let's write something slightly more interesting. This new test `tests/basic.liq`
will
- create an account with `13` tez,
- check that its balance after deployment is `13` tez,
- make a transfer of `29` tez,
- check that the new balance is `42` tez.

```ocaml
{{#include rsc/tests/basic.liq}}
```

and run it

```
{{#include rsc/output/basic.output}}
```

Let's make sure we are actually testing something. Let's change the final check of
`tests/basic.liq` to

```ocaml
{{#include rsc/tests/basic_err.liq:32:35:}}
```

in `tests/basic_err.liq`. The test fails indeed:

```
{{#include rsc/output/basic_err.output}}
```