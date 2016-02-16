#include "stdio.h"
#include "glpk.h"

int main(int argc, const char *argv[])
{
    printf("GLPK Version: %s\n", glp_version());
    return 0;
}
