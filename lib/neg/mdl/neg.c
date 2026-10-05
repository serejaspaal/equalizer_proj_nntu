#include <stdint.h>

#ifdef _WIN32
__declspec(dllexport)
#endif

int neg(int a)
{
    return -a;
}