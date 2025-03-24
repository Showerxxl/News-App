import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate {
    var url: URL?
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize WKWebView
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        
        // Set the navigation delegate
        webView.navigationDelegate = self

        // Add WKWebView to the view
        view.addSubview(webView)

        // Pin WKWebView to the edges of the view
        webView.pinHorizontal(to: view)
        webView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        webView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)

        // Load the URL if it exists
        if let url = url {
            print("Loading URL: \(url)")  
            webView.load(URLRequest(url: url))
        }
    }
    
    // MARK: - WKNavigationDelegate Methods

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load the URL: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started loading the URL")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading the URL")
    }
}
