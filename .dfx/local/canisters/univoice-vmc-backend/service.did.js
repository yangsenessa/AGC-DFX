export const idlFactory = ({ IDL }) => {
  const MinerTxState = IDL.Variant({
    'Claimed' : IDL.Text,
    'Prepared' : IDL.Text,
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
  const NumTokens = IDL.Nat;
  const BlockIndex = IDL.Nat;
  const WorkLoadLedgerItem = IDL.Record({
    'mining_status' : MinerTxState,
    'work_load' : ComfyUIPayload,
    'block_tokens' : NumTokens,
    'wkload_id' : BlockIndex,
  });
  const Event0301008 = IDL.Record({
    'topic' : IDL.Text,
    'payload' : WorkLoadLedgerItem,
  });
  const Result = IDL.Variant({ 'Ok' : IDL.Nat, 'Err' : IDL.Text });
  const Account = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(IDL.Vec(IDL.Nat8)),
  });
  const TransferArgs = IDL.Record({
    'to_account' : Account,
    'amount' : IDL.Nat,
  });
  return IDL.Service({
    'greet' : IDL.Func([IDL.Text], [IDL.Text], ['query']),
    'publish_0301008' : IDL.Func([Event0301008], [Result], []),
    'query_poll_balance' : IDL.Func([], [Result], ['query']),
    'setup_subscribe' : IDL.Func([IDL.Principal, IDL.Text], [], []),
    'transfer' : IDL.Func([TransferArgs], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
