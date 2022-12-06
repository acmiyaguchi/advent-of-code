% needed to figure out a way to deal with multiple sample inputs, I should
% probably configure these as small unit tests for each input. I ran into a
% strange issue with backtracking when I was first writing first_n_unique/3, I
% think this had to do with append possibly. Solved this in roughly 33 minutes.

sample("bvwbjplbgvbhsrlpgdmjqwftvncz").
sample("nppdvjthqldpwncqszvftbrmjlhg").
sample("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").
sample("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").

parse_input(In, Out):-
    string_chars(In, Out).

first_n_unique([], _, Index, Index).
first_n_unique(L, N, Index, Index):-
    length(H, N),
    append(H, _, L),
    list_to_set(H, Set),
    length(Set, N).
first_n_unique([_|T], N, Index, Out):-
    % length(T, NT), print(NT), nl,
    Index1 is Index + 1,
    first_n_unique(T, N, Index1, Out).

first_n_unique(L, N, Out):- first_n_unique(L, N, N, Out).

part1(In, Out):-
    parse_input(In, Parsed),
    first_n_unique(Parsed, 4, Out).

part2(In, Out):-
    parse_input(In, Parsed),
    first_n_unique(Parsed, 14, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    Path = "2022/06/input.txt",
    read_file(Path, In),
    findall(X, sample(X), Samples),

    maplist([X, X-Sol]>>part1(X, Sol), Samples, Sol1),
    print("solutions for part 1 samples "), print(Sol1), nl,
    part1(In, Out1), print(Out1), nl,

    maplist([X, X-Sol]>>part2(X, Sol), Samples, Sol2), nl,
    print("solutions for part 2 samples "), print(Sol2), nl,
    part2(In, Out2), print(Out2), nl.
