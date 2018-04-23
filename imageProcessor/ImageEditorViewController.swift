//
//  ImageEditorViewController.swift
//  imageProcessor
//
//  Created by Lauren Shultz on 4/18/18.
//  Copyright © 2018 Lauren Shultz. All rights reserved.
//

import UIKit
import SpriteKit
import CoreGraphics

class ImageEditorViewController: UIViewController, UIGestureRecognizerDelegate
{
    @IBOutlet var panner: UIPanGestureRecognizer!
    
    let tapAGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    let panAGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panning(_:)))

    
    @IBOutlet weak var freeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    var circleLayer: CAShapeLayer!
    var circlePth: UIBezierPath!
    var arrowLayer: CAShapeLayer!
    var currentImage = UIImage()
    var editedImage = UIImage()
    var freeDrawEnabled = false
    
    var selectedObject = UIImageView()
    
    var onEditorClosed: ((_ image: UIImage) -> ())?
    
    @IBOutlet weak var imageDisplayer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.isHidden = true
        editedImage = currentImage
        imageDisplayer.image = currentImage
    }
    
    @IBAction func done(_ sender: Any)
    {
        screenShot()
        onEditorClosed!(editedImage)
        self.view.removeFromSuperview()
    }
    func screenShot()
    {
        //Create the UIImage
        UIGraphicsBeginImageContext(imageDisplayer.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        editedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    @IBAction func addCircle(_ sender: Any)
    {
        imageCircle()
    }
    func imageCircle()
    {
        print("imageCircle()")
        //Add circle image
        let circleView = UIImageView()
        circleView.image = #imageLiteral(resourceName: "circle2")
        circleView.frame = CGRect(x: imageDisplayer.center.x, y: imageDisplayer.center.y, width: 100, height: 100)
        imageDisplayer.addSubview(circleView)
        imageDisplayer.bringSubview(toFront: circleView)
        
        addGestures(object: circleView)
    }
    @IBAction func addArrow(_ sender: Any)
    {
        imageArrow()
        
    }
    func imageArrow()
    {
        print("imageArrow()")
        let arrowView = UIImageView()
        arrowView.image = #imageLiteral(resourceName: "arrow2")
        arrowView.center = imageDisplayer.center
        arrowView.isUserInteractionEnabled = true
        arrowView.frame = CGRect(x: imageDisplayer.center.x, y: imageDisplayer.center.y, width: 100, height: 100)
        self.view.addSubview(arrowView)
        imageDisplayer.bringSubview(toFront: arrowView)
        
        addGestures(object: arrowView)
    }
    @IBAction func freeDraw(_ sender: Any)
    {
        if(freeDrawEnabled)
        {
            freeButton.setBackgroundImage(#imageLiteral(resourceName: "EmptyButton"), for: .normal)
            freeDrawEnabled = false
        }
        else
        {
            freeButton.setBackgroundImage(#imageLiteral(resourceName: "selectedButton2"), for: .normal)
            freeDrawEnabled = true
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches moved...")
        if(freeDrawEnabled)
        {
            let touch = touches.first
            let point = touch!.location(in: imageDisplayer)
            if(point.x > imageDisplayer.frame.minX && point.y > imageDisplayer.frame.minY && point.x < imageDisplayer.frame.maxX && point.y < imageDisplayer.frame.maxY)
            {
                
            
            let linePath = UIBezierPath()
            linePath.move(to: point)
            linePath.addLine(to: CGPoint(x: point.x + 1, y: point.y + 1))
            
            linePath.close()
            
            let line = CAShapeLayer()
            
            line.path = linePath.cgPath
            line.strokeColor = UIColor.red.cgColor
            line.lineWidth = 5
            
            //arrowLayer = arrow
            self.view.layer.addSublayer(line)
            }
        }
    }
    /*
     * FUNCTION: touchesBegan
     * PURPOSE: Is called when touch begins
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        print("touches began...")
        if(freeDrawEnabled)
        {
            let touch = touches.first
            let point = touch!.location(in: imageDisplayer)
            let linePath = UIBezierPath()
            linePath.move(to: point)
            linePath.addLine(to: CGPoint(x: point.x + 1, y: point.y + 1))
            
            linePath.close()
            
            let line = CAShapeLayer()
            
            line.path = linePath.cgPath
            line.strokeColor = UIColor.red.cgColor
            line.lineWidth = 5
            
            //arrowLayer = arrow
            self.view.layer.addSublayer(line)
        }
    }
    
    func addGestures(object: UIImageView)
    {
        let panGetter = UIPanGestureRecognizer(target: self, action: #selector(pan))
        object.addGestureRecognizer(panGetter)
        
        let tapGetter = UITapGestureRecognizer(target: self, action: #selector(tap))
        object.addGestureRecognizer(tapGetter)
        
        let pinchGetter = UITapGestureRecognizer(target: self, action: #selector(pinch))
        object.addGestureRecognizer(pinchGetter)
        
        let rotateGetter = UITapGestureRecognizer(target: self, action: #selector(rotate))
        object.addGestureRecognizer(rotateGetter)
        
        pinchGetter.require(toFail: tapGetter)
        pinchGetter.require(toFail: rotateGetter)
        tapGetter.require(toFail: pinchGetter)
        tapGetter.require(toFail: rotateGetter)
        rotateGetter.require(toFail: tapGetter)
        rotateGetter.require(toFail: pinchGetter)
        
        object.isUserInteractionEnabled = true
    }
    
    @IBAction func closeCurrentImage(_ sender: Any)
    {
        print("Closeing view...")
        selectedObject.removeFromSuperview()
        closeButton.isHidden = true
    }
    @objc func tap(sender: UITapGestureRecognizer)
    {
        print("Tapped...");
        selectedObject = sender.view as! UIImageView
        closeButton.center = CGPoint(x: (sender.view?.center.x)! + (sender.view?.frame.width)!/2, y: (sender.view?.center.y)! - (sender.view?.frame.height)!/2)
        if(closeButton.isHidden)
        {
            closeButton.isHidden = false
        }
        else
        {
            closeButton.isHidden = true
        }
    }
    @IBAction func tapped(_ sender: UITapGestureRecognizer)
    {
        print("Tapped...");
        selectedObject = sender.view as! UIImageView
        closeButton.center = CGPoint(x: (sender.view?.center.x)! + (sender.view?.frame.width)!/2, y: (sender.view?.center.y)! - (sender.view?.frame.height)!/2)
        if(closeButton.isHidden)
        {
            closeButton.isHidden = false
        }
        else
        {
            closeButton.isHidden = true
        }
    }
    @objc func pan(sender: UIPanGestureRecognizer)
    {
        print("Panning...");
        
        
        //else
        //{
            closeButton.isHidden = true
            if(sender.state == .began || sender.state == .changed)
            {
                let translation = sender.translation(in: sender.view)
                let changeX = (sender.view?.center.x)! + translation.x
                let changeY = (sender.view?.center.y)! + translation.y
                
                sender.view?.center = CGPoint(x: changeX, y: changeY)
                sender.setTranslation(CGPoint.zero, in: sender.view)
            }
        //}
    }
    @IBAction func panning(_ sender: UIPanGestureRecognizer)
    {
        print("Panning...");
        
        if(freeDrawEnabled)
        {
            let point = sender.translation(in: sender.view)
            let linePath = UIBezierPath()
            linePath.move(to: point)
            linePath.addLine(to: CGPoint(x: point.x + 1, y: point.y + 1))
            
            linePath.close()
            
            let line = CAShapeLayer()
            
            line.path = linePath.cgPath
            line.strokeColor = UIColor.red.cgColor
            line.lineWidth = 5
            
            //arrowLayer = arrow
            self.view.layer.addSublayer(line)
        }
        else
        {
        closeButton.isHidden = true
        if(sender.state == .began || sender.state == .changed)
        {
            let translation = sender.translation(in: sender.view)
            let changeX = (sender.view?.center.x)! + translation.x
            let changeY = (sender.view?.center.y)! + translation.y
            
            sender.view?.center = CGPoint(x: changeX, y: changeY)
            sender.setTranslation(CGPoint.zero, in: sender.view)
        }
        }
    }
    @IBAction func pinching(_ sender: UIPinchGestureRecognizer)
    {
        closeButton.isHidden = true
        if let sendView = sender.view {
        sendView.transform = sendView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
    @objc func pinch(sender: UIPinchGestureRecognizer)
    {
        closeButton.isHidden = true
        //if let sendView = sender.view {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
            sender.scale = 1
        //}
    }
    @objc func rotate(sender: UIRotationGestureRecognizer)
    {
        closeButton.isHidden = true
        if let sendView = sender.view {
            sendView.transform = sendView.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    @IBAction func rotateing(_ sender: UIRotationGestureRecognizer)
    {
        closeButton.isHidden = true
        if let sendView = sender.view {
        sendView.transform = sendView.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FCtoBattery" {
            if let vc = segue.destination as? ViewController {
                //vc.imageDisplayer.image = self.imageDisplayer.image
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
