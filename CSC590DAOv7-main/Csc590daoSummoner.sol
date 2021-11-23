
pragma solidity 0.5.3;

import "./CSC590DAOPROJECT.sol";
import "./CloneFactory.sol";


contract CSC590DAOSummoner is CloneFactory { 
    
    address public template;
    mapping (address => bool) public daos;
    uint daoIdx = 0;
    CSC590DAOSummoner private csc590dao; // stating the contract
    
    constructor(address _template) public {
        template = _template;
    }
    
    event SummonComplete(address indexed csc590dao, address[] summoner, address[] tokens, uint256 summoningTime, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward, uint256[] summonerShares);
    event Register(uint daoIdx, address csc590dao, string title, string http, uint version);
     
    function summonCsc590dao(
        address[] memory _summoner,
        address[] memory _approvedTokens,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _proposalDeposit,
        uint256 _dilutionBound,
        uint256 _processingReward,
        uint256[] memory _summonerShares
    ) public returns (address) {
        Csc590dao baal = Csc590dao(createClone(template));
        
        baal.init(
            _summoner,
            _approvedTokens,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _proposalDeposit,
            _dilutionBound,
            _processingReward,
            _summonerShares
        );
       
        emit SummonComplete(address(baal), _summoner, _approvedTokens, now, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDeposit, _dilutionBound, _processingReward, _summonerShares);
        
        return address(baal);
    }
    
    //Registering function

    function registerDao(
        address _daoAdress,
        string memory _daoTitle,
        string memory _http,
        uint _version
      ) public returns (bool) {
          
      csc590dao = Csc590dao(_daoAdress);
      (,,,bool exists,,) = csc590dao.members(msg.sender);
    
      require(exists == true, "must be a member");
      require(daos[_daoAdress] == false, "dao metadata already registered");

      daos[_daoAdress] = true;
      
      daoIdx = daoIdx + 1;
      emit Register(daoIdx, _daoAdress, _daoTitle, _http, _version);
      return true;
      
    }  
}