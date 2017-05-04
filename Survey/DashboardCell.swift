//
//  DashboardCell.swift
//  Survey
//
//  Created by Dan Do on 4/20/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {

    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblfToday: UILabel!
    
    @IBOutlet weak var lblThisweek: UILabel!
    
    @IBOutlet weak var lblLastweek: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func identifier() -> String {
        return "DashboardCell"
    }


}
