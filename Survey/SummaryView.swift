//
//  SummaryView.swift
//  Survey
//
//  Created by Dan Do on 4/18/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import UIKit

protocol SummaryViewDelegate {
    func prevSum()
    func completeSurveySum()
}

class SummaryView: UIView {

    @IBOutlet weak var viewSummary: UIView!
    
    @IBOutlet weak var lblTotalquestion: UILabel!
    
    @IBOutlet weak var lblQuestionpassed: UILabel!
    
    @IBOutlet weak var lblQuestionfailed: UILabel!
    
    @IBOutlet weak var lblQuestionnotanwsered: UILabel!
    
    @IBOutlet weak var viewIndicator: UIView!
    
    @IBOutlet weak var lblIndicator: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnComplete: UIButton!
    
    @IBOutlet weak var btnPrev: WhiteButton!
    
    let nibName = "SummaryView"

    var delegate: SummaryViewDelegate?
    
    var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetUp()
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func xibSetUp() {
        
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
        viewSummary.layer.masksToBounds = true
        viewSummary.layer.cornerRadius = 5.0
        viewSummary.layer.borderColor = Color.green().cgColor
        viewSummary.layer.borderWidth = 1.0
        
        viewIndicator.layer.masksToBounds = true
        viewIndicator.layer.cornerRadius = 5.0
        viewIndicator.isHidden = true

    }
    
    @IBAction func btnPrevAction(_ sender: Any) {
        delegate?.prevSum()
    }
    
    @IBAction func btnCompleteSurAction(_ sender: Any) {
        delegate?.completeSurveySum()
    }
}
