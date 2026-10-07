void cmult(
    int x0, int y0,
    int x1, int y1,
    int *out_re, int *out_im
)
{
    int common = (x0 - y0) * y1;
    int multr  = (x1 - y1) * x0;
    int multi  = (x1 + y1) * y0;

    *out_re = multr + common;
    *out_im = multi + common;
}