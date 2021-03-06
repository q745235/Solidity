/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { PayUsdt, PayUsdtInterface } from "../PayUsdt";

const _abi = [
  {
    inputs: [],
    name: "usdtContract",
    outputs: [
      {
        internalType: "contract IERC20",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

export class PayUsdt__factory {
  static readonly abi = _abi;
  static createInterface(): PayUsdtInterface {
    return new utils.Interface(_abi) as PayUsdtInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): PayUsdt {
    return new Contract(address, _abi, signerOrProvider) as PayUsdt;
  }
}
