import * as vscode from 'vscode';


// COMMANDS
const COMBINE_RENAME_QUICKFIX = 'vsc-augment:keybind-combine:rename-quickFix';


let counter = 0;

export function activate(context:vscode.ExtensionContext) {
	
	const disposable = vscode.commands.registerTextEditorCommand(COMBINE_RENAME_QUICKFIX, async (editor, edit, args) => {
		// if (counter % 2 === 1)
			await vscode.commands.executeCommand('editor.action.rename');
		// else
			await vscode.commands.executeCommand('editor.action.quickFix');

		counter++;
	});
	
	context.subscriptions.push(disposable);
}

// This method is called when your extension is deactivated
export function deactivate() {}
