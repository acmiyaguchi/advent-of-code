sample("R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2").

parse_input(In, Out):-
    split_string(In, "\n", "", Lines),
    maplist([Line, K-Num]>>(
        split_string(Line, " ", "", [K, V]),
        number_string(Num, V)
    ), Lines, Out).

move("R", X-Y, X1-Y):- X1 is X + 1.
move("L", X-Y, X1-Y):- X1 is X - 1.
move("U", X-Y, X-Y1):- Y1 is Y + 1.
move("D", X-Y, X-Y1):- Y1 is Y - 1.

% we can also touch if we once in x or y directions
touch(A, C, S1, S2):-
    member(D1, S1),
    member(D2, S2),
    move(D1, A, B),
    move(D2, B, C).
% touch by moving in one of the cardinal directions
touch_diagonal(A, C):- touch(A, C, ["R", "L"], ["U", "D"]).
touch(A, A).
touch(A, B):- move(_, A, B).
touch(A, C):- touch_diagonal(A, C).

same_axis(X-_, X-_).
same_axis(_-Y, _-Y).

solve1(Moves, Out):-
    solve1(Moves, 0-0, 0-0, [0-0], Out).
solve1([], _, _, Visited, Visited).
solve1([_-0|T], HPos, TPos, Visited, Out):- solve1(T, HPos, TPos, Visited, Out).
% H and T are touching after H moves
solve1([Dir-Steps|T], HPos, TPos, Visited, Out):-
    NewSteps is Steps - 1,
    move(Dir, HPos, NewHPos),
    touch(NewHPos, TPos),
    !,
    % print(HPos), write(' '), print(TPos), nl,
    solve1([Dir-NewSteps|T], NewHPos, TPos, Visited, Out).
% H and T are not touching after H moves, so we find
solve1([Dir-Steps|T], HPos, TPos, Visited, Out):-
    NewSteps is Steps - 1,
    move(Dir, HPos, NewHPos),
    % they dont touch, do they share an axis?
    (
        same_axis(NewHPos, TPos) ->
            move(_, TPos, NewTPos);
            touch_diagonal(TPos, NewTPos)
    ),
    touch(NewTPos, NewHPos),
    !,
    % print(HPos), write(' '), print(TPos), nl,
    append(Visited, [NewTPos], NewVisited),
    solve1([Dir-NewSteps|T], NewHPos, NewTPos, NewVisited, Out).

part1(In, Out):-
    parse_input(In, Parsed),
    solve1(Parsed, Visited),
    list_to_ord_set(Visited, OrdSet),
    % print(OrdSet), nl,
    length(OrdSet, Out).

part2(In, Out):-
    part1(In, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    Path = "2022/09/input.txt",
    read_file(Path, In),
    sample(Sample),
    part1(Sample, SampleOut), print(SampleOut), nl,
    part1(In, Out1), print(Out1), nl.
    % part2(In, Out2), print(Out2), nl.
