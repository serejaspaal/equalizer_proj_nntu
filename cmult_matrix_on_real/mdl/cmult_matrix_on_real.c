void cmult_a_real(long long a, long long x1, long long y1, long long *out_re, long long *out_im);
void round(long long i_data, int in_width, int out_width, int in_signed, int clip_width, long long *o_data, int *o_sat);

typedef struct {
    long long re;
    long long im;
} cmplx;

typedef struct {
    long long det_inv;
    long long m11_re, m11_im;
    long long m12_re, m12_im;
    long long m21_re, m21_im;
    long long m22_re, m22_im;
} cmult_in;

typedef struct {
    long long w11_re, w11_im;
    long long w12_re, w12_im;
    long long w21_re, w21_im;
    long long w22_re, w22_im;
    int o_sat_w11_re, o_sat_w11_im;
    int o_sat_w12_re, o_sat_w12_im;
    int o_sat_w21_re, o_sat_w21_im;
    int o_sat_w22_re, o_sat_w22_im;
} cmult_out;

void cmult_matrix_on_real(
    int DET_WIDTH,
    int M_WIDTH,
    int W_WIDTH,
    int W_CLIP,
    const cmult_in  *in,
    cmult_out       *out
)
{
    int o_sat[4][2] = {};
    long long det_inv = in->det_inv;
    cmplx m_array[4] = {
        {in->m11_re, in->m11_im},
        {in->m12_re, in->m12_im},
        {in->m21_re, in->m21_im},
        {in->m22_re, in->m22_im},
    };
    cmplx w_array[4] = {};
    long long cmult_a_real_out_re[4];
    long long cmult_a_real_out_im[4];

    int i;
    for (i = 0; i<4; i++){
        cmult_a_real(det_inv, m_array[i].re, m_array[i].im,
                     &cmult_a_real_out_re[i], &cmult_a_real_out_im[i]);
        long long cmult_a_real_out_re_drop = cmult_a_real_out_re[i];//& ((1LL << (2 * DET_WIDTH)) - 1);
        long long cmult_a_real_out_im_drop = cmult_a_real_out_im[i]; //& ((1LL << (2 * DET_WIDTH)) - 1);
        round(cmult_a_real_out_re_drop, M_WIDTH + DET_WIDTH, W_WIDTH, 1, W_CLIP, &w_array[i].re, &o_sat[i][0]);
        round(cmult_a_real_out_im_drop, M_WIDTH + DET_WIDTH, W_WIDTH, 1, W_CLIP, &w_array[i].im, &o_sat[i][1]);
    }
    out->w11_re = w_array[0].re;
    out->w11_im = w_array[0].im;
    out->o_sat_w11_re = o_sat[0][0];
    out->o_sat_w11_im = o_sat[0][1];

    out->w12_re = w_array[1].re;
    out->w12_im = w_array[1].im;
    out->o_sat_w12_re = o_sat[1][0];
    out->o_sat_w12_im = o_sat[1][1];

    out->w21_re = w_array[2].re;
    out->w21_im = w_array[2].im;
    out->o_sat_w21_re = o_sat[2][0];
    out->o_sat_w21_im = o_sat[2][1];

    out->w22_re = w_array[3].re;
    out->w22_im = w_array[3].im;
    out->o_sat_w22_re = o_sat[3][0];
    out->o_sat_w22_im = o_sat[3][1];

    return;
}
