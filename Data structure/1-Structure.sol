// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Structure {
    struct Studnet {
        string name;
        uint age;
    }

    Studnet public newStudents;

    function setStudent(string memory _name, uint _age)public {
        newStudents = Studnet({
            name : _name,
            age : _age     
        });
    }
}