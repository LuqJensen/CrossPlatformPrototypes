#include "pch.h"
#include "MyMathFuncs.h"

using namespace MathFuncsWinRT;
using namespace Platform;

MyMathFuncs::MyMathFuncs() {}

double MyMathFuncs::Add(double a, double b)
{
    return a + b;
}

double MyMathFuncs::Subtract(double a, double b)
{
    return a - b;
}

double MyMathFuncs::Multiply(double a, double b)
{
    return a * b;
}

double MyMathFuncs::Divide(double a, double b)
{
    return a / b;
}