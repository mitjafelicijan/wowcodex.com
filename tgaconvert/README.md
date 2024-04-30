# Converts TGA files to PNG or JPEG

> [!NOTE]
> Simple tool that allows bulk converting of TGA files to PNG or JPEG format.
> By default WoW client 1.12 saves all the in-game screenshots as TGA files
> which are a bit hard to share. So this tool makes it a bit easier.

If you don't want to use this tool you could use https://imagemagick.org
which also allows convertion and is much more versatile than this tool
but it come with added complexity.

## Compilation

```sh
git clone --depth=1 git@github.com:mitjafelicijan/wowcodex.git
cd tgaconvert
clang -o tgaconvert main.c -lm
```

## Usage

```sh
tgaconvert -f <format> <input_file1> [<input_file2> ...]
```

Supported formats:

- jpeg (`./tgaconvert -f jpeg test/10.tga`)
- png (`./tgaconvert -f png test/10.tga`)
- bmp (`./tgaconvert -f bmp test/10.tga`)

You can also use bash argument expansion and do `./tgaconvert -f jpeg
test/*.tga` which will expand all of the files with `tga` extension and
provide them with to converter program.

## Testing data

Testing data was taken from https://testimages.org and from the game.

## Credits

* Image loader: [stb_image.h](stb_image.h)
* Image writer: [stb_image_write.h](stb_image_write.h)

## License

[tgaconvert](https://github.com/mitjafelicijan/wowcodex/tgaconvert)
was written by [Mitja Felicijan](https://mitjafelicijan.com) and is
released under the BSD two-clause license, see the LICENSE file for
more information.
