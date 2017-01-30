//
//  PaymentApi.swift
//  appswitch
//
//  Created by Joachim Krüger on 20/11/2016.
//  Copyright © 2016 Joachim Krüger. All rights reserved.
//

import Foundation

class PaymentApi{
    static let sharedInstance = PaymentApi()
    
    let BASE_URL = "https://dec215fa.ngrok.io"
    
    func createPaymentRequest(callback: @escaping (Bool, AnyObject?)-> ()){
        // Create payment request, return payment id
    
        let urlPath = BASE_URL + "/payment"
        var request: URLRequest = URLRequest(url: URL(string: urlPath)!)
        request.httpMethod = "GET"
       
        execTask(request: request, callback: callback)
    }
    
    func getPaymentStatus(tid: String, callback: @escaping (Bool, AnyObject?)-> ()) {
        let urlPath = BASE_URL + "/payment/"+tid
        var request: URLRequest = URLRequest(url: URL(string: urlPath)!)
        request.httpMethod = "GET"
        execTask(request: request, callback: callback)
    }
    
    private func execTask(request: URLRequest, callback: @escaping (Bool, AnyObject?) -> ()) {
        
        let session = URLSession.shared
        
        session.dataTask(with: request) {(data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    callback(true, json as AnyObject?)
                } else {
                    callback(false, json as AnyObject?)
                }
            }
            }.resume()
    }
}
