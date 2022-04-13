## Directory Structure

The directories here are organized into contracts, scripts, and transactions.

Contracts contain the source code for the NFTContract and xGStudios that are deployed to Flow.

Scripts contain read-only transactions to get information about
the state of someones Collection or about the state of the NFTcontract and xGStudios.

Transactions contain the transactions that various users can use
to perform actions in the smart contract like creating Collections, Depositing NFTs and Transfering NFTs.

 - `contracts/` : Where the NFTContract and xGStudios smart contracts live.
 - `transactions/` : This directory contains all the transactions and scripts
 that are associated with these smart contracts.
 - `scripts/`  : This contains all the read-only Cadence scripts 
 that are used to read information from the smart contract
 or from a resource in account storage.
 - `test/` : This directory contains testcases in javascript.'js' folder contains Javascript testcases.
 See the README in `js/` for more information
 about how to run testcases.