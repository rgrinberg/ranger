external (|>) : 'a -> ('a -> 'b) -> 'b = "%revapply"

type 'a t = {
  start : int;
  stop : int;
  get : int -> 'a;
}

let parse_num = function
  | `Inclusive x -> x + 1
  | `Exclusive x -> x

let parse_default ~default = function
  | Some x -> parse_num x
  | None -> default

let create ?(start=0) ~stop get = { start; stop=(parse_num stop); get }

let get {start; get; _} n = get (start + n)

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

let rev t = { t with get=(fun i -> t.get (t.stop - i)) }

let to_list t = 
  let elems = ref [] in
  iter (rev t) ~f:(fun x -> elems := x :: !elems);
  !elems

let iteri {start; stop; get} ~f =
  for i = start to stop - 1 do
    f (i - start) (get i)
  done

let bounds {start; stop; _} = (start, stop - 1)

let length {start; stop; _} = stop - start

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

let dropl ({start; stop; _ } as t) n =
  if (start + n) > stop then invalid_arg "Ranger.drop: out of bounds"
  else {t with start=(start+n)}

let dropl_while ({start; stop; get} as t) ~f =
  let module S = struct exception Found of int end in
  try
    for i = start to stop - 1 do
      if not (f (get i)) then raise (S.Found i)
    done;
    {start=stop;stop;get}
  with S.Found start -> {t with start}

let takel ({start; stop; _} as t) n = 
  if (start + n) > stop then invalid_arg "Ranger.take: out of bounds"
  else {t with stop=(start + n)}

let takel_while ({start; stop; get} as t) ~f =
  let module S = struct exception Found of int end in
  try
    for i = start to stop - 1 do
      if not (f (get i)) then raise (S.Found (pred i))
    done;
    {start=stop;stop;get}
  with S.Found stop -> {t with stop}

let dropr t n = rev (dropl (rev t) n)

let taker t n = rev (takel (rev t) n)
