## Liquidity Extensions

The first step is to declare the [Liquidity extensions] we need. Let's create a [tests/techel.liq]
to write our extensions into:

```ocaml
{{#include rsc/tests/techel.liq:1:18:}}
```

It is not crucial to understand these rules precisely, only the power they give us. And that power
is the following functions. What they do precisely will become clear when we use them later on.

- `get_balance address`: takes an address as parameter, and returns the balance of the contract at
  that address
- `get_storage [%type: 'g] address`: takes a type and an address as parameter, and returns
    - `Some` of the storage of the contract at that address, if it has type `'g`
    - `None` otherwise
- `apply_operations ops`: takes a list of operations and applies them right away
- `start_set_source address` and `end_set_source ()`: a very, very dirty hack to define a *scope*
    where all operations created appear to have been created by whatever is at `address`
- `must_fail msg_opt op`: tells techelson that the operation `op` must fail; this succeeds iff `op`
    fails and
    - `msg_opt` is `None`, or
    - `msg_opt` is `Some msg` and `op` failed **precisely** with string `msg`.

Thanks to Liquidity's file import mechanism, we can use these functions in any Liquidity file
`test.liq` with `Techel.get_balance`, `Techel.get_storage` *etc.* by simply calling Liquidity as
follows:

```
$ liquidity tests/techel.liq test.liq
```

> **NB**: you only need to write `tests/techel.liq` once, and make sure you pass it to Liquidity
> when compiling your testcases, as in `test.sh` below.

So let's fill in the `test.sh` file so that it runs our tests. It takes the path to our (future)
Liquidity test file(s) as argument, and compiles it/them along with all the contracts in
`contracts/` and the extensions we just defined. So, given some file `tests/test.liq`, the script
- generates `tests/test.liq.techel`: contains the testcase and the contract(s) to test, and
- runs techelson on `tests/test.liq.techel`.

```bash
{{#include rsc/test.sh}}
```

> **Warning**: function `start_set_source` uses a dirty hack so that it works as a Liquidity
> extension (similar to a SQL injection). This is a temporary solution, eventually this hack will
> not be necessary.

[Liquidity extensions]: http://www.liquidity-lang.org/doc/reference/liquidity.html#extended-primitives (Liquidity's extensions)

[tests/techel.liq]: listing.md#teststechelliq (Techelson extensions for liquidity)