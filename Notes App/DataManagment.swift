//
//  DataManagment.swift
//  Notes App
//
//  Created by jason smellz on 10/18/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import Foundation

class DataImporter {
    /*
     DataImporter is a class to import data from an external file.
     The class is assumed to take a nontrivial amount of time to initialize.
     */
    var filename = "data.txt"
    // the DataImporter class would provide data importing functionality here
    
    func getData(_ completion: @escaping () -> ()) {
        completion()
    }
}

class DataManager {
    lazy var importer = DataImporter()
    var notes: [Note] = []
    weak var delegate: MainViewController!
    
    init(_ delegate: MainViewController) {
        self.delegate = delegate
    }
    
    func importData() {
        delegate.dataLoading()
        importer.getData(dataImported)
    }
    
    func dataImported() {
        print("IMPORTED")
        for _ in 0...10 {
            let note = Note(Date(), "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer condimentum dictum fringilla. Proin nec molestie metus, vel elementum velit. Vestibulum ut nibh in sapien aliquam vulputate. Pellentesque quis ipsum pharetra leo tempus molestie a at massa. Quisque tincidunt congue erat, a elementum leo cursus quis. Nunc tincidunt dui quis hendrerit vestibulum. Praesent justo lacus, imperdiet nec volutpat non, varius at enim. Donec ut metus lacus. Cras rhoncus elementum augue ut vehicula.")
            notes.append(note)
        }
        
        delegate.dataLoaded()
        
    }
}

protocol MainViewProtocol {
    func dataLoaded()
    func dataLoading()
}
