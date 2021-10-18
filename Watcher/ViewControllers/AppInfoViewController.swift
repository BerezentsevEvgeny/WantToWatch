//
//  InfoViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 26.09.2021.
//

import UIKit

class AppInfoViewController: UIViewController {
    
    private let tmdbLogo: UIImageView = {
        let tmdbLogo = UIImageView()
        tmdbLogo.image = UIImage(named: "LogoTMDB")
        tmdbLogo.translatesAutoresizingMaskIntoConstraints = false
        return tmdbLogo
    }()
    
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.text = "Author: \n Evgeny Berezentsev"
        authorLabel.numberOfLines = 0
        authorLabel.textAlignment = .center
        authorLabel.font = .systemFont(ofSize: 20, weight: .regular)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorLabel
    }()
    
    private let infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = "This product uses the TMDb API but is not endorsed or certified by TMDb."
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .label
        infoLabel.textAlignment = .center
        infoLabel.font = .systemFont(ofSize: 22, weight: .regular)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        return infoLabel
    }()
    
    private let gitButton: UIButton = {
        let gitButton = UIButton()
        gitButton.setTitle("GitHub", for: .normal)
        gitButton.backgroundColor = .systemBlue
        gitButton.layer.cornerRadius = 10            //needs custom button
        gitButton.layer.shadowRadius = 5
        gitButton.layer.shadowOpacity = 0.5
        gitButton.layer.shadowOffset = .zero
        gitButton.layer.shadowColor = UIColor.black.cgColor
        gitButton.translatesAutoresizingMaskIntoConstraints = false
        gitButton.addTarget(self, action: #selector(showSafariVC), for: .touchUpInside)
        return gitButton
    }()
    
    private let mailButton: UIButton = {
        let mailButton = UIButton()
        mailButton.setTitle("Email", for: .normal)
        mailButton.backgroundColor = .systemBlue
        mailButton.layer.cornerRadius = 10
        mailButton.layer.shadowRadius = 5
        mailButton.layer.shadowOpacity = 0.5
        mailButton.layer.shadowOffset = .zero
        mailButton.layer.shadowColor = UIColor.black.cgColor
        mailButton.translatesAutoresizingMaskIntoConstraints = false
        mailButton.addTarget(self, action: #selector(showSafariVC), for: .touchUpInside)
        return mailButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configDoneButton()
        setConstraints()
    }
    
    private func setupViews() {
        title = "About the App"
        navigationController?.navigationBar.backgroundColor = .systemGray5
        view.backgroundColor = .systemBackground
        view.addSubview(tmdbLogo)
        view.addSubview(infoLabel)
        view.addSubview(authorLabel)
        view.addSubview(gitButton)
        view.addSubview(mailButton)
    }
    
    private func configDoneButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissAction))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tmdbLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            tmdbLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: tmdbLogo.bottomAnchor, constant: 70),
            infoLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 40),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            gitButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 100),
            gitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            gitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])

        NSLayoutConstraint.activate([
            mailButton.topAnchor.constraint(equalTo: gitButton.bottomAnchor, constant: 40),
            mailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            mailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
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
