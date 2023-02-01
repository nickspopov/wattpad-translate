//
//  Wattpad.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import Foundation
import Alamofire
import SwiftSoup

enum WattpadError: Error {
    case parseError
    case networkError
}


struct WattpadInfo: Identifiable {
    var id = UUID()
    var link: String
}

class WattpadService {
    static var shared: WattpadService = WattpadService()
    
    func parseHtml(textHtml: String, completeHandler: @escaping (String?, Error?) -> Void) {
        do {
            let doc = try SwiftSoup.parse(textHtml)
            let panelReadingBlocks = try doc.getElementsByClass("panel-reading")
            var string = ""
            for block in panelReadingBlocks {
                let text = try block.text()
                string = string + text
            }
            completeHandler(string, nil)
        } catch {
            completeHandler(nil, WattpadError.parseError)
        }
    }
    
    func getLinkToNextPage(textHtml: String) {
        do {
            let doc = try SwiftSoup.parse(textHtml)
            let buttonContainer = try doc.getElementById("story-part-navigation")
            let link = try buttonContainer?.children()[0].attr("href")
        } catch {}
    }
    
    func getText(byString: String, completeHandler: @escaping (String?, Error?) -> Void) {
        Task {
            AF.request(byString)
                .responseString { data in
                    let textHtml = data.value!
                    self.getLinkToNextPage(textHtml: textHtml)
                    self.parseHtml(textHtml: textHtml) { data, error in
                        guard let _data = data else {
                            return completeHandler(nil, error)
                        }
                        completeHandler(_data, error)
                    }
                }
        }
    }
    
    static var dummyLink1 = "https://www.wattpad.com/737810183-g-t-short-stories-1-completed-a-worrysome"
    static var dummyLink2 = "https://www.wattpad.com/785407846-g-t-short-stories-1-completed-mental-institute"
}
