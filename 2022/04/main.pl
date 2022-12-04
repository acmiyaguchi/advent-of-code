% Oops, accidentally copied the input data twice and had 2000 rows instead of
% 1000. Finding the overlapping intervals was actually a little tricky. I ended
% up taking a different approach for part 2 and used set membership instead of
% doing arithmetic calculations because the logic is way easier to understand
% this way. 21 minutes for part one and 11 minutes for part two.

sample("2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8").

parse_input(In, Out):-
    split_string(In, "\n", "", Split),
    % now split each line into two pairs
    maplist([Line, [A-B, C-D]]>>(
            split_string(Line, ",-", "", Items),
            % convert into numbers
            maplist(atom_number, Items, [A, B, C, D])
        ),
        Split,
        Out
    ).

overlap([A-B, C-D]):- (A =< C, B >= D; C =< A, D >= B).

part1(In, Out):-
    parse_input(In, Parsed),
    include(overlap, Parsed, Valid),
    length(Valid, Out).

any_overlap([A-B, C-D]):-
    between(A, B, X),
    between(C, D, X).

part2(In, Out):-
    parse_input(In, Parsed),
    include(any_overlap, Parsed, Valid),
    length(Valid, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = true,
    Path = "2022/04/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    part1(In, Out1), print(Out1), nl,
    part2(In, Out2), print(Out2), nl.
