//
//  ViewModel.swift
//  NASAApod
//
//  Created by Prasad More on 28/02/22.
//

import Foundation
class ViewModel {
    private var currentDateModel: NASAResponse?
    weak var view: ViewController?
    
    func loadData(dateStr: String) {
        APIHelper.shared.getData(dateStr: dateStr, completionHandler: { responseObj, error in
            guard let firstObj = responseObj else { return }
            DispatchQueue.main.async {
                self.view?.updateLabels(apodModel: firstObj)
            }
            if let url = firstObj.url,
               let imageUrl = URL(string: url) {
                do {
                    let imageData = try Data(contentsOf: imageUrl)
                    DispatchQueue.main.async {
                        self.view?.updateImage(imageData: imageData)
                    }
                } catch {
                    print(error)
                }
            }
        })
    }
}
