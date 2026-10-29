long long mult(long long i_a, long long i_b);
long long cmodule(long long i_Re, long long i_Im);
long long sum(int sign, int sub, long long a, long long b, int *udf);
void round(long long i_data, int in_width, int out_width, int in_signed, int clip_width, long long *o_data, int *o_sat);

typedef struct {
    long long a11;
    long long a22;
    long long a12_re;
    long long a12_im;
} a_matrix_t;

long long a_det(
    const a_matrix_t *mat,
    int a_width,
    int det_width,
    int *o_det_sat,
    int *o_sum_udf
) {
    long long mult_result    = mult(mat->a11, mat->a22);
    long long cmodule_result = cmodule(mat->a12_re, mat->a12_im);
    long long sum_result     = sum(0, 1, mult_result, cmodule_result, o_sum_udf);

    long long sum_result_drop = sum_result & ((1LL << (2 * a_width)) - 1);

    long long det_out = 0;
    round(sum_result_drop, 2 * a_width, det_width, 0, 0, &det_out, o_det_sat);

    return det_out;
}