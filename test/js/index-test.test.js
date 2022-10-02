import {
  deployContractByName,
  emulator,
  executeScript,
  getAccountAddress,
  getContractAddress,
  getScriptCode,
  getTransactionCode,
  init,
  sendTransaction,
  shallPass,
  shallResolve,
} from "flow-js-testing";
import path from "path";

//jest.setTimeout(10000);
jest.setTimeout(100000);


beforeAll(async () => {
  const basePath = path.resolve(__dirname, "../..");

  await init(basePath);
  await emulator.start();
});

afterAll(async () => {
  await emulator.stop();
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
    console.table({
      Alice,
      Bob,
      Charlie,
      Dave,
    });
  });
});

describe("Deployment", () => {
  test("Deploy for library contracts", async () => {
    const to = await getAccountAddress("Alice");

    await shallPass(
      deployContractByName({
        name: "NonFungibleToken",
        to,
      })
    );

    await shallPass(
      deployContractByName({
        name: "FungibleToken",
        to,
      })
    );

    await shallPass(
      deployContractByName({
        name: "MetadataViews",
        to,
      })
    );

    await shallPass(
      deployContractByName({
        name: "Clock",
        to,
      })
    );

    await shallPass(
      deployContractByName({
        name: "ProfileCache",
        to,
      })
    );

    await shallPass(
      deployContractByName({
        name: "Profile",
        to,
      })
    );
  });
  test("Deploy for XGStudio", async () => {
    const name = "XGStudio";
    const to = await getAccountAddress("Bob");
    let update = true;

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const FungibleToken = await getContractAddress("FungibleToken");
    const MetadataViews = await getContractAddress("MetadataViews");
    const Clock = await getContractAddress("Clock");
    const ProfileCache = await getContractAddress("ProfileCache");
    const Profile = await getContractAddress("Profile");
    const addressMap = {
      NonFungibleToken,
      FungibleToken,
      MetadataViews,
      Clock,
      ProfileCache,
      Profile,
    };

    await shallPass(
      deployContractByName({
        name,
        to,
        addressMap,
        update,
      })
    );
  });
});

describe("Transactions", () => {
  test("test transaction  create brand", async () => {
    const name = "createBrand";

    // Import participating accounts
    const Bob = await getAccountAddress("Bob");

    // Set transaction signers
    const signers = [Bob];

    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");
    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });
    const args = ["HondaNorth"];

    await shallPass(
      sendTransaction({
        code,
        signers,
        args,
      })
    );
  });
  test("test transaction  create Schema", async () => {
    const name = "createSchema";

    // Import participating accounts
    const Bob = await getAccountAddress("Bob");

    // Set transaction signers
    const signers = [Bob];

    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");
    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });
    const args = ["Test Schema"];

    await shallPass(
      sendTransaction({
        code,
        signers,
        args,
      })
    );
  });
  test("test transaction  create template", async () => {
    const name = "createTemplateStaticData";

    // Import participating accounts
    const Bob = await getAccountAddress("Bob");

    // Set transaction signers
    const signers = [Bob];

    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");
    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });
    // brandId, schemaId, maxSupply,immutableData
    const args = [1, 1, 100];

    await shallPass(
      sendTransaction({
        code,
        signers,
        args,
      })
    );
  });
  test("test transaction setup Account", async () => {
    const name = "setupAccount";

    // Import participating accounts
    const Charlie = await getAccountAddress("Charlie");

    // Set transaction signers
    const signers = [Charlie];

    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");
    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });

    await shallPass(
      sendTransaction({
        code,
        signers,
      })
    );
  });

  test("test transaction  mint NFT", async () => {
    const name = "mintNFT";

    // Import participating accounts
    const Bob = await getAccountAddress("Bob");
    const Charlie = await getAccountAddress("Charlie");

    // Set transaction signers
    const signers = [Bob];

    // Generate addressMap from import statements
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");
    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };

    let code = await getTransactionCode({
      name,
      addressMap,
    });
    const args = [1, Charlie];
    await shallPass(
      sendTransaction({
        code,
        signers,
        args,
      })
    );
  });
});

describe("Scripts", () => {
  test("get total supply", async () => {
    const name = "getTotalSupply";
    const Bob = await getAccountAddress("Bob");

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");

    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });

    code = code
      .toString()
      .replace(/(?:getAccount\(\s*)(0x.*)(?:\s*\))/g, (_, match) => {
        const accounts = {
          "0x01": Alice,
          "0x02": Bob,
        };
        const name = accounts[match];
        return `getAccount(${name})`;
      });

    await shallResolve(
      executeScript({
        code,
      })
    );
  });
  test("get brand data", async () => {
    const name = "getAllBrands";
    const Bob = await getAccountAddress("Bob");

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");

    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });

    code = code
      .toString()
      .replace(/(?:getAccount\(\s*)(0x.*)(?:\s*\))/g, (_, match) => {
        const accounts = {
          "0x01": Alice,
          "0x02": Bob,
        };
        const name = accounts[match];
        return `getAccount(${name})`;
      });

    await shallResolve(
      executeScript({
        code,
      })
    );
  });
  test("get brand data by Id", async () => {
    const name = "getBrandById";
    const Bob = await getAccountAddress("Bob");

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");

    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });
    const args = [1];

    code = code
      .toString()
      .replace(/(?:getAccount\(\s*)(0x.*)(?:\s*\))/g, (_, match) => {
        const accounts = {
          "0x01": Alice,
          "0x02": Bob,
        };
        const name = accounts[match];
        return `getAccount(${name})`;
      });

    await shallResolve(
      executeScript({
        code,
        args,
      })
    );
  });
  test("get schema data", async () => {
    const name = "getallSchema";
    const Bob = await getAccountAddress("Bob");

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");

    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });

    code = code
      .toString()
      .replace(/(?:getAccount\(\s*)(0x.*)(?:\s*\))/g, (_, match) => {
        const accounts = {
          "0x01": Alice,
          "0x02": Bob,
        };
        const name = accounts[match];
        return `getAccount(${name})`;
      });

    await shallResolve(
      executeScript({
        code,
      })
    );
  });

  test("get schema data by Id", async () => {
    const name = "getSchemaById";
    const Bob = await getAccountAddress("Bob");

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");

    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });

    code = code
      .toString()
      .replace(/(?:getAccount\(\s*)(0x.*)(?:\s*\))/g, (_, match) => {
        const accounts = {
          "0x01": Alice,
          "0x02": Bob,
        };
        const name = accounts[match];
        return `getAccount(${name})`;
      });

    const args = [1];
    await shallResolve(
      executeScript({
        code,
        args,
      })
    );
  });

  test("get template data ", async () => {
    const name = "getAllTemplates";
    const Bob = await getAccountAddress("Bob");

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");

    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });

    code = code
      .toString()
      .replace(/(?:getAccount\(\s*)(0x.*)(?:\s*\))/g, (_, match) => {
        const accounts = {
          "0x01": Alice,
          "0x02": Bob,
        };
        const name = accounts[match];
        return `getAccount(${name})`;
      });

    await shallResolve(
      executeScript({
        code,
      })
    );
  });
  test("get template data by Id", async () => {
    const name = "getTemplateById";
    const Bob = await getAccountAddress("Bob");

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");

    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });

    code = code
      .toString()
      .replace(/(?:getAccount\(\s*)(0x.*)(?:\s*\))/g, (_, match) => {
        const accounts = {
          "0x01": Alice,
          "0x02": Bob,
        };
        const name = accounts[match];
        return `getAccount(${name})`;
      });
    const args = [1];
    await shallResolve(
      executeScript({
        code,
        args,
      })
    );
  });

  test("get all nfts  data", async () => {
    const name = "getAllNFTIds";
    const Charlie = await getAccountAddress("Charlie");

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");

    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };

    let code = await getScriptCode({
      name,
      addressMap,
    });

    code = code
      .toString()
      .replace(/(?:getAccount\(\s*)(0x.*)(?:\s*\))/g, (_, match) => {
        const accounts = {
          "0x03": Charlie,
        };
        const name = accounts[match];
        return `getAccount(${name})`;
      });
    const args = [Charlie];
    await shallResolve(
      executeScript({
        code,
        args,
      })
    );
  });

  test("get nft template data", async () => {
    const name = "getNFTTemplateData";
    const Charlie = await getAccountAddress("Charlie");

    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const XGStudio = await getContractAddress("XGStudio");

    const addressMap = {
      NonFungibleToken,
      XGStudio,
    };
    let code = await getScriptCode({
      name,
      addressMap,
    });

    code = code
      .toString()
      .replace(/(?:getAccount\(\s*)(0x.*)(?:\s*\))/g, (_, match) => {
        const accounts = {
          "0x03": Charlie,
        };
        const name = accounts[match];
        return `getAccount(${name})`;
      });

    const args = [Charlie];

    await shallResolve(
      executeScript({
        code,
        args,
      })
    );
  });
});

describe("MetadataViews", () => {
  test("NFTView", async () => {
    // Import participating accounts
    const Bob = await getAccountAddress("Bob");
    const Charlie = await getAccountAddress("Charlie");

    // Set transaction signers
    const signers = [Bob];

    // Generate addressMap from import statements
    const MetadataViews = await getContractAddress("MetadataViews");
    const XGStudio = await getContractAddress("XGStudio");
    const addressMap = {
      MetadataViews,
      XGStudio,
    };

    const [result] = await shallPass(
      sendTransaction({
        name: "mintNFT",
        signers,
        args: [1, Charlie],
        addressMap,
      })
    );

    const nftID = result.events[0].data.nftId;

    const [nftData] = await shallResolve(
      executeScript({
        name: "getNFTView",
        args: [Charlie, nftID],
      })
    );

    expect(nftData).toEqual({
      name: "Second NFT",
      description: "Second NFT for the xgStudio",
      thumbnail: "ipfs://IPFSCID/",
      owner: "0xf3fcd2c1a78f5eee",
      type: "A.179b6b1cb6755e31.XGStudio.NFT",
      royalties: [],  //TODO: setup receivers in target accounts 
      externalURL: "https://xgstudios.io/rewards/2",
      serialNumber: 2,
      collectionPublicPath: {
        domain: "public",
        identifier: "XGStudioCollection",
      },
      collectionStoragePath: {
        domain: "storage",
        identifier: "XGStudioCollection",
      },
      collectionProviderPath: {
        domain: "private",
        identifier: "XGStudioCollectionProvider",
      },
      collectionPublic:
        "&A.179b6b1cb6755e31.XGStudio.Collection{A.179b6b1cb6755e31.XGStudio.XGStudioCollectionPublic}",
      collectionPublicLinkedType:
        "&A.179b6b1cb6755e31.XGStudio.Collection{A.179b6b1cb6755e31.XGStudio.XGStudioCollectionPublic,A.01cf0e2f2f715450.NonFungibleToken.CollectionPublic,A.01cf0e2f2f715450.NonFungibleToken.Receiver,A.01cf0e2f2f715450.MetadataViews.ResolverCollection}",
      collectionProviderLinkedType:
        "&A.179b6b1cb6755e31.XGStudio.Collection{A.179b6b1cb6755e31.XGStudio.XGStudioCollectionPublic,A.01cf0e2f2f715450.NonFungibleToken.CollectionPublic,A.01cf0e2f2f715450.NonFungibleToken.Provider,A.01cf0e2f2f715450.MetadataViews.ResolverCollection}",
      collectionName: "XGStudio",
      collectionDescription:
        "xG® rewards athletes’ real world sports participation with personalised digital collectibles and the xG® utility token.",
      collectionExternalURL: "https://xgstudios.io",
      collectionSquareImage:
        "https://xgstudios.mypinata.cloud/ipfs/QmZP32SFcQ2rN2diEXsnwyFxZ5dmyFhuqAybDRANg2cEsk/XG_MOVE_THUMBNAIL.png",
      collectionBannerImage:
        "https://xgstudios.mypinata.cloud/ipfs/QmZP32SFcQ2rN2diEXsnwyFxZ5dmyFhuqAybDRANg2cEsk/XG_MOVE_COLLECTION_BANNER.png",
      collectionSocials: {
        discord: "https://discord.com/invite/uaYhFARqXM",
        instagram: "https://www.instagram.com/xGStudios_/",
        twitter: "https://twitter.com/xGStudios_",
        tiktok: "https://www.tiktok.com/@xgstudios"
      },
      editions: [{ name: "Second NFT", number: 2, max: 100 }],
      traits: { "traits" : [
                {
                 "displayType": null,
                 "name": "raceName",
                 "rarity": null,
                 "value": "Lion",
               },
                {
                 "displayType": null,
                 "name": "raceDescription",
                 "rarity": null,
                 "value": "Lion race",
               },
                {
                 "displayType": null,
                 "name": "distance",
                 "rarity": null,
                 "value": "2000.00000000",
               },
                {
                 "displayType": null,
                 "name": "gender",
                 "rarity": null,
                 "value": "Male",
               },
                {
                 "displayType": null,
                 "name": "contectUrl",
                 "rarity": null,
                 "value": "https://xgstudios.io",
               },
                {
                 "displayType": null,
                 "name": "raceLocation",
                 "rarity": null,
                 "value": "Mian Essa",
               },
                {
                 "displayType": null,
                 "name": "activityType",
                 "rarity": null,
                 "value": "Running",
               },
                {
                 "displayType": null,
                 "name": "raceDate",
                 "rarity": null,
                 "value": "1649994582.00000000",
               },
                {
                 "displayType": null,
                 "name": "xGRewardType",
                 "rarity": null,
                 "value": "AR",
               },
             ]},
             
      medias: { items: [] },
      license: null,
    });
  });
  test("NFTView for Legacy Template", async () => {
    // Import participating accounts
    const Bob = await getAccountAddress("Bob");
    const Charlie = await getAccountAddress("Charlie");

    // Set transaction signers
    const signers = [Bob];

    // Generate addressMap from import statements
    const MetadataViews = await getContractAddress("MetadataViews");
    const XGStudio = await getContractAddress("XGStudio");
    const NonFungibleToken = await getContractAddress("NonFungibleToken");
    const templateAddressMap = {
      NonFungibleToken,
      XGStudio,
    };
    let schemaCode = await getTransactionCode({
      name: "createLegacySchema",
      addressMap: templateAddressMap,
    });
    await shallPass(
      sendTransaction({
        code: schemaCode,
        signers,
        args: ["Legacy Test Schema"]
      })
    );
    const templateTxName = "createLegacyTemplateStaticData"
    let code = await getTransactionCode({
      name: templateTxName,
      addressMap: templateAddressMap,
    });
    // brandId, schemaId, maxSupply,immutableData
    const args = [1, 2, 100];

    await shallPass(
      sendTransaction({
        code,
        signers,
        args,
      })
    )

    const addressMap = {
      MetadataViews,
      XGStudio,
    };


    const [result] = await shallPass(
      sendTransaction({
        name: "mintNFT",
        signers,
        args: [2, Charlie],
        addressMap,
      })
    );

    const nftID = result.events[0].data.nftId;

    const [nftData] = await shallResolve(
      executeScript({
        name: "getNFTView",
        args: [Charlie, nftID],
      })
    );

    expect(nftData).toEqual({
      name: "Win: Alexandra Park v Hilltop Women",
      description: "Win: The xG Reward for players who made an appearance a win.\n\nGet xG Rewards for your football achievements.\nBuild your collection - your story.\nUnlock xG experiences.\n\nhttps://linktr.ee/xgstudios",
      thumbnail: "ipfs://QmSPFN7uaUaW1H9GsET9HHKudMCLvB5JyFDPxyQ4FoGd5k/WIN.png",
      owner: "0xf3fcd2c1a78f5eee",
      type: "A.179b6b1cb6755e31.XGStudio.NFT",
      royalties:[], //TODO: setup receivers in target accounts
      externalURL: "https://xgstudios.io/rewards/3",
      serialNumber: 3,
      collectionPublicPath: {
        domain: "public",
        identifier: "XGStudioCollection",
      },
      collectionStoragePath: {
        domain: "storage",
        identifier: "XGStudioCollection",
      },
      collectionProviderPath: {
        domain: "private",
        identifier: "XGStudioCollectionProvider",
      },
      collectionPublic:
        "&A.179b6b1cb6755e31.XGStudio.Collection{A.179b6b1cb6755e31.XGStudio.XGStudioCollectionPublic}",
      collectionPublicLinkedType:
        "&A.179b6b1cb6755e31.XGStudio.Collection{A.179b6b1cb6755e31.XGStudio.XGStudioCollectionPublic,A.01cf0e2f2f715450.NonFungibleToken.CollectionPublic,A.01cf0e2f2f715450.NonFungibleToken.Receiver,A.01cf0e2f2f715450.MetadataViews.ResolverCollection}",
      collectionProviderLinkedType:
        "&A.179b6b1cb6755e31.XGStudio.Collection{A.179b6b1cb6755e31.XGStudio.XGStudioCollectionPublic,A.01cf0e2f2f715450.NonFungibleToken.CollectionPublic,A.01cf0e2f2f715450.NonFungibleToken.Provider,A.01cf0e2f2f715450.MetadataViews.ResolverCollection}",
      collectionName: "XGStudio",
      collectionDescription:
        "xG® rewards athletes’ real world sports participation with personalised digital collectibles and the xG® utility token.",
      collectionExternalURL: "https://xgstudios.io",
      collectionSquareImage:
        "https://xgstudios.mypinata.cloud/ipfs/QmZP32SFcQ2rN2diEXsnwyFxZ5dmyFhuqAybDRANg2cEsk/XG_MOVE_THUMBNAIL.png",
      collectionBannerImage:
        "https://xgstudios.mypinata.cloud/ipfs/QmZP32SFcQ2rN2diEXsnwyFxZ5dmyFhuqAybDRANg2cEsk/XG_MOVE_COLLECTION_BANNER.png",
      collectionSocials: {
        discord: "https://discord.com/invite/uaYhFARqXM",
        instagram: "https://www.instagram.com/xGStudios_/",
        twitter: "https://twitter.com/xGStudios_",
        tiktok: "https://www.tiktok.com/@xgstudios"
      },
      editions: [
        { name: "Win: Alexandra Park v Hilltop Women", number: 1, max: 100 },
        { name: "2022/23", number: 1, max: 100 },
      ],
      traits: { "traits":  [
               {
                 "displayType": null,
                 "name": "oppositionTeam",
                 "rarity": null,
                 "value": "Alexandra Park",
               },
               {
                 "displayType": null,
                 "name": "playerTeam",
                 "rarity": null,
                 "value": "Hilltop Women",
               },
               {
                 "displayType": null,
                 "name": "season",
                 "rarity": null,
                 "value": "2022/23",
               },
               {
                 "displayType": null,
                 "name": "fixtureType",
                 "rarity": null,
                 "value": "Division 2 North",
               },
               {
                 "displayType": null,
                 "name": "result",
                 "rarity": null,
                 "value": "W",
               },
               {
                 "displayType": null,
                 "name": "date",
                 "rarity": null,
                 "value": "04/09/2022",
               },
               {
                 "displayType": null,
                 "name": "competition",
                 "rarity": null,
                 "value": "Greater London Women''s Football League",
               },
               {
                 "displayType": null,
                 "name": "activityType",
                 "rarity": null,
                 "value": "Football",
               },
               {
                 "displayType": null,
                 "name": "venue",
                 "rarity": null,
                 "value": "A",
               },
               {
                 "displayType": null,
                 "name": "score",
                 "rarity": null,
                 "value": "0 - 16",
               },
               {
                 "displayType": null,
                 "name": "xGRewardType",
                 "rarity": null,
                 "value": "Win",
               },
             ]},
      medias: { items: [
                {
                  "file":  {
                     "url": "https://xgstudios.io",
                   },
                   "mediaType": "Image",
                 },
              ]},
      license: null,
    });
  });
});
