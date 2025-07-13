package install

import (
	"fmt"
	"os"

	"path/filepath"
	"github.com/lazypwny751/gibi/pkg/config"
	// "github.com/lazypwny751/gibi/pkg/download"
)

func installPackage(pkg config.Config, src string) error {
	if src == "" {
		return fmt.Errorf("source path is required")
	}

	if pkg.Package == "" {
		return fmt.Errorf("package name is required")
	}

	if pkg.Version == "" {
		return fmt.Errorf("package version is required")
	}

	if pkg.Build == "" {
		return fmt.Errorf("package build information is required")
	}

	fmt.Printf("Installing package: %s\nSource: %s\n", pkg.Package, src)
	return nil
}

// InstallPackages installs the specified packages based on the provided configuration.
func InstallPackages(pkgs []string) error {
	if len(pkgs) == 0 {
		return fmt.Errorf("no packages specified for installation")
	}

	for _, pkg := range pkgs {
		fmt.Printf("Selecting given parameter: %s\n", pkg)
		
		if config.IsPath(pkg) {
			// If the package is a local path, check if it exists
			if _, err := os.Stat(pkg); !os.IsNotExist(err) {
				conf, _ := config.LoadConfig(pkg)
				fmt.Printf("Installing package from local path: %s\n", conf.Package)

				if err := installPackage(*conf, filepath.Dir(pkg)); err != nil {
					return fmt.Errorf("failed to install package from %s: %w", pkg, err)
				}
			} else {
				return fmt.Errorf("local path does not exist: %s", pkg)
			}
		} else if config.SetUrlType(pkg) != config.None {
			// If the package is a URL, handle it accordingly
			fmt.Printf("Installing from URL: %s\n", pkg)
		} else {
			// If the package is neither a valid path nor a URL, return an error
			return fmt.Errorf("invalid package format: %s", pkg)
		}
	}

	return nil
}

func UninstallPackages(pkgs []string) error {
	if len(pkgs) == 0 {
		return fmt.Errorf("no packages specified for uninstallation")
	}

	for _, pkg := range pkgs {
		fmt.Printf("Uninstalling package: %s\n", pkg)
	}

	return nil
}