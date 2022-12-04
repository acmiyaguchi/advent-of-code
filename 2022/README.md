# 2022

Prolog once again!

## quickstart

Here's my starter code:

```prolog
sample("").

parse_input(In, Out):-
    In = Out.

part1(In, Out):-
    parse_input(In, Out).

part2(In, Out):-
    part1(In, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = false,
    Path = "2022/01/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    part1(In, Out1), print(Out1), nl,
    part2(In, Out2), print(Out2), nl.
```

`UseInput` and `Path` will need to be adjusted accordingly. I use the
[VSC-Prolog](https://marketplace.visualstudio.com/items?itemName=arthurwang.vsc-prolog)
extension for VSCode to load the current document, which means that the path has
to be relative to the project root.
