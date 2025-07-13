package config

import (
	"os"
	"strings"

	"gopkg.in/yaml.v3"
)

type UrlType int

const (
	RawHTTP UrlType = iota
	Git
	GitSSH
	GitHub
	GitLab
	BitBucket
	None // Represents an invalid or unsupported URL type
)

// String returns the string representation of the UrlType.
func (u UrlType) String() string {
	return [...]string{"RawHTTP", "Git", "GitSSH", "GitHub", "GitLab", "BitBucket", "None"}[u]
}

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

func IsPath(str string) bool {
	if str[0] == '/' || str[0] == '.' {
		return true
	}
	return false
}

func SetUrlType(str string) UrlType {
	str = strings.TrimSpace(str)
	if str == "" {
		return None
	}

	if strings.HasPrefix(str, "http") || strings.HasPrefix(str, "www") {
		return RawHTTP
	} else if strings.HasPrefix(str, "git@") {
		return GitSSH
	} else if strings.HasPrefix(str, "git:") {
		return Git
	} else if strings.HasPrefix(str, "github.com") {
		return GitHub
	} else if strings.HasPrefix(str, "gitlab.com") {
		return GitLab
	} else if strings.HasPrefix(str, "bitbucket.org") {
		return BitBucket
	}
	return None
}