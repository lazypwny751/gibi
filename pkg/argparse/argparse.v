module argparse

@[footer: 'gibi - Git Based Innovative Package Manager']
@[xdoc: '(Gi)t (B)ased (I)nnovative Package Manager']
@[version: version]
@[name: 'gibi']
pub struct Config {
pub:
	show_version bool   @[help: 'Show version information'; long: 'version'; short: 'v']
	show_help    bool   @[help: 'Show help information'; long: 'help'; short: 'h']
	install      bool   @[help: 'Install packages'; long: 'install'; short: 'i']
	uninstall    bool   @[help: 'Uninstall packages'; long: 'uninstall'; short: 'u']
	update       bool   @[help: 'Update packages'; long: 'update'; short: 'U']
	list         bool   @[help: 'List installed packages'; long: 'list'; short: 'l']
	info         bool   @[help: 'Show information about packages'; long: 'info'; short: 'I']
	moo          bool   @[help: 'Show a cow saying moo'; long: 'moo']
	prefix       string @[help: 'Specify installation prefix'; long: 'prefix'; short: 'p']
}
