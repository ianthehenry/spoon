with import <nixpkgs> {};
let frameworks =
  with (darwin.apple_sdk.frameworks); [
    Foundation CoreServices
  ];
in
mkShell {
  nativeBuildInputs = [
    opam
  ] ++ frameworks;
  shellHook = "eval $(opam env)";
}
