# 09-product-n

Read N, then N integers on the next line. Print their product modulo 1000000007.

1 ≤ N ≤ 100000.
Integers: 0 to 10^9.
Time limit: 2 seconds per test.

Use `long long` for arithmetic.

Use `% 1000000007` after every multiplication.

Start with `answer = 1`.

```cpp
answer = (answer * value) % 1000000007LL;
```

Example Input:
```text
3
1000000000 2 3
```

Example Output:
```text
999999965
```
