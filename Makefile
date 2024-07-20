TARGET := dice

BUILD_DIR := ./build
SRC_DIR := ./src

# Find all source files in the source directories
SRCS := $(shell find $(SRC_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s')
OBJS := $(SRCS:$(SRC_DIR)/%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

# Find all include directories
INC_DIRS := $(shell find $(SRC_DIR) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS := $(INC_FLAGS) -MMD -MP

# Warning flags
WARN_FLAGS := -Wall -Wextra -Werror -pedantic -Wshadow -Wconversion -Wformat=2

CFLAGS := $(WARN_FLAGS)
CXXFLAGS := $(WARN_FLAGS)

# Target executable
$(BUILD_DIR)/$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $@ $(LDFLAGS)

# Compile C source files
$(BUILD_DIR)/%.c.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Compile C++ source files
$(BUILD_DIR)/%.cpp.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

# Include dependency files
-include $(DEPS)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all
all: $(BUILD_DIR)/$(TARGET)

.PHONY: run
run: all
	./$(BUILD_DIR)/$(TARGET)