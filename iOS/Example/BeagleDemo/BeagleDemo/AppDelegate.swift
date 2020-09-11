/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import Beagle

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let deepLinkHandler = DeeplinkScreenManager.shared
        deepLinkHandler[.lazyComponentEndpoint] = LazyComponentScreen.self
        deepLinkHandler[.pageViewEndpoint] = PageViewScreen.self
        deepLinkHandler[.tabViewEndpoint] = TabViewScreen.self
        deepLinkHandler[.formEndpoint] = FormScreen.self
        deepLinkHandler[.customComponentEndpoint] = CustomComponentScreen.self
        deepLinkHandler[.screenDeeplinkEndpoint] = ScreenDeepLink.self
        deepLinkHandler[.listViewEndpoint] = ListViewScreen.self
        deepLinkHandler[.webViewEndpoint] = WebViewScreen.self
        deepLinkHandler[.componentInterationEndpoint] = ComponentInteractionText.self
        deepLinkHandler[.simpleFormEndpoint] = SimpleFormScreen.self
        deepLinkHandler[.navigateStep1Endpoint] = NavigateStep1Screen.self
        deepLinkHandler[.navigateStep2Endpoint] = NavigateStep2Screen.self

        let validator = ValidatorProviding()
        validator[FormScreen.textValidatorName] = FormScreen.textValidator
        
        let dependencies = BeagleDependencies()
        dependencies.theme = AppTheme.theme
        dependencies.urlBuilder = UrlBuilder(baseUrl: URL(string: .baseURL))
        dependencies.navigation.defaultAnimation = .init(pushTransition: .init(type: .fade, subtype: .fromRight, duration: 0.1), modalPresentationStyle: .formSheet)
        dependencies.deepLinkHandler = deepLinkHandler
        dependencies.validatorProvider = validator
        dependencies.analytics = AnalyticsMock()
        dependencies.isLoggingEnabled = true
        
        registerCustomComponents(in: dependencies)
        registerCustomControllers(in: dependencies)
        
        Beagle.dependencies = dependencies
        
//        let rootViewController = MainScreen().screenController()
        window?.rootViewController = CustomController()
        
        return true
    }
    
    private func registerCustomComponents(in dependencies: BeagleDependencies) {
        dependencies.decoder.register(component: DSCollection.self)
        dependencies.decoder.register(component: MyComponent.self)
        dependencies.decoder.register(action: CustomConsoleLogAction.self)
        dependencies.decoder.register(component: DemoTextField.self, named: "SampleTextField")
    }
    
    private func registerCustomControllers(in dependencies: BeagleDependencies) {
        dependencies.navigation.registerNavigationController(builder: CustomBeagleNavigationController.init, forId: "CustomBeagleNavigation")
        dependencies.navigation.registerNavigationController(builder: CustomPushStackNavigationController.init, forId: "PushStackNavigation")
    }
}

class CustomController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let wrapper = YogaWrapper(view: YogaSample())
        view.addSubview(wrapper)
        
        let margin = view.layoutMarginsGuide
        
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        wrapper.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
        wrapper.trailingAnchor.constraint(lessThanOrEqualTo: margin.trailingAnchor).isActive = true
        
//        wrapper.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        wrapper.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        wrapper.bottomAnchor.constraint(lessThanOrEqualTo: margin.bottomAnchor).isActive = true
    }
}

// to be used inside a view hierarchy with autolayout
class YogaWrapper: UIView {
    let root: UIView
    var isFirstTime = true
    
    init(view: UIView) {
        self.root = UIView()
        super.init(frame: .zero)
        
        clipsToBounds = true
        root.yoga.isEnabled = true
        
        root.addSubview(view)
        addSubview(root)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let nanSize = CGSize(width: Double.nan, height: .nan)
        return root.yoga.calculateLayout(with: nanSize)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        root.frame = bounds
        root.yoga.applyLayout(preservingOrigin: true)
    }
}

class YogaSample: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        yoga.isEnabled = true
        yoga.flexWrap = .wrap
        yoga.margin = 10
        yoga.padding = 10
        
        let label = UILabel()
        label.text = "YOGA"
        label.yoga.isEnabled = true
        label.yoga.marginBottom = 5
        addSubview(label)
        
        let button = UIButton(type: .system)
        button.setTitle("ADD", for: .normal)
        button.yoga.isEnabled = true
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        addSubview(button)
        
        let view3 = AutoLayoutWrapper(view: AutoLayoutSample())
        addSubview(view3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func add() {
        let view = AutoLayoutWrapper(view: AutoLayoutSample())
        addSubview(view)
        markDirty()
    }
    
}

// to be used inside a view with yoga
class AutoLayoutWrapper: UIView {
    let view: UIView
    
    init(view: UIView) {
        self.view = view
        super.init(frame: .zero)
        clipsToBounds = true
        yoga.isEnabled = true
        addSubview(view)
        
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        let botton = view.bottomAnchor.constraint(equalTo: bottomAnchor)
        botton.priority = .init(rawValue: 999)
        botton.isActive = true
        let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor)
        leading.priority = .init(rawValue: 999)
        leading.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        systemLayoutSizeFitting(size)
    }
    
}

class AutoLayoutSample: UIView {
    let constraintView: UIView
    let heightConstraint: NSLayoutConstraint
    
    override init(frame: CGRect) {
        let view = UIView()
        self.constraintView = view
        self.heightConstraint = view.heightAnchor.constraint(equalToConstant: 100)
        super.init(frame: frame)
        
        backgroundColor = .yellow
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        view.backgroundColor = .cyan
        addSubview(view)
        
        translatesAutoresizingMaskIntoConstraints = false
    
        let label = UILabel()
        label.text = "AUTO"
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        view.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        heightConstraint.isActive = true
        
        let button = UIButton(type: .system)
        button.setTitle("shrink", for: .normal)
        button.addTarget(self, action: #selector(shrink), for: .touchUpInside)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        button.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func shrink() {
        UIView.animate(withDuration: 0.7) {
            self.heightConstraint.constant = 50
            self.superview?.markDirty() // we need to call on YogaWrapper
        }
        
    }
}

extension UIView {
    func markDirty() {
        yoga.markDirty()
        var view: UIView? = self
        while let currentView = view {
            if !currentView.yoga.isEnabled {
                currentView.invalidateIntrinsicContentSize()
                currentView.setNeedsLayout()
                currentView.layoutIfNeeded() // maybe we should call in root view
                break
            }
            view = view?.superview
        }
    }
}
