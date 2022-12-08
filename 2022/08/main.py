"""And here's the first solution done in python because the prolog problem was
too difficult to set up. This solution had quite a few hiccups too, even though
I'm fairly comfortable with python."""
import numpy as np

sample = """30373
25512
65332
33549
35390"""


def parse(data):
    res = []
    for line in data.strip().split():
        res.append([int(x) for x in line])
    return np.array(res)


def part1(data):
    X = parse(data)
    print(X)
    n, m = X.shape

    mask = np.zeros((n, m), dtype=int)

    def check_row(i, ks):
        ks = list(ks)
        mask[i][ks[0]] = 1
        for k in range(1, len(ks)):
            j = ks[k]
            prev_max = max(X[i][ks[:k]])
            if X[i][j] > prev_max:
                mask[i][j] = 1

    def check_cols(j, ks):
        ks = list(ks)
        mask[ks[0]][j] = 1
        for k in range(1, len(ks)):
            i = ks[k]
            prev_max = max(X[ks[:k], j])
            if X[i][j] > prev_max:
                mask[i][j] = 1

    for i in range(n):
        check_cols(i, range(m))
        check_cols(i, reversed(range(m)))
    for j in range(m):
        check_row(j, range(n))
        check_row(j, reversed(range(n)))

    mask = np.array(mask)
    print(mask)
    print(mask.sum())


def compute_score(X, i, j):
    # how far can you see going in each direction
    n, m = X.shape
    if i == 0 or j == 0 or i == n - 1 or j == m - 1:
        return 0
    h = X[i, j]
    # scores = np.array([m - j, j, n - i, i])
    scores = np.ones(4, dtype=int)
    for k in range(j + 1, m):
        scores[0] = k - j
        if X[i, k] >= h:
            break
    for k in range(j - 1, -1, -1):
        scores[1] = j - k
        if X[i, k] >= h:
            break
    for k in range(i + 1, n):
        scores[2] = k - i
        if X[k, j] >= h:
            break
    for k in range(i - 1, -1, -1):
        scores[3] = i - k
        if X[k, j] >= h:
            break
    return np.prod(np.array(scores))


def part2(data):
    X = parse(data)
    n, m = X.shape
    scores = np.zeros((n, m), dtype=int)
    for i in range(n):
        for j in range(m):
            scores[i, j] = compute_score(X, i, j)
    print(X)
    print(scores)
    print(scores.max())


if __name__ == "__main__":
    print("part 1 sample")
    part1(sample)
    print("part 1 input")
    part1(open("input.txt").read())
    print("part 2 sample")
    part2(sample)
    print("part 2 input")
    part2(open("input.txt").read())
