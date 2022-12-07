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

directory(Name, Parent, Children, FileSizes).

% insert_tree([H|T], FileSize, Tree, Out):-
%     directory(Name, Children, FileSizes),
%     member(Child, Children),
%     Child = directory(H, _, _),
%     insert_tree(T, FileSize, Child, Out).

walk_input(Root, [["$", "cd", ".."]|T], directory(_, Parent, _, _), Out):-
    walk_input(Root, T, Parent, Out).

% check if this directory already exists
walk_input(Root, [["$", "cd", Dir]|T], Cur, Out):-
    Cur = directory(_, _, Children, _),
    member(Child, Children),
    Child = directory(Dir, _, _, _),
    walk_input(Root, T, Child, Out).

% create a new directory if it doesn't exist
walk_input(Root, [["$", "cd", Dir]|T], Cur, Out):-
    Cur = directory(_, _, Children, _),
    NewDir = directory(Dir, Cur, [], []),
    append(Children, [NewDir], NewChildren),
    NewCur = directory(Cur, NewChildren, []),
    walk_input(Root, T, NewCur, Out).

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
