//
//  File.swift
//  Survey
//
//  Created by Dan Do on 4/22/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import Foundation
import SwiftyJSON

class Dashoboard {
    var lastweekAns: String
    var lastweekSur: String
    var thisweekAns: String
    var thisweekSur: String
    var todayAns: String
    var todaySur: String
    var totalAns: String
    var totalSur: String
    
    init(json: JSON) {
        lastweekAns = json["lastWeek"]["answer"].stringValue
        lastweekSur = json["lastWeek"]["survey"].stringValue
        thisweekAns = json["thisweek"]["answer"].stringValue
        thisweekSur = json["thisweek"]["survey"].stringValue
        todayAns = json["today"]["answer"].stringValue
        todaySur = json["today"]["survey"].stringValue
        totalAns = json["total"]["answer"].stringValue
        totalSur = json["total"]["survey"].stringValue

    }

}
