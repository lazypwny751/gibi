package flag

import (
	"os"

	"github.com/alecthomas/kong"
)

type Flag struct {
	Install  []string `help:"Install dependencies." short:"i"`
	Uninstall []string `help:"Uninstall dependencies." short:"u"`
	Verbose   bool      `help:"Enable verbose output." short:"v"`
}

func ParseFlags() (*Flag, error) {
	var flags Flag
	parser, err := kong.New(&flags)
	if err != nil {
		return nil, err
	}
	_, err = parser.Parse(os.Args[1:])
	if err != nil {
		return nil, err
	}
	return &flags, nil
}