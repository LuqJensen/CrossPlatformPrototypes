package com.reactprototype.mathfunc;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class MathFuncModule extends ReactContextBaseJavaModule {

    private MathFunc cppApi;

    static {
        System.loadLibrary("mathfunc"); // load the "mathfunc" JNI module
    }

    public MathFuncModule(ReactApplicationContext reactContext) {
        super(reactContext); //required by React Native
        cppApi = MathFunc.create(); // create a new instance of our cppApi
    }

    @Override
    public String getName() {
        return "MathFunc"; //MathFunc is how this module will be referred to from React Native
    }

	@ReactMethod
    public void add(Double numberA, Double numberB, Promise promise) {
        promise.resolve(cppApi.add(numberA, numberB));
    }

	@ReactMethod
    public void subtract(Double numberA, Double numberB, Promise promise) {
        promise.resolve(cppApi.subtract(numberA, numberB));
    }

	@ReactMethod
    public void multiply(Double numberA, Double numberB, Promise promise) {
        promise.resolve(cppApi.multiply(numberA, numberB));
    }

	@ReactMethod
    public void divide(Double numberA, Double numberB, Promise promise) {
        promise.resolve(cppApi.divide(numberA, numberB));
    }
}