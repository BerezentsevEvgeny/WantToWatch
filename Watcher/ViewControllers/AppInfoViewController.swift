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
        view.backgroundColor = .systemBackground
        title = "About the App"
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
    
    @objc func dismissAction() {
        dismiss(animated: true)
    }
    
    private func configLogo() {
        view.addSubview(tmdbLogo)
        tmdbLogo.image = UIImage(named: "LogoTMDB")
        tmdbLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tmdbLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
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
            infoLabel.topAnchor.constraint(equalTo: tmdbLogo.bottomAnchor, constant: 40),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 )
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

        gitButton.translatesAutoresizingMaskIntoConstraints = false
        gitButton.setTitle("GitHub", for: .normal)
        gitButton.layer.cornerRadius = 10
        gitButton.backgroundColor = .systemBlue
        gitButton.addTarget(self, action: #selector(showSafariVC), for: .touchUpInside)
        view.addSubview(gitButton)
        NSLayoutConstraint.activate([
            gitButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            gitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            gitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
            
        ])
        
        
    }
    
    @objc private func showSafariVC() {
        guard let url = URL(string: "https://github.com/BerezentsevEvgeny") else { return }
        presentSafariVC(with: url)
    }
    
    



}
