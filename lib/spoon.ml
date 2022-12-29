open! Core

module Output_mode = struct
  type t =
    | Pretty_html
    | Ugly_html
    | Text
    | Sexp
  [@@deriving sexp_of, enumerate]
end

module Operation = struct
  type t =
    | Print_all_nodes
    | Run_selector of string
  [@@deriving sexp_of]
end

let sexp_of_name = function
  | ("http://www.w3.org/1999/xhtml" | ""), name -> Sexp.Atom name
  | ns, name -> Sexp.Atom (sprintf "%s:%s" ns name)
;;

let sexp_of_attr (name, value) = Sexp.List [ sexp_of_name name; Sexp.Atom value ]

let sexp_of_markup soup =
  let open Sexp in
  Markup.tree
    soup
    ~text:(fun strings -> Atom (String.concat strings))
    ~element:(fun name attrs children ->
      List [ sexp_of_name name; List (List.map attrs ~f:sexp_of_attr); List children ])
;;

let print_ensuring_newline str =
  if String.is_suffix str ~suffix:"\n" then print_string str else print_endline str
;;

let print output_mode node =
  let open Option.Monad_infix in
  let return = Option.return in
  let str =
    match (output_mode : Output_mode.t) with
    | Pretty_html -> Soup.pretty_print node |> return
    | Ugly_html -> Soup.to_string node |> return
    | Text -> Soup.trimmed_texts node |> String.concat ~sep:" " |> return
    | Sexp -> Soup.signals node |> sexp_of_markup >>| Sexp.to_string_hum
  in
  Option.iter str ~f:print_ensuring_newline
;;

let run output_mode operation ~input_stream =
  let soup = input_stream |> Markup.parse_html |> Markup.signals |> Soup.from_signals in
  let print node = print output_mode node in
  (* [lambda_soup] doesn't expose a way to cast from the [element] phantom type to
     the [general] phantom type, hence the annoying lack of sharing here. *)
  match (operation : Operation.t) with
  | Print_all_nodes -> Soup.children soup |> Soup.iter print
  | Run_selector selector -> Soup.select selector soup |> Soup.iter print
;;
