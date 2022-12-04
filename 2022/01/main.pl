% Fairly easy. The hardest part about this was figuring out how to parse a list
% of list of ints. I ended up writing a traditional looking recursive function
% to deal with this, with with most of the interesting logic being in the main
% function.
% https://swish.swi-prolog.org/p/aoc-2022-01.pl

sample("1000
2000
3000

4000

5000
6000

7000
8000
9000

10000").

gather_inputs([], [], Out, Out).
gather_inputs([], Cur, Acc, Out):-
    append(Acc, [Cur], Out).
gather_inputs([""|T], Cur, Acc, Out):-
    append(Acc, [Cur], Acc1),
    gather_inputs(T, [], Acc1, Out).
gather_inputs([H|T], Cur, Acc, Out):-
    append(Cur, [H], Cur1),
    gather_inputs(T, Cur1, Acc, Out).

parse_input(In, Out):-
    split_string(In, "\n", "", Split),
    % gather so they are a list of lists
    gather_inputs(Split, [], [], Gathered),
    maplist([X, Y]>>
            maplist([Str, Int]>>atom_number(Str, Int), X, Y),
            Gathered,
            Out).

part1(In, Out):-
	parse_input(In, Parsed),
    % sum each list, find max of the list
    maplist(sumlist, Parsed, Summed),
    max_list(Summed, Out).

part2(In, Out):-
	parse_input(In, Parsed),
    % sum each list, sort, and then sum top 3
    maplist(sumlist, Parsed, Summed),
    sort(Summed, Sorted),
    append(_, Top3, Sorted),
    length(Top3, 3),
    sumlist(Top3, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = true,
    Path = "2022/01/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    part1(In, Out1), print(Out1), nl,
    part2(In, Out2), print(Out2), nl.
