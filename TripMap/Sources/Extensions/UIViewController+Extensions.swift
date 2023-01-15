//
//  UIViewController+Extensions.swift
//  TripMap
//
//  Created by Victor Catão on 15/01/23.
//

import UIKit

extension UIViewController {
    /// Display message in prompt view
    ///
    /// — Parameters:
    /// — title: Title to display Alert
    /// — message: Pass string of content message
    /// — options: Pass multiple UIAlertAction title like “OK”,”Cancel” etc
    /// — completion: The block to execute after the presentation finishes.
    func showErrorMessage(
        title: String = "error_modal_title".localized,
        message: String,
        okHandler: (() -> Void)?
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(
            UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
                self.dismiss(animated: true) { okHandler?() }
            })
        )

        self.present(alertController, animated: true, completion: nil)
    }
    
}
