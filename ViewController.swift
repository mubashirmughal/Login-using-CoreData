//
//  ViewController.swift
//  MASSIGNMENT2
//
//  Created by MacStudent on 2023-01-10.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let managedObjectContext = (UIApplication.shared.delegate
                as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func saveContact(_ sender: AnyObject) {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Contacts",
                                       in: managedObjectContext)

        let contact = Contacts(entity: entityDescription!,
            insertInto: managedObjectContext)

        contact.name = name.text!
        contact.address = address.text!
        contact.phone = phone.text!

        do {
            try managedObjectContext.save()
            name.text = ""
            address.text = ""
            phone.text = ""
            status.text = "Contact Saved"

        } catch let error {
            status.text = error.localizedDescription
        }
    }
    @IBAction func findContact(_ sender: AnyObject) {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Contacts",
                                       in: managedObjectContext)

        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.entity = entityDescription

        let pred = NSPredicate(format: "(name = %@)", name.text!)
        request.predicate = pred

        do {
            var results =
                 try managedObjectContext.fetch(request as!
                NSFetchRequest<NSFetchRequestResult>)

            if results.count > 0 {
                let match = results[0] as! NSManagedObject

                name.text = match.value(forKey: "name") as? String
                address.text = match.value(forKey: "address") as? String
                phone.text = match.value(forKey: "phone") as? String
                status.text = "Matches found: \(results.count)"
            } else {
                status.text = "No Match"
            }

        } catch let error {
             status.text = error.localizedDescription
        }
    }


}

