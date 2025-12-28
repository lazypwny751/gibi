package install

import (
	"fmt"
	"os"

	"path/filepath"
	"github.com/lazypwny751/gibi/pkg/config"
	"github.com/lazypwny751/gibi/pkg/build"
	// "github.com/lazypwny751/gibi/pkg/base"
	// git "github.com/go-git/go-git/v5"
)

type InstallConfig struct {
	Prefix string   `json:"prefix"`
}

func installPackageFromCache(pkg string, build_conf build.BuildConfig, install_conf InstallConfig) error {
	if _, err := os.Stat(build_conf.CacheDir); os.IsNotExist(err) {
		return fmt.Errorf("package not found in cache: %s", pkg)
	}

	fmt.Printf("Installing package from cache: %s\n", pkg)
	for _, entry := range build_conf.Entries {
		fmt.Printf("%s - %s\n", filepath.Join(build_conf.BuildDir, entry), filepath.Join(install_conf.Prefix, entry))
	}

	return nil
}

// InstallPackages installs the specified packages based on the provided configuration.
func InstallPackages(pkgs []string) error {
	install_conf := InstallConfig{
		Prefix: "/",
	}

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

				build_conf, err := build.BuildPackage(*conf, filepath.Dir(pkg))
				if err != nil {
					return fmt.Errorf("failed to build package from %s: %w", pkg, err)
				}

				if err := installPackageFromCache(conf.Package, build_conf, install_conf); err != nil {
					return fmt.Errorf("failed to install package from cache: %w", err)
				}

				fmt.Printf("Package %s installed successfully.\n", conf.Package)
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