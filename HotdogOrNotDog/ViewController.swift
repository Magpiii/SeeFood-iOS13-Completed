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
        imagePicker.sourceType = .camera
        
        /*Determines whether or not the user can edit (i.e. crop) what's in the imageView (typically it's a better idea to set this to true so that the machine learning model can learn to use edited photos, but in the interest of time for this project it is set to false):
        */
        imagePicker.allowsEditing = false
    }
    
    func detect(image: CIImage) {
        //Initializes machine learning model:
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { fatalError("Error code 2: could not initialize CoreML model.") }
        
        //Initializes a request in the machine learning model:
        let request = VNCoreMLRequest(model: model) { (request, error) in
            /*Initializes results as the results of the previously declared request and downcasts it as an array of VNClassificationObervation objects, which are observations made by the machine learning model:
            */
            guard let results = request.results as? [VNClassificationObservation] else { fatalError("Error code 3: could not convert ML Model request to type VNClassificationObservation.") }
            
            print(results)
            
            /*Checks for the highest "confidence score" of what the machine model model thinks the image is by setting a new constant equal to the first result in the array of results:
            */
            if let firstResult = results.first {
                //If the image identifier contains the word "hotdog" or "hot dog..."
                if ((firstResult.identifier.contains("hotdog")) || (firstResult.identifier.contains("hot dog"))) {
                    //...changes the nav bar's title to "Hot dog!"
                    self.navigationItem.title = "Hot dog!"
                } else {
                    //...changes the nav bar's title to "Not dog!"
                    self.navigationItem.title = "Not dog!"
                }
            }
        }
        
        /*Initializes the handler for searching for the user's taken or selected image which is passed into the function:
        */
        let handler = VNImageRequestHandler(ciImage: image)
        
        //Tells the handler to perform the request as an array of requests:
        do {
            try handler.perform([request])
        } catch {
            fatalError("Error: could not perform ML algorithm with specified request. Process failed with error: \(error)")
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
            
            /*Uses detect method (defined above) to pass the CIImage into the machine learning model:
            */
            detect(image: smartImage)
        }
        
        /*Dismisses the imagePicker and goes back to the main View once the user is done selecting or taking an image:
        */
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UINavigationControllerDelegate

extension ViewController: UINavigationControllerDelegate{
    
}

