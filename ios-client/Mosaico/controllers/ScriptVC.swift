//
//  ScriptsVC.swift
//  Flisar
//
//  Created by Jordan Campbell on 4/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//
// Refresh control - https://medium.com/anantha-krishnan-k-g/pull-to-refresh-how-to-implement-f915743703f8
//

import UIKit
import FirebaseDatabase

class ScriptVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var scripts = Dictionary<String, String>()
  
  private lazy var database = {
    return Database.database().reference()
  }()
  
  private let tableLoadQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".tableLoadQueue",
                                             qos: .userInteractive)
  
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
    refreshControl.tintColor = UIColor(red: 0, green: 31, blue: 84)
    self.tableView.reloadData()
    return refreshControl
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    self.tableView.addSubview(self.refreshControl)
    self.requestScriptsFromDatabase()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}

extension ScriptVC {
  func requestScriptsFromDatabase() {
    
    tableLoadQueue.async {
      
      self.database.child(Constants.Firebase.scripts).observeSingleEvent(of: .value) { (snapshot) in
        
        guard let children = snapshot.children.allObjects as? [DataSnapshot] else {return}
        
        for child in children {
          if let data = child.value as? Dictionary<String, String> {
            if let token = data["token"], let value = data["value"] {
              self.scripts[token] = value
            }
          }
        }
        
        log.info(self.scripts)
        self.tableView.reloadData()
        
      }
      
    }
  }
}
  
  extension ScriptVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.scripts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.cell, for: indexPath) as? ScriptCellVC else {
        fatalError("The dequeued cell is not an instance of ScanListTVCell.")
      }
      
      cell.label.text = Array(self.scripts.keys)[indexPath.row]
      
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let key = Array(self.scripts.keys)[indexPath.row]
      let value = self.scripts[ key ]
      if let vc: MainVC = instVC(withIdentifier: Constants.VCIDs.main, storyBoard: self.storyboard!) {
        vc.scriptToExecute = value
        self.show(vc, sender: self)
      }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
      self.requestScriptsFromDatabase()
      refreshControl.endRefreshing()
    }
  }
  
  extension ScriptVC {
    @IBAction func didTapBackButton(_ sender: Any) {
      if let vc: MainVC = instVC(withIdentifier: Constants.VCIDs.main, storyBoard: self.storyboard!) {
        self.show(vc, sender: self)
      }
    }
  }
  
  
  class ScriptCellVC: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
    }
    
}
