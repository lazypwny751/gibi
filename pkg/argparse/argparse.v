module argparse

@[xdoc:    "(Gi)t (B)ased (I)nnovative Package Manager"]
@[footer:  "gibi - Git Based Innovative Package Manager"]
@[version: version]
@[name:    "gibi"]
pub struct Config {
pub:
	show_version bool @[short: 'v'; long: 'version'; help: 'Show version information']
	show_help    bool @[short: 'h'; long: 'help'; help: 'Show help information']
	install 	 bool @[short: 'i'; long: 'install'; help: 'Install packages']
	uninstall    bool @[short: 'u'; long: 'uninstall'; help: 'Uninstall packages']
	update       bool @[short: 'U'; long: 'update'; help: 'Update packages']
	list         bool @[short: 'l'; long: 'list'; help: 'List installed packages']
	info         bool @[short: 'I'; long: 'info'; help: 'Show information about packages']
	moo 	     bool @[long: 'moo'; help: 'Show a cow saying moo']
	prefix 	     string @[short: 'p'; long: 'prefix'; help: 'Specify installation prefix']
}
