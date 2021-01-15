//
//  FilterViewController.swift
//  StarWarsCardGame
//
//  Created by Lee McCormick on 1/14/21.
//

import UIKit

// MARK: - Protocol
protocol FiletrSelectionDelegate: AnyObject {
    func selectedFaction(faction: String)
}

class FilterViewController: UIViewController {
    
    // MARK: - Properties
    // somebody to comform the protocol by rule need it
    weak var delegate: FiletrSelectionDelegate?
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func sithButtonTapped(_ sender: Any) {
        delegate?.selectedFaction(faction: "sith")
        // dismiss the UIViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func jediButtonTapped(_ sender: Any) {
        delegate?.selectedFaction(faction: "jedi")
        self.dismiss(animated: true)
    }
}
