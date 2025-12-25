SRC := main.v
OUT := gibi

all: $(OUT)

$(OUT):
	v . -o $(OUT)

clean:
	rm -f $(OUT)

.PHONY: all $(OUT) clean
