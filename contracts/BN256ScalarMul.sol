pragma solidity ^0.5.0;

contract BN256ScalarMul {

    function mulP(uint256 _px, uint256 _py, uint256 _scalar) public view returns (uint256, uint256) {
        assembly {

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
}
