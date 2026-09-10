import sys
from functools import reduce

op = @OP@
values = list(map(int, sys.stdin.read().split()))
if op in (2, 4, 6, 8, 10):
    values = values[1:]

if op in (1, 2):
    print(*values[::-1])
elif op in (3, 4):
    print(sum(values))
elif op in (5, 6):
    print(reduce(lambda a, b: a % b, values))
elif op in (7, 8):
    print(reduce(lambda a, b: a * b % 1000000007, values))
elif op in (9, 10):
    print(reduce(lambda a, b: a // b, values))
else:
    print(values[0])
