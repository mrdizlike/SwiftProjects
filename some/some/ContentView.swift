//
//  ContentView.swift
//  some
//
//  Created by Виктор on 02.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var resultRequest = ""
    @State private var inputText = ""
    var body: some View {
        
    }
    

    
    func request(){
        print(inputText)
        let urlString = "http://127.0.0.1:5000/send?a=\(inputText.replacingOccurrences(of: " ", with: "+"))"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let result = (json as? [String: Any])?["result"] as? String {
                        print("Result: \(result)")
                        resultRequest = result
                    }
                }
            }
            task.resume()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hex: String, opacity: Double = 1) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, opacity: opacity)
    }
}
