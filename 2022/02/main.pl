% Prolog ended up being a really good fit for this problem, due to all the
% constraints involved. Part A took me 20 minutes, while part B took me 5.
% Nothing particularly tricky here.

sample("A Y
B X
C Z").

parse_input(In, Out):-
    split_string(In, "\n", "", Split),
    maplist([A, X-Y]>>split_string(A, " ", "", [X, Y]), Split, Out).

rock("A").
rock("X").
paper("B").
paper("Y").
scissors("C").
scissors("Z").

% conditions when playing rock paper scissors
win(A, B):- rock(A), scissors(B).
win(A, B):- paper(A), rock(B).
win(A, B):- scissors(A), paper(B).

draw(A, B):- rock(A), rock(B).
draw(A, B):- paper(A), paper(B).
draw(A, B):- scissors(A), scissors(B).

% figure out what the value of each element is
score(In, 1):- rock(In).
score(In, 2):- paper(In).
score(In, 3):- scissors(In).

% part 1: B is the play we need to make
% lose is 0, draw is 3, win is 6
play(A-B, Res):-
    win(B, A),
    score(B, Value),
    Res is Value + 6.
play(A-B, Res):-
    draw(A, B),
    score(B, Value),
    Res is Value + 3.

% fall through when losing
play(A-B, Res):- score(B, Res).

% part 2: B is the outcome we need
play2(A-"X", Res):-
    % we need to lose
    win(A, Play),
    score(Play, Value),
    Res is Value.
play2(A-"Y", Res):-
    % we need a draw
    draw(Play, A),
    score(Play, Value),
    Res is Value + 3.
play2(A-"Z", Res):-
    % we need to win
    win(Play, A),
    score(Play, Value),
    Res is Value + 6.

part1(In, Out):-
    parse_input(In, Strategy),
    maplist(play, Strategy, Scores),
    % print(Scores), nl,
    sum_list(Scores, Out).

part2(In, Out):-
    parse_input(In, Strategy),
    maplist(play2, Strategy, Scores),
    % print(Scores), nl,
    sum_list(Scores, Out).

:-
    UseInput = true,
    (UseInput ->
        open("2022/02/input.txt", read, Str),
        read_string(Str, _, In),
        close(Str)
    ;
        sample(In)
    ),
    part1(In, Out1),
    print(Out1), nl,
    part2(In, Out2),
    print(Out2).
