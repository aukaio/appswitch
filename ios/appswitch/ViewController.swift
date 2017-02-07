//
//  ViewController.swift
//  appswitch
//
//  Created by Joachim Krüger on 20/11/2016.
//  Copyright © 2016 Joachim Krüger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AppSwitchProtocol {

    var tid: String = ""
    
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textview.text = ""
        self.spinner.hidesWhenStopped = true

        // Map possible app switch results to protocol functions
        [AppSwitchResult.success: #selector(ViewController.handlePaymentSuccess),
         AppSwitchResult.failure: #selector(ViewController.handlePaymentFailure)
        ].forEach {
            NotificationCenter.default.addObserver(self,
                                                selector: $0.value,
                                                name: Notification.Name($0.key.rawValue),
                                                object: nil)
        }
    }

    // APP SWITCH PROTOCOL FUNCTIONS
    func handlePaymentSuccess() {
        self.textview.text.append("\n  3. Appswitch with mCash payment successful")
        self.getPaymentStatus()
    }

    func handlePaymentFailure() {
        self.textview.text.append("\n  3. Appswitch with mCash payment failed")
    }

    @IBAction func onClick(_ sender: Any) {
        self.createPaymentRequest()
    }
    
    func showError(message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: "Error", message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    // MCASH CALLS
    func createPaymentRequest() {
        self.checkoutButton.isHidden = true
        self.textview.text = "\n Results: \n\n  1. Sending createPayment request ..."
        self.spinner.startAnimating()
        
        PaymentApi.sharedInstance.createPaymentRequest { [weak self] (success, data) in
            DispatchQueue.main.async {
                self?.handlePaymentRequest(success: success, json: data as? [String: AnyObject])
            }
        }
    }
    
    func getPaymentStatus() {
        self.textview.text.append("\n  4. Fetching payment status from mCash ...")
        self.spinner.startAnimating()

        PaymentApi.sharedInstance.getPaymentStatus(tid: self.tid, callback: {(success, json) in
            DispatchQueue.main.async {
                if success, let data = json as? [String: AnyObject]{
                    self.textview.text.append("\n  5. Success fetching payment status\n\n Response:\n\n")
                    self.textview.text.append("{ \n")
                    for (key, val) in data {
                        self.textview.text.append("   " + key + ":" + val.description + "\n")
                    }
                    self.textview.text.append("}")
                    
                }else{
                    self.textview.text.append("\n  5. Error fetching payment status")
                }
                self.spinner.stopAnimating()
            }
        })
        
    }

    func handlePaymentRequest(success: Bool, json: [String: AnyObject]?) {
        if success, let data = json {
            self.tid = data["id"] as! String
            self.textview.text.append("\n  2. Got transaction id (tid): " + self.tid)
            self.openMcash(uri: "mcash://qr?code=http://mca.sh/p/" + self.tid + "/&success_uri=appswitch://success&failure_uri=appswitch://failure")
        } else {
            self.showError(message: "Create payment failed",
                           action: UIAlertAction(title: "OK",
                                                 style: UIAlertActionStyle.default))
        }

        self.spinner.stopAnimating()
    }

    func openMcash(uri: String) {
        if let url = URL(string: uri), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            return
        }

        self.textview.text.append("\n  3. AppSwitch failure, mCash testbed app not found on device ...")
        self.showError(message: "AppSwitch failed. No mCash app available",
                       action: UIAlertAction(title: "OK",
                                             style: UIAlertActionStyle.destructive))
    }
}

