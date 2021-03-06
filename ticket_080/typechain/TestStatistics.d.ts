/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import {
  ethers,
  EventFilter,
  Signer,
  BigNumber,
  BigNumberish,
  PopulatedTransaction,
  BaseContract,
  ContractTransaction,
  Overrides,
  CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type { TypedEventFilter, TypedEvent, TypedListener } from "./common";

interface TestStatisticsInterface extends ethers.utils.Interface {
  functions: {
    "addAmount(string,uint256)": FunctionFragment;
    "getAmount(string)": FunctionFragment;
    "getItems()": FunctionFragment;
    "getLength()": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "addAmount",
    values: [string, BigNumberish]
  ): string;
  encodeFunctionData(functionFragment: "getAmount", values: [string]): string;
  encodeFunctionData(functionFragment: "getItems", values?: undefined): string;
  encodeFunctionData(functionFragment: "getLength", values?: undefined): string;

  decodeFunctionResult(functionFragment: "addAmount", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "getAmount", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "getItems", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "getLength", data: BytesLike): Result;

  events: {};
}

export class TestStatistics extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  listeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter?: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): Array<TypedListener<EventArgsArray, EventArgsObject>>;
  off<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  on<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  once<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeListener<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeAllListeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): this;

  listeners(eventName?: string): Array<Listener>;
  off(eventName: string, listener: Listener): this;
  on(eventName: string, listener: Listener): this;
  once(eventName: string, listener: Listener): this;
  removeListener(eventName: string, listener: Listener): this;
  removeAllListeners(eventName?: string): this;

  queryFilter<EventArgsArray extends Array<any>, EventArgsObject>(
    event: TypedEventFilter<EventArgsArray, EventArgsObject>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEvent<EventArgsArray & EventArgsObject>>>;

  interface: TestStatisticsInterface;

  functions: {
    addAmount(
      itemName: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    getAmount(
      itemName: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getItems(overrides?: CallOverrides): Promise<[string[]]>;

    getLength(overrides?: CallOverrides): Promise<[BigNumber]>;
  };

  addAmount(
    itemName: string,
    amount: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  getAmount(itemName: string, overrides?: CallOverrides): Promise<BigNumber>;

  getItems(overrides?: CallOverrides): Promise<string[]>;

  getLength(overrides?: CallOverrides): Promise<BigNumber>;

  callStatic: {
    addAmount(
      itemName: string,
      amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<void>;

    getAmount(itemName: string, overrides?: CallOverrides): Promise<BigNumber>;

    getItems(overrides?: CallOverrides): Promise<string[]>;

    getLength(overrides?: CallOverrides): Promise<BigNumber>;
  };

  filters: {};

  estimateGas: {
    addAmount(
      itemName: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    getAmount(itemName: string, overrides?: CallOverrides): Promise<BigNumber>;

    getItems(overrides?: CallOverrides): Promise<BigNumber>;

    getLength(overrides?: CallOverrides): Promise<BigNumber>;
  };

  populateTransaction: {
    addAmount(
      itemName: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    getAmount(
      itemName: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getItems(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    getLength(overrides?: CallOverrides): Promise<PopulatedTransaction>;
  };
}
