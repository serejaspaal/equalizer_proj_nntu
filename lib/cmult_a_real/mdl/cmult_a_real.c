#include <stdint.h>

#ifndef _WIN32
__declspec(dllexport)
#endif

void cmult_a_real(
    int A_WIDTH,
    int B_WIDTH,
    int A_SIGNED,
    int a,
    int x1,
    int y1,
    int *out_re,
    int *out_im
)
{
    int result_width = A_WIDTH + B_WIDTH;
    uint32_t a_mask = (1u << A_WIDTH) - 1;
    uint32_t b_mask = (1u << B_WIDTH) - 1;
    uint32_t result_mask = (1u << result_width) - 1;

    uint32_t a_bits = ((uint32_t)a) & a_mask;
    uint32_t x1_bits = ((uint32_t)x1) & b_mask;
    uint32_t y1_bits = ((uint32_t)y1) & b_mask;

    if (A_SIGNED) {
        int32_t a_int;
        int32_t x1_int;
        int32_t y1_int;
        int32_t out_re_int;
        int32_t out_im_int;

        if(a_bits & (1u << (A_WIDTH - 1)))
            a_int = (int32_t)a_bits | ~a_mask;
        else
            a_int = (int32_t)a_bits;

        if(x1_bits & (1u << (B_WIDTH - 1)))
            x1_int = (int32_t)x1_bits | ~b_mask;
        else
            x1_int = (int32_t)x1_bits;

        if(y1_bits & (1u << (B_WIDTH - 1)))
            y1_int = (int32_t)y1_bits | ~b_mask;
        else
            y1_int = (int32_t)y1_bits;

        out_re_int = a_int * x1_int;
        out_im_int = a_int * y1_int;
        *out_re = (int)(out_re_int & result_mask);
        *out_im = (int)(out_im_int & result_mask);
    }
    else {
        int32_t x1_int;
        int32_t y1_int;
        int32_t out_re_int;
        int32_t out_im_int;

        if(x1_bits & (1u << (B_WIDTH - 1)))
            x1_int = (int32_t)x1_bits | ~b_mask;
        else
            x1_int = (int32_t)x1_bits;

        if(y1_bits & (1u << (B_WIDTH - 1)))
            y1_int = (int32_t)y1_bits | ~b_mask;
        else
            y1_int = (int32_t)y1_bits;

        out_re_int = a_bits * x1_int;
        out_im_int = a_bits * y1_int;
        *out_re = (int)(out_re_int & result_mask);
        *out_im = (int)(out_im_int & result_mask);
    }
}
