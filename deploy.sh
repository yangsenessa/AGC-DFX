dfx stop
set -e

echo "===========SETUP tokens========="
dfx start --background --clean
dfx identity use minter
MINT_ACCOUNT=$(dfx identity get-principal)
dfx identity use univoicetest
GOV_ACCOUNT=$(dfx identity get-principal)

echo "===========Prepared Univoice Tokens===================="
dfx deploy icrc1_ledger_canister --argument "(variant {
  Init = record {
    token_symbol = \"$VOICE\";
    token_name = \"VOICE\";
    minting_account = record {
      owner = principal \"$MINT_ACCOUNT\"
    };
    transfer_fee = 10;
    metadata = vec {};
    initial_balances = vec {
      record {
        record {
          owner = principal \"$GOV_ACCOUNT\";
        };
        2_100_000_000_000_000;
      };
    };
    archive_options = record {
      num_blocks_to_archive = 1000;
      trigger_threshold = 2000;
      controller_id = principal \"$GOV_ACCOUNT\";
    };
    feature_flags = opt record {
      icrc2 = true;
    };
  }
})"

dfx deploy icrc1_index_canister --argument '(opt variant { Init = record { ledger_id = principal "bkyz2-fmaaa-aaaaa-qaaaq-cai"} })'

echo "===========balance of GOV_ACCOUNT========="
dfx canister call icrc1_ledger_canister icrc1_balance_of "(record {
  owner = principal \"$GOV_ACCOUNT\";
})"

echo "===========SETUP DONE========="
dfx deploy  univoice-vmc-backend 
dfx deploy  univoice-vmc-frontend
echo "========  MUGC-AGC  ========" 
dfx identity use univoicetest
dfx deploy  mugc-agc-backend 

# approve the token_transfer_from_backend canister to spend 100 tokens
echo "===========icrc2_approve========="

dfx canister call  icrc1_ledger_canister icrc2_approve "(
  record {
    spender= record {
      owner = principal \"$(dfx canister id univoice-vmc-backend)\";
   };
    amount = 1_365_000_000_000_000: nat;
  }
)"
echo "===========icrc2_approve_end========="

echo "===========balance approve==========="

dfx canister call icrc1_ledger_canister icrc1_balance_of "(record {
  owner = principal \"$(dfx canister id univoice-vmc-backend)\"
})"




echo "========update contract======"
dfx canister call mugc-agc-backend update_minting_contract "(
   record {
      poll_account=\"6nimk-xpves-34bk3-zf7dp-nykqv-h3ady-iu3ze-xplot-vm4uy-ptbel-3qe\";
      nft_collection_id=\"bkyz2-fmaaa-aaaaa-qaaaq-cai\";
      token_block=2_625_000
   }
)"




echo  "========DEPLOY NFT=========="
cd icrc_nft.mo
dfx identity use alice
ALICE_PRINCIPAL=$(dfx identity get-principal)

dfx identity use bob
BOB_PRINCIPAL=$(dfx identity get-principal)


dfx identity use univoicetest
ADMIN_PRINCIPAL=$(dfx identity get-principal)

dfx deploy icrc7 --argument 'record {icrc7_args = null; icrc37_args =null; icrc3_args =null;}' --mode reinstall
ICRC7_CANISTER=$(dfx canister id icrc7)
echo $ICRC7_CANISTER

dfx canister call icrc7 init


dfx canister call icrc7 icrcX_mint "(
  vec {
    record {
      token_id = 0 : nat;
      owner = opt record { owner = principal \"$ICRC7_CANISTER\"; subaccount = null;};
      metadata = variant {
        Map = vec {
          record { \"icrc97:metadata\"; variant { Map = vec {
            record { \"name\"; variant { Text = \"Image 1\" } };
            record { \"description\"; variant { Text = \"A beautiful space image from NASA.\" } };
            record { \"assets\"; variant { Array = vec {
              variant { Map = vec {
                record { \"url\"; variant { Text = \"https://images-assets.nasa.gov/image/PIA18249/PIA18249~orig.jpg\" } };
                record { \"mime\"; variant { Text = \"image/jpeg\" } };
                record { \"purpose\"; variant { Text = \"icrc97:image\" } }
              }}
            }}}
          }}}
        }
      };
      memo = opt blob \"\00\01\";
      override = true;
      created_at_time = null;
    };
    record {
      token_id = 1 : nat;
      owner = opt record { owner = principal \"$ICRC7_CANISTER\"; subaccount = null;};
      metadata = variant {
        Map = vec {
          record { \"icrc97:metadata\"; variant { Map = vec {
            record { \"name\"; variant { Text = \"Image 2\" }};
            record { \"description\"; variant { Text = \"Another stunning NASA image.\" } };
            record { \"assets\"; variant { Array = vec {
              variant { Map = vec {
                record { \"url\"; variant { Text = \"https://images-assets.nasa.gov/image/GSFC_20171208_Archive_e001465/GSFC_20171208_Archive_e001465~orig.jpg\" } };
                record { \"mime\"; variant { Text = \"image/jpeg\" } };
                record { \"purpose\"; variant { Text = \"icrc97:image\" } }
              }}
            }}}
          }}}
        }
      };
      memo = opt blob \"\00\01\";
      override = true;
      created_at_time = null;
    };
    record {
      token_id = 2 : nat;
      owner = opt record { owner = principal \"$ICRC7_CANISTER\"; subaccount = null;};
      metadata = variant {
        Map = vec {
          record { \"icrc97:metadata\"; variant { Map = vec {
            record { \"name\"; variant { Text = \"Image 3\" } };
            record { \"description\"; variant { Text = \"Hubble sees the wings of a butterfly.\" } };
            record { \"assets\"; variant { Array = vec {
              variant { Map = vec {
                record { \"url\"; variant { Text = \"https://images-assets.nasa.gov/image/hubble-sees-the-wings-of-a-butterfly-the-twin-jet-nebula_20283986193_o/hubble-sees-the-wings-of-a-butterfly-the-twin-jet-nebula_20283986193_o~orig.jpg\" } };
                record { \"mime\"; variant { Text = \"image/jpeg\" } };
                record { \"purpose\"; variant { Text = \"icrc97:image\" } }
              }}
            }}}
          }}}
        }
      };
      memo = opt blob \"\00\01\";
      override = true;
      created_at_time = null;
    };
    record {
      token_id = 3 : nat;
      owner = opt record { owner = principal \"$ICRC7_CANISTER\"; subaccount = null;};
      metadata = variant {
        Map = vec {
          record { \"icrc97:metadata\"; variant { Map = vec {
            record { \"name\"; variant { Text = \"Image 4\" } };
            record { \"description\"; variant { Text = \"Another beautiful image from NASA archives.\" } };
            record { \"assets\"; variant { Array = vec {
              variant { Map = vec {
                record { \"url\"; variant { Text = \"https://images-assets.nasa.gov/image/GSFC_20171208_Archive_e001518/GSFC_20171208_Archive_e001518~orig.jpg\" } };
                record { \"mime\"; variant { Text = \"image/jpeg\" } };
                record { \"purpose\"; variant { Text = \"icrc97:image\" } }
              }}
            }}}
          }}}
        }
      };
      memo = opt blob \"\00\01\";
      override = true;
      created_at_time = null;
    };
  }
)"


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

#echo "==============TOKEN TRANSFER=================="

#dfx canister call  univoice-vmc-backend transfer "(record {
#   amount = 6_500_000_000;
#   to_account = record {
#   owner = principal \"principal \"$ADMIN_PRINCIPAL\";  };
#})"

echo "===========query balance inner========"
dfx canister call univoice-vmc-backend query_poll_balance --network local

echo "=========subscribe=================="
dfx canister call univoice-vmc-backend setup_subscribe "(
     principal \"bw4dl-smaaa-aaaaa-qaacq-cai\",
     \"0301008\"
)"

echo "=========record_work_load========"
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
dfx canister call icrc1_ledger_canister icrc1_balance_of "(record {
  owner = principal \"$ADMIN_PRINCIPAL\";
})"
echo "============canister balance====================="
dfx canister call icrc1_ledger_canister icrc1_balance_of "(record {
  owner = principal \"$(dfx canister id univoice-vmc-backend)\"
})"


echo "===========icrc2_claim_query after claimed ========="
dfx canister call univoice-vmc-backend get_all_miner_jnl








