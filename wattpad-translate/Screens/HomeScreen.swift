//
//  HomeScreen.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import SwiftUI

struct HomeScreen: View {
    @State var wattpadInfoState: WattpadInfo? = nil
    @State var link: String = ""
    
    func openSheet() {
        wattpadInfoState = WattpadInfo(link: self.link)
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Button(action: openSheet) {
                    Text("Go!")
                }
            }
            .sheet(item: $wattpadInfoState) { wattpadInfo in
                WattpadReaderScreen(linkString: wattpadInfo.link, wattpadInfoState: $wattpadInfoState)
            }
        }.searchable(text: $link)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
