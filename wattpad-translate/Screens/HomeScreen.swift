//
//  HomeScreen.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import SwiftUI

struct WattpadSheetState: Identifiable {
    var id = UUID()
    var link: String
}

struct HomeScreen: View {
    @State var wattpadSheetState: WattpadSheetState? = nil
    @State var searchLink: String = ""
    
    func openSheet() {
        wattpadSheetState = WattpadSheetState(link: self.searchLink)
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Button(action: openSheet) {
                    Text("Go!")
                }
            }
            .sheet(item: $wattpadSheetState) { wattpadInfo in
                WattpadReaderScreen(linkString: wattpadInfo.link)
            }
        }.searchable(text: $searchLink)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
