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
            
            //STEP 5 : Assing the delegate for the FilterVC to 'self' meaning the CardCollectionViewController
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


// STEP 4 : Adopt the protocol and implement the stubs
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
 ___________________________________________________________
 
 PROTOCOL DELEGATE
 
 Mostly from view to view >> One View to Another View >> TableVC and TableViewCell to communicate.
 
 There is no way to communicate backward from the button on DetailVC to TableVC. That  why we are using segue way.
 
 USE - When user input are required for protocol comumunication pattern. It is for One To One Communication.
 
 Protocol Delegate >> more from passing functions from one view to another view
 Segue >> more for passing data from one view to another view
 
 ___________________________________________________________
 
 
  PROTOCOL DELEGATE NOTE BY Ben Tincher
 //  I'm the Boss; if any customers order stuff (AKA user pushes the buttons on the VC), this is/are the task(s) I will need done today... I'm definitely going to need a delegate (employee) to do to these task(s)

 // STEP 1 : Construct your protocol
 protocol FilterSelectionDelegate: AnyObject {
 func selectedFaction(faction: String) //    protocol stubs are what information we need to pass back up the chain of views - typically user interacts with the view that then triggers passing back up the chain
 }
 
 class FilterViewController: UIViewController {
 
 // STEP 2 : Create the landing pad for the delegate
 //  I need a delegate! Who is my delegate?!?  I'm looking for my employees!
 weak var delegate: FilterSelectionDelegate?
 
 override func viewDidLoad() {
 super.viewDidLoad()
 }
 
 @IBAction func jediButtonTapped(_ sender: Any) {
 
 //  (optional delegate? checks to see if a delegate has been assigned... did someone showed up for work?)
 
 //STEP 3 : Call the protocol method where needed.

 delegate?.selectedFaction(faction: "jedi")
 //  if optional passes, a delegate does exist... aka an employee showed up for work
 //  thank goodness I have a delegate now... do this task please... delegate (employee) goes off an does the task... how he/she actually completes the task is defined on the delegate's controller.
 self.dismiss(animated: true, completion: nil)
 }
 
 @IBAction func sithButtonTapped(_ sender: Any) {
 //  thank goodness I have a delegate now... do this task please. mmmk??  thanks.
 delegate?.selectedFaction(faction: "sith")
 self.dismiss(animated: true, completion: nil)
 }
 }
 ___________________________________________________________

// PROTOCOL DELEGATE NOTE BY Ben Tincher
//  I'm the Boss; if any customers order stuff (AKA user pushes the buttons on the VC), this is/are the task(s) I will need done today... I'm definitely going to need a delegate (employee) to do to these task(s)

// STEP 1 : Construct your protocol
protocol FilterSelectionDelegate: AnyObject {
func selectedFaction(faction: String) // protocol stubs are what information we need to pass back up the chain of views - typically user interacts with the view that then triggers passing back up the chain
}

class FilterViewController: UIViewController {

// I need a delegate! Who is my delegate?!?  I'm looking for my employees!
// STEP 2 : Create the landing pad for the delegate
weak var delegate: FilterSelectionDelegate?

@IBAction func jediButtonTapped(_ sender: Any) {
//  (optional delegate? checks to see if a delegate has been assigned... did someone showed up for work?)
    //STEP 3 : Call the protocol method where needed.
delegate?.selectedFaction(faction: "jedi")
//  if optional passes, a delegate does exist... aka an employee showed up for work
//  thank goodness I have a delegate now... do this task please... delegate (employee) goes off an does the task... how he/she actually completes the task is defined on the delegate's controller.
self.dismiss(animated: true, completion: nil)
}
    
@IBAction func sithButtonTapped(_ sender: Any) {
// thank goodness I have a delegate now... do this task please. mmmk??  thanks.
//STEP 3 : Call the protocol method where needed.
delegate?.selectedFaction(faction: "sith")
self.dismiss(animated: true, completion: nil)
}
}

class CardCollectionViewController: UICollectionViewController {
    if segue.identifier == "toDetailVC" {
        let destination = segue.destination as? FilterViewController
        //STEP 5 : Assing the delegate for the FilterVC to 'self' meaning the CardCollectionViewController
        destination?.delegate = self
    }
}

// STEP 4 : Adopt the protocol and implement the stubs
extension CardCollectionViewController: FilterSelectionDelegate {
    func selectedFaction(faction: String) {
        selectedFaction = faction
        shuffleCharacters(faction: faction)
    }
}
___________________________________________________________
 
 5 STEP OF PROTOCOL DELEGATE
 // STEP 1 : Construct your protocol
 // STEP 2 : Create the landing pad for the delegate
 // STEP 3 : Call the protocol method where needed.
 // STEP 4 : Adopt the protocol and implement the stubs
 // STEP 5 : Assing the delegate for the FilterVC to 'self' meaning the CardCollectionViewController

___________________________________________________________
*/
