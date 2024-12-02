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

gt(A,B):- A > B.
lt(A,B):- A < B.

% base
safe(_,_,_,[_]).
% safe
safe(Op, Tol, P, [A,B|T]):-
    apply(Op, [A, B]),
    abs(A-B) =< 3,
    abs(A-B) >= 1,
    append(P, [A], PPrime),
    safe(Op, Tol, PPrime, [B|T]).
% tolerate an error by dropping the current element
safe(_, Tol, P, [A,B|T]):-
    TolP is Tol - 1,
    TolP >= 0,
    append(P, [A|T], DropA),
    append(P, [B|T], DropB),
    (
        safe(gt, TolP, [], DropA);
        safe(lt, TolP, [], DropA);
        safe(gt, TolP, [], DropB);
        safe(lt, TolP, [], DropB)
    ).
safe(Pred, Tol, L):-
    safe(Pred, Tol, [], L).
safe(Pred, L):-
    safe(Pred, 0, L).

part1(In, Out):-
    parse_input(In, Levels),
    include([L]>>(safe(lt, L); safe(gt, L)), Levels, Valid),
    length(Valid, Out).

part2(In, Out):-
    parse_input(In, Levels),
    include([L]>>(safe(lt, 1, L); safe(gt, 1, L)), Levels, Valid),
    length(Valid, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = true,
    Path = "2024/02/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    % parse_input(In, Out), print(Out).
    part1(In, Out1), print(Out1), nl,
    part2(In, Out2), print(Out2), nl.
