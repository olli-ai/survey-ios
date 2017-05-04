//
//  ProviderInfoView.swift
//  Survey
//
//  Created by Dan Do on 4/18/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import UIKit


protocol ProviderViewDelegate {
    func selectMale()
    func selectFemale()
    func next()
}

class ProviderInfoView: UIView {
    
    @IBOutlet weak fileprivate var lblInfo: UILabel!
    
    @IBOutlet weak var txtFieldName: UITextField!
    
    @IBOutlet weak  fileprivate var imgMale: UIImageView!
    
    @IBOutlet weak fileprivate  var imgFemale: UIImageView!
    
    @IBOutlet weak var txtFieldGroupage: UITextField!
    
    @IBOutlet weak var lblDatetime: UILabel!
    
    @IBOutlet weak var btnNext: WhiteButton!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var centerIndicator: UIActivityIndicatorView!
    
    let nibName = "ProviderInfoView"

    var delegate: ProviderViewDelegate?
    
    var view: UIView!
    
    var isMale: Bool = true {
        didSet {
            let selectColor = Color.red()
            let unselectColor = UIColor.white
            if isMale
            {

                imgMale.backgroundColor = selectColor
                imgFemale.backgroundColor = unselectColor

            } else {
                imgMale.backgroundColor = unselectColor
                imgFemale.backgroundColor = selectColor

            }
        }
    }
    
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
        
        lblInfo.textColor = Color.red()
        
        imgMale.layer.masksToBounds = true
        imgMale.layer.cornerRadius = imgMale.bounds.height / 2
        imgFemale.layer.masksToBounds = true
        imgFemale.layer.cornerRadius = imgFemale.bounds.height / 2

        isMale = true
        
        txtFieldName.addTarget(self, action: #selector(txtFieldNameDidchange(sender:)), for: .editingChanged)
    
        txtFieldGroupage.addTarget(self, action: #selector(txtFieldAgeDidchange(sender:)), for: .editingChanged)

        
        lblDatetime.isHidden = true
        
        btnNext.isEnabled = false
        
    }
    
    func txtFieldNameDidchange(sender: UITextField) {
        if !sender.text!.isEmpty && !txtFieldGroupage.text!.isEmpty {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
        }
    }
    
    func txtFieldAgeDidchange(sender: UITextField) {
        if !sender.text!.isEmpty && !txtFieldName.text!.isEmpty {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
        }
    }
    
    @IBAction func btnMaleAction(_ sender: Any) {
        delegate?.selectMale()
    }
    
    @IBAction func btnFemaleAction(_ sender: Any) {
        delegate?.selectFemale()
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        delegate?.next()
    }
    
}
