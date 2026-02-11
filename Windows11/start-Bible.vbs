Set shell = CreateObject("WScript.Shell")
shell.CurrentDirectory = "C:\Users\stasp\Desktop\Bible-Vault\node"

shell.Run "pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command ""npx tsx .\http-server.ts""", 0, False