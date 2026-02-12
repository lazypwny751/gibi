module main

import flag
import log
import os { abs_path, home_dir, join_path, real_path }
import pkg.argparse
import pkg.config { set_opmode }
import pkg.install { install_packages }

const version = '2.0.0'

fn main() {
	cfg, pos := flag.to_struct[argparse.Config](os.args, skip: 1)!

	prefix := match string(cfg.prefix) {
		'', ' ' { abs_path(real_path(join_path(home_dir(), '.local/share/gibi'))) }
		else { abs_path(real_path(join_path(cfg.prefix))) }
	}

	// Handle help and version flags
	if cfg.show_help {
		doc := flag.to_doc[argparse.Config](
			version: version
			name:    'gibi'
			fields:  {
				'show_version': 'Show version information'
				'show_help':    'Show help information'
				'install':      'Install packages, "<pkg1> <pkg2> ..."'
				'uninstall':    'Uninstall packages,  "<pkg1> <pkg2> ..."'
				'update':       'Update packages, "<pkg1> <pkg2> ..."'
				'list':         'List installed packages'
				'info':         'Show information about packages, "<pkg1> <pkg2> ..."'
			}
		)!
		println(doc)
		exit(0)
	} else if cfg.show_version {
		println(version)
	} else if cfg.moo {
		println('         (__)\n         (oo)\n   /------\\/ \n  / |    ||  \n *  /\\---/\\  \n    ~~   ~~  \nMoo!')
		exit(0)
	}

	// Determine operation mode
	opmode := set_opmode(cfg.install, cfg.uninstall, cfg.update, cfg.list, cfg.info)

	match opmode {
		.install {
			if install_packages(pos) == false {
				log.error('Package installation failed.')
				exit(1)
			}
		}
		.uninstall {
			if pos.len == 0 {
				eprintln('Error: No packages specified for uninstallation.')
				exit(1)
			}
			println('Uninstalling packages: ${pos.join(', ')}')
		}
		.update {
			if pos.len == 0 {
				eprintln('Error: No packages specified for update.')
				exit(1)
			}
			println('Updating packages: ${pos.join(', ')}')
		}
		.list {
			println('Listing installed packages...')
		}
		.info {
			if pos.len == 0 {
				eprintln('Error: No packages specified for info.')
				exit(1)
			}
			println('Showing info for packages: ${pos.join(', ')}')
		}
		else {
			eprintln('Error: No operation mode specified. Use -h for help.')
			exit(1)
		}
	}

	dump(prefix)
	exit(0)
}
