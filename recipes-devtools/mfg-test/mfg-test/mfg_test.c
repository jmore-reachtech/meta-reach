#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>
#include <ctype.h>
#include <stdint.h>
#include <string.h>
#include <time.h>
#include <asm/types.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <termios.h>
#include <errno.h>
#include <linux/spi/spidev.h>
#include <linux/i2c-dev-user.h>
#include <linux/input.h>
#include <sys/socket.h>
#include <net/if.h>
#include <linux/can.h>

#define VERSION     "0.9a"

typedef int     bool;
#define TRUE    1
#define FALSE   0

#undef  _I2C_BLOCK_WRITE
#undef  _I2C_BLOCK_READ

#ifdef DWG_X86_TEST
static inline int i2c_smbus_write_byte_data(fd, off, buf) { return 0; }
static inline int i2c_smbus_read_byte_data(fd, off) { return 0; }
#endif // DWG_X86_TEST

// Colors for text formatting
#define ATTR_RED        "\033[0;31m"    /* 0 -> normal; 31 -> red */
#define ATTR_GREEN      "\033[0;32m"    /* 0 -> normal; 32 -> green */
#define ATTR_UNKNOWN    "\033[0;33m"    /* 0 -> normal; 33 -> yellow */
#define ATTR_NONE       "\033[0m"       /* to flush the previous property */
#define STR_PASS        ATTR_GREEN "[PASS]" ATTR_NONE
#define STR_FAIL        ATTR_RED "[FAIL]" ATTR_NONE
#define STR_UNTESTED    ATTR_UNKNOWN "[UN-TESTED]" ATTR_NONE

typedef int (*testFunc_t)(void);

#define NELEM(a) (sizeof(a) / sizeof((a)[0]))

#define NETWORK_ETHERNET        0
#define NETWORK_USBOTG          1
#define NETWORK_CAN             2

const char *RtcIfList[] = { "ETHERNET", "USBOTG" };

typedef struct {
    char    if_name[32];
    #define _NET_USBOTG_LOADED  (0x01 << 0)
    #define _NET_CAN_LOADED     (0x01 << 1)
    #define _NET_INTERFACE_UP   (0x01 << 2)
    uint8_t flags;
} ethIf_t;

#define GPIO_PATH       "/sys/class/gpio"
#define GPIO_PIN_BASE   160
#define GPIO_NUM_PINS   8

typedef struct {
    char    if_path[64];
    uint8_t pin;
    #define _GPIO_DIR_UNKNOWN   0
    #define _GPIO_DIR_INPUT     1
    #define _GPIO_DIR_OUTPUT    2
    uint8_t direction;
    #define _GPIO_POL_UNKNOWN   0
    #define _GPIO_POL_NORMAL    1
    #define _GPIO_POL_INVERT    2
    uint8_t polarity;
    #define _GPIO_PIN_EXPORTED  (0x01 << 0)
    #define _GPIO_PIN_OPEN      (0x01 << 1)
    uint8_t flags;
} gpio_t;

#define _USB_SERIAL             0
#define _USB_MASS_STORAGE       1
#define _USB_BARCODE_SCANNER    2
uint8_t UsbList[8];
uint8_t NumUsbList = 0;

static const uint8_t gpio_map[] = { 3, 2, 1, 0, 4, 5, 6, 7 };
static const uint8_t reach_oui[] = { 0x30, 0x68, 0x8C };

#define USER_INPUT_STRING   "{ASK_USER}"

#ifndef  DBG_BUFFER_LEN
#  define DBG_BUFFER_LEN    1024
#endif

struct {
    #define _DBG_DATA_ON        0x00000010L
    #define _DBG_VERBOSE_ON     0x00000020L
    #define _DBG_KEYEVENT_ON    0x00000040L
    uint32_t    debug;
    bool        verbose;
    bool        dryrun;
    uint32_t    repeat;
    char       *file_path;
    char       *tests;
    char       *mac_address;
    struct {
        char       *if_name;
        char       *server_ip;
        char       *local_ip;
    }           ethernet;
    struct {
        char       *if_name;
        char       *remote_macaddr;
        char       *server_ip;
        char       *local_ip;
    }           usbotg;
    uint8_t     rtc_if;
    uint32_t    rs485_baud;
    uint32_t    rs232_baud;
    uint32_t    buffer_size;
    char       *i2c_path;
    uint8_t     i2c_addr;
    uint8_t     i2c_offset;
    uint8_t     spi_bus;
} g_info = {
    .debug = 0x0,
    .verbose = FALSE,
    .dryrun = FALSE,
    .repeat = 1,
    .file_path = "~reach/File-32M",
    .tests = NULL,
    .mac_address = NULL,
    .ethernet = {
        .if_name = "eth0",
        .server_ip = NULL,
        .local_ip = NULL,
    },
    .usbotg = {
        .if_name = "usb0",
        .remote_macaddr = "10:20:30:40:50:60",
        .server_ip = "10.10.10.1",
        .local_ip = "10.10.10.208",
    },
    .rtc_if = NETWORK_USBOTG,
    .rs485_baud = B4000000,
    .rs232_baud = B576000,
    .buffer_size = 512,
    .i2c_path = "/dev/i2c-1",
    .i2c_addr = 0x20,
    .i2c_offset = 0x00,
    .spi_bus = 1,
};

static int execute_cmd_ex(const char *cmd, char *result, int result_size);
static int execute_cmd(const char *cmd);

static ethIf_t *network_open(uint8_t if_type, uint8_t instance);
static int network_close(ethIf_t *ep);
static gpio_t *gpio_open(uint8_t pin);
static int gpio_set_direction(gpio_t *gp, uint8_t direction);
static int gpio_set_polarity(gpio_t *gp, uint8_t polarity);
static int gpio_get_value(gpio_t *gp, uint8_t *pvalue);
static int gpio_set_value(gpio_t *gp, uint8_t value);
static int gpio_close(gpio_t *gp);
static int barcode_read(char *buffer, uint8_t *pbuffer_size, uint32_t timeout_us);

const struct {
    uint32_t    key;
    uint32_t    speed;
} BaudTable[] = {
    { B0      , 0       },
    { B50     , 50      },
    { B75     , 75      },
    { B110    , 110     },
    { B134    , 134     },
    { B150    , 150     },
    { B200    , 200     },
    { B300    , 300     },
    { B600    , 600     },
    { B1200   , 1200    },
    { B1800   , 1800    },
    { B2400   , 2400    },
    { B4800   , 4800    },
    { B9600   , 9600    },
    { B19200  , 19200   },
    { B38400  , 38400   },
    { B57600  , 57600   },
    { B115200 , 115200  },
    { B230400 , 230400  },
    { B460800 , 460800  },
    { B500000 , 500000  },
    { B576000 , 576000  },
    { B921600 , 921600  },
    { B1000000, 1000000 },
    { B1152000, 1152000 },
    { B1500000, 1500000 },
    { B2000000, 2000000 },
    { B2500000, 2500000 },
    { B3000000, 3000000 },
    { B3500000, 3500000 },
    { B4000000, 4000000 },
};

/****************************************************************************
 * DbgDataToString
 */
static const char *
DbgDataToString(
    const void *    pVData,
    unsigned long   offset,
    unsigned long   length,
    char *          pBuffer,
    unsigned long   bufferLength
    )
{
    static char     Buffer[DBG_BUFFER_LEN] = { 0 }; /* Debug only! */
    const char      digits[] = "0123456789ABCDEF";
    const unsigned char *pData = (const unsigned char *) pVData;
    char           *pB;
    const unsigned char *pD;
    unsigned long   x;
    unsigned char   val;

    /* If the user buffer was not supplied, use the internal buffer. */
    if (pBuffer == NULL)
    {
        pBuffer = Buffer;
        bufferLength = sizeof(Buffer) - 1;
    }

    pB = pBuffer;

    if (pData != NULL)
    {
        if (length < bufferLength)
        {
            pD = (pData + offset);
            for (x = 0; x < length; x++)
            {
                if ((pD[x] >= ' ') && (pD[x] <= '~'))
                {
                    *(pB++) = pD[x];
                }
                else
                {
                    val = pD[x];

                    *(pB++) = '[';
                    *(pB++) = digits[(val >> 4) & 0x0F];
                    *(pB++) = digits[val & 0x0F];
                    *(pB++) = ']';
                }

                if (x >= (bufferLength - 12))
                {
                    *(pB++) = '.';
                    *(pB++) = '.';
                    *(pB++) = '.';
                    break;
                }
            }
        }
        else
        {
            *(pB++) = '.';
            *(pB++) = '.';
            *(pB++) = '.';
        }
        *(pB++) = '\0';

#ifdef DWG_DBG_TRUNCATE
        /* Truncate lines that are too long. */
        if ((pB - pBuffer) > 512)
        {
            pBuffer[0] = '.';
            pBuffer[1] = '.';
            pBuffer[2] = '.';
            pBuffer[3] = '\0';
        }
#endif // DWG_DBG_TRUNCATE
    }
    else
    {
        *(pB++) = '<';
        *(pB++) = 'N';
        *(pB++) = 'U';
        *(pB++) = 'L';
        *(pB++) = 'L';
        *(pB++) = '>';
        *(pB++) = '\0';
    }

    return pBuffer;
}

/****************************************************************************
 * DbgDataToHexString
 */
static const char *
DbgDataToHexString(
    const void *    pVData,
    unsigned long   offset,
    unsigned long   length,
    char *          pBuffer,
    unsigned long   bufferLength
    )
{
    static char     Buffer[DBG_BUFFER_LEN] = { 0 }; /* Debug only! */
    const char      digits[] = "0123456789ABCDEF";
    const unsigned char *pData = (const unsigned char *) pVData;
    char           *pB;
    const unsigned char *pD;
    unsigned long   x;
    unsigned char   val;

    /* If the user buffer was not supplied, use the internal buffer. */
    if (pBuffer == NULL)
    {
        pBuffer = Buffer;
        bufferLength = sizeof(Buffer) - 1;
    }

    pB = pBuffer;

    if (pData != NULL)
    {
        if (length < bufferLength)
        {
            pD = (pData + offset);
            for (x = 0; x < length; x++)
            {
                val = pD[x];

                *(pB++) = '[';
                *(pB++) = digits[(val >> 4) & 0x0F];
                *(pB++) = digits[val & 0x0F];
                *(pB++) = ']';

                if (x >= (bufferLength - 12))
                {
                    *(pB++) = '.';
                    *(pB++) = '.';
                    *(pB++) = '.';
                    break;
                }
            }
        }
        else
        {
            *(pB++) = '.';
            *(pB++) = '.';
            *(pB++) = '.';
        }
        *(pB++) = '\0';

#ifdef DWG_DBG_TRUNCATE
        /* Truncate lines that are too long. */
        if ((pB - pBuffer) > 512)
        {
            pBuffer[0] = '.';
            pBuffer[1] = '.';
            pBuffer[2] = '.';
            pBuffer[3] = '\0';
        }
#endif // DWG_DBG_TRUNCATE
    }
    else
    {
        *(pB++) = '<';
        *(pB++) = 'N';
        *(pB++) = 'U';
        *(pB++) = 'L';
        *(pB++) = 'L';
        *(pB++) = '>';
        *(pB++) = '\0';
    }

    return pBuffer;
}

/****************************************************************************
 * DbgOctet
 */
static const char *
DbgOctet(
    const unsigned char * pData,
    unsigned char   length,
    char *          pBuffer,
    unsigned long   bufferLength
    )
{
    static char     Buffer[32] = { 0 }; /* Debug only! */
    const char      digits[] = "0123456789ABCDEF";
    char           *pB;
    const unsigned char *pD;
    unsigned long   x;
    unsigned char   val;

    /* If the user buffer was not supplied, use the internal buffer. */
    if (pBuffer == NULL)
    {
        pBuffer = Buffer;
        bufferLength = sizeof(Buffer) - 1;
    }

    pB = pBuffer;

    if (pData != NULL)
    {
        pD = pData;
        for (x = 0; x < length; x++)
        {
            val = pD[x];

            if (x != 0) *(pB++) = ':';
            *(pB++) = digits[(val >> 4) & 0x0F];
            *(pB++) = digits[val & 0x0F];
        }
        *(pB++) = '\0';
    }
    else
    {
        *(pB++) = '<';
        *(pB++) = 'N';
        *(pB++) = 'U';
        *(pB++) = 'L';
        *(pB++) = 'L';
        *(pB++) = '>';
        *(pB++) = '\0';
    }

    return pBuffer;
}

/****************************************************************************
 * baud_key_to_str
 */
static const char *
baud_key_to_str(
    uint32_t    baud_key
    )
{
    static char buffer[32] = { 0 };
    int x;

    for (x = 0; x < NELEM(BaudTable); x++)
    {
        if (BaudTable[x].key == baud_key)
        {
            break;
        }
    }

    if (x >= NELEM(BaudTable))
    {
        sprintf(buffer, "{Unknown<%06oo>}", baud_key);
    }
    else
    {
        uint32_t speed = BaudTable[x].speed;

        sprintf(buffer, "%ubps", speed);
    }

    return buffer;
}

/****************************************************************************
 * baud_str_to_key
 */
static uint32_t
baud_str_to_key(const char *baud_str)
{
    uint32_t baud_key = __MAX_BAUD;
    char *baud_buf = NULL;
    char buf[32];
    char *bp;
    int x;

    baud_buf = strdup(baud_str);
    if ((bp = strstr(baud_buf, "bps")) != NULL)
    {
        *bp = '\0';
    }

    for (x = 0; x < NELEM(BaudTable); x++)
    {
        sprintf(buf, "%u", BaudTable[x].speed);
        if (strcasecmp(buf, baud_buf) == 0)
        {
            baud_key = BaudTable[x].key;
            break;
        }
    }

    if (x >= NELEM(BaudTable))
    {
        fprintf(stderr, "Warning: Unknown baud rate '%s'. Defaulting to %s.\n", baud_str, baud_key_to_str(baud_key));
    }

    if (baud_buf != NULL)
    {
        free(baud_buf);
        baud_buf = NULL;
    }

    return baud_key;
}

/****************************************************************************
 * network_open
 */
static ethIf_t *
network_open(uint8_t if_type, uint8_t instance)
{
    ethIf_t *ep = NULL;
    char if_name[32];
    const char *ip_address = NULL;
    const char *server_ip = NULL;
    const char *remote_macaddr = NULL;
    char cmd[128];
    int rv = 0;
    int n;

    *if_name = '\0';
    switch (if_type)
    {
    case NETWORK_ETHERNET:
        sprintf(if_name, "eth%d", instance);
        ip_address = g_info.ethernet.local_ip;
        server_ip = g_info.ethernet.server_ip;
        break;

    case NETWORK_USBOTG:
        sprintf(if_name, "usb%d", instance);
        ip_address = g_info.usbotg.local_ip;
        server_ip = g_info.usbotg.server_ip;
        remote_macaddr = g_info.usbotg.remote_macaddr;
        break;

    case NETWORK_CAN:
        sprintf(if_name, "can%d", instance);
        break;
    }

    n = sizeof(*ep);
    if ((ep = malloc(n)) == NULL)
    {
        fprintf(stderr, "Error: %s: malloc(%d) failed: %s [%d]\n", __FUNCTION__, n, strerror(errno), errno);
        goto e_network_open;
    }
    memset(ep, 0, n);

    strcpy(ep->if_name, if_name);

    if ((if_type == NETWORK_USBOTG) && (remote_macaddr != NULL))
    {
        sprintf(cmd, "modprobe g_ether host_addr=%s", remote_macaddr);
        rv = execute_cmd(cmd);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
            goto e_network_open;
        }
        ep->flags |= _NET_USBOTG_LOADED;
    }

    if (if_type == NETWORK_CAN)
    {
        sprintf(cmd, "modprobe flexcan");
        rv = execute_cmd(cmd);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
            goto e_network_open;
        }
        ep->flags |= _NET_CAN_LOADED;

        sprintf(cmd, "ifconfig %s up", if_name);
        rv = execute_cmd(cmd);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
            goto e_network_open;
        }
    }

    if (ip_address != NULL)
    {
        sprintf(cmd, "ifconfig %s %s netmask 255.255.255.0 up", if_name, ip_address);
        rv = execute_cmd(cmd);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
            goto e_network_open;
        }
    }

    if (server_ip != NULL)
    {
        for (n = 0; n < 10; n++)
        {
            sprintf(cmd, "ping -c 1 -W 1 %s", server_ip);
            rv = execute_cmd(cmd);
            if (rv >= 0)
            {
                break;
            }
        }

        if (n >= 10)
        {
            fprintf(stderr, "Error: %s: timeout trying to ping server %s\n", __FUNCTION__, server_ip);
            goto e_network_open;
        }
    }
    ep->flags |= _NET_INTERFACE_UP;

e_network_open:
    if (!(ep->flags & _NET_INTERFACE_UP))
    {
        if (ep != NULL)
        {
            network_close(ep);
            ep = NULL;
        }
    }

    return ep;
}

/****************************************************************************
 * network_close
 */
static int
network_close(ethIf_t *ep)
{
    int status = 0;
    char cmd[128];
    int rv = 0;

    if (ep != NULL)
    {
        if (ep->flags & _NET_INTERFACE_UP)
        {
            ep->flags &= ~_NET_INTERFACE_UP;

            sprintf(cmd, "ifconfig %s down", ep->if_name);
            rv = execute_cmd(cmd);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
                status = rv;
            }
        }

        if (ep->flags & _NET_USBOTG_LOADED)
        {
            ep->flags &= ~_NET_USBOTG_LOADED;

            sprintf(cmd, "rmmod g_ether");
            rv = execute_cmd(cmd);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
                status = rv;
            }
        }

        if (ep->flags & _NET_CAN_LOADED)
        {
            ep->flags &= ~_NET_CAN_LOADED;

            sprintf(cmd, "rmmod flexcan");
            rv = execute_cmd(cmd);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
                status = rv;
            }
        }

        free(ep);
        ep = NULL;
    }

    return status;
}

/****************************************************************************
 * test_serial
 */
static int
test_serial(const char *devices[], uint32_t baud_key)
{
    int status = 0;
    int rv = 0;
    int fd[2];
    int x;
    int devIdx;
    int nbytes;
    struct termios tcs[2];
    struct timeval timeout;
    bool done;

    // Target
    //   Open both ports
    //   Verify write on Port#0 is received on Port#1
    //   Verify write on Port#1 is received on Port#0

    for (x = 0; x < 2; x++)
    {
        fd[x] = -1;
    }

    for (x = 0; x < 2; x++)
    {
        int i;

        fd[x] = open(devices[x], O_RDWR | O_NDELAY);
        if (fd[x] < 0)
        {
            fprintf(stderr, "Error: %s: open('%s') failed: %s [%d]\n", __FUNCTION__, devices[x], strerror(errno), errno);
            status = -1;
            goto e_test_serial;
        }

        rv = ioctl(fd[x], TCGETS, &(tcs[x]));
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: ioctl(TCGETS) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
            status = rv;
            goto e_test_serial;
        }

        for (i = 0; i < NCCS; i++)
        {
            tcs[x].c_cc[i] = '\0';
        }
        tcs[x].c_cc[VMIN]  = 1;
        tcs[x].c_cc[VTIME] = 0;
        tcs[x].c_iflag = (IGNBRK | IGNPAR);
        tcs[x].c_oflag = (0);
        tcs[x].c_lflag = (0);
        tcs[x].c_cflag = (HUPCL | CREAD | CLOCAL | CS8 | baud_key);

        if (g_info.verbose) fprintf(stdout, "Debug: %s: Setting %s baud rate to %s.\n", __FUNCTION__, devices[x], baud_key_to_str(baud_key));

        rv = ioctl(fd[x], TCSETS, &(tcs[x]));
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: ioctl(TCSETS) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
            status = rv;
            goto e_test_serial;
        }

        int flags = fcntl(fd[x], F_GETFL, 0);
        fcntl(fd[x], F_SETFL, flags & ~O_NDELAY);
    }

    timeout.tv_sec = 2;
    timeout.tv_usec = 0;

    int test_buf_len = g_info.buffer_size;
    uint8_t *test_buf = NULL;
    if ((test_buf = malloc(test_buf_len)) == NULL)
    {
        fprintf(stderr, "Error: %s: malloc(%d) failed: %s [%d]\n", __FUNCTION__, test_buf_len, strerror(errno), errno);
        goto e_test_serial;
    }
    int buf_len = g_info.buffer_size;
    uint8_t *buf = NULL;
    if ((buf = malloc(buf_len)) == NULL)
    {
        fprintf(stderr, "Error: %s: malloc(%d) failed: %s [%d]\n", __FUNCTION__, buf_len, strerror(errno), errno);
        goto e_test_serial;
    }

    for (x = 0; x < test_buf_len; x++)
    {
        test_buf[x] = (uint8_t) x;
    }

    devIdx = 0;
    if (g_info.verbose) fprintf(stdout, "Debug: %s: Sending %d bytes from %s ==> %s.\n", __FUNCTION__, test_buf_len, devices[devIdx], devices[devIdx ^ 1]);
    nbytes = write(fd[devIdx], test_buf, test_buf_len);
    if (nbytes != test_buf_len)
    {
        fprintf(stderr, "Error: %s: %s sent only %d of requested %d bytes.\n", __FUNCTION__, devices[devIdx], nbytes, test_buf_len);
        status = -1;
        goto e_test_serial;
    }

    int offset = 0;
    time_t time_expire = time(NULL) + 5;

    done = FALSE;
    while (!done)
    {
        int maxFd = -1;
        fd_set readFds;

        FD_ZERO(&readFds);
        for (x = 0; x < 2; x++)
        {
            FD_SET(fd[x], &readFds);

            if (fd[x] > maxFd)
            {
                maxFd = fd[x];
            }
        }

        switch (select(maxFd + 1, &readFds, NULL, NULL, &timeout))
        {
        case -1: // Error
            if (errno != EINTR)
            {
                fprintf(stderr, "Error: %s: select() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                status = -1;
                done = TRUE;
            }
            break;

        case 0: // Timeout
            fprintf(stderr, "Error: %s: Timeout waiting for %d bytes sent from %s ==> %s.\n", __FUNCTION__, test_buf_len, devices[devIdx], devices[devIdx ^ 1]);
            status = -1;
            done = TRUE;
            break;

        default:
            for (x = 0; x < 2; x++)    
            {
                if (FD_ISSET(fd[x], &readFds))
                {
                    if ((nbytes = read(fd[x], &(buf[offset]), buf_len - offset)) >= 0)
                    {
                        if (g_info.debug & _DBG_DATA_ON) fprintf(stdout, "Debug: %s: %s receive '%s'[%d]\n", __FUNCTION__, devices[x], DbgDataToString(&(buf[offset]), 0, nbytes, NULL, 0), nbytes);

                        if (time(NULL) > time_expire)
                        {
                            fprintf(stderr, "Error: %s: Timeout waiting for %d bytes sent from %s ==> %s.\n", __FUNCTION__, test_buf_len, devices[devIdx], devices[devIdx ^ 1]);
                            status = -1;
                            done = TRUE;
                            break;
                        }

                        switch (x)
                        {
                        case 0:
                            if (memcmp(&(buf[offset]), &(test_buf[offset]), nbytes) != 0)
                            {
                                fprintf(stderr, "Error: %s: Received data sent from %s ==> %s did not match.\n", __FUNCTION__, devices[devIdx], devices[devIdx ^ 1]);
                                status = -1;
                                done = TRUE;
                                break;
                            }

                            if ((nbytes + offset) == test_buf_len)
                            {
                                offset = 0;

                                done = TRUE;
                            }
                            else
                            {
                                offset += nbytes;
                            }
                            break;

                        case 1:
                            if (memcmp(&(buf[offset]), &(test_buf[offset]), nbytes) != 0)
                            {
                                fprintf(stderr, "Error: %s: Received data sent from %s ==> %s did not match.\n", __FUNCTION__, devices[devIdx], devices[devIdx ^ 1]);
                                status = -1;
                                done = TRUE;
                                break;
                            }

                            if ((nbytes + offset) == test_buf_len)
                            {
                                offset = 0;

                                devIdx ^= 1;
                                if (g_info.verbose) fprintf(stdout, "Debug: %s: Sending %d bytes from %s ==> %s.\n", __FUNCTION__, test_buf_len, devices[devIdx], devices[devIdx ^ 1]);
                                nbytes = write(fd[devIdx], test_buf, test_buf_len);
                                if (nbytes != test_buf_len)
                                {
                                    fprintf(stderr, "Error: %s: %s sent only %d of requested %d bytes.\n", __FUNCTION__, devices[devIdx], nbytes, test_buf_len);
                                    status = -1;
                                    goto e_test_serial;
                                }
                            }
                            else
                            {
                                offset += nbytes;
                            }
                            break;
                        }
                    }
                    else
                    {
                        fprintf(stderr, "Error: %s: read() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                        status = -1;
                        done = TRUE;
                    }
                }
            }
            break;
        }

        // Reset polling interval
        timeout.tv_sec = 2;
        timeout.tv_usec = 0;
    }

e_test_serial:
    if (buf != NULL)
    {
        free(buf);
        buf = NULL;
    }

    if (test_buf != NULL)
    {
        free(test_buf);
        test_buf = NULL;
    }

    for (x = 0; x < 2; x++)
    {
        if (fd[x] != -1)
        {
            /* Restore terminal setup */
            rv = ioctl(fd[x], TCSETS, &(tcs[x]));
            if (rv < 0)
            {
                fprintf(stderr, "Warning: %s: ioctl(TCSETS) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
            }

            close(fd[x]);
            fd[x] = -1;
        }
    }

    return status;
}

/****************************************************************************
 * execute_cmd_ex
 */
static int
execute_cmd_ex(const char *cmd, char *result, int result_size)
{
    int status = 0;
    FILE *fp = NULL;
    char *icmd = NULL;
    int n;

    if (g_info.debug & _DBG_VERBOSE_ON) fprintf(stdout, "Debug: %s(\"%s\")\n", __FUNCTION__, cmd);

    if ((result != NULL) && (result_size > 0))
    {
        *result = '\0';
    }

    n = strlen(cmd) + 16;
    if ((icmd = malloc(n)) == NULL)
    {
        fprintf(stderr, "Error: %s: malloc(%d) failed: %s [%d]\n", __FUNCTION__, n, strerror(errno), errno);
        status = -1;
        goto e_execute_cmd_ex;
    }
    strcpy(icmd, cmd);
    strcat(icmd, " 2>&1");

    if ((fp = popen(icmd, "r")) != NULL)
    {
        char buf[256];
        int x;
        int p_status;

        buf[0] = '\0';

        while (fgets(buf, sizeof(buf), fp) != NULL)
        {
            // Strip trailing whitespace
            for (x = strlen(buf); (x > 0) && isspace(buf[x - 1]); x--); buf[x] = '\0';
            if (buf[0] == '\0') continue;

            if (result != NULL)
            {
                if ((strlen(result) + strlen(buf) + 4) < result_size)
                {
                    strcat(result, buf);
                    strcat(result, "\n");
                }
                else
                {
                    strcat(result, "...\n");
                    result = NULL;
                }
            }

            if (g_info.debug & _DBG_VERBOSE_ON) fprintf(stdout, "Debug: %s:   '%s'\n", __FUNCTION__, buf);
        }

        p_status = pclose(fp);
        if (p_status == -1)
        {
            fprintf(stderr, "Error: %s: pclose() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
            status = -1;
            goto e_execute_cmd_ex;
        }
        else if (WIFEXITED(p_status))
        {
            int e_status;

            e_status = (int8_t) WEXITSTATUS(p_status);

            if (e_status != 0)
            {
                if (g_info.verbose) fprintf(stderr, "Error: %s: Command '%s' exited with status %d\n", __FUNCTION__, cmd, e_status);
                status = -1;
            }
            else
            {
                if (g_info.debug & _DBG_VERBOSE_ON) fprintf(stdout, "Debug: %s: Command '%s' exited with status %d\n", __FUNCTION__, cmd, e_status);
            }
        }
        else if (WIFSIGNALED(p_status))
        {
            int sig;

            sig = WTERMSIG(p_status);
            fprintf(stderr, "Error: %s: Command '%s' was killed with signal %d\n", __FUNCTION__, cmd, sig);
            status = -1;
        }
        else
        {
            fprintf(stderr, "Error: %s: Command '%s' exited for unknown reason\n", __FUNCTION__, cmd);
            status = -1;
        }

        fp = NULL;
    }
    else
    {
        fprintf(stderr, "Error: %s: popen('%s') failed: %s [%d]\n", __FUNCTION__, icmd, strerror(errno), errno);
        status = -1;
        goto e_execute_cmd_ex;
    }

e_execute_cmd_ex:
    if (icmd != NULL)
    {
        free(icmd);
        icmd = NULL;
    }

    return status;
}

/****************************************************************************
 * execute_cmd
 */
static int
execute_cmd(const char *cmd)
{
    return execute_cmd_ex(cmd, NULL, 0);
}

/****************************************************************************
 * test_Ethernet
 */
static int
test_Ethernet(void)
{
    int status = 0;
    const char local_file[] = "/tmp/EthernetDownload";
    ethIf_t *ep = NULL;
    char cmd[128];
    int rv = 0;

    #define _ETHERNET_INTERFACE_UP    (0x01 << 0)
    #define _ETHERNET_FILE_DOWNLOADED (0x01 << 1)
    uint8_t flags = 0x0;

    //DWG J6:Ethernet <==> Host via Ethernet
    // Host
    //   - Enable web server
    //
    // Target
    //   ifconfig eth0 x.x.x.2 netmask 255.255.255.0 up
    //   ping x.x.x.1
    //   cd /tmp
    //   wget http://x.x.x.1/~reach/File-32M

    ep = network_open(NETWORK_ETHERNET, 0);
    if (ep == NULL)
    {
        fprintf(stderr, "Error: %s: network_open() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_test_Ethernet;
    }
    flags |= _ETHERNET_INTERFACE_UP;

    flags |= _ETHERNET_FILE_DOWNLOADED;
    sprintf(cmd, "wget -nv -O %s http://%s/%s", local_file, g_info.ethernet.server_ip, g_info.file_path);
    rv = execute_cmd(cmd);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_Ethernet;
    }

e_test_Ethernet:
    if (flags & _ETHERNET_FILE_DOWNLOADED)
    {
        sprintf(cmd, "rm -f %s", local_file);
        rv = execute_cmd(cmd);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
            status = rv;
        }
        flags &= ~_ETHERNET_FILE_DOWNLOADED;
    }

    if (flags & _ETHERNET_INTERFACE_UP)
    {
        if (ep != NULL)
        {
            rv = network_close(ep);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: network_close() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                status = -1;
            }
            ep = NULL;
        }
        flags &= ~_ETHERNET_INTERFACE_UP;
    }

    return status;
}

/****************************************************************************
 * test_RTC
 */
static int
test_RTC(void)
{
    int status = 0;
    char cmd[128];
    int rv = 0;
    ethIf_t *ep = NULL;
    uint8_t if_type;
    const char *server_ip = NULL;

    //DWG U28:RTC
    // Target
    //   Set time/date <== Host via Ethernet
    //   rdate -s 10.10.10.1
    //   date --utc -s "%s"
    //   hwclock --systohc --utc

    if_type = g_info.rtc_if;
    switch (if_type)
    {
    case NETWORK_ETHERNET:
        server_ip = g_info.ethernet.server_ip;
        break;

    case NETWORK_USBOTG:
    default:
        server_ip = g_info.usbotg.server_ip;
        break;
    }

    ep = network_open(if_type, 0);
    if (ep == NULL)
    {
        fprintf(stderr, "Error: %s: network_open() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_test_RTC;
    }

    sprintf(cmd, "rdate %s", server_ip);
    rv = execute_cmd(cmd);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_RTC;
    }

    sprintf(cmd, "hwclock --systohc --utc");
    rv = execute_cmd(cmd);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_RTC;
    }

e_test_RTC:
    if (ep != NULL)
    {
        rv = network_close(ep);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: network_close() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
            status = -1;
        }
        ep = NULL;
    }

    return status;
}

/****************************************************************************
 * verify_RtcBattery
 */
static int
verify_RtcBattery(void)
{
    int status = 0;
    ethIf_t *ep = NULL;
    char cmd[128];
    char local_time_str[128];
    char remote_time_str[128];
    struct tm local_tm;
    struct tm remote_tm;
    uint8_t if_type;
    const char *server_ip = NULL;
    int rv = 0;
    int x;
    const char *date_fmt = "%a %b %e %H:%M:%S %Y";

    //DWG U25:Battery
    // Target
    //   Read the current time/date from the RTC and verify against 
    //   hwclock --hctosys --utc
    //   rdate -p 10.10.10.1
    //     Sun Oct 28 16:53:07 2012
    //   date +"%a %b %e %H:%M:%S %Y"
    //     Sat Jan  1 01:05:06 2000

    sprintf(cmd, "hwclock --hctosys --utc");
    rv = execute_cmd(cmd);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_RtcBattery;
    }

    if_type = g_info.rtc_if;
    switch (if_type)
    {
    case NETWORK_ETHERNET:
        server_ip = g_info.ethernet.server_ip;
        break;

    case NETWORK_USBOTG:
    default:
        server_ip = g_info.usbotg.server_ip;
        break;
    }

    ep = network_open(if_type, 0);
    if (ep == NULL)
    {
        fprintf(stderr, "Error: %s: network_open() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_test_RtcBattery;
    }

    sprintf(cmd, "rdate -p %s", server_ip);
    rv = execute_cmd_ex(cmd, remote_time_str, sizeof(remote_time_str));
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd_ex('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_RtcBattery;
    }

    // Strip trailing whitespace
    for (x = strlen(remote_time_str); (x > 0) && isspace(remote_time_str[x - 1]); x--); remote_time_str[x] = '\0';
    if (remote_time_str[0] == '\0')
    {
        fprintf(stderr, "Error: %s: unable to read local time\n", __FUNCTION__);
        status = -1;
        goto e_test_RtcBattery;
    }
    if (g_info.verbose) fprintf(stdout, "Debug: %s: Remote time:'%s'\n", __FUNCTION__, remote_time_str);

    sprintf(cmd, "date +'%s'", date_fmt);
    rv = execute_cmd_ex(cmd, local_time_str, sizeof(local_time_str));
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd_ex('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_RtcBattery;
    }

    // Strip trailing whitespace
    for (x = strlen(local_time_str); (x > 0) && isspace(local_time_str[x - 1]); x--); local_time_str[x] = '\0';
    if (local_time_str[0] == '\0')
    {
        fprintf(stderr, "Error: %s: unable to read local time\n", __FUNCTION__);
        status = -1;
        goto e_test_RtcBattery;
    }
    if (g_info.verbose) fprintf(stdout, "Debug: %s: Local time:'%s'\n", __FUNCTION__, local_time_str);

    memset(&local_tm, 0, sizeof(local_tm));
    strptime(local_time_str, date_fmt, &local_tm);
    memset(&remote_tm, 0, sizeof(remote_tm));
    strptime(remote_time_str, date_fmt, &remote_tm);

    if (abs(mktime(&local_tm) - mktime(&remote_tm)) > 2)
    {
        fprintf(stderr, "Error: %s: local time '%s' does not match remote time '%s'\n", __FUNCTION__, local_time_str, remote_time_str);
        status = -1;
        goto e_test_RtcBattery;
    }

e_test_RtcBattery:
    if (ep != NULL)
    {
        rv = network_close(ep);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: network_close() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
            status = -1;
        }
        ep = NULL;
    }

    return status;
}

/****************************************************************************
 * test_RS485
 */
static int
test_RS485(void)
{
    const char *devices[] = { "/dev/ttySP0", "/dev/ttySP4" };

    //DWG J11:RS485:/dev/ttySP0 <==> J7:RS485:/dev/ttySP4

    return test_serial(devices, g_info.rs485_baud);
}

/****************************************************************************
 * test_AUART
 */
static int
test_AUART(void)
{
    const char *devices[] = { "/dev/ttySP1", "/dev/ttyUSB0" };

    //DWG J3:AUART1:/dev/ttySP1 <==> J4:USB1 w/ USB-to-Serial:/dev/ttyUSB0

    return test_serial(devices, g_info.rs232_baud);
}

/****************************************************************************
 * gpio_open
 */
static gpio_t *
gpio_open(uint8_t pin)
{
    gpio_t *gp = NULL;
    char path[128];
    FILE *fp = NULL;
    int rv = 0;
    int n;
    struct stat sbuf;

    if ((pin < GPIO_PIN_BASE) || (pin > GPIO_PIN_BASE + GPIO_NUM_PINS))
    {
        fprintf(stderr, "Error: %s: Invalid pin number %d\n", __FUNCTION__, pin);
        goto e_gpio_open;
    }

    n = sizeof(*gp);
    if ((gp = malloc(n)) == NULL)
    {
        fprintf(stderr, "Error: %s: malloc(%d) failed: %s [%d]\n", __FUNCTION__, n, strerror(errno), errno);
        goto e_gpio_open;
    }
    memset(gp, 0, n);

    gp->pin = pin;
    sprintf(gp->if_path, "%s/gpio%d", GPIO_PATH, gp->pin);

    sprintf(path, "%s/export", GPIO_PATH);
    fp = fopen(path, "ab");
    if (fp != NULL)
    {
        rv = fprintf(fp, "%d", gp->pin);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: fprintf('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
            goto e_gpio_open;
        }

        fclose(fp);
        fp = NULL;
    }
    else
    {
        fprintf(stderr, "Error: %s: fopen('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
        goto e_gpio_open;
    }

    memset(&sbuf, 0, sizeof(sbuf));
    rv = stat(gp->if_path, &sbuf);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: stat('%s') failed: %s [%d]\n", __FUNCTION__, gp->if_path, strerror(errno), errno);
        goto e_gpio_open;
    }

    if ((sbuf.st_mode & S_IFMT) != S_IFDIR)
    {
        fprintf(stderr, "Error: %s: GPIO interface '%s' export failed stat() st_mode:0x%08X\n", __FUNCTION__, gp->if_path, sbuf.st_mode);
        goto e_gpio_open;
    }
    gp->flags |= _GPIO_PIN_EXPORTED;

    rv = gpio_set_direction(gp, _GPIO_DIR_INPUT);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: gpio_set_direction(%d, INPUT) failed: %s [%d]\n", __FUNCTION__, gp->pin, strerror(errno), errno);
        goto e_gpio_open;
    }

    rv = gpio_set_polarity(gp, _GPIO_POL_NORMAL);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: gpio_set_polarity(%d, NORMAL) failed: %s [%d]\n", __FUNCTION__, gp->pin, strerror(errno), errno);
        goto e_gpio_open;
    }

    gp->flags |= _GPIO_PIN_OPEN;

e_gpio_open:
    if ((gp != NULL) && !(gp->flags & _GPIO_PIN_OPEN))
    {
        gpio_close(gp);
        gp = NULL;
    }

    return gp;
}

/****************************************************************************
 * gpio_set_direction
 */
static int
gpio_set_direction(gpio_t *gp, uint8_t direction)
{
    int status = 0;
    char path[128];
    FILE *fp = NULL;
    int rv = 0;
    char *direction_str = NULL;

    if (gp == NULL)
    {
        fprintf(stderr, "Error: %s: GPIO device handle is NULL\n", __FUNCTION__);
        status = -1;
        goto e_gpio_set_direction;
    }

    if (!(gp->flags & _GPIO_PIN_EXPORTED))
    {
        fprintf(stderr, "Error: %s: gpio#%d is not exported\n", __FUNCTION__, gp->pin);
        status = -1;
        goto e_gpio_set_direction;
    }

    if (gp->direction == direction)
    {
        goto e_gpio_set_direction;
    }

    switch (direction)
    {
    case _GPIO_DIR_INPUT:   direction_str = "in"; break;
    case _GPIO_DIR_OUTPUT:  direction_str = "out"; break;
    }

    if (direction_str == NULL)
    {
        fprintf(stderr, "Error: %s: gpio#%d unknown direction %d\n", __FUNCTION__, gp->pin, direction);
        status = -1;
        goto e_gpio_set_direction;
    }

    sprintf(path, "%s/direction", gp->if_path);
    fp = fopen(path, "ab");
    if (fp != NULL)
    {
        rv = fprintf(fp, "%s", direction_str);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: fprintf('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
            status = -1;
            goto e_gpio_set_direction;
        }

        fclose(fp);
        fp = NULL;
    }
    else
    {
        fprintf(stderr, "Error: %s: fopen('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
        status = -1;
        goto e_gpio_set_direction;
    }

    gp->direction = direction;

e_gpio_set_direction:
    if (fp != NULL)
    {
        fclose(fp);
        fp = NULL;
    }

    return status;
}

/****************************************************************************
 * gpio_set_polarity
 */
static int
gpio_set_polarity(gpio_t *gp, uint8_t polarity)
{
    int status = 0;
    char path[128];
    FILE *fp = NULL;
    int rv = 0;
    char *polarity_str = NULL;

    if (gp == NULL)
    {
        fprintf(stderr, "Error: %s: GPIO device handle is NULL\n", __FUNCTION__);
        status = -1;
        goto e_gpio_set_polarity;
    }

    if (!(gp->flags & _GPIO_PIN_EXPORTED))
    {
        fprintf(stderr, "Error: %s: gpio#%d is not exported\n", __FUNCTION__, gp->pin);
        status = -1;
        goto e_gpio_set_polarity;
    }

    if (gp->pin == (GPIO_PIN_BASE + 0))
    {
        switch (polarity)
        {
        case _GPIO_POL_NORMAL: polarity = _GPIO_POL_INVERT; break;
        case _GPIO_POL_INVERT: polarity = _GPIO_POL_NORMAL; break;
        }
    }

    if (gp->polarity == polarity)
    {
        goto e_gpio_set_polarity;
    }

    switch (polarity)
    {
    case _GPIO_POL_NORMAL: polarity_str = "0"; break;
    case _GPIO_POL_INVERT: polarity_str = "1"; break;
    }

    if (polarity_str == NULL)
    {
        fprintf(stderr, "Error: %s: gpio#%d unknown polarity %d\n", __FUNCTION__, gp->pin, polarity);
        status = -1;
        goto e_gpio_set_polarity;
    }

    sprintf(path, "%s/active_low", gp->if_path);
    fp = fopen(path, "ab");
    if (fp != NULL)
    {
        rv = fprintf(fp, "%s", polarity_str);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: fprintf('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
            status = -1;
            goto e_gpio_set_polarity;
        }

        fclose(fp);
        fp = NULL;
    }
    else
    {
        fprintf(stderr, "Error: %s: fopen('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
        status = -1;
        goto e_gpio_set_polarity;
    }

    gp->polarity = polarity;

e_gpio_set_polarity:
    if (fp != NULL)
    {
        fclose(fp);
        fp = NULL;
    }

    return status;
}

/****************************************************************************
 * gpio_get_value
 */
static int
gpio_get_value(gpio_t *gp, uint8_t *pvalue)
{
    int status = 0;
    char path[128];
    FILE *fp = NULL;
    int rv = 0;

    *pvalue = ~0x0;

    if (gp == NULL)
    {
        fprintf(stderr, "Error: %s: GPIO device handle is NULL\n", __FUNCTION__);
        status = -1;
        goto e_gpio_get_value;
    }

    if (!(gp->flags & _GPIO_PIN_EXPORTED))
    {
        fprintf(stderr, "Error: %s: gpio#%d is not exported\n", __FUNCTION__, gp->pin);
        status = -1;
        goto e_gpio_get_value;
    }

    sprintf(path, "%s/value", gp->if_path);
    fp = fopen(path, "rb");
    if (fp != NULL)
    {
        int value = -1;

        rv = fscanf(fp, "%d", &value);
        if (rv != 1)
        {
            fprintf(stderr, "Error: %s: gpio#%d unable to read value [%d]\n", __FUNCTION__, gp->pin, rv);
            status = -1;
            goto e_gpio_get_value;
        }
        if (g_info.debug & _DBG_DATA_ON) fprintf(stdout, "Debug: %s: Read '%s' %d\n", __FUNCTION__, path, value);

        *pvalue = (uint8_t) value;

        fclose(fp);
        fp = NULL;
    }
    else
    {
        fprintf(stderr, "Error: %s: fopen('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
        status = -1;
        goto e_gpio_get_value;
    }

e_gpio_get_value:
    if (fp != NULL)
    {
        fclose(fp);
        fp = NULL;
    }

    return status;
}

/****************************************************************************
 * gpio_set_value
 */
static int
gpio_set_value(gpio_t *gp, uint8_t value)
{
    int status = 0;
    char path[128];
    FILE *fp = NULL;
    int rv = 0;

    if (gp == NULL)
    {
        fprintf(stderr, "Error: %s: GPIO device handle is NULL\n", __FUNCTION__);
        status = -1;
        goto e_gpio_set_value;
    }

    if (!(gp->flags & _GPIO_PIN_EXPORTED))
    {
        fprintf(stderr, "Error: %s: gpio#%d is not exported\n", __FUNCTION__, gp->pin);
        status = -1;
        goto e_gpio_set_value;
    }

    if (gp->direction != _GPIO_DIR_OUTPUT)
    {
        fprintf(stderr, "Error: %s: gpio#%d is not set to input\n", __FUNCTION__, gp->pin);
        status = -1;
        goto e_gpio_set_value;
    }

    if (gp->polarity == _GPIO_POL_INVERT) value ^= 1;

    sprintf(path, "%s/value", gp->if_path);
    fp = fopen(path, "ab");
    if (fp != NULL)
    {
        rv = fprintf(fp, "%d", value);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: fprintf('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
            status = -1;
            goto e_gpio_set_value;
        }

        fclose(fp);
        fp = NULL;
    }
    else
    {
        fprintf(stderr, "Error: %s: fopen('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
        status = -1;
        goto e_gpio_set_value;
    }

e_gpio_set_value:
    if (fp != NULL)
    {
        fclose(fp);
        fp = NULL;
    }

    return status;
}

/****************************************************************************
 * gpio_close
 */
static int
gpio_close(gpio_t *gp)
{
    int status = 0;
    char path[128];
    FILE *fp = NULL;
    int rv = 0;

    if (gp == NULL)
    {
        fprintf(stderr, "Warning: %s: gpio already closed\n", __FUNCTION__);
        goto e_gpio_close;
    }

    if (gp->flags & _GPIO_PIN_EXPORTED)
    {
        gp->flags &= ~_GPIO_PIN_OPEN;
        gp->flags &= ~_GPIO_PIN_EXPORTED;

        sprintf(path, "%s/unexport", GPIO_PATH);
        fp = fopen(path, "ab");
        if (fp != NULL)
        {
            rv = fprintf(fp, "%d", gp->pin);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: fprintf('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
            }

            fclose(fp);
            fp = NULL;
        }
        else
        {
            fprintf(stderr, "Error: %s: fopen('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
            status = -1;
        }
    }

    free(gp);
    gp = NULL;

e_gpio_close:

    return status;
}

/****************************************************************************
 * test_GPIO
 */
static int
test_GPIO(void)
{
    int status = 0;
    int rv = 0;
    int n, x;
    int pin;
    gpio_t *gpio[GPIO_NUM_PINS];
    uint8_t value, act_value, exp_value;

    //DWG J8:GPIO
    // Target
    //   Loopback high 4xbits to low 4xbits
    //   Walking ones test high-to-low ports
    //   Walking ones test low-to-high ports

    for (n = 0; n < NELEM(gpio); n++)
    {
        gpio[n] = NULL;
    }

    for (n = 0; n < NELEM(gpio); n++)
    {
        pin = n + GPIO_PIN_BASE;

        gpio[n] = gpio_open(pin);
        if (gpio[n] == NULL)
        {
            fprintf(stderr, "Error: %s: gpio_open(%d) failed: %s [%d]\n", __FUNCTION__, pin, strerror(errno), errno);
            status = -1;
            goto e_test_GPIO;
        }
    }

    for (n = 0; n < NELEM(gpio); n++)
    {
        uint8_t direction = _GPIO_DIR_INPUT;
        rv = gpio_set_direction(gpio[n], direction);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: gpio_set_direction(%d, %s) failed: %s [%d]\n", __FUNCTION__, gpio[n]->pin, direction == _GPIO_DIR_INPUT ? "INPUT" : "OUTPUT", strerror(errno), errno);
            status = -1;
            goto e_test_GPIO;
        }

        uint8_t polarity = _GPIO_POL_NORMAL;
        rv = gpio_set_polarity(gpio[n], polarity);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: gpio_set_polarity(%d, %s) failed: %s [%d]\n", __FUNCTION__, gpio[n]->pin, polarity == _GPIO_POL_NORMAL ? "NORMAL" : "INVERT", strerror(errno), errno);
            status = -1;
            goto e_test_GPIO;
        }
    }

    for (n = 0; n < NELEM(gpio) / 2; n++)
    {
        uint8_t dir = _GPIO_DIR_OUTPUT;

        rv = gpio_set_direction(gpio[n], dir);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: gpio_set_direction(%d, %s) failed: %s [%d]\n", __FUNCTION__, gpio[n]->pin, (dir == _GPIO_DIR_OUTPUT) ? "OUTPUT" : "INPUT", strerror(errno), errno);
            status = -1;
            goto e_test_GPIO;
        }
    }

    act_value = 0x00;
    exp_value = 0x00;
    for (n = 0; n < NELEM(gpio); n++)
    {
        rv = gpio_get_value(gpio[n], &value);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: gpio_get_value(%d) failed: %s [%d]\n", __FUNCTION__, gpio[n]->pin, strerror(errno), errno);
            status = -1;
            goto e_test_GPIO;
        }

        act_value |= (value << gpio_map[n]);
    }
    if (g_info.verbose) fprintf(stdout, "Debug: %s: Output / Input read 0x%02X.\n", __FUNCTION__, act_value);
    if (act_value != exp_value)
    {
        fprintf(stderr, "Error: %s: All zero failed. Expected:0x%02X Actual:0x%02X\n", __FUNCTION__, exp_value, act_value);
        status = -1;
    }

    exp_value = 0x00;
    for (x = 0; x < NELEM(gpio) / 2; x++)
    {
        uint8_t pin = gpio_map[x];

        rv = gpio_set_value(gpio[pin], 1);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: gpio_set_value(%d) failed: %s [%d]\n", __FUNCTION__, gpio[pin]->pin, strerror(errno), errno);
            status = -1;
            goto e_test_GPIO;
        }

        act_value = 0x00;
        exp_value |= ((0x01 << x) | (0x10 << x));
        for (n = 0; n < NELEM(gpio); n++)
        {
            rv = gpio_get_value(gpio[n], &value);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: gpio_get_value(%d) failed: %s [%d]\n", __FUNCTION__, gpio[n]->pin, strerror(errno), errno);
                status = -1;
                goto e_test_GPIO;
            }

            act_value |= (value << gpio_map[n]);
        }
        if (g_info.verbose) fprintf(stdout, "Debug: %s: One fill test 0x%02X.\n", __FUNCTION__, act_value);
        if (act_value != exp_value)
        {
            fprintf(stderr, "Error: %s: One fill failed. Expected:0x%02X Actual:0x%02X\n", __FUNCTION__, exp_value, act_value);
            status = -1;
        }
    }

    exp_value = 0xFF;
    for (x = 0; x < NELEM(gpio) / 2; x++)
    {
        uint8_t pin = gpio_map[x];

        rv = gpio_set_value(gpio[pin], 0);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: gpio_set_value(%d) failed: %s [%d]\n", __FUNCTION__, gpio[pin]->pin, strerror(errno), errno);
            status = -1;
            goto e_test_GPIO;
        }

        act_value = 0x00;
        exp_value &= ~((0x01 << x) | (0x10 << x));
        for (n = 0; n < NELEM(gpio); n++)
        {
            rv = gpio_get_value(gpio[n], &value);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: gpio_get_value(%d) failed: %s [%d]\n", __FUNCTION__, gpio[n]->pin, strerror(errno), errno);
                status = -1;
                goto e_test_GPIO;
            }

            act_value |= (value << gpio_map[n]);
        }
        if (g_info.verbose) fprintf(stdout, "Debug: %s: Zero fill test 0x%02X.\n", __FUNCTION__, act_value);
        if (act_value != exp_value)
        {
            fprintf(stderr, "Error: %s: Zero fill failed. Expected:0x%02X Actual:0x%02X\n", __FUNCTION__, exp_value, act_value);
            status = -1;
        }
    }

    exp_value = 0x00;
    for (x = 0; x < NELEM(gpio) / 2; x++)
    {
        uint8_t pin = gpio_map[x];

        rv = gpio_set_value(gpio[pin], 1);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: gpio_set_value(%d) failed: %s [%d]\n", __FUNCTION__, gpio[pin]->pin, strerror(errno), errno);
            status = -1;
            goto e_test_GPIO;
        }

        act_value = 0x00;
        exp_value = ((0x01 << x) | (0x10 << x));
        for (n = 0; n < NELEM(gpio); n++)
        {
            rv = gpio_get_value(gpio[n], &value);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: gpio_get_value(%d) failed: %s [%d]\n", __FUNCTION__, gpio[n]->pin, strerror(errno), errno);
                status = -1;
                goto e_test_GPIO;
            }

            act_value |= (value << gpio_map[n]);
        }
        if (g_info.verbose) fprintf(stdout, "Debug: %s: Walking one test 0x%02X.\n", __FUNCTION__, act_value);
        if (act_value != exp_value)
        {
            fprintf(stderr, "Error: %s: Walking one failed. Expected:0x%02X Actual:0x%02X\n", __FUNCTION__, exp_value, act_value);
            status = -1;
        }

        rv = gpio_set_value(gpio[pin], 0);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: gpio_set_value(%d) failed: %s [%d]\n", __FUNCTION__, gpio[pin]->pin, strerror(errno), errno);
            status = -1;
            goto e_test_GPIO;
        }
    }

e_test_GPIO:
    for (n = 0; n < GPIO_NUM_PINS; n++)
    {
        if (gpio[n] != NULL)
        {
            pin = n + GPIO_PIN_BASE;

            rv = gpio_close(gpio[n]);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: gpio_close(%d) failed: %s [%d]\n", __FUNCTION__, pin, strerror(errno), errno);
                status = -1;
            }
            gpio[n] = NULL;
        }
    }

    return status;
}

/****************************************************************************
 * test_SPI
 */
static int
test_SPI(int instance)
{
    int status = 0;
    int rv = 0;
    char device[64];
    int fd = -1;
    uint8_t mode = 0x0;
    uint8_t bits = 8;
    uint8_t cs_change = 0;
    uint32_t speed = 10 * 1000 * 1000;
    uint16_t delay = 0;
    int n;

    //DWG J9:SPI with 2x CS
    // Target
    //   ????

#ifdef DWG_ALGO
    mode |= SPI_LOOP;
    mode |= SPI_CPHA;
    mode |= SPI_CPOL;
    mode |= SPI_LSB_FIRST;
    mode |= SPI_CS_HIGH;
    mode |= SPI_3WIRE;
    mode |= SPI_NO_CS;
    mode |= SPI_READY;
#endif // DWG_ALGO

    sprintf(device, "/dev/spidev%d.%d", g_info.spi_bus, instance);
    fd = open(device, O_RDWR);
    if (fd < 0)
    {
        fprintf(stderr, "Error: %s: open('%s') failed: %s [%d]\n", __FUNCTION__, device, strerror(errno), errno);
        status = -1;
        goto e_test_SPI;
    }

    rv = ioctl(fd, SPI_IOC_WR_MODE, &mode);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(SPI_IOC_WR_MODE) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = rv;
        goto e_test_SPI;
    }

    rv = ioctl(fd, SPI_IOC_RD_MODE, &mode);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(SPI_IOC_RD_MODE) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = rv;
        goto e_test_SPI;
    }

    rv = ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bits);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(SPI_IOC_WR_BITS_PER_WORD) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = rv;
        goto e_test_SPI;
    }

    rv = ioctl(fd, SPI_IOC_RD_BITS_PER_WORD, &bits);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(SPI_IOC_RD_BITS_PER_WORD) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = rv;
        goto e_test_SPI;
    }

    rv = ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(SPI_IOC_WR_MAX_SPEED_HZ) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = rv;
        goto e_test_SPI;
    }

    rv = ioctl(fd, SPI_IOC_RD_MAX_SPEED_HZ, &speed);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(SPI_IOC_RD_MAX_SPEED_HZ) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = rv;
        goto e_test_SPI;
    }

    printf("spi mode: %d\n", mode);
    printf("bits per word: %d\n", bits);
    printf("max speed: %d Hz (%d KHz)\n", speed, speed/1000);

#ifndef DWG
{
    uint8_t tx[] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x40, 0x00, 0x00, 0x00, 0x00, 0x95,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xDE, 0xAD, 0xBE, 0xEF, 0xBA, 0xAD,
        0xF0, 0x0D,
    };
    uint8_t rx[NELEM(tx)];
    struct spi_ioc_transfer tr = {
        .tx_buf = (unsigned long)tx,
        .rx_buf = (unsigned long)rx,
        .len = NELEM(tx),
        .delay_usecs = delay,
        .speed_hz = speed,
        .bits_per_word = bits,
        .cs_change = cs_change,
    };

    memset(rx, 0, sizeof(rx));

    rv = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(SPI_IOC_MESSAGE) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = rv;
        goto e_test_SPI;
    }

    for (n = 0; n < tr.len; n++)
    {
        if (!(n % 6))
        {
            puts("");
        }
        printf("%.2X ", rx[n]);
    }
    puts("");
}
#endif // DWG

e_test_SPI:
    if (fd >= 0)
    {
        close(fd);
        fd = -1;
    }

    return status;
}

/****************************************************************************
 * test_SPI0
 */
static int
test_SPI0(void)
{
    return test_SPI(0);
}

/****************************************************************************
 * test_SPI1
 */
static int
test_SPI1(void)
{
    return test_SPI(1);
}

/****************************************************************************
 * test_I2C
 */
static int
test_I2C(void)
{
    int status = 0;
#define I2CERR_FILE_OP_FAILED   -1
#define I2CERR_ODD_ADDR         -2
#define I2CERR_INV_PARMS        -3
#define I2CERR_NOT_IMPL         -4
#define I2CERR_SLAVE            -5
#define I2CERR_RDWR             -6

    int rv = 0;
    char device[64];
    int fd = -1;
    uint8_t *tx_buf = NULL;
    int tx_buf_len = 32;
    uint8_t *rx_buf = NULL;
    int rx_buf_len = tx_buf_len * 2;
    int nbytes;
    uint8_t i2c_addr = g_info.i2c_addr;
    uint8_t i2c_offset = g_info.i2c_offset;
    int x;

    //DWG J9:I2C
    // Target
    //   Write data to the device and read/verify the data is correct

    sprintf(device, "%s", g_info.i2c_path);
    fd = open(device, O_RDWR);
    if (fd < 0)
    {
        fprintf(stderr, "Error: %s: open('%s') failed: %s [%d]\n", __FUNCTION__, device, strerror(errno), errno);
        status = -1;
        goto e_test_I2C;
    }

    if ((tx_buf = malloc(tx_buf_len)) == NULL)
    {
        fprintf(stderr, "Error: %s: malloc(%d) failed: %s [%d]\n", __FUNCTION__, tx_buf_len, strerror(errno), errno);
        goto e_test_I2C;
    }
    memset(tx_buf, 0, tx_buf_len);

    srandom(0x1234);
    for (x = 0; x < tx_buf_len; x++)
    {
        tx_buf[x] = (uint8_t) random();
    }

    if ((rx_buf = malloc(rx_buf_len)) == NULL)
    {
        fprintf(stderr, "Error: %s: malloc(%d) failed: %s [%d]\n", __FUNCTION__, rx_buf_len, strerror(errno), errno);
        goto e_test_I2C;
    }
    memset(rx_buf, 0, rx_buf_len);

    // ----------------------------
    if (g_info.verbose) fprintf(stdout, "Debug: %s: Writing %d bytes to I2C device 0x%02X offset 0x%02X.\n", __FUNCTION__, tx_buf_len, i2c_addr, i2c_offset);
    if (g_info.debug & _DBG_DATA_ON) fprintf(stdout, "Debug: %s: transmit '%s'[%d] to I2C device 0x%02X\n", __FUNCTION__, DbgDataToHexString(tx_buf, 0, tx_buf_len, NULL, 0), tx_buf_len, i2c_addr);
    rv = ioctl(fd, I2C_SLAVE, i2c_addr);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(I2C_SLAVE) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = I2CERR_FILE_OP_FAILED;
        goto e_test_I2C;
    }

    nbytes = 0;
#ifdef _I2C_BLOCK_WRITE
    rv = i2c_smbus_write_block_data(fd, i2c_offset, tx_buf_len, tx_buf);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: i2c_smbus_write_byte_block_data() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = I2CERR_RDWR;
        goto e_test_I2C;
    }

    nbytes += tx_buf_len;
#else // _I2C_BLOCK_WRITE
    for (x = 0; x < tx_buf_len; x++)
    {
        rv = i2c_smbus_write_byte_data(fd, i2c_offset + x, tx_buf[x]);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: i2c_smbus_write_byte_data() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
            status = I2CERR_RDWR;
            goto e_test_I2C;
        }

        nbytes += 1;
    }
#endif // _I2C_BLOCK_WRITE
    if (nbytes != tx_buf_len)
    {
        fprintf(stderr, "Error: %s: system sent only %d of requested %d bytes to I2C device 0x%02X.\n", __FUNCTION__, nbytes, tx_buf_len, i2c_addr);
        status = -1;
        goto e_test_I2C;
    }

    rx_buf_len = tx_buf_len;

    // ----------------------------
    if (g_info.verbose) fprintf(stdout, "Debug: %s: Reading %d bytes from I2C device 0x%02X offset 0x%02X.\n", __FUNCTION__, rx_buf_len, i2c_addr, i2c_offset);
    rv = ioctl(fd, I2C_SLAVE, i2c_addr);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(I2C_SLAVE) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = I2CERR_FILE_OP_FAILED;
        goto e_test_I2C;
    }

    nbytes = 0;
#ifdef _I2C_BLOCK_READ
    rv = i2c_smbus_read_block_data(fd, i2c_offset, rx_buf);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: i2c_smbus_read_byte_block_data() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = I2CERR_RDWR;
        goto e_test_I2C;
    }

    nbytes += rv;
#else // _I2C_BLOCK_READ
    for (x = 0; x < rx_buf_len; x++)
    {
        rv = i2c_smbus_read_byte_data(fd, i2c_offset + x);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: i2c_smbus_read_byte_data() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
            status = I2CERR_RDWR;
            goto e_test_I2C;
        }

        rx_buf[x] = rv;

        nbytes += 1;
    }
#endif // _I2C_BLOCK_READ
    if (g_info.debug & _DBG_DATA_ON) fprintf(stdout, "Debug: %s: receive  '%s'[%d] from I2C device 0x%02X\n", __FUNCTION__, DbgDataToHexString(rx_buf, 0, nbytes, NULL, 0), nbytes, i2c_addr);
    if (nbytes != tx_buf_len)
    {
        fprintf(stderr, "Error: %s: I2C device 0x%02X responded with only %d of requested %d bytes.\n", __FUNCTION__, i2c_addr, nbytes, tx_buf_len);
        status = -1;
        goto e_test_I2C;
    }

    if (memcmp(tx_buf, rx_buf, nbytes) != 0)
    {
        fprintf(stderr, "Error: %s: Received data did not match.\n", __FUNCTION__);
        if (g_info.verbose) fprintf(stdout, "Debug: %s: transmit '%s'[%d]\n", __FUNCTION__, DbgDataToHexString(tx_buf, 0, tx_buf_len, NULL, 0), tx_buf_len);
        if (g_info.verbose) fprintf(stdout, "Debug: %s: receive  '%s'[%d]\n", __FUNCTION__, DbgDataToHexString(rx_buf, 0, rx_buf_len, NULL, 0), rx_buf_len);
        status = -1;
        goto e_test_I2C;
    }

#ifdef DWG_I2C_WORD_TEST
    // ----------------------------
    if (i2c_offset & 1)
    {
        status = I2CERR_ODD_ADDR;
        goto e_test_I2C;
    }

    rv = ioctl(fd, I2C_SLAVE, i2c_addr);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(I2C_SLAVE) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = I2CERR_FILE_OP_FAILED;
        goto e_test_I2C;
    }

    if (i2c_offset == REGADDR_NONE)
    {
        rv = write(fd, tx_buf, tx_buf_len * 2);
    }
    else
    {
        for (x = 0; x < tx_buf_len; x++)
        {
            rv = i2c_smbus_write_word_data(fd, i2c_offset + (x * 2), tx_buf[x]);
        }
    }

    // ----------------------------
    if (i2c_offset & 1)
    {
        status = I2CERR_ODD_ADDR;
        goto e_test_I2C;
    }

    rv = ioctl(fd, I2C_SLAVE, i2c_addr);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(I2C_SLAVE) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = I2CERR_FILE_OP_FAILED;
        goto e_test_I2C;
    }

    if (i2c_offset == REGADDR_NONE)
    {
        rv = read(fd, rx_buf, rx_buf_len * 2);
    }
    else
    {
        for (x = 0; x < rx_buf_len; x++)
        {
            rv = i2c_smbus_read_word_data(fd, i2c_offset + (x * 2));
            rx_buf[x] = rv;
        }
    }
#endif // DWG_I2C_WORD_TEST

e_test_I2C:
    if (rx_buf != NULL)
    {
        free(rx_buf);
        rx_buf = NULL;
        rx_buf_len = 0;
    }

    if (tx_buf != NULL)
    {
        free(tx_buf);
        tx_buf = NULL;
        tx_buf_len = 0;
    }

    if (fd >= 0)
    {
        close(fd);
        fd = -1;
    }

    return status;
}

/****************************************************************************
 * test_CAN
 */
static int
test_CAN(int instance)
{
#ifndef AF_CAN
# define AF_CAN      29
# define PF_CAN      AF_CAN
#endif /* AF_CAN */
    int status = 0;
    int rv = 0;
    int s = -1;
    struct sockaddr_can sAddr;
    struct ifreq ifr;
    struct can_frame tx_frame;
    struct can_frame rx_frame;
    struct timeval timeout;
    bool done;
    int nbytes;
    ethIf_t *ep = NULL;
    int x;
    #define _CAN_INTERFACE_UP   (0x01 << 0)
    uint8_t flags = 0x0;

    //DWG J12:CAN
    // Target
    //   Write data to the device and read/verify the data is correct

    ep = network_open(NETWORK_CAN, instance);
    if (ep == NULL)
    {
        fprintf(stderr, "Error: %s: network_open() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_test_CAN;
    }
    flags |= _CAN_INTERFACE_UP;

    s = socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if (s < 0)
    {
        fprintf(stderr, "Error: %s: socket(PF_CAN) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_test_CAN;
    }

    memset(&ifr, 0, sizeof(ifr));
    sprintf(ifr.ifr_name, "can%d", instance);
    rv = ioctl(s, SIOGIFINDEX, &ifr);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(SIOGIFINDEX) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_test_CAN;
    }

    memset(&sAddr, 0, sizeof(sAddr));
    sAddr.can_family = AF_CAN;
    sAddr.can_ifindex = ifr.ifr_ifindex;

    rv = bind(s, (struct sockaddr *)&sAddr, sizeof(sAddr));
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: bind() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_test_CAN;
    }

    srandom(0x1234);

    memset(&tx_frame, 0, sizeof(tx_frame));
    tx_frame.can_id = 0;
    tx_frame.can_dlc = 8;
    for (x = 0; x < tx_frame.can_dlc; x++)
    {
        tx_frame.data[x] = (uint8_t) random();
    }

    if (g_info.debug & _DBG_DATA_ON) fprintf(stdout, "Debug: %s: transmit CAN packet '%s'[%ld]\n", __FUNCTION__, DbgDataToHexString(&tx_frame, 0, sizeof(tx_frame), NULL, 0), sizeof(tx_frame));
    nbytes = write(s, &tx_frame, sizeof(tx_frame));
    if (nbytes < 0)
    {
        fprintf(stderr, "Error: %s: write() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_test_CAN;
    }

    timeout.tv_sec = 1;
    timeout.tv_usec = 0;

    done = FALSE;
    while (!done)
    {
        int maxFd = -1;
        fd_set readFds;

        FD_ZERO(&readFds);
        FD_SET(s, &readFds);
        maxFd = s;

        switch (select(maxFd + 1, &readFds, NULL, NULL, &timeout))
        {
        case -1: // Error
            if (errno != EINTR)
            {
                fprintf(stderr, "Error: %s: select() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                status = -1;
                done = TRUE;
            }
            break;

        case 0: // Timeout
            fprintf(stderr, "Error: %s: Timeout waiting CAN response.\n", __FUNCTION__);
            status = -1;
            done = TRUE;
            break;

        default:
            if (FD_ISSET(s, &readFds))
            {
                memset(&rx_frame, 0, sizeof(rx_frame));
                nbytes = read(s, &rx_frame, sizeof(rx_frame));
                if (nbytes < 0)
                {
                    fprintf(stderr, "Error: %s: read() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                    status = -1;
                    goto e_test_CAN;
                }
                if (g_info.debug & _DBG_DATA_ON) fprintf(stdout, "Debug: %s: receive  CAN packet '%s'[%d]\n", __FUNCTION__, DbgDataToHexString(&rx_frame, 0, nbytes, NULL, 0), nbytes);

                if (nbytes < sizeof(rx_frame))
                {
                    fprintf(stderr, "Error: %s: CAN bus read returned %d bytes, expected %ld.\n", __FUNCTION__, nbytes, sizeof(rx_frame));
                    status = -1;
                    goto e_test_CAN;
                }

                if (memcmp(&tx_frame, &rx_frame, nbytes) != 0)
                {
                    fprintf(stderr, "Error: %s: Received data did not match.\n", __FUNCTION__);
                    if (g_info.verbose) fprintf(stdout, "Debug: %s: transmit '%s'[%ld]\n", __FUNCTION__, DbgDataToHexString(&tx_frame, 0, sizeof(tx_frame), NULL, 0), sizeof(tx_frame));
                    if (g_info.verbose) fprintf(stdout, "Debug: %s: receive  '%s'[%ld]\n", __FUNCTION__, DbgDataToHexString(&rx_frame, 0, sizeof(rx_frame), NULL, 0), sizeof(rx_frame));
                    status = -1;
                    goto e_test_CAN;
                }

                done = TRUE;
            }
            break;
        }

        // Reset polling interval
        timeout.tv_sec = 1;
        timeout.tv_usec = 0;
    }

e_test_CAN:
    if (s >= 0)
    {
        close(s);
        s = -1;
    }

    if (flags & _CAN_INTERFACE_UP)
    {
        if (ep != NULL)
        {
            rv = network_close(ep);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: network_close() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                status = -1;
            }
            ep = NULL;
        }
        flags &= ~_CAN_INTERFACE_UP;
    }

    return status;
}

/****************************************************************************
 * test_CAN0
 */
static int
test_CAN0(void)
{
    return test_CAN(0);
}

/****************************************************************************
 * test_CAN1
 */
static int
test_CAN1(void)
{
    return test_CAN(1);
}

/****************************************************************************
 * test_USBOTG
 */
static int
test_USBOTG(void)
{
    int status = 0;
    const char local_file[] = "/tmp/UsbOtgDownload";
    char cmd[128];
    int rv = 0;
    ethIf_t *ep = NULL;

    #define _USBOTG_INTERFACE_UP    (0x01 << 0)
    #define _USBOTG_FILE_DOWNLOADED (0x01 << 1)
    uint8_t flags = 0x0;

    //DWG J2:USB0 <==> Host via USB-Ethernet
    // Host
    //   - Enable web server
    //   - /etc/sysconfig/network-scripts/ifcfg-usb0
    //       TYPE=Ethernet
    //       BOOTPROTO=none
    //       IPADDR0=10.0.0.1
    //       PREFIX0=24
    //       DEFROUTE=yes
    //       IPV4_FAILURE_FATAL=yes
    //       IPV6INIT=no
    //       NAME=usb0
    //       UUID=05e483a4-657d-4553-8d98-dd6f63ffc9c6
    //       ONBOOT=yes
    //       HWADDR=10:20:30:40:50:60
    //
    // Target
    //   modprobe g_ether host_addr=10:20:30:40:50:60
    //   ifconfig usb0 10.0.0.2 netmask 255.255.255.0 up
    //   ping 10.0.0.1
    //   cd /tmp
    //   wget http://10.0.0.1/~reach/File-50M
    //   rm File-50M

    ep = network_open(NETWORK_USBOTG, 0);
    if (ep == NULL)
    {
        fprintf(stderr, "Error: %s: network_open() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_test_USBOTG;
    }
    flags |= _USBOTG_INTERFACE_UP;

    flags |= _USBOTG_FILE_DOWNLOADED;
    sprintf(cmd, "wget -nv -O %s http://%s/%s", local_file, g_info.usbotg.server_ip, g_info.file_path);
    rv = execute_cmd(cmd);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_USBOTG;
    }

e_test_USBOTG:
    if (flags & _USBOTG_FILE_DOWNLOADED)
    {
        sprintf(cmd, "rm -f %s", local_file);
        rv = execute_cmd(cmd);
        if (rv < 0)
        {
            fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
            status = rv;
        }
        flags &= ~_USBOTG_FILE_DOWNLOADED;
    }

    if (flags & _USBOTG_INTERFACE_UP)
    {
        if (ep != NULL)
        {
            rv = network_close(ep);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: network_close() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                status = -1;
            }
            ep = NULL;
        }
        flags &= ~_USBOTG_INTERFACE_UP;
    }

    return status;
}

/****************************************************************************
 * test_UsbDiskDrive
 */
static int
test_UsbDiskDrive(int instance)
{
    int status = 0;
    char cmd[128];
    char dev[16];
    int rv = 0;

    // Target
    //   Read USB disk drive attached to the USB port
    //     dd if=/dev/sda of=/dev/null bs=1k count=64

    sprintf(dev, "/dev/sd%c", 'a' + instance);
    if (g_info.verbose) fprintf(stdout, "Debug: %s: Test USB port with USB disk drive %s.\n", __FUNCTION__, dev);

    sprintf(cmd, "dd if=%s of=/dev/null bs=1k count=64", dev);
    rv = execute_cmd(cmd);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_UsbDiskDrive;
    }

e_test_UsbDiskDrive:

    return status;
}

/****************************************************************************
 * test_UsbBarcodeScanner
 */
static int
test_UsbBarcodeScanner(void)
{
    int status = 0;
    int rv = 0;
    char buf[128];
    uint8_t blen;

    // Target
    //   Read any barcode using the USB barcode scanner

    if (g_info.verbose) fprintf(stdout, "Debug: %s: Test USB port with USB Barcode Scanner.\n", __FUNCTION__);

    fprintf(stdout, "User: Scan any barcode to complete test.\n");
    blen = sizeof(buf);
    rv = barcode_read(buf, &blen, 10 * 1000 * 1000);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: barcode_read() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = rv;
        goto e_test_UsbBarcodeScanner;
    }
    if (g_info.verbose) fprintf(stdout, "Debug: %s: Barcode Scanner returned '%s'[%d]\n", __FUNCTION__, DbgDataToString(buf, 0, blen, NULL, 0), blen);

e_test_UsbBarcodeScanner:

    return status;
}

/****************************************************************************
 * test_UsbSerial
 */
static int
test_UsbSerial(void)
{
    const char *devices[] = { "/dev/ttyUSB0", "/dev/ttySP1" };

    //DWG J4:USB1 w/ USB-to-Serial:/dev/ttyUSB0 <==> J3:AUART1:/dev/ttySP1

    if (g_info.verbose) fprintf(stdout, "Debug: %s: Test USB port with USB Serial device.\n", __FUNCTION__);

    return test_serial(devices, g_info.rs232_baud);
}

/****************************************************************************
 * scan_usb_devices
 */
static int
scan_usb_devices(void)
{
    int status = 0;
    char cmd[128];
    char response[2048];
    uint8_t usb_devices[8];
    int rv = 0;

    /* Scan already complete. No need to rescan. */
    if (NumUsbList != 0)
    {
        goto e_scan_usb_devices;
    }

    memset(usb_devices, 0, sizeof(usb_devices));

    sprintf(cmd, "lsusb -v | grep -e iProduct -e bInterfaceClass");
    rv = execute_cmd_ex(cmd, response, sizeof(response));
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd_ex('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_scan_usb_devices;
    }

    /*
     * Response from the command:
     *   iProduct                2 Freescale On-Chip EHCI Host Controller
     *       bInterfaceClass         9 Hub
     *   iProduct                0 
     *       bInterfaceClass         9 Hub
     *       bInterfaceClass         9 Hub
     *   iProduct                0 
     *       bInterfaceClass         9 Hub
     *       bInterfaceClass         9 Hub
     *   iProduct                2 usb serial converter
     *       bInterfaceClass       255 Vendor Specific Class
     *   iProduct                2 Patriot Memory
     *       bInterfaceClass         8 Mass Storage
     *   iProduct                4 USB Storage
     *       bInterfaceClass         8 Mass Storage
     *   iProduct                2 Handheld Barcode Scanner
     *       bInterfaceClass         3 Human Interface Device
     */

    char *p;
    for (p = strtok(response, "\n"); p != NULL; p = strtok(NULL, "\n"))
    {
        if (strstr(p, "Hub") != NULL)
        {
            continue;
        }

        if (strcasestr(p, "serial") != NULL)
        {
            usb_devices[_USB_SERIAL]++;
            continue;
        }
        if (strstr(p, "Mass Storage") != NULL)
        {
            usb_devices[_USB_MASS_STORAGE]++;
            continue;
        }
        if (strstr(p, "Barcode Scanner") != NULL)
        {
            usb_devices[_USB_BARCODE_SCANNER]++;
            continue;
        }
    }

    NumUsbList = 0;
    if (usb_devices[_USB_SERIAL])
    {
        UsbList[NumUsbList++] = (_USB_SERIAL << 1);
    }
    if (usb_devices[_USB_MASS_STORAGE] > 0)
    {
        UsbList[NumUsbList++] = (_USB_MASS_STORAGE << 1);
    }
    if (usb_devices[_USB_MASS_STORAGE] > 1)
    {
        UsbList[NumUsbList++] = (_USB_MASS_STORAGE << 1) | 1;
    }
    if (usb_devices[_USB_BARCODE_SCANNER])
    {
        UsbList[NumUsbList++] = (_USB_BARCODE_SCANNER << 1);
    }

e_scan_usb_devices:

    return status;
}

/****************************************************************************
 * test_USB1
 */
static int
test_USB1(void)
{
    int status = 0;
    int rv = 0;

    //DWG J4:USB1

    rv = scan_usb_devices();
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: scan_usb_devices() failed.\n", __FUNCTION__);
        status = -1;
        goto e_test_USB1;
    }

    if (NumUsbList <= 0)
    {
        fprintf(stderr, "Warning: %s: %d USB devices connected. Unable to test 1st USB device.\n", __FUNCTION__, NumUsbList);
        status = 1;
        goto e_test_USB1;
    }

    int n = 0;
    switch (UsbList[n] >> 1)
    {
    case _USB_SERIAL:
        status = test_UsbSerial();
        break;

    case _USB_MASS_STORAGE:
        status = test_UsbDiskDrive(UsbList[n] & 0x01);
        break;

    case _USB_BARCODE_SCANNER:
        status = test_UsbBarcodeScanner();
        break;
    }

e_test_USB1:

    return status;
}

/****************************************************************************
 * test_USB2
 */
static int
test_USB2(void)
{
    int status = 0;
    int rv = 0;

    //DWG J1:USB2

    rv = scan_usb_devices();
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: scan_usb_devices() failed.\n", __FUNCTION__);
        status = -1;
        goto e_test_USB2;
    }

    if (NumUsbList <= 1)
    {
        fprintf(stderr, "Warning: %s: %d USB devices connected. Unable to test 2nd USB device.\n", __FUNCTION__, NumUsbList);
        status = 1;
        goto e_test_USB2;
    }

    int n = 1;
    switch (UsbList[n] >> 1)
    {
    case _USB_SERIAL:
        status = test_UsbSerial();
        break;

    case _USB_MASS_STORAGE:
        status = test_UsbDiskDrive(UsbList[n] & 0x01);
        break;

    case _USB_BARCODE_SCANNER:
        status = test_UsbBarcodeScanner();
        break;
    }

e_test_USB2:

    return status;
}

/****************************************************************************
 * test_TouchScreen
 */
static int
test_TouchScreen(void)
{
    int status = 0;
    char cmd[128];
    int rv = 0;

    //DWG J13:TouchScreen
    // Target
    //   Run ts_calibrate

    fprintf(stdout, "User: Perform LCD touchscreen calibration.\n");
    sprintf(cmd, "ts_calibrate");
    rv = execute_cmd(cmd);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_TouchScreen;
    }

e_test_TouchScreen:

    return status;
}

/****************************************************************************
 * test_LCD
 */
static int
test_LCD(void)
{
    int status = 0;
    char cmd[128];
    int rv = 0;

    //DWG J13:LCD
    // Target
    //   Display patterns on the screen using QML with pass/fail buttons

#ifdef DWG
    sprintf(cmd, "ts_calibrate");
    rv = execute_cmd(cmd);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: execute_cmd('%s') failed: %s [%d]\n", __FUNCTION__, cmd, strerror(errno), errno);
        status = rv;
        goto e_test_LCD;
    }
#else // DWG
status = 1; goto e_test_LCD;
#endif // DWG

e_test_LCD:

    return status;
}

/****************************************************************************
 * test_Backlight
 */
static int
test_Backlight(void)
{
    int status = 0;
    int rv = 0;
    char path[128];
    FILE *fp = NULL;
    int delay = 50 * 1000;
    int num_powercycles = 4;

    //DWG J13:Backlight
    // Target
    //   Display slider on the screen using QML that adjusts the screen brightness with pass/fail buttons

    sprintf(path, "/sys/class/backlight/mxs-bl/brightness");
    fp = fopen(path, "ab");
    if (fp != NULL)
    {
        int brightness;

        // Backlight brightness ramp down
        brightness = 100;
        while (brightness >= 0)
        {
            if (g_info.verbose) fprintf(stdout, "Debug: %s: Brightness %d.\n", __FUNCTION__, brightness);
            rv = fprintf(fp, "%d", brightness); fflush(fp);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: fprintf('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
                status = -1;
                goto e_test_Backlight;
            }

            usleep(delay);
            brightness -= 10;
        }

        // Backlight brightness ramp up
        brightness = 0;
        while (brightness <= 100)
        {
            if (g_info.verbose) fprintf(stdout, "Debug: %s: Brightness %d.\n", __FUNCTION__, brightness);
            rv = fprintf(fp, "%d", brightness); fflush(fp);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: fprintf('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
                status = -1;
                goto e_test_Backlight;
            }

            usleep(delay);
            brightness += 10;
        }

        fclose(fp);
        fp = NULL;
    }
    else
    {
        fprintf(stderr, "Error: %s: fopen('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
        status = -1;
        goto e_test_Backlight;
    }

    sprintf(path, "/sys/class/backlight/mxs-bl/bl_power");
    fp = fopen(path, "ab");
    if (fp != NULL)
    {
        int x;

        // Backlight power on/off
        for (x = 0; x < num_powercycles; x++)
        {
            usleep(delay * 10);

            if (g_info.verbose) fprintf(stdout, "Debug: %s: Backlight power %s.\n", __FUNCTION__, x & 1 ? "on" : "off");
            rv = fprintf(fp, "%d", (x & 1) ^ 1); fflush(fp);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: fprintf('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
                status = -1;
                goto e_test_Backlight;
            }
        }

        fclose(fp);
        fp = NULL;
    }
    else
    {
        fprintf(stderr, "Error: %s: fopen('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
        status = -1;
        goto e_test_Backlight;
    }

e_test_Backlight:
    if (fp != NULL)
    {
        fclose(fp);
        fp = NULL;
    }

    return status;
}

/****************************************************************************
 * barcode_read
 */
static int
barcode_read(char *buffer, uint8_t *pbuffer_size, uint32_t timeout_us)
{
    int status = 0;
    char device[64];
    int fd = -1;
    int rv = 0;
    uint8_t blen = 0;
    #define _SHIFT      (0x01 << 0)
    uint8_t flags = 0x00;
    int x;

    const struct {
        const char *normal;
        const char *shifted;
    } keycode[] = {
        { "{RSV}",        "{RSV}"        }, /* KEY_RESERVED   */
        { "{ESC}",        "{ESC}"        }, /* KEY_ESC        */
        { "1",            "!"            }, /* KEY_1          */
        { "2",            "@"            }, /* KEY_2          */
        { "3",            "#"            }, /* KEY_3          */
        { "4",            "$"            }, /* KEY_4          */
        { "5",            "%"            }, /* KEY_5          */
        { "6",            "^"            }, /* KEY_6          */
        { "7",            "&"            }, /* KEY_7          */
        { "8",            "*"            }, /* KEY_8          */
        { "9",            "("            }, /* KEY_9          */
        { "0",            ")"            }, /* KEY_0          */
        { "-",            "_"            }, /* KEY_MINUS      */
        { "=",            "+"            }, /* KEY_EQUAL      */
        { "{BS}",         "{BS}"         }, /* KEY_BACKSPACE  */
        { "\t",           "\t"           }, /* KEY_TAB        */
        { "q",            "Q"            }, /* KEY_Q          */
        { "w",            "W"            }, /* KEY_W          */
        { "e",            "E"            }, /* KEY_E          */
        { "r",            "R"            }, /* KEY_R          */
        { "t",            "T"            }, /* KEY_T          */
        { "y",            "Y"            }, /* KEY_Y          */
        { "u",            "U"            }, /* KEY_U          */
        { "i",            "I"            }, /* KEY_I          */
        { "o",            "O"            }, /* KEY_O          */
        { "p",            "P"            }, /* KEY_P          */
        { "[",            "{"            }, /* KEY_LEFTBRACE  */
        { "]",            "}"            }, /* KEY_RIGHTBRACE */
        { "\n",           "\n"           }, /* KEY_ENTER      */
        { "{LCTRL}",      "{LCTRL}"      }, /* KEY_LEFTCTRL   */
        { "a",            "A"            }, /* KEY_A          */
        { "s",            "S"            }, /* KEY_S          */
        { "d",            "D"            }, /* KEY_D          */
        { "f",            "F"            }, /* KEY_F          */
        { "g",            "G"            }, /* KEY_G          */
        { "h",            "H"            }, /* KEY_H          */
        { "j",            "J"            }, /* KEY_J          */
        { "k",            "K"            }, /* KEY_K          */
        { "l",            "L"            }, /* KEY_L          */
        { ";",            ":"            }, /* KEY_SEMICOLON  */
        { "'",            "\""           }, /* KEY_APOSTROPHE */
        { "`",            "~"            }, /* KEY_GRAVE      */
        { "{LSHIFT}",     "{LSHIFT}"     }, /* KEY_LEFTSHIFT  */
        { "\\",           "|"            }, /* KEY_BACKSLASH  */
        { "z",            "Z"            }, /* KEY_Z          */
        { "x",            "X"            }, /* KEY_X          */
        { "c",            "C"            }, /* KEY_C          */
        { "v",            "V"            }, /* KEY_V          */
        { "b",            "B"            }, /* KEY_B          */
        { "n",            "N"            }, /* KEY_N          */
        { "m",            "M"            }, /* KEY_M          */
        { ",",            "<"            }, /* KEY_COMMA      */
        { ".",            ">"            }, /* KEY_DOT        */
        { "/",            "?"            }, /* KEY_SLASH      */
        { "{RSHIFT}",     "{RSHIFT}"     }, /* KEY_RIGHTSHIFT */
        { "*",            "*"            }, /* KEY_KPASTERISK */
        { "{LALT}",       "{LALT}"       }, /* KEY_LEFTALT    */
        { " ",            " "            }, /* KEY_SPACE      */
        { "{CAPS}",       "{CAPS}"       }, /* KEY_CAPSLOCK   */
        { "{F1}",         "{F1}"         }, /* KEY_F1         */
        { "{F2}",         "{F2}"         }, /* KEY_F2         */
        { "{F3}",         "{F3}"         }, /* KEY_F3         */
        { "{F4}",         "{F4}"         }, /* KEY_F4         */
        { "{F5}",         "{F5}"         }, /* KEY_F5         */
        { "{F6}",         "{F6}"         }, /* KEY_F6         */
        { "{F7}",         "{F7}"         }, /* KEY_F7         */
        { "{F8}",         "{F8}"         }, /* KEY_F8         */
        { "{F9}",         "{F9}"         }, /* KEY_F9         */
        { "{F10}",        "{F10}"        }, /* KEY_F10        */
        { "{NUMLOCK}",    "{NUMLOCK}"    }, /* KEY_NUMLOCK    */
        { "{SCROLLLOCK}", "{SCROLLLOCK}" }, /* KEY_SCROLLLOCK */
        { "{KP7}",        "{KP7}"        }, /* KEY_KP7        */
        { "{KP8}",        "{KP8}"        }, /* KEY_KP8        */
        { "{KP9}",        "{KP9}"        }, /* KEY_KP9        */
        { "{KPMINUS}",    "{KPMINUS}"    }, /* KEY_KPMINUS    */
        { "{KP4}",        "{KP4}"        }, /* KEY_KP4        */
        { "{KP5}",        "{KP5}"        }, /* KEY_KP5        */
        { "{KP6}",        "{KP6}"        }, /* KEY_KP6        */
        { "{KPPLUS}",     "{KPPLUS}"     }, /* KEY_KPPLUS     */
        { "{KP1}",        "{KP1}"        }, /* KEY_KP1        */
        { "{KP2}",        "{KP2}"        }, /* KEY_KP2        */
        { "{KP3}",        "{KP3}"        }, /* KEY_KP3        */
        { "{KP0}",        "{KP0}"        }, /* KEY_KP0        */
        { "{KPDOT}",      "{KPDOT}"      }, /* KEY_KPDOT      */
    };

    if ((buffer == NULL) || (pbuffer_size == NULL) || (*pbuffer_size < 1))
    {
        fprintf(stderr, "Error: %s: invalid function parameter(s)\n", __FUNCTION__);
        status = -1;
        goto e_barcode_read;
    }
    memset(buffer, 0, *pbuffer_size);

    *device = '\0';
    for (x = 0; (*device == '\0') && (x < 4); x++)
    {
        char path[128];

        sprintf(path, "/sys/class/input/event%d/device/name", x);
        FILE *fp = fopen(path, "r");
        if (fp != NULL)
        {
            char buf[256];

            buf[0] = '\0';
            if (fgets(buf, sizeof(buf), fp) != NULL)
            {
                if (strstr(buf, "Barcode Scanner") != NULL)
                {
                    sprintf(device, "/dev/input/event%d", x);
                }
            }

            fclose(fp);
            fp = NULL;
        }
    }
    if (*device == '\0')
    {
        fprintf(stderr, "Error: %s: unable to find USB scanner device\n", __FUNCTION__);
        status = -1;
        goto e_barcode_read;
    }

    fd = open(device, O_RDWR);
    if (fd < 0)
    {
        fprintf(stderr, "Error: %s: open('%s') failed: %s [%d]\n", __FUNCTION__, device, strerror(errno), errno);
        status = -1;
        goto e_barcode_read;
    }

    struct input_id device_id;
    memset(&device_id, 0, sizeof(device_id));
    rv = ioctl(fd, EVIOCGID, &device_id);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(EVIOCGID) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_barcode_read;
    }
    if (g_info.debug & _DBG_VERBOSE_ON) fprintf(stdout, "Debug: %s: BusType:%d Vendor:0x%04X Product:0x%04X Version:0x%04X\n", __FUNCTION__, device_id.bustype, device_id.vendor, device_id.product, device_id.version);
//DWG BusType:3 Vendor:0x05F9 Product:0x2206 Version:0x0110

    if (device_id.bustype != BUS_USB)
    {
        fprintf(stderr, "Error: %s: Input device bus type is not a USB bus (%d)\n", __FUNCTION__, device_id.bustype);
        status = -1;
        goto e_barcode_read;
    }

    char name[64];
    rv = ioctl(fd, EVIOCGNAME(sizeof(name)), name);
    if (rv < 0)
    {
        fprintf(stderr, "Error: %s: ioctl(EVIOCGNAME) failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
        status = -1;
        goto e_barcode_read;
    }
    if (g_info.debug & _DBG_VERBOSE_ON) fprintf(stdout, "Debug: %s: Reading from '%s'\n", __FUNCTION__, name);

    struct timeval timeout;
    timeout.tv_sec = timeout_us / (1000 * 1000);
    timeout.tv_usec = timeout_us - ((timeout_us / (1000 * 1000)) * (1000 * 1000));

    bool done = FALSE;
    while (!done)
    {
        int maxFd = -1;
        fd_set readFds;

        FD_ZERO(&readFds);
        FD_SET(fd, &readFds);

        maxFd = fd;

        switch (select(maxFd + 1, &readFds, NULL, NULL, &timeout))
        {
        case -1: // Error
            if (errno != EINTR)
            {
                fprintf(stderr, "Error: %s: select() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                status = -1;
                done = TRUE;
            }
            break;

        case 0: // Timeout
            done = TRUE;
            if (blen == 0)
            {
                fprintf(stderr, "Error: %s: timeout waiting for barcode scanner: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                status = -1;
                errno = -ETIME;
            }
            break;

        default:
            if (FD_ISSET(fd, &readFds))
            {
                struct input_event event;

                memset(&event, 0, sizeof(event));
                read(fd, &event, sizeof(event));
                if (event.type != EV_KEY) break;

                if (g_info.debug & _DBG_KEYEVENT_ON) fprintf(stdout, "Debug: %s: Event: Type:%d Code:%d(%s) Value:0x%08X\n", __FUNCTION__, event.type, event.code, (flags & _SHIFT) ? keycode[event.code].shifted : keycode[event.code].normal, event.value);

                switch (event.code)
                {
                case KEY_RIGHTSHIFT:
                case KEY_LEFTSHIFT:
                    if (event.value)
                    {
                        flags |= _SHIFT;
                    }
                    else
                    {
                        flags &= ~_SHIFT;
                    }
                    break;

                default:
                    // Ignore key up events
                    if (event.value == 0) break;

                    if (event.code > NELEM(keycode))
                    {
                        fprintf(stderr, "Warning: %s: ignoring unexpected event code 0x%04X\n", __FUNCTION__, event.code);
                        break;
                    }

                    const char *kcode = (flags & _SHIFT) ? keycode[event.code].shifted : keycode[event.code].normal;

                    if ((blen + strlen(kcode)) > *pbuffer_size)
                    {
                        done = TRUE;
                        fprintf(stderr, "Error: %s: buffer overflow\n", __FUNCTION__);
                        status = -1;
                        break;
                    }

                    int x;
                    for (x = 0; x < strlen(kcode); blen++, x++)
                    {
                        buffer[blen] = kcode[x];
                    }
                    buffer[blen] = '\0';
                    break;
                }
            }
            break;
        }

        // Reset polling interval
        timeout.tv_sec = 0;
        timeout.tv_usec = 50 * 1000;
    }

    *pbuffer_size = blen;

e_barcode_read:
    if (fd >= 0)
    {
        close(fd);
        fd = -1;
    }
    return status;
}

/****************************************************************************
 * assign_MacAddress
 */
static int
assign_MacAddress(const char *mac_addr_str)
{
    int status = 0;
    char path[128];
    FILE *fp = NULL;
    int rv = 0;
    char buf[128];
    uint8_t blen;
    uint8_t mac_addr[6];
    int x;

    //DWG
    // Target
    //   Read MAC Address from scanner and program OTP

    if ((mac_addr_str == NULL) || (strcmp(mac_addr_str, USER_INPUT_STRING) == 0))
    {
        fprintf(stdout, "User: Scan MAC address barcode.\n");

        char *bp = buf;
        *bp = '\0';
        blen = sizeof(buf) - 1;

        int n_segments = 0;

        bool done = FALSE;
        while (!done)
        {
            rv = barcode_read(bp, &blen, 10 * 1000 * 1000);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: barcode_read() failed: %s [%d]\n", __FUNCTION__, strerror(errno), errno);
                status = rv;
                goto e_assign_MacAddress;
            }
            n_segments++;

            // Strip trailing whitespace
            for (x = strlen(buf); (x > 0) && isspace(buf[x - 1]); x--); buf[x] = '\0';

            // 2 hex characters per byte of the MAC address
            if (strlen(buf) >= (NELEM(mac_addr) * 2))
            {
                // If the MAC address is coming in as 2 or more bar code scans,
                // make sure that it isn't the MAC address OUI scanned twice.
                if ((n_segments >= 2) && (strlen(buf) == (NELEM(mac_addr) * 2)))
                {
                    // Convert the string into a MAC address array
                    uint64_t val = strtoull(buf, NULL, 16);
                    for (x = 0; x < NELEM(mac_addr); x++)
                    {
                        mac_addr[(NELEM(mac_addr) - x) - 1] = (uint8_t) (val >> (8 * x));
                    }

                    // The top and bottom bytes should NOT both match the OUI. If
                    // they do match, this means the user may have scanned the OUI
                    // barcode twice. We want to make sure the MAC address is globally
                    // unique, so we disallow this combination.
                    if ((memcmp(mac_addr, reach_oui, sizeof(reach_oui)) == 0) &&
                        (memcmp(&(mac_addr[NELEM(mac_addr) / 2]), reach_oui, sizeof(reach_oui)) == 0))
                    {
                        fprintf(stderr, "Error: %s: MAC address (%s) is not allowed since it looks like the OUI label was scanned twice\n", __FUNCTION__, DbgOctet(mac_addr, NELEM(mac_addr), NULL, 0));
                        status = -1;
                        goto e_assign_MacAddress;
                    }
                }

                done = TRUE;
            }
            else
            {
                bp = &(buf[strlen(buf)]);
                blen = sizeof(buf) - strlen(buf) - 1;
            }
        }
    }
    else
    {
        blen = 0;
        strcpy(buf, mac_addr_str);
        for (x = 0; x < strlen(mac_addr_str); x++)
        {
            switch (mac_addr_str[x])
            {
            // Strip out the following characters
            case ':':
                break;

            default:
                buf[blen++] = mac_addr_str[x];
                break;
            }
        }
        buf[blen] = '\0';
    }

    if (g_info.debug & _DBG_DATA_ON) fprintf(stdout, "Debug: %s: MAC address buffer '%s'[%d]\n", __FUNCTION__, DbgDataToString(buf, 0, blen, NULL, 0), blen);

    // Strip trailing whitespace
    for (x = strlen(buf); (x > 0) && isspace(buf[x - 1]); x--); buf[x] = '\0';
    if (buf[0] == '\0')
    {
        fprintf(stderr, "Error: %s: empty MAC address string\n", __FUNCTION__);
        status = -1;
        goto e_assign_MacAddress;
    }
    blen = x;

    // The string for the MAC address needs to be 6 octets (or 12 characters)
    if (blen != (NELEM(mac_addr) * 2))
    {
        fprintf(stderr, "Error: %s: non-MAC address string '%s'\n", __FUNCTION__, buf);
        status = -1;
        goto e_assign_MacAddress;
    }

    // Convert the string into a MAC address array
    uint64_t val = strtoull(buf, NULL, 16);
    for (x = 0; x < NELEM(mac_addr); x++)
    {
        mac_addr[(NELEM(mac_addr) - x) - 1] = (uint8_t) (val >> (8 * x));
    }

    // Make sure the MAC address has the expected OUI
    if (memcmp(mac_addr, reach_oui, sizeof(reach_oui)) != 0)
    {
        char dbuf1[32];
        char dbuf2[32];

        fprintf(stderr, "Error: %s: MAC address OUI (%s) does not match expected OUI (%s)\n", __FUNCTION__, DbgOctet(mac_addr, NELEM(mac_addr), dbuf1, sizeof(dbuf1)), DbgOctet(reach_oui, NELEM(reach_oui), dbuf2, sizeof(dbuf2)));
        status = -1;
        goto e_assign_MacAddress;
    }

    sprintf(path, "/sys/fsl_otp/HW_OCOTP_CUST0");
    fp = fopen(path, "a+b");
    if (fp != NULL)
    {
        uint32_t new_otp = (mac_addr[3] << 16) | (mac_addr[4] << 8) | mac_addr[5];
        uint32_t cur_otp = ~0x0;

        rv = fscanf(fp, "%X", &cur_otp);
        if (rv != 1)
        {
            fprintf(stderr, "Error: %s: unable to read current OTP value from '%s' [%d]\n", __FUNCTION__, path, rv);
            status = -1;
            goto e_assign_MacAddress;
        }
        rewind(fp);

        if (g_info.verbose) fprintf(stdout, "Debug: %s: OTP Current:0x%08X New:0x%08X.\n", __FUNCTION__, cur_otp, new_otp);

        // We only care about the bottom 3 octets since the upper 3 are the OUI
        cur_otp &= 0x00FFFFFF;

        if (cur_otp == new_otp)
        {
            if (g_info.verbose) fprintf(stdout, "Debug: %s: OTP value 0x%08X already matches value in '%s'.\n", __FUNCTION__, new_otp, path);
            goto e_assign_MacAddress;
        }

        if (cur_otp != 0x0)
        {
            fprintf(stderr, "Error: %s: '%s' OTP has already been programmed to 0x%08X. Cannot set new value of 0x%08X\n", __FUNCTION__, path, cur_otp, new_otp);
            status = -1;
            goto e_assign_MacAddress;
        }

        if (g_info.verbose) fprintf(stdout, "Debug: %s: write OTP value 0x%08X to '%s'.\n", __FUNCTION__, new_otp, path);
        if (!g_info.dryrun)
        {
            rv = fprintf(fp, "0x%08X", new_otp); fflush(fp);
            if (rv < 0)
            {
                fprintf(stderr, "Error: %s: fprintf('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
                status = -1;
                goto e_assign_MacAddress;
            }
        }
        else
        {
            fprintf(stdout, "DryRun: %s: write OTP value 0x%08X to '%s'.\n", __FUNCTION__, new_otp, path);
        }
        rewind(fp);

        rv = fscanf(fp, "%X", &cur_otp);
        if (rv != 1)
        {
            fprintf(stderr, "Error: %s: unable to re-read current OTP value from '%s' [%d]\n", __FUNCTION__, path, rv);
            status = -1;
            goto e_assign_MacAddress;
        }

        if (cur_otp != new_otp)
        {
            fprintf(stderr, "Error: %s: OTP value ('%s') verify failed. Expected:0x%08X Actual:0x%08X\n", __FUNCTION__, path, new_otp, cur_otp);
            status = -1;
            goto e_assign_MacAddress;
        }

        fclose(fp);
        fp = NULL;
    }
    else
    {
        fprintf(stderr, "Error: %s: fopen('%s') failed: %s [%d]\n", __FUNCTION__, path, strerror(errno), errno);
        status = -1;
        goto e_assign_MacAddress;
    }

e_assign_MacAddress:
    if (fp != NULL)
    {
        fclose(fp);
        fp = NULL;
    }

    return status;
}

struct {
    const char *part;
    const char *name;
    testFunc_t  func;
#define _TEST_NONE  (0x00)
#define _TEST_P1    (0x01 << 0)
#define _TEST_P2    (0x01 << 1)
    uint8_t     flags;
} MfgTests[] = {
    { "J6",     "Ethernet",         test_Ethernet,     _TEST_P1 },
    { "J2",     "USBOTG",           test_USBOTG,       _TEST_P1 },
    { "U28",    "RTC",              test_RTC,          _TEST_P1 },
    { "J11/J7", "RS485",            test_RS485,        _TEST_P1 },
    { "J3",     "AUART",            test_AUART,        _TEST_P1 },
    { "J8",     "GPIO",             test_GPIO,         _TEST_P1 },
    { "J9",     "I2C",              test_I2C,          _TEST_P1 },
    { "J9",     "SPI0",             test_SPI0,         _TEST_P1 },
    { "J9",     "SPI1",             test_SPI1,         _TEST_P1 },
    { "J12",    "CAN0",             test_CAN0,         _TEST_P1 },
    { "J12",    "CAN1",             test_CAN1,         _TEST_NONE }, // Only CAN0 on Canby
    { "J4",     "USB1",             test_USB1,         _TEST_P1 },
    { "J1",     "USB2",             test_USB2,         _TEST_P1 },
#define TESTS_PHASE1    12                                
    { "U25",    "Battery",          verify_RtcBattery, _TEST_P2 },
    { "J13",    "TouchScreen",      test_TouchScreen,  _TEST_P2 },
    { "J13",    "LCD",              test_LCD,          _TEST_P2 },
    { "J13",    "Backlight",        test_Backlight,    _TEST_P2 },
};

/****************************************************************************
 * usage
 */
static void
usage(const char *prog_name)
{
    fprintf(stdout, "Usage: %s [options]\n", prog_name);
    fprintf(stdout, "  Perform manufacturing tests\n");
    fprintf(stdout, "\n");
    fprintf(stdout, "Options:\n");
    fprintf(stdout, "  -h, --help                   Display this help and exit\n");
    fprintf(stdout, "  --version                    Report program version\n");
    fprintf(stdout, "  -v, --verbose                Enable verbose debug (default:%s)\n", g_info.verbose ? "Enabled" : "Disabled");
    fprintf(stdout, "  -s, --server {ip_addr}       IP address of Ethernet server (default:%s)\n", g_info.ethernet.server_ip ? g_info.ethernet.server_ip : "None");
    fprintf(stdout, "  -l, --local {ip_addr}        IP address of local Ethernet interface (default:%s)\n", g_info.ethernet.local_ip ? g_info.ethernet.local_ip : "None");
    fprintf(stdout, "  -t, --tests {test}           List of tests to run (default:%s)\n", g_info.tests);
    fprintf(stdout, "  --list-tests                 List all available manufacturing tests\n");
    fprintf(stdout, "  --mac-address[={mac_addr}]   Set Ethernet interface MAC address to either the specified\n");
    fprintf(stdout, "                               {mac_addr} (%s:xx:xx:xx), or if not specified, the\n", DbgOctet(reach_oui, NELEM(reach_oui), NULL, 0));
    fprintf(stdout, "                               MAC address will be read use the USB barcode scanner\n");
    fprintf(stdout, "  --rs485-baud={baud_rate}     Set RS485 baud rate (default:%s)\n", baud_key_to_str(g_info.rs485_baud));
    fprintf(stdout, "  --rs232-baud={baud_rate}     Set RS232 baud rate (default:%s)\n", baud_key_to_str(g_info.rs232_baud));
    fprintf(stdout, "  --buffer-size={buf_size}     Set test buffer size (default:%u)\n", g_info.buffer_size);
    fprintf(stdout, "  --i2c-addr={i2c_addr}        Set the I2C device address (default:0x%02X)\n", g_info.i2c_addr);
    fprintf(stdout, "  --i2c-offset={i2c_offset}    Set the I2C write/read offset (default:0x%02X)\n", g_info.i2c_offset);
    fprintf(stdout, "  --spi-bus={spi_bus}          Set the SPI bus number (default:%d)\n", g_info.spi_bus);
    fprintf(stdout, "  --rtc-if={ETHERNET|USBOTG}   Network interface for setting/validating RTC (default:%s)\n", RtcIfList[g_info.rtc_if]);
    fprintf(stdout, "  --repeat={n_repeat}          Repeat the list of tests (default:%d)\n", g_info.repeat);
    fprintf(stdout, "  --dry-run                    Do not perform OTP write of MAC address or other permanent changes.\n");
    fprintf(stdout, "  --version                    Display version information and exit\n");
}

/****************************************************************************
 * main
 */
int
main(int argc, char *argv[])
{
    int ret = 0;
    int opt;
    int option_index = 0;
    int x;
    bool bHelp = FALSE;
    bool bTestList = FALSE;
    uint32_t test_mask;
    char *p;

    static const char *short_options = "s:l:t:vh";
    static const struct option long_options[] = {
        { "debug",       optional_argument,  0, 0 },
        { "version",     no_argument,        0, 0 },
        { "verbose",     no_argument,        0, 'v' },
        { "dry-run",     no_argument,        0, 0 },
        { "server",      required_argument,  0, 's' },
        { "local",       required_argument,  0, 'l' },
        { "tests",       required_argument,  0, 't' },
        { "list-tests",  no_argument,        0, 0 },
        { "mac-address", optional_argument,  0, 0 },
        { "rs485-baud",  required_argument,  0, 0 },
        { "rs232-baud",  required_argument,  0, 0 },
        { "buffer-size", required_argument,  0, 0 },
        { "i2c-addr",    required_argument,  0, 0 },
        { "i2c-offset",  required_argument,  0, 0 },
        { "spi-bus",     required_argument,  0, 0 },
        { "rtc-if",      required_argument,  0, 0 },
        { "repeat",      required_argument,  0, 0 },
        { "help",        no_argument,        0, 'h' },
        { 0, 0, 0, 0 },
    };

    g_info.tests = strdup("all");
    g_info.ethernet.server_ip = strdup("192.168.0.126");
    g_info.ethernet.local_ip = strdup("192.168.0.208");

    while ((opt = getopt_long(argc, argv, short_options,
        long_options, &option_index)) != -1)
    {
        switch (opt)
        {
        case 0:
            switch (option_index)
            {
            case 0: // debug
                if (optarg)
                {
                    g_info.debug = strtoul(optarg, NULL, 0);
                }
                else
                {
                    g_info.debug = ~0x0;
                }

                fprintf(stdout, "%s: Debug 0x%X\n", argv[0], g_info.debug);
                break;

            case 1: // version
                fprintf(stdout, "%s: Version %s\n", argv[0], VERSION);
                ret = 0;
                goto e_main;
                break;

            case 2: // verbose
                g_info.verbose = TRUE;
                break;

            case 3: // dry-run
                g_info.dryrun = TRUE;
                break;

            case 4: // server
                if (optarg)
                {
                    if (g_info.ethernet.server_ip != NULL) free(g_info.ethernet.server_ip);
                    g_info.ethernet.server_ip = strdup(optarg);
                }
                break;

            case 5: // local
                if (optarg)
                {
                    if (g_info.ethernet.local_ip != NULL) free(g_info.ethernet.local_ip);
                    g_info.ethernet.local_ip = strdup(optarg);
                }
                break;

            case 6: // tests
                if (optarg)
                {
                    if (g_info.tests != NULL) free(g_info.tests);
                    g_info.tests = strdup(optarg);
                }
                break;

            case 7: // list-tests
                bTestList = TRUE;
                break;

            case 8: // mac-address
                if (optarg)
                {
                    if (g_info.mac_address != NULL) free(g_info.mac_address);
                    g_info.mac_address = strdup(optarg);
                }
                else
                {
                    if (g_info.mac_address != NULL) free(g_info.mac_address);
                    g_info.mac_address = strdup(USER_INPUT_STRING);
                }
                break;

            case 9: // rs485-baud
                if (optarg)
                {
                    g_info.rs485_baud = baud_str_to_key(optarg);
                }
                break;

            case 10: // rs232-baud
                if (optarg)
                {
                    g_info.rs232_baud = baud_str_to_key(optarg);
                }
                break;

            case 11: // buffer-size
                if (optarg)
                {
                    g_info.buffer_size = strtoul(optarg, NULL, 0);
                }
                break;

            case 12: // i2c-addr
                if (optarg)
                {
                    g_info.i2c_addr = (uint8_t) strtoul(optarg, NULL, 0);
                }
                break;

            case 13: // i2c-offset
                if (optarg)
                {
                    g_info.i2c_offset = (uint8_t) strtoul(optarg, NULL, 0);
                }
                break;

            case 14: // spi-bus
                if (optarg)
                {
                    g_info.spi_bus = (uint8_t) strtoul(optarg, NULL, 0);
                }
                break;

            case 15: // rtc-if
                if (optarg)
                {
                    for (x = 0; x < NELEM(RtcIfList); x++)
                    {
                        if (strcasecmp(optarg, RtcIfList[x]) == 0)
                        {
                            g_info.rtc_if = x;
                            break;
                        }
                    }
                    if (x >= NELEM(RtcIfList))
                    {
                        fprintf(stdout, "Error: Unknown rtc-if option '%s'\n", optarg);
                        ret = 1;
                    }
                }
                break;

            case 16: // repeat
                if (optarg)
                {
                    g_info.repeat = strtoul(optarg, NULL, 0);
                }
                break;

            default:
                fprintf(stdout, "Option '%s'", long_options[option_index].name);
                if (optarg)
                {
                    fprintf(stdout, " with arg '%s'", optarg);
                }
                fprintf(stdout, "\n");
            }
            break;

        case 'v':
            g_info.verbose = TRUE;
            break;

        case 's':
            if (optarg)
            {
                if (g_info.ethernet.server_ip != NULL) free(g_info.ethernet.server_ip);
                g_info.ethernet.server_ip = strdup(optarg);
            }
            break;

        case 'l':
            if (optarg)
            {
                if (g_info.ethernet.local_ip != NULL) free(g_info.ethernet.local_ip);
                g_info.ethernet.local_ip = strdup(optarg);
            }
            break;

        case 't':
            if (optarg)
            {
                if (g_info.tests != NULL) free(g_info.tests);
                g_info.tests = strdup(optarg);
            }
            break;

        case 'h':
            bHelp = TRUE;
            break;

        case '?':
            // Error already handled by getopt_long()
            ret = 1;
            break;

        default:
            fprintf(stdout, "Unknown option '%c'\n", opt);
            ret = 1;
            break;
        }
    }

    if (bHelp)
    {
        usage(argv[0]);
    }

    if (bTestList)
    {
        char phase_str[64];

        for (x = 0; x < NELEM(MfgTests); x++)
        {
            phase_str[0] = '\0';
            if (MfgTests[x].flags & _TEST_P1)
            {
                strcat(phase_str, "Phase1");
            }
            if (MfgTests[x].flags & _TEST_P2)
            {
                if (phase_str[0] != '\0') strcat(phase_str, "/");
                strcat(phase_str, "Phase2");
            }
            fprintf(stdout, "  %-8s %-15s %s\n", MfgTests[x].part, MfgTests[x].name, phase_str);
        }
    }

    if (bHelp || bTestList)
    {
        ret = 0;
        goto e_main;
    }


    if (ret != 0)
    {
        goto e_main;
    }

    if (g_info.mac_address != NULL)
    {
        int rv;

        rv = assign_MacAddress(g_info.mac_address);
        fprintf(stdout, "Action: Assign MAC Address: %s\n", (rv < 0) ? STR_FAIL : ((rv == 0) ? STR_PASS : STR_UNTESTED));
        goto e_main;
    }

    test_mask = 0x0;
    for (p = strtok(g_info.tests, ","); p != NULL; p = strtok(NULL, ","))
    {
        if (strcasecmp(p, "all") == 0)
        {
            test_mask = ~0x0;
        }
        else if (strcasecmp(p, "phase1") == 0)
        {
            for (x = 0; x < NELEM(MfgTests); x++)
            {
                if (MfgTests[x].flags & _TEST_P1)
                {
                    test_mask |= (0x01 << x);
                }
            }
        }
        else if (strcasecmp(p, "phase2") == 0)
        {
            for (x = 0; x < NELEM(MfgTests); x++)
            {
                if (MfgTests[x].flags & _TEST_P2)
                {
                    test_mask |= (0x01 << x);
                }
            }
        }
        else
        {
            for (x = 0; x < NELEM(MfgTests); x++)
            {
                if ((strcasecmp(p, MfgTests[x].name) == 0) ||
                    (strcasestr(p, MfgTests[x].part) != NULL))
                {
                    test_mask |= (0x01 << x);
                }
            }
        }
    }

    uint32_t loop;

    int n_digits = 0;
    for (loop = 1; loop <= g_info.repeat; loop *= 10)
    {
        n_digits++;
    }

    for (loop = 0; loop < g_info.repeat; loop++)
    {
        char loop_str[64];

        if (g_info.repeat > 1)
        {
            sprintf(loop_str, "%*u: ", n_digits, loop + 1);
        }
        else
        {
            loop_str[0] = '\0';
        }

        for (x = 0; x < NELEM(MfgTests); x++)
        {
            int rv;
            char name[32];

            if (!(test_mask & (0x01 << x))) continue;

            sprintf(name, "%s (%s)", MfgTests[x].name, MfgTests[x].part);

            if (g_info.verbose) fprintf(stdout, "Debug: %sTesting %s\n", loop_str, name);
            rv = MfgTests[x].func();
            fprintf(stderr, "Test: %s%-20s %s\n", loop_str, name, (rv < 0) ? STR_FAIL : ((rv == 0) ? STR_PASS : STR_UNTESTED));
        }
    }

e_main:

    return ret;
}

