module install

pub fn install_packages(pkgs []string) bool {
	if pkgs.len == 0 {
		eprintln('Error: No packages specified for installation.')
		return false
	}

	for pkg in pkgs {
		println('Installing package: $pkg')
	}

	return true
}