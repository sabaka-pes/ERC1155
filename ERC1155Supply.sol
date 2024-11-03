// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC1155.sol";

abstract contract ERC1155Supply is ERC1155 {
    mapping(uint => uint) private _totalSupply;

    function totalSupply(uint id) public view virtual returns (uint) {
        return _totalSupply[id];
    }

    function exists(uint id) public view virtual returns (bool) {
        return ERC1155Supply.totalSupply(id) > 0;
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint[] memory ids,
        uint[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);

        if (from == address(0)) {
            for (uint i = 0; i < ids.length; ++i) {
                _totalSupply[ids[i]] += amounts[i];
            }
        }

        if (to == address(0)) {
            for (uint i = 0; i < ids.length; ++i) {
                uint id = ids[i];
                uint amount = amounts[i];
                uint supply = _totalSupply[id];

                require(supply >= amount, "burn amount exceeds totalSupply");

                _totalSupply[id] = supply - amount;
            }
        }
    }
}