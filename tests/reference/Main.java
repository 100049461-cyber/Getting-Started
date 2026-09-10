import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        final int op = @OP@;
        Scanner scanner = new Scanner(System.in);
        boolean many = op == 2 || op == 4 || op == 6 || op == 8 || op == 10;
        int n = many ? scanner.nextInt() : op == 0 ? 1 : 2;
        long[] a = new long[n];
        for (int i = 0; i < n; i++) a[i] = scanner.nextLong();
        if (op == 1 || op == 2) {
            StringBuilder output = new StringBuilder();
            for (int i = n - 1; i >= 0; i--) output.append(a[i]).append(' ');
            System.out.println(output);
        } else {
            long answer = a[0];
            for (int i = 1; i < n; i++) {
                switch (op) {
                    case 3, 4 -> answer += a[i];
                    case 5, 6 -> answer %= a[i];
                    case 7, 8 -> answer = answer * a[i] % 1000000007;
                    case 9, 10 -> answer /= a[i];
                }
            }
            System.out.println(answer);
        }
    }
}
