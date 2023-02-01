//
//  HomeScreen.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import SwiftUI

struct WattpadInfo: Identifiable {
    var id = UUID()
    var link: String
}

struct HomeScreen: View {
    @State var wattpadInfoState: WattpadInfo? = nil
    
    func openSheet() {
        wattpadInfoState = WattpadInfo(link: "https://www.wattpad.com/1297832299-the-remarried-empress-chapter-1-a-fallen-empress")
    }
    
    var body: some View {
        VStack {
            Button(action: openSheet) {
                Text("Go!")
            }
        }
        .sheet(item: $wattpadInfoState) { _wattpadInfo in
            WattpadReaderScreen(linkString: _wattpadInfo.link)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
