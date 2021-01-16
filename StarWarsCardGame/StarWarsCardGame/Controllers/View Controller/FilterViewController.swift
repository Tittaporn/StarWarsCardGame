//
//  FilterViewController.swift
//  StarWarsCardGame
//
//  Created by Lee McCormick on 1/14/21.
//

import UIKit


// STEP 1 : Construct your protocol
// MARK: - Protocol
protocol FiletrSelectionDelegate: AnyObject {
    func selectedFaction(faction: String)// >> This is call "Protocol Stubs"
    // stubs = functions with no body
    // You can put any protocol function here....
}

/*
 protocol PlayControllerDelegate: AnyObject {
 func play()
 func rewind()
 func stop()
 }
 */
class FilterViewController: UIViewController {
    
    // MARK: - Properties
    // somebody to comform the protocol by rule need it
    // STEP 2 : Create the landing pad for the delegate
    weak var delegate: FiletrSelectionDelegate?
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func sithButtonTapped(_ sender: Any) {
        //STEP 3 : Call the protocol method where needed.
        delegate?.selectedFaction(faction: "sith")
        // dismiss the UIViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func jediButtonTapped(_ sender: Any) {
        delegate?.selectedFaction(faction: "jedi")
        self.dismiss(animated: true)
    }
}
