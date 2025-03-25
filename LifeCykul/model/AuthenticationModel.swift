//
//  AuthenticationModel.swift
//  LifeCykul
//
//  Created by Rishop Babu on 25/03/25.
//

import Foundation

struct OTPRequest: Encodable {
    let code: String
    let mobileNumber: String
    let type: String
}

struct LoginResponse: Codable {
    let resultStatus: String?
    let mobileNumber: String?
    let reportStatus: String?
    let reportStatusNew: String?
    let timer: String?
    let issuesList: [String]?
}
