void cmult_both_coupl(
    long long x0, long long y0,
    long long x1, long long y1,
    long long *out_re, long long *out_im
)
{
    y0 = -y0;
    y1 = -y1;
    long long common = (x0 - y0) * y1;
    long long multr  = (x1 - y1) * x0;
    long long multi  = (x1 + y1) * y0;

    *out_re = multr + common;
    *out_im = multi + common;
}