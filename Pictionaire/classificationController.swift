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
import ROGoogleTranslate


class classificationController: UIViewController, ARSCNViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource/*UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout*/{



    @IBOutlet weak var sceneView: ARSCNView! // displays view of live camera feed where objs will be displayed
    
    @IBOutlet weak var flagLang: UIImageView!
    var availLangs = ["Chinese", "Danish", "German", "Hindi", "Spanish"]
    
    @IBOutlet weak var leftTopBar: UIView!
    @IBOutlet weak var midTopBar: UIView!
    @IBOutlet weak var rightTopBar: UIView!
    
    //
    var textToTranslate = TheOneAndOnlyObservation.sharedInstance.observation1
  
    var fromLang = "en"
    var toLang = "es"
    var translatedText = ""
    
    
    // Updating UI elements with top 2 predictions:
    @IBOutlet weak var firstPredictionButton: UIButton!
    @IBOutlet weak var firstPredictionConfidenceLabel: UILabel!
    
    @IBOutlet weak var secondPredictionButton: UIButton!
    @IBOutlet weak var secondPredictionConfidenceLabel: UILabel!
    
    // Prediction Buttons Clicked:
    @IBAction func firstPredictionButtonClicked(_ sender: UIButton) {
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~\(textToTranslate)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        translationReq(firstPredictionButton)
    }
    
    @IBAction func secondPredictionButtonClicked(_ sender: UIButton) {
        translationReq(secondPredictionButton)
    }
    
    
    
    func translationReq(_ predictionButton: UIButton) {
        
        let params = ROGoogleTranslateParams(source: fromLang,
                                             target: toLang,
                                             text:   (predictionButton.titleLabel?.text)!)
        
        let translator = ROGoogleTranslate()
        
        translator.translate(params: params) { (result) in
            DispatchQueue.main.async {
                self.translatedText = "\(result)"
                self.calculationTextView.text = "\(result)"
            }
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availLangs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let item1 = availLangs[pickerView.selectedRow(inComponent: 0)]
       // var item2 = availLangs[1][pickerView.selectedRow(inComponent: 1)]

        
        let chinese = UIImage(named: "chinese.png")
        let danish = UIImage(named: "danish.png")
        let german = UIImage(named: "german.png")
        let hindi = UIImage(named: "india.png")
        let spanish = UIImage(named: "spanish.png")
        
        switch item1 {
        case "Chinese":
            flagLang.image = chinese
        case "Danish":
            flagLang.image = danish
        case "German":
            flagLang.image = german
        case "Hindi":
            flagLang.image = hindi
        case "Spanish":
            flagLang.image = spanish
        default:
            flagLang.image = hindi
        }
        
        
    }
    
    
    
    
    /*
    func picker() {
        let flagPicker = UIPickerView()
        flagPicker.delegate = self

    }
    
    
    var flagImgArr: [UIImage] = [UIImage(named: "chinese")!, UIImage(named: "danish")!, UIImage(named: "india")!, UIImage(named: "german")!, UIImage(named: "spanish")!  ]
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 140
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        

        var myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 60))
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        
        var rowString = String ()
        
        switch row {
            
        case 0:
            rowString = "Chinese"
            myImageView.image = #imageLiteral(resourceName: "chinese")
                //UIImage(named: "chinese")
        case 1:
            rowString = "Danish"
            myImageView.image = #imageLiteral(resourceName: "danish")
        case 2:
            rowString = "Hindi"
            myImageView.image = #imageLiteral(resourceName: "india")
        case 3:
            rowString = "German"
            myImageView.image = #imageLiteral(resourceName: "german")
        case 4:
            rowString = "Spanish"
            myImageView.image = #imageLiteral(resourceName: "spanish")
        default: rowString = "error"
            myImageView.image = nil
            
        }
        
        
        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60))
      //  myLabel.font = UIFont(name:some font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
        
    }
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        <#code#>
    }
 */
    
    
    
    
    
    
    //let arTextDepth: Float = 0.01 // 3D text's depth
    var latestPrediction: String = "Calculating..." // var holding most recent ML prediction
    
    var visionRequests = [VNCoreMLRequest]() // or try [VNRequest] ?
    let dispatchQueueML = DispatchQueue(label: "coreml.dispatchqueue")
    var configuration: ARWorldTrackingConfiguration!
    
    // COLOR SCHEMES
    let skyBlueColor = UIColor(red: 124.0/255.0, green: 200.0/255.0, blue: 239.0/255.0, alpha: 0.7)
    let blueColor = UIColor(red: 56.0/255.0, green: 145.0/255.0, blue: 233.0/255.0, alpha: 0.8)
    let grayColor = UIColor(red: 83.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 0.75)

    
    
    
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
        

        

//        let skyBlueColor = UIColor(red: 124.0/255.0, green: 200.0/255.0, blue: 239.0/255.0, alpha: 0.7)
//        let blueColor = UIColor(red: 56.0/255.0, green: 145.0/255.0, blue: 233.0/255.0, alpha: 0.4)
//        let blackColor = UIColor(red: 83.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 0.75)
//
//        topBar.backgroundColor = skyBlueColor
//        topBar.layer.cornerRadius = 6.0
//
//
//        topBar.layer.shadowColor = UIColor.black.cgColor
//        topBar.layer.shadowOffset = CGSize(width: 0, height: 10)
//        topBar.layer.shadowOpacity = 0.5
//        topBar.layer.shadowRadius = 5
//        topBar.clipsToBounds = false
//        topBar.layer.masksToBounds = false
        
        
        
//        enum Colors {
//            case skyBlueCor
//        }

            

        //translationReq()
        
        
//
//
//
//        bar.backgroundColor = skyBlueColor
        
        
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
        
        
        // TOP BAR COLOR & DESIGN EDITS
        leftTopBar.backgroundColor = skyBlueColor
        midTopBar.backgroundColor = blueColor
        rightTopBar.backgroundColor = skyBlueColor
        // !: result of call unused?
        shadowEdits(leftTopBar)
        shadowEdits(midTopBar)
        shadowEdits(rightTopBar)
        


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
            
            let predictOne = classifications[0].identifier
            let confidenceOneDouble = Double((classifications[0].confidence)*100).rounded(toPlaces: 2)
            let confidenceOneString = String(confidenceOneDouble)
            let predictTwo = classifications[1].identifier
            let confidenceTwoDouble = Double((classifications[1].confidence)*100).rounded(toPlaces: 2)
            let confidenceTwoString = String(confidenceTwoDouble)
            
            TheOneAndOnlyObservation.sharedInstance.observation1 = predictOne
            TheTwoAndOnlyObservation.sharedInstance.observation2 = predictTwo
            
            
            
            // set cell 1's observation button to classifications[0].identifier =============
          //  self.calculationTextView.text = classifications[0].identifier
            
            self.firstPredictionButton.setTitle(predictOne, for: .normal)
            self.firstPredictionConfidenceLabel.text = "\(confidenceOneString)%"
            
            self.secondPredictionButton.setTitle(predictTwo, for: .normal)
            self.secondPredictionConfidenceLabel.text = "\(confidenceTwoString)%"
            
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
    
    
    func shadowEdits (_ bar: UIView) /*-> UIView*/ {
        
        bar.layer.cornerRadius = 6.0
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize(width: 6, height: 10)
        bar.layer.shadowOpacity = 0.5
        bar.layer.shadowRadius = 5
        bar.clipsToBounds = false
        bar.layer.masksToBounds = false
        
      //  return bar
        
    }
    
   /*
    func viewBackgroundColor (_ yourView: UIView, _ theColor: String) {
        
        let skyBlueColor = UIColor(red: 124.0/255.0, green: 200.0/255.0, blue: 239.0/255.0, alpha: 0.7)
        let blueColor = UIColor(red: 56.0/255.0, green: 145.0/255.0, blue: 233.0/255.0, alpha: 0.4)
        let blackColor = UIColor(red: 83.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 0.75)
        
        
        yourView.backgroundColor = desiredColor
        
        
    }
    */
    
    
    
    
    

    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    // no other class should have access to menu bar
    private func setUpMenuBar() {
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuBar)
       // menuBar.alpha = 1.0
        

        
        
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

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
        
        
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
