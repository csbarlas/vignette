//
//  SearchCell.swift
//  Vignette
//
//  Created by Christopher Barlas on 6/7/24.
//

import UIKit

class SearchCell: UITableViewCell {
    static let identifier = "SearchCell"
    
    // MARK: - Properties
    private let posterThumbnailImage: UIImage = {
        guard let image = UIImage(named: "placeholder_poster") else {
            fatalError("Could not load placeholder poster image")
        }
        return image
    }()
    
    // MARK: - UI Components
    private let posterThumbnailImageView: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        return thumbnail
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title Placeholder"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper functions
    private func setupUI() {
        self.contentView.addSubview(posterThumbnailImageView)
        self.contentView.addSubview(titleLabel)
        
        posterThumbnailImageView.image = posterThumbnailImage
        titleLabel.text = "Star Trek"
        
        NSLayoutConstraint.activate([
            posterThumbnailImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            posterThumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            posterThumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            
            posterThumbnailImageView.heightAnchor.constraint(equalToConstant: 120),
            posterThumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterThumbnailImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor)
        ])
    }
    
    public func configure(result: MovieSearchResult) {
        titleLabel.text = result.title
        titleLabel.sizeToFit()
    }
}
