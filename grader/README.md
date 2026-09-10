# Maintainer notes

The CLI and grader are C. No Python packages required.

`run NAME` compiles locally and compares against case 01 (the README sample).
It never commits, pushes, or marks an assignment complete.

`submit` commits only the chosen solution, then runs `git push --set-upstream origin HEAD`.
The subject is `Submit: LANGUAGE/ASSIGNMENT`. The push workflow grades only that assignment.
Unchanged solutions can be resubmitted. A failed push preserves the commit for retry.

`list` reads submission commits and GitHub Actions results through `gh`.
Progress is cached in ignored `.getting_started/`; fresh clones recover it from Git history.
Edits after a submission show `*`. Unavailable GitHub results keep the saved status.

Twenty fixed cases per assignment live in `testcases/`, shared across languages.
They include examples, seeded random data, edge cases, and N = 100000.
Student commands and CI never generate tests.

Limits: 2 seconds per test (Java: 4), 30 seconds to compile, 4 MiB output.
Whitespace is ignored; other output must match exactly. Children are killed on timeout.
Verdicts: AC, WA, TLE, RE, CE, OLE. GitHub's run log gives details.

The Dockerfile is shared by Codespaces and CI: GCC 16, Java 26, latest stable Python at image build.
C uses `-std=c2y`; C++ uses `-std=gnu++26`. Standard support depends on GCC's implementation.
Java uses `--release 26 --enable-preview`. Rebuild the container to update Python.
For local grading, install matching runtimes; `gcc-16`/`g++-16` are preferred when present.

```sh
make test                              # isolated, including a local Git remote
./getting_started --ci 'Submit: c/01-echo'  # grade locally without pushing
make fixtures                          # regenerate fixed tests + READMEs; preserve solutions
```

Add exercises in `catalog.h`, extend `tools/generate.c`, then run `make fixtures`.
Commit the resulting files. Language time limits live in `catalog.h`.

References: [GCC standards](https://gcc.gnu.org/onlinedocs/gcc/Standards.html),
[C++26 support](https://gcc.gnu.org/projects/cxx-status.html),
[GitHub run queries](https://cli.github.com/manual/gh_run_list).
