#ifndef CATALOG_H
#define CATALOG_H

enum { PYTHON, C, CPP, JAVA, LANGUAGE_COUNT };
enum { ECHO, REVERSE_TWO, REVERSE_N, SUM_TWO, SUM_N,
       MODULO_TWO, MODULO_N, PRODUCT_TWO, PRODUCT_N, DIVIDE_TWO, DIVIDE_N, ASSIGNMENT_COUNT };

typedef struct {
    const char *name;
    const char *source;
    const char *flag;
    int time_ms;
} Language;

typedef struct {
    const char *name;
    const char *description;
    const char *example_input;
    const char *example_output;
    int n_values;
} Assignment;

static const Language languages[] = {
    {"python", "main.py", "py", 2000},
    {"c", "main.c", "c", 2000},
    {"cpp", "main.cpp", "cpp", 2000},
    {"java", "Main.java", "java", 4000}
};

static const Assignment assignments[] = {
    {"01-echo", "Read one integer. Print it.", "7\n", "7\n", 0},
    {"02-reverse-two", "Read two integers. Print them in reverse order.", "1 2\n", "2 1\n", 0},
    {"03-reverse-n", "Read N, then N integers on the next line. Print them in reverse order.", "5\n1 2 3 4 5\n", "5 4 3 2 1\n", 1},
    {"04-sum-two", "Read two integers. Print their sum.", "3 5\n", "8\n", 0},
    {"05-sum-n", "Read N, then N integers on the next line. Print their sum.", "4\n1 2 3 4\n", "10\n", 1},
    {"06-modulo-two", "Read two integers. Print the remainder when the first is divided by the second.", "17 5\n", "2\n", 0},
    {"07-modulo-n", "Read N, then N integers on the next line. Apply modulo from left to right.", "3\n100 30 7\n", "3\n", 1},
    {"08-product-two", "Read two integers. Print their product modulo 1000000007.", "1000000000 2\n", "999999993\n", 0},
    {"09-product-n", "Read N, then N integers on the next line. Print their product modulo 1000000007.", "3\n1000000000 2 3\n", "999999965\n", 1},
    {"10-divide-two", "Read two integers. Print the first divided by the second, rounded down.", "7 2\n", "3\n", 0},
    {"11-divide-n", "Read N, then N integers on the next line. Divide from left to right, rounding down after each step.", "3\n100 3 2\n", "16\n", 1}
};

#define TEST_COUNT 20
#define OUTPUT_LIMIT (4 * 1024 * 1024)
#endif
