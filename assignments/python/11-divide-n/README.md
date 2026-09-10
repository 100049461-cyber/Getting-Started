# 11-divide-n

Read N, then N integers on the next line. Divide from left to right, rounding down after each step.

1 ≤ N ≤ 100000.
Integers: 0 ≤ first ≤ 10^9; 1 ≤ remaining values ≤ 10^9.
Time limit: 2 seconds per test.

Use `a // b`. Example: `7 // 2 = 3`.

Compute `floor(floor(a1 / a2) / a3) ...`. For N = 1, print a1.

Example Input:
```text
3
100 3 2
```

Example Output:
```text
16
```
