#!/bin/sh
set -eu
repo=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd -P)
scratch=$(mktemp -d "${TMPDIR:-/tmp}/getting-started-tests.XXXXXX")
trap 'code=$?; if [ "$code" -eq 0 ]; then rm -rf "$scratch"; else printf "Test files: %s\n" "$scratch"; fi' EXIT
trap 'exit 130' HUP INT TERM
student="$scratch/student repo"
mkdir -p "$student" "$scratch/bin"
cp -R "$repo/assignments" "$repo/grader" "$repo/testcases" "$student/"
cp "$repo/getting_started" "$student/"
ln -s "$student/getting_started" "$scratch/bin/getting_started"
PATH="$scratch/bin:$PATH"
export PATH
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
export GIT_TERMINAL_PROMPT=0
unset GITHUB_STEP_SUMMARY
cd "$student"

count=0
expect() {
    wanted=$1
    text=$2
    shift 2
    code=0
    "$@" > "$scratch/log" 2>&1 || code=$?
    if [ "$code" -ne "$wanted" ] || ! grep -Fq -- "$text" "$scratch/log"; then
        printf 'FAIL: expected exit %s and %s: %s\n' "$wanted" "$text" "$*"
        cat "$scratch/log"
        exit 1
    fi
    count=$((count + 1))
}

# No GitHub calls in tests. Actual commits/pushes target only the local bare repo.
cat > "$scratch/bin/gh" <<'SH'
#!/bin/sh
if [ "${GS_TEST_OFFLINE:-0}" = 1 ]; then exit 1; fi
printf '%s\t%s\n' "${GS_TEST_STATUS:-in_progress}" "${GS_TEST_CONCLUSION:-}"
SH
chmod +x "$scratch/bin/gh"

expect 2 'getting_started' getting_started
expect 2 'Choose a language' getting_started -rust list
expect 2 'Unknown assignment' getting_started -c start missing
expect 2 'Invalid submission marker' getting_started --ci 'Submit: c/../../etc/passwd'
expect 2 'Invalid submission marker' getting_started --ci 'Submit: c/01-echo extra'
expect 2 'getting_started' getting_started -py list extra
for alias in py p python c cpp cc 'c++' java; do
    expect 0 '. 01-echo' getting_started "-$alias" -list
done
expect 0 '. 11-divide-n' getting_started -py
expect 0 'already been filled' getting_started -c start next
expect 0 '* 01-echo' getting_started -c list
cp assignments/c/01-echo/main.c "$scratch/original.c"
expect 0 'Edit:' getting_started -c -start 01-echo
cmp assignments/c/01-echo/main.c "$scratch/original.c"
cd assignments/c/01-echo
expect 0 '. 02-reverse-two' getting_started -c list
cd "$student"
printf '// work in progress\n' >> assignments/c/02-reverse-two/main.c
expect 0 '* 02-reverse-two' getting_started -c list

cc -std=c11 -Wall -Wextra -Werror "$repo/tests/check_cases.c" -o "$scratch/check-cases"
"$scratch/check-cases"

# Every provided example and every exercise's correct solution, in all four languages.
for language in python c cpp java; do
    case "$language" in
        python) file=main.py;; c) file=main.c;; cpp) file=main.cpp;; java) file=Main.java;;
    esac
    expect 0 '20/20 tests' getting_started --ci "Submit: $language/01-echo"
    expect 0 'Sample correct.' getting_started "-$language" -run 01-echo
    op=0
    for assignment in assignments/"$language"/*; do
        name=${assignment##*/}
        sed "s/@OP@/$op/g" "$repo/tests/reference/$file" > "$assignment/$file"
        expect 0 '20/20 tests' getting_started --ci "Submit: $language/$name"
        op=$((op + 1))
    done
    printf '%s: 11 assignments × 20 cases passed.\n' "$language"
done

# Check that modern syntax reaches the requested language modes.
cat > assignments/c/01-echo/main.c <<'C'
#include <stdio.h>
#if __STDC_VERSION__ < 202400L
#error Expected the C2y draft
#endif
int main(void) { auto value = 0; scanf("%d", &value); printf("%d\n", value); }
C
expect 0 'Sample correct.' getting_started -c run 01-echo
cat > assignments/cpp/01-echo/main.cpp <<'CPP'
#include <iostream>
#if __cplusplus < 202400L || defined(__STRICT_ANSI__)
#error Expected GNU C++26
#endif
template<typename... Types> using First = Types...[0];
int main() { First<int, double> value; std::cin >> value; std::cout << value << '\n'; }
CPP
expect 0 'Sample correct.' getting_started -cpp run 01-echo
cat > assignments/java/01-echo/Main.java <<'JAVA'
void main() {
    if (Runtime.version().feature() != 26) throw new RuntimeException("Expected Java 26");
    var scanner = new java.util.Scanner(System.in);
    System.out.println(scanner.nextInt());
}
JAVA
expect 0 'Sample correct.' getting_started -java run 01-echo
cat > assignments/python/01-echo/main.py <<'PY'
value = int(input())
template = t"{value}"
print(template.interpolations[0].value)
PY
expect 0 'Sample correct.' getting_started -py run 01-echo

# Distinguish wrong answer, compile error, runtime error, timeout, and excessive output.
cat > assignments/c/01-echo/main.c <<'C'
#include <stdio.h>
int main(void) { puts("123"); }
C
expect 1 'WA c/01-echo' getting_started --ci 'Submit: c/01-echo'
expect 1 'Sample failed: WA' getting_started -c run 01-echo
cat > assignments/c/01-echo/main.c <<'C'
#include <stdio.h>
int main(void) { puts("7"); }
C
expect 0 'Sample correct.' getting_started -c run 01-echo
expect 1 'WA c/01-echo' getting_started --ci 'Submit: c/01-echo'
printf 'broken C code\n' > assignments/c/01-echo/main.c
expect 1 'CE c/01-echo' getting_started --ci 'Submit: c/01-echo'
printf 'int main(void) {return 7;}\n' > assignments/c/01-echo/main.c
expect 1 'RE c/01-echo' getting_started --ci 'Submit: c/01-echo'
printf 'int main(void) {for (;;) {}}\n' > assignments/c/01-echo/main.c
expect 1 'TLE c/01-echo' getting_started --ci 'Submit: c/01-echo'
cat > assignments/c/01-echo/main.c <<'C'
#include <stdio.h>
int main(void) {for (int i = 0; i < 5000000; i++) putchar('x');}
C
expect 1 'OLE c/01-echo' getting_started --ci 'Submit: c/01-echo'
cp "$scratch/original.c" assignments/c/01-echo/main.c
rm testcases/01-echo/20.out
expect 1 'Missing test case 20' getting_started --ci 'Submit: c/01-echo'
cp "$repo/testcases/01-echo/20.out" testcases/01-echo/20.out

# A quadratic reversal must time out on the checked-in large cases.
cat > assignments/c/03-reverse-n/main.c <<'C'
#include <stdio.h>
#include <stdlib.h>
int main(void) {
    int n;
    if (scanf("%d", &n) != 1) return 1;
    int *a = malloc((size_t)n * sizeof(int));
    for (int i = 0; i < n; i++) {
        int value;
        if (scanf("%d", &value) != 1) return 1;
        for (volatile int j = i; j > 0; j--) a[j] = a[j - 1];
        a[0] = value;
    }
    for (int i = 0; i < n; i++) printf("%d ", a[i]);
    free(a);
}
C
expect 1 'TLE c/03-reverse-n' getting_started --ci 'Submit: c/03-reverse-n'

# Reset learner files, then exercise the actual git transaction and progress recovery.
rm -rf assignments .getting_started
cp -R "$repo/assignments" .
git init -q -b main
git config user.name 'Grader Test'
git config user.email 'grader@example.invalid'
git config commit.gpgsign false
git add assignments grader testcases
git commit -qm 'Initial assignments'
git init -q --bare "$scratch/origin.git"
git remote add origin "$scratch/origin.git"
printf 'unrelated staged file\n' > unrelated.txt
git add unrelated.txt
expect 0 'Submitted c/01-echo' getting_started -c submit 01-echo
test "$(git log -1 --format=%s)" = 'Submit: c/01-echo'
test "$(git diff --cached --name-only)" = unrelated.txt
test "$(git --git-dir="$scratch/origin.git" rev-parse refs/heads/main)" = "$(git rev-parse HEAD)"
expect 0 '* 01-echo' getting_started -c list
GS_TEST_STATUS=completed GS_TEST_CONCLUSION=success
export GS_TEST_STATUS GS_TEST_CONCLUSION
expect 0 '✓ 01-echo' getting_started -c list
expect 0 '02-reverse-two' getting_started -c start next
printf '\n// edited\n' >> assignments/c/01-echo/main.c
expect 0 '* 01-echo' getting_started -c list
expect 0 'Submitted c/01-echo' getting_started -c -submit 01-echo
GS_TEST_CONCLUSION=failure
export GS_TEST_CONCLUSION
expect 0 'x 01-echo' getting_started -c list
rm -rf .getting_started
expect 0 'x 01-echo' getting_started -c list
GS_TEST_OFFLINE=1
export GS_TEST_OFFLINE
expect 0 'x 01-echo' getting_started -c list
unset GS_TEST_OFFLINE
GS_TEST_CONCLUSION=success
export GS_TEST_CONCLUSION
expect 0 '✓ 01-echo' getting_started -c list
# A changed source is the only path in the submission commit.
test "$(git diff-tree --no-commit-id --name-only -r HEAD)" = assignments/c/01-echo/main.c
test "$(git diff --cached --name-only)" = unrelated.txt

# Failed pushes leave a retryable submission commit.
git remote set-url origin "$scratch/missing.git"
expect 1 'Your commit is saved' getting_started -c submit 01-echo
test "$(git log -1 --format=%s)" = 'Submit: c/01-echo'

printf 'PASS: %s integration checks; 880 solution cases + 80 starter cases; local commit/push/status flow.\n' "$count"
