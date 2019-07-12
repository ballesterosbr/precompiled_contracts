pragma solidity ^0.5.0;

contract ByzantiumContracts {

    function mulP(uint256 _px, uint256 _py, uint256 _scalar) public view returns (uint256, uint256) {
        assembly {
            // Free memory pointer
            let pointer := mload(0x40)

            mstore(pointer, _px)
            mstore(add(pointer, 0x20), _py)
            mstore(add(pointer, 0x40), _scalar)

            if iszero(staticcall(not(0), 0x07, pointer, 0x60, pointer, 0x40)) {
                revert(0, 0)
            }

            let size := returndatasize
            returndatacopy(pointer, 0, size)
            return(pointer,size)
        }
    }

    function addP(uint256 _px, uint256 _py, uint256 _qx, uint256 _qy) public view returns (uint256, uint256) {
        assembly {

            let pointer := mload(0x40)

            mstore(pointer, _px)
            mstore(add(pointer, 0x20), _py)
            mstore(add(pointer, 0x40), _qx)
            mstore(add(pointer, 0x60), _qy)

            if iszero(staticcall(not(0), 0x06, pointer, 0x80, pointer, 0x40)) {
                revert(0, 0)
            }

            let size := returndatasize
            returndatacopy(pointer, 0, size)
            return(pointer,size)
        }
    }

    function modExp(uint256 _b, uint256 _e, uint256 _m) public returns (uint256 result) {
        assembly {
            // Free memory pointer
            let pointer := mload(0x40)

            // Define length of base, exponent and modulus. 0x20 == 32 bytes
            mstore(pointer, 0x20)
            mstore(add(pointer, 0x20), 0x20)
            mstore(add(pointer, 0x40), 0x20)

            // Define variables base, exponent and modulus
            mstore(add(pointer, 0x60), _b)
            mstore(add(pointer, 0x80), _e)
            mstore(add(pointer, 0xa0), _m)

            // Store the result
            let value := mload(0xc0)

            // Call the precompiled contract 0x05 = bigModExp
            if iszero(call(not(0), 0x05, 0, pointer, 0xc0, value, 0x20)) {
                revert(0, 0)
            }

            result := mload(value)
        }
    }
}