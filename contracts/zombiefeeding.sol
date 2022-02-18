//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

// put import statement here
import "./zombiefactory.sol";

contract KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

contract ZombieFeeding is ZombieFactory {
    KittyInterface kittyContract;

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

	//ตรวจสอบ zombie พร้อมออกไปกิน kitty
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= now);
    }

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string _species
    ) internal {
        //ตรวจสอบ owner เป็น owner ของ zombie หรือไม่
        require(msg.sender == zombieToOwner[_zombieId]);
		// Storage หมายถึงตัวแปรที่ถูกจัดเก็บอย่างถาวรบน blokchain
        Zombie storage myZombie = zombies[_zombieId];
		require(_isReady(myZombie));
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;
        if (keccak256(_species) == keccak256("kitty")) {
            newDna = newDna - (newDna % 100) + 99;
        }
        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
        // And modify function call here:
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
