
type 'a binary = 'a -> 'a -> 'a
type 'a unary  = 'a -> 'a
type 'a binary_p = 'a -> 'a -> bool
type 'a unary_p  = 'a -> bool

module type Additive = sig
  type t
  val (+): t binary
  val (-): t binary
end

module type Multipliable = sig
  type t
  val ( * ): t binary
end

module type Dividable = sig
  type t
  val ( / ): t binary
end

module type Multiplicative = sig
  type t
  include Multipliable with type t := t
  include Dividable    with type t := t
end

module type Ring = sig
  type t
  include Additive with type t := t
  include Multipliable with type t := t
end

module type Field = sig
  type t
  include Ring with type t := t
  include Dividable with type t := t
end

module type EqualComparable = sig
  type t
  val (=): t binary_p
end


module type Comparable = sig
  type t
  include EqualComparable with type t := t
  val (<): t binary_p
end

module type TotallyOrdered = sig
  type t
  include EqualComparable with type t := t
  include Comparable with type t := t
  val (<>): t binary_p
  val (<=): t binary_p
  val (>=): t binary_p
  val (>): t binary_p
end

module MakeOrdered(Comparable:Comparable) = struct
  include Comparable
  let (<>) a b = not(a = b)
  let (<=) a b = a < b || a = b
  let (>=) a b = not(a < b)
  let (>) a b = not(a <= b)
end
