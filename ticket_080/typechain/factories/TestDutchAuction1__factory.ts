/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type {
  TestDutchAuction1,
  TestDutchAuction1Interface,
} from "../TestDutchAuction1";

const _abi = [
  {
    inputs: [],
    name: "getPrice",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "startTime",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "endTime",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "startPrice",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "endPrice",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "interval",
        type: "uint256",
      },
    ],
    name: "newSale",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b50610618806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c806398d5fdca1461003b578063a1f7060714610055575b600080fd5b61004361006a565b60405190815260200160405180910390f35b610068610063366004610523565b61007b565b005b60006100766000610091565b905090565b61008a60008287868887610149565b5050505050565b60006001600983015460ff1660028111156100ae576100ae61055e565b14156100c3576100bd82610359565b92915050565b6002600983015460ff1660028111156100de576100de61055e565b14156100f0576100bd82600501610468565b60405162461bcd60e51b8152602060048201526024808201527f447574636841756374696f6e3a2074686520636f6e666967206d757374206265604482015263081cd95d60e21b60648201526084015b60405180910390fd5b6000600987015460ff1660028111156101645761016461055e565b146101bf5760405162461bcd60e51b815260206004820152602560248201527f447574636841756374696f6e3a2074686520636f6e66696720686173206265656044820152641b881cd95d60da1b6064820152608401610140565b8461021d5760405162461bcd60e51b815260206004820152602860248201527f447574636841756374696f6e3a2074686520696e74657276616c206d7573742060448201526706265206e6f7420360c41b6064820152608401610140565b83821161028a5760405162461bcd60e51b815260206004820152603560248201527f447574636841756374696f6e3a2074686520656e6454696d65206d757374206260448201527465206f766572207468616e20737461727454696d6560581b6064820152608401610140565b8083116102ff5760405162461bcd60e51b815260206004820152603760248201527f447574636841756374696f6e3a207468652073746172745072696365206d757360448201527f74206265206f766572207468616e20656e6450726963650000000000000000006064820152608401610140565b6040805160a08101825286815260208101869052908101849052606081018390526080018190529385556001808601939093556002850191909155600384015560048301919091556009909101805460ff19169091179055565b6000428260010154111561036f57506002015490565b816003015442111561038357506004015490565b600082600101548360030154610399919061058a565b90506000836004015484600201546103b1919061058a565b905060008460010154426103c5919061058a565b905060006103d384846105a1565b90506000670de0b6b3a76400008760000154836103f091906105c3565b6103fa91906105a1565b875490915060009061041485670de0b6b3a76400006105c3565b61041e91906105a1565b905061042a82826105c3565b8860020154111561045a5761043f82826105c3565b886002015461044e919061058a565b98975050505050505050565b506000979650505050505050565b6000428260010154111561047e57506002015490565b6000826001015442610490919061058a565b83549091506000906104aa83670de0b6b3a76400006105c3565b6104b491906105a1565b90506000670de0b6b3a7640000856000015486600301546104d591906105c3565b6104df91906105a1565b90506104eb81836105c3565b856002015411156105185761050081836105c3565b856002015461050f919061058a565b95945050505050565b506000949350505050565b600080600080600060a0868803121561053b57600080fd5b505083359560208501359550604085013594606081013594506080013592509050565b634e487b7160e01b600052602160045260246000fd5b634e487b7160e01b600052601160045260246000fd5b60008282101561059c5761059c610574565b500390565b6000826105be57634e487b7160e01b600052601260045260246000fd5b500490565b60008160001904831182151516156105dd576105dd610574565b50029056fea264697066735822122005c58a0876db318aee6995094775c000fa82c57e994c64970358fcc072c7b35364736f6c634300080c0033";

export class TestDutchAuction1__factory extends ContractFactory {
  constructor(
    ...args: [signer: Signer] | ConstructorParameters<typeof ContractFactory>
  ) {
    if (args.length === 1) {
      super(_abi, _bytecode, args[0]);
    } else {
      super(...args);
    }
  }

  deploy(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<TestDutchAuction1> {
    return super.deploy(overrides || {}) as Promise<TestDutchAuction1>;
  }
  getDeployTransaction(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  attach(address: string): TestDutchAuction1 {
    return super.attach(address) as TestDutchAuction1;
  }
  connect(signer: Signer): TestDutchAuction1__factory {
    return super.connect(signer) as TestDutchAuction1__factory;
  }
  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): TestDutchAuction1Interface {
    return new utils.Interface(_abi) as TestDutchAuction1Interface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): TestDutchAuction1 {
    return new Contract(address, _abi, signerOrProvider) as TestDutchAuction1;
  }
}
