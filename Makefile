CPPFLAGS += -std=c99

all: libpgm.so liblepton.so

lib%.so: CFLAGS  += -fPIC
lib%.so: LDFLAGS += -shared
lib%.so: %.o
	$(LINK.c) -o $@ $^

clean:
	$(RM) *.o
	$(RM) lib*.so

