//
//  WattpadReader.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import SwiftUI

struct WattpadReaderScreen: View {
    var linkString: String
    
    @Binding var wattpadInfoState: WattpadInfo?
    
    @State private var text: String? = nil
    @State private var errorState: Error? = nil
    @State private var loading: Bool = true
    
    
    func scrapeLink() {
        text = nil
        errorState = nil
        WattpadService.shared.getText(byString: linkString) { data, error in
            if let _data = data {
                TranslateService.shared.translate(text: _data) { translatedText, translateError in
                    if let _translatedText = translatedText {
                        text = _translatedText
                    }
                }
            }
            if let _error = error {
                errorState = _error
            }
            loading = false
        }
    }
    
    func goToNextPage() {
        wattpadInfoState = WattpadInfo(link: "https://www.wattpad.com/768296833-g-t-short-stories-1-completed-new-life-pt-2")
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
            Button(action: goToNextPage) {
                Text("Next Page!")
            }
        }
        .onAppear(perform: scrapeLink)
        .padding()
    }
}

struct WattpadReaderScreen_Previews: PreviewProvider {
    static var previews: some View {
        WattpadReaderScreen(linkString: "https://www.wattpad.com/1297832299-the-remarried-empress-chapter-1-a-fallen-empress", wattpadInfoState: .constant(WattpadInfo(link: "https://www.wattpad.com/1297832299-the-remarried-empress-chapter-1-a-fallen-empress")))
    }
}
