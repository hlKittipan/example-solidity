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

    function getZombiesByOwner(address _owner)
        external
        view
        returns (uint256[])
    {
        // สร้าง array ชื่อ result เก็บลง memory จำนวน array เท่ากับ จำนวน zombies ที่ owner เป็นเจ้าของ
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
		// คอยเช็คค่า index ใน array ใหม่:
        uint256 counter = 0;
		 // ทำซ้ำ 1 ถึง zombies.length ครั้งด้วย for-loop: 
        for (uint256 i = 0; i < zombies.length; i++) {
			// ตรวจสอบคุณเป็น owner ของ zombies หรือไม่?
            if (zombieToOwner[i] == _owner) {
				// เพิ่มลงใน array
				result[counter] = i;
				// เลื่อน counter ไปยัง index ถัดไปที่ว่างใน `resules`:
                counter++;
            }
        }
        return result;
    }
}
