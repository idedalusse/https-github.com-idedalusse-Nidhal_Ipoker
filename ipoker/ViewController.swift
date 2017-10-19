//----------------------//----------------------
import UIKit
//----------------------//----------------------
class ViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    //---la vue des cartes qui apparaisse --//
    @IBOutlet weak var slot_1: UIImageView!
    @IBOutlet weak var slot_2: UIImageView!
    @IBOutlet weak var slot_3: UIImageView!
    @IBOutlet weak var slot_4: UIImageView!
    @IBOutlet weak var slot_5: UIImageView!
    //---Variable pour creer des images --//
    var card_blur_1: UIImage!
    var card_blur_2: UIImage!
    var card_blur_3: UIImage!
    var card_blur_4: UIImage!
    var card_blur_5: UIImage!
    //---Vue du background--//
    @IBOutlet weak var bg_1: UIView!
    @IBOutlet weak var bg_2: UIView!
    @IBOutlet weak var bg_3: UIView!
    @IBOutlet weak var bg_4: UIView!
    @IBOutlet weak var bg_5: UIView!
    //---connexion pour montrer et disparaitre les cartes--//
    @IBOutlet weak var keep_1: UILabel!
    @IBOutlet weak var keep_2: UILabel!
    @IBOutlet weak var keep_3: UILabel!
    @IBOutlet weak var keep_4: UILabel!
    @IBOutlet weak var keep_5: UILabel!
    //---- connexion avec les bouttons mise, credits, Distribuer ---//
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    //--- Annimations des images blurs ---//
    var arrOfCardImages: [UIImage]!
    //--- tableau des images slots---//
    var arrOfSlotImageViews: [UIImageView]!
    //---tableau de toople assigne 0 ---//
    var deckOfCards = [(Int, String)]()
    //---tableau des arriere plants ---//
    var arrOfBackgrounds: [UIView]!
    //--- Variable qui represente le mot garder ----//
    var arrOfKeepLabels: [UILabel]!
    //--- variable pour savoir si on peux ou non selectionner les cartes  --//
    var permissionToSelectCards = false
     //--- variable pour la mise ---//
    var bet = 0
     //--- variable pour le credit ---//
    var credits = 2000
    //--- Variable pour gérer à quel moment ou le joueur es dans la partie --//
    var chances = 2
    //--- l'instontation de l'objet (creation d'un objet selon la classe) --//
    let pokerHands = PokerHands()
    //--- classe pour garder le score en memoire --//
    let saveScore = UserDefaultsManager()
    //---tableau de toople pour analyser les cartes --//
    var handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
    //---la main au hazard (global)--//
    var theHand = [(Int, String)]()
    //--- Méthode qui dit l'lorsque le document et prêt ainsi que l'interface que doit, on faire --//
    override func viewDidLoad() {
        //--- Methode l'orsque le document est pret --//
        super.viewDidLoad()
        //--- creer des objets a partir des images --//
        createCardObjectsFromImages()
        //--- Methode pour remplire tous les tableaux --//
        fillUpArrays()
        //---Dure de l'annimations--//
        prepareAnimations(duration: 0.5,
                          repeating: 5,
                          cards: arrOfCardImages)
        //--- style au slide les cartes la vue --//
        stylizeSlotImageViews(radius: 10,
                              borderWidth: 0.5,
                              borderColor: UIColor.black.cgColor,
                              bgColor: UIColor.yellow.cgColor)
        //---les arriere plans ---//
        stylizeBackgroundViews(radius: 10,
                               borderWidth: nil,
                               borderColor: UIColor.black.cgColor,
                               bgColor: nil)
        //---Methode qui creer le jeux de carte --//
        createDeckOfCards()
        //---
    }
    //---- 52 Toople pour 52 carte ---//
    func createDeckOfCards() {
        deckOfCards = [(Int, String)]()
        for a in 0...3 {
            let suits = ["d", "h", "c", "s"]
            for b in 1...13 {
                deckOfCards.append((b, suits[a]))
            }
        }
    }
    //--- Methode pour ImageView ---//
    func stylizeSlotImageViews(radius r: CGFloat,
                               borderWidth w: CGFloat,
                               borderColor c: CGColor,
                               bgColor g: CGColor!) {
        for slotImageView in arrOfSlotImageViews {
            slotImageView.clipsToBounds = true
            slotImageView.layer.cornerRadius = r
            slotImageView.layer.borderWidth = w
            slotImageView.layer.borderColor = c
            slotImageView.layer.backgroundColor = g
        }
    }
    //---- Methode pour les backgrounds ---//
    func stylizeBackgroundViews(radius r: CGFloat,
                                borderWidth w: CGFloat?,
                                borderColor c: CGColor,
                                bgColor g: CGColor?) {
        for bgView in arrOfBackgrounds {
            bgView.clipsToBounds = true
            bgView.layer.cornerRadius = r
            bgView.layer.borderWidth = w ?? 0
            bgView.layer.borderColor = c
            bgView.layer.backgroundColor = g
        }
    }
    //---- XXXXXXXXXXXXXXXXXXXXXXXXX----//
    func fillUpArrays() {
        arrOfCardImages = [card_blur_1, card_blur_2, card_blur_3, card_blur_4,
                           card_blur_5]
        arrOfSlotImageViews = [slot_1, slot_2, slot_3, slot_4, slot_5]
        arrOfBackgrounds = [bg_1, bg_2, bg_3, bg_4, bg_5]
        arrOfKeepLabels = [keep_1, keep_2, keep_3, keep_4, keep_5]
    }
    //------ Méthode pour appeler les cartes -----//
    func createCardObjectsFromImages() {
        card_blur_1 = UIImage(named: "blur_1.png")
        card_blur_2 = UIImage(named: "blur_2.png")
        card_blur_3 = UIImage(named: "blur_3.png")
        card_blur_4 = UIImage(named: "blur_4.png")
        card_blur_5 = UIImage(named: "blur_4.png")
    }
    //----- Methode pour mellonger les annimations ---//
    func prepareAnimations(duration d: Double,
                           repeating r: Int,
                           cards c: [UIImage]) {
        for slotAnimation in arrOfSlotImageViews {
            slotAnimation.animationDuration = d
            slotAnimation.animationRepeatCount = r
            slotAnimation.animationImages = returnRandomBlurCards(arrBlurCards: c)
        }
    }
    //------- Methode pour mellonger les cartes ------//
    func returnRandomBlurCards(arrBlurCards: [UIImage]) -> [UIImage] {
        var arrToReturn = [UIImage]()
        var arrOriginal = arrBlurCards
        for _ in 0..<arrBlurCards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(arrOriginal.count)))
            arrToReturn.append(arrOriginal[randomIndex])
            arrOriginal.remove(at: randomIndex)
        }
        return arrToReturn
    }
    //-------bouttons distribuer  ------//
    @IBAction func play(_ sender: UIButton) {
        //--- bloque si pas de chance ou si pas le boutton est griser
        if chances == 0 || dealButton.alpha == 0.5 {
            return
        } else {
            chances = chances - 1
        }
        //---partie de l'animation --//
        var allSelected = true
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                allSelected = false
                break
            }
        }
        if allSelected {
            displayRandomCards()
            return
        }
        //--- partie de l'animation --//
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                slotAnimation.startAnimating()
            }
        }
        //--- partie de l'animation --//
        Timer.scheduledTimer(timeInterval: 2.55,
                             target: self,
                             selector: #selector(displayRandomCards),
                             userInfo: nil,
                             repeats: false)
    }
    //-------- Affichage des cartes au hazard ---------
    @objc func displayRandomCards() {
        //---XXXXXXXXXXXXX
        theHand = returnRandomHand()
        //---XXXXXXXXXXXXXX
        let arrOfCards = createCards(theHand: theHand)
        //---XXXXXXXXXXXX
        displayCards(arrOfCards: arrOfCards)
        //--- Methode permissions de selectionner les cartes ---//
        permissionToSelectCards = true
        //---Methode pour preparation d'une nouvelle main --//
        prepareForNextHand()
        //---
    }
    //------ preparation  pour afficher la prochaine main ------//
    func prepareForNextHand() {
        //--- verifier si la chance egale 0 veux dire qu'il es pret a analyser la prochaine main --//
        if chances == 0 {
            permissionToSelectCards = false
            dealButton.alpha = 0.5
            resetCards()
            createDeckOfCards()
            handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
            chances = 2
            bet = 0
            betLabel.text = "MISE : 0"
        }
        //---
    }
    //------Qunad on vas montrer les cartes ----//
    func displayCards(arrOfCards: [String]) {
        //---si les cartes egale 0 l'utilisateur a deja choisi les cartes clique sur distribuer pour jouer les cartes --//
        var counter = 0
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1 {
                if chances == 0 {
                    handToAnalyse = removeEmptySlotsAndReturnArray()
                    handToAnalyse.append(theHand[counter])
                }
                //---annimation de l'image--//
                slotAnimation.image = UIImage(named: arrOfCards[counter])
            }
            counter = counter + 1
        }
        //--- fini la main,apres verifie et  voici la main a analyser --//
        if chances == 0 {
            verifyHand(hand: handToAnalyse)
        }
        //---
    }
    //------- la methoses pour enlever les vides retourne les tableaux ----------//
    func removeEmptySlotsAndReturnArray() -> [(Int, String)] {
        var arrToReturn = [(Int, String)]()
        for card in handToAnalyse {
            if card != (0, "") {
                arrToReturn.append(card)
            }
        }
        return arrToReturn
    }
    //----------- creation de cartes  -----------//
    func createCards(theHand: [(Int, String)]) -> [String] {
        //---
        let card_1 = "\(theHand[0].0)\(theHand[0].1).png"
        let card_2 = "\(theHand[1].0)\(theHand[1].1).png"
        let card_3 = "\(theHand[2].0)\(theHand[2].1).png"
        let card_4 = "\(theHand[3].0)\(theHand[3].1).png"
        let card_5 = "\(theHand[4].0)\(theHand[4].1).png"
        return [card_1, card_2, card_3, card_4, card_5]
        //---
    }
    //------------ methodes pour avoir 5 cartes au hazard-------------//
    func returnRandomHand() -> [(Int, String)] {
        //---
        var arrToReturn = [(Int, String)]()
        //---
        for _ in 1...5 {
            let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
            arrToReturn.append(deckOfCards[randomIndex])
            deckOfCards.remove(at: randomIndex)
        }
        //---
        return arrToReturn
        //---
    }
    //----------- Methodes de verification de la main  (QUINTE FLUSH ROYALE,CARRÉ.....) ---------------//
    func verifyHand(hand: [(Int, String)]) {
        if pokerHands.royalFlush(hand: hand) {
            calculateHand(times: 250, handToDisplay: "QUINTE FLUSH ROYALE")
        } else if pokerHands.straightFlush(hand: hand) {
            calculateHand(times: 50, handToDisplay: "QUINTE FLUSH")
        } else if pokerHands.fourKind(hand: hand) {
            calculateHand(times: 25, handToDisplay: "CARRÉ")
        } else if pokerHands.fullHouse(hand: hand) {
            calculateHand(times: 9, handToDisplay: "FULL")
        } else if pokerHands.flush(hand: hand) {
            calculateHand(times: 6, handToDisplay: "COULEUR")
        } else if pokerHands.straight(hand: hand) {
            calculateHand(times: 4, handToDisplay: "QUINTE")
        } else if pokerHands.threeKind(hand: hand) {
            calculateHand(times: 3, handToDisplay: "BRELAN")
        } else if pokerHands.twoPairs(hand: hand) {
            calculateHand(times: 2, handToDisplay: "DEUX PAIRES")
        } else if pokerHands.onePair(hand: hand) {
            calculateHand(times: 1, handToDisplay: "PAIRE")
        } else {
            calculateHand(times: 0, handToDisplay: "RIEN...")
        }
    }
    //------- Methode pour afficher les gains -------//
    func calculateHand(times: Int, handToDisplay: String) {
        credits += (times * bet)
        tempLabel.text = handToDisplay
        creditsLabel.text = "CRÉDITS: \(credits)"
    }
    //--- bouttons a cliquer pour selectionner les cartes --//
    @IBAction func cardsToHold(_ sender: UIButton) {
        //--- permission pour selection des cartes --//
        if !permissionToSelectCards {
            return
        }
        //--- pour ne pas afficher les cartes  off de la carte --//
        if arrOfBackgrounds[sender.tag].layer.borderWidth == 0.5 {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.0
            arrOfBackgrounds[sender.tag].layer.backgroundColor = nil
            arrOfKeepLabels[sender.tag].isHidden = true
            //--- Quand on veux selectionner les cartes False ---//
            manageSelectedCards(theTag: sender.tag, shouldAdd: false)
        } else {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 1.0
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderColor = UIColor.blue.cgColor
            arrOfBackgrounds[sender.tag].layer.backgroundColor = UIColor(red: 0.0,
                                                                         green: 0.0, blue: 1.0, alpha: 0.5).cgColor
            arrOfKeepLabels[sender.tag].isHidden = false
            //---Quand on veux selectionner les cartes true --//
            manageSelectedCards(theTag: sender.tag, shouldAdd: true)
        }
    }
    //------Methone pour selectionner ou des-selectionner les choix fait des cartes  ------//
    func manageSelectedCards(theTag: Int, shouldAdd: Bool) {
        if shouldAdd {
            handToAnalyse[theTag] = theHand[theTag]
        } else {
            handToAnalyse[theTag] = (0, "")
        }
    }
    //----Methode pour les deux bouttons mise Miser 25 et Miser 100 ---//
    @IBAction func betButtons(_ sender: UIButton) {
        //---
        if chances <= 1 {
            return
        }
        //---pour ne plus avoir de message au moment de cliquer sur le bouttons miser--//
        tempLabel.text = ""
        //---Methode pour la mise --//
        if sender.tag == 1000 {
            bet = credits
            betLabel.text = "MISE : \(bet)"
            credits = 0
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
            resetBackOfCards()
            return
        }
        //---avorter le script ne fera pas le reste (comme un break) --/
        let theBet = sender.tag
        //---
        if credits >= theBet {
            bet += theBet
            credits -= theBet
            betLabel.text = "MISE : \(bet)"
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
        }
        //---
        resetBackOfCards()
        //---
    }
    //----- remettre la face cacher des cartes ----//
    func resetBackOfCards() {
        for back in arrOfSlotImageViews {
            back.image = UIImage(named: "back.png")
        }
    }
    //-- toutes les cartes selectionner seron des-electionner --//
    func resetCards() {
        //---
        for index in 0...4 {
            arrOfSlotImageViews[index].layer.borderWidth = 0.5
            arrOfBackgrounds[index].layer.borderWidth = 0.0
            arrOfBackgrounds[index].layer.backgroundColor = nil
            arrOfKeepLabels[index].isHidden = true
        }
        //---
        chances = 2
        //---
    }
    //----------------------//----------------------
}
//----------------------//----------------------
