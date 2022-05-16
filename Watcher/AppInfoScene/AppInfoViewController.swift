//
//  InfoViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 26.09.2021.
//

import UIKit

class AppInfoViewController: UIViewController {
    
    private var gitButton = UIButton()
    private var appSiteButton = UIButton()
    private var mailButton = UIButton()
    private var vstack = UIStackView()
    
    private let tmdbLogo: UIImageView = {
        let tmdbLogo = UIImageView()
        tmdbLogo.image = UIImage(named: "LogoTMDB")
        tmdbLogo.translatesAutoresizingMaskIntoConstraints = false
        return tmdbLogo
    }()
    
    private let infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = "This product uses the TMDb API but is not endorsed or certified by TMDb."
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .label
        infoLabel.textAlignment = .center
        infoLabel.font = .systemFont(ofSize: 22)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        return infoLabel
    }()
    
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.text = "Developer: \n Evgeny Berezentsev"
        authorLabel.numberOfLines = 0
        authorLabel.textAlignment = .center
        authorLabel.font = .systemFont(ofSize: 22)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorLabel
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        setViews()
        setConstraints()
    }
    
    private func setViews() {
        title = "App information"
        navigationController?.navigationBar.backgroundColor = .systemGray5
        view.backgroundColor = .systemBackground
        view.addSubview(tmdbLogo)
        view.addSubview(infoLabel)
        view.addSubview(authorLabel)
        view.addSubview(gitButton)
        view.addSubview(appSiteButton)
        
        vstack = UIStackView(arrangedSubviews: [infoLabel,authorLabel,gitButton,appSiteButton])
        vstack.axis = .vertical
        vstack.distribution = .equalSpacing
        vstack.alignment = .fill
        vstack.spacing = 20
        vstack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vstack)
    }
    
    private func configureButtons() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissAction))
        navigationItem.rightBarButtonItem = doneButton
        setupButton(gitButton, title: "GitHub", action: #selector(showMyGitHub))
        setupButton(appSiteButton, title: "App Support", action: #selector(showAppSite))
    }
        
    private func setConstraints() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            tmdbLogo.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50),
            tmdbLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor) ])
        
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: tmdbLogo.bottomAnchor, constant: 50),
            vstack.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -50),
            vstack.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
            vstack.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20) ])
    }
        
    @objc func dismissAction() {
        dismiss(animated: true)
    }
    
    @objc private func showMyGitHub() {
        guard let url = URL(string: "https://github.com/BerezentsevEvgeny") else { return }
        presentSafariVC(with: url)
    }
    
    @objc private func showAppSite() {
        guard let url = URL(string: "https://berezentsevdevelop.wixsite.com/wanttowatch") else { return }
        presentSafariVC(with: url)
    }
}

extension AppInfoViewController {
    func setupButton(_ button: UIButton,title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.layer.shadowColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
    }
}
