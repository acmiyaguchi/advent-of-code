sample("30373
25512
65332
33549
35390").

parse_input(In, Out):-
    split_string(In, "\n", "", Lines),
    maplist([Line, Nums]>>(
        string_chars(Line, Elements),
        maplist(atom_number, Elements, Nums)
    ), Lines, Out).

convert_row_to_assoc(Row, Out):-
    findall(K-V, nth0(K, Row, V), Pairs),
    keysort(Pairs, Sorted),
    list_to_assoc(Sorted, Out).

convert_to_assoc(Grid, Out):-
    findall(K-V, nth0(K, Grid, V), Pairs),
    keysort(Pairs, Sorted),
    maplist([K-Row, K-A]>>(convert_row_to_assoc(Row, A)), Sorted, Out).

grid_size(Grid, N-M):-
    assoc_to_keys(Grid, Keys),
    length(Keys, N),
    get_assoc(0, Grid, Row),
    assoc_to_keys(Row, RowKeys),
    length(RowKeys, M).

% get_grid(Assoc, I, J, Out):-
%     get_assoc(I, Assoc, Row),
%     get_assoc(J, Row, Out).

% visible(Grid, I, J, Out):-
%     get_grid(Grid, I, J, Height),
%     % get all coords that are adjacent to I-J
%     Offsets = [[1, 0], [0, 1], [-1, 0], [0, -1]],
%     maplist({I, J}/[[OffX, OffY], [X, Y]>>{
%         X is I + OffX,
%         Y is J + OffY
%     }, Offsets, Adjacent),
%     % check if this node is possibly visible from one of the sides
%     includes

get_row(Grid, I, Out):-
    get_assoc(I, Grid, Row),
    assoc_to_list(Row, List),
    keysort(List, Out).

get_col(Grid, J, Out):-
    findall(I-Num, (
        get_assoc(I, Grid, Row),
        get_assoc(J, Row, Num)
    ), List),
    keysort(List, Out).

% find the position of the first element that is not monotonically increasing
changepoint([H1,H2|_], Idx, Idx):- H2 < H1, !.
changepoint([_|T], Idx, Out):- NewIdx is Idx+1, changepoint(T, NewIdx, Out).
changepoint(List, Out):- changepoint(List, 0, Out).

visible_top(Grid, Out):-
    grid_size(Grid, _-M),
    findall(J, between(0, M, J), Js),
    maplist({Grid}/[J, Out]>>get_col(Grid, J, Out), Js, Cols),
    maplist(changepoint, Cols, Out).

part1(In, Out):-
    parse_input(In, Parsed),
    convert_to_assoc(Parsed, Assoc),
    visible_top(Assoc, Out).

part2(In, Out):-
    part1(In, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = false,
    Path = "2022/01/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    part1(In, Out1), print(Out1), nl,
    part2(In, Out2), print(Out2), nl.
