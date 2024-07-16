/*import UIKit
import AudioToolbox

class FlagManager {
    static let shared = FlagManager()
    
    private init() {}
    
    var flagSelectionView: UIView?
    var flagButton: UIButton?
    
    func setupFlagSelectionView(in view: UIView, flagButton: UIButton) {
        let flagView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 190))
        flagView.backgroundColor = UIColor(white: 0.9, alpha: 0.5) // Silik gri arka plan rengi
        flagView.layer.cornerRadius = 10
        flagView.isHidden = true
        view.addSubview(flagView)
        flagSelectionView = flagView
        
        let colors: [UIColor] = [.red, .orange, .yellow, .white]
        let systemNames = ["flag.fill", "flag.fill", "flag.fill", "flag.fill"]
        
        let buttonHeight: CGFloat = 40
        let buttonSpacing: CGFloat = 1
        
        for (index, color) in colors.enumerated() {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 10, y: CGFloat(index) * (buttonHeight + buttonSpacing) + 10, width: 40, height: buttonHeight)
            let image = UIImage(systemName: systemNames[index])?.withTintColor(color, renderingMode: .alwaysOriginal)
            button.setImage(image, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(flagColorSelected(_:)), for: .touchUpInside)
            flagView.addSubview(button)
        }
        
        self.flagButton = flagButton
        // Flag button için uzun basma tanılayıcı ekleyin
        let flagLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(flagButtonLongPressed(_:)))
        flagLongPressRecognizer.minimumPressDuration = 0.5 // Uzun basma süresi (0.5 saniye)
        flagButton.addGestureRecognizer(flagLongPressRecognizer)
    }
    
    @objc func flagButtonTapped() {
        print("Flag butonu tıklandı")
        if let flagView = flagSelectionView, let flagButton = flagButton {
            flagView.isHidden = !flagView.isHidden
            if (!flagView.isHidden) {
                // Flag view'i flagButton'un üstünde konumlandır
                let flagButtonFrame = flagButton.superview?.convert(flagButton.frame, to: flagView.superview) ?? CGRect.zero
                flagView.frame.origin = CGPoint(x: flagButtonFrame.midX - flagView.frame.width / 2, y: flagButtonFrame.minY - flagView.frame.height - 10)
            }
        }
    }
    
    @objc func flagButtonLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            print("Flag butonuna uzun basıldı")
            // Titreşim ver
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            // Flag butonunun rengini sıfırla
            resetFlagButtonColor()
        }
    }
    
    @objc private func flagColorSelected(_ sender: UIButton) {
        print("Flag rengi seçildi: \(sender.tag)")
        let colors: [UIColor] = [.red, .orange, .yellow, .white]
        let selectedColor = colors[sender.tag]
        if let flagButton = self.flagButton {
            let image = UIImage(systemName: "flag.fill")?.withTintColor(selectedColor, renderingMode: .alwaysOriginal)
            flagButton.setImage(image, for: .normal)
        }
        flagSelectionView?.isHidden = true
    }
    
    func resetFlagButtonColor() {
        guard let flagButton = self.flagButton else { return }
        let image = UIImage(systemName: "flag")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        flagButton.setImage(image, for: .normal)
    }
}
*/

import UIKit
import AudioToolbox

class FlagManager {
    static let shared = FlagManager()
    
    private init() {}
    
    var flagSelectionView: UIView?
    var flagButton: UIButton?
    
    func setupFlagSelectionView(in view: UIView, flagButton: UIButton) {
        let flagView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 190))
        flagView.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        flagView.layer.cornerRadius = 10
        flagView.isHidden = true
        view.addSubview(flagView)
        flagSelectionView = flagView
        
        let colors: [UIColor] = [.red, .orange, .yellow, .white]
        let systemNames = ["flag.fill", "flag.fill", "flag.fill", "flag.fill"]
        
        let buttonHeight: CGFloat = 40
        let buttonSpacing: CGFloat = 1
        
        for (index, color) in colors.enumerated() {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 10, y: CGFloat(index) * (buttonHeight + buttonSpacing) + 10, width: 40, height: buttonHeight)
            let image = UIImage(systemName: systemNames[index])?.withTintColor(color, renderingMode: .alwaysOriginal)
            button.setImage(image, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(flagColorSelected(_:)), for: .touchUpInside)
            flagView.addSubview(button)
        }
        
        self.flagButton = flagButton
        let flagLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(flagButtonLongPressed(_:)))
        flagLongPressRecognizer.minimumPressDuration = 0.5
        flagButton.addGestureRecognizer(flagLongPressRecognizer)
    }
    
    @objc func flagButtonTapped() {
        print("Flag butonu tıklandı")
        if let flagView = flagSelectionView, let flagButton = flagButton {
            flagView.isHidden = !flagView.isHidden
            if (!flagView.isHidden) {
                let flagButtonFrame = flagButton.superview?.convert(flagButton.frame, to: flagView.superview) ?? CGRect.zero
                flagView.frame.origin = CGPoint(x: flagButtonFrame.midX - flagView.frame.width / 2, y: flagButtonFrame.minY - flagView.frame.height - 10)
            }
        }
    }
    
    @objc func flagButtonLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            print("Flag butonuna uzun basıldı")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            resetFlagButtonColor()
        }
    }
    
    @objc private func flagColorSelected(_ sender: UIButton) {
        print("Flag rengi seçildi: \(sender.tag)")
        let colors: [UIColor] = [.red, .orange, .yellow, .white]
        let selectedColor = colors[sender.tag]
        if let flagButton = self.flagButton {
            let image = UIImage(systemName: "flag.fill")?.withTintColor(selectedColor, renderingMode: .alwaysOriginal)
            flagButton.setImage(image, for: .normal)
        }
        flagSelectionView?.isHidden = true
        
        // Notification gönder
        NotificationCenter.default.post(name: .flagColorSelected, object: nil, userInfo: ["selectedIndex": sender.tag])
    }
    
    func resetFlagButtonColor() {
        guard let flagButton = self.flagButton else { return }
        let image = UIImage(systemName: "flag")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        flagButton.setImage(image, for: .normal)
    }
}

extension Notification.Name {
    static let flagColorSelected = Notification.Name("flagColorSelected")
}
