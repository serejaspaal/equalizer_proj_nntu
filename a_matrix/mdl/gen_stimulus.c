#include <stdlib.h>
#include <math.h>

#define PI 3.14159265358979323846

static const double disp_levels[8] = {
    100.0, 10.0, 1.0, 0.1, 0.01, 0.001, 0.0001, 0.00001
};

static double g_disp = 1.0;

static double gauss(double sigma)
{
    double u1 = (rand() + 1.0) / ((double)RAND_MAX + 2.0);
    double u2 = (rand() + 1.0) / ((double)RAND_MAX + 2.0);
    return sigma * sqrt(-2.0 * log(u1)) * cos(2.0 * PI * u2);
}

static void cplx(double *re, double *im)
{
    *re = gauss(sqrt(0.5));
    *im = gauss(sqrt(0.5));
}

double set_disp(int idx)
{
    if (idx < 0)  idx = 0;
    if (idx > 7)  idx = 7;
    g_disp = disp_levels[idx];
    return g_disp;
}

void next_sample(double *h11_re, double *h11_im, double *h12_re, double *h12_im,
                 double *h21_re, double *h21_im, double *h22_re, double *h22_im,
                 double *c11,    double *c22)
{
    double a, b;

    cplx(&a, &b); *h11_re = a; *h11_im = b;
    cplx(&a, &b); *h12_re = a; *h12_im = b;
    cplx(&a, &b); *h21_re = a; *h21_im = b;
    cplx(&a, &b); *h22_re = a; *h22_im = b;

    /* C = disp * I */
    *c11 = g_disp;
    *c22 = g_disp;
}
