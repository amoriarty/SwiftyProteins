//
//  ProteinController.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import UIKit
import ToolboxLGNT
import SceneKit

final class ProteinController: GenericViewController {
    private var ligandNode: SCNNode?
    var ligand: Ligand? {
        didSet {
            guard let ligand = ligand else { return }
            title = ligand.name
            generateModel(with: ligand)
        }
    }
    
    private let camera: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.position = SCNVector3(0, 0, 20)
        return node
    }()
    
    private lazy var scene: SCNScene = {
        let scene = SCNScene()
        scene.rootNode.addChildNode(camera)
        return scene
    }()
    
    private lazy var sceneView: SCNView = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let view = SCNView()
        view.allowsCameraControl = true
        view.scene = scene
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private let atomLabel: UILabel = {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let label = UILabel(frame: frame)
        label.backgroundColor = .gray
        label.textAlignment = .center
        label.textColor = .white
        label.alpha = 0
        label.font = .boldSystemFont(ofSize: 32)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    // MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    // MARK:- Setups
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = Colors.background
        view.addSubview(sceneView)
        view.addSubview(atomLabel)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        _ = sceneView.fill(view.safeAreaLayoutGuide)
    }
    
    private func setupNavBar() {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
        navigationItem.rightBarButtonItem = button
    }
    
    // MARK:- Scene Logics
    private func generateModel(with ligand: Ligand) {
        /* Remove ligand node before rebuild it and re-add it to root node. */
        ligandNode?.removeFromParentNode()
        ligandNode = SCNNode()
        
        /* Generate new models */
        generateModel(with: ligand.atoms)
        generateModel(with: ligand.links)
        
        /* Adding ligandNode to scene */
        scene.rootNode.addChildNode(ligandNode!)
    }
    
    private func generateModel(with atoms: [Atom]) {
        /* Adding all atoms into ligandNode */
        atoms.forEach { atom in
            let sphere = SCNSphere()
            let node = SCNNode(geometry: sphere)
            node.position = atom.position
            sphere.color = Colors.CPK[atom.type]
            ligandNode?.addChildNode(node)
        }
    }
    
    private func generateModel(with links: [Link]) {
        /* Adding all links between atoms */
        links.forEach { link in
            guard let left = ligand?.atoms[link.left - 1].position else { return }
            guard let right = ligand?.atoms[link.right - 1].position else { return }
            let height = left.distance(from: right)
            let cylinder = SCNCylinder(radius: 0.1, height: height)
            let node = SCNNode(geometry: cylinder)
            cylinder.color = .black
            
            /* Caculate link position and orientation */
            node.position = (left + right) / 2
            node.transform = nodeOrientation(left, right)
            ligandNode?.addChildNode(node)
        }
    }
    
    private func nodeOrientation(_ left: SCNVector3, _ right: SCNVector3) -> SCNMatrix4 {
        let lookat = right - left
        let y = lookat.normalized
        let up = lookat.cross(right).normalized
        let x = y.cross(up).normalized
        let z = x.cross(y).normalized
        let transform = SCNMatrix4(x: x, y: y, z: z, w: left)
        return SCNMatrix4MakeTranslation(0, lookat.lenght / 2, 0) * transform
    }
    
    // MARK:- Buttons handlers
    /* Take a snapshot from sceneView and share trought activity controller. */
    @objc func handleShare() {
        let image = sceneView.snapshot()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        /* Getting location in scene view, then hits */
        guard sender.state == .ended else { return }
        let location = sender.location(in: sceneView)
        let hits = sceneView.hitTest(location, options: nil)
        
        /* Unwrap node and atom from previous hit test */
        guard let node = hits.first?.node else { return }
        guard let atom = ligand?.atoms.first(where: { $0.position == node.position }) else { return }
        
        /* Setting up label with atom value.
         * Animate label to appear and disappear once everything is setup */
        atomLabel.text = atom.type.rawValue
        atomLabel.frame.origin = sender.location(in: view)
        atomLabel.frame.origin.x -= 15
        atomLabel.frame.origin.y -= 40
        animateAtomLabel()
    }
    
    // MARK:- Label animation logic
    private func animateAtomLabel() {
        /* Closure call on tap */
        let animatedOn = { [unowned self] in
            self.atomLabel.alpha = 1
        }
        
        /* Closure call after 3 seconds */
        let animatedOff = { [unowned self] in
            self.atomLabel.alpha = 0
        }
        
        /* Closure call by timer after 3 seconds.
         * It just launch animation. */
        let block: (Timer) -> Void = { _ in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: animatedOff, completion: nil)
        }
        
        /* Closure call after animation completed.
         * It launch the 3 seconds timer. */
        let animationCompletion: (Bool) -> Void = { _ in
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: block)
        }
        
        /* Finally call animation with previous closure. */
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: animatedOn, completion: animationCompletion)
    }
}
