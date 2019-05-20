import React, { Component } from 'react';
import {NativeModules, Platform, StyleSheet, Text, View, Button, TextInput} from 'react-native';
 
const MathFunc = require('NativeModules').MathFunc;
 
type State = { message: string };
 
export default class App extends Component {
    constructor(props) {
        super(props);
        this.buttonCpp = this.buttonCpp.bind(this);
        this.buttonBenchmarks = this.buttonBenchmarks.bind(this);
        this.state = { message: " " };
    }
    async buttonCpp() {
        var message = ""
        var numberA = 1
        var numberB = 2
       
        addResult = await MathFunc.add(numberA,numberB)
        subtractResult = await MathFunc.subtract(numberA,numberB)
        multiplyResult = await MathFunc.multiply(numberA,numberB)
        divideResult = await MathFunc.divide(numberA,numberB)
       
        var message = ""
        message += numberA + "+" + numberB + "=" + addResult + "\n"
        message += numberA + "-" + numberB + "=" + subtractResult + "\n"
        message += numberA + "*" + numberB + "=" + multiplyResult + "\n"
        message += numberA + "/" + numberB + "=" + divideResult + "\n"
        this.setState({
            message
        });
    }
	
	n: number = 1000;
    async buttonBenchmarks(): void {
   
    var message = "Running benchmarks";
    this.setState({
        message
    });
	
    let dict_t = 0;
    let patmch_1t = 0;
    let patmch_2t = 0;
    let matmul = 0;
 
    for (let i = 0; i < 10; ++i) {
		matmul += this.testmatmul();
    }
    var message = "matmul: " + (matmul / 10 / 1000).toFixed(1) + "s\n";
	this.setState({
        message
    });
    for (let i = 0; i < 10; ++i) {
		patmch_1t += await this.testpatmch1();
    }
    message += "patmch:1t: " + (patmch_1t / 10 / 1000).toFixed(1) + "s\n";
	for (let i = 0; i < 10; ++i) {
		patmch_1t += await this.testpatmch2();
    }
    message += "patmch:2t: " + (patmch_2t / 10 / 1000).toFixed(1) + "s\n";
	for (let i = 0; i < 10; ++i) {
		patmch_1t += await this.testdict();
    }
    message += "dict:t: " + (dict_t / 10 / 1000).toFixed(1) + "s";
	
    this.setState({
        message
    });
  }
  async testpatmch1(): Promise<number> {
    let t0 = Date.now();
    let response = await fetch('assets/howto')
	let text = await response.text()
	let strings = text.split("\n");
    let pat = new RegExp("([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)");
    strings.forEach(l => {
      pat.test(l);
    });
    let t1 = Date.now();
    return t1 - t0;
  }
  async testpatmch2(): Promise<number> {
    let t0 = Date.now();
    let response = await fetch('assets/howto')
	let text = await response.text()
	let strings = text.split("\n");
    let pat = new RegExp("([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)|([^ @]+)@([^ @]+)");
    strings.forEach(l => {
      pat.test(l);
    });
    let t1 = Date.now();
    return t1 - t0;
  }
  async testdict(): Promise<number> {
    let t0 = Date.now();
	let response = await fetch('assets/5million.txt')
	let text = await response.text()
	let strings = text.split("\n");
    let h = {};
    strings.forEach(l => {
      if (h[l]) {
        ++h[l];
      }
      else
        h[l] = 1;
    });
    let t1 = Date.now();
    return t1 - t0;
  }
  testmatmul(): number {
    let t0 = Date.now();
    let a = this.matgen(this.n);
    let b = this.matgen(this.n);
    let c = this.multiply(a, b);
    let t1 = Date.now();
    return t1 - t0;
  }
  transpose(a: any): any {
    let b = [], m = a.length, n = a[0].length; // m rows and n cols
      for (let j = 0; j < n; ++j) b[j] = [];
      for (let i = 0; i < m; ++i)
          for (let j = 0; j < n; ++j)
              b[j].push(a[i][j]);
      return b;
  }
  multiply(a: any, b: any): any {
    let m = a.length, n = a[0].length, s = b.length, t = b[0].length;
      if (n != s) return null;
      let x = [], c = this.transpose(b);
      for (let i = 0; i < m; ++i) {
          x[i] = [];
          for (let j = 0; j < t; ++j) {
              let sum = 0;
              let ai = a[i], cj = c[j];
              for (let k = 0; k < n; ++k) sum += ai[k] * cj[k];
              x[i].push(sum);
          }
      }
      return x;
  }
  matgen(n: number): any {
      let a = [], tmp = 1. / n / n;
      for (let i = 0; i < n; ++i) {
          a[i] = []
          for (let j = 0; j < n; ++j)
              a[i][j] = tmp * (i - j) * (i + j);
      }
      return a;
  }
    render() {
        return (
        <View style={styles.container}>
            <Text>
                Welcome to React Native!
            </Text>
            <View style={{margin: 20}}>
                <Button
                    style={{margin: 100}}
                    onPress={this.buttonCpp}
                    title="Test C++"
                />
            </View>
            <View style={{margin: 20}}>
                <Button
                    style={{padding: 100}}
                    onPress={this.buttonBenchmarks}
                    title="Run benchmarks"
                />
            </View>
            <View style={{padding: 10}}>
                <TextInput
                    style={{height: 100}}
                    placeholder="Type here to translate!"
                    multiline={true}
                    value={this.state.message}
                />
            </View>
      </View>
    );
  }
}
 
const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});