#include <pcre.h>
int main()
{
    int ans;
    int res = pcre_config(PCRE_CONFIG_UTF8, &ans);
    if (res || ans != 1) exit(1); else exit(0);
}

