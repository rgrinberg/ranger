type 'a t

val create : ?start:int -> stop:int -> (int -> 'a) -> 'a t

val get : 'a t -> int -> 'a

val of_array : ?start:int -> ?stop:int -> 'a array -> 'a t

val of_string : ?start:int -> ?stop:int -> string -> char t

val iter : 'a t -> f:('a -> unit) -> unit

val iteri : 'a t -> f:(int -> 'a -> unit) -> unit

val bounds : 'a t -> int * int

val for_all : 'a t -> f:('a -> bool) -> bool

val length : 'a t -> int

val is_empty : 'a t -> bool

val rev : 'a t -> 'a t

val fold_left : 'a t -> init:'b -> f:('b -> 'a -> 'b) -> 'b

val fold_right : 'a t -> f:('a -> 'b -> 'b) -> init:'b -> 'b

val drop : 'a t -> int -> 'a t

val drop_while : 'a t -> f:('a -> bool) -> 'a t

val take : 'a t -> int -> 'a t

val take_while : 'a t -> f:('a -> bool) -> 'a t
