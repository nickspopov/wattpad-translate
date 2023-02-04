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

struct WattpadPageInfo {
    var text: String
    var nextChapterLink: String?
}

struct WattpadParseHtmlInfo {
    var text: String
    var nextPageLink: String?
}

class WattpadService {
    static var shared: WattpadService = WattpadService()
    
    private var concatanetedText: String? = nil
    
    func getNextPageLink(textHtml: String) -> String? {
        do {
            let doc = try SwiftSoup.parse(textHtml)
            let nextPageAttr = try doc.getElementsByAttributeValue("rel", "next")
            if nextPageAttr.count > 0 {
                let link = try nextPageAttr[0].attr("href")
                return link
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func parseHtml(textHtml: String, completeHandler: @escaping (WattpadParseHtmlInfo?, Error?) -> Void) {
        do {
            let doc = try SwiftSoup.parse(textHtml)
            let panelReadingBlocks = try doc.getElementsByClass("panel-reading")
            var string = ""
            for block in panelReadingBlocks {
                let text = try block.text()
                string = string + text
            }
            completeHandler(WattpadParseHtmlInfo(
                text: string,
                nextPageLink: self.getNextPageLink(textHtml: textHtml)
            ), nil)
        } catch {
            completeHandler(nil, WattpadError.parseError)
        }
    }
    
    func getLinkToNextChapter(textHtml: String, completeHandler: @escaping (String?, Error?) -> Void) {
        do {
            let doc = try SwiftSoup.parse(textHtml)
            let buttonContainer = try doc.getElementById("story-part-navigation")
            let link = try buttonContainer?.children()[0].attr("href")
            if let _link = link {
                completeHandler(_link, nil)
            } else {
                completeHandler(nil, WattpadError.parseError)
            }
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
                        completeHandler(_data.text, error)
                    }
                }
        }
    }
    
    func getPageInfo(byString: String, completeHandler: @escaping (WattpadPageInfo?, Error?) -> Void) {
        Task {
            AF.request(byString)
                .responseString { data in
                    let textHtml = data.value!
                    self.parseHtml(textHtml: textHtml) { text, error in
                        guard let _text = text else {
                            return completeHandler(nil, error)
                        }
                        self.getLinkToNextChapter(textHtml: textHtml) { nextPageLink, getLinkError in
                            guard let _nextPageLink = nextPageLink else {
                                return completeHandler(WattpadPageInfo(text: _text.text), nil)
                            }
                            return completeHandler(WattpadPageInfo(text: _text.text, nextChapterLink: _nextPageLink), nil)
                        }
                    }
                }
        }
    }
    
    func getPageInfo(byStringRecursive: String, completeHandler: @escaping (WattpadPageInfo?, Error?) -> Void) {
        Task {
            AF.request(byStringRecursive)
                .responseString { data in
                    let textHtml = data.value!
                    self.parseHtml(textHtml: textHtml) { wattpadParseHtmlInfo, error in
                        guard let _wattpadParseHtmlInfo = wattpadParseHtmlInfo else {
                            return completeHandler(nil, error)
                        }
                        if !(_wattpadParseHtmlInfo.nextPageLink?.isEmpty ?? true) {
                            self.concatanetedText = (self.concatanetedText ?? "") + _wattpadParseHtmlInfo.text
                            return self.getPageInfo(byStringRecursive: _wattpadParseHtmlInfo.nextPageLink!, completeHandler: completeHandler)
                        } else {
                            self.getLinkToNextChapter(textHtml: textHtml) { nextPageLink, getLinkError in
                                guard let _nextPageLink = nextPageLink else {
                                    if let _fullText = self.concatanetedText {
                                        return completeHandler(WattpadPageInfo(text: _fullText + _wattpadParseHtmlInfo.text), nil)
                                    }
                                    return completeHandler(WattpadPageInfo(text: _wattpadParseHtmlInfo.text), nil)
                                }
                                return completeHandler(WattpadPageInfo(text: _wattpadParseHtmlInfo.text, nextChapterLink: _nextPageLink), nil)
                            }
                        }
                    }
                }
        }
    }

    
    static var dummyLink1 = "https://www.wattpad.com/737810183-g-t-short-stories-1-completed-a-worrysome"
    static var dummyLink2 = "https://www.wattpad.com/785407846-g-t-short-stories-1-completed-mental-institute"
}
