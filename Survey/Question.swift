//
//  Question.swift
//  Survey
//
//  Created by Dan Do on 4/21/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import Foundation
import SwiftyJSON

class Question {
    var id: String
    var content: String
    
    init(json: JSON) {
        id = json["id"].stringValue
        content = json["content"].stringValue
    }
}
