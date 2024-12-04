%% NOTE: incomplete
sample("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))").

mul(Input, Out):-
    % mul(A, B)
    string_concat("mul(", Rest, Input),
    string_concat(TermString, ")", Rest),
    split_string(TermString, ",", "", Terms),
    maplist(atom_number, Terms, [A, B]),
    Out is A * B.

char_mul(Input, Out):-
    string_chars(Input, Chars),
    mul(Chars, Out).

% scan([], _, Acc, Acc).
% % do the test and move along
% scan(Input, Test, Acc, Out):-
%     string_chars(TestString, Test),
%     mul(TestString, Res),
%     AccP is Acc + Res,
%     scan(Input, [], AccP, Out).
% % remove from the front of our test string
% scan(Input, [_|Test], Acc, Out):-
%     scan(Input, Test, Acc, Out).
% % no match, move along
% scan(Input, _, Acc, Out):- scan(Input, [], Acc, Out).
% % add to the back of our test string
% scan([H|T], Test, Acc, Out):-
%     append(Test, [H], TestP),
%     scan(T, TestP, Acc, Out).

scan([], _, Acc, Acc).
scan([m|T], _, Acc, Out):-
    scan(T, [m], Acc, Out).
scan([H|T], Test, Acc, Out):-
    H = ")",
    append(Test, [H], TestP),
    (
    char_mul(TestP, Res) ->
        (
            AccP is Acc + Res,
            scan(T, [], AccP, Out)
        );
        scan(T, [], Acc, Out)
    ).
scan([H|T], Test, Acc, Out):-
    append(Test, [H], TestP),
    scan(T, TestP, Acc, Out).

% wrapper
scan(Input, Out):-
    string_chars(Input, Chars),
    scan(Chars, [], 0, Out).

% tests
scan("mul(2,2)", 4).
scan("xmul(2,2)", 4).
scan("mul(2,2)x", 4).
scan("m(2,2)", 0).

part1(In, Out):-
    scan(In, Out).

% part2(In, Out):-
%     parse_input(In, Levels),
%     include([L]>>(safe(lt, 1, L); safe(gt, 1, L)), Levels, Valid),
%     length(Valid, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = false,
    Path = "2024/03/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    % parse_input(In, Out), print(Out).
    part1(In, Out1), print(Out1), nl.
    % part2(In, Out2), print(Out2), nl.
