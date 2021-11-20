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
                let data = convertToLog(theUserInput: Double(numberInput) ?? 0.0)
                output = data.0
                baseOutput = data.3
                resultOutput = data.2
                reps = data.1
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
                Text("Data Points: \(resultOutput.count - 1)")
                
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

func convertToLog(theUserInput: Double) -> (String, Int, [DataPoint], [DataPoint]) {
    
    let resultLegned = Legend(color: .teal, label: "Result Values")
    let baseLegend = Legend(color: .green, label: "Base Values")
    var resultArray: [DataPoint] = [.init(value: 2, label: "1", legend: resultLegned)]
    var baseArray: [DataPoint] = [.init(value: 2, label: "1", legend: baseLegend)]
    
    
    let combined = "0." + "\(theUserInput)"
    let userInput = (combined as NSString).doubleValue
    let input: Double = 0 + userInput
    var base: Double = 2
    var output: Double = 0
    var result: Double = 2
    var growthQuanitity: Double = 1000
    var greater = 0
    var lesser = 0
    var repetitions = 0
    var addition: Double = 0.2
    
    var uncompleted = false
    var recoveredOutput: Double = 0
    
    if 0.3 >= userInput { addition = 0 }
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
            growthQuanitity = growthQuanitity / 2
            greater = 0
            lesser = 0
        }
        if logarithm.distance(to: Double(input)) > 0.1 { result += 1 }
        //Set Result at End of Each Loop
        output = logarithm
        //Kills Loop if Goes on Too Long
        if repetitions > 1000000 {
            recoveredOutput = output
            output = input
            uncompleted = true
        }
        
        resultArray.append(.init(value: result, label: "\(repetitions)", legend: resultLegned))
        baseArray.append(.init(value: base, label: "\(repetitions)", legend: baseLegend))
        
    }
    
    if repetitions > 5000 {
        let three: Double = 3
        var repLog: Double = log(Double(repetitions)) / log(Double(three))
        repLog.round()
        let repInt = Int(repLog)
        for _ in 0...repInt {
            resultArray = resultArray.enumerated().compactMap { tuple in
              tuple.offset.isMultiple(of: 2) ? tuple.element : nil
            }
            baseArray = baseArray.enumerated().compactMap { tuple in
              tuple.offset.isMultiple(of: 2) ? tuple.element : nil
            }
        }
    }
    
    var returnValue = "log\(result)/log\(base) + 0.2"
    if addition == 0 { returnValue = "log\(result)/log\(base)" }
    if uncompleted { returnValue = "Error: \(returnValue) = \(recoveredOutput) rather than \(input)" }
    return (returnValue, repetitions, resultArray, baseArray)
    
}
