typedef struct {
    long long h11_re;
    long long h11_im;
    long long h12_re;
    long long h12_im;
    long long h21_re;
    long long h21_im;
    long long h22_re;
    long long h22_im;
} a_matrix_t;

void cmult_b_coupl(
    long long x0, long long y0,
    long long x1, long long y1,
    long long *out_re, long long *out_im
);

long long sum(
    int sign,
    int sub,
    long long a,
    long long b,
    int *udf
);

void round(
    long long i_data,
    int in_width,
    int out_width,
    int in_signed,
    int clip_width,
    long long *o_data,
    int *o_sat
);

void a_side_diag(
    const a_matrix_t *mat,
    int h_width,
    int a_width,
    long long *o_a12_re,
    long long *o_a12_im,
    int *o_sat_a12_re,
    int *o_sat_a12_im
)
{
    const int cmult_width = 2 * h_width + 1;
    const int sum_width = cmult_width + 1;

    long long cmult_re_1, cmult_im_1;
    long long cmult_re_2, cmult_im_2;

    long long sum_re, sum_im;
    int udf_re, udf_im;

    cmult_b_coupl(
        mat->h11_re, mat->h11_im,
        mat->h21_re, mat->h21_im,
        &cmult_re_1, &cmult_im_1
    );

    cmult_b_coupl(
        mat->h12_re, mat->h12_im,
        mat->h22_re, mat->h22_im,
        &cmult_re_2, &cmult_im_2
    );

    sum_re = sum(1, 0, cmult_re_1, cmult_re_2, &udf_re);
    sum_im = sum(1, 0, cmult_im_1, cmult_im_2, &udf_im);

    round(
        sum_re,
        sum_width,
        a_width,
        1,
        0,
        o_a12_re,
        o_sat_a12_re
    );

    round(
        sum_im,
        sum_width,
        a_width,
        1,
        0,
        o_a12_im,
        o_sat_a12_im
    );
}