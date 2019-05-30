#pragma once

namespace MathFuncsWinRT
{
    public ref class MyMathFuncs sealed
    {
    public:
        MyMathFuncs();
        double Add(double a, double b);
        double Subtract(double a, double b);
        double Multiply(double a, double b);
        double Divide(double a, double b);
    };
}