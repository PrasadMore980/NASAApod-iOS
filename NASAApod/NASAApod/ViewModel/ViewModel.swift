//
//  ViewModel.swift
//  NASAApod
//
//  Created by Prasad More on 28/02/22.
//

import Foundation
import CoreData
import UIKit

class ViewModel {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var currentDateModel: NASAResponse?
    weak var view: ViewController?
    
    func loadData(dateStr: String) {
        APIHelper.shared.getData(dateStr: dateStr, completionHandler: { responseObj, error in
            guard let firstObj = responseObj else { return }
            self.view?.updateLabels(apodModel: firstObj)
            if let mediaType = firstObj.mediaType, let url = firstObj.url,
               let mediaUrl = URL(string: url){
                if mediaType == "video" {
                    self.view?.openVideo(mediaUrl: mediaUrl)
                    self.checkSavedDate(apodResponse: firstObj, imageData: Data())
                } else {
                    //API fetchImageData
                    APIHelper.shared.fetchImageData(imageUrl: url) { data, error in
                        if error == nil {
                            guard let imageData = data else {
                                //NO IMAGE FOUND
                                return
                            }
                            self.view?.updateImage(imageData: imageData)
                            self.checkSavedDate(apodResponse: firstObj, imageData: imageData)
                        } else {
                            //NO IMAGE FOUND
                        }
                    }
                }
            }
        })
    }
    
    func loadSavedData(dateStr: String) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.kEntityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "date == %@", dateStr)

        do {
            let dates = try managedContext.fetch(fetchRequest)
            if dates != nil && dates.count == 0 {
                self.loadData(dateStr: dateStr)
                return
            } else if !self.checkSavedDate(dateStr: dateStr) {
                self.loadData(dateStr: dateStr)
                return
            }
            for Entity in dates as [NSManagedObject] {
                var apodResponse : NASAResponse = NASAResponse()
                apodResponse.date = Entity.value(forKey: "date") as? String
                apodResponse.copyright = Entity.value(forKey: "copyright") as? String
                apodResponse.explanation = Entity.value(forKey: "explanation") as? String
                apodResponse.hdurl = Entity.value(forKey: "hdurl") as? String
                apodResponse.mediaType = Entity.value(forKey: "mediaType") as? String
                apodResponse.serviceVersion = Entity.value(forKey: "serviceVersion") as? String
                apodResponse.title = Entity.value(forKey: "title") as? String
                apodResponse.url = Entity.value(forKey: "url") as? String
                let imageData = Entity.value(forKey: "imageData") as? Data ?? Data()
                self.currentDateModel = apodResponse
                DispatchQueue.main.async {
                    self.view?.updateLabels(apodModel: apodResponse)
                }
                if let mediaType = apodResponse.mediaType, let url = apodResponse.url,
                   let mediaUrl = URL(string: url){
                    if mediaType == "video" {
                        self.view?.openVideo(mediaUrl: mediaUrl)
                    } else {
                        self.view?.updateImage(imageData: imageData)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //Should be Used with Favourites
    func deleteAllData(entity: String) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func checkSavedDate(dateStr: String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.kEntityName)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let dates = try context.fetch(fetchRequest)
            if dates != nil && dates.count != 0 {
                for Entity in dates as [NSManagedObject] {
                    if let savedDate = Entity.value(forKey: "date") as? String {
                        if savedDate == dateStr {
                            return true
                        }
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false

    }
    
    func checkSavedDate(apodResponse : NASAResponse, imageData: Data) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.kEntityName)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let dates = try context.fetch(fetchRequest)
            if dates != nil && dates.count != 0 {
                for Entity in dates as [NSManagedObject] {
                    if let date = apodResponse.date,
                       let savedDate = Entity.value(forKey: "date") as? String {
                        if savedDate == date {
                            return
                        }
                    }
                }
            }
            self.saveAPODResponse(apodResponse : apodResponse, imageData: imageData)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveAPODResponse(apodResponse : NASAResponse, imageData: Data) {
        //        deleteAllData(entity: "APODList")
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "APODList", in: context)
        let responseData = NSManagedObject(entity: entity!, insertInto: context)
        if let date = apodResponse.date {
            responseData.setValue(date, forKey: "date")
        }
        if let title = apodResponse.title {
            responseData.setValue(title, forKey: "title")
        }
        if let copyright = apodResponse.copyright {
            responseData.setValue(copyright, forKey: "copyright")
        }
        if let explanation = apodResponse.explanation {
            responseData.setValue(explanation, forKey: "explanation")
        }
        if let hdurl = apodResponse.hdurl {
            responseData.setValue(hdurl, forKey: "hdurl")
        }
        if let mediaType = apodResponse.mediaType {
            responseData.setValue(mediaType, forKey: "mediaType")
        }
        if let url = apodResponse.url {
            responseData.setValue(url, forKey: "url")
        }
        if let serviceVersion = apodResponse.serviceVersion {
            responseData.setValue(serviceVersion, forKey: "serviceVersion")
        }
        responseData.setValue(imageData, forKey: "imageData")
        responseData.setValue(false, forKey: "isFavourite")
        do {
            try context.save()
        }
        catch {
            print("Failed saving")
        }
    }
    
}
