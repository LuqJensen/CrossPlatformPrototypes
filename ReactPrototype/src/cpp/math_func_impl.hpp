#pragma once
 
#include "math_func.hpp"
 
namespace mathfunc {
    
    class MathFuncImpl : public mathfunc::MathFunc {
        
    public:
        
        // Constructor
        MathFuncImpl();
        
        // Our method that returns a string
        double add(double a, double b);
        double subtract(double a, double b);
        double multiply(double a, double b);
        double divide(double a, double b);
        
    };
    
}