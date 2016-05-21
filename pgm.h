struct pgm_image {
    char magic[2];
    int width, height;
	int max;
    char data[];
};

int pgm_read(FILE *stream, struct pgm_image **out);
int pgm_write(FILE *stream, struct pgm_image *out);
void pgm_free(struct pgm_image *out);
