//
//  ViewController.swift
//  Project3
//
//  Created by Виктор on 11.02.2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "vk.com"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open", style: .plain, target: self, action: #selector(openTapped))
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(barButtonSystemItem: .undo, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(barButtonSystemItem: .redo, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [progressButton, spacer, refresh, goBack, goForward]
        navigationController?.isToolbarHidden = false
    }

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"
        {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction){
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host
        {
            for website in websites {
                if host.contains(website)
                {
                    decisionHandler(.allow)
                    return
                } else
                {
                    let ac = UIAlertController(title: "Error!", message: "Address blocked", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(ac, animated: true, completion: nil)
                }
            }
        }
        
        decisionHandler(.cancel)
    }
}

