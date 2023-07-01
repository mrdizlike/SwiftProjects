//
//  ContentView.swift
//  WeSplit
//
//  Created by Виктор on 01.06.2023.
//

import SwiftUI

struct newContentView: View{
    let tipPercentages = [10, 15, 20, 25, 0]
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.identifier ))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section{
                    Text("Total amount: \(checkAmount + totalPerPerson)")
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.identifier))
                } header: {
                    Text("Amount per person")
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("How much tip do you want to leave?")
                }
            }
        }
        .navigationTitle("WeSplit")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard){
                Spacer()
                
                Button("Done") {
                    amountIsFocused = false
                }
            }
        }
    }
}

struct ContentView: View {
    let students = ["Harry", "Hermione", "Ron"]
    @State private var tapCount = 0
    @State private var name = ""
    @State private var selectedStudent = "Harry"
    
    var body: some View {
        Form {
            TextField("Enter your name", text: $name)
            Text("Your name is \(name)")
        }
        Button("Tap Count: \(tapCount)"){
            self.tapCount += 1
        }
        
        NavigationView{
            Form {
                Picker("Select your student", selection: $selectedStudent){
                    ForEach(students, id: \.self){
                        Text($0)
                    }
                }
            }
            Form {
                Text("Hello world")
                Text("Hello world")
                Text("Hello world")
                
                Group {
                    Text("hi")
                }
                
                Section {
                    Text("You")
                    Text("You")
                }
                
                Section {
                    Text("You")
                }
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        newContentView()
    }
}
