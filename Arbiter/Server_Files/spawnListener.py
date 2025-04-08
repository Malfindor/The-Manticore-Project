#!/usr/bin/env python3
import os
import socket
import sys
def main():
    if (len(sys.argv) != 3):
        print("Input error")
        return
    TARGET_PORT = sys.argv[1]
    TARGET_SOURCETYPE = sys.argv[2]
    instructions = getSourceTypeInstructions(TARGET_SOURCETYPE)
    createService(TARGET_PORT, instructions)
       
def getSourceTypeInstructions(sourcetype):
    
    
def createService(port, sourcetypeInstructions):
    listenerScriptContents = f"""
#!/usr/bin/env python3
import os
import socket
import datetime
import xml.etree.ElementTree as ET
def main():

    listenSocket = socket.create_server(('0.0.0.0', {port}))
    listenSocket.listen()
    conn = listenSocket.accept()
    
    address = conn[1]
    currentTime = datetime.now()
    logString = '[' + currentTime + '] - A connection was logged from: ' + address + ' using port: {port}'
    logFile = open('/var/arbiter/connections.log', 'w')
    logFile.write(logString)
    
    message = (conn.recv(4096)).decode('utf-8')
    processedMessage = processInput(message)
    
    root = ET.Element('root')
    
    for item in processedMessage:
    name, value = item
    item_element = ET.SubElement(root, 'item')
    name_element = ET.SubElement(item_element, 'name')
    name_element.text = name
    value_element = ET.SubElement(item_element, 'value')
    value_element.text = value
    
    tree = ET.ElementTree(root)
    
    currentTime = datetime.now()
    filePath = '/var/log/arbiter/log-{port}-' + currentTime
    tree.write(filePath)
    
    os.system('cp ' + filePath + ' /var/log/arbiterHistory/log-{port}-' + currentTime)
    
    
def processInput(input):
    
    {sourcetypeInstructions}
    
main()

"""
    listenerFile = open(f"/opt/arbiter/bin/listener{TARGET_PORT}", "w")
    listenerFile.write(listenerScriptContents)
    return 0
main()