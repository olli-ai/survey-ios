//
//  GreenButton.swift
//  Survey
//
//  Created by Dan Do on 4/20/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import UIKit

class GreenButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        self.backgroundColor = Color.green()
        self.layer.cornerRadius = 5.0
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
    }


}
