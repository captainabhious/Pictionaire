//
//  Translation.swift
//  Pictionaire
//
//  Created by Abhi Singh on 12/7/17.
//  Copyright © 2017 Abhi Singh. All rights reserved.
//
//
//import Foundation
//import ROGoogleTranslate
//
//class Translate: ROGoogleTranslate {
//    
//    
//    
//    
//    var params = ROGoogleTranslateParams(source: "en",
//                                         target: "de",
//                                         text:   "Here you can add your sentence you want to be translated")
//    
//    
//    func thing () {
//        
//        let translator = ROGoogleTranslate()
//        translator.apiKey = "AIzaSyALg1aHfloWe00knnfsfhV9HFEB9ikEmBw" // Add your API Key here
//        
//        var params = ROGoogleTranslateParams()
//        params.source = fromLanguage.text ?? "en"
//        params.target = toLanguage.text ?? "de"
//        params.text = text.text ?? "The textfield is empty"
//        
//        translator.translate(params: params) { (result) in
//            DispatchQueue.main.async {
//                self.translation.text = "\(result)"
//            }
//        }
//        
//        
//    }
//    
//    //let translator = ROGoogleTranslate(with: "AIzaSyALg1aHfloWe00knnfsfhV9HFEB9ikEmBw")
//
//
//    
//    
//}
//
//
//
//
//
//
