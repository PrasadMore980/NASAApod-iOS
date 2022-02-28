//
//  DetailsViewController.swift
//  NASAApod
//
//  Created by Prasad More on 28/02/22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var lblCopyright: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblExplanation: UILabel!
    var currentDateModel: NASAResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblCopyright.text = currentDateModel?.copyright
        lblTitle.text = currentDateModel?.title
        lblExplanation.text = currentDateModel?.explanation
    }
    

    @IBAction func dismissView() {
        dismiss(animated: true, completion: nil)
    }

}
