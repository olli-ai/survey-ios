//
//  SurveyView.swift
//  Survey
//
//  Created by Dan Do on 4/18/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import UIKit
import Pulsator

protocol SurveyViewDelegate {
    func nextSur()
    func prevSur()
    func completeSurvey()
    func holdToRecord()
    func holdrelease()
}

class SurveyView: UIView {

    @IBOutlet weak var viewQuestion: UIView!
    
    @IBOutlet weak var lblNumberquestion: UILabel!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var viewAnser: UIView!
    
    @IBOutlet weak var txtViewAnwser: UITextView!
    
    @IBOutlet weak var lblAccuracy: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnPrev: UIButton!
    
    @IBOutlet weak var btnMicro: UIButton!
    
    @IBOutlet weak var viewForPulsator: UIView!
    
    
    let nibName = "SurveyView"
    
    var delegate: SurveyViewDelegate?
    
    var view: UIView!
    
    let pulse = Pulsator()
    
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
        
        viewQuestion.layer.masksToBounds = true
        viewQuestion.layer.cornerRadius = 5.0
        viewQuestion.layer.borderColor = Color.green().cgColor
        viewQuestion.layer.borderWidth = 1.0
        
        viewAnser.layer.masksToBounds = true
        viewAnser.layer.cornerRadius = 5.0
        viewAnser.layer.borderColor = Color.green().cgColor
        viewAnser.layer.borderWidth = 1.0
        viewAnser.isHidden = true
        
        lblAccuracy.textColor = Color.red()
        lblAccuracy.text = ""
        
        btnMicro.addTarget(self, action: #selector(holdMicro), for: .touchDown)
        btnMicro.addTarget(self, action: #selector(holdReleaseMicro), for: .touchUpInside)
        
        viewForPulsator.layer.addSublayer(pulse)
        pulse.radius = 80.0
        pulse.numPulse = 5
        pulse.animationDuration = 3.0
        pulse.backgroundColor = UIColor.lightGray.cgColor
        
        btnPrev.isHidden = true
        
        txtViewAnwser.indicatorStyle = UIScrollViewIndicatorStyle.white
    }
    
    func holdMicro() {
        delegate?.holdToRecord()
    }
    
    func holdReleaseMicro() {
        delegate?.holdrelease()
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        delegate?.nextSur()
    }
    @IBAction func btnPrevAction(_ sender: Any) {
        delegate?.prevSur()
    }
    
    @IBAction func btnCompleteSur(_ sender: Any) {
        delegate?.completeSurvey()
    }
    

    
}
