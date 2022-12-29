(lang dune 3.6)

(formatting (enabled_for ocaml))

(name spoon)

(generate_opam_files true)

(source
 (github ianthehenry/spoon))

(authors "Ian Henry <ianthehenry@gmail.com>")

(maintainers "Ian Henry <ianthehenry@gmail.com>")

(license MIT)

(package
 (name spoon)
 (synopsis "HTML wrangler")
 (description "A simple frontend to lambda_soup")
 (depends
   ocaml
   ocamlformat
   dune
   lambdasoup
   core
   core_unix
   ppx_jane)
 (tags
  (topics html)))
