open Kaputt.Abbreviations

module R = Ranger

let arr = [|1;2;3;4|]

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


let () = Test.launch_tests ()


