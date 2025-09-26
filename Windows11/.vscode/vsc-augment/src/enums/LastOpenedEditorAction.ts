/** Used by `vsc-augment:keybind-combine:rename-quickFix` to keep track of last editor.action opened by `ctrl+.` */
export enum LastOpenedEditorAction {
	Rename   = "rename",
	QuickFix = "quickfix",
	None     = "none"
}