open! Core

module Output_mode : sig
  type t =
    | Pretty_html
    | Ugly_html
    | Text
    | Sexp
  [@@deriving sexp_of, enumerate]
end

module Operation : sig
  type t =
    | Print_all_nodes
    | Run_selector of string
  [@@deriving sexp_of]
end

val run
  :  Output_mode.t
  -> Operation.t
  -> input_stream:(char, Markup.sync) Markup.stream
  -> unit
