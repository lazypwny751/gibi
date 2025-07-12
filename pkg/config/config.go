package config

import (
	"gopkg.in/yaml.v3"
	"os"
)

type Config struct {
	Package     string `yaml:"package"`
	Version     string `yaml:"version"`
	Author      string `yaml:"author"`
	Build       string `yaml:"build"`
	Description string `yaml:"description"`
}

func LoadConfig(filePath string) (*Config, error) {
	data, err := os.ReadFile(filePath)
	if err != nil {
		return nil, err
	}

	var config Config
	err = yaml.Unmarshal(data, &config)
	if err != nil {
		return nil, err
	}

	return &config, nil
}
