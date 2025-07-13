package main

import (
	"fmt"
	"os"

	// "github.com/lazypwny751/gibi/pkg/config"
	"github.com/lazypwny751/gibi/pkg/base"
	"github.com/lazypwny751/gibi/pkg/install"
	"github.com/lazypwny751/gibi/pkg/flag"
)

// main is the entry point of the Gibi application.
// It parses command-line flags and executes the appropriate actions based on the flags provided.
//
// Usage:
//
//	-v, --verbose: Enable verbose output.
//	-i, --install: Specify dependencies to install.
//	-u, --uninstall: Specify dependencies to uninstall.
//
// Example:
//
//	./gibi --verbose --install dep1,dep2
//	./gibi --uninstall dep3
func main() {
	// Initialize the base directory structure.
	
	// Load configuration file
	flags, err := flag.ParseFlags()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing flags: %v\n", err)
		os.Exit(1)
	}
	
	if flags.Verbose {
		fmt.Println("Verbose mode enabled.")
	}

	base.Setup(flags.Verbose)
	if len(flags.Install) > 0 {
		if err := install.InstallPackages(flags.Install); err != nil {
			fmt.Fprintf(os.Stderr, "Error installing packages: %v\n", err)
			os.Exit(1)
		}
	} else if len(flags.Uninstall) > 0 {
		fmt.Println("Uninstalling packages:", flags.Uninstall)
	}

	os.Exit(0)
}