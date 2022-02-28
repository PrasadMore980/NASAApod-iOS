//
//  Loader.swift
//  NASAApod
//
//  Created by Prasad More on 28/02/22.
//

import Foundation
import UIKit

struct ProgressAlert {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressAlert.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController {
    func LoadingStart() {
        
        ProgressAlert.alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        
        ProgressAlert.alert.view.addSubview(loadingIndicator)
        present(ProgressAlert.alert, animated: true, completion: nil)
    }
    
    func LoadingStop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            ProgressAlert.alert.dismiss(animated: true, completion: nil)
        }
    }
}
