//
//  ViewController.swift
//  NASAApod
//
//  Created by Prasad More on 28/02/22.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedDate = Date()
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var apodImage: UIImageView!
    private lazy var datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = .clear
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var dateFormatterForDisplay : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    private lazy var dateFormatterForAPI : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    var preloadedArray : [NASAResponse] = []
    let viewModel = ViewModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateStr = dateFormatterForAPI.string(from: Date())
        let dateItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = dateItem
        viewModel.loadData(dateStr: dateStr)
    }


    @objc func dateChanged(picker : UIDatePicker) {
        self.dismiss(animated: false, completion: nil)
        self.lblDate.text = dateFormatterForDisplay.string(from: picker.date)
        let dateStr = dateFormatterForAPI.string(from: datePicker.date)
        viewModel.loadData(dateStr: dateStr)
    }
    
    func updateLabels(apodModel: NASAResponse) {
        self.lblTitle.text = apodModel.title
        self.lblDate.text = apodModel.date
    }
    
    func updateImage(imageData: Data) {
        self.apodImage.image = UIImage(data: imageData)
    }

}

