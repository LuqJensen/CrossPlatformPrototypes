using MathFuncCpp;
using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace MathFuncBridge
{
    class MathFuncModule : ReactContextNativeModuleBase
    {
        private MathFunc cppApi;
        public MathFuncModule(ReactContext reactContext)
            : base(reactContext)
        {
            cppApi = new MathFunc();
        }

        public override string Name
        {
            get
            {
                return "MathFunc";
            }
        }

        [ReactMethod]
        public void add(double numberA, double numberB, IPromise promise)
        {
            promise.Resolve(cppApi.add(numberA, numberB));
        }
        [ReactMethod]
        public void subtract(double numberA, double numberB, IPromise promise)
        {
            promise.Resolve(cppApi.subtract(numberA, numberB));
        }
        [ReactMethod]
        public void multiply(double numberA, double numberB, IPromise promise)
        {
            promise.Resolve(cppApi.multiply(numberA, numberB));
        }
        [ReactMethod]
        public void divide(double numberA, double numberB, IPromise promise)
        {
            promise.Resolve(cppApi.divide(numberA, numberB));
        }

    }
}
