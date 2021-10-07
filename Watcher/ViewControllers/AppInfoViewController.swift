//
//  InfoViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 26.09.2021.
//

import UIKit

class AppInfoViewController: UIViewController {
    
    var tmdbLogo = UIImageView()
    var infoLabel = UILabel()
    var authorLabel = UILabel()
    var gitButton = UIButton()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .systemGray5
        title = "About the App"
        view.backgroundColor = .systemBackground
        configDoneButton()
        configLogo()
        configInfoLabel()
        configAuthorLabel()
        configGitButton()
    }
    
    private func configDoneButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissAction))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configLogo() {
        view.addSubview(tmdbLogo)
        tmdbLogo.image = UIImage(named: "LogoTMDB")
        tmdbLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tmdbLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tmdbLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configInfoLabel() {
        view.addSubview(infoLabel)
        infoLabel.text = "This product uses the TMDb API but is not endorsed or certified by TMDb."
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .label
        infoLabel.textAlignment = .center
        infoLabel.font = .systemFont(ofSize: 22, weight: .regular)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: tmdbLogo.bottomAnchor, constant: 60),
            infoLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func configAuthorLabel() {
        view.addSubview(authorLabel)
        authorLabel.text = "Author: \n Evgeny Berezentsev"
        authorLabel.numberOfLines = 0
        authorLabel.textAlignment = .center
        authorLabel.font = .systemFont(ofSize: 20, weight: .regular)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 40),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configGitButton() {
        view.addSubview(gitButton)
        gitButton.setTitle("GitHub", for: .normal)
        gitButton.layer.cornerRadius = 10
        gitButton.backgroundColor = .systemBlue
        gitButton.translatesAutoresizingMaskIntoConstraints = false
        gitButton.addTarget(self, action: #selector(showSafariVC), for: .touchUpInside)
        gitButton.layer.shadowColor = UIColor.black.cgColor
        gitButton.layer.shadowRadius = 5
        gitButton.layer.shadowOpacity = 0.5
        gitButton.layer.shadowOffset = .zero
        
        NSLayoutConstraint.activate([
            gitButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -150),
            gitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            gitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    @objc func dismissAction() {
        dismiss(animated: true)
    }
    
    @objc private func showSafariVC() {
        guard let url = URL(string: "https://github.com/BerezentsevEvgeny") else { return }
        presentSafariVC(with: url)
    }
    
    



}
