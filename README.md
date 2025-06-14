# gibi.sh

> _"May be one day, but not today."_  
> — it’s kinda like a package manager. Kinda.

**gibi.sh** is a minimal, POSIX-compliant package helper script.  
It’s not a package manager. Not yet. But it can install and uninstall software from source in a simple and predictable way.

No dependencies, no magic, just shell.

## ✨ Features

- 💡 100% POSIX-compliant
- 🧱 No external dependencies (only `git` required)
- 📦 Simple URL-based package format
- 🧼 Lightweight, hackable, readable

## 🚀 Usage

```sh
./gibi.sh -d ~/.local/share/gibi        # setup directory
./gibi.sh -i github.com/user/repo       # install
./gibi.sh -u github.com/user/repo       # uninstall
./gibi.sh -v                            # show version
./gibi.sh -h                            # show help
```

### Package Format

```
site.domain/username/repo
```

Example:

```sh
gibi.sh -i github.com/lazypwny751/gibi
```

## 🤝 Contributing

Contributions are welcome!

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/cool-stuff`)
3. Commit your changes (`git commit -m 'Add some cool stuff'`)
4. Push to the branch (`git push origin feature/cool-stuff`)
5. Open a pull request

Or just open an issue if you have feedback or suggestions.

## 📜 License

This project is licensed under the terms of the [GNU GPLv3 License](https://www.gnu.org/licenses/gpl-3.0.html).  
See the [LICENSE](https://github.com/lazypwny751/gibi/blob/main/LICENSE) file for details.

---

> Project repository: [github.com/lazypwny751/gibi](https://github.com/lazypwny751/gibi)  
> Maintained with ☕ and `sh`
