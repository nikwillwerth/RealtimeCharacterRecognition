//
//  ViewController.swift
//  ML
//
//  Created by Nik Willwerth on 9/12/18.
//  Copyright © 2018 Nik Willwerth. All rights reserved.
//

import CoreML
import ImageIO
import UIKit
import Vision

class ViewController: UIViewController
{
    @IBOutlet weak var imageView: DrawableImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    private var model: VNCoreMLModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let thisModel = try? VNCoreMLModel(for: MNIST().model)
        {
            model = thisModel
            
            clearButton.addTarget(self, action: #selector(ViewController.onClearButtonPressed), for: .touchUpInside)
            
            imageView.setOnTouchesEnded
            {
                self.processImage(image: self.imageView!.image!)
            }
        }
    }
    
    func processImage(image: UIImage)
    {
        let ciImage = CIImage(image: image)!
        
        let request = VNCoreMLRequest(model: model)
        { [unowned self] request, error in
            //check results
            guard let results = request.results as? [VNClassificationObservation], let _ = results.first else
            {
                return
            }
            
            //show results on screen
            DispatchQueue.main.async
            { [unowned self] in
                if let first = results.first
                {
                    let label = first.identifier
                    
                    self.predictionLabel.text = "\(label)"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        DispatchQueue.global(qos: .userInteractive).async
        {
            do
            {
                //run model
                try handler.perform([request])
            }
            catch
            {
                print(error)
            }
        }
    }
    
    @objc func onClearButtonPressed()
    {
        imageView.clear()
        predictionLabel.text = ""
    }
}
