//
//  ViewController.swift
//  Pictionaire
//
//  Created by Abhi Singh on 12/4/17.
//  Copyright © 2017 Abhi Singh. All rights reserved.
//

import UIKit
import SceneKit // used for developing 3D objs
import ARKit // used for placing those 3D objs into real-world surroundings
import Vision

class classificationController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView! // displays view of live camera feed where objs will be displayed
    
    let arTextDepth: Float = 0.01 // 3D text's depth
    var latestPrediction: String = "Calculating..." // var holding most recent ML prediction
    
    var visionRequests = [VNCoreMLRequest]() // or try [VNRequest] ?
    let dispatchQueueML = DispatchQueue(label: "coreml.dispatchqueue")
    var configuration: ARWorldTrackingConfiguration!
    

    @IBOutlet weak var calculationTextView: UITextView!

    // reminder: update shitty logic for toggling sesh - pause/resume
    // boolean enum cases?
    var counter = 0
    @IBAction func selectButtonWasClicked(_ sender: UIButton) {
        counter += 1
        if counter % 2 != 0 {
            selectButton.flash()
            selectButton.rotation()
            sceneView.session.pause()
        } else {
            selectButton.quickPulse()
            sceneView.session.run(configuration)
        }
    }
    
    @IBOutlet weak var selectButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set the view's delegate
        sceneView.delegate = self
        
        // (don't) show statistics such as fps & timing information at bottom
        sceneView.showsStatistics = true
        
        
        // instantiate a new session
        let scene = SCNScene()
        
        // set scene to the sceneView
        sceneView.scene = scene

        
        //////////////////////////////////////////////////
        // Tap Gesture Recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
//        view.addGestureRecognizer(tapGesture)
        // need to make func
        //////////////////////////////////////////////////
        
        // Model Set-Up
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            fatalError("Error: model could not be loaded.")
        }


        let classificationRequest = VNCoreMLRequest(model: model, completionHandler: classificationCompleteHandler)
       // classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // crop from centre of images and scale
        visionRequests = [classificationRequest]
        
        
//        ARText Stuff:
//        let text = SCNText(string: "testing", extrusionDepth: 0.5) // text to be displayed
//
//        let material = SCNMaterial() // instantiating material obj
//        material.diffuse.contents = UIColor.blue // diffuse = base material of obj
//        text.materials = [material] // needs array of [material] b/c can assign multiple materials to obj (can change diffuse, metallicness, texture, etc.)
        
        selectButton.loadPulse()
        
        loopCoreMLUpdate()
        
        setUpMenuBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkForSupport()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // FUNCTIONS:
    
    // checks for device compatibility
    func checkForSupport () {
        if ARWorldTrackingConfiguration.isSupported {
            print("This device is compatible.")
            
            // Create a ARWTC session config
            // ARWTC: config that uses the rear cam, tracks device's orientation & position, & detects real-world flat surfaces
            configuration = ARWorldTrackingConfiguration()
            // Enable plane detection
            configuration.planeDetection = .horizontal
            
            // Run the view's session
            sceneView.session.run(configuration)
        } else {
            print ("This device is incompatible.")
            
            // possibly throw alert about unsupported device (no A9 chip)?
            // perhaps set logic to use AROrientationTrackingConfiguration (CHECK IF THIS WORKS_
            let configuration = AROrientationTrackingConfiguration()
            // AROTC has no plane detection property
            
            // Run the view's session
            sceneView.session.run(configuration)
        }
    }
    


    // continuously run CoreML
    func loopCoreMLUpdate() {
        
        dispatchQueueML.async {
            // DispatchQueue.global(qos: .background).async { // runs async background
            
            // update
            self.updateCoreML()
            
            // loop
            self.loopCoreMLUpdate()
        }
        
    }
    
    
    // completionHandler from viewDidLoad classificationRequest
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let results = request.results else {
            print("No results")
            return
        }
    
        // obtain classifications
        let classifications = results[0...1] // top 2 results
            .flatMap({ $0 as? VNClassificationObservation }) // transform contents of an array of arrays -> linear array
            // .map({"\n\($0.identifier) \(String(format:"- %.2f", $0.confidence * 100))%" })
            // .joined(separator: "\n")
            // ^ don't need above code b/c need individual classifications' properties

        DispatchQueue.main.async {
            // Print Classifications
            print(classifications)
            print("--")

            // set cell 1's observation button to classifications[0].identifier =============
            self.calculationTextView.text = classifications[0].identifier
            // set cell 1's confidence label to classifications[0].confidence * convert properly
            
        }
    }
    
    
    
    func updateCoreML() {
        // camera img as RGB
        let pixbuff: CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        // note1: not sure if ciImage is being interpreted as RGB, but for now works w/ the Inception/Resnet model
        // note2: uncertain if pixelBuffer should be rotated before handing off to Vision (VNImageRequestHandler) - works for now
        
        // prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        // Run Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
        
    }
    

    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    // no other class should have access to menu bar
    private func setUpMenuBar() {
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuBar)
        
        
        let menuBarHorizontalConstraint = NSLayoutConstraint(item: menuBar, attribute: NSLayoutAttribute.trailing , relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        let menuBarVerticalConstraint = NSLayoutConstraint(item: menuBar, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        let menuBarTopConstraint = NSLayoutConstraint(item: menuBar, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)

        
        let menuBarWidthConstraint = NSLayoutConstraint(item: menuBar, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 375)
        
        let menuBarHeightConstraint = NSLayoutConstraint(item: menuBar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 122)
        
        NSLayoutConstraint.activate([menuBarHorizontalConstraint, menuBarVerticalConstraint, menuBarTopConstraint, menuBarWidthConstraint, menuBarHeightConstraint])

        
        
    }
    
    
    
    
    
    
    
    
    
    

    
   // ARKIT
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
