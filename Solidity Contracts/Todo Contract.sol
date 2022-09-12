// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

contract Todo{

    struct TodoObj{
        uint id; string todoName; string todoDescription;
    }
    event TaskCreate(uint, string);

    mapping(address => TodoObj[]) todoMap;
    TodoObj[] public todos;

    function addTodos(uint _id, string memory _todoText, string memory _todoDescription) public {
        todos.push(TodoObj(_id, _todoText, _todoDescription));
        todoMap[msg.sender] = todos;
        emit TaskCreate(_id, _todoText);
    }
    function getTodosData(address _address) public view returns(TodoObj[] memory){
        return todoMap[_address];
    }
}