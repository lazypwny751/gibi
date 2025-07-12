package tests

import (
	"os"
	"testing"
	
	"github.com/lazypwny751/gibi/pkg/config"
)

func TestLoadConfig(t *testing.T) {
	configFile := "example/config.yml"
	cfg, err := config.LoadConfig(configFile)
	if err != nil {
		t.Fatalf("Failed to load config: %v", err)
	}

	if cfg.Package == "" {
		t.Error("Package field is empty")
	}
	if cfg.Version == "" {
		t.Error("Version field is empty")
	}
	if cfg.Author == "" {
		t.Error("Author field is empty")
	}
	if cfg.Build == "" {
		t.Error("Build field is empty")
	}
	if cfg.Description == "" {
		t.Error("Description field is empty")
	}
}

func TestConfigFileExists(t *testing.T) {
	configFile := "example/config.yml"
	if _, err := os.Stat(configFile); os.IsNotExist(err) {
		t.Fatalf("Config file %s does not exist", configFile)
	}
}