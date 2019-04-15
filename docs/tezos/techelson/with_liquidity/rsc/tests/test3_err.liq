let nothing : operation list * unit = [], ()

(* Creates a storage for Multi with one administrator. *)
let one_admin (root : string) (address : address) : Multi.storage = {
    Multi.admins =
        Map.add root address (Map : (string, address) map) ;
    Multi.users =
        (Map : (string, (address * tez * UnitContract.instance)) map) ;
}

(* Deploys an account with an arbitrary manager. *)
let deploy_account_op (amount: tez) : operation * address =
    let delegate : key_hash option = None in
    Account.create
        ~manager:tz1YLtLqD1fWHthSVHPD116oYvsd4PTAHUoc
        ~delegate
        ~delegatable:true
        ~amount

(* Deploys an instance of multi with an arbitrary manager. *)
let deploy_contract_op (storage : Multi.storage) : operation * address =
    let delegate : key_hash option = None in
    Contract.create
        ~manager:tz1YLtLqD1fWHthSVHPD116oYvsd4PTAHUoc
        ~delegate
        ~delegatable:true
        ~spendable:false
        ~amount:0tz
        ~storage
        ~code:(contract Multi)

(* Storage of the test is irrelevant. *)
type storage = unit

(* Actual test. *)
let%entry test (_param : unit) (_storage : unit) =
    let root_op, root = deploy_account_op 0tz in
    let storage = one_admin "root" root in
    let main_op, main = deploy_contract_op storage in
    (* ask techelson to apply these operations. *)
    Techel.apply_operations [ root_op ; main_op ];
    (* root and main are live now *)

    (* let's check root is an admin, and that the address is correct *)
    let storage =
        match Techel.get_storage [%type: Multi.storage] main with
        | Some storage -> storage
        | None -> failwith "can't retrieve contract's storage"
    in
    (
        match Map.find "root" storage.Multi.admins with
        | None -> failwith "no root in storage"
        | Some address -> (
            if address <> root then (
                failwith "wrong address for root"
            )
        )
    );

    let client_op, client = deploy_account_op 15tz in
    (* deploy the client *)
    Techel.apply_operations [ client_op ];
    (* client is live now *)

    (* retrieve client instance for registration *)
    let client_instance =
        match (Contract.at client : UnitContract.instance option) with
        | None -> failwith "could not retrieve main contract"
        | Some instance -> instance
    in
    (* retrieve multi's instance to call it *)
    let main_instance =
        match Multi.at main with
        | None -> failwith "could not retrieve main contract"
        | Some instance -> instance
    in

    (* let's add a client and fail *)
    let bad_add_client =
        Contract.call ~dest:main_instance ~amount:0tz ~entry:add_client ~parameter:(
            "root", "lucy", client, client_instance
        )
    in
    let error_message = Some "illegal access to admin account" in
    let must_fail = Techel.must_fail error_message bad_add_client in
    (* let's really add a client now *)
    Techel.start_set_source root ;
    (* all operations created in here will appear to have been created by `root` *)
    let add_client =
        Contract.call ~dest:main_instance ~amount:0tz ~entry:add_client ~parameter:(
            "root", "lucy", client, client_instance
        )
    in
    Techel.end_set_source () ;

    Techel.apply_operations [ must_fail ; add_client ];

    (* lucy deposits `10tz` *)
    Techel.start_set_source client ;
        let deposit_money =
            Contract.call ~dest:main_instance ~amount:10tz ~entry:deposit ~parameter:"lucy"
        in
    Techel.end_set_source () ;
    Techel.apply_operations [ deposit_money ];
    let balance_lucy = Techel.get_balance client in
    if balance_lucy <> 5tz then (
        failwith "lucy should have 5tz now"
    );

    (* lucy walks out of the whole thing *)
    Techel.start_set_source client ;
        let drain =
            Contract.call ~dest:main_instance ~amount:0tz ~entry:drain ~parameter:"lucy"
        in
    Techel.end_set_source () ;
    Techel.apply_operations [ drain ] ;

    (* lucy should have her money back *)
    let balance_lucy = Techel.get_balance client in
    if balance_lucy <> 2tz then (
        failwith "lucy should have 2tz now"
    );

    nothing
