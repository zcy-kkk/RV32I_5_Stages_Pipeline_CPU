int main() {
    volatile int n = 13; 
    
    int a = 1;
    int b = 1;
    int c = 1;

    if (n <= 2) {
        return 1;
    }

    for (int i = 3; i <= n; i++) {
        c = a + b;
        a = b;
        b = c;
    }

    return c;
}