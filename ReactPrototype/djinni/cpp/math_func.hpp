// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from mathfunc.djinni

#pragma once

#include <memory>

namespace mathfunc {

class MathFunc {
public:
    virtual ~MathFunc() {}

    static std::shared_ptr<MathFunc> create();

    virtual double add(double a, double b) = 0;

    virtual double subtract(double a, double b) = 0;

    virtual double multiply(double a, double b) = 0;

    virtual double divide(double a, double b) = 0;
};

}  // namespace mathfunc
