//
//  ContentView.swift
//  Example
//
//  Created by Tomoya Hirano on 2019/11/03.
//  Copyright © 2019 Tomoya Hirano. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var items: [Int] = [0,1,2,3,4,5,6,7,8,9]
    @State var isLoading: Bool = false
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    
                }) {
                    Text("\(item)")
                }
            }
        }
        .onPull(perform: {
            self.isLoading = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.items.shuffle()
                self.isLoading = true
            }
        }, isLoading: isLoading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
