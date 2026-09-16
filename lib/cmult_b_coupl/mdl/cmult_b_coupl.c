static int sign_trunc(int value, int width)
{
    int mask = (1 << width) - 1;
    int sign = 1 << (width - 1);

    value &= mask;
    if (value & sign)
        value |= ~mask;
    return value;
}

void cmult_b_coupl(
    int A_WIDTH, int B_WIDTH,
    int x0, int y0,
    int x1, int y1,
    int *out_re, int *out_im
)
{
    int common = (y0 - x0) * y1;
    int multr  = (x1 + y1) * x0;
    int multi  = (x1 - y1) * y0;

    int re = multr + common;
    int im = multi + common;

    int out_width = A_WIDTH + B_WIDTH + 1;

    *out_re = sign_trunc(re, out_width);
    *out_im = sign_trunc(im, out_width);
}