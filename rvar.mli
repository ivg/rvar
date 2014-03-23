(** Uncertain values.
    Represents quantitives with values that are not known exactly.
    Each quantity is assosiated with a standard deviation accessible
    with [std].

    Quantity is represented as a random value which follows a normal
    distribution of mean [mean] and standard deviation [std].

    Functor [Make] creates a module for a value represented by module
    [S].
  *)
module Make(S:sig
  type t                                (** support type  *)
  val of_float: float -> t              (** inject from float  *)
  val to_float: t -> float              (** project to  float  *)
end) : sig
  (** {2 Type definitions}  *)
  type t                                (** uncertain value  *)
  type s = S.t                          (** underlying value  *)

  (** {2 Constructors and Accessors}  *)
  val create: s -> s -> t
  (** [create x e] creates value [x±e] *)
  val exactly: s -> t
  (** [exact m] creates a value that is certainly equal to [m] *)
  val mean: t -> s
  (** [mean v] returns a certain part of uncertain value  *)
  val std: t -> s
  (** [std v] standard deviation *)
  val change: s -> t -> t
  (** [change m v] updates the certain part of value, leaving [std]
      intact.  *)
  val with_std: s -> t -> t
  (** [with_std std v] returns quantity equal to [v] but with
      standard deviation [std]  *)

  val more_precise: t -> t -> t
  (** [precise a b] return [a] if [std a < std b] else [b].  *)

  val to_pair: t -> s * s
  (** [to_pair v] decontructs value to [(x,e)e], where [x] is a
      certain part and [e] is the [std] *)
  val of_pair: s * s -> t
  (** [to_pair v] contructs value of pair [(x,e)], where [x] is a
      certain part and [e] is the [std] *)

  (** {3 Converting to or from floats }  *)
  val to_floats: t -> float * float
  (** [to_floats v] deconstructs value to a pair of floats [(x,e)e],
      where [x] is a certain part and [e] is the [std] *)

  val float_of_mean: t -> float
  (** [float_of_mean t => fst (to_floats t)] *)

  val float_of_std: t -> float
  (** [float_of_std t => snd (to_floats t)] *)

  val to_string: t -> string
  (** [to_string t] represents quantity as [v±e].  *)

  (** {2 Arithmetics}
      Implementation of operations in this section assumes, that
      errors of the quatities are uncorrelated and normally
      distributed. *)
  val sum: t -> t -> t (** [sum a b => a + b] *)
  val sub: t -> t -> t (** [sub a b => a - b] *)
  val mul: t -> t -> t (** [mul a b => a · b] *)
  val div: t -> t -> t (** [div a b => a ÷ b] *)
  val abs: t -> t      (** [abs a   => |a|  ] *)

  (** {3 Infix operations}
      This module provides infix versions of the above operations *)
  include Ops.Field with type t := t
  (** {2 Comparison }

      Binary operations in this section, assumes that [a] equals [b]
      [iff] [|a-b| < √(c²+d²)], where [c] and [d] are standard
      deviations of [a] and [b] respectivly.  Indeed the functions
      tests hypothesis, with some uncertanity of the result.
  *)

  val compare: t -> t -> int
  (** [compare a b] common comparison interface *)

  val less:    t -> t -> bool              (** [a < b] *)
  val equal:   t -> t -> bool              (** [a = b] *)
  val great:   t -> t -> bool              (** [a > b] *)
  val lesseq:  t -> t -> bool              (** [a ≤ b] *)
  val greateq: t -> t -> bool              (** [a ≥ b] *)

  (** {3 Infix operations}
      This module provides the infix variants of the operations,
      provided in this section. *)
  include Ops.TotallyOrdered with type t := t
end
