long long sum(int sign, int sub, long long a, long long b, int *udf)
{
    *udf = !sign && sub && a < b;
    return sub ? a - b : a + b;
}