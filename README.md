# ranger

A library for efficient contigious integer slices of indexed data structures.

A specialized version of this library is contained in batteries under the
name BatSubstring.

### Example:

```

let range = Ranger.of_string "one two three four"

let twothreefour = range |> Ranger.drop_while ~f:((<>) ' ') |> Ranger.tl_exn

let () = assert (twothreefour = "two three four")

```

