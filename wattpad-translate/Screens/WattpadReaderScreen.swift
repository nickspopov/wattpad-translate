//
//  WattpadReader.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import SwiftUI

struct WattpadReaderScreen: View {
    var linkString: String
    
    @State var text: String? = nil
    @State var errorState: Error? = nil
    @State var loading: Bool = true
    
    
    func scrapeLink() {
        text = nil
        errorState = nil
        WattpadService.shared.getText(byString: linkString) { data, error in
            if let _data = data {
                text = _data
            }
            if let _error = error {
                errorState = _error
            }
            loading = false
        }
    }
    
    var body: some View {
        ScrollView {
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
        .onAppear(perform: scrapeLink)
        .padding()
    }
}

struct WattpadReaderScreen_Previews: PreviewProvider {
    static var previews: some View {
        WattpadReaderScreen(linkString: "https://www.wattpad.com/1297832299-the-remarried-empress-chapter-1-a-fallen-empress")
    }
}
