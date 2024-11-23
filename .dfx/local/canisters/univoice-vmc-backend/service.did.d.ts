import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Account {
  'owner' : Principal,
  'subaccount' : [] | [Uint8Array | number[]],
}
export type BlockIndex = bigint;
export interface ComfyUIPayload {
  'status' : string,
  'voice_key' : string,
  'gmt_datatime' : Timestamp,
  'app_info' : string,
  'ai_node' : string,
  'client_id' : string,
  'wk_id' : string,
  'deduce_asset_key' : string,
  'promt_id' : string,
}
export interface Event0301008 {
  'topic' : string,
  'payload' : WorkLoadLedgerItem,
}
export type MinerTxState = { 'Claimed' : string } |
  { 'Prepared' : string };
export type NumTokens = bigint;
export type Result = { 'Ok' : bigint } |
  { 'Err' : string };
export interface Subscriber { 'topic' : string }
export type Timestamp = bigint;
export interface TransferArgs { 'to_account' : Account, 'amount' : bigint }
export interface WorkLoadLedgerItem {
  'mining_status' : MinerTxState,
  'work_load' : ComfyUIPayload,
  'block_tokens' : NumTokens,
  'wkload_id' : BlockIndex,
}
export interface _SERVICE {
  'greet' : ActorMethod<[string], string>,
  'publish_0301008' : ActorMethod<[Event0301008], Result>,
  'query_poll_balance' : ActorMethod<[], Result>,
  'setup_subscribe' : ActorMethod<[Principal, string], undefined>,
  'transfer' : ActorMethod<[TransferArgs], Result>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
