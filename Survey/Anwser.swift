//
//  AnwserContent.swift
//  Survey
//
//  Created by Dan Do on 4/21/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import Foundation

class Anwser {
    var questionId: String
    var anwserText: String
    var anwserAudioPath: URL?
    var accuracy: Int
    var isAnwsered: Bool
    
    init(questid: String, text: String, acy: Int, isAnwser: Bool) {
        questionId = questid
        anwserText = text
        accuracy = acy
        isAnwsered = isAnwser
    }
}



