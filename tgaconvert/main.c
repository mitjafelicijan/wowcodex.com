#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image.h"
#include "stb_image_write.h"

#define BUFSIZE 512

int main(int argc, char *argv[]) {
  if (argc < 4) {
    fprintf(stderr, "Usage: %s -f <format> <input_file1> [<input_file2> ...]\n", argv[0]);
    return 1;
  }

  if (strcmp(argv[1], "-f") != 0) {
    fprintf(stderr, "Error: Invalid usage. Use -f to specify output format\n");
    return 1;
  }

  const char *format = argv[2];
  const char *output_format;

  for (int i = 3; i < argc; i++) {
    const char *input_filename = argv[i];
   
    char no_extension[BUFSIZE];
    strcpy(no_extension, input_filename);
        
    char *dot = strrchr(no_extension, '.');
    if (dot) *dot = '\0';

    char output_filename[BUFSIZE];
    strcpy(output_filename, no_extension);
    strcat(output_filename, ".");
    strcat(output_filename, format);

    printf("Converting: %s to %s\n", input_filename, output_filename);

    int width, height, channels;
    unsigned char *data = stbi_load(input_filename, &width, &height, &channels, 0);
    if (!data) {
        fprintf(stderr, "Error: Unable to open TGA file '%s'\n", input_filename);
        exit(1);
    }

    if (strcmp(format, "png") == 0) {
      int result = stbi_write_png(output_filename, width, height, channels, data, width * channels);
      if (!result) {
        fprintf(stderr, "Error: Unable to write PNG file '%s'\n", output_filename);
      }
    } else if (strcmp(format, "jpeg") == 0) {
      int result = stbi_write_jpg(output_filename, width, height, channels, data, 100);
      if (!result) {
          fprintf(stderr, "Error: Unable to write JPG file '%s'\n", output_filename);
      }
    } else if (strcmp(format, "bmp") == 0) {
      int result = stbi_write_bmp(output_filename, width, height, channels, data);
      if (!result) {
          fprintf(stderr, "Error: Unable to write JPG file '%s'\n", output_filename);
      }
    } else {
       printf("Unknown format %s defined. Available formats are jpeg and png.\n", format);
    }

    stbi_image_free(data);
  }
}
