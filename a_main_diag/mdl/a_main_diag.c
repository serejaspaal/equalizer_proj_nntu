unsigned long long a_main_diag(int h1_re, int h1_im,
                               int h2_re, int h2_im,
                               unsigned int c_diag,
                               int point_pos)
{
    long long m1 = (long long)h1_re * h1_re +
                   (long long)h1_im * h1_im;

    long long m2 = (long long)h2_re * h2_re +
                   (long long)h2_im * h2_im;

    return (unsigned long long)(m1 + m2 + ((unsigned long long)c_diag << point_pos));
}