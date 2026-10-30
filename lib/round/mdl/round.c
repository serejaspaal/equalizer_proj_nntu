void round(
    long long i_data,
    int in_width,
    int out_width,
    int in_signed,
    int clip_width,
    long long *o_data,
    int *o_sat
) {
    int drop = in_width - out_width - clip_width;

    if (drop == 0) {
        *o_data = i_data;
        *o_sat  = 0;
        return;
    }

    int round_bit = (i_data >> (drop - 1)) & 1;
    long long sum = (i_data >> drop) + round_bit;

    long long max_val = in_signed ?  (1LL << (out_width - 1)) - 1 : (1LL << out_width) - 1;
    long long min_val = in_signed ? -(1LL << (out_width - 1))     : 0;

    if (sum > max_val) {
        *o_data = max_val;
        *o_sat  = 1;
    } else if (sum < min_val) {
        *o_data = min_val;
        *o_sat  = 1;
    } else {
        *o_data = sum;
        *o_sat  = 0;
    }
}