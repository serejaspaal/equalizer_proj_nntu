#include <stdint.h>


void cmult_a_real(
    // int a_signed,
    int a,
    int x1,
    int y1,
    int *out_re,
    int *out_im
)
{
    // if (a_signed) {
        // int32_t a_int;
        // int32_t x1_int;
        // int32_t y1_int;
        // int32_t out_re_int;
        // int32_t out_im_int;

        // a_int = (int32_t)a;
        // x1_int = (int32_t)x1;
        // y1_int = (int32_t)y1;

        // *out_re = a_int * x1_int;
        // *out_im = a_int * y1_int;
        *out_re = a * x1;
        *out_im = a * y1;
//     }
//     else {
//         uint32_t a_uint;
//         // int32_t x1_int;
//         // int32_t y1_int;
//         // int32_t out_re_int;
//         // int32_t out_im_int;
//
//         // a_uint = (uint32_t)a;
//         // x1_int = (int32_t)x1;
//         // y1_int = (int32_t)y1;
//
//         // *out_re = a_uint * x1_int;
//         // *out_im = a_uint * y1_int;
//         *out_re = a * x1;
//         *out_im = a * y1;
//     }
}
