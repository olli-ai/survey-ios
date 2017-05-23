//
//  LoginViewController.swift
//  Survey
//
//  Created by Dan Do on 4/18/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtField: UITextField!

    @IBOutlet weak var btnLogin: RedButton!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    fileprivate var ableBtnLogin = true {
        didSet {
            if ableBtnLogin {
                btnLogin.isEnabled = true
                btnLogin.backgroundColor = Color.red()
            } else {
                btnLogin.isEnabled = false
                btnLogin.backgroundColor = Color.gray()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        API.sharedInstance.checkNetworkConnection(success: { 
            
        }) { (errorCode) in
            if errorCode == -1009 {
                var config = SwiftMessages.Config()
                config.presentationStyle = .bottom
                config.duration = .seconds(seconds: 4)
                
                let view = MessageView.viewFromNib(layout: .CardView)
                view.button?.isHidden = true
                view.configureContent(title: "Không có kết nối Internet", body: "Vui lòng bật Wifi hoặc sử dụng 3G để nối mạng.")
                view.configureTheme(.error)
                SwiftMessages.show(config: config, view: view)

            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkNetworkConnection()

        // cant run in viewDidload and viewWillAppear

        let token = UserDefaults.standard.string(forKey: "token")
        if token != nil {
            API.sharedInstance.header["Authorization"] = token!
            
            let phonenumber = UserDefaults.standard.string(forKey: "phonenumber")
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
            mainVC.loginPhonenumber = phonenumber!
            self.present(mainVC, animated: false, completion: nil)
            
        }

    }
    
    func setupUI() {
        
        view.backgroundColor = Color.black()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        txtField.addTarget(self, action: #selector(txtFieldValueChange(sender:)), for: .editingChanged)
        
        ableBtnLogin = false
    }
    
    func txtFieldValueChange(sender: UITextField) {
        if (sender.text?.characters.count)! >= 10 {
            ableBtnLogin = true
        } else {
            ableBtnLogin = false
        }
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func checkNetworkConnection() {
        let network = NetworkReachabilityManager()
        network?.startListening()
        
        network?.listener = { status in
            
            if  network?.isReachable ?? false {
                
                if ((network?.isReachableOnEthernetOrWiFi) != nil) {
                    //do some stuff

                } else if(network?.isReachableOnWWAN)! {
                    //do some stuff

                }
                
            }
            else {
                var config = SwiftMessages.Config()
                config.presentationStyle = .bottom
                config.duration = .seconds(seconds: 4)
                
                let view = MessageView.viewFromNib(layout: .CardView)
                view.button?.isHidden = true
                view.configureContent(title: "Không có kết nối Internet", body: "Vui lòng bật Wifi hoặc sử dụng 3G để nối mạng.")
                view.configureTheme(.error)
                SwiftMessages.show(config: config, view: view)

                
            }
            
        }

    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        btnLogin.isEnabled = false
        indicator.startAnimating()
        
        API.sharedInstance.login(phonenumber: txtField.text!, success: {
            
            self.btnLogin.isEnabled = true
            self.indicator.stopAnimating()
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
            mainVC.loginPhonenumber = self.txtField.text!
            self.present(mainVC, animated: true, completion: nil)
        }) { (error) in
            self.btnLogin.isEnabled = true
            self.indicator.stopAnimating()
        }

    }
    
}


