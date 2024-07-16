import UIKit

class RecurringEventViewController: UIViewController {

    // Yeni view'lerin ekleneceği stack view
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    
    // Eklenecek view'lerin yüksekliği
    let viewHeight: CGFloat = 50.0
    
    // Eklenen view sayacını takip etmek için değişken
    var viewCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Scroll view'in özelliklerini ayarla
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Scroll view için Auto Layout kısıtlamaları
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
        
        // Stack view'in özelliklerini ayarla
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack view'i scroll view'e ekle
        scrollView.addSubview(stackView)
        
        // Stack view için Auto Layout kısıtlamaları
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Buton oluştur ve ekle
        let button = UIButton(type: .system)
        button.setTitle("View Ekle", for: .normal)
        button.addTarget(self, action: #selector(addView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        // Buton için Auto Layout kısıtlamaları
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func addView() {
        // Yeni bir view oluştur
        let newView = UIView()
        newView.backgroundColor = .red
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        // Yeni view'e label ekle
        let label = UILabel()
        label.text = "View Count: \(viewCount + 1)"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        newView.addSubview(label)
        
        // Label için Auto Layout kısıtlamaları
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: newView.centerYAnchor)
        ])
        
        // Yeni view'i stack view'e ekle
        stackView.addArrangedSubview(newView)
        
        // Eklenen view sayısını artır
        viewCount += 1
        
        // 11. view eklendiğinde scroll view'i son view'e kaydır
        if viewCount >= 11 {
            scrollView.layoutIfNeeded()
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
}

