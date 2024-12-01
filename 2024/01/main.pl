sample("3   4
4   3
2   5
1   3
3   9
3   3").

parse_line(Line, Out):-
    split_string(Line, "\s", "\s", Split),
    maplist(atom_number, Split, Out).

% https://stackoverflow.com/questions/16431002/prolog-unzip-list-of-pairs
% https://www.swi-prolog.org/pack/file_details/canny_tudor/prolog/swi/lists.pl?show=src
zip([], [], []).
zip([H1|T1], [H2|T2], [[H1, H2]|T]) :- zip(T1, T2, T).

parse_input(In, L-R):-
    split_string(In, "\n", "", Split),
    maplist(parse_line, Split, Lines),
    % now lets unzip these into a two lists
    zip(L, R, Lines).

part1(In, Out):-
	parse_input(In, L-R),
    % sort each line
    msort(L, Lsort),
    msort(R, Rsort),
    zip(Lsort, Rsort, Psort),
    % take the difference
    maplist([[A,B],Y]>>(Y is abs(A-B)), Psort, Diffs),
    sumlist(Diffs, Out).

% basecase
count(_, [], Out, Out).
% number appears
count(Val, [Val|T], Cur, Out):-
    Acc is Cur + 1,
    count(Val, T, Acc, Out).
% it doesn't appear
count(Val, [_|T], Acc, Out):-
    count(Val, T, Acc, Out).
% wrapper
count(Val, List, Out) :- count(Val, List, 0, Out).

part2(In, Out):-
	parse_input(In, L-R),
    % for each number in the left list, see how many times
    % it appears in the right list
    maplist(
        {R}/[X, Count]>>
            count(X, R, Count),
        L,
        Counts
    ),
    zip(L, Counts, Zipped),
    maplist([[X,Y], Prod]>>(Prod is X*Y), Zipped, Prods),
    sumlist(Prods, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = true,
    Path = "2024/01/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    % parse_input(In, Out), print(Out).
    part1(In, Out1), print(Out1), nl,
    part2(In, Out2), print(Out2), nl.
