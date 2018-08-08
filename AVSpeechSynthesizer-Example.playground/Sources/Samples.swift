import NaturalLanguage

let samplesByLanguage: [NLLanguage: String] = [
    .arabic: "لَيْسَ حَيَّاً مَنْ لَا يَحْلُمْ",
    .czech: "Kolik jazyků znáš, tolikrát jsi člověkem.",
    .danish: "Enhver er sin egen lykkes smed.",
    .dutch: "Wie zijn eigen tuintje wiedt, ziet het onkruid van een ander niet",
    .german: "Die beste Bildung findet ein gescheiter Mensch auf Reisen.",
    .greek: "Ἐν οἴνῳ ἀλήθεια",
    .english: "All the world's a stage, and all the men and women merely players",
    .finnish: "On vähäkin tyhjää parempi.",
    .french: "Le plus grand faible des hommes, c'est l'amour qu'ils ont de lavie.",
    .hindi: "जान है तो जहान है",
    .hungarian: "Ki korán kel, aranyat lel|Aki korán kel, aranyat lel.",
    .indonesian: "Jadilah kumbang, hidup sekali di taman bunga, jangan jadi lalat hidup:skali di bukit sampah.",
    .italian: "Finché c'è vita c'è speranza.",
    .japanese: "天に星、地に花、人に愛",
    .korean: "손바닥으로 하늘을 가리려한다",
    .norwegian: "D'er mange ǿksarhogg, som eiki skal fella.",
    .polish: "Co lekko przyszło, lekko pójdzie.",
    .portuguese: "É de pequenino que se torce o pepino.",
    .romanian: "Cine se scoală de dimineață, departe ajunge.",
    .russian: "Челове́к рожда́ется жить, а не гото́виться к жи́зни.",
    .slovak: "Každy je sám svôjho št'astia kováč.",
    .spanish: "La vida no es la que uno vivió, sino la que uno recuerda, y cómola recu:ra para contarla.",
    .swedish: "Verkligheten överträffar dikten.",
    .thai: "ความลับไม่มีในโลก",
    .turkish: "Al elmaya taş atan çok olur.",
    .simplifiedChinese: "小洞不补，大洞吃苦。",
    .traditionalChinese: "风向转变时、\n有人筑墙、\n有人造风车。"
]

public struct LanguageSample: Equatable, Hashable {
    public static let all: [LanguageSample] = {
        return samplesByLanguage.map {
            LanguageSample(language: $0.0, text: $0.1)
        }.sorted()
    }()
    
    public let languageCode: String
    public let text: String
    public let transliteratedText: String?
    
    init(language: NLLanguage, text: String) {
        self.languageCode = language.rawValue
        self.text = text
        
        if let transliteratedText = text.applyingTransform(.toLatin, reverse: false),
            text != transliteratedText
        {
            self.transliteratedText = transliteratedText
        } else {
            self.transliteratedText = nil
        }
    }
}

extension LanguageSample: Comparable {
    public static func < (lhs: LanguageSample, rhs: LanguageSample) -> Bool {
        return lhs.languageCode < rhs.languageCode
    }
}
