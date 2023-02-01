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
    
    func getText(byString: String, completeHandler: @escaping (String?, Error?) -> Void) {
        Task {
            AF.request(byString)
                .responseString { data in
                    let textHtml = data.value!
                    self.parseHtml(textHtml: textHtml) { data, error in
                        guard let _data = data else {
                            return completeHandler(nil, error)
                        }
                        completeHandler(_data, error)
                    }
                }
        }
    }
}
