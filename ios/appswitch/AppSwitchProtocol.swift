//
//  AppSwitchProtocol.swift
//  appswitch
//
//  Created by Theodor Skippervold on 07.02.2017.
//  Copyright © 2017 Joachim Krüger. All rights reserved.
//

import Foundation

enum AppSwitchResult: String {
    case success = "AppSwitchSuccess"
    case failure = "AppSwitchFailure"
}

protocol AppSwitchProtocol {
    func handlePaymentSuccess()
    func handlePaymentFailure()
}
