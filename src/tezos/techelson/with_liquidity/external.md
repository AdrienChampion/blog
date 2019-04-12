## External Contract Example

Let's give ourselves an external contract that we can write a test for. We will use
[contracts/multi.liq]. It's whole code is available in the [listing], but for writing a test
we only need a high-level understanding of what it does.

`Multi`, in [contracts/multi.liq], offers its clients to store tokens for them. It has some
administrators, which are the only one able to add new clients. First, the contract's storage is

```ocaml
{{#include rsc/contracts/multi.liq:1:4:}}
```

`Multi` stores some named administrators in a map `admins` from names to administrator addresses.
It also stores some named clients in a map `clients`. It maps the name of a client to
- its address
- the amount of money it has stored on this contract
- an account which will receive all the money the client has if the client asks to drains it.

### Entry Points

The entry points of `Multi` we are interested in are

```ocaml
{{#include rsc/contracts/multi.liq:33:36:}}
    ...
```

Adds a new user. Only administrators can do this.

```ocaml
{{#include rsc/contracts/multi.liq:71:71:}}
    ...
```

Transfers all the money of a user to the account provided on creation. Only the client can call
this entry point (with the right name).

### Testing Multi (and failing to do so)

Let's first write a test which creates an instance of `Multi` with an admin named `root`. It then adds a new administrator:

```ocaml
{{#include rsc/tests/test1_err.liq}}
```

Let's run this test. It will fail though, as it should. So we will call it [tests/test1_err.liq].
The relevant part of the output is

```
{{#include rsc/output/test1_err.output:1:1:}}
[....]
{{#include rsc/output/test1_err.output:60:64:}}
```

The reason this test failed is because only administrator can add clients. So here, only `root` can
add a new client. Hence, we need to pretend to be `root`. More precisely, we need to pretend to be
root when we create the operation.

But this test is not worthless. It shows that an outsider cannot add new clients even by using the
name of an existing outsider. What we should do is say that this transfer must fail. This is what
[tests/test1.liq] does. Only the `apply_operations` changes:

```ocaml
{{#include rsc/tests/test1.liq:84:85:}}
```

### Testing Multi

Let's now make the transfer work by pretending to be `root`. The current solution for this is not
very satisfactory, but it will do the job until techelson is more tightly integrated in Liquidity.
The result is [tests/test2.liq], where we add:

```ocaml
{{#include rsc/tests/test2.liq:79:85:}}
```

The test is now successful:

```
{{#include rsc/output/test2.output}}
```

Finally, let's add more tests. We will have the client (`"lucy"`) deposit `10tz` on her account,
which should leave her with `5tz` (remember she was created with `15tz`). She will then drain her
account, which will trigger Multi to send her all of her money, at which point she should have
`15tz`.

The additional code, in [tests/test3.liq], is

```ocaml
{{#include rsc/tests/test3.liq:97:121:}}
```

which is successful:

```
{{#include rsc/output/test3.output}}
```

Last, let's again make sure we're actually testing something by checking that, at the end, lucy's
balance is `2tz` (it's not) in [tests/test3_err.liq]:

```ocaml
{{#include rsc/tests/test3_err.liq:117:121:}}
```

This fails:

```
{{#include rsc/output/test3_err.output}}
```

[listing]: listing.md (File Listing)
[contracts/multi.liq]: listing.md#contractsmultiliq (Multi contract file)
[tests/test1_err.liq]: listing.md#teststest1_errliq (Test1_err test file)
[tests/test1.liq]: listing.md#teststest1liq (Test1 test file)
[tests/test2.liq]: listing.md#teststest2liq (Test2 test file)
[tests/test3.liq]: listing.md#teststest3liq (Test3 test file)
[tests/test3_err.liq]: listing.md#teststest3_errliq (Test3_err test file)