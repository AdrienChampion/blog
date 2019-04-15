[@@effect]
external get_balance :
    [%stack: address] -> [%stack: tez]
    = "GET_BALANCE"
[@@effect]
external get_storage :
    [%type: 'a] -> [%stack: address] -> [%stack: 'a option]
    = "GET_STORAGE"
[@@effect]
external apply_operations :
    [%stack: operation list] -> unit
    = "APPLY_OPERATIONS"
[@@effect]
external start_set_source :
    [%stack: address] -> unit
    = "SET_SOURCE { #"
[@@effect]
external end_set_source :
    unit -> unit
    = "}"
[@@effect]
external must_fail :
    [%stack: operation] -> [%stack: operation]
    = "{ NONE string ; MUST_FAIL string }"
[@@effect]
external print_stack :
    unit -> unit
    = "PRINT_STACK"
[@@effect]
external step :
    unit -> unit
    = "STEP"

let do_with_source (a : address) (stuff : unit -> 'a) : 'a =
    start_set_source a;
    let res = stuff () in
    end_set_source ();
    res
