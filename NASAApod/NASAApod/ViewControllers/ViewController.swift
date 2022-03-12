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
    @IBOutlet weak var apodImage: UIImageView!
    @IBOutlet weak var detailsButton: UIButton!
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
    var favButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    var dateStr: String {
        get {
            let dateStr = dateFormatterForAPI.string(from: datePicker.date)
            return dateStr
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.LoadingStart()
        viewModel.view = self
        viewModel.loadSavedData(dateStr: dateStr)
        setUpFavouriteButton()
    }
    
    func setUpFavouriteButton() {
        let isFavourite = viewModel.checkFavouriteStatus(dateStr: dateStr)
        if isFavourite {
            //        Favourite Button Heart Filled
            favButton.setImage(Constants.favFilledImage, for: .normal)
        } else {
            //        Favourite Button Heart Empty
            favButton.setImage(Constants.favImage, for: .normal)
        }
    }
    
    func setupNavigationBar() {
        let dateItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = dateItem
        let favButtonItem = UIBarButtonItem(customView: favButton)
        favButton.addTarget(self, action: #selector(self.favTapped(_:)), for: .touchUpInside)
        let listButton = UIBarButtonItem(image: Constants.listImage,  style: .plain, target: self, action: #selector(self.favListTapped(_:)))
        navigationItem.rightBarButtonItems = [favButtonItem, listButton]
    }
    
    @objc func favTapped(_ sender: Any) {
        let isFavourite = viewModel.updateFavouriteStatus(dateStr: dateStr)
        if isFavourite {
            //        Favourite Button Heart Filled
            favButton.setImage(Constants.favFilledImage, for: .normal)
        } else {
            //        Favourite Button Heart Empty
            favButton.setImage(Constants.favImage, for: .normal)
        }
    }
    
    @objc func favListTapped(_ sender: Any) {
        
    }
    
    @objc func dateChanged(picker : UIDatePicker) {
        self.dismiss(animated: false, completion: nil)
        self.lblDate.text = dateFormatterForDisplay.string(from: picker.date)
        LoadingStart()
        viewModel.loadSavedData(dateStr: dateStr)
    }
    
    func updateLabels(apodModel: NASAResponse) {
        DispatchQueue.main.async {
            self.detailsButton.setTitle(apodModel.title, for: .normal)
            self.lblDate.text = apodModel.date
        }
    }
    
    func updateImage(imageData: Data) {
        DispatchQueue.main.async {
            self.apodImage.image = UIImage(data: imageData)
            self.LoadingStop()
        }
    }
    
    func openVideo(mediaUrl: URL) {
        DispatchQueue.main.async {
            self.LoadingStop()
            self.apodImage.image = nil
            UIApplication.shared.open(mediaUrl)
        }
    }
    
    @IBAction func navigateToDetails(_ sender : UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.currentDateModel = viewModel.currentDateModel
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
}

