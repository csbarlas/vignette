//
//  ViewController.swift
//  Vignette
//
//  Created by Christopher Barlas on 5/20/24.
//

import UIKit

class ViewController: UIViewController {
    private var searchResults = [MovieSearchResult]()

    // MARK: - UI Components
    private let topNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        var buttonConfig = UIButton.Configuration.plain()
        var attributeContainer = AttributeContainer()
        attributeContainer.font = UIFont.boldSystemFont(ofSize: 18.0)
        buttonConfig.attributedTitle = AttributedString("Home", attributes: attributeContainer)
        var imageConfig = UIImage.SymbolConfiguration(hierarchicalColor: .systemBlue)
        imageConfig = imageConfig.applying(UIImage.SymbolConfiguration(pointSize: 13))
        buttonConfig.image = UIImage(systemName: "chevron.down.circle.fill", withConfiguration: imageConfig)
        buttonConfig.imagePlacement = .trailing
        buttonConfig.imagePadding = 3.0
        button.configuration = buttonConfig
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Movies"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        return tableView
    }()
    
    
    
    private let navMenu: UIMenu = {
        let settingsAction: UIAction = {
            let action = UIAction(title: "Settings", image: UIImage(systemName: "gear")) { _ in
                
            }
            
            return action
        }()
        
        let statsAction: UIAction = {
            let action = UIAction(title: "Stats", image: UIImage(systemName: "chart.bar.fill")) { _ in
                
            }
            return action
        }()
        
        let menu = UIMenu(children: [statsAction, settingsAction])
        return menu
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(topNavButton)
        
        topNavButton.menu = navMenu
        topNavButton.showsMenuAsPrimaryAction = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            topNavButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topNavButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: topNavButton.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    // MARK: - UI Callbacks
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
    
    @objc func navButtonPressed() {
        topNavButton.configuration?.title = "Test"
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            fatalError("Could not dequeue a SearchCell")
        }
        
        Task {
            do {
                try await cell.configure(result: searchResults[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchCell else {
            fatalError("Could not fetch SearchCell at: \(indexPath.row)")
        }
        
        let movieId = cell.searchResult.id
        let movieDetailVC = MovieDetailController(movieId: movieId)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(movieDetailVC, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        Task {
            do {
                guard let searchBarText = searchBar.text else { return }
                let results = try await performMovieSearchAPICall(title: searchBarText)
                searchResults = results
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - API Calls

enum VignetteError: Error {
    case invalidURL(String)
}

func performMovieSearchAPICall(title: String) async throws -> [MovieSearchResult] {
    let url = URL(string: "https://api.vignetteapp.com/search/movie?query=\(title)")
    guard let url = url else { throw VignetteError.invalidURL("The API Endpoint URL is invalid")}
    let (data, _) = try await URLSession.shared.data(from: url)
    let response = try JSONDecoder().decode(MovieSearchWrapper.self, from: data)
    return response.results
}
