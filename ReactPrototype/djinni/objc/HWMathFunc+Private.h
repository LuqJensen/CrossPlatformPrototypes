// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from mathfunc.djinni

#include "math_func.hpp"
#include <memory>

static_assert(__has_feature(objc_arc), "Djinni requires ARC to be enabled for this file");

@class HWMathFunc;

namespace djinni_generated {

class MathFunc
{
public:
    using CppType = std::shared_ptr<::mathfunc::MathFunc>;
    using CppOptType = std::shared_ptr<::mathfunc::MathFunc>;
    using ObjcType = HWMathFunc*;

    using Boxed = MathFunc;

    static CppType toCpp(ObjcType objc);
    static ObjcType fromCppOpt(const CppOptType& cpp);
    static ObjcType fromCpp(const CppType& cpp) { return fromCppOpt(cpp); }

private:
    class ObjcProxy;
};

}  // namespace djinni_generated

