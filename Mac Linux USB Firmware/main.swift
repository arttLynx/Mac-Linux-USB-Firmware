//
//  main.swift
//  Mac Linux USB Firmware
//
//  Created by Thomas Lynx on 16.05.2022.
//

//var test = String("\((fileName)!)Hello, world! ")
//print(test)

// TEST_PATH /Users/thomaslynx/Desktop/USB_DISK/manjaro-kde-21.2.5-minimal-220314-linux510.iso
import Foundation
var echo = "echo "
var eraseCmd = "sudo -S  diskutil eraseDisk MS-DOS LINUX "
var convertCmd1 = "hdiutil convert "
var convertCmd2 = " -format UDRW -o "

func safeShell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil

    try task.run() //<--updated
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

print("Введи путь к имени файла, который нужно записать на флешку. ВНИМАНИЕ! В пути к файлу не должно быть пробелов: ")
var fileName: String? = readLine()
print("Введи имя образа. Оно может быть любым: ")
//print(String("OHOHH: " + (fileName)!))
var fileNick: String? = readLine()
print("Введи номер диска: ")
var driveName: String? = readLine()
var drivePath = "/dev/disk" + (driveName)!
print("Необходим рут пароль. Не волнуйтесь, это безопасно: ")
var passwd: String? = readLine()
//var fullCommand1 = "echo " + (passwd)! + " | " + eraseCmd + drivePath
var fullCommand1 = "cd ~ && cd ISO_OBRAZEZ || mkdir ISO_OBRAZEZ && cd ISO_OBRAZEZ && hdiutil convert \((fileName)!) -format UDRW -o \((fileNick)!) && echo \((passwd)!) | sudo -S diskutil eraseDisk MS-DOS LINUX \(drivePath) && diskutil unmountDisk  \(drivePath) && echo \((passwd)!) | sudo -S dd if=\((fileName)!) of=\(drivePath) bs=1m"



//print("Введи имя диска: ")
//var fleshName: String? = readLine()
//var volumeName = "/Volumes/" + (fleshName)!
//print(volumeName)
do{
    try print(safeShell(fullCommand1)) // String(eraseCmd + drivePath)
}catch {
    print("\(error)") //handle or silence the error here
}
