//
//  CharacterCollectionViewCell.swift
//  StarWarsCardGame
//
//  Created by Lee McCormick on 1/14/21.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var characterImageView: UIImageView!
    
    // MARK: - Fuctions
    // update single imageView
    func displayImage(character: Character) {
    
        // You can do this on storyboard, but you can do so much more by code programmatically.
        // change image to aspect fill by coding. The imageView has different contentMode to present
        characterImageView.contentMode = .scaleAspectFill //Zoom in and fill the whole image
        
        //characterImageView.contentMode = .scaleToFill //Fill the whole image with out zoom in, make the photos not look so good.
        characterImageView.image = character.photo
    }
}
