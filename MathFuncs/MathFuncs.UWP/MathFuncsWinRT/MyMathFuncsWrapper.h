#include "MyMathFuncs.h"
using namespace MathFuncs;

extern "C" {
    __declspec(dllexport) MyMathFuncs* CreateMyMathFuncsClass();
    __declspec(dllexport) void DisposeMyMathFuncsClass(MyMathFuncs* ptr);
    __declspec(dllexport) double MyMathFuncsAdd(MyMathFuncs *ptr, double a, double b);
    __declspec(dllexport) double MyMathFuncsSubtract(MyMathFuncs *ptr, double a, double b);
    __declspec(dllexport) double MyMathFuncsMultiply(MyMathFuncs *ptr, double a, double b);
    __declspec(dllexport) double MyMathFuncsDivide(MyMathFuncs *ptr, double a, double b);
}