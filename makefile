TEST_OUTPUT_DIR=bin/tests
TEST_OUTPUT=$(TEST_OUTPUT_DIR)/test.prg
DEVICE_ID=vivoactive3m

build-test:
	rm -rf $(TEST_OUTPUT_DIR) && \
	monkeyc --unit-test --output $(TEST_OUTPUT) --warn \
		--jungles monkey.jungle --private-key $(CONNECT_IQ_PRIVATE_KEY_PATH) \
		--device $(DEVICE_ID)

test: build-test
	connectiq && \
	monkeydo $(TEST_OUTPUT) $(DEVICE_ID) -t && \
	python3 tools/kill_simulator.py