////
////  DataManagment.swift
////  Notes App
////
////  Created by jason smellz on 10/18/19.
////  Copyright © 2019 jacob. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//class DataImporter {
//    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    
//    func saveData(_ note: Note) {
//        
//        // check if note.id exists as data
//        singleFetch(note) { (n, error) in
//            if error != nil {
//                return
//            }
//            
//            n.body = note.body
//            n.date = note.date
//            n.id = note.id
//            
//            appDelegate.saveContext()
//            print("saved", newEntry.body, newEntry.date)
//            
//        }
//        
//    }
//    
//    func singleFetch(_ note: Note, _ completionHandler: (_ result: NoteContainer, _ error: Error?) -> ()) {
//        
//        let container = appDelegate.persistentContainer
//        let context = container.viewContext
//        let fetchRequest = NSFetchRequest<NoteContainer>(entityName: "NoteContainer")
//        fetchRequest.predicate = NSPredicate(format: "id = %@", note.id)
//        
//        do {
//            let notes = try context.executeFetchRequest(fetchRequest)
//            assert(profiles.count < 2) // we shouldn't have any duplicates in CD
//            
//            if let n = notes.first as? Note {
//                // we've got the profile already cached!
//                completionHandler(n, nil)
//            } else {
//                // no local cache yet, use placeholder for now
//                completionHandler(n, nil)
//
//            }
//            
//        } catch {
//            // handle error
//        }
//    }
//    
//    func fetchData(_ completion: @escaping ([Note]) -> () ) {
//        
//        var notes: [Note] = []
//        // Set up fetch request
//        let container = appDelegate.persistentContainer
//        let context = container.viewContext
//        let fetchRequest = NSFetchRequest<NoteContainer>(entityName: "NoteContainer")
//        
//        do {
//            var notesData: [NoteContainer] = try context.fetch(fetchRequest)
//            print("fetchage", notesData)
//            
////            if let note = notesData.first {
////                print(note)
////
////                if let body = note.body, let date = note.date{
////                    print(body, date)
////                }
////
////                print(note)
////            }
//            
//            for (index, noteData) in notesData.enumerated() {
////                guard let note = notesData.first else {return print("FAILURE TO FETCH 1")}
////                guard let date = note.date, let body = note.body else {return print("FAILURE TO FETCH 2")}
//                if let note = notesData[index] as? NoteContainer {
////                    print(note)
//                    
//                    if let body = note.body, let date = note.date{
//                        print(body, date)
//                        notes.append(Note(date, body))
//                    }
////                    print(note)
//                }
//            }
//            DispatchQueue.main.async {
//                completion(notes)
//            }
//        } catch {
//            completion([])
//            print("Couldn't Fetch Data")
//        }
//        
//    }
//
////    func getData(_ completion: @escaping () -> ()) {
////        completion()
////        fetchData(completion)
////    }
//}
//
//class DataManager {
//    lazy var importer = DataImporter()
//    var notes: [Note] = []
//    weak var delegate: NotesMainViewController!
//    
//    init(_ delegate: NotesMainViewController) {
//        self.delegate = delegate
//    }
//    
//    func importData() {
//        delegate.dataLoading()
//        importer.fetchData(dataImported)
//    }
//
//    func dataImported(_ notes:[Note]) {
//        print("IMPORTED")
//        self.notes = notes
////        for _ in 0...10 {
////            let note = Note(Date(), "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer condimentum dictum fringilla. Proin nec molestie metus, vel elementum velit. Vestibulum ut nibh in sapien aliquam vulputate. Pellentesque quis ipsum pharetra leo tempus molestie a at massa. Quisque tincidunt congue erat, a elementum leo cursus quis. Nunc tincidunt dui quis hendrerit vestibulum. Praesent justo lacus, imperdiet nec volutpat non, varius at enim. Donec ut metus lacus. Cras rhoncus elementum augue ut vehicula.")
////            notes.append(note)
////            importer.saveData(note)
////        }
//        delegate.dataLoaded()
//        
//    }
//}
//
//protocol MainViewProtocol {
//    func dataLoaded()
//    func dataLoading()
//}
