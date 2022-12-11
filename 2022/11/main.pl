sample("Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
  If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1").

% Id, Items, Op, TestCond, ThrowTrue-ThrowFalse
monkey(_, _, _, _, _).

% this must be some of the ugliest code I've written for parsing input
parse_monkey([], Monkey, Monkey).
parse_monkey([Line|T], _, Out):-
    split_string(Line, " ", ":", ["Monkey", Str]),
    number_string(Id, Str),
    Monkey = monkey(Id, _, _, _, _, _),
    parse_monkey(T, Monkey, Out).

parse_monkey([Line|T], monkey(Id, _, _, _, _, _), Out):-
    split_string(Line, ":", " ", ["Starting items", Items]),
    split_string(Items, ",", " ", ItemsList),
    maplist(number_string, ItemsInt, ItemsList),
    Monkey = monkey(Id, ItemsInt, _, _, _, _),
    parse_monkey(T, Monkey, Out).

parse_monkey([Line|T], monkey(Id, ItemsInt, _, _, _, _), Out):-
    split_string(Line, ":", " ", ["Operation", Op]),
    Monkey = monkey(Id, ItemsInt, Op, _, _, _),
    parse_monkey(T, Monkey, Out).

parse_monkey([Line|T], monkey(Id, ItemsInt, Op, _, _, _), Out):-
    split_string(Line, ":", " ", ["Test", Test]),
    split_string(Test, " ", "", ["divisible", "by", Str]),
    number_string(DivInt, Str),
    Monkey = monkey(Id, ItemsInt, Op, DivInt, _),
    parse_monkey(T, Monkey, Out).

parse_monkey([Line|T], monkey(Id, ItemsInt, Op, DivInt, _), Out):-
    split_string(Line, ":", " ", ["If true", ThrowTrue]),
    split_string(ThrowTrue, " ", "", ["throw", "to", "monkey", Str]),
    number_string(ThrowTrueInt, Str),
    Monkey = monkey(Id, ItemsInt, Op, DivInt, ThrowTrueInt-_),
    parse_monkey(T, Monkey, Out).

parse_monkey([Line|T], monkey(Id, ItemsInt, Op, DivInt, ThrowTrueInt-_), Out):-
    split_string(Line, ":", " ", ["If false", ThrowFalse]),
    split_string(ThrowFalse, " ", "", ["throw", "to", "monkey", Str]),
    number_string(ThrowFalseInt, Str),
    Monkey = monkey(Id, ItemsInt, Op, DivInt, ThrowTrueInt-ThrowFalseInt),
    parse_monkey(T, Monkey, Out).

parse_inputs([], Acc, Acc).
parse_inputs(Lines, Acc, Out):-
    length(MonkeyLines, 6),
    append(MonkeyLines, Tail, Lines),
    parse_monkey(MonkeyLines, _, Monkey),
    (Tail = [] -> NewTail = []; Tail = [""|NewTail]),
    append(Acc, [Monkey], NewAcc),
    parse_inputs(NewTail, NewAcc, Out).

parse_input(In, Out):-
    split_string(In, "\n", "", Lines),
    parse_inputs(Lines, [], Out).

part1(In, Out):-
    parse_input(In, Out).

part2(In, Out):-
    part1(In, Out).

read_file(Path, Out):- open(Path, read, Fp), read_string(Fp, _, Out), close(Fp).
:-
    UseInput = false,
    Path = "2022/11/input.txt",
    (UseInput -> read_file(Path, In); sample(In)),
    part1(In, Out1), print(Out1), nl,
    part2(In, Out2), print(Out2), nl.
