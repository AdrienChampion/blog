## Liquidity Extensions

The first step is to declare the [liquidity extensions] we need. Let's create a [tests/techel.liq]
to write our extensions into:

```ocaml
{{#include rsc/tests/techel.liq}}
```

It is not crucial to understand these rules precisely, only the power they give us. And that power
is the following functions.

- `get_balance address`: takes an address as parameter, and returns the balance of the contract at
  that address
- `get_storage [%type: 'g] address`: takes a type and an address as parameter, and returns
    - `Some` of the storage of the contract at that address, if it has type `'g`
    - `None` otherwise
- `apply_operations ops`: takes a list of operations and applies them right away
- `start_set_source address` and `end_set_source ()`: a very, very dirty hack to define a *scope*
    where all operations created appear to have been created by whatever is at `address`
- `must_fail op`: tells techelson that the operation `op` must fail

Thanks to liquidity's file import mechanism, we can use these functions in any liquidity file
`test.liq` with `Techel.get_balance`, `Techel.get_storage` *etc.* by simply calling liquidity as
follows:

```
$ liquidity tests/techel.liq test.liq
```

So let's fill in the `test.sh` file so that it runs our tests. It takes the path to our (future)
liquidity test file(s) as argument, and compiles along with all the contracts in `contracts/` and
the extensions we just defined.

```bash
{{#include rsc/test.sh}}
```

[liquidity extensions]: http://www.liquidity-lang.org/doc/reference/liquidity.html#extended-primitives (Liquidity's extensions)

[tests/techel.liq]: listing.md#teststechelliq (Techelson extensions for liquidity)