//
//  Employer.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 16/01/2024.
//

import Foundation

struct Employer: Codable {
  var discountPercentage: Int
  var employerID: Int
  var name: String
  var place: String
  
  private enum CodingKeys: String, CodingKey {
    case discountPercentage = "DiscountPercentage"
    case employerID = "EmployerID"
    case name = "Name"
    case place = "Place"
  }
}
