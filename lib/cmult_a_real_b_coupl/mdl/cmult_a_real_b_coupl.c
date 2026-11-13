void cmult_a_real_b_coupl(
    long long a,
    long long x1,
    long long y1,
    long long *out_re,
    long long *out_im
)
{
    *out_re = a * x1;
    *out_im = a * (-1 * y1);
}