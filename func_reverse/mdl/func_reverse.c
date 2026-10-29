// #include <stdio.h>

void func_reverse(
    int IN_WIDTH,
    int FRAC_WIDTH,
    long long i_x,
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


    double mantissa = (double)norm / (double)(1LL << FRAC_WIDTH);
    double scaled = (1.0 / mantissa) * 65536.0;
    long long val = (long long)(scaled + 0.5);

    val &= (1LL << 18) - 1;

    long long wide_res;
    if (shift_right)
        wide_res = val >> shift_k;
    else
        wide_res = val << shift_k;

    int out_width = IN_WIDTH + 1;
    long long mask_out = (1LL << out_width) - 1LL;
    *o_result = wide_res & mask_out;
}

// int main(void){
//     int inwidth = 32;
//     int fracwidth = 16;
//     long long i_x = 131072;
//     // long long i_x = 16384;
//     long long o_res;
//     int o_inf;
//     func_reverse(inwidth, fracwidth, i_x, &o_res, &o_inf);
//     printf("o_res = %lld\n", o_res);
//     printf("o_inf = %d\n", o_inf);
//     return 0;
// }
