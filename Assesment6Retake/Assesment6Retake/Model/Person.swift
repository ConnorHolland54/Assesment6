//
//  Person.swift
//  Assesment6Retake
//
//  Created by Connor Holland on 7/16/20.
//  Copyright © 2020 Connor Holland. All rights reserved.
//

import Foundation

class Person: Codable {
    let fullName: String
    
    init(fullName: String) {
        self.fullName = fullName
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.fullName == rhs.fullName
    }
}
