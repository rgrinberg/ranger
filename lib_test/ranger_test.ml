open Kaputt.Abbreviations

module R = Ranger

let arr = [|1;2;3;4|]

let arr_gen = 
  let open Gen in
  array (make_int 0 10) (make_int 4 10)

let arr2_gen = 
  let open Gen in
  Gen.zip2 arr_gen arr_gen

let () = Test.add_simple_test ~title:"of_array"
    (fun () ->
       let rng = R.of_array arr ~start:1 ~stop:(`Inclusive 2) in
       let s1 = R.fold_left rng ~init:0 ~f:(+) in
       Assert.equal_int s1 5)

let () = Test.add_simple_test ~title:"reverse"
    (fun () ->
       let rev = R.rev (R.of_array arr) in
       let elems = R.to_list rev in
       Assert.equal arr (Array.of_list (List.rev elems)))

let () = Test.add_random_test ~title:"for_all" ~nb_runs:20 arr_gen
    (fun arr -> R.of_array arr)
    [
      Spec.always ==> (fun r -> R.for_all r ~f:(fun x -> x > 3))
    ]

let () = Test.add_random_test ~title:"length" ~nb_runs:20 arr_gen
    (fun arr -> (arr, R.of_array arr))
    [
      Spec.always ==> (fun (arr, range) -> 
          (R.length range) = (Array.length arr))
    ]

let () = Test.add_random_test ~title:"equal" ~nb_runs:20 arr_gen
    (fun a1 -> (R.compare (R.of_array a1) (R.of_array a1),
                      compare a1 a1))
    [
      Spec.always ==> (fun (x1, x2) -> x1 = x2)
    ]

let () = Test.add_simple_test ~title:"takel empty"
    (fun () ->
       let range = R.of_array arr in
       let zero = R.takel range 0 in
       Assert.equal_int (List.length (R.to_list zero)) 0;
       Assert.equal_int 0 (R.length zero))

let () = Test.add_random_test ~title:"takel" ~nb_runs:20 arr_gen
    (fun arr -> 
       let range = R.of_array arr in
       let len  = Array.length arr in
       let take_n = if len = 0 then 0 else (Random.int len) in
       (R.takel range take_n, take_n, arr))
    [
      Spec.always ==> (fun (taken, l, _) -> (R.length taken) = l);
      Spec.always ==> (fun (range, _, arr) -> (R.get range 0) = arr.(0))
    ]

let () = Test.add_simple_test ~title:"drop word"
    (fun () ->
       let r = Ranger.of_string "one two three" in
       let dropped = Ranger.dropl_while r ~f:((<>) ' ') in
       Assert.equal_string (R.to_string dropped) " two three")

let () = Test.add_random_test ~title:"taker" ~nb_runs:20 arr_gen
    (fun arr ->
       let range = R.of_array arr in
       let len = Array.length arr in
       let take_n = if len = 0 then 0 else (Random.int len) in
       (R.taker range take_n, take_n, arr))
    [
      Spec.always ==> (fun (taken, l, _) -> (R.length taken) = l);
    ]

let () = Test.add_simple_test ~title:"midpoint"
    (fun () ->
       let tests = [
         (Some (`One 3), R.of_array [|1;2;3;4;5|]);
         (None, R.of_array [||]);
         (Some (`One 1), R.of_array [|1|]);
         (Some (`Two (1,2)), R.of_array [|1;2|]); 
         (Some (`Two (2,3)), R.of_array [|1;2;3;4|])
       ]
       in List.iter (fun (res, range) ->
           let md = R.mid range in
           Assert.equal md res) tests
    )


let () = Test.launch_tests ()


