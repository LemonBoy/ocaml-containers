
(* This file is free software, part of containers. See file "license" for more details. *)

(** {1 Basic Int functions} *)

type t = int

val compare : t -> t -> int

val equal : t -> t -> bool

val hash : t -> int

val sign : t -> int
(** [sign i] is one of [-1, 0, 1] *)

val neg : t -> t
(** [neg i = - i]
    @since 0.5 *)

val pow : t -> t -> t
(** [pow a b = a^b] for positive integers [a] and [b].
    Raises [Invalid_argument] if [a = b = 0] or [b] < 0.
    @since 0.11 *)

type 'a printer = Format.formatter -> 'a -> unit
type 'a random_gen = Random.State.t -> 'a
type 'a sequence = ('a -> unit) -> unit

val random : int -> t random_gen
val random_small : t random_gen
val random_range : int -> int -> t random_gen

val pp : t printer

val to_string : t -> string
(** @since 0.13 *)

val of_string : string -> t option
(** @since 0.13 *)

val pp_binary : t printer
(** prints as "0b00101010".
    @since 0.20 *)

val to_string_binary : t -> string
(** @since 0.20 *)

val min : t -> t -> t
(** @since 0.17 *)

val max : t -> t -> t
(** @since 0.17 *)

val range_by : step:t -> t -> t -> t sequence
(** [range_by ~step i j] iterates on integers from [i] to [j] included,
    where the difference between successive elements is [step].
    use a negative [step] for a decreasing list.
    @raise Invalid_argument if [step=0]
    @since NEXT_RELEASE *)

val range : t -> t -> t sequence
(** [range i j] iterates on integers from [i] to [j] included . It works
    both for decreasing and increasing ranges
    @since NEXT_RELEASE *)

val range' : t -> t -> t sequence
(** Same as {!range} but the second bound is excluded.
    For instance [range' 0 5 = Sequence.of_list [0;1;2;3;4]]
    @since NEXT_RELEASE *)

(** {2 Infix Operators}

    @since 0.17 *)
module Infix : sig
  val (=) : t -> t -> bool
  (** @since 0.17 *)

  val (<>) : t -> t -> bool
  (** @since 0.17 *)

  val (<) : t -> t -> bool
  (** @since 0.17 *)

  val (>) : t -> t -> bool
  (** @since 0.17 *)

  val (<=) : t -> t -> bool
  (** @since 0.17 *)

  val (>=) : t -> t -> bool
  (** @since 0.17 *)

  val (--) : t -> t -> t sequence
  (** Alias to {!range}
      @since NEXT_RELEASE *)

  val (--^) : t -> t -> t sequence
  (** Alias to {!range'}
      @since NEXT_RELEASE *)
end

include module type of Infix
