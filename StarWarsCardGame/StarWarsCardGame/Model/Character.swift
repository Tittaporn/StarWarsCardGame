//
//  Character.swift
//  StarWarsCardGame
//
//  Created by Lee McCormick on 1/14/21.
//

import UIKit

class Character {
    let name: String
    let photo: UIImage?
    let faction: String
    init(name: String, photo: UIImage?, faction: String) {
        self.name = name
        self.photo = photo
        self.faction = faction
    }
}

extension Character: Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        //return lhs.name == rhs.name && lhs.photo == rhs.photo && lhs.faction == rhs.faction >> you can omit return if the line is in one line.
        lhs.name == rhs.name && lhs.photo == rhs.photo && lhs.faction == rhs.faction
    }
}


// MARK: - Storyboard Note
/*
 
 This time use segue "Present Modally" 
 - segue "Present Modally" >> To Show the whole screen
 - segue "show" >> To Show with navigation bar
 
 Collection View Cell >> Don't have Image built in, so we need to build it.
 
 override func numberOfSections(in collectionView: UICollectionView) -> Int {
 return 0 >> Default is 1
 }
 
 */
