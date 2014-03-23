open OUnit
open Printf

module TVar = Rvar.Make(
  struct
    type t = float
    let of_float v = v
    let to_float v = v
  end)
open TVar
open TVar

let v1 = TVar.create 200. 3.
let v2 = TVar.create 100. 1.
let ex = TVar.exactly  100.

let sum = v1 + v2
let sum' = TVar.create 300. 3.16
let sub = v1 - v2
let sub' = TVar.create 100. 3.16
let bus = v2 - v1
let bus' = TVar.create ~-.100. 3.16
let mul  = v1 * v2
let mul' = TVar.create 20000. 360.56
let div  = v1 / v2
let div' = TVar.create 2. 0.03
let vid  = v2 / v1
let vid' = TVar.create 0.5 9.01e-3

let esum = TVar.create 300. 3.
let esub = TVar.create 100. 3.
let ebus = TVar.create ~-.100. 3.
let emul = TVar.create 20000. 300.
let ediv = TVar.create 2. 0.03
let evid = TVar.create 0.5 7.5e-3



let equal = assert_equal
  ~cmp:(fun a b -> a = b)
  ~printer:(fun a -> TVar.to_string a)

let suite =
  "Rvar">::: [
    "sum" >:: (fun () -> equal sum' sum);
    "sub" >:: (fun () -> equal sub' sub);
    "bus" >:: (fun () -> equal bus' bus);
    "mul" >:: (fun () -> equal mul' mul);
    "div" >:: (fun () -> equal div' div);
    "vid" >:: (fun () -> equal vid' vid);
    "great" >:: (fun () -> "v1 > v2" @? (v1 > v2));
    "greateq" >:: (fun () -> "v1 >= v2" @? (v1 >= v2));
    "less" >:: (fun () -> "v2 < v1" @?  (v2 < v1));
    "lesseq" >:: (fun () -> "v2 < v1" @?  (v2 <= v1));
    "eq">:: (fun () -> "v1 = v1" @?  (v1 = v1));
    "not eq">:: (fun () -> "v1 <> v2" @?  (v1 <> v2));
    "ref1"  >:: (fun () -> "v1 <= v1" @?  (v1 <= v1));
    "ref2"  >:: (fun () -> "v1 >= v1" @?  (v1 >= v1));
    "esum"  >:: (fun () -> equal esum (v1 + ex));
    "esub"  >:: (fun () -> equal esub (v1 - ex));
    "ebus"  >:: (fun () -> equal ebus (ex - v1));
    "emul"  >:: (fun () -> equal emul (v1 * ex));
    "ediv"  >:: (fun () -> equal ediv (v1 / ex));
    "evid"  >:: (fun () -> equal evid (ex / v1));
    "prec"  >:: (fun () -> equal v2 (TVar.more_precise v1 v2))
  ]



















