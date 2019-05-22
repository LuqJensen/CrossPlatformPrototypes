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
        
        let path = Bundle.main.path(forResource: "howto", ofType: nil)!
        let regEx = "([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)"
        if let aStreamReader = StreamReader(path: path) {
            defer {
                aStreamReader.close()
            }
            while let line = aStreamReader.nextLine() {
                line.range(of: regEx, options: .regularExpression)
            }
        }
        
        return abs(date.timeIntervalSinceNow)
    }
    
    private func testPatmch2() -> Double {
        let date = NSDate.init()
        
        let path = Bundle.main.path(forResource: "howto", ofType: nil)!
        let regEx = "([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)|([^ @]+)@([^ @]+)"
        if let aStreamReader = StreamReader(path: path) {
            defer {
                aStreamReader.close()
            }
            while let line = aStreamReader.nextLine() {
                line.range(of: regEx, options: .regularExpression)
            }
        }
        
        return abs(date.timeIntervalSinceNow)
    }
    
    private func testDict() -> Double {
        let date = NSDate.init()
        
        let path = Bundle.main.path(forResource: "5million", ofType: "txt")!
        var dict = [String : Int]()
        if let aStreamReader = StreamReader(path: path) {
            defer {
                aStreamReader.close()
            }
            while let line = aStreamReader.nextLine() {
                var x = 1
                if (dict[line] != nil) {
                    dict[line] = dict[line]! + 1
                } else {
                    dict[line] = 1
                }
            }
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

///From https://stackoverflow.com/questions/24581517/read-a-file-url-line-by-line-in-swift
class StreamReader  {
    
    let encoding : String.Encoding
    let chunkSize : Int
    var fileHandle : FileHandle!
    let delimData : Data
    var buffer : Data
    var atEof : Bool
    
    init?(path: String, delimiter: String = "\n", encoding: String.Encoding = .utf8,
          chunkSize: Int = 4096) {
        
        guard let fileHandle = FileHandle(forReadingAtPath: path),
            let delimData = delimiter.data(using: encoding) else {
                return nil
        }
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = delimData
        self.buffer = Data(capacity: chunkSize)
        self.atEof = false
    }
    
    deinit {
        self.close()
    }
    
    /// Return next line, or nil on EOF.
    func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")
        
        // Read data chunks from file until a line delimiter is found:
        while !atEof {
            if let range = buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEof = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }
    
    /// Start reading from the beginning of file.
    func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEof = false
    }
    
    /// Close the underlying file. No reading must be done after calling this method.
    func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}

extension StreamReader : Sequence {
    func makeIterator() -> AnyIterator<String> {
        return AnyIterator {
            return self.nextLine()
        }
    }
}
