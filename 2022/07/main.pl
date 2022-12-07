% 3 hours and 5 minutes (~15 minutes for part 2). This was a doozy to parse, but
% it was even more difficult to figure out how to sum up the sizes of the
% directories. I ended up being able to take advantage of the fact that I can
% sort individual directories by depth, and then sum up using the nodes using
% their immediate children. Not super intuitive, but it works. the second part
% was relatively easy, but the small piece of algebra tripped me up.
sample("$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k").


parse_input(In, Out):-
    split_string(In, "\n", "", Lines),
    maplist([Line, Parts]>>(split_string(Line, " ", "", Parts)), Lines, Out).

path(Parts, Path):- atomics_to_string(Parts, "-", Path).

read_ls_output([[SizeStr, _]|T], PathParts, Assoc, Out):-
    number_string(Size, SizeStr),
    path(PathParts, Key),
    (get_assoc(Key, Assoc, Value); Value = 0),
    NewValue is Value + Size,
    put_assoc(Key, Assoc, NewValue, NewAssoc),
    read_ls_output(T, PathParts, NewAssoc, Out).
% starts with dir, so we don't really care about it
read_ls_output([_|T], PathParts, Assoc, Out):-
    read_ls_output(T, PathParts, Assoc, Out).
read_ls_output([], _, Assoc, Assoc).


walk_input([["$", "cd", ".."]|T], Path, Assoc, Out):-
    append(NewPath, [_], Path),
    path(NewPath, Key),
    (get_assoc(Key, Assoc, _) -> NewAssoc = Assoc; put_assoc(Key, Assoc, 0, NewAssoc)),
    walk_input(T, NewPath, NewAssoc, Out).

walk_input([["$", "cd", Dir]|T], Path, Assoc, Out):-
    append(Path, [Dir], NewPath),
    path(NewPath, Key),
    (get_assoc(Key, Assoc, _) -> NewAssoc = Assoc; put_assoc(Key, Assoc, 0, NewAssoc)),
    walk_input(T, NewPath, NewAssoc, Out).

walk_input([["$", "ls"]|T], PathParts, Assoc, Out):-
    % the listing output does not contain any commands
    append(Listing, Rest, T),
    (Rest = [["$"|_]|_]; Rest = []),
    maplist([[H|_]]>>(H \= "$"), Listing),
    read_ls_output(Listing, PathParts, Assoc, NewAssoc),
    walk_input(Rest, PathParts, NewAssoc, Out).

walk_input([], _, Assoc, Assoc).

sum_sub_paths(Assoc, [H|T], AccAssoc, Out):-
    assoc_to_keys(AccAssoc, Keys),
    include({H}/[X]>>(
        path(HParts, H),
        path(XParts, X),
        append(HParts, Tail, XParts),
        length(Tail, 1)
    ), Keys, SubPaths),
    maplist({AccAssoc}/[SubPath, Size]>>(get_assoc(SubPath, AccAssoc, Size)), SubPaths, Sizes),
    (sum_list(Sizes, AccSum); AccSum = 0),
    get_assoc(H, Assoc, Value),
    Sum is AccSum + Value,

    % print("path: "), print(H), nl,
    % print("keys: "),print(Keys), nl,
    % print("subpaths: "),print(SubPaths), nl,
    % print(Sum), nl,

    put_assoc(H, AccAssoc, Sum, NewAccAssoc),
    sum_sub_paths(Assoc, T, NewAccAssoc, Out).
sum_sub_paths(_, [], Assoc, Assoc).

solver_for_paths(In, SummedAssoc):-
    parse_input(In, Parsed),
    empty_assoc(Empty),
    walk_input(Parsed, [], Empty, Assoc),
    % print(Assoc), nl,
    assoc_to_keys(Assoc, Keys),
    maplist([Key, N-Key]>>(
        string_concat("/", Rel, Key),
        path(Parts, Rel),
        length(Parts, K), N is -K
    ), Keys, Pairs),
    keysort(Pairs, KeyPairsSorted),
    maplist([_-Key, Key]>>true, KeyPairsSorted, KeysSorted),
    % print(KeysSorted), nl,
    sum_sub_paths(Assoc, KeysSorted, Empty, SummedAssoc).

part1(In, Out):-
    solver_for_paths(In, Assoc),
    assoc_to_values(Assoc, Values),
    include([X]>>(X =< 100_000), Values, AtMost),
    sum_list(AtMost, Out).

part2(In, Out):-
    solver_for_paths(In, Assoc),
    Available = 70_000_000,
    AtLeastSpace = 30_000_000,
    get_assoc("/", Assoc, RootSize),
    NeedSpace is AtLeastSpace - (Available - RootSize),
    assoc_to_values(Assoc, Sizes),
    include({NeedSpace}/[Size]>>(Size >= NeedSpace), Sizes, Valid),
    sort(Valid, Sorted),
    nth0(0, Sorted, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    Path = "2022/07/input.txt",
    read_file(Path, In),
    findall(X, sample(X), Samples),

    print("part 1 samples"), nl,
    maplist([X]>>(part1(X, Sol), print(Sol), nl), Samples),
    print("part 1 input"), nl,
    part1(In, Out1), print(Out1), nl,

    print("part 2 samples"), nl,
    maplist([X]>>(part2(X, Sol), print(Sol), nl), Samples),
    print("part 2 input"), nl,
    part2(In, Out2), print(Out2), nl.
