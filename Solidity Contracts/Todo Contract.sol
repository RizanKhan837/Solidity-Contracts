// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

contract Todo{

    struct TodoObj{
        uint id; string todoName; string todoDescription;
    }
    // Event to be emitted when a new task is created
    event TaskCreate(uint, string);
    // Mapping to store the todos
    mapping(address => TodoObj[]) todoMap;
    TodoObj[] public todos;
    
    // Function to add a new todo
    function addTodos(uint _id, string memory _todoText, string memory _todoDescription) public {
        todos.push(TodoObj(_id, _todoText, _todoDescription));
        todoMap[msg.sender] = todos;
        emit TaskCreate(_id, _todoText);
    }
    function getTodosData(address _address) public view returns(TodoObj[] memory){
        return todoMap[_address];
    }
}