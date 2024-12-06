sample = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
""".strip()

MARKERS = ["^", ">", "v", "<"]


def parse_input(input):
    """Convert into a 2D array that we can traverse"""
    return [list(line) for line in input.split("\n")]


def find_start(grid):
    for y, row in enumerate(grid):
        for x, cell in enumerate(row):
            if cell in MARKERS:
                return (x, y)
    raise ValueError("No starting point found")


def orientation(marker):
    if marker == "^":
        return (0, -1)
    elif marker == "v":
        return (0, 1)
    elif marker == "<":
        return (-1, 0)
    elif marker == ">":
        return (1, 0)


def rotate(marker):
    cur = MARKERS.index(marker)
    return MARKERS[(cur + 1) % 4]


def inbounds(grid, pos):
    x, y = pos
    return x >= 0 and x < len(grid[0]) and y >= 0 and y < len(grid)


def traverse(grid, pos):
    while True:
        x, y = pos
        # check if we are out of bounds
        if not inbounds(grid, pos):
            return grid
        marker = grid[y][x]
        grid[y][x] = "X"

        dx, dy = orientation(marker)
        # check if we go out of bounds
        if not inbounds(grid, (y + dy, x + dx)):
            return grid

        if grid[y + dy][x + dx] == "#":
            # rotate orientation to the right
            marker = rotate(marker)
            dx, dy = orientation(marker)

        grid[y + dy][x + dx] = marker
        pos = (x + dx, y + dy)


def count_elements(grid, element):
    return sum(row.count(element) for row in grid)


def solve1(input):
    """Count all possible positions"""
    grid = parse_input(input)
    start = find_start(grid)
    grid = traverse(grid, start)
    print(count_elements(grid, "X"))


if __name__ == "__main__":
    input = open("2024/06/input.txt").read().strip()
    solve1(sample)
    solve1(input)
