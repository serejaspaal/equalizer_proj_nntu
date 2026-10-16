void cmult_a_real_b_coupl(
    int a,
    int x1,
    int y1,
    int *out_re,
    int *out_im
)
{
    *out_re = a * x1;
    *out_im = a * (-1 * y1);
}
