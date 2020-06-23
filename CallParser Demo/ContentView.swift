//
//  ContentView.swift
//  CallParser Demo
//
//  Created by Peter Bourget on 6/6/20.
//  Copyright © 2020 Peter Bourget. All rights reserved.
//

import SwiftUI
import CallParser

extension EnvironmentObject
{
  var safeToUse: Bool {
    return (Mirror(reflecting: self).children.first(where: { $0.label == "_store"})?.value as? ObjectType) != nil
  }
}

struct ContentView: View {
  @EnvironmentObject var callParser: PrefixFileParser
  @EnvironmentObject var callLookup: CallLookup
  @State private var callSign = "W6OP"
  @State var hitList = [Hit]()
  
    var body: some View {
      VStack{
        HStack{
          TextField("Enter Call Sign", text: $callSign)
          .frame(maxWidth: 100)
          Button(action: {_ = lookupCall(call: self.callSign, callLookup: self.callLookup)}) {
            Text("Lookup")
          }
          Spacer()
        }
        HStack {
          Button(action: {_ = loadCompoundFile(callLookup: self.callLookup)}) {
            Text("Run Batch Job")
          }
          Spacer()
        }
        HStack {
          PrefixDataRow(hitList: hitList).environmentObject(self.callLookup)
          //Spacer().frame(minHeight: 300)
        }
      }.frame(minWidth: 800)
    }
}


struct PrefixDataRow: View {
  @EnvironmentObject var callLookup: CallLookup
  @State public var hitList: [Hit]

    var body: some View {
      
      ScrollView {
      VStack {
       ForEach(callLookup.hitList, id: \.self) { hit in
          HStack {
            Text(hit.call)
            .frame(minWidth: 75, maxWidth: 75, alignment: .leading)
            .padding()
            Divider()
            
            Text(hit.kind.rawValue)
              .frame(minWidth: 65, maxWidth: 65, alignment: .leading)
            .padding()
             Divider()
            
            Text(hit.country)
              .frame(minWidth: 150, maxWidth: 150, alignment: .leading)
            .padding()
             Divider()
            
            Text(hit.province)
                .frame(minWidth: 150, maxWidth: 150, alignment: .leading)
                .padding()
                Divider()
            
            Text(String(hit.dxcc_entity))
              .frame(minWidth: 55, maxWidth: 55, alignment: .leading)
            .padding()
          
          }.frame(maxHeight: 10)
        }//.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 500)
      }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 500, alignment: .topLeading)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/**
 
 */
func lookupCall(call: String, callLookup: CallLookup) -> [Hit] {
  
  return callLookup.lookupCall(call: call)
    //print(hitlist)
  
}

func loadCompoundFile(callLookup: CallLookup) -> [Hit] {
  
  return callLookup.loadCompoundFile()

}

