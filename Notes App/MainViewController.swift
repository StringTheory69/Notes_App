//
//  ViewController.swift
//  Notes App
//
//  Created by jason smellz on 10/17/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController, MainViewProtocol {
    func dataLoaded() {
        tableView.reloadData()
    }
    
    func dataLoading() {
        // spinner here
        print("DATA LOADING")
    }
    
    
    lazy var heading: HeadingLabel = HeadingLabel()
    
    lazy var circleButton: CircleButton = {
        let circleButton = CircleButton()
        circleButton.addTarget(self, action: #selector(presentBlankNote), for: .touchUpInside)
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        return circleButton
    }()
    
    @objc func presentBlankNote() {
        
        presentNotesComposer(Note(Date(), ""))
    }
    
//    lazy var noteComposerViewController = NoteComposerViewController()
    var dataManager: DataManager!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager(self)
        dataManager.importData()
        setupView()
    }
    
    private func setupView() {
        
        view.backgroundColor = UIColor.notesBackground
        tableView.separatorStyle = .none
        tableView.register(NotesCell.self, forCellReuseIdentifier: "notesCell")
        tableView.rowHeight = 120 + 10
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: heading)
        
        view.addSubview(circleButton)
        setupLayout()
    }
    
    private func setupLayout() {
        circleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        circleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    }
    
    func presentNotesComposer(_ note: Note) {
        navigationController?.pushViewController(NoteComposerViewController.init(note:
            note), animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.notes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! NotesCell
        
        cell.cellView.titleView.text = dataManager.notes[indexPath.row].truncatedTitle
        cell.cellView.dateView.text = dataManager.notes[indexPath.row].dateString
        cell.cellView.bodyView.text = dataManager.notes[indexPath.row].truncatedBody

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentNotesComposer(dataManager.notes[indexPath.row])
    }


}

