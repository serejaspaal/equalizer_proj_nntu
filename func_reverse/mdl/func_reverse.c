void linear_intrp(
    long long i_a0,
    long long i_a1,
    long long i_xf,
    int intrp_width,
    long long *o_res
);

void func_reverse(
    int IN_WIDTH,
    int FRAC_WIDTH,
    long long i_x,
    int USE_INTRP,
    int INTRP_WIDTH,
    long long *o_result,
    int *o_inf
)
{
    if (i_x == 0){
        *o_inf = 1;
        *o_result = 0;
        return;
    }
    *o_inf = 0;
    long long x = i_x & ((1LL << IN_WIDTH)- 1LL);
    int msb_pos = 0;
    int i;
    for (i = 0; i < IN_WIDTH; i++){
        if ((x >> i) & 1LL)
            msb_pos = i;
    }

    int k_right = msb_pos - (FRAC_WIDTH - 1);
    int k_left  = (FRAC_WIDTH - 1) - msb_pos;
    int shift_right = (msb_pos >= FRAC_WIDTH);
    int shift_k = shift_right ? k_right : k_left;

    long long norm;
    if (shift_right)
        norm = x >> shift_k;
    else
        norm = x << shift_k;


    const int lut_aw = 11;
    long long addr_comb = 0;
    long long xfrac = 0;

    for (i = 0; i < lut_aw; i++) {
        if (msb_pos > 0 && msb_pos - 1 >= i) {
            long long bit = (x >> (msb_pos - 1 - i)) & 1LL;
            addr_comb |= (bit << (lut_aw - 1 - i));
        }
    }

    for (i = 0; i < INTRP_WIDTH; i++) {
        if (msb_pos >= lut_aw + 1 + i) {
            long long bit = (x >> (msb_pos - 1 - lut_aw - i)) & 1LL;
            xfrac |= (bit << (INTRP_WIDTH - 1 - i));
        }
    }

    double x0 = (2048.0 + (double)addr_comb) / 4096.0;
    double x1 = (2048.0 + (double)addr_comb + 1.0) / 4096.0;

    long long a0 = (long long)(round((1.0 / x0) * 65536.0));
    a0 &= (1LL << 18) - 1;

    long long a1 = (long long)(round((1.0 / x1) * 65536.0));
    a1 &= (1LL << 18) - 1;

    long long interp;
    if (USE_INTRP) {
        linear_intrp(a0, a1, xfrac, INTRP_WIDTH, &interp);
    } else {
        interp = a0;
    }

    long long wide_res;
    if (shift_right)
        wide_res = interp >> shift_k;
    else
        wide_res = interp << shift_k;

    int out_width = IN_WIDTH + (USE_INTRP ? INTRP_WIDTH : 0) + 1;
    long long mask_out = (1LL << out_width) - 1LL;
    *o_result = wide_res & mask_out;
}
