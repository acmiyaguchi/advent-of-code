% Another straightforward puzzle. It's super nice to be able to assert
% properties of the solution without having to do any real work.

sample("vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw").

% assign each char to a priority, 1-26 for a-z and 27-52 for A-Z
priorities(In, Out):-
    char_type(In, lower),
    char_code('a', Lower),
    char_code(In, Code),
    Out is Code - Lower + 1.

% upper case
priorities(In, Out):-
    char_type(In, upper),
    char_code('A', Upper),
    char_code(In, Code),
    Out is Code - Upper + 27.

parse_input(In, Out):-
    split_string(In, "\n", "", Split),
    % turn split into list of atoms
    maplist(atom_chars, Split, Chars),
    maplist(maplist(priorities), Chars, Out).

appears_in_both(List, Out):-
    % split list in half
    append(Left, Right, List),
    length(Left, N),
    length(Right, N),
    % find common elements
    member(Out, Left),
    member(Out, Right).

part1(In, Out):-
    parse_input(In, RucksackContents),
    maplist(appears_in_both, RucksackContents, Intersection),
    sumlist(Intersection, Out).

partition(_, [], Out, Out).
partition(N, List, Acc, Out):-
    append(Left, Right, List),
    length(Left, N),
    append(Acc, [Left], Acc1),
    partition(N, Right, Acc1, Out).

part2(In, Out):-
    parse_input(In, RucksackContents),
    partition(3, RucksackContents, [], Partitioned),
    maplist([[X, Y, Z], Common]>>(
            member(Common, X),
            member(Common, Y),
            member(Common, Z)
        ),
        Partitioned,
        GroupId
    ),
    sumlist(GroupId, Out).

:-
    UseInput = true,
    (UseInput ->
        open("2022/03/input.txt", read, Str),
        read_string(Str, _, In),
        close(Str)
    ;
        sample(In)
    ),
    part1(In, Out1),
    print(Out1), nl,
    part2(In, Out2),
    print(Out2).
