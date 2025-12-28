module config

pub enum OpMode {
	install
	uninstall
	update
	list
	info
	nil
}

pub struct Version {
pub:
	major	u8
	minor	u8
	patch	u8
}

pub fn set_opmode(install bool, uninstall bool, update bool, list bool, info bool) OpMode {
	if install {
		return OpMode.install
	} else if uninstall {
		return OpMode.uninstall
	} else if update {
		return OpMode.update
	} else if list {
		return OpMode.list
	} else if info {
		return OpMode.info
	} else {
		return OpMode.nil // Default to nil if none specified
	}
}