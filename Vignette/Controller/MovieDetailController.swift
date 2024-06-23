//
//  MovieDetailController.swift
//  Vignette
//
//  Created by Christopher Barlas on 6/10/24.
//

import UIKit

class MovieDetailController: UIViewController {
    private let movieId: Int
    
    // MARK: - UI Components
    private let testLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test"
        return label
    }()
    
    // MARK: - Initializers
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(movieId: 13475)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        self.view.addSubview(testLabel)
        
        testLabel.text = "\(movieId)"
        
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
