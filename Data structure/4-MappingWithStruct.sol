// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MappingWithSrtuct {
    struct Students {
        string name;
        uint age;
        bool pass;
    }

    mapping (uint => Students) public data;


    function newStudent(uint _index, string memory _name, uint _age, bool _bool) public {
        data[_index] = Students({
            name : _name,
            age:_age,
            pass:_bool
        });

        // data[_index] = Students(_name,_age, _bool);
    }
    function returnval(uint _index) public view returns(Students memory) {
        return data[_index];
    }
}