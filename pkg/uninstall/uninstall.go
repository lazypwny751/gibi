package uninstall

import (
	"fmt"
)

func UninstallPackages(pkgs []string) error {
	if len(pkgs) == 0 {
		return fmt.Errorf("no packages specified for uninstallation")
	}

	for _, pkg := range pkgs {
		fmt.Printf("Uninstalling package: %s\n", pkg)
	}

	return nil
}