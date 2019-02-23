SIMULATOR_OUTPUT=bin/climbing-activity.prg
TEST_OUTPUT_DIR=bin/tests
TEST_OUTPUT=$(TEST_OUTPUT_DIR)/test.prg
DEVICE_ID=vivoactive3m

build:
	rm -rf $(SIMULATOR_OUTPUT) && \
	monkeyc --output $(SIMULATOR_OUTPUT) --warn \
		--jungles monkey.jungle --private-key $(CONNECT_IQ_PRIVATE_KEY_PATH) \
		--device $(DEVICE_ID)

build-test:
	rm -rf $(TEST_OUTPUT_DIR) && \
	monkeyc --unit-test --output $(TEST_OUTPUT) --warn \
		--jungles monkey.jungle --private-key $(CONNECT_IQ_PRIVATE_KEY_PATH) \
		--device $(DEVICE_ID)

test: build-test
	connectiq && \
	python3 tools/run_tests.py $(TEST_OUTPUT) $(DEVICE_ID) ; \
	python3 tools/kill_simulator.py

simulator: build
	connectiq && \
	monkeydo $(SIMULATOR_OUTPUT) $(DEVICE_ID)