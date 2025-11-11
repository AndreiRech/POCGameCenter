//
//  SpeechManager.swift
//  POCGameKit
//
//  Created by Andrei Rech on 06/11/25.
//

import Foundation
import Speech

@MainActor
@Observable
class SpeechManager {
    
    // Objetos principais do Speech
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    
    // Para evitar comandos duplicados
    private var lastProcessedString: String = ""

    func startListening(matchManager: MatchManager) {
        // 1. Pedir autorização
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // Permissão de Microfone
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if !(authStatus == .authorized && granted) {
                        print("Erro: Permissões de voz ou microfone negadas.")
                        return
                    }
                    
                    // Se tivermos permissão, começamos a escutar
                    self.startRecording(matchManager: matchManager)
                }
            }
        }
    }

    private func startRecording(matchManager: MatchManager) {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Configura a sessão de áudio
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Erro ao configurar a sessão de áudio: \(error)")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Não foi possível criar o SFSpeechAudioBufferRecognitionRequest")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        lastProcessedString = "" // Reseta o processamento

        // Inicia a "Task" de reconhecimento
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
            guard let self = self, let result = result else {
                // Erro ou fim do áudio
                self?.stopListening()
                return
            }
            
            // Pega o texto mais recente
            let newText = result.bestTranscription.formattedString.lowercased()
            // Compara com o que já processamos para ver apenas as palavras novas
            let newWords = newText.replacingOccurrences(of: self.lastProcessedString, with: "")
            
            // Verifica os comandos
            if newWords.contains("aumente") || newWords.contains("aumentar") {
                print("Comando de voz: AUMENTE")
                matchManager.incrementCounter()
            } else if newWords.contains("diminua") || newWords.contains("diminuir") {
                print("Comando de voz: DIMINUA")
                matchManager.decrementCounter()
            }
            
            self.lastProcessedString = newText
            
            // Se for final, reinicia (opcional, mas bom para comandos contínuos)
            if result.isFinal {
                self.stopListening()
                self.startRecording(matchManager: matchManager)
            }
        }
        
        // Conecta o microfone ao recognition request
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        // Inicia o motor de áudio
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine não pôde ser iniciado: \(error)")
        }
    }

    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        
        // Tenta desativar a sessão de áudio
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Erro ao desativar sessão de áudio: \(error)")
        }
    }
}
