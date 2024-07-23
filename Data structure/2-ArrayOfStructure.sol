// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Structure{
    struct student {
        string name;
        uint age;
        bool pass;
    }

    student[] public StudentDetails;

    function saveDataInStruct(string memory _name, uint _age, bool _bool) public {
         student memory newStudentData = student({
            name : _name,
            age : _age,
            pass : _bool
         });

         StudentDetails.push(newStudentData);
    }
}