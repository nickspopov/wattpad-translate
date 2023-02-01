//
//  WattpadReader.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import SwiftUI

struct WattpadReaderScreen: View {
    var linkString: String
    
    @State private var text: String? = nil
    @State private var errorState: Error? = nil
    @State private var loading: Bool = true
    @State private var nextPageLink: String? = nil
    
    
    func scrapeLink() {
        text = nil
        errorState = nil
        WattpadService.shared.getPageInfo(byString: linkString) { data, error in
            if let _data = data {
                TranslateService.shared.translate(text: _data.text) { translatedText, translateError in
                    if let _translatedText = translatedText {
                        text = _translatedText
                        nextPageLink = _data.nextPageLink
                    }
                }
            }
            if let _error = error {
                errorState = _error
            }
            loading = false
        }
    }
    
    var body: some View {
        NavigationView{
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
                if !(nextPageLink?.isEmpty ?? true) {
                    NavigationLink("Go to next page") {
                        WattpadReaderScreen(linkString: nextPageLink!)
                    }
                }
            }
            .onAppear(perform: scrapeLink)
            .padding()
        }
    }
}

struct WattpadReaderScreen_Previews: PreviewProvider {
    static var previews: some View {
        WattpadReaderScreen(linkString: WattpadService.dummyLink1)
    }
}
