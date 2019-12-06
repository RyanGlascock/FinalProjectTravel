//
//  TripCreatorViewController.swift
//  Travelogue
//
//  Created by Ryan Glascock on 12/4/19.
//  Copyright © 2019 Ryan Glascock. All rights reserved.
//

import UIKit

class TripCreatorViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickSave(_ sender: Any) {
        let trip = Trip(title: titleField.text!)
        let managedContext = trip?.managedObjectContext
        do{
            try managedContext?.save()
        }
        catch{
            print("Failed to save file.")
        }
        performSegue(withIdentifier: "saveSeg", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
