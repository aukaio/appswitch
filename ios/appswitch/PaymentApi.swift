//
//  PaymentApi.swift
//  appswitch
//
//  Created by Joachim Krüger on 20/11/2016.
//  Copyright © 2016 Joachim Krüger. All rights reserved.
//

import Foundation

class PaymentApi {

    static let sharedInstance = PaymentApi()

    // PRIVATES
    private let apiQueue: DispatchQueue
    private let baseUrl: String

    init() {
        guard let baseUrl = Bundle.main.infoDictionary!["ApiUrl"] as? String else {
            fatalError("\"ApiUrl\" is missing from Info.plist.")
        }

        self.baseUrl = baseUrl
        self.apiQueue = DispatchQueue(label: "queue.api",
                                      attributes: .concurrent)
    }

    func createPaymentRequest(_ callback: @escaping (Bool, AnyObject?)-> ()) {
        let url = URL(string: baseUrl)?
            .appendingPathComponent("payment")

        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
       
        self.executeRequest(request, completion: callback)
    }
    
    func getPaymentStatus(tid: String, callback: @escaping (Bool, AnyObject?) -> ()) {
        let url = URL(string: baseUrl)?
            .appendingPathComponent("payment")
            .appendingPathComponent(tid)

        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"

        self.executeRequest(request, completion: callback)
    }

    // PRIVATES
    private func executeRequest(_ request: URLRequest, completion: @escaping (Bool, AnyObject?) -> ()) {
        apiQueue.async { [unowned self] in
            URLSession.shared.dataTask(with: request, completionHandler: {
                self.handleDataTask(data: $0, response: $1, error: $2, completion: completion)
            }).resume()
        }
    }

    private func handleDataTask(data: Data?, response: URLResponse?, error: Error?, completion: (Bool, AnyObject?) -> ()) {
        if error != nil {
            completion(false, nil)
            return
        }

        guard let data = data else {
            completion(false, nil)
            return
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data)
            completion(true, json as AnyObject?)
        } catch _ {
            completion(false, nil)
        }
    }
}
