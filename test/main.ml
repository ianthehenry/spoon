open Core

let stream_of_string x = String.to_list x |> Markup.of_list

let test output_mode operation str =
  Spoon.run output_mode operation ~input_stream:(Markup.of_list (String.to_list str))
;;

let example_markup =
  {|<body>
          <div class="important">
              just  markup    things </div></body> |}
;;

let%expect_test "different output modes" =
  List.iter Spoon.Output_mode.all ~f:(fun output_mode ->
    print_s [%sexp (output_mode : Spoon.Output_mode.t)];
    test output_mode Print_all_nodes example_markup);
  [%expect
    {|
      Pretty_html
      <body>
        <div class="important">
          just  markup    things
        </div>
      </body>

      Ugly_html
      <body>
                <div class="important">
                    just  markup    things </div></body>

      Text
      just  markup    things

      Sexp
      (body ()
       ( "\
        \n          "
        (div ((class important)) ( "\
                                  \n              just  markup    things "))))
      " " |}]
;;

let%expect_test "text output prints each node on its own line" =
  test
    Text
    Print_all_nodes
    "<div>some text here</div><div>and <span>here</span> too</div>";
  [%expect {|
    some text here
    and here too |}]
;;

let%expect_test "text output can print the same text node twice" =
  test
    Text
    (Run_selector "*")
    "<div>some text here</div><div>text <span>repeat</span> text</div>";
  [%expect {|
    some text here
    text repeat text
    repeat |}]
;;

let%expect_test "nested nodes can produce duplicate output" =
  test Pretty_html (Run_selector "div") "<div><div>nested</div></div>";
  [%expect
    {|
    <div>
      <div>
        nested
      </div>
    </div>
    <div>
      nested
    </div> |}]
;;

let%expect_test "top-level text nodes don't get dropped" =
  test Pretty_html Print_all_nodes "<div>nested</div> top-level";
  [%expect {|
    <div>
      nested
    </div>
    top-level |}]
;;
