import UIKit

class NewTaskPlusButtonManager {
    
    private var mainButton: UIButton
    private var mainLabel: UILabel
    private weak var parentView: UIView?
    private weak var viewController: UIViewController? // ViewController referansı eklendi
    
    var additionalButtonsVisible = false
    
    init(parentView: UIView, viewController: UIViewController) { // ViewController referansı eklendi
        self.parentView = parentView
        self.viewController = viewController
        self.mainButton = UIButton(type: .system)
        self.mainLabel = UILabel()
        
        setupMainButton()
    }
    
    private func setupMainButton() {
        guard let parentView = parentView else { return }
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.backgroundColor = .systemBlue
        mainButton.tintColor = .white
        mainButton.setImage(UIImage(systemName: "plus"), for: .normal)
        mainButton.layer.cornerRadius = 35
        mainButton.layer.masksToBounds = true
        
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        
        parentView.addSubview(mainButton)
        
        NSLayoutConstraint.activate([
            mainButton.widthAnchor.constraint(equalToConstant: 70),
            mainButton.heightAnchor.constraint(equalToConstant: 70),
            mainButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -30),
            mainButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30)
        ])
    }
    
    @objc private func mainButtonTapped() {
        viewController?.performSegue(withIdentifier: "toRouterVC", sender: nil)
    }
    
}


