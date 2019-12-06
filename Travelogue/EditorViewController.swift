//
//  EditorViewController.swift
//  Travelogue
//
//  Created by Ryan Glascock on 12/4/19.
//  Copyright © 2019 Ryan Glascock. All rights reserved.
//

import UIKit
import CoreData

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var trip : Trip?
    var sentEntry: Entry?
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
    }
    
    
    @IBAction func choosePhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else{
            print("Failed to open photos")
            return
        }
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert = UIAlertController(title: "Warning", message: "The device has no camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func clickSave(_ sender: Any) {
        if imageView.image == nil{
            print("Please select an image")
            return
        }
        let imageData: NSData = imageView.image!.pngData()! as NSData
        if sentEntry?.title != nil{
            sentEntry!.update(title: textTitle.title!, body: theTextview.text, image: imageData, trip: trip!, modDate: Date(timeIntervalSinceNow: 0))
            let managedContext = sentEntry!.managedObjectContext
            do{
                try managedContext?.save()
            }
            catch{
                print("Failed to save file.")
            }
        }
        else{
            let entry = Entry(title: textTitle.title!, body: theTextview.text, image: imageData, trip: trip!, modDate: Date(timeIntervalSinceNow: 0))
            trip?.addToEntries(entry!)
            let managedContext = entry!.managedObjectContext
            do{
                try managedContext?.save()
            }
            catch{
                print("Failed to save file.")
            }
        }
        performSegue(withIdentifier: "saveSeg", sender: nil)
    }
    
    @IBOutlet weak var textTitle: UINavigationItem!
    
    @IBAction func editTextfield(_ sender: Any) {
        textTitle.title = theTextfield.text
    }
    
    @IBOutlet weak var theTextfield: UITextField!
    
    @IBOutlet weak var theTextview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if sentEntry?.title == nil{
            return
        }
        textTitle.title = sentEntry?.title
        theTextfield.text = sentEntry?.title
        theTextview.text = sentEntry?.body
        let imageData = Data(referencing: (sentEntry?.image)!)
        let trueImage = UIImage(data:imageData,scale:1.0)
        imageView.image = trueImage
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let destination = segue.destination as? EntryViewController{
            destination.trip = trip
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
