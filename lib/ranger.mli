(** Ranger - An interval slice for any data structures *)

(** Interval slices are called ranges in this library *)
type 'a t

val create : ?start:int -> stop:[`Inclusive of int | `Exclusive of int] ->
  (int -> 'a) -> 'a t

(** [repeat ~times:3 1] |> to_list is equivalent to [1;1;1] *)
val repeat : times:int -> 'a -> 'a t

(** [get t i] gets the ith element of the range (0 being the first element
    in the range) *)
val get : 'a t -> int -> 'a

(** Create a range out of an array *)
val of_array : ?start:int -> ?stop:[`Inclusive of int | `Exclusive of int]
  -> 'a array -> 'a t

(** Create a range out of a string *)
val of_string : ?start:int -> ?stop:[`Inclusive of int | `Exclusive of int] ->
  string -> char t

(** Create a range out of a list *)
val of_list : ?start:int -> ?stop:[`Inclusive of int | `Exclusive of int] ->
  'a list -> 'a t

val to_list : 'a t -> 'a list

val to_string : char t -> string

val iter : 'a t -> f:('a -> unit) -> unit

val iteri : 'a t -> f:(int -> 'a -> unit) -> unit

exception Longer of [`Left | `Right]

(** [iter2_exn t1 t2 ~f] iterates over [t1] [t2] together and executes
    f on both elements. raieses [Longer `Left] if [t1] termintates first
    otherwise raises [Longer `Right] *)
val iter2_exn : 'a t -> 'b t -> f:('a -> 'b -> unit) -> unit

val equal : ?eq:('a -> 'a -> bool) -> 'a t -> 'a t -> bool

val compare : ?cmp:('a -> 'a -> int) -> 'a t -> 'a t -> int

(** [bounds t] returns the first and last index in the range corresponding to
    the value the range was created from *)
val bounds : 'a t -> int * int

(** [for_all t ~f] returns true if [f] returns true for every element
    spanned by t. false otherwise*)
val for_all : 'a t -> f:('a -> bool) -> bool

val length : 'a t -> int

val is_empty : 'a t -> bool

val rev : 'a t -> 'a t

val fold_left : 'a t -> init:'b -> f:('b -> 'a -> 'b) -> 'b

val fold_right : 'a t -> f:('a -> 'b -> 'b) -> init:'b -> 'b

val reduce : 'a t -> f:('a -> 'a -> 'a) -> 'a option

val dropl : 'a t -> n:int -> 'a t

val dropl_while : 'a t -> f:('a -> bool) -> 'a t

val takel : 'a t -> n:int -> 'a t

val takel_while : 'a t -> f:('a -> bool) -> 'a t

val dropr : 'a t -> n:int -> 'a t

val taker : 'a t -> n:int -> 'a t

val split_at : 'a t -> n:int -> 'a t * 'a t

val splitl : 'a t -> f:('a -> bool) -> 'a t * 'a t

val splitr : 'a t -> f:('a -> bool) -> 'a t * 'a t

val hd : 'a t -> 'a option

val hd_exn : 'a t -> 'a

val tl : 'a t -> 'a t option

val tl_exn : 'a t -> 'a t

val mid_point : 'a t -> [`One of 'a | `Two of 'a * 'a] option
