import UIKit

class FloatingButtonManager {
    
    private var mainButton: UIButton
    private var additionalButton1: UIButton
    private var additionalButton2: UIButton
    private var additionalLabel1: UILabel
    private var additionalLabel2: UILabel
    private var mainLabel: UILabel
    private var blurEffectView: UIView?
    private weak var parentView: UIView?
    private weak var viewController: UIViewController? // ViewController referansı eklendi
    
    var additionalButtonsVisible = false
    
    init(parentView: UIView, viewController: UIViewController) { // ViewController referansı eklendi
        self.parentView = parentView
        self.viewController = viewController
        self.mainButton = UIButton(type: .system)
        self.additionalButton1 = UIButton(type: .system)
        self.additionalButton2 = UIButton(type: .system)
        self.additionalLabel1 = UILabel()
        self.additionalLabel2 = UILabel()
        self.mainLabel = UILabel()
        
        setupMainButton()
        setupAdditionalButtons()
        setupLabels()
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
    
    private func setupAdditionalButtons() {
        guard let parentView = parentView else { return }
        
        additionalButton1.translatesAutoresizingMaskIntoConstraints = false
        additionalButton1.backgroundColor = .systemGreen
        additionalButton1.tintColor = .white
        additionalButton1.setImage(UIImage(systemName: "arrow.circlepath"), for: .normal)
        additionalButton1.layer.cornerRadius = 25
        additionalButton1.layer.masksToBounds = true
        additionalButton1.alpha = 0 // Başlangıçta gizli
        
        additionalButton1.addTarget(self, action: #selector(additionalButton1Tapped), for: .touchUpInside)
        
        additionalButton2.translatesAutoresizingMaskIntoConstraints = false
        additionalButton2.backgroundColor = .systemRed
        additionalButton2.tintColor = .white
        additionalButton2.setImage(UIImage(systemName: "circle.circle"), for: .normal)
        additionalButton2.layer.cornerRadius = 25
        additionalButton2.layer.masksToBounds = true
        additionalButton2.alpha = 0 // Başlangıçta gizli
        
        additionalButton2.addTarget(self, action: #selector(additionalButton2Tapped), for: .touchUpInside)
        
        parentView.addSubview(additionalButton1)
        parentView.addSubview(additionalButton2)
        
        NSLayoutConstraint.activate([
            additionalButton1.widthAnchor.constraint(equalToConstant: 50),
            additionalButton1.heightAnchor.constraint(equalToConstant: 50),
            additionalButton1.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor),
            additionalButton1.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -10),
            
            additionalButton2.widthAnchor.constraint(equalToConstant: 50),
            additionalButton2.heightAnchor.constraint(equalToConstant: 50),
            additionalButton2.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor),
            additionalButton2.bottomAnchor.constraint(equalTo: additionalButton1.topAnchor, constant: -10)
        ])
    }
    
    private func setupLabels() {
        guard let parentView = parentView else { return }
        
        additionalLabel1.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel1.backgroundColor = .white
        additionalLabel1.textColor = .black
        additionalLabel1.text = "Recurring Event"
        additionalLabel1.textAlignment = .center
        additionalLabel1.layer.cornerRadius = 5
        additionalLabel1.layer.masksToBounds = true
        additionalLabel1.alpha = 0 // Başlangıçta gizli
        
        additionalLabel2.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel2.backgroundColor = .white
        additionalLabel2.textColor = .black
        additionalLabel2.text = "Habit"
        additionalLabel2.textAlignment = .center
        additionalLabel2.layer.cornerRadius = 5
        additionalLabel2.layer.masksToBounds = true
        additionalLabel2.alpha = 0 // Başlangıçta gizli
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.backgroundColor = .white
        mainLabel.textColor = .black
        mainLabel.text = "New Task"
        mainLabel.textAlignment = .center
        mainLabel.layer.cornerRadius = 5
        mainLabel.layer.masksToBounds = true
        mainLabel.alpha = 0 // Başlangıçta gizli
        
        parentView.addSubview(additionalLabel1)
        parentView.addSubview(additionalLabel2)
        parentView.addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            additionalLabel1.widthAnchor.constraint(equalToConstant: 150),
            additionalLabel1.heightAnchor.constraint(equalToConstant: 30),
            additionalLabel1.trailingAnchor.constraint(equalTo: additionalButton1.leadingAnchor, constant: -10),
            additionalLabel1.centerYAnchor.constraint(equalTo: additionalButton1.centerYAnchor),
            
            additionalLabel2.widthAnchor.constraint(equalToConstant: 70),
            additionalLabel2.heightAnchor.constraint(equalToConstant: 30),
            additionalLabel2.trailingAnchor.constraint(equalTo: additionalButton2.leadingAnchor, constant: -10),
            additionalLabel2.centerYAnchor.constraint(equalTo: additionalButton2.centerYAnchor),
            
            mainLabel.widthAnchor.constraint(equalToConstant: 100),
            mainLabel.heightAnchor.constraint(equalToConstant: 30),
            mainLabel.trailingAnchor.constraint(equalTo: mainButton.leadingAnchor, constant: -10),
            mainLabel.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor)
        ])
    }
    
    @objc private func mainButtonTapped() {
        if additionalButtonsVisible {
            // Eğer butonlar görünüyorsa, segue'yi gerçekleştirin
            viewController?.performSegue(withIdentifier: "toRouterVC", sender: nil)
        } else {
            // Butonları göster
            showAdditionalButtons()
            applyBlurEffect()
        }
    }
    
    @objc private func additionalButton1Tapped() {
        // Ek birinci butonun işlemleri buraya
    }
    
    @objc private func additionalButton2Tapped() {
        // Ek ikinci butonun işlemleri buraya
    }
    
    func toggleAdditionalButtons() {
        if additionalButtonsVisible {
            hideAdditionalButtons()
            removeBlurEffect()
        } else {
            showAdditionalButtons()
            applyBlurEffect()
        }
    }
    
    func showAdditionalButtons() {
        additionalButtonsVisible = true
        UIView.animate(withDuration: 0.3) {
            self.additionalButton1.alpha = 1
            self.additionalButton2.alpha = 1
            self.additionalLabel1.alpha = 1
            self.additionalLabel2.alpha = 1
            self.mainLabel.alpha = 1
            self.mainButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal) // + ikonunu tikli box ile değiştir
        }
    }
    
    func hideAdditionalButtons() {
        additionalButtonsVisible = false
        UIView.animate(withDuration: 0.3) {
            self.additionalButton1.alpha = 0
            self.additionalButton2.alpha = 0
            self.additionalLabel1.alpha = 0
            self.additionalLabel2.alpha = 0
            self.mainLabel.alpha = 0
            self.mainButton.setImage(UIImage(systemName: "plus"), for: .normal) // Tikli box ikonunu + ikonu ile değiştir
        }
    }
    
    func applyBlurEffect() {
        guard let parentView = parentView else { return }
        
        let blurEffectView = UIView(frame: parentView.bounds)
        blurEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.4) // Yarı saydam arka plan
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.blurEffectView = blurEffectView
        parentView.insertSubview(blurEffectView, belowSubview: mainButton)
    }
    
    func removeBlurEffect() {
        blurEffectView?.removeFromSuperview()
    }
}

