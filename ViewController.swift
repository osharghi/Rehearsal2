//
//  ViewController.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 5/29/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    enum State {
        case down
        case up
    }
    
    var position = State.down
    
    //UI
    var slideView : UIView!
    
    //Constraints
    var slideViewBottomAnchor : NSLayoutConstraint!
    var tapLabelCXAnchor : NSLayoutConstraint!
    
    //AudioRecorder
    var recorder : AVAudioRecorder!
    var recordingSession : AVAudioSession!
    
    //AudioPlayer
    var player : AVAudioPlayer?
    var currentRecorderURL : URL?
    var currentPlayerURL : URL?
    
    //SaveButton
    var saveButton : UIBarButtonItem?
    
    //TapLabel
    var tapLabel : UILabel?
    
    //SwipeLabel
    var swipeLabel: UILabel?
    
    var upArrowImageView : UIView?
    var downArrowImageView : UIView?
    
    //Blinking Recording View
    var recordingView : UIView?

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 107/255, green: 212/255, blue: 231/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor(red: 27/255, green: 53/255, blue: 58/255, alpha: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSlideView()
        setUpRecognizer()
        setUpRecorder()
        setUpLeftButton()
        setUpRightButton()
        toggleSaveButton()
        setUpRecordingAnimation()
        setUpTapLabel()
        setUpSwipeLabel()
        setUpMicImage()
        setUpUpArrow()
        setUpDownArrow()

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        togglePlayLabel()
    }
    
    /**Begin Setup UX VVV **/
    func setUpMicImage()
    {
        let imageView = UIImageView()
        
        self.slideView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let cxAnchor = imageView.centerXAnchor.constraint(equalTo: self.slideView.centerXAnchor)
        let cyAnchor = imageView.centerYAnchor.constraint(equalTo: self.slideView.centerYAnchor)
        let wAnchor = imageView.widthAnchor.constraint(equalToConstant: 125)
        let hAnchor = imageView.heightAnchor.constraint(equalToConstant: 286)
        
        //width 359  125
        //height 823 286
        NSLayoutConstraint.activate([wAnchor, hAnchor, cxAnchor, cyAnchor])
        
        let micImage: UIImage = UIImage(named: "BigMic.png")!
        
        imageView.image = micImage
    }
    
    func setUpSwipeLabel()
    {
        let label = UILabel()
        label.text = "RECORD"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 19.0)
        
        
        self.slideView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let labelCXAnchor = label.centerXAnchor.constraint(equalTo: self.slideView.centerXAnchor)
        let labelBottomAnchor = label.bottomAnchor.constraint(equalTo: self.slideView.bottomAnchor, constant: -80)
        let labelWidthAnchor = label.widthAnchor.constraint(equalTo:self.slideView.widthAnchor)
        let labelHeightAnchor = label.heightAnchor.constraint(equalToConstant:20)
        
        NSLayoutConstraint.activate([labelCXAnchor, labelBottomAnchor, labelWidthAnchor, labelHeightAnchor])
        
        self.swipeLabel = label
        
    }
    
    func setUpTapLabel()
    {
        let label = UILabel()
        label.text = "(Tap To Play)"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15.0)
        
        self.slideView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let labelCXAnchor = label.centerXAnchor.constraint(equalTo: self.slideView.centerXAnchor)
        let labelBottomAnchor = label.bottomAnchor.constraint(equalTo: self.slideView.bottomAnchor, constant: -60)
        let labelWidthAnchor = label.widthAnchor.constraint(equalTo:self.slideView.widthAnchor)
        let labelHeightAnchor = label.heightAnchor.constraint(equalToConstant:20)
        
        tapLabelCXAnchor = labelCXAnchor
        
        NSLayoutConstraint.activate([labelCXAnchor, labelBottomAnchor, labelWidthAnchor, labelHeightAnchor])
        
        self.tapLabel = label
        
    }
    
    func setUpUpArrow()
    {
        let imageView = UIImageView()
        
        self.slideView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let cxAnchor = imageView.centerXAnchor.constraint(equalTo: self.slideView.centerXAnchor)
        let wAnchor = imageView.widthAnchor.constraint(equalToConstant: 17)
        let hAnchor = imageView.heightAnchor.constraint(equalToConstant: 24)
        let bAnchor = imageView.bottomAnchor.constraint(equalTo: self.slideView.bottomAnchor, constant: -103)

        
        NSLayoutConstraint.activate([wAnchor, hAnchor, cxAnchor, bAnchor])
        
        let arrowImage: UIImage = UIImage(named: "UpArrow.png")!
        imageView.image = arrowImage
        upArrowImageView = imageView
    }
    
    func setUpDownArrow()
    {
        let imageView = UIImageView()
        
        self.slideView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let cxAnchor = imageView.centerXAnchor.constraint(equalTo: self.slideView.centerXAnchor)
        //        let cyAnchor = imageView.centerYAnchor.constraint(equalTo: self.slideView.centerYAnchor)
        let wAnchor = imageView.widthAnchor.constraint(equalToConstant: 17)
        let hAnchor = imageView.heightAnchor.constraint(equalToConstant: 24)
        let bAnchor = imageView.bottomAnchor.constraint(equalTo: self.slideView.bottomAnchor, constant: -53)
        
        
        NSLayoutConstraint.activate([wAnchor, hAnchor, cxAnchor, bAnchor])
        
        let arrowImage: UIImage = UIImage(named: "DownArrow.png")!
        
        imageView.image = arrowImage
        imageView.isHidden = true
        downArrowImageView = imageView
        
    }
    
    func setUpSlideView()
    {
        let slideView = UIView()
        slideView.backgroundColor = UIColor(red: 107/255, green: 212/255, blue: 231/255, alpha: 1)
        self.view.addSubview(slideView)
        slideView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let cxAnchor = slideView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let bAnchor = slideView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let wAnchor = slideView.widthAnchor.constraint(equalToConstant: self.view.bounds.width)
        let hAnchor = slideView.heightAnchor.constraint(equalToConstant: self.view.bounds.height)
        
        slideViewBottomAnchor = bAnchor
        
        NSLayoutConstraint.activate([wAnchor, hAnchor, cxAnchor, bAnchor])
        self.slideView = slideView
    }
    
    func setUpRecognizer()
    {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleUpSwipe))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleDownSwipe))
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        
        self.slideView.addGestureRecognizer(upSwipe)
        self.slideView.addGestureRecognizer(downSwipe)
        self.slideView.addGestureRecognizer(tapRec)
        self.slideView.isUserInteractionEnabled = true
        
        upSwipe.direction = .up
        downSwipe.direction = .down
    }
    
    func setUpLeftButton()
    {
        let fontSize:CGFloat = 18
        let font:UIFont = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.white,]
        let item = UIBarButtonItem.init(title: "LIBRARY", style: .plain, target: self, action: #selector(ViewController.libraryPressed))
        item.setTitleTextAttributes(attributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem = item;
    }
    
    func setUpRightButton()
    {
        
        let fontSize:CGFloat = 18
        let font:UIFont = UIFont.boldSystemFont(ofSize: fontSize)
        let attributesEnabled: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.white,]
        let attributesDisabled: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.lightText,]
        let item = UIBarButtonItem.init(title: "SAVE", style: .plain, target: self, action: #selector(ViewController.savePressed))
        item.setTitleTextAttributes(attributesEnabled, for: UIControl.State.normal)
        item.setTitleTextAttributes(attributesDisabled, for: UIControl.State.disabled)
        
        self.navigationItem.rightBarButtonItem = item;
        self.saveButton = self.navigationItem.rightBarButtonItem
    }
    
    func animateUp()
    {
        if(position == State.down)
        {
            self.slideViewBottomAnchor.constant -= 100
            showDownArrow()
            self.swipeLabel!.text = "STOP"
            self.beginBlinkAnimation()
          
            UIView.animate(withDuration: 0.4, animations:{
                self.view.layoutIfNeeded()}){ (Bool) in
            }
            
            position = State.up
            hideTapLabel()
            startRecording()
        }
    }
    
    func animateDown()
    {
        if(position == State.up)
        {
            self.slideViewBottomAnchor.constant += 100
            showUpArrow()
            self.swipeLabel!.text = "RECORD"
            
            UIView.animate(withDuration: 0.4, animations:
                {
                    self.view.layoutIfNeeded()
            })
                { (Bool) in

//                self.togglePlayLabel()
                self.showTapLabel()
                self.shake()
                self.toggleSaveButton()
                self.stopAnimations()
                self.resetAlpha()
            }
            
            position = State.down
            stopRecording(success: true)
        }
    }
    
    func showUpArrow()
    {
        self.upArrowImageView?.isHidden = false
        self.downArrowImageView?.isHidden = true
    }
    
    func showDownArrow()
    {
        self.downArrowImageView?.isHidden = false
        self.upArrowImageView?.isHidden = true
    }
    
    func hideTapLabel()
    {
        self.tapLabel?.isHidden = true
    }
    
    func showTapLabel()
    {
        self.tapLabel?.isHidden = false
    }
    
    func togglePlayLabel()
    {
        if(self.currentRecorderURL != nil)
        {
            self.tapLabel?.isHidden = false;
        }
        else{
            self.tapLabel?.isHidden = true;
        }
    }
    
    @objc func handleUpSwipe()
    {
        animateUp()
    }
    
    @objc func handleDownSwipe()
    {
        animateDown()
    }
    
    @objc func savePressed()
    {
        //        let counter = UserDefaults.standard.integer(forKey: "Counter")
        //        let defaultTitle = "Track-" + String(counter)
        //        presentAlert(title: defaultTitle)
        
        toggleSaveButton()
        clearURLS()
        togglePlayLabel()
        performSegue(withIdentifier: "ToSaveController", sender: self)
    }
    
    @objc func libraryPressed()
    {
        performSegue(withIdentifier: "ToSongLibraryController", sender: self)
    }
    
    func toggleSaveButton()
    {
        if(self.currentRecorderURL == nil)
        {
            saveButton!.isEnabled = false
        }
        else
        {
            saveButton!.isEnabled = true
        }
    }
    
    func stopAnimations()
    {
        self.view.layer.removeAllAnimations()
    }
    
    func setUpRecordingAnimation()
    {
        let recordingView = UIView()
        recordingView.backgroundColor = UIColor(red: 27/255, green: 53/255, blue: 58/255, alpha: 1)
        
        self.view.addSubview(recordingView)
        recordingView.translatesAutoresizingMaskIntoConstraints = false
        let recordViewHAnchor = recordingView.heightAnchor.constraint(equalToConstant: 30)
        let recordViewWAnchor = recordingView.widthAnchor.constraint(equalToConstant: self.view.bounds.width)
        let recordViewCXAnchor = recordingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let recordViewTAnchor = recordingView.topAnchor.constraint(equalTo: self.slideView.bottomAnchor, constant: 30)
        NSLayoutConstraint.activate([recordViewHAnchor, recordViewWAnchor, recordViewCXAnchor, recordViewTAnchor])
        
        let recordingLabel = UILabel()
        recordingLabel.backgroundColor = UIColor(red: 27/255, green: 53/255, blue: 58/255, alpha: 1)
        recordingLabel.text = "RECORDING"
        recordingLabel.textColor = .white
        recordingLabel.textAlignment = .center
        recordingLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        recordingView.addSubview(recordingLabel)
        recordingLabel.translatesAutoresizingMaskIntoConstraints = false
        let cxAnchor = recordingLabel.centerXAnchor.constraint(equalTo: recordingView.centerXAnchor)
        let cyAnchor = recordingLabel.centerYAnchor.constraint(equalTo: recordingView.centerYAnchor)
        recordingLabel.sizeToFit()
        NSLayoutConstraint.activate([cxAnchor, cyAnchor])
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.view.frame.size.width/2 - recordingLabel.frame.size.width/2 - 10, y: (recordingView.frame.origin.y+recordViewHAnchor.constant/2)), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        recordingView.layer.addSublayer(shapeLayer)
        
        self.recordingView = recordingView;
        
    }
    
    func resetAlpha()
    {
        self.recordingView?.alpha = 1
    }
    
    func beginBlinkAnimation()
    {
        UIView.animate(withDuration: 0.75, delay: 0, options: [.repeat,.autoreverse], animations: {
            self.recordingView!.alpha = 0.0
        }, completion: nil)
    }
    
    func shake()
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.15
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.tapLabel!.center.x-3, y: self.tapLabel!.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.tapLabel!.center.x+3, y: self.tapLabel!.center.y))
        self.tapLabel!.layer.add(animation, forKey: "position")
    }
    
    func presentAlert(title: String)
    {
        var fileTitle = title
        let alertController = UIAlertController(title: "Name Recording", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = fileTitle
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
            let firstTextField = alertController.textFields![0] as UITextField
            fileTitle = firstTextField.text!
            
            if (firstTextField.text?.isEmpty)!
            {
                self.newSave(titleToSave: title)
            }
            else
            {
                self.newSave(titleToSave: firstTextField.text!)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /** End Setup UX **/
    
    /** Begin Recorder/Player Functionality **/
    func setUpRecorder()
    {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission(){ [weak self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //do nothing
                        print("Enabled")
                    }
                    else{
                        //Handle error messsage
                        print("Not enabled")
                    }
                }
            }
        } catch {
            //Handle error
            print("Failed to access audio session.")
        }
    }
    func startRecording()
    {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            recorder.delegate = self
            recorder.record()
            
        } catch {
            stopRecording(success: false)
        }
    }
    
    func stopRecording(success: Bool)
    {
        recorder.stop()
        //        audioRecorder = nil
        
        if success {
            currentRecorderURL = recorder.url
            
        } else {
            //doSomething
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording(success: false)
        }
    }
    
    @objc func handleTap()
    {
        if(position == State.down)
        {
            if let player = self.player
            {
                if(player.isPlaying)
                {
                    player.pause()
                }
                else if(currentPlayerURL != nil)
                {
                    player.play()
                }
                else
                {
                    if let urlToPlay = self.currentRecorderURL
                    {
                        play(fileURL: urlToPlay)
                    }
                }
            }
            else
            {
                if let urlToPlay = self.currentRecorderURL
                {
                    play(fileURL: urlToPlay)
                }
            }
        }
    }
    
    func play(fileURL: URL)
    {
        do {
            self.currentPlayerURL = fileURL
            self.player = try AVAudioPlayer(contentsOf: fileURL)
            self.player?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    /** End Recorder Functionality **/
    
    /** Begin File Management and Saving **/
    func testDirectory()
    {
        let directory = getDocumentsDirectory()
        let absolute = directory.absoluteURL
        let relative = directory.relativePath
    }
    
    //Test Fuction
    func checkFiles()
    {
        do{
            let directory = getDocumentsDirectory()
            let directoryContents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func clearURLS()
    {
        self.currentRecorderURL = nil
        self.currentPlayerURL = nil
    }
    
    func saveRecording(title: String, pathComponenet: String) -> Bool
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Recording",
                                                in: managedContext)!
        
        let recording = NSManagedObject(entity: entity, insertInto: managedContext)
        
        recording.setValue(title, forKey: "title")
        recording.setValue(pathComponenet, forKey: "url")
        
        do {
            try managedContext.save()
            print("SAVE SUCCESSFUL")
            updateCounter()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    func newSave(titleToSave: String)
    {
        do {
            let counter = UserDefaults.standard.integer(forKey: "Counter")
            let directoryURL = getDocumentsDirectory()
            let originPath = directoryURL.appendingPathComponent("recording.m4a")
            let defaultTitle = "Track-" + String(counter)
            let pathTitle = defaultTitle + ".m4a"
            //checkTitle
            let destinationPath = directoryURL.appendingPathComponent(pathTitle)
            try FileManager.default.moveItem(at: originPath, to: destinationPath)
            let saved = saveRecording(title: titleToSave, pathComponenet: pathTitle)
            if saved != true
            {
                //Handle error
            }
            
        } catch {
            //Handle Error
            print(error)
        }
        
        toggleSaveButton()
        clearURLS()
        togglePlayLabel()
        performSegue(withIdentifier: "ToSongLibraryController", sender: self)
    }
    
    /** End File Management and Saving **/

    
    /** Extra Stuff **/
    func updateCounter()
    {
        var counter = UserDefaults.standard.integer(forKey: "Counter")
        counter += 1
        UserDefaults.standard.set(counter, forKey:"Counter")
    }
    

}

