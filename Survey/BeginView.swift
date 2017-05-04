//
//  BeginView.swift
//  Survey
//
//  Created by Dan Do on 4/18/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import UIKit

protocol BeginViewDelegate {
    func logout()
    func startSurvey() 
}

class BeginView: UIView {

    @IBOutlet weak var lblLoginWithPhonenumber: UILabel!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnStartsurvey: UIButton!
    
    var delegate: BeginViewDelegate?
    
    let nibName = "BeginView"

    var view: UIView!
    
    var dashboard: Dashboard!
    
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
        
        let attrs: [String: Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 18.0),
            NSForegroundColorAttributeName : Color.red(),
            NSUnderlineStyleAttributeName : 1]
        let buttonTitleStr = NSMutableAttributedString(string:"Đăng xuất", attributes:attrs)
        
        btnLogout.setAttributedTitle(buttonTitleStr, for: .normal)
        
        let nib = UINib(nibName: "DashboardCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DashboardCell.identifier())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        delegate?.logout()
    }
    
    @IBAction func btnStartsurveyAction(_ sender: Any) {
        delegate?.startSurvey()
    }
    
    
}

extension BeginView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dashboard == nil {
            return 0
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCell.identifier(), for: indexPath) as! DashboardCell
        
        cell.backgroundColor = UIColor.clear
        
        if indexPath.row == 0 {
            cell.lblText.text = "Full survey"
            cell.lblfToday.text = dashboard.todaySur
            cell.lblThisweek.text = dashboard.thisweekSur
            cell.lblLastweek.text = dashboard.lastweekSur
            cell.lblTotal.text = dashboard.totalSur
        } else {
            cell.lblText.text = "Total questions"
            cell.lblfToday.text = dashboard.todayAns
            cell.lblThisweek.text = dashboard.thisweekAns
            cell.lblLastweek.text = dashboard.lastweekAns
            cell.lblTotal.text = dashboard.totalAns

        }

        return cell
    }
}
