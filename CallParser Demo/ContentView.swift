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
  
    var body: some View {
      VStack{
        HStack{
          TextField("Enter Call Sign", text: $callSign)
          .frame(maxWidth: 100)
          Button(action: {LookupCall(call: self.callSign, callLookup: self.callLookup)}) {
            Text("Lookup")
          }
          
        }
      }.frame(minWidth: 250, minHeight: 150)
    }
}

func LookupCall(call: String, callLookup: CallLookup) {
  //var callLookup: CallLookup
  
  do {
  let hitlist: [HitList] = try callLookup.lookupCall(call: call)
    print(hitlist)
  }
  catch {
      print(error.localizedDescription)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
