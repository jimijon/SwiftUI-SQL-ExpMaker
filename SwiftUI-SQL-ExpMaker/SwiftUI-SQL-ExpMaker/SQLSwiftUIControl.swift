//
//  SQLSwiftUIControl.swift
//  TrendPlay2
//
//  Created by James Cicenia on 8/26/19.
//  Copyright © 2019 James Cicenia. All rights reserved.
//

import SwiftUI
import Sliders


struct SQLSwiftUIControl: View {
    
    @Binding var col:String
    @Binding var op:String
    @Binding var val:Double
    @Binding var lBound:Double
    @Binding var uBound:Double
    @Binding var lRange:Double
    @Binding var uRange:Double  
    @Binding var step:Double
    

    @State private var queryTypeValue = 0
    @State private var range:ClosedRange<Double>
    @State private var stateOp = "="
    @State private var stateVal = 0.0

    private var orig_value: Double
    private var orig_operand: String
    private var orig_lowerRange:Double
    private var orig_upperRange:Double
    private var queryDictionary:[String:String] = [:]

    init(
         col: Binding<String>,
         op: Binding<String>,
         val: Binding<Double>,
         lBound: Binding<Double>,
         uBound: Binding<Double>,
         lRange: Binding<Double>,
         uRange: Binding<Double>,
         step: Binding<Double>){
        
            self._col = col
            self._op = op
            self._val = val
            self._lBound = lBound
            self._uBound = uBound
            self._lRange = lRange
            self._uRange = uRange
            self._step = step
        
            self.orig_value  = val.wrappedValue
            self.orig_operand = op.wrappedValue
            self.orig_lowerRange = lRange.wrappedValue
            self.orig_upperRange = uRange.wrappedValue
        
            self._range = State(initialValue: lRange.wrappedValue...uRange.wrappedValue)
            self._stateOp = State(initialValue: op.wrappedValue)
            self._stateVal = State(initialValue: val.wrappedValue)
        
        }
        
    

    let operators = ["=","≠","<",">","< >"]

    private func queryCallback(){
       
        var queryString = ""
        switch self.operators[queryTypeValue] {
        case "< >":
    
          queryString = " AND " + col + " BETWEEN " + String(format: "%.0f", self.range.lowerBound as Double) + " AND " + String(format: "%.0f", self.range.upperBound as Double)
            
        case "≠":
          
          queryString = " AND LENGTH(\(col)) !=0 AND " + col + " != " + String(format: "%.0f", val as Double)
            
        default:
            
          queryString = " AND LENGTH(\(col)) !=0 AND " + col + " " + self.operators[queryTypeValue] + " " + String(format: "%.0f", val as Double)
        }
            
        ////// Update environment Dictionary
        // envObj.queryDictionary[col] = queryString
        
        ////// Do something like run a query here"
        // database.runQuery()
        
        ////// Update the Bindings
        val = stateVal
        op = stateOp
        
        print(queryString)
        
    }
    
   //* Reset *//
    ///resets the controls back to original values
    
    private func reset(){
        val = orig_value
        op = orig_operand
        lRange = orig_lowerRange
        uRange = orig_upperRange
    }
    
    var body: some View {
                
                let queryType = Binding<Int>(get: {
                    return self.queryTypeValue
                }, set: {
                    self.queryTypeValue = $0
                    self.queryCallback()

                })
                return NavigationView {
                
            
                List {
                    
                    Section(header: HStack {
                        HStack {
                            Text(col)
                            Spacer()
                            Button(action: self.reset) {
                                Image(systemName: "xmark.square")
                            }
                        }
                        .background(Color("TPDarkGrey"))
                        .font(.system(size: 14))
                        .foregroundColor(Color.white)
                        .frame(height:CGFloat(28.0))
                        .padding()
                        
                    }) {
                        
                    Picker(selection: queryType, label: Text("Query Type")) {
                        ForEach(0..<self.operators.count) { index in
                            Text(self.operators[index]).tag(index)
                         }
                     }.pickerStyle(SegmentedPickerStyle())
                        
                         if queryTypeValue  == 4 {
                            
                            // SHOW RANGE SLIDER (BETWEEN)
                             HStack {
                                Text(String(format: "%.0f", range.lowerBound as Double))

                                RangeSlider(range:$range, in: lBound...uBound, onEditingChanged: {value in
                                    if !value {
                                        self.queryCallback()
                                    }
                                })
                                
                                Text(String(format: "%.0f", range.upperBound as Double))
                             }
                             .padding()

                         }else {
                            // SINGLE VALUE SLIDER (=,<,>,≠)
                             HStack {

                                 ValueSlider(value: $stateVal, in: lBound...uBound, step: step, onEditingChanged: {value in
                                     if !value {
                                         self.queryCallback()
                                     }
                                 })
                                Text(String(format: "%.0f", stateVal as Double))

                             }.padding()
                             
                         }
                                                             
                    }
                    .listStyle(GroupedListStyle())
                    .navigationBarTitle("SQL Control")
                }
           }
          .navigationViewStyle(StackNavigationViewStyle())
       
    }
        
}

#if DEBUG
struct SQLSwiftUIControl_Previews: PreviewProvider {
    
    struct SQLSwiftUIControlView: View {
        @State var value: Double = 1969.0
        @State var operand: String = "="
        @State var lowerRange:Double = 1969.0
        @State var upperRange:Double = 2018.0
        
        var body: some View {
            SQLSwiftUIControl(
                col: .constant("Season"),
                op: $operand,
                val: $value,
                lBound: .constant(1940.0),
                uBound: .constant(2019.0),
                lRange: $lowerRange,
                uRange: $upperRange,
                step: .constant(1.0)
            )
        }
    }

    static var previews: some View {
        SQLSwiftUIControlView()
    }
    
}
#endif
            
