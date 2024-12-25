export const idlFactory = ({ IDL }) => {
  const NftUnivoicePricipal = IDL.Record({ 'owners' : IDL.Vec(IDL.Text) });
  const Result = IDL.Variant({ 'Ok' : IDL.Nat, 'Err' : IDL.Text });
  const BlockIndex = IDL.Nat;
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
  const WorkLoadLedgerItem = IDL.Record({
    'mining_status' : MinerTxState,
    'work_load' : ComfyUIPayload,
    'block_tokens' : NumTokens,
    'nft_pool' : IDL.Text,
    'token_pool' : IDL.Text,
    'wkload_id' : BlockIndex,
  });
  const Account = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(IDL.Vec(IDL.Nat8)),
  });
  const TxIndex = IDL.Nat;
  const TransferTxState = IDL.Variant({
    'Claimed' : IDL.Null,
    'WaitClaim' : IDL.Null,
  });
  const UnvMinnerLedgerRecord = IDL.Record({
    'block_index' : IDL.Opt(BlockIndex),
    'meta_workload' : WorkLoadLedgerItem,
    'minner' : Account,
    'trans_tx_index' : IDL.Opt(TxIndex),
    'biz_state' : TransferTxState,
    'tokens' : NumTokens,
    'gmt_datetime' : Timestamp,
  });
  const Event0301008 = IDL.Record({
    'topic' : IDL.Text,
    'payload' : WorkLoadLedgerItem,
  });
  const UserIdentityInfo = IDL.Record({
    'user_nick' : IDL.Text,
    'user_id' : IDL.Text,
    'principalid_txt' : IDL.Text,
  });
  const TransferArgs = IDL.Record({
    'to_account' : Account,
    'amount' : IDL.Nat,
  });
  return IDL.Service({
    'call_unvoice_for_ext_nft' : IDL.Func([NftUnivoicePricipal], [Result], []),
    'claim_to_account_from_index' : IDL.Func([BlockIndex], [Result], []),
    'get_all_miner_jnl' : IDL.Func(
        [],
        [IDL.Opt(IDL.Vec(UnvMinnerLedgerRecord))],
        ['query'],
      ),
    'greet' : IDL.Func([IDL.Text], [IDL.Text], ['query']),
    'publish_0301008' : IDL.Func([Event0301008], [Result], []),
    'query_poll_balance' : IDL.Func([], [Result], []),
    'setup_subscribe' : IDL.Func([IDL.Principal, IDL.Text], [], []),
    'sync_userinfo_identity' : IDL.Func(
        [IDL.Vec(UserIdentityInfo)],
        [Result],
        [],
      ),
    'transfer' : IDL.Func([TransferArgs], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
