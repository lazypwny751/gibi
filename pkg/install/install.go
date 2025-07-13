package install

import (
	"fmt"
	"os"

	"path/filepath"
	"github.com/lazypwny751/gibi/pkg/config"
	"github.com/lazypwny751/gibi/pkg/build"
	// git "github.com/go-git/go-git/v5"
)

// InstallPackages installs the specified packages based on the provided configuration.
func InstallPackages(pkgs []string) error {
	if len(pkgs) == 0 {
		return fmt.Errorf("no packages specified for installation")
	}

	for _, pkg := range pkgs {
		// fmt.Printf("Selecting given parameter: %s\n", pkg) // Debugging line to show the package being processed
		
		if config.IsPath(pkg) {
			// If the package is a local path, check if it exists
			if _, err := os.Stat(pkg); !os.IsNotExist(err) {
				conf, _ := config.LoadConfig(pkg)
				fmt.Printf("Installing package from local path: %s\n", conf.Package)

				if err := build.BuildPackage(*conf, filepath.Dir(pkg)); err != nil {
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