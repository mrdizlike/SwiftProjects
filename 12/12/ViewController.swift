import Foundation

class Something
 
func validate(_ cardNumber: String) -> Bool {
    let numbers = cardNumber
        .map(String.init)
  
    let sequence = numbers[0 ..< numbers.count]
    let controlNumber = numbers[15]
  
    let sum = sequence
        .enumerated()
        .reduce(into: 0, { partialResult, item in
        switch item.offset % 2 {
        case 0 where item.element * 2 > 9:
            partialResult += (item.element * 2) - 9
        case 0:
            partialResult += item.element * 2
        default:
            partialResult += item.element
        }
    })
  
    return sum  / 10 == .zero
}
 
if let input = readLine() {
    print(validate(input))
}
