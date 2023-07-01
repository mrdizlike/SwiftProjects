//
//  main.swift
//  Algo
//
//  Created by Виктор on 12.04.2023.
//

import Foundation

// a = 100, b = 50 mb, c = 1mb/5, d = 55
func payment(a: Int, b: Int, c: Int, d:Int) -> Int {
    var totalSum = 0
    if (d <= b) {
        totalSum = a
    } else {
        totalSum = a + (d-b) * c
    }
    return totalSum
}

func cake(n: Int) -> Int {
    var totalBlades = 0
    let check = n % 2
    print(check)
    totalBlades = n / 2
    if check != 0 {
        totalBlades += 1
    }
    return totalBlades
}

print(cake(n: 6))
