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
    
    func checkSharedPrefToGetLink() {
        let data = UserDefaults(suiteName: ConstantsService.groupName)?.string(forKey: ConstantsService.urlDefaultNameShareExtension)
        
        if let _data = data {
            searchLink = _data
            UserDefaults(suiteName: ConstantsService.groupName)?.removeObject(forKey: ConstantsService.urlDefaultNameShareExtension)
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Button(action: openSheet) {
                    Text("Go!")
                }
            }
            .sheet(item: $wattpadSheetState) { wattpadInfo in
                NavigationView{
                    WattpadReaderScreen(linkString: wattpadInfo.link)
                }
            }
        }
        .searchable(text: $searchLink)
        .onAppear(perform: checkSharedPrefToGetLink)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
