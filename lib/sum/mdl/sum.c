#include <stdint.h>

#ifdef _WIN32
__declspec(dllexport)
#endif

int sum(
    int A,
    int B,
    int sub,
    int signed_operands,
    int A_WIDTH,
    int B_WIDTH,
    int *underflow
)
{
    int max_width = (A_WIDTH > B_WIDTH) ? A_WIDTH : B_WIDTH;
    int result_width = max_width + 1;

    uint32_t a_mask = (1u << A_WIDTH) - 1u;
    uint32_t b_mask = (1u << B_WIDTH) - 1u;
    uint32_t result_mask = (1u << result_width) - 1u;

    uint32_t a_bits = ((uint32_t)A) & a_mask;
    uint32_t b_bits = ((uint32_t)B) & b_mask;

    *underflow = 0;

    if (signed_operands)
    {
        int32_t a;
        int32_t b;
        int32_t result;

        if (a_bits & (1u << (A_WIDTH - 1)))
            a = (int32_t)(a_bits | ~a_mask);
        else
            a = (int32_t)a_bits;

        if (b_bits & (1u << (B_WIDTH - 1)))
            b = (int32_t)(b_bits | ~b_mask);
        else
            b = (int32_t)b_bits;

        if (sub)
            result = a - b;
        else
            result = a + b;

        return (int)(result & result_mask);
    }
    else
    {
        uint32_t result;

        if (sub)
        {
            if (a_bits < b_bits)
                *underflow = 1;

            result = a_bits - b_bits;
        }
        else
        {
            result = a_bits + b_bits;
        }

        return (int)(result & result_mask);
    }
}
