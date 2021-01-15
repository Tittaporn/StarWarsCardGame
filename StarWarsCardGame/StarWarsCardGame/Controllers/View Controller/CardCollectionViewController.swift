//
//  CardCollectionViewController.swift
//  StarWarsCardGame
//
//  Created by Lee McCormick on 1/14/21.
//

import UIKit

// private let reuseIdentifier = "Cell" >> Don't need it here because we have it inside >> func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)

class CardCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    var displayedCharecters: [Character] = []
    var targetCharacter: Character?
    var selectedFaction = "sith"
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        shuffleCharecters(faction: selectedFaction)
    }
    
    // MARK: - Helper Fuctions
    func shuffleCharecters(faction: String) {
        if faction == "jedi" {
            
            // We can shuffle first.
            let jediShuffleGroup = CharacterController.jedi.shuffled()
            
            // prefix is giving the maximum legth of array.
            let jediGroup = jediShuffleGroup.prefix(3)
            
            displayedCharecters = Array(jediGroup) //SubSequence Array?? >> This is convert it to be array.
            
            //using randomElement to grab sith
            targetCharacter = CharacterController.sith.randomElement()
            
        } else {
            let sithGroup = CharacterController.sith.prefix(3)
            displayedCharecters = Array(sithGroup)
            targetCharacter = CharacterController.jedi.randomElement()
        }
        updateViews()
    }
    
    func updateViews() {
        guard let charecter = targetCharacter else {return}
        displayedCharecters.append(charecter)
        
        // shuffle array
        displayedCharecters.shuffle()
        
        title = "Find \(charecter.name)"
        collectionView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilterVC" {
            let destination = segue.destination as? FilterViewController
            // conform the protocol here and sent it to delegate on FilterViewController
            destination?.delegate = self
        }
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedCharecters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // we need to guard because we use custom collection view cell, if not we have to return UICollectionViewCell()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCollectionViewCell else { return UICollectionViewCell() }
        
        // Find the character of each index
        //let character = CharacterController.jedi[indexPath.row]
        let character = displayedCharecters[indexPath.row]
        
        // Passing the character in the cell
        cell.displayImage(character: character)
        
        return cell
    }
    
    // This function will run any time we selected the cell.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //using func presentAlert() to Present an alert
        let charater = displayedCharecters[indexPath.row]
        presentAlert(character: charater)
    }
    
    // MARK: - Alert
    func presentAlert(character: Character) {
        
        // Checking if success is true or false
        let success = character == targetCharacter
        
        // Create alert using ternary operator
        let alertController = UIAlertController(title: success ? "Good job" : "Better luck next time..", message: nil, preferredStyle: .alert)
        
        // style: .cancel >> blue, .destructive >> red
        let doneAction = UIAlertAction(title: "Done", style: .cancel)
        
        // (_) wild card when we don't need to use it. Click Enter to get handler.
        let shuffleAction = UIAlertAction(title: "Shulffle", style: .default) { (_) in
            
            //It is calling from somewhere else memory management. It can create a memory leak. The clousure live in different place with this file. So we use `self.` to access this class.
            self.shuffleCharecters(faction: self.selectedFaction )
        }
        
        // add button to alert
        alertController.addAction(doneAction)
        
        if success {
            alertController.addAction(shuffleAction)
        }
        
        // present and show the alert
        present(alertController, animated: true, completion: nil)
        //present(alertController, animated: true) >> same as line above.
    }
}

// MARK: - Extensions UICollectionViewDelegateFlowLayout
// UICollectionViewDelegateFlowLayout >> It gonna delegate what the flow collection look likes.
extension CardCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // This function is going to tell the cell how big it should be. It helps to size the cell.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //frame is the whole screen
        let width = view.frame.width / 2 //The width is half of the screen
        
        return CGSize(width: width - 20, height: width + 30)
    }
}

extension CardCollectionViewController: FiletrSelectionDelegate {
    
    func selectedFaction(faction: String) {
        
        selectedFaction = faction
        
        shuffleCharecters(faction: faction)
    }
    
    
}


/*
 NOTE
 
 TERNARY OPERATOR
 
 Avoid  >>>  ternary nested
 
 Swift has a rarely used operator called the ternary operator. It works with three values at once, which is where its name comes from: it checks a condition specified in the first value, and if it’s true returns the second value, but if it’s false returns the third value.
 
 The ternary operator is a condition plus true or false blocks all in one, split up by a question mark and a colon, all of which which makes it rather hard to read. Here’s an example:
 
 let firstCard = 11
 let secondCard = 10
 print(firstCard == secondCard ? "Cards are the same" : "Cards are different")
 
 //This if else work the same way of ternary operator below
 if success == true {
 title = "Good job"
 } else {
 tittle = "Better luck next time"
 }
 
 //This Ternary Operator work the same way of if else above.
 success ? "Good job" : "Better luck next time.."
 
 TERNARY OPERATOR SYNTAX
 condition ? if true : if false
 
 https://www.hackingwithswift.com/sixty/3/7/the-ternary-operator
 _________________________________________________________________________
 
 CLOSURES
 
 Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.
 
 Closures can capture and store references to any constants and variables from the context in which they are defined. This is known as closing over those constants and variables. Swift handles all of the memory management of capturing for you.
 
 Closure Expression Syntax
 Closure expression syntax has the following general form:
 
 { (parameters) -> return type in
 statements
 }
 
 https://docs.swift.org/swift-book/LanguageGuide/Closures.html#:~:text=Closures%20are%20self-contained%20blocks%20of%20functionality%20that%20can,from%20the%20context%20in%20which%20they%20are%20defined.
 
 ___________________________________________________________
 
 SELF Swift self
 
 In Swift self is a special property of an instance that holds the instance itself. Most of the times self appears in an initializer or method of a class, structure or enumeration. The motto favor clarity over brevity is a valuable strategy to follow.
 
 https://dmitripavlutin.com/how-to-use-correctly-self-keyword-in-swift/
 */


