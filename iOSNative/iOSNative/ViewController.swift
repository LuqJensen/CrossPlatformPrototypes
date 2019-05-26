//
//  ViewController.swift
//  iOSNative
//
//  Created by Thanusaan Rasiah on 21/05/2019.
//  Copyright © 2019 Thanusaan Rasiah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var output: UITextView!
    
    @IBAction func benchmark(_ sender: Any) {
        output.text = "Running benchmarks..."
        let iterations = 10
        
        var matmul = 0.0
        for _ in 1...iterations {
            matmul += testMatMul();
        }
        output.text = "matmul:t: " + String(matmul / Double(iterations)) + "\n"
        
        var patmch1 = 0.0
        for _ in 1...iterations {
            patmch1 += testPatmch1();
        }
        output.insertText("patmch:1t: " + String(patmch1 / Double(iterations)) + "\n")
        
        var patmch2 = 0.0
        for _ in 1...iterations {
            patmch2 += testPatmch2();
        }
        output.insertText("patmch:2t: " + String(patmch2 / Double(iterations)) + "\n")
        
        var dict = 0.0
        for _ in 1...iterations {
            dict += testDict();
        }
        output.insertText("dict:t: " + String(dict / Double(iterations)) + "\n")
    }
    
    private func testPatmch1() -> Double {
        let date = NSDate.init()
        let path = Bundle.main.path(forResource: "howto", ofType: "txt")!
        let regEx = "([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)"
        do {
            let data = try String(contentsOfFile: path, encoding: .ascii)
            let strings = data.components(separatedBy: .newlines)
            for line in strings {
                line.range(of: regEx, options: .regularExpression)
            }
        } catch {
            print(error)
        }
        
        return abs(date.timeIntervalSinceNow)
    }
    
    private func testPatmch2() -> Double {
        let date = NSDate.init()
        
        let path = Bundle.main.path(forResource: "howto", ofType: nil)!
        let regEx = "([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)|([^ @]+)@([^ @]+)"
        do {
            let data = try String(contentsOfFile: path, encoding: .ascii)
            let strings = data.components(separatedBy: .newlines)
            for line in strings {
                line.range(of: regEx, options: .regularExpression)
            }
        } catch {
            print(error)
        }
        
        return abs(date.timeIntervalSinceNow)
    }
    
    private func testDict() -> Double {
        let date = NSDate.init()
        
        let path = Bundle.main.path(forResource: "5million", ofType: "txt")!
        var dict = [String : Int]()
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let strings = data.components(separatedBy: .newlines)
            for line in strings {
                var x = 1
                if (dict[line] != nil) {
                    dict[line] = dict[line]! + 1
                } else {
                    dict[line] = 1
                }
            }
        } catch {
            print(error)
        }
        
        return abs(date.timeIntervalSinceNow)
    }
    
    private func testMatMul() -> Double {
        let date = NSDate.init()
        let n = 1000;
        let a = matgen(n: n);
        let b = matgen(n: n);
        matmul(a: a, b: b);
        return abs(date.timeIntervalSinceNow)
    }
    
    private func matgen(n: Int) -> [[Double]] {
        var a = [[Double]](repeating: [Double](repeating: 0, count: n), count: n)
        let tmp = 1.0 / Double(n) / Double(n)
        for i in 0..<n {
            for j in 0...n-1 {
                a[i][j] = tmp * Double((i - j)) * Double((i + j))
            }
        }
        return a;
    }
    
    private func matmul(a: [[Double]], b: [[Double]]) -> [[Double]]{
        let m = a.count, n = a[0].count, p = b[0].count;
        var x = [[Double]](repeating: [Double](repeating: 0, count: p), count: m)
        var c = [[Double]](repeating: [Double](repeating: 0, count: n), count: p)
        for i in 0..<n { // transpose
            for j in 0..<p {
                c[j][i] = b[i][j]
            }
        }
        for i in 0..<m {
            for j in 0..<p {
                var s = 0.0
                for k in 0..<n {
                    s += a[i][k] * c[j][k]
                }
                x[i][j] = s;
            }
        }
    return x;
    }
}
