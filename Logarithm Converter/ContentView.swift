//
//  ContentView.swift
//  Logarithm Converter
//
//  Created by Luke Drushell on 11/19/21.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    
    //All credit for project idea goes to https://github.com/jakeroggebuck & to be fair he does it way better
    
    @State var numberInput: String = ""
    @State var calculate = false
    @State var output = ""
    
    @FocusState var showKeyboard
    @State var showGraph = false
    
    let defaultLegend = Legend(color: .red, label: "Undefined")
    @State var baseOutput: [DataPoint] = []
    @State var resultOutput: [DataPoint] = []
    @State var reps = 0
    var body: some View {
        VStack {
            TextField("Enter a Whole Number", text: $numberInput)
                .keyboardType(.numberPad)
                .padding()
                .background(.regularMaterial)
                .cornerRadius(50)
                .padding(.horizontal)
                .focused($showKeyboard)
            
            Button {
                calculate = true
                output = convertToLog(theUserInput: Double(numberInput) ?? 0.0)
                baseOutput = baseUpdating(theUserInput: Double(numberInput) ?? 0.0)
                resultOutput = resultUpdating(theUserInput: Double(numberInput) ?? 0.0)
                reps = repetitionCount(theUserInput: Double(numberInput) ?? 0.0)
                numberInput = ""
            } label: {
                Text("Calculate")
                    .padding()
            }
            
            Button {
                UIPasteboard.general.setValue(output, forPasteboardType: "public.plain-text")
            } label: {
                Text(output)
                    .foregroundColor(.primary)
                    .padding()
            }
            
            Button {
                withAnimation(.spring(), {
                    showGraph.toggle()
                })
            } label: {
                Text("Show Data")
                    .padding()
            }
            
            if showGraph {
                LineChartView(dataPoints: baseOutput)
                    .frame(height: 300, alignment: .center)
                    .padding()
                Text("Repetitions: \(reps)")
                
            }
        } .toolbar(content: {
            ToolbarItemGroup(placement: .keyboard, content: {
                HStack {
                    Spacer()
                    Button {
                        showKeyboard.toggle()
                    } label: {
                        Text("Done")
                    }
                }
            })
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func convertToLog(theUserInput: Double) -> String {
    let combined = "0." + "\(theUserInput)"
    let userInput = (combined as NSString).doubleValue
    let input: Double = 0 + userInput
    var base: Double = 2
    var output: Double = 0
    var result: Double = 10
    var growthQuanitity: Double = 100000
    var greater = 0
    var lesser = 0
    var repetitions = 0
    var addition: Double = 0.2
    if 0.2 >= userInput { addition = 0 }
    while "\(output)" != "\(input)" {
        repetitions += 1
        let logarithm = log(result)/log(base) + addition
        if logarithm > Double(input) {
            base += Double(1*growthQuanitity)
            greater = 1
        } else if logarithm < Double(input) {
            base -= Double(1*growthQuanitity)
            lesser = 1
        }
        if greater == 1 && lesser == 1 {
            growthQuanitity = growthQuanitity / 1.01
            greater = 0
            lesser = 0
        }
        if logarithm.distance(to: Double(input)) > 0.1 { result += 1 }
        //Set Result at End of Each Loop
        output = logarithm
        //Kills Loop if Goes on Too Long
        if repetitions > 3000000 {
            result = 0
            base = 0
            output = input
        }
    }
    var returnValue = "log\(result)/log\(base) + 0.2"
    if addition == 0 { returnValue = "log\(result)/log\(base)" }
    return returnValue
    
}

func resultUpdating(theUserInput: Double) -> [DataPoint] {
    
    let resultLegned = Legend(color: .teal, label: "Result Values")
    
    let combined = "0." + "\(theUserInput)"
    let userInput = (combined as NSString).doubleValue
    let input: Double = 0 + userInput
    var base: Double = 2
    var output: Double = 0
    var result: Double = 10
    var growthQuanitity: Double = 100000
    var greater = 0
    var lesser = 0
    var repetitions = 0
    var addition: Double = 0.2
    
    var resultArray: [DataPoint] = [.init(value: 10, label: "10", legend: resultLegned)]
    
    if 0.2 >= userInput { addition = 0 }
    while "\(output)" != "\(input)" {
        repetitions += 1
        let logarithm = log(result)/log(base) + addition
        if logarithm > Double(input) {
            base += Double(1*growthQuanitity)
            greater = 1
        } else if logarithm < Double(input) {
            base -= Double(1*growthQuanitity)
            lesser = 1
        }
        if greater == 1 && lesser == 1 {
            growthQuanitity = growthQuanitity / 1.01
            greater = 0
            lesser = 0
        }
        if logarithm.distance(to: Double(input)) > 0.1 { result += 1 }
        //Set Result at End of Each Loop
        output = logarithm
        //Kills Loop if Goes on Too Long
        if repetitions > 3000000 {
            result = 0
            base = 0
            output = input
        }
        if (repetitions % 50) == 0 {
            resultArray.append(.init(value: result, label: "\(repetitions)", legend: resultLegned))
        }
    }
    
    return resultArray
    
}

func baseUpdating(theUserInput: Double) -> [DataPoint] {
    
    let baseLegend = Legend(color: .green, label: "Base Values")
    
    let combined = "0." + "\(theUserInput)"
    let userInput = (combined as NSString).doubleValue
    let input: Double = 0 + userInput
    var base: Double = 2
    var output: Double = 0
    var result: Double = 10
    var growthQuanitity: Double = 100000
    var greater = 0
    var lesser = 0
    var repetitions = 0
    var addition: Double = 0.2
    
    var baseArray: [DataPoint] = [.init(value: 2, label: "2", legend: baseLegend)]
    
    if 0.2 >= userInput { addition = 0 }
    while "\(output)" != "\(input)" {
        repetitions += 1
        let logarithm = log(result)/log(base) + addition
        if logarithm > Double(input) {
            base += Double(1*growthQuanitity)
            greater = 1
        } else if logarithm < Double(input) {
            base -= Double(1*growthQuanitity)
            lesser = 1
        }
        if greater == 1 && lesser == 1 {
            growthQuanitity = growthQuanitity / 1.01
            greater = 0
            lesser = 0
        }
        if logarithm.distance(to: Double(input)) > 0.1 { result += 1 }
        //Set Result at End of Each Loop
        output = logarithm
        //Kills Loop if Goes on Too Long
        if repetitions > 3000000 {
            result = 0
            base = 0
            output = input
        }
        if (repetitions % 50) == 0 {
            baseArray.append(.init(value: base, label: "\(repetitions)", legend: baseLegend))
        }
    }
    
    return baseArray
    
}

func repetitionCount(theUserInput: Double) -> Int {
    let combined = "0." + "\(theUserInput)"
    let userInput = (combined as NSString).doubleValue
    let input: Double = 0 + userInput
    var base: Double = 2
    var output: Double = 0
    var result: Double = 10
    var growthQuanitity: Double = 100000
    var greater = 0
    var lesser = 0
    var repetitions = 0
    var addition: Double = 0.2
    
    if 0.2 >= userInput { addition = 0 }
    while "\(output)" != "\(input)" {
        repetitions += 1
        let logarithm = log(result)/log(base) + addition
        if logarithm > Double(input) {
            base += Double(1*growthQuanitity)
            greater = 1
        } else if logarithm < Double(input) {
            base -= Double(1*growthQuanitity)
            lesser = 1
        }
        if greater == 1 && lesser == 1 {
            growthQuanitity = growthQuanitity / 1.01
            greater = 0
            lesser = 0
        }
        if logarithm.distance(to: Double(input)) > 0.1 { result += 1 }
        //Set Result at End of Each Loop
        output = logarithm
        //Kills Loop if Goes on Too Long
        if repetitions > 3000000 {
            result = 0
            base = 0
            output = input
        }
    }
    return repetitions
}
