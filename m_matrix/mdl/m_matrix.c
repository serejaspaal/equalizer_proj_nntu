void cmult_a_real_b_coupl(long long a, long long x1, long long y1, long long *out_re, long long *out_im);
void cmult_b_coupl(long long x0, long long y0, long long x1, long long y1, long long *out_re, long long *out_im);
void cmult_both_coupl(long long x0, long long y0, long long x1, long long y1, long long *out_re, long long *out_im);
long long sum(int sign, int sub, long long a, long long b, int *udf);
void round(long long i_data, int in_width, int out_width, int in_signed, int clip_width, long long *o_data, int *o_sat);

typedef struct {
    long long h11_re, h11_im;
    long long h12_re, h12_im;
    long long h21_re, h21_im;
    long long h22_re, h22_im;
    long long a11, a22;
    long long a12_re, a12_im;
} m_matrix_in_t;

typedef struct {
    long long m11_re, m11_im;
    long long m12_re, m12_im;
    long long m21_re, m21_im;
    long long m22_re, m22_im;
    int sat_m11_re, sat_m11_im;
    int sat_m12_re, sat_m12_im;
    int sat_m21_re, sat_m21_im;
    int sat_m22_re, sat_m22_im;
} m_matrix_out_t;

static void top_block_m_matrix(
    long long h1_re, long long h1_im,
    long long h2_re, long long h2_im,
    long long a22,
    long long a12_re, long long a12_im,
    int in_round_width, int m_width, int m_clip,
    long long *m_re, long long *m_im,
    int *sat_re, int *sat_im
) {
    long long cmult1_re, cmult1_im;
    long long cmult2_re, cmult2_im;
    int udf_re, udf_im;

    cmult_a_real_b_coupl(a22, h1_re, h1_im, &cmult1_re, &cmult1_im);
    cmult_b_coupl(a12_re, a12_im, h2_re, h2_im, &cmult2_re, &cmult2_im);

    long long sum_re = sum(1, 1, cmult1_re, cmult2_re, &udf_re);
    long long sum_im = sum(1, 1, cmult1_im, cmult2_im, &udf_im);

    round(sum_re, in_round_width, m_width, 1, m_clip, m_re, sat_re);
    round(sum_im, in_round_width, m_width, 1, m_clip, m_im, sat_im);
}

static void bot_block_m_matrix(
    long long h1_re, long long h1_im,
    long long h2_re, long long h2_im,
    long long a11,
    long long a12_re, long long a12_im,
    int in_round_width, int m_width, int m_clip,
    long long *m_re, long long *m_im,
    int *sat_re, int *sat_im
) {
    long long cmult1_re, cmult1_im;
    long long cmult2_re, cmult2_im;
    int udf_re, udf_im;

    cmult_a_real_b_coupl(a11, h2_re, h2_im, &cmult1_re, &cmult1_im);
    cmult_both_coupl(a12_re, a12_im, h1_re, h1_im, &cmult2_re, &cmult2_im);

    long long sum_re = sum(1, 1, cmult1_re, cmult2_re, &udf_re);
    long long sum_im = sum(1, 1, cmult1_im, cmult2_im, &udf_im);

    round(sum_re, in_round_width, m_width, 1, m_clip, m_re, sat_re);
    round(sum_im, in_round_width, m_width, 1, m_clip, m_im, sat_im);
}

void m_matrix(
    const m_matrix_in_t *in,
    int a_width,
    int h_width,
    int m_width,
    int m_clip,
    m_matrix_out_t *out
) {
    int in_round_width = a_width + h_width + 2;

    top_block_m_matrix(
        in->h11_re, in->h11_im, in->h12_re, in->h12_im,
        in->a22, in->a12_re, in->a12_im,
        in_round_width, m_width, m_clip,
        &out->m11_re, &out->m11_im, &out->sat_m11_re, &out->sat_m11_im
    );

    bot_block_m_matrix(
        in->h11_re, in->h11_im, in->h12_re, in->h12_im,
        in->a11, in->a12_re, in->a12_im,
        in_round_width, m_width, m_clip,
        &out->m21_re, &out->m21_im, &out->sat_m21_re, &out->sat_m21_im
    );

    top_block_m_matrix(
        in->h21_re, in->h21_im, in->h22_re, in->h22_im,
        in->a22, in->a12_re, in->a12_im,
        in_round_width, m_width, m_clip,
        &out->m12_re, &out->m12_im, &out->sat_m12_re, &out->sat_m12_im
    );

    bot_block_m_matrix(
        in->h21_re, in->h21_im, in->h22_re, in->h22_im,
        in->a11, in->a12_re, in->a12_im,
        in_round_width, m_width, m_clip,
        &out->m22_re, &out->m22_im, &out->sat_m22_re, &out->sat_m22_im
    );
}