//
//  ContentView.swift
//  InfiniteList
//
//  Created by Leslie Meadows on 9/28/21.
//

import SwiftUI
import Foundation
import Combine


class myStruct: ObservableObject {
    @Published var counter: [myInt]
    @Published var cnt : Int = 0
    init() {
        counter = []
        counter.append(myInt(value: 0))
        cnt = counter.count
    }
    
    static let mediumDateTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        
        return df
    }()
    
    func getMoreData(index: Int) {
        print("GetMoreData Called")
        print("Index = \(index)")
        let newValue = (index - 1)  + 1
        print("newValue = \(newValue)")
        counter.append(myInt(value: newValue))
        print("Index = \(index) / newValue = \(newValue)")
        cnt = counter.count
    }
}
class myInt: Identifiable {
    var id = UUID()
    var value: Int
    var created: Date = Date()
    
    init(value: Int) {
        self.value = value
    }
}
struct ContentView: View {
    @StateObject var counterobj: myStruct = myStruct()
    var body: some View {
        ScrollView {
            LazyVStack (alignment: .leading) {
                ForEach (counterobj.counter) { obj in
                    numberView(value: obj.value, cdate: obj.created)
                        .onAppear() {
                            print("Requesting more Items")
                            counterobj.getMoreData(index: counterobj.counter.count)
                        }
                }
            }.frame(width: .infinity)
        }
    }
}

struct numberView: View {
    var value: Int
    var cdate: Date
    var body: some View {
        HStack {
            Image(systemName: "number.square")
                .foregroundColor(.purple)
            HStack {
                Text("\(value)")
                Spacer()
                Text("Created : \(myStruct.mediumDateTimeFormatter.string(from: cdate))")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                
            }
        }.padding(.horizontal)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
