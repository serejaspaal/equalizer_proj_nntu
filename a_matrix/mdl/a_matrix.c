typedef struct {
    long long h11_re;
    long long h11_im;
    long long h12_re;
    long long h12_im;
    long long h21_re;
    long long h21_im;
    long long h22_re;
    long long h22_im;
    long long c11;
    long long c22;
} a_matrix_t;

long long cmodule(long long i_Re, long long i_Im);

long long sum(int sign, int sub, long long a, long long b, int *udf);

void round(
    long long i_data,
    int in_width,
    int out_width,
    int in_signed,
    int clip_width,
    long long *o_data,
    int *o_sat
);

void cmult_b_coupl(
    long long x0,
    long long y0,
    long long x1,
    long long y1,
    long long *out_re,
    long long *out_im
);

void a_matrix(
    const a_matrix_t *mat,
    int h_width,
    int c_width,
    int a_width,
    int point_pos,
    long long *o_a11,
    long long *o_a22,
    long long *o_a12_re,
    long long *o_a12_im,
    int *o_sat_a11,
    int *o_sat_a22,
    int *o_sat_a12_re,
    int *o_sat_a12_im
)
{
    int cmag_width = 2 * h_width;
    int s1_width = cmag_width + 1;
    int c_width_ext = c_width + point_pos;

    int s2_width =
        (s1_width > c_width_ext) ? s1_width : c_width_ext;

    int round_in_width = s2_width + 1;

    int cmult_width = 2 * h_width + 1;
    int side_sum_width = cmult_width + 1;

    int udf;

    long long mag_h11;
    long long mag_h12;
    long long mag_h21;
    long long mag_h22;

    long long sum_a11;
    long long sum_a22;

    long long c11_ext;
    long long c22_ext;

    long long p1_re;
    long long p1_im;
    long long p2_re;
    long long p2_im;

    long long sum_a12_re;
    long long sum_a12_im;

    mag_h11 = cmodule(mat->h11_re, mat->h11_im);
    mag_h12 = cmodule(mat->h12_re, mat->h12_im);
    mag_h21 = cmodule(mat->h21_re, mat->h21_im);
    mag_h22 = cmodule(mat->h22_re, mat->h22_im);

    sum_a11 = sum(0, 0, mag_h11, mag_h12, &udf);
    sum_a22 = sum(0, 0, mag_h21, mag_h22, &udf);

    c11_ext = mat->c11 << point_pos;
    c22_ext = mat->c22 << point_pos;

    sum_a11 = sum(0, 0, sum_a11, c11_ext, &udf);
    sum_a22 = sum(0, 0, sum_a22, c22_ext, &udf);

    round(
        sum_a11,
        round_in_width,
        a_width,
        0,
        0,
        o_a11,
        o_sat_a11
    );

    round(
        sum_a22,
        round_in_width,
        a_width,
        0,
        0,
        o_a22,
        o_sat_a22
    );

    cmult_b_coupl(
        mat->h11_re,
        mat->h11_im,
        mat->h21_re,
        mat->h21_im,
        &p1_re,
        &p1_im
    );

    cmult_b_coupl(
        mat->h12_re,
        mat->h12_im,
        mat->h22_re,
        mat->h22_im,
        &p2_re,
        &p2_im
    );

    sum_a12_re = sum(1, 0, p1_re, p2_re, &udf);
    sum_a12_im = sum(1, 0, p1_im, p2_im, &udf);

    round(
        sum_a12_re,
        side_sum_width,
        a_width,
        1,
        0,
        o_a12_re,
        o_sat_a12_re
    );

    round(
        sum_a12_im,
        side_sum_width,
        a_width,
        1,
        0,
        o_a12_im,
        o_sat_a12_im
    );
}
