//
//  TranslateService.swift
//  wattpad-translate
//
//  Created by Николай Попов on 01.02.2023.
//

import Foundation
import MLKitTranslate

enum TranslateServiceError: Error {
    case something
}

class TranslateService {
    static var shared: TranslateService = TranslateService()
    
    let translatorOptions: TranslatorOptions
    let translator: Translator
    
    var ready = false

    
    init() {
        self.translatorOptions = TranslatorOptions(sourceLanguage: .english, targetLanguage: .russian)
        self.translator = Translator.translator(options: translatorOptions)
    }
    
    func prepareModel() {
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        print("Start model downloading")
        self.translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            
            self.ready = true
            print("Model is downloaded!")
        }
    }
    
    func translate(text: String, completeHandler: @escaping (String?, Error?) -> Void ) -> Void {
        if(!self.ready) {
            return completeHandler(nil, TranslateServiceError.something)
        }
        
        self.translator.translate(text) { translatedText, error in
            guard error == nil, let translatedText = translatedText else {
                return completeHandler(nil, TranslateServiceError.something)
                
            }
            completeHandler(translatedText, nil)
        }
    }
}
