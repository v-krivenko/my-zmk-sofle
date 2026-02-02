run:
	docker compose run --rm zmk-build bash

west_init:
	docker compose run --rm zmk-build \
		bash -c "west init -l config && west update"

west_update:
	docker compose run --rm zmk-build \
		bash -c "west update"

build: clean build_left build_right

clean:
	rm -rf build/* firmware/*

build_right:
	docker compose run --rm zmk-build \
		bash -c "west zephyr-export && \
			west build -s zmk/app -d build/eyelash_sofle_right \
				-b eyelash_sofle_right \
				-- -DSHIELD=nice_view \
					-DZMK_CONFIG=/workspace/config && \
			mkdir -p firmware && \
			cp build/eyelash_sofle_right/zephyr/zmk.uf2 firmware/eyelash_sofle_studio_right.uf2 2>/dev/null || \
			echo 'No uf2 or bin found'"

build_left:
	docker compose run --rm zmk-build \
		bash -c "west zephyr-export && \
			west build -s zmk/app -d build/eyelash_sofle_left \
				-b eyelash_sofle_left \
				-S studio-rpc-usb-uart \
				-- -DSHIELD=nice_view \
					-DZMK_CONFIG=/workspace/config \
					-DCONFIG_ZMK_STUDIO=y \
					-DCONFIG_ZMK_STUDIO_LOCKING=n && \
			mkdir -p firmware && \
			cp build/eyelash_sofle_left/zephyr/zmk.uf2 firmware/eyelash_sofle_studio_left.uf2 2>/dev/null || \
			echo 'Build finished, check firmware/'"
