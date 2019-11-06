import UIKit

class KeyboardViewController: UIInputViewController {

    var cellView: CellView!
    var previewView: PreviewView!
    
    var previousSummary = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CellView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        cellView = objects.first as? CellView
        guard let inputView = inputView else { return }
        inputView.addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.leftAnchor.constraint(equalTo: inputView.leftAnchor),
            cellView.topAnchor.constraint(equalTo: inputView.topAnchor),
            cellView.rightAnchor.constraint(equalTo: inputView.rightAnchor),
            cellView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
            ])

        cellView.setNextKeyboardVisible(true) // MANUAL OVERRIDE DURING DEVELOP
//        keyboardView.setNextKeyboardVisible(needsInputModeSwitchKey)
        cellView.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .allTouchEvents)
        cellView.sendButton.addTarget(self, action: #selector(sendSummary), for: .allTouchEvents)
        
        
    }
    
    @objc func sendSummary() {
        guard let summary = cellView.summary, summary != previousSummary else { return }
        self.previousSummary = summary
        textDocumentProxy.insertText(summary)
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }

}
