//
//  LibraryController.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 6/4/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


class LibraryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    var songData: [SongObj] = []
    let storageManager = StorageManager()
    
    //AudioPlayer
    var player : AVAudioPlayer?
    var currentPlayerURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackButton()
        setUpTableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        songData = storageManager.getData()

        // Do any additional setup after loading the view.
    }
    
    func setUpTableView()
    {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let tableViewWidthAnchor = tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let tableViewCXAnchor = tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        NSLayoutConstraint.activate([tableViewBottomAnchor, tableViewTopAnchor, tableViewWidthAnchor, tableViewCXAnchor])
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        let headerInset: CGFloat = 20
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: headerInset, bottom: 0, right: 0)
    }
    
    func setUpBackButton()
    {
        let fontSize:CGFloat = 18
        let font:UIFont = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.white,]
        let item = UIBarButtonItem.init(title: "BACK", style: .plain, target: self, action: #selector(LibraryController.backPressed))
        item.setTitleTextAttributes(attributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem = item
    }
    
    @objc func backPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let songObj = songData[section]
        return songObj.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return songData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let songObj = songData[section]
        return songObj.versions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        let versionObj = songData[indexPath.section].versions[indexPath.row]
        let dateStr = storageManager.getDate(date: versionObj.date)
        cell!.textLabel?.text = "Version " + "\(versionObj.num)" + " - " +  "\(dateStr)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell: UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        let versionObj = songData[indexPath.section].versions[indexPath.row]
        self.play(url: versionObj.lastPathComp)
        
    }
    
    func play(url: String)
    {
        do {
            let directoryURL = StorageManager().getDocumentsDirectory()
            let fileURL = directoryURL.appendingPathComponent(url)
//            let fileURL = URL(string: url)
            self.currentPlayerURL = fileURL
            self.player = try AVAudioPlayer(contentsOf: fileURL)
            self.player?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
