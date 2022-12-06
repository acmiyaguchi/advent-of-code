sample("bvwbjplbgvbhsrlpgdmjqwftvncz").
sample("nppdvjthqldpwncqszvftbrmjlhg").
sample("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").
sample("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").

parse_input(In, Out):-
    string_chars(In, Out).

first_n_unique([], Index, Index).
first_n_unique([A,B,C,D|T], Index, Index):-
    list_to_set([A,B,C,D], Set),
    length(Set, 4).
first_n_unique([_|T], Index, Out):-
    % length(T, NT), print(NT), nl,
    Index1 is Index + 1,
    first_n_unique(T, Index1, Out).


part1(In, Out):-
    parse_input(In, Parsed),
    first_n_unique(Parsed, 4, Out).

part2(In, Out):-
    part1(In, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    Path = "2022/06/input.txt",
    read_file(Path, In),
    findall(X, sample(X), Samples),
    maplist([X, X-Sol]>>part1(X, Sol), Samples, Sol1),
    print("solutions for part 1 samples "), print(Sol1), nl,
    part1(In, Out1), print(Out1), nl.
    % part2(In, Out2), print(Out2), nl.
