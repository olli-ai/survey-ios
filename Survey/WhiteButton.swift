//
//  WhiteButton.swift
//  Survey
//
//  Created by Dan Do on 4/20/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import UIKit

class WhiteButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Color.red().cgColor
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
    }


}
