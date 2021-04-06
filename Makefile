AS=wla-z80
LINKER=wlalink
REMOVE=rm -f
ECHO=echo

TARGET=test

BUILD=build
LINKFILE=build/linkfile
SRC=src/main.asm

all: $(TARGET)

$(TARGET): $(LINKFILE)
	$(LINKER) -d -v -r -S $(LINKFILE) $(TARGET).sms

$(BUILD)/main.o:
	$(AS) -i -v -o $(BUILD)/main.o $(SRC)

$(LINKFILE): $(BUILD)/main.o
	$(ECHO) [objects] > $(LINKFILE)
	$(ECHO) $(BUILD)/main.o >> $(LINKFILE)

clean:
	$(REMOVE) $(TARGET).sms
	$(REMOVE) $(TARGET).sym
	$(REMOVE) $(LINKFILE)
	$(REMOVE) build/*.o
