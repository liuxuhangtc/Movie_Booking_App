//
//  DBManager.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/3/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation
import CoreData


class DBManager {
    
    private static let instance = DBManager()
    
    ///
    public static var `default`: DBManager {
        return instance
    }
    
    let movieEntity = "Movie"
    let customerEntity = "Customer"
    let bookingEntity = "Booking"

    public lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.mangerModel)
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: "db.sqlite", relativeTo: dirURL)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: fileURL, options: nil)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }
        return coordinator
    }()
    
    public lazy var mangerModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "MovieBooking", withExtension: "momd") else {
            fatalError("load db failed")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("load db failed")
        }
        return model
    }()
    
    
    func checkDefaultMovies() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        do {
            let result = try context.fetch(request) as! [Movie]
            if result.count > 0 , let name = result[0].title, name == "IRON MAN" {
                return
            } else {
                [("IRON MAN", "PG", 50, "2016-02-27", ""), ("SPIDER MAN", "PG-13", 150, "2012-06-02", ""),
                 ("SUPER MAN", "PG-13", 250, "2014-05-01", "")].forEach({
                    addMovie($0.0, type: $0.1, quantity: $0.2, m_release: $0.3, cover: $0.4)
                    
                 })
            }
        } catch {
            print(error)
        }
    }
    
    func getMovies(_ title: String? = nil, filter: Bool = false) -> [Movie] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        if let t = title {
            let predicate = NSPredicate.init(format: "title \(filter ? "CONTAINS": "=") %@ ", t)
            request.predicate = predicate
        }
        do {
            let result = try context.fetch(request) as! [Movie]
            print(result)
            print(context.registeredObjects)
            return result
        } catch {
            print(error)
            return []
        }
        
    }
    
    
    func addMovie(_ title: String, type: String, quantity: Int, m_release: String, cover: String) {
        let entity = NSEntityDescription.entity(forEntityName: movieEntity, in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(title, forKey: "title")
        object.setValue(type, forKey: "type")
        object.setValue(quantity, forKey: "quantity")
        object.setValue(m_release, forKey: "m_release")
        object.setValue(cover, forKey: "cover")
        do {   //Save the object
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("Error:\(nserror),\(nserror.userInfo)")
        }
    }
    
    func deleteMovie(_ title: String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        let predicate = NSPredicate.init(format: "title = %@ ", title)
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            result.forEach({ (person) in
                context.delete(person as! NSManagedObject)
            })
            print(context.deletedObjects)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    func updateMovie(_ movie: Movie) {
        do {
            let object = context.object(with: movie.objectID) as! Movie
            object.title = movie.title
            object.type = movie.type
            object.quantity = Int16(movie.quantity)
            object.m_release = movie.m_release
            object.cover = movie.cover
            
            print(context.updatedObjects)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    func updateMovie(_ title: String, type: String, quantity: Int, m_release: String, cover: String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        let predicate = NSPredicate.init(format: "title = %@ ", title)
        request.predicate = predicate
        do {
            let result = try context.fetch(request) as! [Movie]
            result.forEach({ (object) in
                object.type = type
                object.quantity = Int16(quantity)
                object.m_release = m_release
                object.cover = cover
                
            })
            
            print(context.updatedObjects)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Cus
    
    func checkDefaultCustomers() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: customerEntity)
        do {
            let result = try context.fetch(request) as! [Customer]
            if result.count > 0 , let name = result[0].name, name == "JERRY" {
                return
            } else {
                [("JERRY", 22, "jerry@gmail.com", "123 St"), ("BOBO", 34, "bobo@gmail.com", "349 Tomma Blvd"),
                 ("JULIA", 42, "julia@gmail.com", "482 St")].forEach({addCustomer($0.0, age: $0.1, email: $0.2, address: $0.3)})
            }
        } catch {
            print(error)
        }
    }

    func getCustomers(_ name: String? = nil, filter: Bool = false) -> [Customer] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: customerEntity)
        if let t = name {
            let predicate = NSPredicate.init(format: "name \(filter ? "CONTAINS": "=") %@ ", t)
            request.predicate = predicate
        }
        do {
            let result = try context.fetch(request) as! [Customer]
            print(result)
            print(context.registeredObjects)
            return result
        } catch {
            print(error)
            return []
        }
        
    }
    
    func addCustomer(_ name: String, age: Int, email: String, address: String) {
        let entity = NSEntityDescription.entity(forEntityName: customerEntity, in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(name, forKey: "name")
        object.setValue(age, forKey: "age")
        object.setValue(email, forKey: "email")
        object.setValue(address, forKey: "address")
        do {   //Save the object
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("Error:\(nserror),\(nserror.userInfo)")
        }
    }
    
    func deleteCustomer(_ name: String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: customerEntity)
        let predicate = NSPredicate.init(format: "name = %@ ", name)
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            result.forEach({ (person) in
                context.delete(person as! NSManagedObject)
            })
            print(context.deletedObjects)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    func updateCustomer(_ cus: Customer) {
        do {
            let person = context.object(with: cus.objectID) as! Customer
            
                person.name = cus.name
                person.age = Int16(cus.age)
                person.email = cus.email
                person.address = cus.address
            
            print(context.updatedObjects)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    func updateCustomer2(_ name: String, age: Int, email: String, address: String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: customerEntity)
        let predicate = NSPredicate.init(format: "name = %@ ", name)
        request.predicate = predicate
        do {
            let result = try context.fetch(request) as! [Customer]
            result.forEach({ (person) in
                person.age = Int16(age)
                person.email = email
                person.address = address
                
            })
            
            print(context.updatedObjects)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error)
        }
    }

    // MARK: - Booking
    
    func getBooking(_ str: String? = nil, filter: Bool = false) -> [Booking] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: bookingEntity)
        if let t = str {
            let predicate = NSPredicate.init(format: "movie.title \(filter ? "CONTAINS": "=") %@ or customer.name \(filter ? "CONTAINS": "=") %@ ", t, t)
            request.predicate = predicate
        }
        do {
            let result = try context.fetch(request) as! [Booking]
            print(result)
            print(context.registeredObjects)
            return result
        } catch {
            print(error)
            return []
        }
        
    }
    
    func addBooking(_ movie: Movie, customer: Customer, number: Int, start: String, end: String) {
        let entity = NSEntityDescription.entity(forEntityName: bookingEntity, in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(movie, forKey: "movie")
        object.setValue(customer, forKey: "customer")
        object.setValue(number, forKey: "number")
        object.setValue(start, forKey: "startDate")
        object.setValue(end, forKey: "endDate")
        do {   //Save the object
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("Error:\(nserror),\(nserror.userInfo)")
        }
    }
    
    func deleteBooking(_ booking: Booking) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: bookingEntity)
        let predicate = NSPredicate.init(format: "movie = %@ and customer = %@ ", booking.customer!)
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            result.forEach({ (person) in
                context.delete(person as! NSManagedObject)
            })
            print(context.deletedObjects)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    func updateBooking(_ booking: Booking) {
        do {
            let person = context.object(with: booking.objectID) as! Booking
            
                person.movie = booking.movie
                person.customer = booking.customer
                person.number = Int16(booking.number)
                person.startDate = booking.startDate
                person.endDate = booking.endDate
            
            print(context.updatedObjects)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    /// Calculate the order quantity
    func getBookingQuantity(_ movie: Movie) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: bookingEntity)
        
        let predicate = NSPredicate.init(format: "movie.title = %@ ", movie.title!)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request) as! [Booking]
            print(result)
            print(context.registeredObjects)
            return result.reduce(0, { (res, b) -> Int in
                return res + Int(b.number)
            })
        } catch {
            print(error)
            return Int(movie.quantity)
        }
    }
}
