# Gibi - (Gi)t (B)ased (I)nnovative Package Manager

Gibi is a lightweight, git-based package manager built with V. It's designed to be simple, fast, and innovative.

## Installation

To get started with Gibi, you'll need a couple of things installed on your system first:
- `make`
- `v` (The V Compiler)

Once you have those, just clone the repo and build it:

```sh
git clone "https://github.com/lazypwny751/gibi.git"
cd gibi
make
```

## Usage

Using Gibi is straightforward. Here are the commands to manage your packages:

```sh
# Install one or more packages
./gibi --install <package1> <package2>

# Uninstall packages
./gibi --uninstall <package1> <package2>

# Update packages
./gibi --update <package1> <package2>

# List all installed packages
./gibi --list

# Show information about specific packages
./gibi --info <package1>
```

## License

Gibi is licensed under the **GPLv3**. See the [LICENSE](LICENSE) file for more details.
