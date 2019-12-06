//
//  TripsViewController.swift
//  Travelogue
//
//  Created by Ryan Glascock on 12/4/19.
//  Copyright © 2019 Ryan Glascock. All rights reserved.
//

import UIKit
import CoreData

class tripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var trips = [Trip]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    @IBOutlet weak var TripsTableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        if let cell = cell as? TripsTableViewCell {
            cell.titleLabel.text = trips[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        
        let delete = UIAlertAction(title: "Delete", style: .default){ (action) in
            let deltrips = self.trips[indexPath.row]
            let managedContext = deltrips.managedObjectContext
            managedContext?.delete(deltrips)
            self.trips.remove(at: indexPath.row)
            self.TripsTableView.deleteRows(at: [indexPath], with: .automatic)
            do{
                try managedContext?.save()
            }
            catch{
                print("Failed to delete.")
            }
        }
        alert.addAction(delete)
        alert.addAction(cancel)
        if trip.entryCount!.count > 0{
            self.present(alert, animated: true)
        }
        else{
            let deltrips = trips[indexPath.row]
            let managedContext = deltrips.managedObjectContext
            managedContext?.delete(deltrips)
            trips.remove(at: indexPath.row)
            TripsTableView.deleteRows(at: [indexPath], with: .automatic)
            do{
                try managedContext?.save()
            }
            catch{
                print("Error info: \(error)")
            }
        }
    }
    let alert = UIAlertController(title: "Confirm Delete", message: "Delete this trip?", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel){ (action) in
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let destination = segue.destination as? EntryViewController ,
            let row = TripsTableView.indexPathForSelectedRow?.row{
            destination.trip = trips[row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        do{
            trips = try managedContext.fetch(fetchRequest)
            TripsTableView.reloadData()
        }
        catch{
            print("Fetch failed.")
        }
        // Do any additional setup after loading the view.
    }
    


}
