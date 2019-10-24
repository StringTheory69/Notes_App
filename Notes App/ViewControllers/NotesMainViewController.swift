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
    
    // storage
    var fetchedResultsController: NSFetchedResultsController<Note>!
    var container: NSPersistentContainer!
    var predicate: NSPredicate?
    
    // UI
    lazy var heading: HeadingLabel = HeadingLabel()
    
    lazy var addBlankNoteButton: CircleButton = {
        let addBlankNoteButton = CircleButton()
        addBlankNoteButton.addTarget(self, action: #selector(presentBlankNote), for: .touchUpInside)
        return addBlankNoteButton
    }()
    
    // logic
    // edge case: blankNoteActive to bipass the traditional tableview delete action when a blank note is created but nothing is added to it
    var blankNoteActive = false
 
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
}
    
// setup
extension NotesMainViewController {
    
    fileprivate func setupView() {
        
        view.backgroundColor = UIColor.notesBackground
        tableView.separatorStyle = .none
        tableView.register(NotesCell.self, forCellReuseIdentifier: "notesCell")
        tableView.rowHeight = 120 + 10
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: heading)
        
        view.addSubview(addBlankNoteButton)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addBlankNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        addBlankNoteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    }
}

// NoteComposerViewController presentation
extension NotesMainViewController {
    
    @objc fileprivate func presentBlankNote() {
        
        // create blank note
        let note = Note(context: self.container.viewContext)
        note.date = Date()
        note.body = ""
        
        blankNoteActive = true
        presentNotesComposer(note)
    }
    
    fileprivate func presentNotesComposer(_ note: Note) {
        let vc = NoteComposerViewController()
        vc.delegate = self
        vc.note = note
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// storage handling
extension NotesMainViewController {
    
    //  save changes to disk - if there are any changes
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
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
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        } catch {
            print("Fetch failed")
        }
    }
    
    @objc func deleteAction(_ note: Note) {
        container.viewContext.delete(note)
        saveContext()
    }
}

// tableview datasource and delete action
extension NotesMainViewController {
    
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
        cell.note = note
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

