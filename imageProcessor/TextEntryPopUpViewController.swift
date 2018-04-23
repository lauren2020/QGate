//
//  TextEntryPopUpViewController.swift
//  imageProcessor
//
//  Created by Lauren Shultz on 4/23/18.
//  Copyright © 2018 Lauren Shultz. All rights reserved.
//

import UIKit

class TextEntryPopUpViewController: UIViewController
{
    var titleIn = "Enter Name:"
    var returnType = 0
    var setUser: ((_ nameIn: String) -> ())?
    var setMachine: ((_ macNameIn: String) -> ())?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    @IBAction func close(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    @IBAction func submit(_ sender: Any)
    {
        if(returnType == 0)
        {
            setUser!(textBox.text!)
        }
        else
        {
            setMachine!(textBox.text!)
        }
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
