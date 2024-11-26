export const idlFactory = ({ IDL }) => {
  const WorkLoadInitParam = IDL.Record({
    'token_block' : IDL.Nat,
    'poll_account' : IDL.Text,
    'nft_collection_id' : IDL.Text,
  });
  const ComfyUINode = IDL.Record({
    'weight' : IDL.Int,
    'ws_url' : IDL.Text,
    'node_id' : IDL.Opt(IDL.Nat),
    'ori_url' : IDL.Text,
  });
  const Timestamp = IDL.Nat64;
  const ComfyUIPayload = IDL.Record({
    'status' : IDL.Text,
    'voice_key' : IDL.Text,
    'gmt_datatime' : Timestamp,
    'app_info' : IDL.Text,
    'ai_node' : IDL.Text,
    'client_id' : IDL.Text,
    'wk_id' : IDL.Text,
    'deduce_asset_key' : IDL.Text,
    'promt_id' : IDL.Text,
  });
  const MinerTxState = IDL.Variant({
    'Claimed' : IDL.Text,
    'Prepared' : IDL.Text,
  });
  const NumTokens = IDL.Nat;
  const BlockIndex = IDL.Nat;
  const WorkLoadLedgerItem = IDL.Record({
    'mining_status' : MinerTxState,
    'work_load' : ComfyUIPayload,
    'block_tokens' : NumTokens,
    'nft_pool' : IDL.Text,
    'token_pool' : IDL.Text,
    'wkload_id' : BlockIndex,
  });
  const MixComfyErr = IDL.Variant({
    'RuntimeErr' : IDL.Text,
    'NoneNodeVaild' : IDL.Text,
  });
  const WorkLoadReceipt = IDL.Variant({
    'Ok' : WorkLoadLedgerItem,
    'Err' : MixComfyErr,
  });
  const Result = IDL.Variant({ 'Ok' : IDL.Nat, 'Err' : IDL.Text });
  const Subscriber = IDL.Record({ 'topic' : IDL.Text });
  const Account = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(IDL.Vec(IDL.Nat8)),
  });
  const TransferArgs = IDL.Record({
    'to_account' : Account,
    'amount' : IDL.Nat,
  });
  return IDL.Service({
    'export_minting_contract' : IDL.Func([], [IDL.Opt(WorkLoadInitParam)], []),
    'gen_ai_node_router' : IDL.Func([], [IDL.Opt(ComfyUINode)], []),
    'greet' : IDL.Func([IDL.Text], [IDL.Text], ['query']),
    'push_workload_record' : IDL.Func([ComfyUIPayload], [WorkLoadReceipt], []),
    'query_comfy_nodes' : IDL.Func([], [IDL.Opt(IDL.Vec(ComfyUINode))], []),
    'query_curr_workload' : IDL.Func(
        [],
        [IDL.Opt(IDL.Vec(WorkLoadLedgerItem))],
        [],
      ),
    'query_poll_balance' : IDL.Func([], [Result], ['query']),
    'reg_comfy_nodes' : IDL.Func(
        [IDL.Vec(ComfyUINode)],
        [IDL.Opt(IDL.Vec(ComfyUINode))],
        [],
      ),
    'subscribe' : IDL.Func([Subscriber], [], []),
    'transfer' : IDL.Func([TransferArgs], [Result], []),
    'update_minting_contract' : IDL.Func(
        [WorkLoadInitParam],
        [IDL.Opt(WorkLoadInitParam)],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
