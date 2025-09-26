import * as vscode from 'vscode';
import { LastOpenedEditorAction } from './enums/LastOpenedEditorAction';

class Commands {
	/**  `vsc-augment:keybind-combine:rename-quickFix` registered in package.json to: `ctrl+.`  */
	static KEYBIND_COMBINE__RENAME_QUICKFIX = "vsc-augment:keybind-combine:rename-quickFix";

	/**  `vsc-augment:keybind-combine:find-findReplace` registered in package.json to: `ctrl+f`  */
	static KEYBIND_DOUBLE_TAP__CTRL_F       = "vsc-augment:keybind-combine:find-findReplace"
}


let lastOpened = LastOpenedEditorAction.None;
let timer: NodeJS.Timeout|null = null;

export function activate(context:vscode.ExtensionContext) {
	context.subscriptions.push(
		vscode.commands.registerTextEditorCommand(Commands.KEYBIND_COMBINE__RENAME_QUICKFIX, async (editor, edit, args) => {
			if (lastOpened === LastOpenedEditorAction.None || lastOpened === LastOpenedEditorAction.QuickFix) {
				await vscode.commands.executeCommand('editor.action.rename');
				lastOpened = LastOpenedEditorAction.Rename
			}
			else if(lastOpened == LastOpenedEditorAction.Rename) {
				await vscode.commands.executeCommand('editor.action.quickFix');
				lastOpened = LastOpenedEditorAction.QuickFix
			}
		})
	);
	context.subscriptions.push(
		vscode.commands.registerTextEditorCommand(Commands.KEYBIND_DOUBLE_TAP__CTRL_F, async (editor, edit, args) => {
			if (!timer) {	/*  ctrl+f tapped first time within 1000ms  */
				await vscode.commands.executeCommand("actions.find");
				timer = setTimeout(() => {
					timer = null;
				}, 1000);
			} else {
				clearTimeout(timer);
				timer = null;
				await vscode.commands.executeCommand("editor.action.startFindReplaceAction");
			}
		})
	);
}

// This method is called when your extension is deactivated
export function deactivate() {}
