//
//  CoreDataManager.swift
//  HeiAd
//
//  Created by Reinhard D on 20.10.21.

import Foundation
import CoreData

internal class CoreDataManager {
    
    internal static let shared = CoreDataManager()
    
    internal let AD_OBJECT = "AdObject"
    
    private let identifier: String  = Bundle.main.bundleIdentifier!
    private let model: String = "HeiAd"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let messageKitBundle = Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error {
                fatalError("Loading of store failed:\(err)")
            }
        }
        
        return container
        
    }()
    
    
    internal func saveAds(data: [AdDTO]) {
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = persistentContainer.viewContext
        
        for adObj in data {
            
            var adObject: AdObject?
            privateContext.performAndWait {
                
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: AD_OBJECT)
                fetchRequest.predicate = NSPredicate (format: "id = %@",adObj.id)
                
                do {
                    let predicateAdObject = try privateContext.fetch(fetchRequest)
                    
                    if(predicateAdObject.isEmpty){
                        adObject = NSEntityDescription.insertNewObject(forEntityName: AD_OBJECT, into: privateContext) as? AdObject
                    }else{
                        adObject = predicateAdObject [0] as? AdObject
                    }
                }
                catch {
                    print(error)
                }
            }
            guard let adInfo = adObject else {
                return
            }
            
            
            adInfo.setValue(adObj.id, forKeyPath: "id")
            adInfo.setValue(IMAGE_URL + (adObj.image?.url ?? ""), forKeyPath: "url")
            adInfo.setValue(adObj.description, forKeyPath: "descriptionInfo")
            adInfo.setValue(adObj.price?.value, forKeyPath: "price")
            adInfo.setValue(adObj.location, forKeyPath: "location")
            
            privateContext.performAndWait {
                do {
                    try privateContext.save()
                } catch let error {
                    print(error)
                }
            }
        }
        
        persistentContainer.viewContext.performAndWait {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    
    internal func fetchAds(onlyFaves:Bool) -> [AdObject]? {
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<AdObject>(entityName: AD_OBJECT)
        
        let sortDescriptor = NSSortDescriptor(key: "location", ascending: true)
        
        if(onlyFaves){
            fetchRequest.predicate = NSPredicate(format: "favorite == YES")
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let ads = try context.fetch(fetchRequest)
            return ads
            
        } catch let fetchErr {
            print(fetchErr)
            return nil
        }
    }
    
    
    internal func updateAds(adId: String, favorite: Bool){
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<AdObject>(entityName: AD_OBJECT)
        fetchRequest.predicate = NSPredicate (format: "id = %@", adId as CVarArg)
        
        do{
            let adObject = try context.fetch(fetchRequest)
            let adInfo = adObject [0] as NSManagedObject
            
            adInfo.setValue(favorite, forKeyPath: "favorite")
            
        }catch {
            print(error)
        }
        
        do {
            
            try context.save()
            
        } catch let error {
            print(error)
        }
        
    }
    
}
