import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface AGIAssetresult { 'res_code' : string, 'res_message' : string }
export interface AGIWkFlowNode { 'wk_flow' : string, 'agi_id' : string }
export interface Account {
  'owner' : Principal,
  'subaccount' : [] | [Uint8Array | number[]],
}
export type BlockIndex = bigint;
export interface ComfyUINode {
  'weight' : bigint,
  'ws_url' : string,
  'node_id' : [] | [bigint],
  'ori_url' : string,
}
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
export type MinerTxState = { 'Claimed' : string } |
  { 'Prepared' : string };
export type MixComfyErr = { 'RuntimeErr' : string } |
  { 'NoneNodeVaild' : string };
export type NumTokens = bigint;
export type Result = { 'Ok' : bigint } |
  { 'Err' : string };
export interface Subscriber { 'topic' : string }
export type Timestamp = bigint;
export interface TransferArgs { 'to_account' : Account, 'amount' : bigint }
export interface WorkLoadInitParam {
  'token_block' : bigint,
  'poll_account' : string,
  'nft_collection_id' : string,
}
export interface WorkLoadLedgerItem {
  'mining_status' : MinerTxState,
  'work_load' : ComfyUIPayload,
  'block_tokens' : NumTokens,
  'nft_pool' : string,
  'token_pool' : string,
  'wkload_id' : BlockIndex,
}
export type WorkLoadReceipt = { 'Ok' : WorkLoadLedgerItem } |
  { 'Err' : MixComfyErr };
export interface _SERVICE {
  'export_minting_contract' : ActorMethod<[], [] | [WorkLoadInitParam]>,
  'gen_ai_node_router' : ActorMethod<[], [] | [ComfyUINode]>,
  'greet' : ActorMethod<[string], string>,
  'push_workload_record' : ActorMethod<[ComfyUIPayload], WorkLoadReceipt>,
  'query_comfy_nodes' : ActorMethod<[], [] | [Array<ComfyUINode>]>,
  'query_curr_workload' : ActorMethod<[], [] | [Array<WorkLoadLedgerItem>]>,
  'query_poll_balance' : ActorMethod<[], Result>,
  'reg_comfy_nodes' : ActorMethod<
    [Array<ComfyUINode>],
    [] | [Array<ComfyUINode>]
  >,
  'subscribe' : ActorMethod<[Subscriber], undefined>,
  'transfer' : ActorMethod<[TransferArgs], Result>,
  'update_minting_contract' : ActorMethod<
    [WorkLoadInitParam],
    [] | [WorkLoadInitParam]
  >,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
