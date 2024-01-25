//
//  EmployerRowView.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 25/01/2024.
//

import Foundation
import SwiftUI

struct EmployerRowView: View {
  let employer: Employer
  
  var body: some View {
    
    VStack(alignment: .leading, spacing: 4) {
      Text(employer.name ?? "")
        .font(.headline)
      HStack {
        Image(systemName: "mappin.circle.fill")
          .foregroundColor(.blue)
          .frame(width: 24, height: 24)
        Text(employer.place ?? "")
          .font(.subheadline)
      }
      if let discount = employer.discountPercentage {
        Text("Discount Value: " + String(discount))
          .font(.subheadline)
      }
    }
    .padding()
  }
}



#Preview {  
  EmployerRowView(employer: .init(discountPercentage: 12, employerID: 122, name: "abc", place: "alpha"))
}
