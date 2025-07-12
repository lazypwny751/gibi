package base

import (
	"fmt"
	"os"
	"os/user"
)

var (
	usr, _ = user.Current()
	GibiDir  = usr.HomeDir + "/.gibi"
	CacheDir   = GibiDir + "/cache"
	PackageDir = GibiDir + "/pkg"
	BinDir    = GibiDir + "/bin"
)

func Setup(verbose bool) {
	for _, dir := range []string{GibiDir, CacheDir, PackageDir, BinDir} {
		if _, err := os.Stat(dir); os.IsNotExist(err) {
			err := os.MkdirAll(dir, 0755)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error creating directory %s: %v\n", dir, err)
				os.Exit(1)
			}
			if verbose {
				fmt.Println("Directory created:", dir)
			}
		} else if verbose {
			fmt.Println("Directory already exists:", dir)
		}
	}
}