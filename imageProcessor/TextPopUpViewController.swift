//
//  TextPopUpViewController.swift
//  imageProcessor
//
//  Created by Lauren Shultz on 4/18/18.
//  Copyright © 2018 Lauren Shultz. All rights reserved.
//

import UIKit

class TextPopUpViewController: UIViewController
{

    @IBOutlet weak var messageBox: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    @IBAction func returnToMain(_ sender: Any)
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
