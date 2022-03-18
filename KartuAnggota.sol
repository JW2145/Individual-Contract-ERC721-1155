// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// import "@openzeppelin/contracts/utils/Context.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "./ITN.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./Token721.sol";
import "./Token1155.sol";

contract Group{
    address[] member;
    address[] verifiedMembers;
    uint256 id = 0;
    uint256 contractCreation;
    address owner;

    // IERC20 public dai;
    // ERC20 public coin;
    // ITN public itn;
    // Token721 public test;
    Token721 public koin;
    Token1155 public coin1155;

    constructor(address _tokenContract721, address _tokenContract1155) public{
        contractCreation = block.timestamp;
        owner = msg.sender;
        koin = Token721(_tokenContract721);
        coin1155 = Token1155(_tokenContract1155);
        // coin = ERC20(_tokenContract);
        // itn = ITN(_tokenContract);
    }

    modifier onlyOwner(address _user) {
        require(owner == _user);
        // itn.pay();
        _;
    }

    modifier onlyAnggota(uint256 _id){
        require(idToAnggotaCheck[_id]);
        _;
    }

   
    event anggotaCreated(
        uint256 _id,
        uint256 _created,
        string _name,
        string _alamat,
        string _domisili,
        string _url
        //bool verified
    );
    event UpdateVerified(
        address indexed sender,
        address[] data,
        uint256 timestamp
    );

    mapping(uint256 => Anggota) internal idToAnggota;
    mapping(uint => bool) internal idToAnggotaCheck;

    function testingOnly() public{
        // koin.mintItem(msg.sender);
        coin1155.mintERC1155(msg.sender);
    }

    function get721()

    function testCoin(uint idx) public{
        koin.testingToken(msg.sender,idx);
    }

    //Kasih badge ke anggota secara manual
    function anggotaBadge(uint _id) public onlyAnggota(_id){
        coin1155.mintERC1155(address(idToAnggota[_id]));
    }

   

    function createAnggota(
        string memory _name,
        string memory _alamat,
        string memory _domisili,
        string memory _url
    ) public payable{
        // itn.pay();
        // itn.approving(msg.sender,1);
        // address __sender = msg.sender;
        // address contractaddress = address(this);
        // itn.transferFrom(msg.sender,address(this),1);//pay to create a member
        // koin.mintItem(msg.sender);
        uint256 _created = block.timestamp;
        Anggota anggota = new Anggota(
            id,
            _created,
            _name,
            _alamat,
            _domisili,
            _url,
            false
        );
        member.push(address(anggota));
        idToAnggota[id] = anggota;
        idToAnggotaCheck[id] = true;
        id++;
        emit anggotaCreated(id, _created, _name, _alamat, _domisili, _url);
    }

    function getAnggotaAddress(uint256 _id) public view returns (address) {
        return (address(member[_id]));
    }

    function append(
        string memory a,
        string memory b,
        string memory c,
        string memory d
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(a, " ", b, " ", c, " ", d, " "));
    }

    function addressData(uint256 _id) public view returns (string memory) {
        string memory temp = append(
            Anggota(member[_id]).name(),
            Anggota(member[_id]).alamat(),
            Anggota(member[_id]).domisili(),
            Anggota(member[_id]).url()
        );
        return temp;
    }

    function totalAnggota() public view returns (uint256) {
        return member.length;
    }

    /*
    //Check smua member yg ada dan push member yg sudah verifed ke verifiedMembers array.
    function checkVerified() internal{

        for (uint i = 0; i < member.length; i++) {
            if(now >= (Anggota(member[i]).created() + 10 seconds)){
                Anggota(member[i]).setVerified(true);
                if(verifiedMembers.length > 0){
                    for(uint a = 0; a < verifiedMembers.length; a++){
                        if(member[i] != verifiedMembers[a]){
                            verifiedMembers.push(member[i]);
                        } 
                    }
                }else{
                    verifiedMembers.push(member[i]);
                }
                
                
            }
        }

    }
    */
    function checkVerified() internal view returns (address[] memory) {
        uint256 tmp = 0;
        address[] memory tmp1 = new address[](member.length);

        for (uint256 i = 0; i < member.length; i++) {
            if ((Anggota(member[i]).created() + 5 seconds) <= block.timestamp) {
                tmp1[tmp] = member[i];
                tmp += 1;
            }
        }

        for (uint256 i = 0; i < (member.length - (tmp + 1)); i++) {
            delete tmp1[tmp1.length - 1];
        }
        // delete tmp1[tmp1.length-1];

        return tmp1;
    }

    // function testing() internal view returns (uint[] memory){
    //     uint[] memory aaa;
    //     aaa[0] = 1;
    //     aaa[1] = 2;
    //     return aaa;
    // }

    // function test() public view returns(uint[] memory){
    //     return testing();
    // }

    // Seharusnya call function, call smua anggota yg udh "verified"
    //Stiap function ini di call, akan check panggil function checkVerified untuk check anggota
    //yg sudah verified spuya dpt data yg paling recent. habis itu baru call.

    //check and update data
    function pushVerifiedAddress()
        public
        onlyOwner(msg.sender)
        returns (address[] memory)
    {
        verifiedMembers = checkVerified();
        emit UpdateVerified(msg.sender, verifiedMembers, block.timestamp);
        return verifiedMembers;
    }

    //check only
    function CheckOnlyVerifiedAddress() public view returns (address[] memory) {
        return checkVerified();
    }
}

contract Anggota {
    uint256 id;
    uint256 public created;
    string public name;
    string public alamat;
    string public domisili;
    string public url;
    bool public verified;

    constructor(
        uint256 _id,
        uint256 _created,
        string memory _name,
        string memory _alamat,
        string memory _domisili,
        string memory _url,
        bool _verified
    ) public {
        id = _id;
        created = _created;
        name = _name;
        alamat = _alamat;
        domisili = _domisili;
        url = _url;
        verified = _verified;
    }

    function setVerified(bool _verified) public {
        verified = _verified;
    }
}

// contract ITN is ERC20 {
//     address public owner;

//     constructor(string memory _name, string memory _symbol)
//         public
//         ERC20(_name, _symbol)
//     {
//         owner = msg.sender;
//     }

//     modifier onlyOwnerITN(address _user){
//         require(owner == _user);
//         _;
//     }

//     modifier checkBalance(address _user){
//         require(balanceOf(_user) > 1);
//         _;
//     }

//     function faucet(address _to, uint256 _amount) external {
//         _mint(_to, _amount);
//     }

//     function getOwner() view public returns(address){
//         return owner;
//     }

//     function getSender() view public returns(address){
//         return msg.sender;
//     }

//     function approving(address _spender, uint _amount) public payable checkBalance(msg.sender){
//         approve(_spender, _amount);
//     }

//     //Tambahin modifier harus cukup balance dia
//     function pay() public payable checkBalance(msg.sender){
//         approving(owner,1);
//         transfer(owner, 1);
//     }

//     function transferBro() public payable {
//         transferFrom(msg.sender, owner,1);
//     }

    

// }