//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Travis McCormick on 6/23/17.
//  Copyright © 2017 TravisMcCormick. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
  
  var audioRecorder: AVAudioRecorder!
  
  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var recordingButton: UIButton!
  @IBOutlet weak var stopRecordingButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    stopRecordingButton.isEnabled = false
  }
  
  
  func configureUI(_ isRecording: Bool) {

    recordingLabel.text = isRecording ? "Recording in Progress" : "Press to Record"
    recordingButton.isEnabled = isRecording ? false : true
    stopRecordingButton.isEnabled = isRecording ? true : false
  }
  
  @IBAction func recordAudio(_ sender: AnyObject) {
    configureUI(true)
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = URL(string: pathArray.joined(separator: "/"))
    
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
    
    try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    audioRecorder.delegate = self
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
  }
  
  @IBAction func stopRecording(_ sender: Any) {
    configureUI(false)
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag {
      performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    } else {
      print("recording was not successful")
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "stopRecording" {
      let playSoundsVC = segue.destination as! PlaySoundsViewController
      let recordedAudioURL = sender as! URL
      playSoundsVC.recordedAudioURL = recordedAudioURL
    }
  }
  
}

