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
    
    var blankNoteActive = false
    
    lazy var heading: HeadingLabel = HeadingLabel()
    
    lazy var circleButton: CircleButton = {
        let circleButton = CircleButton()
        circleButton.addTarget(self, action: #selector(presentBlankNote), for: .touchUpInside)
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        return circleButton
    }()
    
    @objc func presentBlankNote() {

        let note = Note(context: self.container.viewContext)
        note.date = Date()
        note.body = ""
        blankNoteActive = true
        presentNotesComposer(note)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        container = NSPersistentContainer(name: "NoteContainer")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        loadSavedData()

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
        let vc = NoteComposerViewController()
        vc.delegate = self
        vc.note = note
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
    
    @objc func saveAndReload() {
        
        self.saveContext()
        self.loadSavedData()
    }
    
    func loadSavedData() {
    
        if fetchedResultsController == nil {
            let request = Note.createFetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
//            request.fetchBatchSize = 20
            
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
        
        // refactor here 
        cell.cellView.titleView.text = note.body
        cell.cellView.dateView.text = note.dateString
        cell.cellView.bodyView.text = note.body.truncateBody
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentNotesComposer(fetchedResultsController.object(at: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = fetchedResultsController.object(at: indexPath)
            deleteAction(note)
        }
    }
        
    @objc func deleteAction(_ note: Note) {
        container.viewContext.delete(note)
        saveContext()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard blankNoteActive == false else {return}
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            
        default:
            break
        }
    }
    
}

