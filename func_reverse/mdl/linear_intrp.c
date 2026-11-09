void linear_intrp(
    long long i_a0,
    long long i_a1,
    long long i_xf,
    int intrp_width,
    long long *o_res
)
{
    long long diff = i_a0 - i_a1;
    long long corr = i_xf * diff;
    *o_res = (i_a0 << intrp_width) - corr;
}
