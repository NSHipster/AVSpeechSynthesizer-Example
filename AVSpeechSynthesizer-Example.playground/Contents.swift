import UIKit
import AVFoundation
import PlaygroundSupport

class ViewController: UIViewController {
    let synthesizer: AVSpeechSynthesizer
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: self.view.bounds)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        return pickerView
    }()
    
    lazy var utterranceLabel: UILabel = {
        var label = UILabel(frame: self.view.bounds)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var transliterationLabel: UILabel = {
        var label = UILabel(frame: self.view.bounds)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var stackView: UIStackView = {
        var stackView = UIStackView(frame: self.view.bounds)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        stackView.addArrangedSubview(self.pickerView)
        stackView.addArrangedSubview(self.utterranceLabel)
        stackView.addArrangedSubview(self.transliterationLabel)

        return stackView
    }()
    
    init() {
        self.synthesizer = AVSpeechSynthesizer()
        
        super.init(nibName: nil, bundle: nil)
        
        self.synthesizer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public override func loadView() {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 320.0, height: 400)))
        view.backgroundColor = .white
        self.view = view
        
        self.view.addSubview(self.stackView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let randomRow = (0..<LanguageSample.all.endIndex).randomElement()!
        self.pickerView.selectRow(randomRow, inComponent: 0, animated: false)
        self.pickerView(self.pickerView, didSelectRow: randomRow, inComponent: 0)
    }
}

extension ViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LanguageSample.all.count
    }
}

extension ViewController: UIPickerViewDelegate {
    // MARK: UIPickerViewDelegate
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let sample = LanguageSample.all[row]
        
        let localizedLanguageName = Locale.current.localizedString(forLanguageCode: sample.languageCode)!
        
        return "\(localizedLanguageName) (\(sample.languageCode))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.synthesizer.stopSpeaking(at: .immediate)

        let sample = LanguageSample.all[row]
        self.utterranceLabel.text = sample.text
        self.transliterationLabel.text = sample.transliteratedText

        let utterance = AVSpeechUtterance(string: sample.text)
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        utterance.preUtteranceDelay = 0.25;
        utterance.postUtteranceDelay = 0.25;
        utterance.voice = AVSpeechSynthesisVoice(language: sample.languageCode)

        self.synthesizer.speak(utterance)
    }
}

extension ViewController: AVSpeechSynthesizerDelegate {
    private func attributedString(from string: String, highlighting characterRange: NSRange) -> NSAttributedString {
        guard characterRange.location != NSNotFound else {
            return NSAttributedString(string: string)
        }
        
        let mutableAttributedString = NSMutableAttributedString(string: string)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: characterRange)
        return mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        self.utterranceLabel.attributedText = attributedString(from: utterance.speechString, highlighting: characterRange)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.utterranceLabel.attributedText = NSAttributedString(string: utterance.speechString)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.utterranceLabel.attributedText = NSAttributedString(string: utterance.speechString)
    }
}

let viewController = ViewController()

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = viewController.view
