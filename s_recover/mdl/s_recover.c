typedef struct {
    long long w11_re;
    long long w11_im;
    long long w12_re;
    long long w12_im;
    long long w21_re;
    long long w21_im;
    long long w22_re;
    long long w22_im;
} w_matrix_t;

typedef struct {
    long long s11_re;
    long long s11_im;
    long long s21_re;
    long long s21_im;
} s_vector_t;

typedef struct {
    long long s11_re;
    long long s11_im;
    long long s21_re;
    long long s21_im;
    int sat_s11_re;
    int sat_s11_im;
    int sat_s21_re;
    int sat_s21_im;
} s_rec_t;

void cmult(
    long long x0,
    long long y0, 
    long long x1,
    long long y1,
    long long *out_re,
    long long *out_im
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

static void one_block_s_recover(
    long long w1_re,
    long long w1_im,
    long long w2_re,
    long long w2_im,
    long long s1_re,
    long long s1_im,
    long long s2_re,
    long long s2_im,

    int w_width,
    int s_width,
    int sr_width,

    long long *o_s_re,
    long long *o_s_im,
    int *o_sat_re,
    int *o_sat_im
) {
    int cmult_width = w_width + s_width + 1;
    int sum_width = cmult_width + 1;

    long long cmult1_re, cmult1_im;
    long long cmult2_re, cmult2_im;
    long long sum_re, sum_im;
    int udf_re, udf_im;

    cmult(w1_re, w1_im, s1_re, s1_im, &cmult1_re, &cmult1_im);
    cmult(w2_re, w2_im, s2_re, s2_im, &cmult2_re, &cmult2_im);

    sum_re = sum(1, 0, cmult1_re, cmult2_re, &udf_re);
    sum_im = sum(1, 0, cmult1_im, cmult2_im, &udf_im);

    round(sum_re, sum_width, sr_width, 1, 0, o_s_re, o_sat_re);
    round(sum_im, sum_width, sr_width, 1, 0, o_s_im, o_sat_im);
}

void s_recover(
    const w_matrix_t *w,
    const s_vector_t *s,
    int w_width,
    int s_width,
    int sr_width,
    s_rec_t *s_rec
) {
    one_block_s_recover(
        w->w11_re, w->w11_im,
        w->w12_re, w->w12_im,
        s->s11_re, s->s11_im,
        s->s21_re, s->s21_im,
        w_width,
        s_width,
        sr_width,
        &s_rec->s11_re, &s_rec->s11_im,
        &s_rec->sat_s11_re, &s_rec->sat_s11_im
    );

    one_block_s_recover(
        w->w21_re, w->w21_im,
        w->w22_re, w->w22_im,
        s->s11_re, s->s11_im,
        s->s21_re, s->s21_im,
        w_width,
        s_width,
        sr_width,
        &s_rec->s21_re, &s_rec->s21_im,
        &s_rec->sat_s21_re, &s_rec->sat_s21_im
    );
}