external (|>) : 'a -> ('a -> 'b) -> 'b = "%revapply"

type 'a t = {
  start : int;
  stop : int;
  get : int -> 'a;
}

let create ?(start=0) ~stop get = { start; stop; get }

let of_array ?(start=0) ?stop arr = 
  let stop = match stop with
    | None -> Array.length arr - 1
    | Some x -> x in
  { start; stop; get=(Array.get arr) }

let of_string ?(start=0) ?stop str = 
  let stop = match stop with
    | None -> String.length str - 1
    | Some x -> x in
  { start; stop; get=(String.get str) }

let iter {start; stop; get} ~f =
  for i = start to stop do f (get i) done

let iteri {start; stop; get} ~f =
  for i = start to stop do
    f (i - start) (get i)
  done

let bounds {start; stop; _} = (start, stop)

let length {start; stop; _} = stop - start + 1

let for_all {start; stop; get} ~f = 
  try for i = start to stop do
      if not (f (get i)) then
        raise Exit
    done;
    true
  with Exit -> false

let reverse {start; stop; get} = 
  {start=(-stop); stop=(-stop); get=(fun i -> get (-1 * i))}

let fold_left {start; stop; get} ~init ~f =
  let acc = ref init in
  for i = start to stop do
    acc := f !acc (get i)
  done; !acc

let fold_right t ~f ~init =
  fold_left (reverse t) ~init ~f:(fun x y -> f y x)
