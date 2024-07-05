import UIKit

class RouterViewController: UIViewController {
    
    @IBOutlet weak var newTaskContainerView: UIView!
    @IBOutlet weak var recurringEventContainerView: UIView!
    @IBOutlet weak var habitContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Başlangıçta ilk container view'i göster
        updateViewVisibility(selectedIndex: 0)
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        updateViewVisibility(selectedIndex: sender.selectedSegmentIndex)
    }
    
    private func updateViewVisibility(selectedIndex: Int) {
        newTaskContainerView.isHidden = selectedIndex != 0
        recurringEventContainerView.isHidden = selectedIndex != 1
        habitContainerView.isHidden = selectedIndex != 2
    }
}
