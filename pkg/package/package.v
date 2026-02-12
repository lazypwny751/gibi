module package

import toml
import pkg.config

struct Package {
	name        string
	version     config.Version
	description string
}

pub fn read_pkgconfig(path string, prefix string) Package {
	gibifile := toml.parse_file(path) or {
		panic('Failed to read package config file at ${path}: ${err}')
	}

	return Package{
		name:        gibifile.value('name').string()
		version:     config.Version{
			major: 0
			minor: 0
			patch: 0
		}
		description: gibifile.value('description').string()
	}
}
