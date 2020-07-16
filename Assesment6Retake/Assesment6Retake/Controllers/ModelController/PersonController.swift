//
//  PersonController.swift
//  Assesment6Retake
//
//  Created by Connor Holland on 7/16/20.
//  Copyright © 2020 Connor Holland. All rights reserved.
//

import Foundation

class PersonController {
    
    // MARK: - Shared Instance
    static let shared = PersonController()
    
    // MARK: -Source Of Truth
    var persons: [Person] = []
    
    // MARK: - Properties
    var pairs = [[Person?]]()
    var sections = [String]()
    
    // MARK: - Helpful Methods
    
    func randomize() {
        persons.shuffle()
        createPairs()
        createSections()
    }
    
    func createSections() {
        sections = []
        var groupNumber = 1
        var pairCount = pairs.count
        while pairCount > 0 {
            sections.append("Group \(groupNumber)")
            groupNumber += 1
            pairCount -= 1
        }
        print(sections)
    }
    
    func createPairs() {
        var count = persons.count
        var indexOne = 0
        var indexTwo = 1
        
        if persons.count % 2 == 1 {
            var loops = persons.count / 2
            
            while loops > 0 {
                let nameOne = persons[indexOne]
                let nameTwo = persons[indexTwo]
                pairs.append([nameOne, nameTwo])
                loops -= 1
                indexOne += 2
                indexTwo += 2
            }
            guard let last = persons.last else {return}
            pairs.append([last])
        } else if persons.count % 2 == 0 {
            while count > 0 {
                let nameOne = persons[indexOne]
                let nameTwo = persons[indexTwo]
                pairs.append([nameOne, nameTwo])
                count -= 2
                indexOne += 2
                indexTwo += 2
            }
        }
        print(pairs)
    }

    // MARK: - CRUD Methods
    //create
    func addPerson(with fullName: String) {
        let newPerson = Person(fullName: fullName)
        persons.append(newPerson)
        saveToPersistenceStore()
    }
    
    //delete
    func delete(person: Person) {
        guard let index = persons.firstIndex(of: person) else {return}
        persons.remove(at: index)
        saveToPersistenceStore()
    }
    
    // MARK: - Persistence
    //MARK: - Persistence
    func createPersistenceStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = url[0].appendingPathComponent("Person.json") // <- Change File Name
        return fileUrl
    }
    
    //save
    func saveToPersistenceStore() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data =  try jsonEncoder.encode(persons) //<- Change source of truth
            try data.write(to: createPersistenceStore())
        } catch {
            print("Error encoding our person: \(error) -- \(error.localizedDescription)") //<- update error message
        }
    }
    
    //load
    func loadFromPersistenceStore() {
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: createPersistenceStore())
            persons = try jsonDecoder.decode([Person].self , from: data) //<- update source of truth & update decoded type.
        } catch {
            print("Error decoding our person: \(error), -- \(error.localizedDescription)") //<- update error message
        }
    }
}
