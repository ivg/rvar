
module Make(S:
  sig
    type t
    val of_float: float -> t
    val to_float: t -> float
  end
) = struct
  type s = S.t
  type t = float * float

  open S

  let create m s = to_float m, to_float s
  let exactly m = to_float m, 0.
  let change m (_,s) = to_float m, s
  let with_std s (m,_) = m,to_float s
  let mean (m,_) = of_float m
  let std (_,s)  = of_float s
  let float_of_mean = fst
  let float_of_std  = snd
  let more_precise (a,a') (b,b') = if a' < b' then (a,a') else (b,b')
  let to_pair (m,s)  = of_float m, of_float s
  let of_pair (m,s)  = to_float m, to_float s


  let hypot (a,b) = sqrt (a**2. +. b**2.)

  let add op (a,b) (c,d) = op a c, match (b,d) with
    | (0.,e) | (e,0.) -> e
    | (b,d) -> hypot (b,d)
  let sum = add ( +. )
  let sub = add ( -. )
  let mul (a,b) (c,d) = a *. c, match (b,d) with
    | 0.,e -> abs_float (e *. c)
    | e,0. -> abs_float (e *. a)
    | b,d -> hypot (b*.c,d*.a)
  let div (a,b) (c,d) = a /. c, match (b,d) with
    | b,0. -> abs_float b /. c
    | 0.,d -> abs_float ((d *. a /. c) /. c)
    | b,d  -> hypot (b, d *. a /. c) /. c

  let compare (a,b) (c,d) =
    let r = a -. c in
    let eps = max (hypot (b,d)) (sqrt epsilon_float) in
    if   (abs_float r) <= eps then 0
    else match r with
      | r when r > 0. -> 1
      | _ -> -1
  let abs (m,e) = abs_float m, e

  let to_string (a,b) = Printf.sprintf "%g±%g" a b

  let less a b = compare a b = -1
  let equal a b = compare a b = 0
  let great a b = compare a b = 1
  let lesseq a b = compare a b <= 0
  let greateq a b = compare a b >= 0

  let to_floats s = s

  let ( + ) = sum
  let ( * ) = mul
  let ( / ) = div
  let ( - ) = sub
  let ( < ) = less
  let ( > ) = great
  let ( = ) = equal
  let ( >= ) = greateq
  let ( <= ) = lesseq
  let (<>) a b = not (a = b)

end
