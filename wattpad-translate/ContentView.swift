//
//  ContentView.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeScreen()
            .onAppear(perform: TranslateService.shared.prepareModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
