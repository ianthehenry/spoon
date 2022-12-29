open! Core
open! Core_unix

let output_mode_param =
  let open Command.Param in
  let open Spoon.Output_mode in
  let map_bool_to_choice v param = map param ~f:(Fn.flip Option.some_if v) in
  choose_one
    ~if_nothing_chosen:(Default_to Pretty_html)
    [ flag
        "-ugly"
        no_arg
        ~doc:
          "don't pretty-print output, and try (not very well) to preserve the whitespace \
           of the input. Note that Spoon will still ensure a terminal newline after each \
           node it outputs."
      |> map_bool_to_choice Ugly_html
    ; flag "-text" no_arg ~doc:"flatten and print text from each selected node"
      |> map_bool_to_choice Text
    ; flag
        "-sexp"
        no_arg
        ~doc:
          "print output as a sexp. HTML comments and doctype declarations will be \
           ignored."
      |> map_bool_to_choice Sexp
    ]
;;

let operation_param =
  let open Command.Let_syntax in
  let open Spoon.Operation in
  let%map_open selector = anon (maybe ("SELECTOR" %: string)) in
  Option.value_map selector ~default:Print_all_nodes ~f:(fun selector ->
    Run_selector selector)
;;

let command =
  let open Command.Let_syntax in
  Command.basic
    ~summary:"Spoon is a command-line wrapper around lambda-soup."
    (let%map_open output_mode = output_mode_param
     and operation = operation_param
     and file =
       flag
         "-file"
         (optional_with_default "/dev/stdin" string)
         ~doc:"PATH file to read from (defaults to stdin)"
     in
     fun () ->
       let input_stream, close_input_file = Markup.file file in
       Spoon.run output_mode operation ~input_stream;
       close_input_file ())
;;

let () = Command_unix.run command
