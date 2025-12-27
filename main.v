module main

import flag
import os

import pkg.argparse

const version = '2.0.0'

fn main() {
	cfg, no_matches := flag.to_struct[argparse.Config](os.args, skip: 1)!
	if no_matches.len > 0 {
		println('The following flags could not be mapped to any fields on the struct: ${no_matches}')
	}

	// Handle help and version flags
	if cfg.show_help {
		doc := flag.to_doc[argparse.Config]()!
		println(doc)
		exit(0)
	} else if cfg.show_version {
		println(version)		
	}

	exit(0)
}
