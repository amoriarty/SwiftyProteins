//
//  AuthenticationController.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import UIKit
import ToolboxLGNT
import LocalAuthentication

final class AuthenticationController: GenericViewController {
    private let authContext = LAContext()
    
    // MARK:- Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Swifty Proteins"
        label.font = .boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    private let touchButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Fingerprint")
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
        return button
    }()
    
    // MARK:- View Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthentication()
    }
    
    // MARK:- Setups
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = Colors.background
        view.addSubview(titleLabel)
        view.addSubview(touchButton)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        _ = titleLabel.center(.horizontaly, view.safeAreaLayoutGuide)
        _ = titleLabel.center(.verticaly, view.safeAreaLayoutGuide, multiplier: 0.5)
        _ = touchButton.center(view.safeAreaLayoutGuide)
    }
    
    // MARK:- Authentication
    /* Checking if local authentification is available */
    private func checkAuthentication() {
        var error: NSError?
        
        guard authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let retry = UIAlertAction(title: "Retry", style: .default, handler: { [unowned self] _ in
                self.checkAuthentication()
            })
            
            alert.title = "Authentication Impossible"
            alert.message = "No authentication method is configured on your device. Please configure a password or/and Touch/Face ID in order to use Swifty Proteins."
            alert.addAction(retry)
            present(alert, animated: true, completion: nil)
            return
        }
        
        authenticate()
    }
    
    private func authenticate() {
        authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate in order to unlock application.") { [unowned self] success, error in
            guard success, error == nil else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK:- Button handle
    @objc func handleTouch() {
        authenticate()
    }
}
