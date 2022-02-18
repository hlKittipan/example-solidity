//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "./ownable.sol";

contract ZombieFactory is Ownable {
    //อีเวนต์สร้าง ซอมบี้
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;
    uint256 cooldownTime = 1 days;

    // สร้าง class zombie
    struct Zombie {
        string name;
        uint256 dna;
        uint32 level;
        uint32 readyTime;
    }

    Zombie[] public zombies;

    // ข้อมูล owner  ของซอมบี้
    mapping(uint256 => address) public zombieToOwner;
    // ข้อมูล owner มี ซอมบี้จำนวนเท่าไร
    mapping(address => uint256) ownerZombieCount;

    //internal คืออนุญาติให้ file ที่ inherit (สืบทอด) นี้ได้ ใช้งาน function นี้ได้
    function _createZombie(string _name, uint256 _dna) internal {
        uint256 id = zombies.push(
            Zombie(_name, _dna, 1, uint32(now + cooldownTime))
        ) - 1;

        // เก็บ id ซอมบี้ กับ owner
        // msg.sender(address) = 0x15433fbd35C82591F8d4f008Caf77fca9DccF66D
        zombieToOwner[id] = msg.sender;
        // เก็บจำนวนซอมบี้ของ  owner
        ownerZombieCount[msg.sender]++;
        //บันทึกอีเวนต์ สร้างซอมบี้
        NewZombie(id, _name, _dna);
    }

    // สุ่ม dna ของซอมบี้ จากชื่อซอมบี้
    function _generateRandomDna(string _str) private view returns (uint256) {
        uint256 rand = uint256(keccak256(_str));
        return rand % dnaModulus;
    }

    // สร้างซอมบี้ จาก dna ที่สุ่ม
    function createRandomZombie(string _name) public {
        // ตรวจสอบเจ้าของต้องไม่มี ซอมบี้
        require(ownerZombieCount[msg.sender] == 0);
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
