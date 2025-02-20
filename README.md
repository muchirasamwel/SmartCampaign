# Campaign Smart Contract Project

This project implements a decentralized crowdfunding campaign smart contract. The contract allows for democratic fund management where donors can vote on spending proposals.

## Contract Features

- **Campaign Creation**: Automatically assigns the creator as the campaign manager
- **Donations**: Anyone can donate (minimum 0.001 ether)
- **Spending Requests**: Manager can create requests to spend funds
- **Democratic Approval**: Donors can vote on spending requests
- **Version Control**: Maintains separate voting records for each funding round

## Core Functions

### For Donors

- `donate()`: Participate in the campaign by sending ETH
- `approveSpending(bool)`: Vote on current spending request

### For Managers

- `requestSpending(description, value, receiver)`: Create new spending proposal
- `closeCampaign()`: Finalize current request based on votes

## Usage

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Campaign.ts
```

## Security Features

- Only manager can create spending requests
- Each donor can vote only once per request
- New requests can't be created until previous ones are closed
- Automatic funds transfer on approved requests
