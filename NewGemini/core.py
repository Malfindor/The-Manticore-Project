import os
import ctype
if(os.name == 'POSIX'):
    geminiLib = CDLL("/lib/gemLib.so")
else:
    geminiLib = WinDLL(r"C:\Windows\System32")
