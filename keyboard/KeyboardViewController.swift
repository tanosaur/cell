import UIKit

class KeyboardViewController: UIInputViewController {

    var keyboardView: KeyboardView!
    var previousSummary = ""
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        keyboardView = objects.first as? KeyboardView
        guard let inputView = inputView else { return }
        inputView.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardView.leftAnchor.constraint(equalTo: inputView.leftAnchor),
            keyboardView.topAnchor.constraint(equalTo: inputView.topAnchor),
            keyboardView.rightAnchor.constraint(equalTo: inputView.rightAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
            ])

        keyboardView.setNextKeyboardVisible(true) // MANUAL OVERRIDE DURING DEVELOP
//        keyboardView.setNextKeyboardVisible(needsInputModeSwitchKey)
        keyboardView.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .allTouchEvents)
        keyboardView.sendButton.addTarget(self, action: #selector(sendSummary), for: .allTouchEvents)
    }
    
    @objc func sendSummary() {
        guard let summary = keyboardView.summary, summary != previousSummary else { return }
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
