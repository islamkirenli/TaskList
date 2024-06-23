import UIKit

class NewTaskButton {
    
    static func createNewTaskButton() -> UIButton {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "New Task"
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 30 // Padding between image and title
        configuration.imagePlacement = .trailing
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static func setupNewTaskButton(in view: UIView, target: Any?, action: Selector) {
        let newTaskButton = createNewTaskButton()
        view.addSubview(newTaskButton)
        
        NSLayoutConstraint.activate([
            newTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            newTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newTaskButton.heightAnchor.constraint(equalToConstant: 50),
            newTaskButton.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        newTaskButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

