//
//  ViewController.swift
//  Vignette
//
//  Created by Christopher Barlas on 5/20/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Hello, World!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc func didTapButton() {
        let alert = UIAlertController(title: "Hello, User!", message: "You pressed the button!", preferredStyle: .alert)
        let button = UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
            print("Button Pressed")
        })
        alert.addAction(button)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}
