#include <stdint.h>


int mult(int i_a, int i_b);
int cmodule(int i_Re, int i_Im);
int sum(int sign, int sub, int a, int b, int *udf);
void round(int i_data, int in_width, int out_width, int in_signed, int clip_width, int *o_data, int *o_sat);


typedef struct {
    int a11;
    int a22;
    int a12_re;
    int a12_im;
} a_matrix_t;


int a_det(
    const a_matrix_t *mat,
    int a_width,
    int det_width,
    int *o_sat_det,
    int *sum_underflow
) {
    int width_2 = 2 * a_width;
    uint64_t mask_a  = (1ULL << a_width) - 1;
    uint64_t mask_2a = (width_2 >= 64) ? ~0ULL : ((1ULL << width_2) - 1);


    int a11_u = (int)(mat->a11 & mask_a);
    int a22_u = (int)(mat->a22 & mask_a);


    int shift_s = 32 - a_width;
    int a12_re_s = ((int)((uint32_t)mat->a12_re << shift_s)) >> shift_s;
    int a12_im_s = ((int)((uint32_t)mat->a12_im << shift_s)) >> shift_s;


    uint32_t mult_result = (uint32_t)mult(a11_u, a22_u) & mask_2a;

    uint32_t dline_result = mult_result;


    uint32_t cmodule_result = (uint32_t)cmodule(a12_re_s, a12_im_s) & mask_2a;


    int udf = 0;
    uint32_t sum_result = (uint32_t)sum(0, 1, (int)dline_result, (int)cmodule_result, &udf);
    // Корректировка беззнакового сравнения для 32-битных чисел (так как в sum() аргументы типа int)
    *sum_underflow = (dline_result < cmodule_result) ? 1 : 0;


    uint32_t sum_result_drop = sum_result & mask_2a;


    int det_out = 0;
    int sat_out = 0;
    int drop = width_2 - det_width;

    if (drop == 0) {
        round((int)sum_result_drop, width_2, det_width, 0, 0, &det_out, &sat_out);
    } else {
        // Беззнаковое округление (защита от знакового сдвига и переполнения 1<<32 в Си)
        uint64_t round_bit = (sum_result_drop >> (drop - 1)) & 1ULL;
        uint64_t r_sum = (sum_result_drop >> drop) + round_bit;
        uint64_t max_u = (det_width >= 64) ? ~0ULL : ((1ULL << det_width) - 1);

        if (r_sum > max_u) {
            det_out = (int)max_u;
            sat_out = 1;
        } else {
            det_out = (int)r_sum;
            sat_out = 0;
        }
    }

    *o_sat_det = sat_out;
    return det_out;
}