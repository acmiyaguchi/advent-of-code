sample("7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9").

parse_line(Line, Out):-
    split_string(Line, "\s", "\s", Split),
    maplist(atom_number, Split, Out).

parse_input(In, Out):-
    split_string(In, "\n", "", Split),
    maplist(parse_line, Split, Out).

% base
monotonically_increasing_safely(_,_,[_]).
% safe
monotonically_increasing_safely(ToleratedErrors, P, [A,B|T]):-
    A < B,
    abs(A-B) =< 3,
    abs(A-B) >= 1,
    append(P, [A], PPrime),
    monotonically_increasing_safely(ToleratedErrors, PPrime, [B|T]).
% tolerate an error by dropping the current element
monotonically_increasing_safely(ToleratedErrors, P, [A,_|T]):-
    ToleratedErrorsPrime is ToleratedErrors - 1,
    ToleratedErrorsPrime >= 0,
    % new list with current element dropped
    append(P, [A|T], Dropped),
    (
        monotonically_increasing_safely(ToleratedErrorsPrime, [], Dropped);
        monotonically_decreasing_safely(ToleratedErrorsPrime, [], Dropped)
    ).
monotonically_increasing_safely(ToleratedErrors, P, [_,A|T]):-
    ToleratedErrorsPrime is ToleratedErrors - 1,
    ToleratedErrorsPrime >= 0,
    % new list with current element dropped
    append(P, [A|T], Dropped),
    (
        monotonically_increasing_safely(ToleratedErrorsPrime, [], Dropped);
        monotonically_decreasing_safely(ToleratedErrorsPrime, [], Dropped)
    ).
monotonically_increasing_safely(Tol, L):-
    monotonically_increasing_safely(Tol, [], L).

monotonically_decreasing_safely(_,_,[_]).
monotonically_decreasing_safely(ToleratedErrors, P, [A,B|T]):-
    A > B,
    abs(A-B) =< 3,
    abs(A-B) >= 1,
    append(P, [A], PPrime),
    monotonically_decreasing_safely(ToleratedErrors, PPrime, [B|T]).
monotonically_decreasing_safely(ToleratedErrors, P, [A,_|T]):-
    ToleratedErrorsPrime is ToleratedErrors - 1,
    ToleratedErrorsPrime >= 0,
    % new list with current element dropped
    append(P, [A|T], Dropped),
    (
        monotonically_increasing_safely(ToleratedErrorsPrime, [], Dropped);
        monotonically_decreasing_safely(ToleratedErrorsPrime, [], Dropped)
    ).
monotonically_decreasing_safely(ToleratedErrors, P, [_,A|T]):-
    ToleratedErrorsPrime is ToleratedErrors - 1,
    ToleratedErrorsPrime >= 0,
    % new list with current element dropped
    append(P, [A|T], Dropped),
    (
        monotonically_increasing_safely(ToleratedErrorsPrime, [], Dropped);
        monotonically_decreasing_safely(ToleratedErrorsPrime, [], Dropped)
    ).
monotonically_decreasing_safely(Tol, L):-
    monotonically_decreasing_safely(Tol, [], L).

part1(In, Out):-
    parse_input(In, Levels),
    include([L]>>(
        (
            monotonically_increasing_safely(0, L);
            monotonically_decreasing_safely(0, L)
        )
    ), Levels, Valid),
    length(Valid, Out).

part2(In, Out):-
    parse_input(In, Levels),
    include([L]>>(
        (
            monotonically_increasing_safely(1, L);
            monotonically_decreasing_safely(1, L)
        )
    ), Levels, Valid),
    % print(Valid), nl,
    length(Valid, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = true,
    Path = "2024/02/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    % parse_input(In, Out), print(Out).
    part1(In, Out1), print(Out1), nl,
    part2(In, Out2), print(Out2), nl.
