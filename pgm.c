#include <stdio.h>
#include <stdlib.h>

#include "pgm.h"

int pgm_read(FILE *stream, struct pgm_image **out)
{
    char buf[64];

    char magic[2];
    if (!fgets(buf, sizeof buf, stream))
        return 1;
    if (buf[0] != 'P' || buf[1] != '5' || buf[2] != '\n')
        return 2;
    magic[0] = buf[0];
    magic[1] = buf[1];

    char *next;
    if (!fgets(buf, sizeof buf, stream))
        return 3;
    int width = strtol(buf, &next, 10);
    if (!width)
        return 4;
    int height = strtol(next, NULL, 10);
    if (!height)
        return 5;

    if (!fgets(buf, sizeof buf, stream))
        return 6;
    int max = strtol(buf, NULL, 10);
    if (!max)
        return 7;

    struct pgm_image *pgm = malloc(width * height + sizeof *pgm);
    pgm->magic[0] = magic[0];
    pgm->magic[1] = magic[1];

    pgm->width = width;
    pgm->height = height;

    pgm->max = max;

    if (fread(pgm->data, width * height, 1, stream) != 1) {
        free(pgm);
        return 8;
    }

    *out = pgm;

    return 0;
}

int pgm_write(FILE *stream, struct pgm_image *out)
{
    fprintf(stream,
            "%c%c\n"
            "%d %d\n"
            "%d\n"
            , out->magic[0], out->magic[1]
            , out->width, out->height
            , out->max);

    if (fwrite(out->data, out->width * out->height, 1, stream) != 1)
        return 1;

    return 0;
}

void pgm_free(struct pgm_image *out)
{
    free(out);
}

