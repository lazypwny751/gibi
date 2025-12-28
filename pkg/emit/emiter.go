package emiter

// import (
// 	"fmt"
// 	"runtime"

// 	"os/exec"
// )

// func EmitPackage() error {
// 	fmt.Println("runtime.GOOS:", runtime.GOOS)
// 	return nil
// }

// func emit2Debian() error {
// 	if _, err := exec.LookPath("dpkg-deb"); err != nil {
// 		return fmt.Errorf("dpkg-deb command not found: %w", err)
// 	}

// 	return nil
// }

// func emit2Docker() error {
// 	if _, err := exec.LookPath("docker"); err != nil {
// 		return fmt.Errorf("docker command not found: %w", err)
// 	}

// 	return nil
// }