type 'a t

val create : ?start:int -> stop:[`Inclusive of int | `Exclusive of int] ->
  (int -> 'a) -> 'a t

val get : 'a t -> int -> 'a

val of_array : ?start:int -> ?stop:[`Inclusive of int | `Exclusive of int]
  -> 'a array -> 'a t

val of_string : ?start:int -> ?stop:[`Inclusive of int | `Exclusive of int] ->
  string -> char t

val of_list : ?start:int -> ?stop:[`Inclusive of int | `Exclusive of int] ->
  'a list -> 'a t

val to_list : 'a t -> 'a list

val iter : 'a t -> f:('a -> unit) -> unit

val iteri : 'a t -> f:(int -> 'a -> unit) -> unit

exception Longer of [`Left | `Right]

val iter2_exn : 'a t -> 'b t -> f:('a -> 'b -> unit) -> unit

val equal : ?eq:('a -> 'a -> bool) -> 'a t -> 'a t -> bool

val compare : ?cmp:('a -> 'a -> int) -> 'a t -> 'a t -> int

val bounds : 'a t -> int * int

val for_all : 'a t -> f:('a -> bool) -> bool

val length : 'a t -> int

val is_empty : 'a t -> bool

val rev : 'a t -> 'a t

val fold_left : 'a t -> init:'b -> f:('b -> 'a -> 'b) -> 'b

val fold_right : 'a t -> f:('a -> 'b -> 'b) -> init:'b -> 'b

val dropl : 'a t -> int -> 'a t

val dropl_while : 'a t -> f:('a -> bool) -> 'a t

val takel : 'a t -> int -> 'a t

val takel_while : 'a t -> f:('a -> bool) -> 'a t

val dropr : 'a t -> int -> 'a t

val taker : 'a t -> int -> 'a t

val hd : 'a t -> 'a option

val hd_exn : 'a t -> 'a

val tl : 'a t -> 'a t option

val tl_exn : 'a t -> 'a t
