//
//  ViewController.swift
//  Survey
//
//  Created by Dan Do on 4/18/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import UIKit
import Speech
import SwiftMessages

class MainViewController: UIViewController {

    fileprivate var beginView: BeginView!
    
    fileprivate var providerView: ProviderInfoView!

    fileprivate var surveyView: SurveyView!

    fileprivate var summaryView: SummaryView!

    fileprivate let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "vi-VN"))  //1

    fileprivate var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recognitionTask: SFSpeechRecognitionTask?
    fileprivate let audioEngine = AVAudioEngine()
    
    fileprivate var audioRecorder: AVAudioRecorder?

    var loginPhonenumber = ""
    
    fileprivate let apiInstance = API.sharedInstance
    
     fileprivate var fpid = ""
    
    fileprivate var arrayQuestion = [Question]()
    
    fileprivate var currenIndexQuestion = 0
    
    fileprivate var arrayAnwser = [Anwser]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }

    func setupUI() {
        view.backgroundColor = Color.black()
        
        beginView = BeginView(frame: view.frame)
        view.addSubview(beginView)
        beginView.delegate = self
        beginView.lblLoginWithPhonenumber.text = "Đăng nhập với số điện thoại " + loginPhonenumber
        
        apiInstance.surveyDashboard(success: { dashboard in
            DispatchQueue.main.async(execute: {
                self.beginView.dashboard = dashboard
                self.beginView.tableView.reloadData()
            })

        }) { (error) in
            var config = SwiftMessages.Config()
            config.presentationStyle = .bottom
            config.duration = .seconds(seconds: 4)
            
            let view = MessageView.viewFromNib(layout: .CardView)
            view.button?.isHidden = true
            view.configureContent(title: "Không có kết nối Internet", body: "Vui lòng bật Wifi hoặc sử dụng 3G để nối mạng.")
            view.configureTheme(.error)
            SwiftMessages.show(config: config, view: view)

        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(taptoHideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    func taptoHideKeyboard() {
        view.endEditing(true)
    }
    
    func setupSpeechRecognizer() {
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.surveyView.btnMicro.isEnabled = isButtonEnabled
            }
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.surveyView.viewAnser.isHidden = false
                self.surveyView.txtViewAnwser.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!

            }
            
            if error != nil || isFinal {
               // print("error \(String(describing: error?.localizedDescription))")
               // self.audioEngine.stop()
               // inputNode.removeTap(onBus: 0)
        
               // self.recognitionRequest = nil
               // self.recognitionTask = nil
                self.surveyView.txtViewAnwser.text = result?.bestTranscription.formattedString

            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    func setupRecordsAudio() {
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let currentQuestId = self.arrayQuestion[currenIndexQuestion].id
        let filename = String(currentQuestId) + "Audio.wav"
        
        let soundFileURL = dirPaths[0].appendingPathComponent(filename)
        
        let currentAnwser = self.arrayAnwser[currenIndexQuestion]
        currentAnwser.anwserAudioPath = soundFileURL
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    func textForLblNumberQuestion(index: Int) -> String {
        let total = String(self.arrayQuestion.count)
        let string = "( \(index + 1)/\(total) )"
        return string
    }
    
    func creatingArrayNum() -> [Int] {
        var arr = [Int]()
        arr += 71...98
        return arr
    }
    
    func getRandomConfidence() -> Int {
        var arr = creatingArrayNum()
        let randomIndex = Int(arc4random_uniform(UInt32(arr.count)))
        let randomValue = arr[randomIndex]
        return randomValue
    }
    
    func createArrayAnwser(arrayQuestion: [Question]) -> [Anwser] {
        var arrayAnwser = [Anwser]()
        for question in arrayQuestion {
            let anwser = Anwser(questid: question.id, text: "", acy: 0, isAnwser: false)
            arrayAnwser.append(anwser)
        }
        return arrayAnwser
    }
    
    func getSummary(from arrayAnwser: [Anwser]) -> (Int, Int, Int, Int) {
        let total = arrayAnwser.count
        var qpass = 0
        //var qfail = 0
        //var qskip = 0
        
        for anwser in arrayAnwser {
            if anwser.isAnwsered {
                qpass += 1
            }
        }
        
        let qskip = total - qpass
        let qfail = 0
        
        return (total, qpass, qfail, qskip)
    }
}

extension MainViewController: BeginViewDelegate {
    func logout() {
        UserDefaults.standard.set(nil, forKey: "token")
        UserDefaults.standard.set(nil, forKey: "phonenumber")
        self.dismiss(animated: true, completion: nil)
    }
    
    func startSurvey() {
        beginView.isHidden = true
        
        providerView = ProviderInfoView(frame: view.frame)
        providerView.delegate = self as ProviderViewDelegate
        view.addSubview(providerView)
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm  dd/MM/yyyy"
        let currentDateString = formatter.string(from: currentDate)
        providerView.lblDatetime.text = currentDateString
    }
}

extension MainViewController: ProviderViewDelegate {
    func selectMale() {
        self.providerView.isMale = true
    }
    
    func selectFemale() {
        self.providerView.isMale = false

    }
    
    func next() {
    
        providerView.btnNext.isEnabled = false
        //providerView.indicator.startAnimating()
        providerView.centerIndicator.startAnimating()
        
        var gender = "1"
        if providerView.isMale {
            gender = "1"
        } else {
            gender = "3"
        }
        
        var age = "0"
        if (providerView.txtFieldGroupage.text?.characters.count)! > 0 {
            age = providerView.txtFieldGroupage.text!
        } else {
            age = "0"
        }
        
        apiInstance.surveyProvider(name: providerView.txtFieldName.text!, gender: gender, age: age, success: { (fpid) in
            self.fpid = fpid

            self.apiInstance.surveyListQuestion(success: { (arrayQuestion) in
                
                DispatchQueue.main.async(execute: {

                    self.providerView.btnNext.isEnabled = true
                    //self.providerView.indicator.stopAnimating()
                    self.providerView.centerIndicator.stopAnimating()

                    
                    self.providerView.isHidden = true
                    
                    self.surveyView = SurveyView(frame: self.view.frame)
                    self.surveyView.delegate = self as SurveyViewDelegate
                    self.view.addSubview(self.surveyView)
                    
                    self.arrayQuestion = arrayQuestion
                    self.arrayAnwser = self.createArrayAnwser(arrayQuestion: arrayQuestion)
                    
                    self.surveyView.lblNumberquestion.text = self.textForLblNumberQuestion(index: self.currenIndexQuestion)
                    self.surveyView.lblQuestion.text = self.arrayQuestion[0].content
                    
                    self.setupSpeechRecognizer()
                    self.setupRecordsAudio()
                })

            }, failure: { (error) in
                self.providerView.btnNext.isEnabled = true
                self.providerView.indicator.stopAnimating()
            })
            
        }) { (error) in
            self.providerView.btnNext.isEnabled = true
            self.providerView.indicator.stopAnimating()

        }
        
    }
}

extension MainViewController: SurveyViewDelegate {
    func nextSur() {
        if self.currenIndexQuestion == arrayQuestion.count - 1 {
            completeSurvey()
        } else {
            self.currenIndexQuestion += 1
            
            surveyView.viewAnser.isHidden = true
            surveyView.txtViewAnwser.text = ""
            surveyView.lblAccuracy.text = ""
            
            surveyView.lblNumberquestion.text = textForLblNumberQuestion(index: self.currenIndexQuestion)
            surveyView.lblQuestion.pushTransition(0.5, direction: .Right)
            surveyView.lblQuestion.text = arrayQuestion[self.currenIndexQuestion].content
            
            if self.currenIndexQuestion == 1 {
                surveyView.btnPrev.isHidden = false
            }
        }
    }
    
    func prevSur() {
        self.currenIndexQuestion -= 1
        
        surveyView.viewAnser.isHidden = true
        surveyView.txtViewAnwser.text = ""
        surveyView.lblAccuracy.text = ""
        
        surveyView.lblNumberquestion.text = textForLblNumberQuestion(index: self.currenIndexQuestion)
        surveyView.lblQuestion.pushTransition(0.5, direction: .Left)
        surveyView.lblQuestion.text = arrayQuestion[self.currenIndexQuestion].content

        if self.currenIndexQuestion == 0 {
            //surveyView.removeFromSuperview()
            //providerView.isHidden = false
            surveyView.btnPrev.isHidden = true
            
        }
    }
    
    func completeSurvey() {
        surveyView.isHidden = true
        
        summaryView = SummaryView(frame: view.frame)
        summaryView.delegate = self as SummaryViewDelegate
        
        view.addSubview(summaryView)
        
        let tuple = getSummary(from: self.arrayAnwser)
        summaryView.lblTotalquestion.text = "Tổng số câu hỏi: " + String(tuple.0)
        summaryView.lblQuestionpassed.text = "Số câu hỏi đạt: " + String(tuple.1)
        summaryView.lblQuestionfailed.text = "Số câu hỏi chưa đạt: " + String(tuple.2)
        summaryView.lblQuestionnotanwsered.text = "Số câu hỏi chưa trả lời: " + String(tuple.3)
    }
    
    func holdToRecord() {
        
        self.surveyView.lblAccuracy.text = "Bắt đầu ghi âm ..."
        
        surveyView.pulse.start()
        
        surveyView.txtViewAnwser.text = ""
        
        startRecording()
    
        setupRecordsAudio()
        audioRecorder?.record()
        
        /*
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            //microphoneButton.isEnabled = false
            //microphoneButton.setTitle("Start Recording", for: .normal)
            print("aaa")
        } else {
            print("bb")
            startRecording()
            //microphoneButton.setTitle("Stop Recording", for: .normal)
        }*/
        
    }
    
    func holdrelease() {
        
        surveyView.pulse.stop()
        
        audioEngine.stop()
        audioEngine.inputNode?.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        
        self.recognitionRequest = nil
        self.recognitionTask = nil

        
        audioRecorder?.stop()
        
        if surveyView.txtViewAnwser.text.characters.count > 0 {
            
            let confidence = getRandomConfidence()
            let text = "Độ chính xác: " + String(confidence) + "%"
            self.surveyView.lblAccuracy.text = text
            
            let currentAnwser = self.arrayAnwser[currenIndexQuestion]
            currentAnwser.anwserText = surveyView.txtViewAnwser.text
            currentAnwser.isAnwsered = true
            currentAnwser.accuracy = confidence

        } else {
            self.surveyView.lblAccuracy.text = ""

        }

    }
}

extension MainViewController: SummaryViewDelegate {
    func prevSum() {
        summaryView.removeFromSuperview()
        surveyView.isHidden = false
        
    }
    
    func completeSurveySum() {
        
        summaryView.btnPrev.isEnabled = false
        summaryView.btnComplete.isEnabled = false
        
        summaryView.viewIndicator.isHidden = false
        summaryView.lblIndicator.text = "Uploading..."
        summaryView.indicator.startAnimating()
        
        let tuble = getSummary(from: self.arrayAnwser)
        let questionTotal = self.arrayQuestion.count
        apiInstance.surveyComplete(fpid: self.fpid, fquespass: tuble.1, fquesfail: tuble.2, fquesskip: tuble.3,fquestiontotal: questionTotal, success: {
        }) { (error) in
            
        }
        
        var totalAnwsered = 0
        for anwser in self.arrayAnwser {
            if anwser.isAnwsered {
                totalAnwsered += 1
            }
        }
        
        var b = totalAnwsered

        var a = 0
        
        
        
        for anwser in self.arrayAnwser {
            if anwser.isAnwsered {
                self.apiInstance.uploadAnswer(answerText: anwser.anwserText, fpid: self.fpid, fqid: anwser.questionId, faccuracy: String(anwser.accuracy), audio: anwser.anwserAudioPath!, success: {
                    DispatchQueue.main.async(execute: {
                        let number: Double = 1 / Double(totalAnwsered) * 100
                        let numberint = Int(number)
                        a += numberint
                        let string = String(a) + "%"
                        self.summaryView.lblIndicator.text = "Uploading... \(string)"
                        b -= 1
                        
                        if b == 0 {
                            self.summaryView.indicator.stopAnimating()
                            self.summaryView.viewIndicator.isHidden = true
                            
                            self.summaryView.btnPrev.isEnabled = false
                            self.summaryView.btnComplete.isEnabled = false

                            
                            self.beginView.isHidden = false
                            
                            self.apiInstance.surveyDashboard(success: { dashboard in
                                DispatchQueue.main.async(execute: {
                                    self.beginView.dashboard = dashboard
                                    self.beginView.tableView.reloadData()
                                })
                                
                            }) { (error) in
                                
                            }

                            
                            self.summaryView.removeFromSuperview()
                            self.surveyView.removeFromSuperview()
                            self.providerView.removeFromSuperview()
                            
                            self.fpid = ""
                            self.arrayQuestion = [Question]()
                            self.arrayAnwser = [Anwser]()
                            self.currenIndexQuestion = 0
                        }
                    })

                }, failure: {
                    
                })
            }
        }

    }
}

extension MainViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            surveyView.btnMicro.isEnabled = true
        } else {
            surveyView.btnMicro.isEnabled = false

        }
    }
}
