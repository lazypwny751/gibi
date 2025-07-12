# gibi

> _"Simple package management, done right."_

**gibi** is a fast and lightweight package manager written in Go. Install and manage software packages from Git repositories with minimal configuration.

## ✨ Features

- ⚡ Fast and lightweight Go implementation
- 📦 YAML-based package configuration
- 🔧 Simple install/uninstall operations
- 🎯 Git repository support
- 🛠️ Cross-platform compatibility

## 🚀 Quick Start

### Build

```bash
./build.sh
```

### Usage

```bash
# Install packages
./gibi -i package1,package2

# Uninstall packages  
./gibi -u package1,package2

# Verbose output
./gibi -v -i package1
```

### Package Configuration

Create a `gibi.yml` file in your repository:

```yaml
package: myapp
version: 1.0.0
author: username
description: My awesome application
build: |
  mkdir -p "${GIBI_BUILD}/usr/bin"
  go build -o "${GIBI_BUILD}/usr/bin/myapp"
```

## 🔧 Development

### Requirements

- Go 1.22.2 or later
- Git

### Project Structure

```
gibi/
├── cmd/main.go           # Application entry point
├── pkg/
│   ├── config/           # YAML configuration handling
│   ├── download/         # Package download logic
│   ├── flag/             # Command-line flag parsing
│   ├── install/          # Package installation
│   └── uninstall/        # Package removal
├── build.sh              # Build script
└── gibi.yml              # Package definition
```

## 🤝 Contributing

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/awesome-feature`)
3. Commit your changes (`git commit -m 'Add awesome feature'`)
4. Push to the branch (`git push origin feature/awesome-feature`)
5. Open a pull request

## 📜 License

This project is licensed under the [GNU GPLv3 License](LICENSE).

---

> **Repository:** [github.com/lazypwny751/gibi](https://github.com/lazypwny751/gibi)  
> **Maintained with** ☕ **and** Go
