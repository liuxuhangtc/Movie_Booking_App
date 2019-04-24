import UIKit
import WebKit

class WebViewController: MTBaseViewController {

    public var urlRequest: URLRequest

    var webView = WKWebView(frame: CGRect.zero, configuration:  WKWebViewConfiguration())

    //web component initialize
    public required init(_ url: URL) {
        self.urlRequest = URLRequest(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //back to previous scene
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var artcle: TheMovie?
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        
        webView.allowsBackForwardNavigationGestures = true
        webView.contentMode = .scaleAspectFit
        view.addSubview(webView)
        webView.load(urlRequest)
        
        addNavigationBarLeftButton(self)
        
        if let a = artcle {
            
            title = a.title
            
            let suggestButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
            
            let leftButton2: UIButton = UIButton(frame: CGRect(x: 60, y: 0, width: 32, height: 32))
            leftButton2.setImage(UIImage(named: "product"), for: .normal)
            leftButton2.setImage(UIImage(named: "product_s"), for: .selected)
            leftButton2.imageEdgeInsets = UIEdgeInsets(top: 8, left: 3, bottom: 8, right: 3)
            
            leftButton2.addTarget(self, action: #selector(addReading(_:)), for: .touchUpInside)
            leftButton2.transform = CGAffineTransform(translationX: 15, y: 0)   //15 刚好
            suggestButtonContainer.addSubview(leftButton2)
            let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
            
            self.navigationItem.rightBarButtonItem = suggestButtonItem
        }
    }
    
    @objc func toSource() {
        
        
    }
    
    @objc func addReading(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.stopLoading()
    }

}


