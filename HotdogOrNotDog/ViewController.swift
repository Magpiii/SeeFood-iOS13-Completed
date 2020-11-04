//
//  ViewController.swift
//  HotdogOrNotDog
//
//  Created by Hunter Hudson on 11/4/20.
//

import UIKit

//Import relevant ML files:
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    //Initializes ImagePickerController as its own ViewController:
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set the imagePicker's delegate as the current ViewController:
        imagePicker.delegate = self
        
        /*Allows the user to use device camera to insert an image:
        imagePicker.sourceType = .camera
        */
        
        //Allows the user to use photo library to insert an image:
        imagePicker.sourceType = .photoLibrary
        
        /*Determines whether or not the user can edit (i.e. crop) what's in the imageView (typically it's a better idea to set this to true so that the machine learning model can learn to use edited photos, but in the interest of time for this project it is set to false):
        */
        imagePicker.allowsEditing = false
    }
    
    func detect(image: CIImage) {
        //Initializes machine learning model:
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { fatalError("Error code 2: could not initialize CoreML model.") }
        
        let request = VNCoreMLRequest(model: model) { (VNRequest, Error?) in
            <#code#>
        }
    }

    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        //Opens the imagePicker (declared above) when the user taps the camera button:
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate:

extension ViewController: UIImagePickerControllerDelegate {
    //This delegate method is triggered when the user picks an image from an ImagePicker:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*Declares a constant that uses the key of the image taken or selected in order to use the original, unedited image within the app (optionally bound and downcasted as it can technically be nil):
        */
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //Inserts the selected/taken image into the imageView:
            imageView.image = userImage
            
            /*Sets the image selected or taken by the user to a "Core Image Image" which can be used by a machine learning model:
            */
            guard let smartImage = CIImage(image: userImage) else { fatalError("Error code 1: could not convert user inputted image to CIImage.") }
        }
        
        /*Dismisses the imagePicker and goes back to the main View once the user is done selecting or taking an image:
        */
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UINavigationControllerDelegate

extension ViewController: UINavigationControllerDelegate{
    
}

