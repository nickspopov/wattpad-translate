//
//  ContentView.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import SwiftUI

struct ContentView: View {
    @State var text: String? = nil
    @State var errorState: Error? = nil
    @State var loading: Bool = false
    
    
    func scrapeLink() {
        var link = URL(string: "https://www.wattpad.com/1297832299-the-remarried-empress-chapter-1-a-fallen-empress")!
        
        loading.toggle()
        text = nil
        errorState = nil
        WattpadService.shared.getText(byLink: link) { data, error in
            if let _data = data {
                text = _data
            }
            if let _error = error {
                errorState = _error
            }
            loading.toggle()
        }
    }
    
    var body: some View {
        VStack {
            Button(action: scrapeLink) {
                Text("Start!")
            }
            .padding()
            if loading {
                ProgressView()
            }
            if text?.count ?? 0 > 0 {
                Text(text!)
            }
            if errorState != nil {
                Text("Error").foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
