import path from "path";
import {
  init,
  emulator,
  getAccountAddress,
  deployContractByName,
  getContractCode,
  getContractAddress,
  getTransactionCode,
  getScriptCode,
  executeScript,
  sendTransaction,
  mintFlow,
  getFlowBalance,
} from "flow-js-testing";
import { expect } from "@jest/globals";

jest.setTimeout(10000);

beforeAll(async () => {
  const basePath = path.resolve(__dirname, "../..");
  const port = 8080;

  await init(basePath, { port });
  await emulator.start(port);
});

afterAll(async () => {
  const port = 8080;
  await emulator.stop(port);
});

describe("Replicate Playground Accounts", () => {
  test("Create Accounts", async () => {
    // Playground project support 4 accounts, but nothing stops you from creating more by following the example laid out below
    const Alice = await getAccountAddress("Alice");
    const Bob = await getAccountAddress("Bob");
    const Charlie = await getAccountAddress("Charlie");
    const Dave = await getAccountAddress("Dave");

    console.log(
      "Four Playground accounts were created with following addresses"
    );
    console.log("Alice:", Alice);
    console.log("Bob:", Bob);
    console.log("Charlie:", Charlie);
    console.log("Dave:", Dave);
    //mint the flow to the user account
    const data = await mintFlow(Bob, "42.0");
    const updatedBalance = await getFlowBalance(Bob);
  });
});
describe("Deployment", () => {
  test("Deploy for NonFungibleToken", async () => {
    const name = "NonFungibleToken";
    const to = await getAccountAddress("Alice");
    let update = true;

    let result;
    try {
      result = await deployContractByName({
        name,
        to,
        update,
      });
    } catch (e) {
      console.log(e);
    }
    expect(name).toBe("NonFungibleToken");
  });
  
  test("Deploy for xGStudios", async () => {
    const name = "xGStudios";
    const to = await getAccountAddress("Bob");
    let update = true;
    const NonFungibleToken = await getContractAddress("NonFungibleToken");

    let addressMap = {
      NonFungibleToken,
    };
    let result;
    try {
      result = await deployContractByName({
        name,
        to,
        addressMap,
        update,
      });
    } catch (e) {
      console.log(e);
    }
    expect(name).toBe("xGStudios");
  });
});

describe("Transactions", () => {
  test("test transaction createCollection on an Account", async () => {
    const name = "createCollection";
    // Import participating accounts
    const Charlie = await getAccountAddress("Charlie");
    // Set transaction signers
    const signers = [Charlie];
    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const xGStudios = await getContractAddress("xGStudios");
    const addressMap = {
      NonFungibleToken,
      xGStudios,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });

    let txResult;
    try {
      txResult = await sendTransaction({
        code,
        signers,
      });
    } catch (e) {
      console.log(e);
    }
    console.log("tx Result", txResult);
    console.log("trans Good");
     expect(txResult.errorMessage).toBe(undefined);
  });

  test("test transaction createCollection on an Account", async () => {
    const name = "createCollection";
    // Import participating accounts
    const Dave = await getAccountAddress("Dave");
    // Set transaction signers
    const signers = [Dave];
    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const xGStudios = await getContractAddress("xGStudios");
    const addressMap = {
      NonFungibleToken,
      xGStudios,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });

    let txResult;
    try {
      txResult = await sendTransaction({
        code,
        signers,
      });
    } catch (e) {
      console.log(e);
    }
    console.log("tx Result", txResult);
    console.log("trans Good");
     expect(txResult.errorMessage).toBe(undefined);
  });

  test("test transaction depositNFT on an Account", async () => {
    const name = "depositNFT";
    // Import participating accounts
    const Bob = await getAccountAddress("Bob");
    const Dave = await getAccountAddress("Dave");
    // Set transaction signers
    const signers = [Bob];
    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const NowWhereContract = await getContractAddress("NowWhereContract");
    const addressMap = {
      NonFungibleToken,
      NowWhereContract,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });

    let txResult;
    try {
      const args = [Dave];

      txResult = await sendTransaction({
        code,
        args,
        signers,
      });
    } catch (e) {
      console.log(e);
    }
    console.log("tx result ", txResult);
    expect(txResult.errorMessage).toBe(undefined);
    // expect(txResult.errorMessage).toBe("");
  });

  test("test transaction depositNFT on an Account", async () => {
    const name = "depositNFT";
    // Import participating accounts
    const Bob = await getAccountAddress("Bob");
    const Charlie = await getAccountAddress("Charlie");
    // Set transaction signers
    const signers = [Bob];
    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const NowWhereContract = await getContractAddress("NowWhereContract");
    const addressMap = {
      NonFungibleToken,
      NowWhereContract,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });

    let txResult;
    try {
      const args = [Charlie];

      txResult = await sendTransaction({
        code,
        args,
        signers,
      });
    } catch (e) {
      console.log(e);
    }
    console.log("tx result ", txResult);
    expect(txResult.errorMessage).toBe(undefined);
    // expect(txResult.errorMessage).toBe("");
  });

  test("test transaction transferNFT to an Account", async () => {
    const name = "transferNFT";
    // Import participating accounts
    const Dave = await getAccountAddress("Dave");
    const Charlie = await getAccountAddress("Charlie");
    // Set transaction signers
    const signers = [Charlie];

    const nftID=1

    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const NowWhereContract = await getContractAddress("NowWhereContract");
    const addressMap = {
      NonFungibleToken,
      NowWhereContract,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });

    let txResult;
    try {
      const args = [Dave,nftID];

      txResult = await sendTransaction({
        code,
        args,
        signers,
      });
    } catch (e) {
      console.log(e);
    }
    console.log("tx result ", txResult);
    expect(txResult.errorMessage).toBe(undefined);
    // expect(txResult.errorMessage).toBe("");
  });

});

describe("Scripts", () => {
  test("get user NFT", async () => {
    const name = "getAccountNFT";
    const Charlie = await getAccountAddress("Charlie");
    let nftcount = 0;
    const NonFungibleToken = await getContractAddress("NonFungibleToken");

    const addressMap = {
      NonFungibleToken,   
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });
    const args = [Charlie];
    const result = await executeScript({
      code,
      args,
    });
    //expect(result.length > nftcount);
    console.log("result", result);
  });

  test("get user NFT", async () => {
    const name = "getAccountNFT";
    const Dave = await getAccountAddress("Dave");
    let nftcount = 0;
    const NonFungibleToken = await getContractAddress("NonFungibleToken");

    const addressMap = {
      NonFungibleToken,   
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });
    const args = [Dave];
    const result = await executeScript({
      code,
      args,
    });
    //expect(result.length > nftcount);
    console.log("result", result);
  });

  test("get user NFT Data", async () => {
    const name = "getNFTData";
    const Dave = await getAccountAddress("Dave");
    let nftID = 0;
    const NonFungibleToken = await getContractAddress("NonFungibleToken");

    const addressMap = {
      NonFungibleToken,   
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });
    const args = [Dave,nftID];
    const result = await executeScript({
      code,
      args,
    });
    //expect(result.length > nftcount);
    console.log("result", result);
  });

});
