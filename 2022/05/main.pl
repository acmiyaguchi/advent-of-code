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
    Path = "2022/05/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    part1(In, Out1), print(Out1), nl,
    part2(In, Out2), print(Out2), nl.
