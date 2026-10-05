int sum(int sign, int sub, int a, int b, int *udf)
{
    *udf = !sign && sub && a < b;
    return sub ? a - b : a + b;
}
