//
//  CoreDataManager.swift
//  Liverpool
//
//  Created by Daniel Liceaga on 15/09/20.
//  Copyright © 2020 Daniel Liceaga. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager: NSObject {
    
    override init() {
        super.init()
    }
    
    func save(entity: String, attributes: [String: Any], predicate: NSPredicate? = nil) {
        var insert: Bool = true
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        if predicate != nil {
            let data = get(entity: entity, predicate: predicate)
            
            insert = data.count == 0
        }
        
        if insert {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
            let bus = NSManagedObject(entity: entity,insertInto: managedContext)
            
            for (key, att) in attributes {
                bus.setValue(att, forKeyPath: key)
            }
          
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func get(entity: String, predicate: NSPredicate? = nil) -> [NSManagedObject] {
        var datos: [NSManagedObject] = []
        
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        
        if (predicate != nil) {
            fetchRequest.predicate = predicate
        }

        do {
            datos = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return datos
    }
}
