//
//  ViewController.swift
//  imageProcessor
//
//  Created by Lauren Shultz on 4/18/18.
//  Copyright © 2018 Lauren Shultz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate
{

    var port = Port()
    var machineId = "C7700777"
    var user = "DefaultUser"
    var currentImage = UIImage()
    var currentMessage = ""
    var menuToggle = 0
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let docDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    @IBOutlet weak var imagesButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var changeMachineButton: UIButton!
    @IBOutlet weak var changeUserButton: UIButton!
    @IBOutlet weak var imageDisplayer: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var messageDisplayer: UILabel!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var machineTag: UILabel!
    @IBOutlet weak var userTag: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton.isHidden = true
        imagesButton.isHidden = true
        changeMachineButton.isHidden = true
        changeUserButton.isHidden = true
        
        messageField.delegate = self
        getUser()
        getMachine()
        machineTag.text = machineId
        userTag.text = user
        //imageDisplayer = currentImage;
        //port.startConnection()
        
        if(!port.connectionSuccesful)
        {
            print("Could not connect.")
            //couldNotConnect()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func toggleMenu(_ sender: Any)
    {
        if(menuToggle == 0)
        {
            editButton.isHidden = false
            imagesButton.isHidden = false
            changeMachineButton.isHidden = false
            changeUserButton.isHidden = false
        }
        else
        {
            editButton.isHidden = true
            imagesButton.isHidden = true
            changeMachineButton.isHidden = true
            changeUserButton.isHidden = true
        }
    }
    func getUser()
    {
        do
        {
            let fileURL = docDirURL.appendingPathComponent("storedName").appendingPathExtension("txt")
            let userName = try String(contentsOf: fileURL)
            if(userName == "" || userName == "\n")
            {
                print("USER NAME IS EMPTY")
                getNamePopUp()
            }
            else
            {
                user = userName
            }
        }
        catch
        {
            print(error)
        }
    }
    func setUser(_ nameIn: String)
    {
        do
        {
            user = nameIn
            let fileURL = docDirURL.appendingPathComponent("storedName").appendingPathExtension("txt")
            try user.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            let readText = try String(contentsOf: fileURL)
            print("Name set to: ", readText)
            print("NAME SAVED SUCCESFULLY")
        }
        catch
        {
            print("NAME COULD NOT SAVE")
            print(error)
        }
    }
    func getMachine()
    {
        do
        {
            let fileURL = docDirURL.appendingPathComponent("storedMachine").appendingPathExtension("txt")
            let macName = try String(contentsOf: fileURL)
            if(macName == "" || macName == "\n")
            {
                print("USER NAME IS EMPTY")
                getMachinePopUp()
            }
            else
            {
                machineId = macName
            }
        }
        catch
        {
            print(error)
        }
    }
    func setMachine(_ macNameIn: String)
    {
        do
        {
            machineId = macNameIn
            let fileURL = docDirURL.appendingPathComponent("storedMachine").appendingPathExtension("txt")
            try machineId.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            let readText = try String(contentsOf: fileURL)
            print("Machine set to: ", readText)
            print("MACHINE SAVED SUCCESFULLY")
        }
        catch
        {
            print("MACHINE COULD NOT SAVE")
            print(error)
        }
    }
    func getNamePopUp()
    {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "textEntryPopUp") as! TextEntryPopUpViewController
        popOverVC.returnType = 0
        popOverVC.titleIn = "Enter Name:"
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        popOverVC.setUser = setUser
    }
    func getMachinePopUp()
    {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "textEntryPopUp") as! TextEntryPopUpViewController
        popOverVC.returnType = 1
        popOverVC.titleIn = "Enter Machine ID:"
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        popOverVC.setMachine = setMachine
    }
    @IBAction func changeMachine(_ sender: Any)
    {
        getMachinePopUp()
    }
    @IBAction func changeUser(_ sender: Any)
    {
        getNamePopUp()
    }
    
    /*
     * FUNCTION: touchesBegan
     * PURPOSE: Is called when touch begins
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    /*
     * FUNCTION: textFieldShouldReturn
     * PURPOSE: When text field is done editing, resigns responder
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        return true
    }
    @IBAction func openImagesViewer(_ sender: Any)
    {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imagesViewer") as! ImagesViewerViewController
        popOverVC.port = self.port
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    @IBAction func openEditor(_ sender: Any)
    {
       // self.performSegue(withIdentifier: "mainToEditor", sender: (Any).self)
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageEditor") as! ImageEditorViewController
        popOverVC.currentImage = self.currentImage
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        popOverVC.onEditorClosed = onEditorClosed
    }
    func onEditorClosed(_ image: UIImage)
    {
        currentImage = image
        imageDisplayer.image = image
    }
    
    /*
     * FUNCTION: textFieldDidBeginEditing
     * PURPOSE: If text box editing is started, this function exceutes
     * PARAMS: textField -> UITextField object for senseing edit
     */
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        moveTextField(textField: messageField, moveDistance: -250, up: true)
    }
    /*
     * FUNCTION: textFieldDidEndEditing
     * PURPOSE: If text box editing is ended, this function exceutes
     * PARAMS: textField -> UITextField object for senseing edit
     */
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        moveTextField(textField: messageField, moveDistance: -250, up: false)
    }
    /*
     * FUNCTION: moveTextField
     * PURPOSE: Moves screen up so keyboard doesnt cover textbox at base of screen
     * PARAMS: textField -> textfield to be moved if touched
     *         moveDistance -> distance to move screen
     *         up -> true if screen should go up, false if screen should go down
     */
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool)
    {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    /*
     * FUNCTION: attatchMessage
     * PURPOSE: Adds a message to the preview and adds it to be sent on upload.
     */
    @IBAction func attatchMessage(_ sender: Any)
    {
        currentMessage = messageField.text!
        messageDisplayer.text = messageField.text
        messageField.text = ""
    }
    /*
     * FUNCTION: getPicture
     * PURPOSE: Opens camera and gallery options and temporarily stores selected image
     */
    @IBAction func getPicture(_ sender: Any)
    {
        CameraHandler.shared.showActionSheet(vc: self)
         CameraHandler.shared.imagePickedBlock = { (image) in
         self.imageDisplayer.image = image
         self.currentImage = image
         self.imageDisplayer.isHidden = false
         }
    }
    /*
     * FUNCTION: upload
     * PURPOSE: Sends the image and message to the database if an image is selected or calls warning popup if none is selected
     */
    @IBAction func upload(_ sender: Any)
    {
        if(imageDisplayer.image == nil)
        {
            print("No Image to upload")
            noImagePopUp()
        }
        else
        {
            print("Uploading image...")
            startActivity()
            //UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil)
            DispatchQueue.global().async {
                
                self.compressImage(image: self.currentImage)
                self.port.addImage(image: self.currentImage, message: self.currentMessage, macId: self.machineId)
                print("Added Image")
                
                DispatchQueue.main.async {
                    self.stopActivity()
                }
            }
            //UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil)
            imageDisplayer.image = nil
            messageDisplayer.text = ""
        }
    }
    func compressImage(image: UIImage)
    {
        if let imageData = image.jpeg(.low) {
            print(imageData.count, "Bytes")
            currentImage = UIImage(data: imageData)!
            //imageDisplayer.image = UIImage(data: imageData)
        }
    }
    /*
     * FUNCTION: noImagePopUp
     * PURPOSE: Displays a warning pop up
     */
    func noImagePopUp()
    {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "textPopUp") as! TextPopUpViewController
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    /*
     * FUNCTION: startActivity
     * PURPOSE: Shows the activity indicator and stops recording user touches.
     */
    func startActivity()
    {
        print("Activity Started")
        self.view.alpha = 0.5
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    /*
     * FUNCTION: stopActivity
     * PURPOSE: Hides the activity indicator and resumes responding to user touches
     */
    func stopActivity()
    {
        print("Activity Stoped")
        self.view.alpha = 1
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    /*
     * FUNCTION: showLoadingScreen
     * PURPOSE: Displays the loading view
     */
    func showLoadingScreen()
    {
        /*loadingView.isHidden = false
        loadingView.bounds.size.width = view.bounds.width
        loadingView.bounds.size.height = view.bounds.height
        loadingView.center = view.center
        loadingView.alpha = 1
        self.view.bringSubview(toFront: loadingView)
        self.view = loadingView
        print("Loading screen succeeded")*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FCtoBattery" {
            if let vc = segue.destination as? ImageEditorViewController {
                //vc.currentImage = self.currentImage
                //vc.imageDisplayer.image = self.imageDisplayer.image
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

