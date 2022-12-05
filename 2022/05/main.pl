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
    length(Crates, N),
    % create a list of numbers between 1 and N
    findall(X, between(1, N, X), Indexes),
    sort(Indexes, SortedIndexes),
    maplist(build_stack(CratesReversed), SortedIndexes, Out).

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
    nth1(From, State, FromStack),
    nth1(To, State, ToStack),

    % move Q blocks from From to To
    append(NewFromStack, TopFromStack, FromStack),
    length(TopFromStack, Q),
    reverse(TopFromStack, TopFromStackReversed),
    append(ToStack, TopFromStackReversed, NewToStack),
    !,

    % now create a new state from the old state by replacing these two elements
    length(NewState, N),
    length(State, N),
    nth1(From, NewState, NewFromStack),
    nth1(To, NewState, NewToStack),
    % also copy over the state from Stacks
    findall(X, between(1, N, X), Indexes),
    subtract(Indexes, [From, To], OtherIndexes),
    sort(OtherIndexes, SortedIndexes),
    !,

    maplist({State, NewState}/[I]>>(
        nth1(I, State, Entry),
        nth1(I, NewState, Entry)
    ), SortedIndexes),
    !,
    move_blocks(Moves, NewState, Out).

part1(In, Out):-
    parse_input(In, Stacks-Moves),
    move_blocks(Moves, Stacks, Out).
    % get the top of the stack
    % maplist(reverse, State, Reversed),
    % include([Elem]>>(length(Elem, N), N > 0), Reversed, Stacks),
    % maplist([Stack, Top]>>nth1(1, Stack, Top), Stacks, Tops),
    % string_chars(Out, Tops).

part2(In, Out):-
    part1(In, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = true,
    Path = "2022/05/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    part1(In, Out1), print(Out1), nl.
    % part2(In, Out2), print(Out2), nl.
