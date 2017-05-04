//
//  API.swift
//  Survey
//
//  Created by Dan Do on 4/18/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class API {
    
    static let sharedInstance = API()
    var header: [String: String] = ["Authorization":""]

    //fileprivate override init() {}
    
    func checkNetworkConnection(success: @escaping () -> (), failure: @escaping (Int) -> ()) {
        let urlString = "https://google.com"
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success( _):
                success()
            case .failure(let error):
                let errorCode = error._code
                failure(errorCode)

            }
        }
    }
    
    func login(phonenumber: String, success: @escaping () -> (), failure: @escaping (String) -> ()) {
        let urlString = APIUrl.login
        
        var parameter = [String: AnyObject]()
        parameter["fnumber"] = phonenumber as AnyObject
        
        Alamofire.request(urlString, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let valueJson = JSON(value)
                let statuscode = valueJson["status_code"].intValue
                if statuscode == 200 {
                    let data = valueJson["data"]
                    let token = data["token"].stringValue
                    self.header["Authorization"] = token
                    
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(phonenumber, forKey: "phonenumber")
                    
                    success()

                } else {
                    let error = "Co lỗi xảy ra,vui lòng thử lại"
                    failure(error)
                }
                
            case .failure(let error):
                failure(error.localizedDescription)

            }
        }
    }
    
    func surveyDashboard(success: @escaping (Dashboard) -> (), failure: @escaping (Int) -> ()) {
        let urlString = APIUrl.dashboard
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let valueJson = JSON(value)
                let statuscode = valueJson["status_code"].intValue
                if statuscode == 200 {
                    let data = valueJson["data"]
                    let dashboard = Dashboard(json: data)
                    success(dashboard)
                    
                } else {
                    let error = 0
                    failure(error)
                }
                
            case .failure(let error):
                let errorCode = error._code
                failure(errorCode)
                
            }
        }
    }

    func surveyProvider(name: String, gender: String, age: String, success: @escaping (String) -> (), failure: @escaping (String) -> ()) {
        let urlString = APIUrl.provider
        
        var parameter = [String: AnyObject]()
        parameter["fname"] = name as AnyObject
        parameter["fgender"] = gender as AnyObject
        parameter["fage"] = age as AnyObject

        Alamofire.request(urlString, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: header).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let valueJson = JSON(value)
                let statuscode = valueJson["status_code"].intValue
                if statuscode == 200 {
                    let providerid = valueJson["data"].stringValue
                    success(providerid)
                    
                } else {
                    let error = "Co lỗi xảy ra,vui lòng thử lại"
                    failure(error)
                }
                
            case .failure(let error):
                failure(error.localizedDescription)
                
            }
        }
    }
    
    func surveyComplete(fpid: String,fquespass: Int, fquesfail: Int, fquesskip: Int,fquestiontotal: Int, success: @escaping () -> (), failure: @escaping (String) -> ()) {
        let urlString = APIUrl.completeSurvey
        
        var parameter = [String: AnyObject]()
        parameter["fpid"] = fpid as AnyObject
        parameter["fquestionpassed"] = fquespass as AnyObject
        parameter["fquestionfailed"] = fquesfail as AnyObject
        parameter["fquestionskipped"] = fquesskip as AnyObject
        parameter["fquestiontotal"] = fquestiontotal as AnyObject
        
        Alamofire.request(urlString, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: header).responseString { response in
            //print(response)
            switch response.result {
            case .success(let value):
                let valueJson = JSON(value)
                let statuscode = valueJson["status_code"].intValue
                if statuscode == 200 {
                    success()
                    
                } else {
                    let error = "Co lỗi xảy ra,vui lòng thử lại"
                    failure(error)
                }
                
            case .failure(let error):
                failure(error.localizedDescription)
                
            }
        }
    }
    
    func surveyListQuestion(success: @escaping ([Question]) -> (), failure: @escaping (String) -> ()) {
        let urlString = APIUrl.getListQuestions
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let valueJson = JSON(value)
                let statuscode = valueJson["status_code"].intValue
                if statuscode == 200 {
                    var arrayQuestion = [Question]()
                    let array = valueJson["data"].arrayValue
                    for json in array {
                        let question = Question(json: json)
                        arrayQuestion.append(question)
                    }
                    success(arrayQuestion)
                    
                } else {
                    let error = "Co lỗi xảy ra,vui lòng thử lại"
                    failure(error)
                }
                
            case .failure(let error):
                failure(error.localizedDescription)
                
            }

        }
    }
    
    func uploadAnswer(answerText: String, fpid: String,fqid: String, faccuracy: String,audio: URL, success: @escaping () -> (), failure: @escaping () -> ()) {
        let urlString = APIUrl.postAnwserToServer
        
        Alamofire.upload(multipartFormData: { (muiltiPart) in
            muiltiPart.append(audio, withName: "faudio")
            muiltiPart.append(answerText.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "ftext")
            muiltiPart.append(fpid.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "fpid")
            muiltiPart.append(fqid.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "fqid")
            muiltiPart.append(faccuracy.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "faccuracy")

        }, to: urlString, headers:self.header, encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let valueJson = JSON(response.value as Any)
                    let status_code = valueJson["status_code"].intValue
                    if status_code == 200 {
                        success()

                    } else {
                        failure()
                    }
                }
            case .failure( _):

                failure()
            }
        })
    }

}
