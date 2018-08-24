//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Sahil Jain on 06/08/18.
//  Copyright © 2018 Sahil Jain. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecoder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configuringUI(recordingLabelText: "Tap to Record", recordButtonState: true, stopButtonState: false)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configuringUI(recordingLabelText: "Recording...", recordButtonState: false, stopButtonState: true)
        
        //Code for recording audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecoder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecoder.delegate = self
        audioRecoder.isMeteringEnabled = true
        audioRecoder.prepareToRecord()
        audioRecoder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configuringUI(recordingLabelText: "Tap to Record", recordButtonState: true, stopButtonState: false)
        
        //Codeto stop recording audio
        audioRecoder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func configuringUI ( recordingLabelText: String, recordButtonState: Bool, stopButtonState: Bool ){
        recordingLabel.text = recordingLabelText
        recordButton.isEnabled = recordButtonState
        stopRecordingButton.isEnabled = stopButtonState
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecoder.url)
        } else {
            print("Recording not successful.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
}

