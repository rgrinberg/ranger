open Kaputt.Abbreviations

module R = Ranger

let arr = [|1;2;3;4|]

let arr_gen = 
  let open Gen in
  array (make_int 0 10) (make_int 4 10)

let () = Test.add_simple_test ~title:"of_array"
    (fun () ->
       let rng = R.of_array arr ~start:1 ~stop:2 in
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

let () = Test.launch_tests ()


