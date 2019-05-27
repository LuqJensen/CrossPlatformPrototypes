#include "math_func_impl.hpp"
#include <string>
 
namespace mathfunc {
    
    std::shared_ptr<MathFunc> MathFunc::create() {
        return std::make_shared<MathFuncImpl>();
    }
    
    MathFuncImpl::MathFuncImpl() {
 
    }
    
	double MathFuncImpl::add(double a, double b)
    {
        return a + b;
    }

    double MathFuncImpl::subtract(double a, double b)
    {
        return a - b;
    }

    double MathFuncImpl::multiply(double a, double b)
    {
        return a * b;
    }

    double MathFuncImpl::divide(double a, double b)
    {
        return a / b;
    }
}