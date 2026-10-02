void cmult_a_real(
    int a,
    int x1,
    int y1,
    int *out_re,
    int *out_im
)
{
    *out_re = a * x1;
    *out_im = a * y1;
}
