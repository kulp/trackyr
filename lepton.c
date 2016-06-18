#define _BSD_SOURCE 1
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>
#include <limits.h>
#include <string.h>

#define VOSPI_FRAME_SIZE (164)

int get_line(int fd, int hz, int bits, unsigned int image[][80])
{
    int frame_number = 0;
    uint8_t frame[VOSPI_FRAME_SIZE];
    struct spi_ioc_transfer tr = {
        .tx_buf        = (uintptr_t)(uint8_t[VOSPI_FRAME_SIZE]){ 0 },
        .rx_buf        = (uintptr_t)frame,
        .len           = sizeof frame,
        .delay_usecs   = 0,
        .speed_hz      = hz,
        .bits_per_word = bits,
    };

    int ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
    if (ret < 1)
        return -1;

    int is_status = (frame[0] & 0xf) == 0x0f;
    uint8_t good[] = { 0xdc, 0xd0, 0xdc, 0xad };

    int tries = 0;
    while (is_status && memcmp(&frame[4], good, 4) && tries++ < 10) {
        usleep(200000L);
        int ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
        if (ret < 1)
            return -1;
        is_status = (frame[0] & 0xf) == 0x0f;
    }

    if (tries >= 10)
        return -1;

    if (!is_status) {
        frame_number = frame[1];
        if (frame_number < 60)
            for (int i = 0; i < 80; i++)
                image[frame_number][i] = (frame[2*i+4] << 8 | frame[2*i+5]);
    }

    return frame_number;
}

int get_image(int fd, int hz, int bits, unsigned int image[][80])
{
    while (get_line(fd, hz, bits, image) != 59)
        ; // cycle
    return 0;
}

int set_up_spi(const char *device, unsigned int speed, unsigned int bits)
{
    int ret = 0;
    int fd = open(device, O_RDWR);

    uint8_t b = bits;
    ret |= ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &b);
    uint32_t s = speed;
    ret |= ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &s);

    return ret ? -1 : fd;
}

