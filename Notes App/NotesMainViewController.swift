//
//  ViewController.swift
//  Notes App
//
//  Created by jason smellz on 10/17/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit
import CoreData

class NotesMainViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Note>!
    var container: NSPersistentContainer!
    var predicate: NSPredicate?
    
    lazy var heading: HeadingLabel = HeadingLabel()
    
    lazy var circleButton: CircleButton = {
        let circleButton = CircleButton()
        circleButton.addTarget(self, action: #selector(presentBlankNote), for: .touchUpInside)
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        return circleButton
    }()
    
    @objc func presentBlankNote() {
        print("PRESENt BLANK NOte")
        let note = Note(context: self.container.viewContext)
        note.date = Date()
        note.body = ""
        presentNotesComposer(note)
    }
    
//    lazy var noteComposerViewController = NoteComposerViewController()
//    var dataManager: DataManager!
 
    override func viewDidLoad() {
        super.viewDidLoad()
//        dataManager = DataManager(self)
//        dataManager.importData()
        container = NSPersistentContainer(name: "NoteContainer")
        
        // loads the saved database if it exists, or creates it otherwise
        // if object in memory object with unique constraint matches new object - in memory trumps new
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        
        loadSavedData()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
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
        let vc = NoteComposerViewController()
        vc.delegate = self
        vc.note = note
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataManager.notes.count
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! NotesCell
//
//        cell.cellView.titleView.text = dataManager.notes[indexPath.row].truncatedTitle
//        cell.cellView.dateView.text = dataManager.notes[indexPath.row].dateString
//        cell.cellView.bodyView.text = dataManager.notes[indexPath.row].truncatedBody
//
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        presentNotesComposer(dataManager.notes[indexPath.row])
//    }

}

extension NotesMainViewController {
    
    //  save changes to disk - if there are any changes - only if hasChanges
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    @objc func fetchCommits() {
        
        self.saveContext()
        self.loadSavedData()
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = Note.createFetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Fetch failed")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! NotesCell
        
        let note = fetchedResultsController.object(at: indexPath)
        cell.cellView.titleView.text = note.body
        cell.cellView.dateView.text = note.dateString
        cell.cellView.bodyView.text = note.body.truncateBody()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentNotesComposer(fetchedResultsController.object(at: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = fetchedResultsController.object(at: indexPath)
            delete(note)
        }
    }
    
    @objc func deleteAction(_ note: Note) {
        container.viewContext.delete(note)
        saveContext()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            
        default:
            break
        }
    }
    
}

extension String {
    
    // for use in note cell
    func truncateTitle() -> String{
        return String(self.prefix(30))
    }
    
    func truncateBody() -> String {

        // if new line exists truncate body after first new line
        guard self.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return self.components(separatedBy: "\n")[1]
        }
        
        // else truncate after first 30 characters
        guard self.count > 30 else {return ""}
        // find first space after taking suffix after thirty characters
        let firstSpaceAfterSuffix = self.suffix(self.count - 30).split(separator: " " )[0]
        // split components based on first occurence of word after first space found
        return self.components(separatedBy: firstSpaceAfterSuffix)[1]
    }
    
}
