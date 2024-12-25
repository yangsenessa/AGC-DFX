dfx stop
set -e

dfx identity use univoicerun
GOV_ACCOUNT=$(dfx identity get-principal)

echo "===========SETUP tokens========="
dfx start --background --clean
./minttoken.sh


echo "===========SETUP DONE========="
dfx identity use univoicerun
dfx deploy  univoice-vmc-backend 
dfx deploy  univoice-vmc-frontend
echo "========  MUGC-AGC  ========" 
dfx deploy  mugc-agc-backend 


#echo "==============TOKEN TRANSFER=================="

#dfx canister call  univoice-vmc-backend transfer "(record {
#   amount = 6_500_000_000;
#   to_account = record {
#   owner = principal \"principal \"$ADMIN_PRINCIPAL\";  };
#})"
./init-env.sh

echo "===========TESTING query balance inner========"
dfx canister call univoice-vmc-backend query_poll_balance --network local

echo "=========subscribe=================="
dfx canister call univoice-vmc-backend setup_subscribe "(
     principal \"bw4dl-smaaa-aaaaa-qaacq-cai\",
     \"0301008\"
)"

echo "=========TESTING record_work_load========"
dfx canister call mugc-agc-backend push_workload_record "(
    record {
      promt_id = \"086daeb4-3795-486a-8d20-725866f4ded9\";
      client_id = \"1982027079\";
      ai_node = \"http://127.0.0.1:8188/prompt\";
      app_info = \"muse_talk\";
      wk_id = \"univoice-wk-local.json\";
      voice_key = \"2f4018e2-ed5e-4821-97ba-4873b431586f/tmp/tmprh7jbr_7.wav\";
      deduce_asset_key = \"AIGC_output_video_final_00116.mp4\";
      status = \"executed\" ;
      gmt_datatime=1731837234   
    })"



#echo "==========query_curr_workload======="
#dfx canister call mugc-agc-backend query_curr_workload

echo "===========icrc2_claim_query ========="
dfx canister call univoice-vmc-backend get_all_miner_jnl



#echo "===========icrc2_claim ... ========="

#echo "============balance-admin ========="
#dfx canister call icrc1_ledger_canister icrc1_balance_of "(record {
#  owner = principal \"$ADMIN_PRINCIPAL\";
#})"
#echo "============canister balance before====================="
#dfx canister call icrc1_ledger_canister icrc1_balance_of "(record {
#  owner = principal \"$(dfx canister id univoice-vmc-backend)\"
#})"

echo "============ claim index {1} {2}"
dfx canister call  univoice-vmc-backend claim_to_account_from_index "(1)"

dfx canister call  univoice-vmc-backend claim_to_account_from_index "(2)"

dfx canister call  univoice-vmc-backend claim_to_account_from_index "(3)"



echo "============balance-end ========="
dfx canister call voice_ledger_canister icrc1_balance_of "(record {
  owner = principal \"$GOV_ACCOUNT\";
})"
echo "============canister balance====================="
dfx canister call voice_ledger_canister icrc1_balance_of "(record {
  owner = principal \"$(dfx canister id univoice-vmc-backend)\"
})"


echo "===========icrc2_claim_query after claimed ========="
dfx canister call univoice-vmc-backend get_all_miner_jnl








