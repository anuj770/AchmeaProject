//
//  DataBaseService.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 16/01/2024.
//

import Foundation
import CoreData

protocol CDRepository{
  func deleteEmployers(withQuery query: String)
  func createRecords(record: EmployersData)
  func fetchEmployers(forQuery query: String, time: Date?) -> [Employer]
}

class CDEmployerRepository:CDRepository{
  
  // MARK: - Properties
  let coreDataStack: Persistence
  
  // MARK: - Initializers
  init(coreDataStack: Persistence = Persistence()) {
    self.coreDataStack = coreDataStack
  }
  
  func createRecords(record: EmployersData){
    debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    print("Records saved in local DB")
    if let employers = record.employers {
      employers.forEach{ employer in
        self.saveEmployer(record: employer, query: record.query, time: record.time)
      }
    }
  }
  
  func saveEmployer(record: Employer, query: String?, time: Date?){
    let context = Persistence.shared.mainContext
    if let employers = NSEntityDescription.insertNewObject(forEntityName: "Employers", into: context) as? Employers {
      
      employers.time = time
      employers.query = query
      employers.name = record.name
      employers.place = record.place
      if let descount = record.discountPercentage {
        employers.discountPercentage = Int64(descount)
      }
      if let employerID = record.employerID {
        employers.employerID = Int64(employerID)
      }
      context.performAndWait{
        context.insert(employers)
        Persistence.shared.saveContext(context:context)
      }
    }
  }
  
  func fetchEmployers(forQuery query: String, time: Date?) -> [Employer] {
    
    let context = Persistence.shared.mainContext
    let fetchRequest: NSFetchRequest<Employers> = Employers.fetchRequest()
    
    if let time = time {
      fetchRequest.predicate = NSPredicate(format: "query == %@ AND time >= %@", query, time as CVarArg)
    } else {
      fetchRequest.predicate = NSPredicate(format: "query == %@", query)
    }
    
    do {
      let matchingEmployers = try context.fetch(fetchRequest)
      var employerList: [Employer] = []
      matchingEmployers.forEach{ cdEmployer in
        let employer = Employer(
          discountPercentage: Int(cdEmployer.discountPercentage),
          employerID: Int(cdEmployer.employerID),
          name: cdEmployer.name,
          place: cdEmployer.place
        )
        employerList.append(employer)
      }
      return employerList
    } catch {
      print("Error fetching employers: \(error)")
      return []
    }
  }
  
  func deleteEmployers(withQuery query: String) {
    let context = Persistence.shared.mainContext
    let fetchRequest: NSFetchRequest<Employers> = Employers.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "query == %@", query)
    do {
      let matchingEmployers = try context.fetch(fetchRequest)
      for employer in matchingEmployers {
        context.delete(employer)
      }
      try context.save()
    } catch {
      print("Error deleting employers: \(error)")
    }
  }
}

extension Employers {
  func toSwiftObject() -> Employer {
    return Employer(
      discountPercentage: Int(self.discountPercentage),
      employerID: Int(self.employerID),
      name: self.name,
      place: self.place
    )
  }
}

