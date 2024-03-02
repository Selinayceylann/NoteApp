

import UIKit
import CoreData

class SecondViewController: UIViewController {

    @IBOutlet weak var saveButton1: UIButton!
    @IBOutlet weak var noteField: UITextView!
    @IBOutlet weak var subjectField: UITextField!
    
    var chosenKey = ""
    var chosenKeyId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if chosenKey != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Keys")
            let idString = chosenKeyId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let subject = result.value(forKey: "subject") as? String {
                            subjectField.text = subject
                        }
                        
                        if let note = result.value(forKey: "notes") as? String {
                            noteField.text = note
                        }
                    }
                }
                
            } catch {
                print("Error")
            }
        } else {
            
            subjectField.text = ""
            noteField.text = ""
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)

        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    

  
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newKeys = NSEntityDescription.insertNewObject(forEntityName: "Keys", into: context)
        newKeys.setValue(subjectField.text!, forKey: "subject")
        newKeys.setValue(noteField.text!, forKey: "notes")
        newKeys.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
        } catch {
            print("Error!")
        }
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
    

