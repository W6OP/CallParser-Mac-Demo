//
//  ContentView.swift
//  CallParser Demo
//
//  Created by Peter Bourget on 6/6/20.
//  Copyright © 2020 Peter Bourget. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @State private var callSign = ""
  
    var body: some View {
      VStack{
        HStack{
          TextField("Enter Call Sign", text: $callSign)
          .frame(maxWidth: 100)
          Button(action: {LookupCall()}) {
            Text("Lookup")
          }
        }
      }
      
      
    }
}

func LookupCall() {
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
