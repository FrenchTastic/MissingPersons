//
//  ViewController.swift
//  MissingPersons
//
//  Created by Romain Pardon on 10/08/2016.
//  Copyright © 2016 SlasherApp. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseUrl = "http://localhost:6069/img/"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let imagePicker = UIImagePickerController()
    var haSelectedImage: Bool = false
    let missingPeople = [
        Person(personImageUrl: "person1.jpg"),
        Person(personImageUrl: "person2.jpg"),
        Person(personImageUrl: "person3.jpg"),
        Person(personImageUrl: "person4.jpg"),
        Person(personImageUrl: "person5.jpg"),
        Person(personImageUrl: "person6.png")
    ]
    
    var selectedPerson: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        imagePicker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as? PersonCell {
            let person = missingPeople[indexPath.row]
            cell.configureCell(person)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedPerson = missingPeople[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        cell.configureCell(selectedPerson!)
        cell.setSelected()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg.image = pickImage
            haSelectedImage = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false;
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Select Person", message: "Please select a missing person to check", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func checkForMatch(sender: AnyObject) {
        if selectedPerson == nil || !haSelectedImage {
            showErrorAlert()
        } else {
            if let myImg = selectedImg.image, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces:[MPOFace]!, error:NSError!) in
                    if error == nil {
                        var faceId: String?
                        for face in faces {
                            faceId = face.faceId
                            break
                        }
                        if faceId != nil {
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceId, faceId2: faceId, completionBlock: { (result:MPOVerifyResult!, error:NSError!) in
                                if error == nil {
                                    print(result.confidence)
                                    print(result.isIdentical)
                                    print(result.debugDescription)
                                } else {
                                    print(error.debugDescription)
                                }
                                
                            })
                        }
                    }
                })
            }
        }
    }
}

