//
//  ViewController.swift
//  QRReader
//
//  Created by Darshan Sk on 3/17/19.
//  Copyright © 2019 Darshan Sk. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            let input = try AVCaptureDeviceInput(device: (captureDevice!))
            session.addInput(input)
        }
        catch{
            print("error")
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [ AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.ean8 ]
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(square)
        session.startRunning()
    
        
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    let alert = UIAlertController(title: "Barcode", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                    UIPasteboard.general.string = object.stringValue
                }))
                    
                present(alert,animated: true,completion: nil )
                }
            }
        }
    }

}

