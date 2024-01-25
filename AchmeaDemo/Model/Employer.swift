//
//  Employer.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 16/01/2024.
//

import Foundation
import SwiftUI


struct EmployersData: Codable {
  let time: Date?
  let query: String?
  let employers: [Employer]?
}

struct Employer: Codable, Identifiable, Equatable {
  let discountPercentage: Int?
  let employerID: Int?
  let name: String?
  let place: String?
  
  enum CodingKeys: String, CodingKey {
    case discountPercentage = "DiscountPercentage"
    case employerID = "EmployerID"
    case name = "Name"
    case place = "Place"
  }
  
  var id: Int? {
    return employerID
  }
  
  init(discountPercentage: Int?, employerID: Int?, name: String?, place: String?) {
    self.discountPercentage = discountPercentage
    self.employerID = employerID
    self.name = name
    self.place = place
  }
  
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    discountPercentage = try values.decodeIfPresent(Int.self, forKey: .discountPercentage)
    employerID = try values.decodeIfPresent(Int.self, forKey: .employerID)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    place = try values.decodeIfPresent(String.self, forKey: .place)
  }
  
  static func == (lhs: Employer, rhs: Employer) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
  }
}
