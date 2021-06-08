#include <stdio.h>
#include <stdlib.h>


extern void *checkerboard24(void *img, unsigned int sqsize, unsigned int
color1, unsigned int color2);

int main(int argc, const char* argv[]) {
    if (argc != 5) {
        printf("Incorrect number of arguments");
        return 0;
    }
    FILE *fp;
    fp = fopen(argv[1], "rb");
    if (fp == NULL) {
        printf("File not found.\n");
        return 0;
    }
    if (strtol(argv[2], NULL, 10) > 255) {
        printf("Square size cannot be larger than 127");
        return 0;
    }
    unsigned int width, height;
    fseek(fp, 18, SEEK_SET);
    fread(&width, 4, 1, fp);
    fread(&height, 4, 1, fp);
    if (width > 16777215 || height > 16777215) {
        printf("Image width or height too big");
        return 0;
    }
    unsigned int bmpSize;
    fseek(fp, 2, SEEK_SET);
    fread(&bmpSize, 4, 1, fp);
    void *image = malloc(bmpSize);
    fseek(fp, 0, SEEK_SET);
    fread(image, 1, bmpSize, fp);
    fclose(fp);
    void *newImage = checkerboard24(image, strtol(argv[2], NULL, 10),  strtol(argv[3], NULL, 16), strtol(argv[4], NULL, 16));
    fp = fopen("newImage.bmp", "wb");
    fwrite(newImage, 1, bmpSize, fp);
    fclose(fp);
    free(image);

    return 0;
}
