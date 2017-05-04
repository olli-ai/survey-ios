//
//  File.swift
//  Survey
//
//  Created by Dan Do on 4/18/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import Foundation

struct mainUrl {
    static let main = "https://service-dot-olli-iviet.appspot.com/api"
}

struct APIUrl {
    static let login = mainUrl.main + "/user/login/phone"
    static let provider = mainUrl.main + "/survey/provider"
    static let getListQuestions = mainUrl.main + "/survey/start"
    static let postAnwserToServer = mainUrl.main + "/survey/answer"
    static let completeSurvey = mainUrl.main + "/survey/provider"
    static let dashboard = mainUrl.main + "/survey/dashboard"
}
