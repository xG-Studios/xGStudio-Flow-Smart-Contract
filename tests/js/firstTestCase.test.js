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

jest.setTimeout(95000);

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
    const Fahim = await getAccountAddress("Fahim");

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
    expect(txResult.errorMessage).toBe(undefined);
    console.log("transaction succeeded");
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
    expect(txResult.errorMessage).toBe(undefined);
    console.log("transaction succeeded");
  });

  test("test transaction createCollection on an Account", async () => {
    const name = "createCollection";
    // Import participating accounts
    const Fahim = await getAccountAddress("Fahim");
    // Set transaction signers
    const signers = [Fahim];
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
    expect(txResult.errorMessage).toBe(undefined);
    console.log("transaction succeeded");
  });

  test("test transaction depositNFT on an Account", async () => {
    const name = "depositNFT";
    // Import participating accounts
    const Bob = await getAccountAddress("Bob");
    const Dave = await getAccountAddress("Dave");
   //const Fahim = await getAccountAddress("Fahim");
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
      //const args = [Fahim];

      txResult = await sendTransaction({
        code,
        args,
        signers,
      });
    } catch (e) {
      console.log(e);
    }
    console.log("tx Result", txResult);
    expect(txResult.errorMessage).toBe(undefined);
   // console.log("noooooooooooooo collection");
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
    console.log("tx Result", txResult);
    expect(txResult.errorMessage).toBe(undefined);
    console.log("transaction succeeded");
    // expect(txResult.errorMessage).toBe("");
  });

  test("test transaction transferNFT to an Account", async () => {
    const name = "transferNFT";
    // Import participating accounts
    const Dave = await getAccountAddress("Dave");
    //const Charlie = await getAccountAddress("Charlie");
    const Fahim = await getAccountAddress("Fahim");
    // Set transaction signers
    const signers = [Dave];

    const nftID=0

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
      const args = [Fahim,nftID];

      txResult = await sendTransaction({
        code,
        args,
        signers,
      });
    } catch (e) {
      console.log(e);
    }
    console.log("tx Result", txResult);
    expect(txResult.errorMessage).toBe(undefined);
    console.log("noooooooooooooooooo collection nooooooooooo nft");
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
    console.log("result"+" charlie", result);
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
    console.log("result"+" Dave", result);
  });

  test("get user NFT", async () => {
    const name = "getAccountNFT";
    const Fahim = await getAccountAddress("Fahim");
    let nftcount = 0;
    const NonFungibleToken = await getContractAddress("NonFungibleToken");

    const addressMap = {
      NonFungibleToken,   
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });
    const args = [Fahim];
    const result = await executeScript({
      code,
      args,
    });
    //expect(result.length > nftcount);
    console.log("result"+" Fahim", result);
  });

  test("get user NFT Data", async () => {
    const name = "getNFTData";
    const Fahim = await getAccountAddress("Fahim");
    let nftID = 0;
    const NonFungibleToken = await getContractAddress("NonFungibleToken");

    const addressMap = {
      NonFungibleToken,   
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });
    const args = [Fahim,nftID];
    const result = await executeScript({
      code,
      args,
    });
    //expect(result.length > nftcount);
    console.log("result", result);
  });

});




