// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Transfer {

    address payable public admin;
    address payable public vault;
    uint public process_fee;

    constructor() {
        admin = payable(msg.sender);
        vault = payable(msg.sender);
        process_fee = 975;
    }

    // Pay_User Settings

    struct User{
        address payable UserAddress;
        uint Bidfee; 
    }    

    function setProcessFee(uint _NewProcessFee) external{
        require(msg.sender == admin);
        require(_NewProcessFee < 1000);
        process_fee = _NewProcessFee;
    }

    function setAdmin(address payable _NewAdmin) external{
        require(msg.sender == admin);
        admin = _NewAdmin;
    }

    function setvault(address payable _NewVault) external{
        require(msg.sender == admin);
        vault = _NewVault;
    }

    // Functions

    function Pay_Users(User[] calldata _List) external payable {
        require(msg.sender != admin);
        require(msg.sender != vault);

        uint _Bidderfee;
        uint _totalbidderfee = 0;
        uint _totalpaid = 0;

        User memory Payee;
        
        for(uint i = 0; i < _List.length; i++) {
            Payee = _List[i];

            _totalpaid = _totalpaid + Payee.Bidfee;            
            _Bidderfee = Payee.Bidfee * process_fee / 1000;
            _totalbidderfee = _totalbidderfee + _Bidderfee; 

            Payee.UserAddress.transfer(_Bidderfee);

        }

        if(msg.value < _totalpaid) {
            revert();
        }

        vault.transfer(_totalpaid-_totalbidderfee);

    }
}
