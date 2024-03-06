//
//  AuthorViewController.swift
//  FakeNFT
//
//  Created by Эмилия on 03.03.2024.
//

import UIKit
import WebKit

//MARK: - AuthorViewController
final class AuthorViewController: UIViewController {
    
    //MARK: - Private properties
    private var url: URL?
    
    //MARK: - UI Components
    private lazy var webView = WKWebView()
    
    // MARK: - Initializers
    init(url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        load()
    }
    
    //MARK: - Private methods
    private func load() {
        guard let url = url else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func configure() {
        view.backgroundColor = UIColor(named: "YP White")
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    private func layoutViews() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
}
