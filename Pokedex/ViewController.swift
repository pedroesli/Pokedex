//
//  ViewController.swift
//  Pokedex
//
//  Created by Pedro Ésli Vieira do Nascimento on 17/08/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    struct OriginalTransform {
        let topImageOriginalT: CGAffineTransform
        let bottomImageOriginalT: CGAffineTransform
        let pokeballTopOriginalT: CGAffineTransform
        let pokeballBottomOriginalT: CGAffineTransform
    }

    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var pokeballTop: UIImageView!
    @IBOutlet weak var pokeballBottom: UIImageView!
    @IBOutlet weak var pokeballButton: UIButton!
    @IBOutlet weak var pokemonCollectionView: UICollectionView!
    
    var audioPlayer: AVAudioPlayer?
    var isPokedexOpened: Bool = false
    var originalTransforms: OriginalTransform!
    
    var data: Pokemons?
    
    override var canBecomeFirstResponder: Bool{
        get{
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.becomeFirstResponder()
        
        originalTransforms = OriginalTransform(
            topImageOriginalT: topImage.transform,
            bottomImageOriginalT: bottomImage.transform,
            pokeballTopOriginalT: pokeballTop.transform,
            pokeballBottomOriginalT: pokeballBottom.transform)
        
        
        let layout = UICollectionViewFlowLayout()
        pokemonCollectionView.collectionViewLayout = layout
        
        pokemonCollectionView.register(PokemonCollectionViewCell.nib(), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        
        pokemonCollectionView.delegate = self
        pokemonCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            let pokemonsRequest = PokemonsRequest(offset: 0,limit: 50)
            pokemonsRequest.getPokemons(completion: { [weak self] result in
                switch result{
                case .success(let pokemons):
                    self?.data = pokemons
                    self?.reloadCollectionView()
                case .failure(let error):
                    print(error)
                }
            })
        }
        
    }
    
    func reloadCollectionView(){
        DispatchQueue.main.async {
            self.pokemonCollectionView.reloadData()
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            if isPokedexOpened{
                closePokedex()
                collectionViewDisapearAnimation()
            } else {
                openPokedex()
                collectionViewApearAnimation()
            }
        }
    }
    
    @IBAction func pokeballPressed(_ sender: UIButton) {
        openPokedex()
        collectionViewApearAnimation()
    }
    
    //MARK: Open Pokedex
    func openPokedex(){
        pokeballButton.isHidden = true
        isPokedexOpened = true
        pokeballOpeningAudio()
        openAnimation()
    }
    
    func openAnimation(){
        pokeballOpenAnimation()
        topAndBottomOpenAnimation()
    }
    
    func topAndBottomOpenAnimation(){
        UIView.animate(withDuration: 1, delay: 0.3, options: .curveEaseIn) {
            self.topImage.transform = CGAffineTransform(translationX: 0, y: -self.topImage.frame.height)
            self.bottomImage.transform = CGAffineTransform(translationX: 0, y: self.bottomImage.frame.height)
        } completion: { done in

        }
        
    }
    
    func pokeballOpenAnimation(){
        let yPos = (self.view.frame.height / 2) + 100
        
        UIView.animate(withDuration: 1.5, delay: 0.3, options: .curveEaseIn) {
            self.pokeballTop.transform = CGAffineTransform(translationX: 0, y: -yPos)
            self.pokeballBottom.transform = CGAffineTransform(translationX: 0, y: yPos)
        } completion: { done in

        }
    }
    
    func pokeballOpeningAudio(){
        let pathToSound = Bundle.main.path(forResource: "pokemonOut", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
    
    //MARK: Close Pokedex
    func closePokedex(){
        pokeballButton.isHidden = false
        isPokedexOpened = false
        pokeballClosingAudio()
        closeAnimation()
    }
    
    func pokeballClosingAudio(){
        let pathToSound = Bundle.main.path(forResource: "pokemonReturn", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
    
    func closeAnimation(){
        topAndBottomCloseAnimation()
        pokeballCloseAnimation()
    }
    
    func topAndBottomCloseAnimation(){
        UIView.animate(withDuration: 1, delay: 0.3, options: .curveEaseIn) {
            
            self.topImage.transform = self.originalTransforms.topImageOriginalT
            self.bottomImage.transform = self.originalTransforms.bottomImageOriginalT
            
        }
    }
    
    func pokeballCloseAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseIn) {
            self.pokeballTop.transform = self.originalTransforms.pokeballTopOriginalT
            self.pokeballBottom.transform = self.originalTransforms.pokeballBottomOriginalT
        }
    }
    
    func collectionViewApearAnimation(){
        UIView.animate(withDuration: 1, delay: 0) {
            self.pokemonCollectionView.alpha = 1
        }
    }
    
    func collectionViewDisapearAnimation(){
        UIView.animate(withDuration: 1, delay: 0) {
            self.pokemonCollectionView.alpha = 0
        }
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clicked cell at: \(indexPath.row)")
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
        
        if data != nil {
            cell.setLabel(pokemon: (data?.results[indexPath.row])!)
        }
        
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
}
