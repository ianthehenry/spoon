Spoon is a command-line HTML wrangler, like [`pup`](https://github.com/ericchiang/pup), but worse.

It is a small wrapper around [Lamba Soup](https://github.com/aantron/lambdasoup).

It is not actually released anywhere, so if you want to use it, you'll have to build it from source.

# Quick Start

Spoon takes a single anonymous argument, a CSS selector, and optionally some flags that control how it prints them.

The default is to pretty-print HTML structure:

```
$ curl -s https://ianthehenry.com | spoon 'header'
<header>
 <a class="site-title" href="/">Ian Henry</a>
 <nav>
  <ul>
   <li>
    <a href="/about/">About</a>
   </li>
   <li>
    <a href="/posts/">Blog</a>
   </li>
   <li>
    <a href="/stuff/">Stuff</a>
   </li>
  </ul>
 </nav>
 <button id="dmt" title="Toggle dark mode"></button>
</header>
```

You can also extract just the text nodes from the selection:

```
$ curl -s https://ianthehenry.com | spoon 'header' -text
Ian Henry About Blog Stuff
```

And you can print the selected nodes with an approximate preservation of the original whitespace:

```
$ curl -s https://ianthehenry.com | spoon 'header' -ugly
<header>
<a class="site-title" href="/">Ian Henry</a>
<nav>
<ul><li><a href="/about/">About</a></li><li><a href="/posts/">Blog</a></li><li><a href="/stuff/">Stuff</a></li></ul>
</nav>
<button id="dmt" title="Toggle dark mode"></button>
</header>
```

```
$ spoon 'head > meta[name=twitter:creator]' -sexp -file <(curl -s https://ianthehenry.com)
(meta ((name twitter:creator) (content @ianthehenry)) ())
```

Once you have a sexp, you can continue to process it with the [`sexp`](https://github.com/janestreet/sexp) tool.

`spoon` currently ignores all HTML comments. There's no way to extract them from a document.

# Usage

```
$ spoon -help
Spoon is a command-line wrapper around lambda-soup.

  spoon [SELECTOR]

=== flags ===

  [-file PATH]               . file to read from (defaults to stdin)
  [-sexp]                    . print output as a sexp. HTML comments and doctype
                               declarations will be ignored.
  [-text]                    . flatten and print text from each selected node
  [-ugly]                    . don't pretty-print output, and try (not very
                               well) to preserve the whitespace of the input.
                               Note that Spoon will still ensure a terminal
                               newline after each node it outputs.
  [-build-info]              . print info about this build and exit
  [-version]                 . print the version of this build and exit
  [-help], -?                . print this help text and exit
```

# Building

`spoon` requires `opam`.

```
$ opam switch create . 4.14.1
$ opam install --deps-only .
$ dune build
```
