#include <iostream>

int main() {
    // 32-bit hexadecimal value
    unsigned int number = 0x12345678; // Hexadecimal 0x12345678 (305419896 in decimal)

    // Define masks
    unsigned int maskLowByte = 0x00FF; // Mask to isolate the lowest byte
    unsigned int maskHighByte = 0xFF00; // Mask to isolate the highest byte
    unsigned int maskMiddleBytes = 0x00FFFF00; // Mask to isolate the middle 16 bits

    // Apply masks
    unsigned int lowByte = number & maskLowByte; // Isolate the lowest byte
    unsigned int highByte = number & maskHighByte; // Isolate the highest byte
    unsigned int middleBytes = number & maskMiddleBytes; // Isolate the middle 16 bits

    // Shift highByte and middleBytes to get the value in decimal
    highByte >>= 24;
    middleBytes >>= 8;

    std::cout << "Original number: 0x" << std::hex << number << std::endl;
    std::cout << "Lowest byte: 0x" << std::hex << lowByte << std::endl;
    std::cout << "Highest byte: 0x" << std::hex << highByte << std::endl;
    std::cout << "Middle 16 bits: 0x" << std::hex << middleBytes << std::endl;

    return 0;
}
