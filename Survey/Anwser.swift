//
//  AnwserContent.swift
//  Survey
//
//  Created by Dan Do on 4/21/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import Foundation

class AnwserContent {
    var questionId: Int
    var anwserText: String
    var anwserAudioPath: String
    var isAnwsered: Bool
    
    init(questid: Int, text: String, path: String, isAnwser: Bool) {
        questionId = questid
        anwserText = text
        anwserAudioPath = path
        isAnwsered = isAnwser
    }
}
