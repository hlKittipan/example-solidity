//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
	// ตรวจสอบ เงื่อนไข
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

	// สำหรับซอมบี้ที่มีเลเวล 2 ขึ้นไป ผู้เล่นจะสามารถเปลี่ยนชื่อของตัวเองได้
	// external คืออนุญาติให้ function เรียกใช้งานได้จากที่ไหนก็ได้
    function changeName(uint256 _zombieId, string _newName)
        external
        aboveLevel(2, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

	//สำหรับซอมบี้ที่มีเลเวล 20 ขึ้นไป ผู้เล่นจะสามารถปรับแต่ง DNA ได้
    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }
}
