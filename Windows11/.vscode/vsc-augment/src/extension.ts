import * as vscode from 'vscode';
import { LastOpenedEditorAction } from './enums/LastOpenedEditorAction';


let lastOpened = LastOpenedEditorAction.None;

export function activate(context:vscode.ExtensionContext) {
	
	/* vsc-augment:keybind-combine:rename-quickFix also registered in package.json to: ctrl+. */
	const disposable = vscode.commands.registerTextEditorCommand("vsc-augment:keybind-combine:rename-quickFix", async (editor, edit, args) => {
		if (lastOpened === LastOpenedEditorAction.None || lastOpened === LastOpenedEditorAction.QuickFix) {
			await vscode.commands.executeCommand('editor.action.rename');
			lastOpened = LastOpenedEditorAction.Rename
		}
		else if(lastOpened == LastOpenedEditorAction.Rename) {
			await vscode.commands.executeCommand('editor.action.quickFix');
			lastOpened = LastOpenedEditorAction.QuickFix
		}
	});
	
	context.subscriptions.push(disposable);
}

// This method is called when your extension is deactivated
export function deactivate() {}
