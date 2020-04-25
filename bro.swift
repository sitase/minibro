#!/usr/bin/swift sh

import AppKit
import WebKit

let app = NSApplication.shared
let wv = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())

var u: String = "https://www.york.ac.uk/teaching/cws/wws/webpage1.html"

if CommandLine.argc < 2 {
    //print("No arguments are passed.")
    let firstArgument = CommandLine.arguments[0]
    //print(firstArgument)
} else {
    //print("Arguments are passed.")
    u = CommandLine.arguments[1]

}

extension URL {
    subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate {
    let window = NSWindow(contentRect: NSMakeRect(200, 200, 400, 200),
                          styleMask: [.titled, .closable, .miniaturizable, .resizable],
                          backing: .buffered,
                          defer: false,
                          screen: nil)

       // 1. Decides whether to allow or cancel a navigation.
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        let url: URL = navigationAction.request.url!
       // print("navigationAction load:\(String(describing: url))")
        if(url.host == "localhost") {
            print("code="+url["code"]!)
            app.terminate(0)
        }
        decisionHandler(.allow)

    }

    // 2. Start loading web address
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
       // print("start load:\(String(describing: webView.url))")
    }

    // 3. Fail while loading with an error
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        //print("fail with error: \(error.localizedDescription)")
    }

    // 4. WKWebView finish loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("finish loading")
       // print(wv.frame)
    }
    func applicationDidFinishLaunching(_ notification: Notification) {
        window.makeKeyAndOrderFront(nil)
       // let field = NSTextView(frame: window.contentView!.bounds)
       // field.backgroundColor = .white
       // field.isContinuousSpellCheckingEnabled = true
        let view = window.contentView
        window.contentView?.addSubview(wv)
//        window.setContentSize(NSMakeSize(200,400))
//      wv.frame=window.contentRect
        wv.leadingAnchor.constraint(equalTo: view!.leadingAnchor).isActive = true
        wv.trailingAnchor.constraint(equalTo: view!.trailingAnchor).isActive = true
        wv.topAnchor.constraint(equalTo: view!.topAnchor).isActive = true
        wv.bottomAnchor.constraint(equalTo: view!.bottomAnchor).isActive = true
        wv.heightAnchor.constraint(equalTo: view!.heightAnchor).isActive = true
        wv.widthAnchor.constraint(equalTo: view!.widthAnchor).isActive = true
        wv.translatesAutoresizingMaskIntoConstraints = true
        wv.autoresizingMask = [.width, .height]
    //    wv.frame=NSMakeRect(00, 00, 400, 200)
        wv.frame=window.contentView!.frame
        wv.navigationDelegate=self
        if let url = URL(string: u) {
            let request = URLRequest(url: url)
            wv.load(request)

           // print("load")
        }
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

}

let delegate = AppDelegate()
app.setActivationPolicy(.regular) // Magic to accept keyboard input and be docked!
app.delegate = delegate
app.run()
