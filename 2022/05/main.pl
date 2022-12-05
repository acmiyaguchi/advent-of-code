sample("    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2").

contains_brackets(Str):-
    string_chars(Str, Chars),
    member('[', Chars),
    member(']', Chars).

partition(_, [], Out, Out).
partition(N, List, Acc, Out):-
    append(Left, Right, List),
    length(Left, N),
    append(Acc, [Left], Acc1),
    partition(N, Right, Acc1, Out).

get_block_position([], _, Acc, Acc).
get_block_position([H|T], Col, Acc, Out):-
    H = ['[', Block, ']', _],
    append(Acc, [Col-Block], Acc1),
    Col1 is Col + 1,
    get_block_position(T, Col1, Acc1, Out).
get_block_position([_|T], Col, Acc, Out):-
    Col1 is Col + 1,
    get_block_position(T, Col1, Acc, Out).

% for each column, iterate over each list and see if there's a matching entry
key_in_row(Index, Row):- member(Index-_, Row).
value_from_row(Index, Row, Value):- member(Index-Value, Row).

build_stack(Lists, Index, Out):-
    include(key_in_row(Index), Lists, Valid),
    maplist(value_from_row(Index), Valid, Out).

zip([], [], []).
zip([H1|T1], [H2|T2], [H1-H2|T3]):-
    zip(T1, T2, T3).

parse_stacks(Lines, Out):-
    % add a space to the end of each bracket line
    maplist([Line, Normed]>>string_concat(Line, " ", Normed), Lines, Normed),
    maplist([Line, Parts]>>(
            string_chars(Line, Chars),
            partition(4, Chars, [], Parts)
        ),
        Normed, BracketLinesSplit
    ),
    maplist([Line, Crates]>>get_block_position(Line, 1, [], Crates), BracketLinesSplit, Crates),
    reverse(Crates, CratesReversed),
    % get the size of the largest list
    maplist(length, Crates, Lengths),
    max_list(Lengths, N),
    % create a list of numbers between 1 and N
    findall(X, between(1, N, X), Indexes),
    sort(Indexes, SortedIndexes),
    maplist(build_stack(CratesReversed), SortedIndexes, Stacks),
    zip(SortedIndexes, Stacks, Pairs),
    list_to_assoc(Pairs, Out).


parse_move(Lines, Out):-
    maplist([Line, [Q,From,To]]>>(
        split_string(Line, " ", "", [_, X, _, Y, _, Z]),
        number_string(Q, X),
        number_string(From, Y),
        number_string(To, Z)
    ), Lines, Out).

parse_input(In, Stacks-Moves):-
    % split newlines
    split_string(In, "\n", "", Split),
    % get lines that contain brackets
    include(contains_brackets, Split, BracketLines),

    % get the rest of the configuration
    append(Head, MoveLines, Split),
    length(BracketLines, NBracket),
    NHead is NBracket + 2,
    length(Head, NHead),

    % parse the lines
    parse_stacks(BracketLines, Stacks),
    parse_move(MoveLines, Moves).


move_blocks([], State, State).
move_blocks([[Q,From,To]|Moves], State, Out):-
    % length(Moves, Depth),
    % format("Depth: ~w~n", [Depth]),
    % format("move ~w from ~w to ~w~n", [Q, From, To]),

    get_assoc(From, State, FromStack),
    get_assoc(To, State, ToStack),

    % print stacks
    % format("From: ~w~n", [FromStack]),
    % format("To: ~w~n", [ToStack]),

    % move Q blocks from From to To
    length(Top, Q),
    append(NewFromStack, Top, FromStack),
    reverse(Top, TopRev),
    append(ToStack, TopRev, NewToStack),

    put_assoc(From, State, NewFromStack, State1),
    put_assoc(To, State1, NewToStack, State2),

    move_blocks(Moves, State2, Out).

part1(In, Out):-
    parse_input(In, Stacks-Moves),
    !,
    print(Stacks),nl,
    % Out = Stacks-Moves.
    move_blocks(Moves, Stacks, Result),
    % get the top of the stack
    assoc_to_values(Result, ResultValues),
    include([Elem]>>(length(Elem, N), N > 0), ResultValues, Valid),
    maplist([Stack, Top]>>last(Stack, Top), Valid, Tops),
    string_chars(Out, Tops).

part2(In, Out):-
    part1(In, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = true,
    Path = "2022/05/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    % trace(move_blocks, +fail),
    part1(In, Out1), print(Out1), nl.
    % part2(In, Out2), print(Out2), nl.
