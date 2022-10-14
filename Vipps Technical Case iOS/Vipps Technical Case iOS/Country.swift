//
//  Country.swift
//  Vipps Technical Case iOS
//
//  Created by Marius Genton on 10/14/22.
//

import Foundation


struct Country: Decodable { // Used to parse JSON and store data
    
    let name: String
    let capital: String
    let altSpellings: [String]
    
    // Could use more properties but these ones are the only ones that will be useful in the context of this app
    
}
