//
//  DBManager.swift
//
//  Created by Xuhang Liu on 2019/3/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation
import CoreData


class DBManager {
    
    private static let instance = DBManager()
    

    public static var `default`: DBManager {
        return instance
    }
    
    let movieEntity = "Movie"
    let customerEntity = "UserInfo"

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
    

    
    func getMovies() -> [Movie] {
        let userName = User.shared.userName!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        
        let predicate = NSPredicate.init(format: "userName = %@ ", userName)
        request.predicate = predicate
        
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
    
    func getMovieBy(_ id: Int) -> [Movie] {
        guard let userName = User.shared.userName else {return []}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        
        let predicate = NSPredicate.init(format: "userName = %@ and id = %d ", userName, id)
        request.predicate = predicate
        
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
    func addMovie(_ m: TheMovie) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        let predicate = NSPredicate.init(format: "id = %d ", m.id)
        request.predicate = predicate
        
        do {   //保存实体对象
            let result = try context.fetch(request) as! [Movie]
            if result.count > 0 {
                return
            }
            let entity = NSEntityDescription.entity(forEntityName: movieEntity, in: context)
            let object = NSManagedObject(entity: entity!, insertInto: context)
            object.setValue(m.id, forKey: "id")
            object.setValue(m.title, forKey: "title")
            object.setValue(m.quantity, forKey: "quantity")
            object.setValue(m.release_date, forKey: "m_release")
            object.setValue(m.poster_path, forKey: "cover")
            object.setValue(m.vote_average, forKey: "vote_average")
            object.setValue(User.shared.userName!, forKey: "userName")
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("Error:\(nserror),\(nserror.userInfo)")
        }
    }
    
    
    func addMovie(_ id: Int, title: String, quantity: Int, m_release: String, cover: String?) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        let predicate = NSPredicate.init(format: "id = %d ", id)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request) as! [Movie]
            if result.count > 0 {
                return
            }
            let entity = NSEntityDescription.entity(forEntityName: movieEntity, in: context)
            let object = NSManagedObject(entity: entity!, insertInto: context)
            object.setValue(id, forKey: "id")
            object.setValue(title, forKey: "title")
            object.setValue(quantity, forKey: "quantity")
            object.setValue(m_release, forKey: "m_release")
            object.setValue(cover, forKey: "cover")
            
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("Error:\(nserror),\(nserror.userInfo)")
        }
    }
    
    func deleteMovie(_ id: Int) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        let predicate = NSPredicate.init(format: "id = %d ", id)
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
    
    func updateMovieQuantity(_ movie: Movie, q: Int) {
        do {
            let object = context.object(with: movie.objectID) as! Movie
            object.id = movie.id
            object.title = movie.title
            object.quantity = Int16(q)
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
    
    func updateMovie(_ movie: Movie) {
        do {
            let object = context.object(with: movie.objectID) as! Movie
            object.id = movie.id
            object.title = movie.title
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
    
    // MARK: - Cus
    
    func checkDefaultUsers() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: customerEntity)
        do {
            let result = try context.fetch(request) as! [UserInfo]
            if result.count > 0 , let name = result[0].userName, name == "jack" {
                return
            } else {
                [("jack", "123456", "Jerry", 34, "jerry@gmail.com", "51.xsjflsdjlf"), ("bobo", "123456", "Bobo", 34, "jerry@gmail.com", "51.xsjflsdjlf"),
                 ("lily", "123456", "Julia", 34, "jerry@gmail.com", "51.xsjflsdjlf")].forEach({addUserInfo($0.0, password: $0.1, name: $0.2, age: $0.3, email: $0.4, address: $0.5)})
            }
        } catch {
            print(error)
        }
    }

    func getUserInfos(_ userName: String) -> [UserInfo] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: customerEntity)
        
        let predicate = NSPredicate.init(format: "userName = %@ ", userName)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request) as! [UserInfo]
            print(result)
            print(context.registeredObjects)
            return result
        } catch {
            print(error)
            return []
        }
        
    }
    
    func getUserInfos(_ userName: String, pwd: String) -> [UserInfo] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: customerEntity)
        
        let predicate = NSPredicate.init(format: "userName = %@ and password = %@", userName, pwd)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request) as! [UserInfo]
            print(result)
            print(context.registeredObjects)
            return result
        } catch {
            print(error)
            return []
        }
        
    }
    
    func addUserInfo(_ userName: String, password: String, name: String?, age: Int?, email: String?, address: String?) {
        let entity = NSEntityDescription.entity(forEntityName: customerEntity, in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(userName, forKey: "userName")
        object.setValue(password, forKey: "password")
        object.setValue(name, forKey: "name")
        object.setValue(age, forKey: "age")
        object.setValue(email, forKey: "email")
        object.setValue(address, forKey: "address")
        do {
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("Error:\(nserror),\(nserror.userInfo)")
        }
    }
    
    func deleteUserInfo(_ name: String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: customerEntity)
        let predicate = NSPredicate.init(format: "userName = %@ ", name)
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
    
    func updateUserInfo(_ cus: UserInfo) {
        do {
            let person = context.object(with: cus.objectID) as! UserInfo
                person.password = cus.password
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


}
