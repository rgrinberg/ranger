external (|>) : 'a -> ('a -> 'b) -> 'b = "%revapply"

type 'a t = {
  start : int;
  stop : int;
  get : int -> 'a;
}

exception Found of int 

let parse_num = function
  | `Inclusive x -> x + 1
  | `Exclusive x -> x

let parse_default ~default = function
  | Some x -> parse_num x
  | None -> default

let empty = {start=0; stop=0; get=(fun _ -> invalid_arg "Ranger.empty")}

let option_map t ~f = match t with None -> None | Some x -> Some (f x)

let create ?(start=0) ~stop get = { start; stop=(parse_num stop); get }

let repeat ~times a = {start=0;stop=times;get=(fun _ -> a) }

let get {start; get; _} n = get (start + n)

let length {start; stop; _} = stop - start

let of_array ?(start=0) ?stop arr = 
  let stop = parse_default ~default:(Array.length arr) stop
  in { start; stop; get=(Array.get arr) }

let of_string ?(start=0) ?stop str = 
  let stop = parse_default ~default:(String.length str) stop in
  { start; stop; get=(String.get str) }

let of_list ?(start=0) ?stop l =
  let stop = parse_default ~default:(List.length l) stop in
  { start ; stop; get=(List.nth l) }

let iter {start; stop; get} ~f =
  for i = start to stop - 1 do f (get i) done

exception Longer of [`Left | `Right]

let iter2_exn t1 t2 ~f = 
  let i = ref 0 in
  let length_t2 = length t2 in
  iter t1 ~f:(fun e -> 
      if !i = length_t2 then raise (Longer `Left)
      else begin f e (get t2 !i); incr i end
  ); if length_t2 > !i then raise (Longer `Right)

(* just use this for early return *)
let fast_equal t1 t2 = (length t1) = (length t2)

let equal ?(eq=(=)) t1 t2 = 
  if not (fast_equal t1 t2) then false
  else
    try 
      for i = 0 to length t1 - 1 do
        if not (eq (get t1 i) (get t2 i)) then
          raise Exit
      done; true
    with Exit -> false

let compare ?(cmp=compare) t1 t2 =
  let module M = struct exception Exit of int end in
  let open M in
  try iter2_exn t1 t2 ~f:(fun a b ->
      match cmp a b with
      | -1 -> raise (Exit (-1))
      | 1 -> raise (Exit 1)
      | 0 -> ()
      | x -> invalid_arg ("Ranger.compare: bad argument compare " ^
                            (string_of_int x))
    ); 0
  with
  | Longer `Left -> 1
  | Longer `Right -> -1

let rev t = { t with get=(fun i -> t.get (t.stop - i)) }

let to_list t = 
  let elems = ref [] in
  iter (rev t) ~f:(fun x -> elems := x :: !elems);
  !elems

let iteri {start; stop; get} ~f =
  for i = start to stop - 1 do
    f (i - start) (get i)
  done

let to_string t =
  let s = String.create (length t) in
  iteri t ~f:(fun i c -> s.[i] <- c);
  s

let bounds {start; stop; _} = (start, stop - 1)

let is_empty {start; stop; _} = start >= stop

let for_all {start; stop; get} ~f = 
  try for i = start to stop - 1 do
      if not (f (get i)) then
        raise Exit
    done;
    true
  with Exit -> false

let fold_left {start; stop; get} ~init ~f =
  let acc = ref init in
  for i = start to stop - 1 do
    acc := f !acc (get i)
  done; !acc

let fold_right t ~f ~init =
  fold_left (rev t) ~init ~f:(fun x y -> f y x)

let dropl ({start; stop; _ } as t) ~n =
  if (start + n) > stop then invalid_arg "Ranger.drop: out of bounds"
  else {t with start=(start+n)}

let dropl_while ({start; stop; get} as t) ~f =
  try
    for i = start to stop - 1 do
      if not (f (get i)) then raise (Found i)
    done;
    {start=stop;stop;get}
  with Found start -> {t with start}

let takel ({start; stop; _} as t) ~n = 
  if (start + n) > stop then invalid_arg "Ranger.take: out of bounds"
  else {t with stop=(start + n)}

let takel_while ({start; stop; get} as t) ~f =
  try
    for i = start to stop - 1 do
      if not (f (get i)) then raise (Found (pred i))
    done;
    {start=stop;stop;get}
  with Found stop -> {t with stop}

let dropr t ~n = rev (dropl (rev t) n)

let taker t ~n = rev (takel (rev t) n)

let tl t = 
  if t.start + 1 >= t.stop then None
  else Some {t with start=(t.start + 1) }

let tl_exn t =
  if t.start + 1 >= t.stop then invalid_arg "Range.tl_exn: out of bounds"
  else {t with start=(t.start + 1) }

let hd t = 
  if t.start >= t.stop then None
  else Some (get t 0)

let hd_exn t = 
  if t.start >= t.stop then invalid_arg "Range.hd_exn: out of bounds"
  else get t 0

let findi t ~f = 
  try iteri t ~f:(fun i x -> if f x then raise (Found i)); None
  with Found x -> Some (x, get t x)

let find t ~f = option_map (findi t ~f) ~f:snd

let split_at t ~n = (takel t n, dropl t n)

let splitl t ~f =
  match findi t ~f:(fun x -> not (f x)) with
  | None -> (empty, t)
  | Some (i, _) -> split_at t i

let splitr t ~f = 
  match findi (rev t) ~f:(fun x -> not (f x)) with
  | None -> (empty, t)
  | Some (i, _) -> split_at t i


