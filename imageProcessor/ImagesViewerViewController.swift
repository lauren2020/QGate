//
//  ImagesViewerViewController.swift
//  imageProcessor
//
//  Created by Lauren Shultz on 4/20/18.
//  Copyright © 2018 Lauren Shultz. All rights reserved.
//

import UIKit

class ImagesViewerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
  
    var port: Port!
    var images = [Image]()
    var machines = [Machine]()
    var machine: Machine!
    var image: Image!
    @IBOutlet weak var machinesPicker: UIPickerView!
    @IBOutlet weak var imagesPicker: UIPickerView!
    @IBOutlet weak var imageDisplayer: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagesPicker.delegate = self
        machinesPicker.delegate = self
        
        imagesPicker.reloadAllComponents()
        
        loadMachines()
        
        // Do any additional setup after loading the view.
    }
    
    func loadMachines()
    {
        machines = port.getMachines()
        if(machines.count != 0)
        {
            machine = machines[0]
        }
        machinesPicker.reloadAllComponents()
        loadImages()
    }
    func loadImages()
    {
        images = machine.images
        if(images.count != 0)
        {
            image = images[0]
            imageDisplayer.image = image.picture
        }
        imagesPicker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        var count = 0;
        if(pickerView == machinesPicker)
        {
            count = machines.count
        }
        else
        {
            count = images.count
        }
        return count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let rowLabel = UILabel()
        if(pickerView == machinesPicker)
        {
            rowLabel.adjustsFontSizeToFitWidth = true
            rowLabel.text = machines[row].machineId
        }
        else
        {
            rowLabel.adjustsFontSizeToFitWidth = true
            rowLabel.text = images[row].message
        }
        return rowLabel
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView == machinesPicker)
        {
        if(machines.count != 0)
        {
            machine = machines[row]
            loadImages()
        }
        }
        else
        {
            if(images.count != 0)
            {
                image = images[row]
                if(machine.images.count != 0)
                {
                    print("Image found")
                    imageDisplayer.image = image.picture
                }
                else
                {
                    print("no identifier found")
                    imageDisplayer.image = nil
                }
            }
        }
    }
    
    
    @IBAction func deleteImage(_ sender: Any)
    {
    }
    @IBAction func done(_ sender: Any)
    {
        self.view.removeFromSuperview()
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
