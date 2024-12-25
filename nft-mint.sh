cd icrc_nft.mo

dfx stop
set -e
echo "===========SETUP tokens========="
dfx start --background --clean

echo  "========DEPLOY NFT=========="

dfx identity use alice
ALICE_PRINCIPAL=$(dfx identity get-principal)

dfx identity use bob
BOB_PRINCIPAL=$(dfx identity get-principal)


dfx identity use univoicerun
ADMIN_PRINCIPAL=$(dfx identity get-principal)

echo "========deplying=========="
dfx deploy icrc7 --argument 'record {icrc7_args = null; icrc37_args =null; icrc3_args =null;}' --network=local --mode reinstall
ICRC7_CANISTER=$(dfx canister id icrc7)
echo $ICRC7_CANISTER

dfx canister call icrc7 init


dfx canister call icrc7 icrcX_mint --argument-file '../nftscript.did'


#All tokens should be owned by the canister
echo "All tokens should be owned by the canister"
dfx canister call icrc7 icrc7_tokens_of "(record { owner = principal \"$ICRC7_CANISTER\"; subaccount = null;},null,null)"

#Should be approved to transfer
echo "Should be approved to transfer"
dfx canister call icrc7 icrc37_is_approved "(vec{record { spender=record {owner = principal \"$ADMIN_PRINCIPAL\"; subaccount = null;}; from_subaccount=null; token_id=0;}})" --query


#Check that the owner is spender
echo "Check that the owner is spender"
dfx canister call icrc7 icrc37_get_collection_approvals "(record { owner = principal \"$ICRC7_CANISTER\"; subaccount = null;},null, null)" --query

#tranfer from a token to the admin
echo "tranfer from a token to the admin"
dfx canister call icrc7 icrc37_transfer_from "(vec{record { 
  spender = principal \"$ADMIN_PRINCIPAL\";
  from = record { owner = principal \"$ICRC7_CANISTER\"; subaccount = null}; 
  to = record { owner = principal \"$ALICE_PRINCIPAL\"; subaccount = null};
  token_id =  0 : nat;
  memo = null;
  created_at_time = null;}})"

dfx canister call icrc7 icrc37_transfer_from "(vec{record { 
  spender = principal \"$ADMIN_PRINCIPAL\";
  from = record { owner = principal \"$ICRC7_CANISTER\"; subaccount = null}; 
  to = record { owner = principal \"mavpv-uegot-nsxdf-buehx-6ra72-itrat-tc5ox-m6evr-kqxmy-khd4t-rqe\"; subaccount = null};
  token_id =  2 : nat;
  memo = null;
  created_at_time = null;}})"

dfx canister call icrc7 icrc37_transfer_from "(vec{record { 
  spender = principal \"$ADMIN_PRINCIPAL\";
  from = record { owner = principal \"$ICRC7_CANISTER\"; subaccount = null}; 
  to = record { owner = principal \"$BOB_PRINCIPAL\"; subaccount = null};
  token_id =  3 : nat;
  memo = null;
  created_at_time = null;}})"

  # Admin should own two tokens
echo "Admin should own two tokens"

dfx canister call icrc7 icrc7_tokens_of "(record { owner = principal \"$ADMIN_PRINCIPAL\"; subaccount = null}, null, null)" --query

echo "List owner of all tokens"
# List owner of all tokens
dfx canister call icrc7 icrc7_owner_of '(vec {0;1;2;3})' --query

cd ..
