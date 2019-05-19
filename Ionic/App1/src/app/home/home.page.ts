import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage {
  constructor(private http: HttpClient) {}
  output: string = "Output";
  n: number = 1000;
  async button_benchmarks(): Promise<void> {
    this.output = "Running benchmarks";
    let dict_t = 0;
    let patmch_1t = 0;
    let patmch_2t = 0;
    let matmul = 0;

    for (let i = 0; i < 10; ++i) {
      matmul += this.testmatmul();
    }
    this.output = "matmul: " + (matmul / 10 / 1000).toFixed(1) + "s\n";
    
    for (let i = 0; i < 10; ++i) {
      patmch_1t += await this.testpatmch1();
    }
    this.output += "patmch:1t: " + (patmch_1t / 10 / 1000).toFixed(1) + "s\n";

    for (let i = 0; i < 10; ++i) {
      patmch_2t += await this.testpatmch2();
    }
    this.output += "patmch:2t: " + (patmch_2t / 10 / 1000).toFixed(1) + "s\n";
    
    for (let i = 0; i < 10; ++i) {
      dict_t += await this.testdict();
    }
    this.output += "dict:t: " + (dict_t / 10 / 1000).toFixed(1) + "s";
  }
  async testpatmch1(): Promise<number> {
    let t0 = performance.now();
    let text = await this.http.get('assets/howto', {responseType: 'text'}).toPromise();
    let strings = text.split("\n");
    let pat = new RegExp("([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)");
    strings.forEach(l => {
      pat.test(l);
    });
    let t1 = performance.now();
    return t1 - t0;
  }
  async testpatmch2(): Promise<number> {
    let t0 = performance.now();
    let text = await this.http.get('assets/howto', {responseType: 'text'}).toPromise();
    let strings = text.split("\n");
    let pat = new RegExp("([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)|([^ @]+)@([^ @]+)");
    strings.forEach(l => {
      pat.test(l);
    });
    let t1 = performance.now();
    return t1 - t0;
  }
  async testdict(): Promise<number> {
    let t0 = performance.now();
    let text = await this.http.get('assets/5million.txt', {responseType: 'text'}).toPromise();
    //let text = await this.file.readAsText(this.file.applicationDirectory + "www/assets", "5million.txt");
    let strings = text.split("\n");
    let h = {};
    strings.forEach(l => {
      if (h[l]) {
        ++h[l];
      } 
      else 
        h[l] = 1;
    });
    let t1 = performance.now();
    return t1 - t0;
  }
  testmatmul(): number {
    let t0 = performance.now();
    let a = this.matgen(this.n);
    let b = this.matgen(this.n);
    let c = this.multiply(a, b);
    let t1 = performance.now();
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
}
