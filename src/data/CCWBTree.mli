
(* This file is free software, part of containers. See file "license" for more details. *)

(** {1 Weight-Balanced Tree}

  {b status: experimental}

  @since NEXT_RELEASE *)

type 'a sequence = ('a -> unit) -> unit
type 'a gen = unit -> 'a option
type 'a printer = Format.formatter -> 'a -> unit

module type ORD = sig
  type t
  val compare : t -> t -> int
end

module type KEY = sig
  include ORD
  val weight : t -> int
end

(** {2 Signature} *)

module type S = sig
  type key

  type 'a t

  val empty : 'a t

  val is_empty : _ t -> bool

  val singleton : key -> 'a -> 'a t

  val mem : key -> _ t -> bool

  val get : key -> 'a t -> 'a option

  val get_exn : key -> 'a t -> 'a
  (** @raise Not_found if the key is not present *)

  val nth : int -> 'a t -> (key * 'a) option
  (** [nth i m] returns the [i]-th [key, value] in the ascending
      order. Complexity is [O(log (cardinal m))] *)

  val nth_exn : int -> 'a t -> key * 'a
  (** @raise Not_found if the index is invalid *)

  val add : key -> 'a -> 'a t -> 'a t

  val remove : key -> 'a t -> 'a t

  val update : key -> ('a option -> 'a option) -> 'a t -> 'a t
  (** [update k f m] calls [f (Some v)] if [get k m = Some v], [f None]
      otherwise. Then, if [f] returns [Some v'] it binds [k] to [v'],
      if [f] returns [None] it removes [k] *)

  val cardinal : _ t -> int

  val weight : _ t -> int

  val fold : ('b -> key -> 'a -> 'b) -> 'b -> 'a t -> 'b

  val iter : (key -> 'a -> unit) -> 'a t -> unit

  val choose : 'a t -> (key * 'a) option

  val choose_exn : 'a t -> key * 'a
  (** @raise Not_found if the tree is empty *)

  val random_choose : Random.State.t -> 'a t -> key * 'a
  (** Randomly choose a (key,value) pair within the tree, using weights
      as probability weights
      @raise Not_found if the tree is empty *)

  val add_list : 'a t -> (key * 'a) list -> 'a t

  val of_list : (key * 'a) list -> 'a t

  val to_list : 'a t -> (key * 'a) list

  val add_seq : 'a t -> (key * 'a) sequence -> 'a t

  val of_seq : (key * 'a) sequence -> 'a t

  val to_seq : 'a t -> (key * 'a) sequence

  val add_gen : 'a t -> (key * 'a) gen -> 'a t

  val of_gen : (key * 'a) gen -> 'a t

  val to_gen : 'a t -> (key * 'a) gen

  val print : key printer -> 'a printer -> 'a t printer

  (**/**)
  val balanced : _ t -> bool
  (**/**)
end

(** {2 Functor} *)

module Make(X : ORD) : S with type key = X.t

module MakeFull(X : KEY) : S with type key = X.t
(** Use the custom [X.weight] function *)
