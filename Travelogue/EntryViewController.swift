//
//  EntryViewController.swift
//  Travelogue
//
//  Created by Ryan Glascock on 12/4/19.
//  Copyright © 2019 Ryan Glascock. All rights reserved.
//

import UIKit
import CoreData
let formatter = DateFormatter()

class EntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var EntryTableView: UITableView!
    var trip: Trip?
    var entries = [Entry]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip?.entryCount?.count ?? 0
    }
    
    
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.deleteEntry(at: indexPath)
        }
        
        return [delete]
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        let entry = trip?.entryCount?[indexPath.row]
        if let cell = cell as? EntryTableViewCell {
            entries.append(entry!)
            let dataImage = Data(referencing: (entry?.image)!)
            let trueImage = UIImage(data:dataImage,scale:1.0)
            cell.cellImage.image = trueImage
            cell.titleLabel.text = entry?.title
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return cell
    }
    
    
    
    func deleteEntry(at indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        
        if let managedObjectContext = entry.managedObjectContext {
            managedObjectContext.delete(entry)
            
            do {
                try managedObjectContext.save()
                self.entries.remove(at: indexPath.row)
                EntryTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Failed to delete file!")
                EntryTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let destination = segue.destination as? EditorViewController{
            destination.trip = trip
            if let row = EntryTableView.indexPathForSelectedRow?.row{
                destination.sentEntry = entries[row]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
