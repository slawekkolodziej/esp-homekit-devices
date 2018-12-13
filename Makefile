WORKSPACE_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))
ESPPORT=/dev/tty.wchusbserial1410
BAUD=115200

build:
	@docker-compose run --rm sdk make -C devices/$(dev) all

clean:
	@docker-compose run --rm sdk make -C devices/$(dev) clean

flash-clean:
	@esptool.py \
		-p $(ESPPORT) \
		--baud $(BAUD) write_flash \
		-fs 1MB \
		-fm dout \
		-ff 40m \
		0x0 ./sdk/esp-open-rtos/bootloader/firmware_prebuilt/rboot.bin \
		0x1000 ./sdk/esp-open-rtos/bootloader/firmware_prebuilt/blank_config.bin \
		0x2000 ./sdk/otaboot.bin

flash:
	@esptool.py \
		-p $(ESPPORT) \
		--baud $(BAUD) write_flash \
		-fs 1MB \
		-fm dout \
		-ff 40m \
		0x0 ./sdk/esp-open-rtos/bootloader/firmware_prebuilt/rboot.bin \
		0x1000 ./sdk/esp-open-rtos/bootloader/firmware_prebuilt/blank_config.bin \
		0x2000 ./devices/$(dev)/firmware/main.bin

serial:
	@screen -L $(ESPPORT) $(BAUD) –L
